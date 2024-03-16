package core.hud.components.chat
{
   import core.hud.components.ToolTip;
   import core.scene.Game;
   import feathers.controls.ScrollContainer;
   import feathers.layout.HorizontalLayout;
   import starling.display.Image;
   import starling.events.TouchEvent;
   import textures.ITextureManager;
   import textures.TextureLocator;
   
   public class PlayerChatOptions extends ScrollContainer
   {
       
      
      private var g:Game;
      
      private var obj:Object;
      
      private var muteImage:Image;
      
      private var messageImage:Image;
      
      private var banImage:Image;
      
      private var textImage:Image;
      
      public function PlayerChatOptions(param1:Game, param2:Object)
      {
         super();
         this.g = param1;
         this.obj = param2;
         var _loc4_:HorizontalLayout;
         (_loc4_ = new HorizontalLayout()).paddingLeft = 10;
         _loc4_.paddingTop = 5;
         _loc4_.paddingBottom = 10;
         _loc4_.gap = 15;
         this.layout = _loc4_;
         var _loc3_:ITextureManager = TextureLocator.getService();
         muteImage = new Image(_loc3_.getTextureGUIByTextureName("mute"));
         muteImage.addEventListener("touch",onMute);
         muteImage.useHandCursor = true;
         addChild(muteImage);
         new ToolTip(param1,muteImage,"mute player",null,"PlayerChatOptions");
         messageImage = new Image(_loc3_.getTextureGUIByTextureName("chat_pm"));
         messageImage.addEventListener("touch",onPrivateMessage);
         messageImage.useHandCursor = true;
         addChild(messageImage);
         new ToolTip(param1,messageImage,"send private message",null,"PlayerChatOptions");
         textImage = new Image(_loc3_.getTextureGUIByTextureName("chat_pm"));
         textImage.addEventListener("touch",onTextChat);
         textImage.useHandCursor = true;
         addChild(textImage);
         new ToolTip(param1,textImage,"get text",null,"PlayerChatOptions");
         if(param1.me.isModerator || param1.me.isDeveloper)
         {
            banImage = new Image(_loc3_.getTextureGUIByTextureName("chat_ban"));
            banImage.addEventListener("touch",onSilence);
            banImage.useHandCursor = true;
            addChild(banImage);
            new ToolTip(param1,banImage,"silence player",null,"PlayerChatOptions");
         }
      }
      
      private function onMute(param1:TouchEvent) : void
      {
         if(param1.getTouch(muteImage,"ended"))
         {
            g.sendToServiceRoom("chatMsg","ignore",obj.playerName);
            g.messageLog.removePlayerMessages(obj.playerKey);
         }
      }
      
      private function onPrivateMessage(param1:TouchEvent) : void
      {
         if(param1.getTouch(messageImage,"ended"))
         {
            g.chatInput.setText("/w " + obj.playerName + " ");
         }
      }
      
      private function onSilence(param1:TouchEvent) : void
      {
         if(param1.getTouch(banImage,"ended"))
         {
            g.chatInput.setText("/silence " + obj.playerKey + " ");
         }
      }
      
      override public function dispose() : void
      {
         muteImage.removeEventListeners();
         messageImage.removeEventListeners();
         if(banImage)
         {
            banImage.removeEventListeners();
         }
         ToolTip.disposeType("PlayerChatOptions");
         super.dispose();
      }
      
      public function onTextChat(param1:TouchEvent) : void
      {
         if(param1.getTouch(textImage,"ended"))
         {
            g.chatInput.setText(removeSystemMsg(obj.text));
         }
      }
      
      public function removeSystemMsg(param1:String) : String
      {
         param1 = param1.replace("<FONT COLOR=\'#9a9a9a\'>[private]</FONT>","");
         param1 = param1.replace("<FONT COLOR=\'#cccc44\'>[global]</FONT>","");
         param1 = param1.replace("<FONT COLOR=\'#8888cc\'>[local]</FONT>","");
         param1 = param1.replace("<FONT COLOR=\'#6666ff\'>[team]</FONT>","");
         param1 = param1.replace("<FONT COLOR=\'#88cc88\'>[clan]</FONT>","");
         param1 = param1.replace("<FONT COLOR=\'#20ecea\'>[group]</FONT>","");
         param1 = param1.replace("<FONT COLOR=\'#ff3daf\'>[mod]</FONT>","");
         param1 = param1.replace("<FONT COLOR=\'#ff6daf\'>[modchat]</FONT>","");
         param1 = param1.replace("<FONT COLOR=\'#ff44ff\'>[planet wars]</FONT>","");
         param1 = param1.replace("<FONT COLOR=\'#C5403A\'>[error]</FONT>","");
         param1 = param1.replace("[death]","");
         param1 = param1.replace("[loot]","");
         param1.replace("[join_leave]","");
         var _loc3_:int = 1;
         while(_loc3_ < param1.length && param1.charAt(_loc3_) != ":")
         {
            _loc3_++;
         }
         return param1.substring(_loc3_ + 2);
      }
   }
}