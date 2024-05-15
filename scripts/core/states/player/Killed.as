package core.states.player
{
   import core.credits.CreditManager;
   import core.hud.components.Box;
   import core.hud.components.Button;
   import core.hud.components.dialogs.CreditBuyBox;
   import core.player.Player;
   import core.scene.Game;
   import core.states.IState;
   import core.states.StateMachine;
   import core.states.gameStates.RoamingState;
   import core.states.gameStates.ShopState;
   import core.weapon.Damage;
   import flash.geom.Point;
   import playerio.Message;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.filters.GlowFilter;
   import starling.text.TextField;
   import starling.text.TextFormat;
   
   public class Killed implements IState
   {
      
      public static var killedTime:Number;
      
      public static var killedPosition:Point = new Point(0,0);
       
      
      private var player:Player;
      
      private var g:Game;
      
      private var m:Message;
      
      private var sm:StateMachine;
      
      private var q:Quad;
      
      private var box:Box;
      
      private var deathInfo:TextField;
      
      private var dropInfo:TextField;
      
      private var respawnText:TextField;
      
      public function Killed(param1:Player, param2:Game, param3:Message)
      {
         super();
         this.player = param1;
         this.g = param2;
         this.m = param3;
      }
      
      private function teleport(param1:Message) : void
      {
         if(param1.getBoolean(0))
         {
            Game.trackEvent("used flux","teleport","teleport to death",CreditManager.getCostTeleportToDeath());
         }
         else
         {
            g.showErrorDialog(param1.getString(1));
         }
      }
      
      public function enter() : void
      {
         var killerText:String;
         var mod:String;
         var lostXpText:String;
         var xpProtectionButton:Button;
         var teleportToDeathButton:Button;
         var lostXpInfo:TextField;
         var dropText:String;
         var dropDict:Object;
         var prop:String;
         var i:int;
         var amount:int;
         var prop2:String;
         var cargoProtectionButton:Button;
         var _loc2_:String;
         var _loc3_:*;
         if(player.isMe)
         {
            killedPosition = player.ship.pos.clone();
            if(killedPosition.x != 0 && killedPosition.y != 0)
            {
               killedTime = g.time;
            }
         }
         player.spree = 0;
         player.ship.destroy();
         player.ship = null;
         if(player.mirror != null)
         {
            player.mirror.destroy(false);
            player.mirror = null;
         }
         if(!player.isMe)
         {
            return;
         }
         g.camera.focusTarget = killedPosition;
         if(!g.gameStateMachine.inState(RoamingState))
         {
            g.gameStateMachine.revertState();
         }
         if(g.hud.healthAndShield != null)
         {
            g.hud.healthAndShield.stopLowHPWarningEffect();
         }
         g.hud.update();
         g.killed();
         g.hud.show = false;
         box = new Box(480,280,"normal",0,20);
         killerText = m.getString(1);
         mod = m.getString(2);
         if(mod == "sun")
         {
            killerText = "<FONT COLOR=\'#666666\'>Cause of Death</FONT>\n<FONT SIZE=\'20\' COLOR=\'#ff4444\'>TOO HOT TO HANDLE</FONT>";
         }
         else if(killerText == player.name)
         {
            killerText = "<FONT COLOR=\'#666666\'>Cause of Death</FONT>\n<FONT SIZE=\'20\' COLOR=\'#ff4444\'>SUICIDE</FONT>";
         }
         else
         {
            killerText = "<FONT COLOR=\'#666666\'>Killed by</FONT>\n<FONT SIZE=\'20\' COLOR=\'#ff4444\'>" + killerText + "</FONT>";
         }
         killerText = killerText + "\n" + Damage.TYPE_HTML[m.getInt(4)] + " damage";
         deathInfo = new TextField(280,10,"",new TextFormat("DAIDRR"));
         deathInfo.autoSize = "vertical";
         deathInfo.format.color = 16777215;
         deathInfo.isHtmlText = true;
         deathInfo.text = killerText;
         deathInfo.format.horizontalAlign = "left";
         box.addChild(deathInfo);
         if(g.solarSystem.isPvpSystemInEditor)
         {
            lostXpText = "";
         }
         else if(player.hasXpProtection())
         {
            lostXpText = "\n\n<FONT COLOR=\'#666666\'>Lost XP</FONT>\n0 XP\n<FONT COLOR=\'#88ff88\'>protection active</FONT>";
         }
         else
         {
            lostXpText = "\n\n<FONT COLOR=\'#666666\'>Lost XP</FONT>\n-" + m.getString(3) + " XP";
            xpProtectionButton = new Button(function(param1:Event):void
            {
               g.enterState(new ShopState(g,"xpProtection"));
            },"Get XP protection");
         }
         teleportToDeathButton = new Button(function(param1:Event):void
         {
            var e:Event = param1;
            g.creditManager.refresh(function():void
            {
               var confirmBuyWithFlux:CreditBuyBox = new CreditBuyBox(g,CreditManager.getCostTeleportToDeath(),"Are you sure you want to teleport?");
               g.addChildToOverlay(confirmBuyWithFlux);
               confirmBuyWithFlux.addEventListener("accept",function():void
               {
                  g.rpc("buyTeleportToDeath",teleport,player.id);
                  confirmBuyWithFlux.removeEventListeners();
                  g.removeChildFromOverlay(confirmBuyWithFlux,true);
               });
               confirmBuyWithFlux.addEventListener("close",function():void
               {
                  confirmBuyWithFlux.removeEventListeners();
                  g.removeChildFromOverlay(confirmBuyWithFlux,true);
               });
            });
         },"Teleport to killed location","buy");
         teleportToDeathButton.x = deathInfo.x;
         teleportToDeathButton.y = deathInfo.y + deathInfo.height + teleportToDeathButton.height * 0.5;
         box.addChild(teleportToDeathButton);
         lostXpInfo = new TextField(280,10,"",new TextFormat("DAIDRR"));
         lostXpInfo.autoSize = "vertical";
         lostXpInfo.isHtmlText = true;
         lostXpInfo.format.color = 16777215;
         lostXpInfo.y = deathInfo.height + teleportToDeathButton.height;
         lostXpInfo.text = lostXpText;
         lostXpInfo.format.horizontalAlign = "left";
         box.addChild(lostXpInfo);
         if(xpProtectionButton != null)
         {
            xpProtectionButton.x = lostXpInfo.x;
            xpProtectionButton.y = lostXpInfo.y + lostXpInfo.height + xpProtectionButton.height * 0.5;
            box.addChild(xpProtectionButton);
         }
         if(g.isSystemTypeSurvival())
         {
            Game.trackEvent("Survival","Death","Rank " + g.hud.uberStats.uberRank,g.me.level);
         }
         if(!g.solarSystem.isPvpSystemInEditor)
         {
            dropText = "<FONT COLOR=\'#666666\'>Lost Cargo</FONT>\n";
            dropDict = {};
            prop = "";
            i = 5;
            while(i < m.length)
            {
               prop = m.getString(i);
               amount = m.getInt(i + 8);
               if(!dropDict.hasOwnProperty(prop))
               {
                  dropDict[prop] = amount;
               }
               else
               {
                  _loc2_ = prop;
                  _loc3_ = dropDict[_loc2_] + amount;
                  dropDict[_loc2_] = _loc3_;
               }
               i += 9;
            }
            for(prop2 in dropDict)
            {
               dropText += prop2 + " x" + dropDict[prop2] + "\n";
            }
            if(prop == "")
            {
               dropText += "None";
            }
            if(player.isCargoProtectionActive())
            {
               dropText += "\n<FONT COLOR=\'#88ff88\'>protection active</FONT>";
            }
            else
            {
               g.myCargo.removeAllJunk();
            }
            dropInfo = new TextField(200,10,"",new TextFormat("DAIDRR"));
            dropInfo.autoSize = "vertical";
            dropInfo.format.color = 16777215;
            dropInfo.isHtmlText = true;
            dropInfo.text = dropText;
            dropInfo.x = 330;
            dropInfo.format.horizontalAlign = "left";
            box.addChild(dropInfo);
            if(!player.isCargoProtectionActive() && prop != "")
            {
               cargoProtectionButton = new Button(function(param1:Event):void
               {
                  g.enterState(new ShopState(g,"cargoProtection"));
               },"Get cargo protection");
               cargoProtectionButton.x = dropInfo.x;
               cargoProtectionButton.y = dropInfo.height + cargoProtectionButton.height / 2;
               box.addChild(cargoProtectionButton);
            }
         }
         q = new Quad(g.stage.stageWidth,g.stage.stageHeight,0);
         q.alpha = 0.5;
         g.addChild(q);
         g.addResizeListener(resize);
         g.addChild(box);
         respawnText = new TextField(10,10,"",new TextFormat("DAIDRR",52));
         respawnText.autoSize = "bothDirections";
         respawnText.text = Math.round(player.respawnNextReady - g.time).toString();
         respawnText.filter = new GlowFilter(16777215,1,10);
         respawnText.x = box.width / 2;
         respawnText.y = box.height;
         respawnText.format.horizontalAlign = "center";
         respawnText.format.color = 16777215;
         respawnText.alignPivot();
         box.addChild(respawnText);
         resize();
      }
      
      private function resize(param1:Event = null) : void
      {
         q.width = g.stage.stageWidth;
         q.height = g.stage.stageHeight;
         box.y = g.stage.stageHeight / 6;
         box.x = g.stage.stageWidth / 2 - 225;
      }
      
      public function execute() : void
      {
         var _loc2_:int = 0;
         var _loc1_:String = null;
         if(player.isMe)
         {
            respawnText.scaleX = respawnText.scaleY = Math.sin((player.respawnNextReady - g.time) * 0.0075) * 0.1 + 1;
            if(player.respawnNextReady < g.time + 100)
            {
               if(!g.solarSystem.isPvpSystemInEditor)
               {
                  respawnText.text = "Press SPACE to respawn";
                  if(g.isSystemTypeSurvival())
                  {
                     _loc2_ = g.hud.uberStats.getMyLives();
                     if(_loc2_ == 0)
                     {
                        respawnText.text = "Game Over";
                     }
                     else if(_loc2_ == 1)
                     {
                        respawnText.text = _loc2_ + " life left";
                     }
                     else
                     {
                        respawnText.text = _loc2_ + " lives left";
                     }
                  }
               }
               respawnText.format.size = 25;
            }
            else
            {
               respawnText.text = Math.ceil(0.001 * (player.respawnNextReady - g.time));
            }
            respawnText.alignPivot();
         }
      }
      
      public function exit() : void
      {
         if(player.isMe)
         {
            if(respawnText)
            {
               if(respawnText.filter)
               {
                  respawnText.filter.dispose();
               }
               respawnText.filter = null;
            }
            g.removeChild(box,true);
            g.removeChild(q,true);
            g.removeResizeListener(resize);
            g.respawned();
            g.hud.show = true;
            g.messageLog.visible = true;
         }
      }
      
      public function get type() : String
      {
         return "Killed";
      }
      
      public function set stateMachine(param1:StateMachine) : void
      {
         this.sm = param1;
      }
   }
}
