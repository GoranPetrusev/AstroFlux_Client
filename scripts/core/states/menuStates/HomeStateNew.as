package core.states.menuStates
{
   import com.greensock.TweenMax;
   import core.clan.PlayerClanLogo;
   import core.credits.CreditManager;
   import core.hud.components.Box;
   import core.hud.components.Button;
   import core.hud.components.TextBitmap;
   import core.hud.components.ToolTip;
   import core.hud.components.dialogs.CreditBuyBox;
   import core.hud.components.dialogs.PopupInputMessage;
   import core.hud.components.shipMenu.ArtifactSelector;
   import core.hud.components.shipMenu.CrewSelector;
   import core.hud.components.shipMenu.WeaponSelector;
   import core.player.FleetObj;
   import core.player.Player;
   import core.scene.Game;
   import core.ship.ShipFactory;
   import core.states.DisplayState;
   import data.DataLocator;
   import data.IDataManager;
   import generics.Localize;
   import generics.Util;
   import playerio.Message;
   import sound.SoundLocator;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.TouchEvent;
   
   public class HomeStateNew extends DisplayState
   {
       
      
      private const COLUMN_WIDTH:int = 280;
      
      private var dataManager:IDataManager;
      
      private var infoContainer:Box;
      
      private var shipContainer:Box;
      
      private var weaponsContainer:Box;
      
      private var artifactsContainer:Box;
      
      private var crewContainer:Box;
      
      private var p:Player;
      
      private var shipImage:MovieClip;
      
      public function HomeStateNew(game:Game, player:Player)
      {
         super(game,HomeStateNew);
         this.p = player;
         dataManager = DataLocator.getService();
      }
      
      private static function addStat(x:int, y:int, name:String, value:String, container:Sprite, rightAlign:Boolean = false) : int
      {
         var statName:TextBitmap = new TextBitmap(x,y,name);
         statName.format.color = 6710886;
         if(rightAlign)
         {
            statName.alignRight();
         }
         container.addChild(statName);
         var statValue:TextBitmap = new TextBitmap(x,statName.y + statName.height, value);
         if(rightAlign)
         {
            statValue.alignRight();
         }
         container.addChild(statValue);
         return statName.x + statName.width;
      }
      
      override public function enter() : void
      {
         var weaponsLabel:TextBitmap;
         var weaponSelector:WeaponSelector;
         var upgradeButton:Button;
         var artifactLabel:TextBitmap;
         var artifactsButton:Button;
         var fitnessButton:Button;
         var artifactSelector:ArtifactSelector;
         var crewLabel:TextBitmap;
         var crewButton:Button;
         var crewSelector:CrewSelector;
         super.enter();
         loadShipInfo();
         loadPlayerInfo();
         weaponsContainer = new Box(280,70,"light",0.5,20);
         weaponsContainer.x = shipContainer.x;
         weaponsContainer.y = shipContainer.y + shipContainer.height + 7;
         addChild(weaponsContainer);
         weaponsLabel = new TextBitmap(0,-3,Localize.t("Weapons"));
         weaponsLabel.format.color = 16689475;
         weaponsContainer.addChild(weaponsLabel);
         weaponSelector = new WeaponSelector(g,p);
         weaponSelector.y = weaponsLabel.y + weaponsLabel.height + 15;
         weaponSelector.addEventListener("changeWeapon",function(param1:Event):void
         {
            sm.changeState(new ChangeWeaponState(g,p,param1.data as int));
         });
         weaponsContainer.addChild(weaponSelector);
         upgradeButton = new Button(function():void
         {
            sm.changeState(new UpgradesState(g,p));
         },Localize.t("Upgrades").toLowerCase());
         upgradeButton.x = 280 + 10 - upgradeButton.width;
         upgradeButton.y = -10;
         weaponsContainer.addChild(upgradeButton);
         artifactsContainer = new Box(280,70,"light",0.5,20);
         artifactsContainer.x = shipContainer.x;
         artifactsContainer.y = weaponsContainer.y + weaponsContainer.height + 20;
         addChild(artifactsContainer);
         artifactLabel = new TextBitmap(0,-3,Localize.t("Artifacts"));
         artifactLabel.format.color = 16689475;
         artifactsContainer.addChild(artifactLabel);
         artifactsButton = new Button(function():void
         {
            sm.changeState(new ArtifactState2(g,p));
         },Localize.t("Artifacts").toLowerCase());
         artifactsButton.x = 280 + 10 - artifactsButton.width;
         artifactsButton.y = -10;
         artifactsContainer.addChild(artifactsButton);
         fitnessButton = new Button(function():void
         {
            sm.changeState(new FitnessState(g));
         },"fitness");
         addChild(fitnessButton);
         artifactsContainer.addChild(fitnessButton);
         fitnessButton.x = artifactsButton.x - fitnessButton.width - 10;
         fitnessButton.y = artifactsButton.y;
         artifactSelector = new ArtifactSelector(g,p);
         artifactSelector.y = artifactLabel.y + artifactLabel.height + 15;
         artifactSelector.addEventListener("artifactSelected",function(param1:Event):void
         {
            sm.changeState(new ArtifactState2(g,p));
         });
         artifactsContainer.addChild(artifactSelector);
         crewContainer = new Box(280,70,"light",0.5,20);
         crewContainer.x = infoContainer.x;
         crewContainer.y = weaponsContainer.y;
         addChild(crewContainer);
         crewLabel = new TextBitmap(0,-3,Localize.t("Crew"));
         crewLabel.format.color = 16689475;
         crewContainer.addChild(crewLabel);
         crewButton = new Button(function():void
         {
            sm.changeState(new CrewStateNew(g));
         },Localize.t("Manage").toLowerCase());
         crewButton.x = 280 + 10 - crewButton.width;
         crewButton.y = -5;
         crewContainer.addChild(crewButton);
         crewSelector = new CrewSelector(g,p);
         crewSelector.y = crewLabel.y + crewLabel.height + 15;
         crewSelector.addEventListener("crewSelected",function(param1:Event):void
         {
            sm.changeState(new CrewStateNew(g));
         });
         crewContainer.addChild(crewSelector);

         var devText:TextBitmap = new TextBitmap(390, crewContainer.y + crewContainer.height, "Af Goki has been lovingly made by TheRealPancake, Kaiser (Primiano), Balisman and MAXI. Big thank you to the original pioneers for figuring most of this stuff out!");
         devText.wordWrap = true;
         devText.format.color = 11009932;
         devText.size = 25;
         devText.width = crewContainer.width;
         devText.height = 100;
         addChild(devText);
      }
      
      private function loadPlayerInfo() : void
      {
         infoContainer = new Box(280,190,"light",0.5,20);
         infoContainer.x = 410;
         infoContainer.y = 70;
         addChild(infoContainer);
         addExplored();
         addExperience();

         //player_v_g1
         var offset:int = 0;
         var troonImg:Image = new Image(textureManager.getTextureGUIByTextureName("troon.png"));
         troonImg.x = 100 + offset;
         troonImg.y = 0;
         infoContainer.addChild(troonImg);
         new ToolTip(g,troonImg,"Troons give bonus stats to your ship if its above <FONT COLOR=\'#FFFFFF\'>200 000</FONT>.",null,"HomeState");
         var troonsCnt:TextBitmap = new TextBitmap(280,0,p.troons.toString());
         troonsCnt.x = troonImg.x + troonImg.width + 5 + offset;
         infoContainer.addChild(troonsCnt);
         var level:TextBitmap = new TextBitmap(troonImg.x + (troonImg.width + troonsCnt.width)/2 + offset, -25 , p.level.toString(), 32);
         level.center();
         infoContainer.addChild(level);

         var splitter:Image = new Image(textureManager.getTextureByTextureName("line1","texture_main_NEW.png"));
         splitter.scaleX = 1.5;
         splitter.scaleY = 0.1;
         splitter.rotation = 1.57;
         splitter.color = 3158064;
         splitter.x = level.x + 3;
         splitter.y = 40;
         infoContainer.addChild(splitter);

         var yOff:int = 47;//infoContainer.height - infoContainer.padding * 6;
         var xOff:int = -10;
         addStat(xOff, yOff,       "enemy kills",  p.enemyKills.toString(),   infoContainer);
         addStat(xOff + 130, yOff + 35,  "player kills", p.playerKills.toString(),  infoContainer, true);
         addStat(xOff, yOff + 70,  "deaths",       p.playerDeaths.toString(), infoContainer);
         addStat(xOff + 130, yOff + 105, "owned ships",  p.fleet.length,            infoContainer, true);
         // yOff += infoContainer.padding * 2;
         // addStat(xOff * 0 - 10, yOff, "enemy kills",  p.enemyKills.toString(),   infoContainer);
         // addStat(xOff * 1 - 10, yOff, "player kills", p.playerKills.toString(),  infoContainer);
         // addStat(xOff * 2 - 10, yOff, "deaths",       p.playerDeaths.toString(), infoContainer);
      }

      private function addExperience() : void
      {
         var xpCircle:Image = new Image(textureManager.getTextureByTextureName("fluff9","texture_main_NEW.png"));
         var scale:Number = 1.4;
         xpCircle.scaleX = xpCircle.scaleY = scale;
         xpCircle.readjustSize();
         xpCircle.pivotX = xpCircle.width / scale / 2;
         xpCircle.pivotY = xpCircle.height / scale / 2;
         xpCircle.color = 16775006;
         xpCircle.x = infoContainer.width - infoContainer.padding * 4.95;
         xpCircle.y = 150;//50;
         infoContainer.addChild(xpCircle);

         var xpTxt:TextBitmap = new TextBitmap(xpCircle.x, xpCircle.y + xpCircle.height * 0.5 + 8, "experience");
         xpTxt.format.color = 6710886;
         xpTxt.center();
         infoContainer.addChild(xpTxt);

         var levelProgress:Number = (p.xp - p.levelXpMin) / (p.levelXpMax - p.levelXpMin) * 100;

         var shadow:TextBitmap = new TextBitmap(xpCircle.x + 2, xpCircle.y - 1, levelProgress.toFixed(2) + "%", 25);
         shadow.center();
         shadow.format.bold = true;
         shadow.format.color = 986895;
         infoContainer.addChild(shadow);
         var xpPercent:TextBitmap = new TextBitmap(xpCircle.x, xpCircle.y - 3, levelProgress.toFixed(2) + "%", 25);
         xpPercent.center();
         infoContainer.addChild(xpPercent);
      }

      private function addExplored() : void
      {
         var earth:Image = new Image(textureManager.getTextureByTextureName("earth","texture_body.png"));
         var scale:Number = 0.35;
         earth.scaleX = earth.scaleY = scale;
         earth.readjustSize();
         earth.pivotX = earth.width / scale / 2;
         earth.pivotY = earth.height / scale / 2;
         earth.x = infoContainer.width - infoContainer.padding * 4.95;
         earth.y = 50;//50;
         infoContainer.addChild(earth);

         var exploreTxt:TextBitmap = new TextBitmap(earth.x, earth.y + earth.height * 0.5 + 7, "explored");
         exploreTxt.format.color = 6710886;
         exploreTxt.center();
         infoContainer.addChild(exploreTxt);

         var areasExplored:Number = 0;
         var totalAreas:Number = 0;
         var bodyAreas:Object = dataManager.loadTable("BodyAreas");
         for(var area in bodyAreas)
         {
            areasExplored += g.me.hasExploredArea(area);
            totalAreas++;
         }
         var exploreProgress:Number = areasExplored / totalAreas * 100;

         var shadow:TextBitmap = new TextBitmap(earth.x + 2, earth.y - 1, exploreProgress.toFixed(2) + "%", 25);
         shadow.center();
         shadow.format.bold = true;
         shadow.format.color = 986895;
         infoContainer.addChild(shadow);
         var explorePercent:TextBitmap = new TextBitmap(earth.x, earth.y - 3, exploreProgress.toFixed(2) + "%", 25);
         explorePercent.center();
         infoContainer.addChild(explorePercent);
      }
      
      override public function get type() : String
      {
         return "HomeState";
      }
      
      private function loadShipInfo() : void
      {
         shipContainer = new Box(280,190,"light",0.5,20);
         shipContainer.x = 70;
         shipContainer.y = 70;
         addChild(shipContainer);
         if(p.clanId != "")
         {
            var clanLogo:Image = new Image(p.clanLogo.texture);
            clanLogo.x = -20;
            clanLogo.y = shipContainer.height * 0.5 - 83;
            clanLogo.color = p.clanLogoColor;
            clanLogo.alpha = 0.22;
            clanLogo.scaleX = clanLogo.scaleY = 1.2;
            shipContainer.addChild(clanLogo);
         }
         var _loc1_:Sprite = new Sprite();
         _loc1_.width = shipContainer.width;
         _loc1_.height = shipContainer.height;
         shipContainer.addChild(_loc1_);
         var yOff:int = shipContainer.height - 63;
         var xOff:int = 70;
         addStat(xOff * 0 - 10, yOff, "health",p.ship.hpMax.toString(),_loc1_);
         addStat(xOff * 1 - 10, yOff, "armor",p.ship.armorThreshold.toString(),_loc1_);
         addStat(xOff * 2 - 10, yOff, "shield",p.ship.shieldHpMax.toString(),_loc1_);
         addStat(xOff * 3 - 10, yOff, "shield regen",(1.75 * (p.ship.shieldRegen + p.ship.shieldRegenBonus)).toFixed(0),_loc1_);
         drawShip();
      }
      
      private function drawShip() : void
      {
         var xx:int = 0;
         var supporterImage:Image;
         var playerName:TextBitmap;
         var skin:Object = dataManager.loadKey("Skins",p.activeSkin);
         var fleetObj:FleetObj = p.getActiveFleetObj();
         var ship:Object = dataManager.loadKey("Ships",skin.ship);
         var obj2:Object = dataManager.loadKey("Images",ship.bitmap);
         shipImage = new MovieClip(textureManager.getTexturesMainByTextureName(obj2.textureName));
         var scale:Number = 1.25;
         shipImage.scaleX = shipImage.scaleY = scale;
         shipImage.readjustSize();
         shipImage.pivotX = shipImage.width / scale / 2;
         shipImage.pivotY = shipImage.height / scale / 2;
         shipImage.x = shipContainer.width * 0.5 - 20;
         shipImage.y = shipContainer.height * 0.5 - 22;
         shipContainer.addChild(shipImage);
         shipImage.filter = ShipFactory.createPlayerShipColorMatrixFilter(fleetObj);
         if(g.me.hasSupporter())
         {
            supporterImage = new Image(textureManager.getTextureGUIByTextureName("icon_supporter.png"));
            supporterImage.x = shipImage.x + shipImage.width + 5;
            supporterImage.y = Math.round(shipImage.height / 2) - supporterImage.height / 2;
            shipContainer.addChild(supporterImage);
            xx = 5;
         }
         playerName = new TextBitmap(shipImage.x + xx,-25,p.name,25);
         playerName.useHandCursor = true;
         playerName.center();
         var clanName:TextBitmap = new TextBitmap(shipImage.x, playerName.y + playerName.height - 7, p.clanName, 19);
         clanName.format.color = p.clanLogoColor;
         clanName.center();
         shipContainer.addChild(clanName);
         var clanRank:TextBitmap = new TextBitmap(shipImage.x, clanName.y + clanName.height - 7, p.clanRankName, 12);
         clanRank.format.color = p.clanLogoColor;
         clanRank.center();
         shipContainer.addChild(clanRank);
         new ToolTip(g,playerName,Localize.t("Click to change name."),null,"HomeState");
         playerName.addEventListener("touch",function(param1:TouchEvent):void
         {
            var popup:PopupInputMessage;
            var e:TouchEvent = param1;
            if(e.getTouch(playerName,"ended"))
            {
               popup = new PopupInputMessage(Localize.t("Change Name for [flux] Flux").replace("[flux]",CreditManager.getCostChangeName(p.name)));
               popup.input.restrict = "a-zA-Z0-9\\-_";
               popup.input.maxChars = 15;
               popup.addEventListener("accept",function(param1:Event):void
               {
                  var e:Event = param1;
                  g.creditManager.refresh(function():void
                  {
                     var confirmBuyWithFlux:CreditBuyBox = new CreditBuyBox(g,CreditManager.getCostChangeName(p.name),Localize.t("Are you sure you want to change name?"));
                     g.addChildToOverlay(confirmBuyWithFlux);
                     confirmBuyWithFlux.addEventListener("accept",function(param1:Event):void
                     {
                        var e:Event = param1;
                        g.rpc("changeName",function(param1:Message):void
                        {
                           if(param1.getBoolean(0))
                           {
                              p.name = popup.text;
                              playerName.text = p.name;
                              TweenMax.fromTo(playerName,1,{
                                 "scaleX":2,
                                 "scaleY":2
                              },{
                                 "scaleX":1,
                                 "scaleY":1
                              });
                              SoundLocator.getService().play("7zeIcPFb-UWzgtR_3nrZ8Q");
                              g.creditManager.refresh();
                           }
                           else
                           {
                              g.showErrorDialog(param1.getString(1),false);
                           }
                        },popup.text);
                        confirmBuyWithFlux.removeEventListeners();
                     });
                     confirmBuyWithFlux.addEventListener("close",function(param1:Event):void
                     {
                        confirmBuyWithFlux.removeEventListeners();
                        g.removeChildFromOverlay(confirmBuyWithFlux,true);
                     });
                     popup.removeEventListeners();
                     g.removeChildFromOverlay(popup);
                  });
               });
               popup.addEventListener("close",function(param1:Event):void
               {
                  popup.removeEventListeners();
                  g.removeChildFromOverlay(popup);
               });
               g.addChildToOverlay(popup);
            }
         });
         shipContainer.addChild(playerName);
      }
      
      override public function exit() : void
      {
         ToolTip.disposeType("HomeState");
         removeChild(infoContainer,true);
         removeChild(shipContainer,true);
         removeChild(weaponsContainer,true);
         removeChild(artifactsContainer,true);
         removeChild(crewContainer,true);
         super.exit();
      }
   }
}
