package core.hud.components.map
{
   import core.hud.components.ButtonExpandableHud;
   import core.hud.components.pvp.DominationManager;
   import core.player.Player;
   import core.scene.Game;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import textures.ITextureManager;
   import textures.TextureLocator;
   
   public class Map extends Sprite
   {
      
      public static var SCALE:Number = 0.1;
      
      public static var WIDTH:Number = 698;
      
      public static var HEIGHT:Number = 538;
      
      public static var CORNER:Number = 10;
      
      public static var PADDING:Number = 31;
       
      
      public var clearedFraction:Number = 0;
      
      private var mapBgr:Image;
      
      private var mapContainer:Sprite;
      
      private var mapPlayers:Vector.<MapPlayer>;
      
      private var mapBodies:Vector.<MapBodyBase>;
      
      private var mapSpawners:Vector.<MapSpawner>;
      
      private var mapBosses:Vector.<MapBoss>;
      
      private var mapDeathLines:Vector.<MapDeathLine>;
      
      private var mapLastKilled:MapKilled;
      
      private var pvpZones:Vector.<MapPvpZone>;
      
      private var closeButton:ButtonExpandableHud;
      
      private var g:Game;
      
      public function Map(param1:Game)
      {
         mapContainer = new Sprite();
         mapPlayers = new Vector.<MapPlayer>();
         mapBodies = new Vector.<MapBodyBase>();
         mapSpawners = new Vector.<MapSpawner>();
         mapBosses = new Vector.<MapBoss>();
         mapDeathLines = new Vector.<MapDeathLine>();
         pvpZones = new Vector.<MapPvpZone>();
         this.g = param1;
         super();
      }
      
      public function load(param1:Number = 0.1, param2:Number = 2200, param3:Number = 1200, param4:Number = 31, param5:Number = 10, param6:Boolean = false) : void
      {
         var scale:Number = param1;
         var width:Number = param2;
         var height:Number = param3;
         var padding:Number = param4;
         var corner:Number = param5;
         var pvpMode:Boolean = param6;
         g.hud.hideMapHint();
         var textureManager:ITextureManager = TextureLocator.getService();
         if(pvpMode)
         {
            mapBgr = new Image(textureManager.getTextureGUIByTextureName("hud_radar_pvp.png"));
            mapBgr.y = -8;
            addChild(mapBgr);
         }
         var q:Quad = new Quad(10000,10000,0);
         q.x = -4269;
         q.y = -4269;
         q.alpha = 0.69;
         q.touchable = false;
         addChild(q);
         addChild(mapContainer);
         var maxRadius:Number = 200;
         SCALE = scale;
         WIDTH = width;
         HEIGHT = height;
         PADDING = padding;
         CORNER = corner;
         for each(b in g.bodyManager.bodies)
         {
            if(b.type != "comet" && b.course.orbitRadius * SCALE > maxRadius)
            {
               SCALE = maxRadius / b.course.orbitRadius;
            }
         }
         for each(var b2 in g.bodyManager.bodies)
         {
            switch(b2.type)
            {
               case "sun":
                  var mapSun:MapSun = new MapSun(g,mapContainer,b2);
                  mapBodies.push(mapSun);
                  break;
               case "warning":
                  var mapElite:MapEliteArea = new MapEliteArea(g,mapContainer,b2);
                  mapBodies.push(mapElite);
                  break;
               case "hidden":
                  var mapHidden:MapHidden = new MapHidden(g,mapContainer,b2);
                  mapBodies.push(mapHidden);
                  break;
            }
         }
         for each(b2 in g.bodyManager.bodies)
         {
            if(b2.type != "comet")
            {
               if(b2.type == "paintShop" || b2.type == "warpGate" || b2.type == "research" || b2.type == "shop" || b2.type == "junk yard" || b2.type == "hangar" || b2.type == "cantina")
               {
                  var mapStation:MapStation = new MapStation(g,mapContainer,b2);
                  mapStation.selected = g.hud.compas.hasTarget(b2);
                  mapBodies.push(mapStation);
               }
            }
         }
         for each(var boss in g.bossManager.bosses)
         {
            if(!boss.awaitingActivation)
            {
               var mapBoss:MapBoss = new MapBoss(mapContainer,boss);
               mapBosses.push(mapBoss);
            }
         }
         for each(var line in g.deathLineManager.lines)
         {
            mapDeathLine = new MapDeathLine(g,mapContainer,line,16746632);
            mapDeathLines.push(mapDeathLine);
         }
         for each(b2 in g.bodyManager.bodies)
         {
            if(b2.type == "planet")
            {
               var mapPlanet:MapPlanet = new MapPlanet(g,mapContainer,b2);
               mapPlanet.selected = g.hud.compas.hasTarget(b2);
               mapBodies.push(mapPlanet);
            }
         }
         for each(var spawner in g.spawnManager.spawners)
         {
            var mapSpawner:MapSpawner = new MapSpawner(mapContainer,spawner);
            mapSpawners.push(mapSpawner);
         }
         var isDomination:Boolean = g.solarSystem.type == "pvp dom";
         if(g.pvpManager != null && isDomination)
         {
            var dm:DominationManager = g.pvpManager as DominationManager;
            for each(var dz in dm.zones)
            {
               var dzs:Sprite = new MapPvpZone(g,dz);
               dzs.x = dz.x * Map.SCALE;
               dzs.y = dz.y * Map.SCALE;
               pvpZones.push(dzs);
               mapContainer.addChild(dzs);
            }
         }
         for each(var player in g.playerManager.players)
         {
            var mapPlayer:MapPlayer = new MapPlayer(mapContainer,player,g,isDomination);
            mapPlayers.push(mapPlayer);
         }
         mapLastKilled = new MapKilled(mapContainer,g);
         var mask:Quad = new Quad(WIDTH,HEIGHT);
         mask.width = WIDTH;
         mask.height = HEIGHT;
         mapContainer.mask = mask;
      }
      
      public function playerJoined(param1:Player) : void
      {
         var _loc2_:MapPlayer = new MapPlayer(mapContainer,param1,g,g.solarSystem.type == "pvp dom");
         mapPlayers.push(_loc2_);
      }
      
      public function update() : void
      {
         var _loc1_:DisplayObject = null;
         for each(var _loc4_ in mapBodies)
         {
            _loc4_.update();
         }
         for each(var _loc2_ in pvpZones)
         {
            _loc2_.update();
         }
         for each(var _loc6_ in mapPlayers)
         {
            _loc6_.update();
            if(_loc6_.isMe)
            {
               _loc1_ = mapContainer.mask;
               _loc1_.x = -(WIDTH / 2) + _loc6_.x + PADDING / 2;
               _loc1_.y = -(HEIGHT / 2) + _loc6_.y + PADDING / 2;
               mapContainer.x = WIDTH / 2 - _loc6_.x;
               mapContainer.y = HEIGHT / 2 - _loc6_.y;
               if(!g.solarSystem.isPvpSystemInEditor)
               {
                  mapContainer.x -= 715;
                  mapContainer.y -= 300;
               }
            }
         }
         for each(var _loc3_ in mapSpawners)
         {
            _loc3_.update();
         }
         for each(var _loc5_ in mapBosses)
         {
            _loc5_.update();
         }
         mapLastKilled.update();
      }
      
      override public function dispose() : void
      {
         for each(var _loc1_ in mapDeathLines)
         {
            _loc1_.dispose();
         }
         for each(var _loc2_ in mapPlayers)
         {
            _loc2_.dispose();
         }
         mapDeathLines.length = 0;
         mapBosses.length = 0;
         mapBodies.length = 0;
         mapPlayers.length = 0;
         mapSpawners.length = 0;
      }
   }
}
