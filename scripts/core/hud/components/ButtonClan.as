package core.hud.components
{
   import core.clan.PlayerClanLogo;
   import core.scene.Game;
   import core.scene.SceneBase;
   import data.KeyBinds;
   import generics.Localize;
   import generics.Util;
   import starling.display.Image;
   import starling.text.TextField;
   import textures.ITextureManager;
   import textures.TextureLocator;
   
   public class ButtonClan extends ButtonHud
   {
       
      
      private var g:Game;
      
      private var troonsPerMinute:TextField;
      
      private var clanLogo:Image;
      
      private var troonIcon:Image;
      
      public function ButtonClan(param1:Function, param2:Game)
      {
         var textureManager:ITextureManager;
         var playerClanLogo:PlayerClanLogo;
         var keyBinds:KeyBinds;
         var clickCallback:Function = param1;
         var g:Game = param2;
         super(clickCallback,"button_shop_bg");
         this.g = g;
         textureManager = TextureLocator.getService();
         troonsPerMinute = new TextBitmap(0,0,"0/m");
         troonsPerMinute.format.color = Style.COLOR_YELLOW;
         troonsPerMinute.touchable = false;
         troonsPerMinute.batchable = true;
         troonsPerMinute.y = 4;
         addChild(troonsPerMinute);
         playerClanLogo = new PlayerClanLogo(g,g.me,function(param1:Boolean = true):void
         {
            if(param1)
            {
               clanLogo = new Image(g.me.clanLogo.texture);
               core.hud.§components:ButtonClan§.clanLogo.color = g.me.clanLogoColor;
            }
            else
            {
               clanLogo = new Image(textureManager.getTextureGUIByTextureName("clan_logo1"));
               core.hud.§components:ButtonClan§.clanLogo.color = 6710886;
            }
            core.hud.§components:ButtonClan§.clanLogo.scaleX = core.hud.§components:ButtonClan§.clanLogo.scaleY = 0.15;
            core.hud.§components:ButtonClan§.clanLogo.touchable = false;
            core.hud.§components:ButtonClan§.clanLogo.y = 5;
            addChild(core.hud.§components:ButtonClan§.clanLogo);
            troonIcon = new Image(textureManager.getTextureGUIByTextureName("troon.png"));
            troonIcon.scaleX = troonIcon.scaleY = 0.5;
            troonIcon.y = 7;
            addChild(troonIcon);
            removeChild(playerClanLogo);
            updateTroons();
         });
         keyBinds = SceneBase.settings.keybinds;
         if(g.me.clanId == "")
         {
            new ToolTip(g,this,Localize.t("Click here to join or create a clan."));
         }
         else
         {
            new ToolTip(g,this,Localize.t("Your clan: troons / minute from planet wars. <FONT COLOR=\'#44FF44\'>[key]</FONT>").replace("[key]",keyBinds.getKeyChar(0)));
         }
         addChild(playerClanLogo);
      }
      
      public function updateTroons() : void
      {
         var _loc1_:int = g.controlZoneManager.getTotalTroonsPerMinute(g.me.clanId);
         if(core.hud.§components:ButtonClan§.clanLogo == null)
         {
            return;
         }
         core.hud.§components:ButtonClan§.clanLogo.x = 4;
         troonIcon.x = width - 4 - troonIcon.width;
         troonsPerMinute.text = Util.formatAmount(_loc1_) + "/" + Localize.t("m");
         troonsPerMinute.x = troonIcon.x - 2 - troonsPerMinute.width;
      }
   }
}
