package core.hud.components.chat
{
   import core.player.Player;
   import core.player.PlayerManager;
   import core.scene.Game;
   import feathers.controls.TabBar;
   import feathers.controls.TextInput;
   import feathers.data.ListCollection;
   import flash.ui.Mouse;
   import goki.FileManager;
   import goki.PlayerConfig;
   import goki.AfkFarm;
   import goki.AfkUtils;
   import sound.Playlist;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.display.Sprite;
   import goki.TextureLoader;
   import goki.FileManager;
   import core.solarSystem.Body;
   import textures.TextureManager;
   import textures.ITextureManager;
   import textures.TextureLocator;
   import starling.display.Image;
   import core.hud.components.TextBitmap;
   import core.hud.components.dialogs.PopupMessage;

   public class ChatInputText extends starling.display.Sprite
   {
      
      private static const SPAM_TIME_LIMIT:int = 1000;
      
      private static const SPAM_TIME_LIMIT_GLOBAL:int = 30000;
       
      
      private var g:Game;
      
      private var history:Vector.<String>;
      
      private var nextRdySendTime:Number = 0;
      
      private var nextGlobalRdySendTime:Number = 0;
      
      public var chatMode:String = "local";
      
      private var savedPrivateTarget:String = "";
      
      public var lastPrivateReceived:String = "";
      
      private var input:TextInput;
      
      private var tabs:TabBar;
      
      public function ChatInputText(param1:Game, param2:int, param3:int, param4:int, param5:int)
      {
         history = new Vector.<String>();
         tabs = new TabBar();
         super();
         this.g = param1;
         visible = false;
         this.x = param2;
         this.y = param3;
         var _loc6_:ListCollection = new ListCollection([{
            "label":"Local",
            "chatMode":"local"
         },{
            "label":"Global",
            "chatMode":"global"
         },{
            "label":"Clan",
            "chatMode":"clan"
         },{
            "label":"Group",
            "chatMode":"group"
         }]);
         if(param1.me.isModerator || param1.me.isDeveloper)
         {
            _loc6_.addItem({
               "label":"Mod",
               "chatMode":"modchat"
            });
         }
         tabs.dataProvider = _loc6_;
         tabs.styleNameList.add("chat_tabs");
         tabs.addEventListener("change",onTabChange);
         tabs.selectedIndex = 0;
         tabs.width = param4;
         input = new TextInput();
         input.styleName = "chat";
         input.y = 24;
         input.width = param4;
         input.height = param5;
         input.restrict = "^<>=&#[]{}";
         addChild(input);
      }
      
      private function onTabChange(param1:Event) : void
      {
         if(tabs.selectedIndex != -1)
         {
            chatMode = tabs.selectedItem.chatMode;
            input.setFocus();
         }
      }
      
      private function updateTab() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Object = null;
         _loc2_ = 0;
         while(_loc2_ < tabs.dataProvider.length)
         {
            _loc1_ = tabs.dataProvider.getItemAt(_loc2_);
            if(_loc1_.chatMode === chatMode)
            {
               tabs.selectedIndex = _loc2_;
               return;
            }
            _loc2_++;
         }
         tabs.selectedIndex = 0;
      }
      
      public function closeChat() : void
      {
         if(g == null)
         {
            return;
         }
         if(isActive())
         {
            input.text = "";
            visible = false;
            Starling.current.nativeStage.focus = null;
            Mouse.cursor = "arrow";
         }
      }
      
      public function toggleChatMode() : void
      {
         if(g == null)
         {
            return;
         }
         if(!contains(tabs))
         {
            addChild(tabs);
         }
         visible = !visible;
         if(visible)
         {
            input.setFocus();
         }
         else
         {
            sendMessage();
            Starling.current.nativeStage.focus = null;
            Mouse.cursor = "arrow";
            visible = false;
         }
      }
      
      public function isActive() : Boolean
      {
         return visible;
      }
      
      public function setText(param1:String) : void
      {
         var message:String = param1;
         if(!visible)
         {
            toggleChatMode();
         }
         input.text = message;
         Starling.juggler.delayCall(function():void
         {
            input.selectRange(input.text.length);
         },0.2);
      }
      
      private function parseCommand(param1:String) : Vector.<String>
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<String> = new Vector.<String>();
         if(param1.length >= 2 && param1.charAt(0) == "/")
         {
            _loc3_ = 1;
            while(_loc3_ < param1.length && param1.charAt(_loc3_) != " ")
            {
               _loc3_++;
            }
            _loc2_.push(param1.substring(1,_loc3_));
            if(_loc2_[0] == "")
            {
               _loc2_[0] = chatMode;
            }
            if(param1.length > _loc3_)
            {
               _loc2_.push(param1.substring(_loc3_ + 1));
            }
            return _loc2_;
         }
         _loc2_.push(chatMode);
         _loc2_.push(param1);
         return _loc2_;
      }
      
      private function sendMessage() : void
      {
         var output:Vector.<String>;
         var tmp:Array;
         var text:String = input.text;
         var stackAmount:int = 1;
         if(text == "")
         {
            return;
         }
         output = parseCommand(text);
         switch(output[0])
         {
            case "zoom":
               PlayerConfig.values.zoomFactor = output[1];
               g.camera.zoomFocus(PlayerConfig.values.zoomFactor,1);
               break;
            case "test":
               break;
            case "records":
               for(var key in g.me.completedMissions)
               {
                  var sec:Number = g.me.completedMissions[key]%60000/1000;
                  var min:int = g.me.completedMissions[key]/60000;
                  MessageLog.write(g.dataManager.loadKey("MissionTypes",key).title + " <FONT COLOR=\'#ff8888\'>" + min + ":" + sec.toFixed(3) + "</FONT>");
               }
               break;
            case "atlas":
               for(var str in TextureManager.textureAtlasDict)
               {
                  MessageLog.write(str);
               }
               break;
            case "sprite":
                  addSpriteSheet(output[1]);
               break;
            case "hackhelp":
               var helpBox:PopupMessage = new PopupMessage("Close", 5592405, 500);
               helpBox.text = "<FONT COLOR=\'#ffff44\' SIZE=\'16\'>Commands!\n\n</FONT>/zoom @value - sets the exact zoom factor\n/s, /st, /stack @number - you need to own the ships Y2K V-16, Snowformer and Rocket Sled for stacking to work. You can buy them for 0 flux from the Hyperion hangar\n/us, /unstack - unstacks :P/ss, /setstats - use this after stacking to apply the stats\n/ar, /autorec, /autorecycle - toggle autorecycling\n/pr, /pur, /purify - purifies arts\n/rec - recycles everything without opening the recycling station menu\n/recycle - opens the recycling station menu so you can choose what to recycle\n/ref, /refresh, /reload - reconnects you to the system\n/af, /afk, /afkfarm @farmName - starts one of the available afk farms. There are currently 6 farms available:\nexe - executor (completely reworked from the previous af public client)\nz - zhersis (same as zfarm in af public)\nmb - motherbrain (not extensively tested)\nbuglegs - kills moths in Hozar and collects buglegs (hasn't been tested in other systems)\nblob - bloobs\nicemoth - just leave this on for the 888 kills mission :P\nUsage example: /af exe - will initiate executor afk farm. If you want to stop it just type in /af without anything else\nEnjoy!! ^^";
               helpBox.addEventListener("close",function(param1:starling.events.Event):void
               {
                  helpBox.removeEventListeners();
                  g.removeChildFromOverlay(helpBox);
               });
               g.addChildToOverlay(helpBox);
               break;
            case "ar":
            case "autorec":
            case "autorecycle":
               PlayerConfig.autorec = !PlayerConfig.autorec;
               MessageLog.write("<FONT COLOR=\'#ffff88\'>Auto recycle is " + ((PlayerConfig.autorec)?"on!":"off!") + "</FONT>");
               break;
            case "pr":
            case "pur":
            case "purify":
               g.me.purifyArts(true);
               break;
            case "rec":
               g.me.recycleCargo(true);
               break;
            case "recycle":
               g.onboardRecycle();
               break;
            case "ref":
            case "refresh":
            case "reload":
               Starling.juggler.delayCall(function():void
               {
                  g.reload();
               },0.2);
               break;
            case "af":
            case "afk":
            case "afkfarm":
               if(output.length == 2)
               {
                  AfkFarm.init(output[1]);
               }
               else
               {
                  AfkFarm.init(null);
               }
               break;
            case "ss":
            case "setstats":
               g.me.setStackedStats();
               break;
            case "s":
            case "st":
            case "stack":
               if(g.isSystemTypeClan() || g.isSystemTypeSurvival())
               {
                  if(output.length == 2)
                  {
                     stackAmount = int(output[1]);
                  }
                  stackAmount = Math.min(stackAmount, 100);
                  g.me.stack(stackAmount);
               }
               break;
            case "us":
            case "unstack":
               if(g.isSystemTypeClan() || g.isSystemTypeSurvival())
               {
                  if(output.length == 2)
                  {
                     stackAmount = int(output[1]);
                  }
                  stackAmount = Math.min(stackAmount, 100);
                  g.me.unstack(stackAmount);
               }
               break;
            case "cnt":
            case "count":
               MessageLog.write(g.me.stacksNumber);
               break;
            case "cunt":
               MessageLog.write("OI! WHO THE FUCK ARE YOU CALLIN A CUNT AY?\n LOOK AT YOU, DYSLEXIC BASTARD CAN'T EVEN FUCKING SPELL");
               break;
            case "tptodeath":
               g.rpc("buyTeleportToDeath",null,g.me.id);
               MessageLog.write("Spent 3 flux to teleport to death");
               break;
            case "y":
            case "yes":
               g.groupManager.acceptGroupInvite();
               break;
            case "i":
            case "inv":
            case "invite":
               if(output.length == 2)
               {
                  for each(_loc2_ in g.playerManager.players)
                  {
                     if(output[1] == _loc2_.name)
                     {
                        g.groupManager.invitePlayer(_loc2_);
                     }
                  }
               }
               break;
            case "g":
            case "grp":
            case "group":
               chatMode = "group";
               if(output.length == 2)
               {
                  sendGroup(output[1]);
               }
               break;
            case "go":
               g.send("devMsg","mod",output[1]);
               break;
            case "m":
            case "w":
            case "whisper":
            case "t":
            case "tell":
            case "private":
               if(output.length == 2)
               {
                  chatMode = "privateSaved";
                  tmp = output[1].split(" ",1);
                  sendPrivate(output[1].replace(tmp[0] + " ",""),tmp[0]);
               }
               break;
            case "privateSaved":
               sendPrivate(output[1],savedPrivateTarget);
               break;
            case "r":
            case "reply":
               if(output.length == 2)
               {
                  sendPrivate(output[1],lastPrivateReceived);
               }
               break;
            case "l":
            case "local":
               chatMode = "local";
               if(output.length == 2)
               {
                  sendLocal(output[1]);
               }
               break;
            case "global":
               if(output.length == 2)
               {
                  sendGlobal(output[1]);
               }
               break;
            case "c":
            case "clan":
               chatMode = "clan";
               if(output.length == 2)
               {
                  sendLocal(output[1],"clan");
               }
               break;
            case "modchat":
               chatMode = "modchat";
               if(output.length == 2 && (g.me.isModerator || g.me.isDeveloper))
               {
                  sendLocal(output[1],"modchat");
               }
               break;
            case "leave":
               g.groupManager.leaveGroup();
               break;
            case "help":
            case "commands":
            case "command":
               listCommands();
               break;
            case "list":
               g.playerManager.listAll();
               break;
            case "msgstats":
               g.send("getMsgStats");
               break;
            case "ignore":
            case "mute":
            case "unignore":
            case "ban":
            case "unban":
            case "kick":
            case "getId":
            case "warpToId":
            case "silence":
            case "silenceall":
            case "sil":
            case "silall":
            case "showbans":
            case "showbanhistory":
            case "onlinestats":
            case "eventurl":
            case "eventimage":
            case "unmute":
               sendSettingMsg(output);
               break;
            case "setfps":
               RymdenRunt.s.nativeStage.frameRate = output[1];
               break;
            case "setmyid":
               g.me.id = output[1];
               break;
            case "stats":
               g.traceDisplayObjectCounts();
               break;
            case "report":
               if(output.length == 2)
               {
                  reportPlayer(output[1]);
               }
               break;
            case "showquality":
               g.showQuality();
               break;
            case "setquality":
               q = int(parseInt(output[1]));
               g.setQuality(q);
               break;
            case "reloadtexts":
               g.reloadTexts();
               break;
            case "myid":
               Starling.juggler.delayCall(function():void
               {
                  setText(g.me.id);
               },0.2);
               break;
            case "profile":
               MessageLog.write(Starling.current.profile);
               break;
            case "next":
               Playlist.next();
               break;
            case "get":
               if(output[1] == "out of my head")
               {
                  MessageLog.write("Out of sight out of mind, ... right?");
                  PlayerConfig.values.hideHim = true;
               }
               break;
            case "nightmare":
               if(output[1] == "fuel")
               {
                  MessageLog.write("<FONT COLOR=\'#555555\'>Chapter 6:</FONT> <FONT COLOR=\'#880000\'>heresy</FONT>");
                  PlayerConfig.values.hideHim = false;
               }
               break;
            default:
               MessageLog.write("invalid command, type /help for valid commands");
         }
         input.text = "";
         updateTab();
      }

      private function addSpriteSheet(atlas:String) : void
      {
         var spritesCanvas:Sprite = new Sprite();

         var x:int = g.me.ship.x;
         var y:int = g.me.ship.y;
         var startX:int = x;
         var startY:int = y;
         var textureManager:ITextureManager = TextureLocator.getService();
         for each(var name in TextureManager.textureAtlasDict[atlas].getNames())
         {
            var sprite:Image = new Image(textureManager.getTextureByTextureName(name,atlas));

            sprite.pivotY = sprite.height/2;
            sprite.pivotX = sprite.width/2;
            sprite.x = x;
            sprite.y = y;

            y += AfkUtils.scale(g, 10);

            if(y >= startY + AfkUtils.scale(g, 40))
            {
               y = startY;
               x += AfkUtils.scale(g, 10);
            }

            var txt:TextBitmap = new TextBitmap(sprite.x, sprite.y + sprite.height/2 + 10, name, 20);
            txt.x -= txt.width/2;

            spritesCanvas.addChild(sprite);
            spritesCanvas.addChild(txt);
         }
         g.addChildToCanvas(spritesCanvas);
      }
      
      private function reportPlayer(param1:String) : void
      {
         var _loc3_:Array = param1.split(" ",2);
         if(_loc3_.length == 0)
         {
            return;
         }
         var _loc4_:Boolean = false;
         for each(var _loc2_ in g.playerManager.players)
         {
            if(_loc2_.name == _loc3_[0])
            {
               _loc4_ = true;
            }
         }
         if(_loc4_ == false)
         {
            return;
         }
         if(_loc3_.length > 1)
         {
            param1 = param1.replace(_loc3_[0] + " ","");
            Game.trackEvent("reportedPlayers",_loc3_[0],param1 + " (" + g.me.name + ")",1);
         }
         else if(_loc3_.length > 0)
         {
            Game.trackEvent("reportedPlayers",_loc3_[0],"no reason (" + g.me.name + ")",1);
         }
      }
      
      private function listCommands() : void
      {
         MessageLog.write("\'\'/i, /inv, /invite PlayerName\'\' to send a group invite");
         MessageLog.write("\'\'/leave\'\' to leave your group");
         MessageLog.write("\'\'/l, /local, msg\'\' sends a msg to all");
         MessageLog.write("\'\'/c, /clan, msg\'\' sends a msg to your clan");
         MessageLog.write("\'\'/g, /grp, /group msg\'\' sends a msg to your group");
         MessageLog.write("\'\'/w, /whisper, /m, /t, /tell, /private PlayerName msg\'\' sends a msg to that player");
         MessageLog.write("\'\'/r, /reply msg\'\' to reply to last private msg");
         MessageLog.write("\'\'/list\'\' lists all players in the system");
         MessageLog.write("\'\'/ignore name\'\' ignore a player");
         MessageLog.write("\'\'/unignore name\'\' remove ignore");
      }
      
      private function sendSettingMsg(param1:Vector.<String>) : void
      {
         if(param1.length == 2)
         {
            g.sendToServiceRoom("chatMsg",param1[0],param1[1]);
            g.send("chatMsg",param1[0],param1[1]);
         }
         else
         {
            g.sendToServiceRoom("chatMsg",param1[0]);
         }
      }
      
      private function sendPrivate(param1:String, param2:String) : void
      {
         if(PlayerManager.banMinutes && PlayerManager.isAllChannels)
         {
            MessageLog.write("You are banned from private chat for " + PlayerManager.banMinutes + " more minutes.");
            return;
         }
         savedPrivateTarget = param2;
         var _loc4_:int = tabs.dataProvider.length;
         var _loc3_:Object = tabs.dataProvider.getItemAt(_loc4_ - 1);
         if(_loc3_.chatMode == "privateSaved")
         {
            _loc3_.label = param2;
         }
         else
         {
            _loc3_ = {
               "label":param2,
               "chatMode":"privateSaved"
            };
            tabs.dataProvider.addItem(_loc3_);
         }
         tabs.invalidate();
         g.sendToServiceRoom("chatMsg","private",param2,param1);
      }
      
      private function sendLocal(param1:String, param2:String = "local") : void
      {
         if(PlayerManager.banMinutes > 0 && PlayerManager.isAllChannels && param2 != "clan")
         {
            MessageLog.write("You are banned from local chat for " + PlayerManager.banMinutes + " more minutes.");
            return;
         }
         if(nextRdySendTime > g.time)
         {
            MessageLog.write("Hold your horses cowboy.");
            return;
         }
         if(g.messageLog.isMuted("local"))
         {
            MessageLog.write("[error] You have muted local chat","error");
            return;
         }
         history.push(param1);
         nextRdySendTime = g.time + 1000;
         if(chatMode == "local")
         {
            g.sendToServiceRoom("chatMsg",param2,param1);
         }
         else
         {
            g.sendToServiceRoom("chatMsg",param2,param1);
         }
      }
      
      private function sendGroup(param1:String) : void
      {
         var keys:Array;
         var msg:String = param1;
         if(msg.replace(" ","") === "")
         {
            return;
         }
         if(PlayerManager.banMinutes > 0 && PlayerManager.isAllChannels)
         {
            MessageLog.write("You are banned from group chat for " + PlayerManager.banMinutes + " more minutes.");
            return;
         }
         if(g.messageLog.isMuted("group"))
         {
            MessageLog.write("[error] You have muted local chat","error");
            return;
         }
         keys = [];
         g.me.group.players.forEach(function(param1:Player, param2:int, param3:Vector.<Player>):void
         {
            keys.push(param1.id);
         });
         g.sendToServiceRoom("chatMsg","group",keys.join(),msg);
      }
      
      private function sendGlobal(param1:String) : void
      {
         if(PlayerManager.banMinutes > 0)
         {
            MessageLog.write("You are banned from global chat for " + PlayerManager.banMinutes + " more minutes.");
            return;
         }
         if(g.messageLog.isMuted("global"))
         {
            MessageLog.write("[error] You have muted global chat","error");
            return;
         }
         if(nextGlobalRdySendTime < g.time || g.me.isDeveloper || g.me.isModerator)
         {
            history.push(param1);
            nextGlobalRdySendTime = g.time + 30000;
            g.sendToServiceRoom("chatMsg","global",param1);
            g.chatInput.chatMode = "local";
         }
         else if(nextGlobalRdySendTime > g.time)
         {
            MessageLog.write("You have to wait " + Math.round((nextGlobalRdySendTime - g.time) / 1000) + " seconds.");
         }
      }
      
      public function previous() : void
      {
         if(history.length > 0)
         {
            input.text = history.pop();
            history.unshift(input.text);
         }
      }
      
      public function next() : void
      {
         if(history.length > 0)
         {
            input.text = history.shift();
            history.push(input.text);
         }
      }
   }
}
