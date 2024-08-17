package core.states.gameStates
{
   import core.hud.components.InputText;
   import core.hud.components.Line;
   import core.hud.components.Text;
   import core.scene.Game;
   import core.scene.SceneBase;
   import data.Settings;
   import feathers.controls.Check;
   import feathers.controls.ScrollContainer;
   import feathers.controls.Slider;
   import generics.Localize;
   import goki.PlayerConfig;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class SettingsGeneral extends Sprite
   {
      
      private static const START_HEIGHT:int = 10;
      
      private static const START_WIDTH:int = 50;
       
      
      private var g:Game;
      
      private var currentHeight:Number = 10;
      
      private var currentWidth:Number = 50;
      
      private var settings:Settings;
      
      private var musicSlider:Slider;
      
      private var effectSlider:Slider;
      
      private var showHud:Check;
      
      private var showEffects:Check;
      
      private var showLatency:Check;
      
      private var showBackground:Check;
      
      private var mouseAim:Check;
      
      private var keyboardAim:Check;
      
      private var rotationSlider:Slider;
      
      private var rotationSpeedText:Text;
      
      private var dmgTextSizeSlider:Slider;
      
      private var iWantAllTimedMissions:Check;
      
      private var hpshBarSizeSlider:Slider;
      
      private var hpshBarsAlwaysOn:Check;
      
      private var fireWithHotkeys:Check;
      
      private var showAllEncounters:Check;
      
      private var scrollArea:ScrollContainer;
      
      private var nMessagesInput:InputText;
      
      private var censorChat:Check;

      private var dontKick:Check;
      
      private var disableScreenShake:Check;

      private var autoReload:Check;

      public function SettingsGeneral(param1:Game)
      {
         super();
         this.g = param1;
         this.settings = SceneBase.settings;
         scrollArea = new ScrollContainer();
         scrollArea.y = 50;
         scrollArea.x = 10;
         scrollArea.width = 700;
         scrollArea.height = 500;
         initComponents();
         addChild(scrollArea);
      }
      
      private function initComponents() : void
      {
         var rotationValue:Number;
         if(g.me.isTranslator || g.me.isDeveloper)
         {
            addLanguage();
         }
         addHeader("Sound");
         musicSlider = new Slider();
         addSlider(musicSlider,settings.musicVolume,Localize.t("Music Volume"));
         musicSlider.addEventListener("change",function(param1:Event):void
         {
            settings.musicVolume = musicSlider.value;
         });
         effectSlider = new Slider();
         addSlider(effectSlider,settings.effectVolume,Localize.t("Effect Volume"));
         effectSlider.addEventListener("change",function(param1:Event):void
         {
            settings.effectVolume = effectSlider.value;
         });
         addHeader("Graphics");
         showHud = new Check();
         showHud.isSelected = settings.showHud;
         showHud.addEventListener("change",function(param1:Event):void
         {
            settings.showHud = showHud.isSelected;
         });
         addCheckbox(showHud,Localize.t("Show Hud"));
         showLatency = new Check();
         showLatency.isSelected = settings.showLatency;
         showLatency.addEventListener("change",function(param1:Event):void
         {
            settings.showLatency = showLatency.isSelected;
         });
         addCheckbox(showLatency,Localize.t("Show Latency/fps"));
         showEffects = new Check();
         showEffects.isSelected = settings.showEffects;
         showEffects.addEventListener("change",function(param1:Event):void
         {
            settings.showEffects = showEffects.isSelected;
            g.toggleHighGraphics(settings.showEffects);
         });
         addCheckbox(showEffects,Localize.t("High graphic settings"));
         showBackground = new Check();
         showBackground.isSelected = settings.showBackground;
         showBackground.addEventListener("change",function(param1:Event):void
         {
            settings.showBackground = showBackground.isSelected;
            g.parallaxManager.refresh();
         });
         addCheckbox(showBackground,Localize.t("Show Background"));
         mouseAim = new Check();
         mouseAim.isSelected = !settings.mouseAim;
         mouseAim.addEventListener("change",function(param1:Event):void
         {
            settings.mouseAim = !mouseAim.isSelected;
         });
         addHeader("Controls");
         addCheckbox(mouseAim,Localize.t("Disable Mouse Aim"));
         fireWithHotkeys = new Check();
         fireWithHotkeys.isSelected = settings.fireWithHotkeys;
         fireWithHotkeys.addEventListener("change",function(param1:Event):void
         {
            settings.fireWithHotkeys = fireWithHotkeys.isSelected;
         });
         addCheckbox(fireWithHotkeys,Localize.t("Fire with Weapon Hotkeys"));
         rotationSlider = new Slider();
         rotationValue = (settings.rotationSpeed - 0.75) * 2;
         addSlider(rotationSlider,rotationValue,Localize.t("Player Rotation Speed"));
         rotationSlider.addEventListener("change",function(param1:Event):void
         {
            settings.rotationSpeed = 0.75 + 0.5 * rotationSlider.value;
            rotationSpeedText.text = settings.rotationSpeed.toFixed(2);
         });
         rotationSpeedText = new Text(rotationSlider.x + 120,rotationSlider.y + 10);
         rotationSpeedText.text = settings.rotationSpeed.toFixed(2);
         scrollArea.addChild(rotationSpeedText);
         addHeader("Misc");
         iWantAllTimedMissions = new Check();
         iWantAllTimedMissions.isSelected = settings.iWantAllTimedMissions;
         iWantAllTimedMissions.addEventListener("change",function(param1:Event):void
         {
            settings.iWantAllTimedMissions = iWantAllTimedMissions.isSelected;
         });
         addCheckbox(iWantAllTimedMissions,Localize.t("I want all timed missions"));
         showAllEncounters = new Check();
         showAllEncounters.isSelected = PlayerConfig.values.showAllEncounters;
         showAllEncounters.addEventListener("change",function(param1:Event):void
         {
            PlayerConfig.values.showAllEncounters = showAllEncounters.isSelected;
         });
         addCheckbox(showAllEncounters,Localize.t("Show all encounters"));
         currentHeight = 10;
         currentWidth = 380;
         addHeader("Gameplay");
         hpshBarsAlwaysOn = new Check();
         hpshBarsAlwaysOn.isSelected = PlayerConfig.values.barAlwaysShow;
         hpshBarsAlwaysOn.addEventListener("change",function(param1:Event):void
         {
            PlayerConfig.values.barAlwaysShow = hpshBarsAlwaysOn.isSelected;
         });
         addCheckbox(hpshBarsAlwaysOn,Localize.t("Always show SH/HP bars"));
         hpshBarSizeSlider = new Slider();
         addSlider(hpshBarSizeSlider,(PlayerConfig.values.barSize - 1) * 0.25,Localize.t("SH/HP Bars scale"));
         hpshBarSizeSlider.addEventListener("change",function(param1:Event):void
         {
            PlayerConfig.values.barSize = 1 + hpshBarSizeSlider.value * 4;
         });
         dmgTextSizeSlider = new Slider();
         addSlider(dmgTextSizeSlider,(PlayerConfig.values.dmgTextSize - 1) * 0.5,Localize.t("Damage text scale"));
         dmgTextSizeSlider.addEventListener("change",function(param1:Event):void
         {
            PlayerConfig.values.dmgTextSize = 1 + dmgTextSizeSlider.value * 2;
         });
         dontKick = new Check();
         dontKick.isSelected = PlayerConfig.values.dontKick;
         dontKick.addEventListener("change",function(param1:Event):void
         {
            PlayerConfig.values.dontKick = dontKick.isSelected;
         });
         addCheckbox(dontKick, "Don't kick");
         disableScreenShake = new Check();
         disableScreenShake.isSelected = PlayerConfig.values.disableScreenShake;
         disableScreenShake.addEventListener("change",function(param1:Event):void
         {
            PlayerConfig.values.disableScreenShake = disableScreenShake.isSelected;
         });
         addCheckbox(disableScreenShake, "Disable camera shake");
         autoReload = new Check();
         autoReload.isSelected = PlayerConfig.values.autoReload;
         autoReload.addEventListener("change",function(param1:Event):void
         {
            PlayerConfig.values.autoReload = autoReload.isSelected;
         });
         addCheckbox(autoReload, "Automatically reload when disconnected");
         addHeader("Chat");
         nMessagesInput = new InputText(currentWidth + 256,currentHeight - 4,40,20);
         nMessagesInput.addEventListener("change",function(param1:Event):void
         {
            PlayerConfig.values.maxChatMessages = nMessagesInput.text;
         });
         addInputField("Max chat messages",nMessagesInput);
         censorChat = new Check();
         censorChat.isSelected = PlayerConfig.values.censorChat;
         censorChat.addEventListener("change",function(param1:Event):void
         {
            PlayerConfig.values.censorChat = censorChat.isSelected;
         });
         addCheckbox(censorChat,"Censor profanities");
      }
      
      private function addInputField(str:String, field:InputText) : void
      {
         field.text = PlayerConfig.values.maxChatMessages;
         var desc:Text = new Text(currentWidth + 2,currentHeight,false,"Verdana");
         desc.text = str;
         addFieldRim(field);
         addLine(desc.x + desc.width + 4,field.x - 5);
         scrollArea.addChild(desc);
         scrollArea.addChild(field);
         currentHeight += 30;
      }
      
      private function addFieldRim(field:InputText) : void
      {
         var topFill:Quad = new Quad(field.width + 2,field.height * 0.5 + 1,13948116);
         var botFill:Quad = new Quad(field.width + 2,field.height * 0.5 + 1,11053224);
         topFill.x = field.x - 1;
         topFill.y = field.y - 1;
         botFill.x = field.x - 1;
         botFill.y = field.y + field.height * 0.5;
         scrollArea.addChild(topFill);
         scrollArea.addChild(botFill);
      }
      
      private function addCheckbox(param1:Check, param2:String) : void
      {
         var _loc3_:Text = new Text(currentWidth + 2,currentHeight,false,"Verdana");
         _loc3_.text = param2;
         param1.x = currentWidth + 286;
         param1.y = currentHeight - 4;
         param1.useHandCursor = true;
         addLine(_loc3_.x + _loc3_.width + 4,param1.x - 5);
         scrollArea.addChild(_loc3_);
         scrollArea.addChild(param1);
         currentHeight += 30;
      }
      
      private function addLine(start:int, end:int) : void
      {
         var line:Line = new Line();
         line.x = start;
         line.y = currentHeight + 10;
         line.lineTo(end,currentHeight + 10);
         line.thickness = 3;
         line.color = 3684408;
         scrollArea.addChild(line);
      }
      
      private function addHeader(param1:String) : void
      {
         var head:Text = new Text(currentWidth - 8,currentHeight);
         var line:Line = new Line();
         head.text = param1;
         head.size = 20;
         head.color = 16689475;
         line.x = head.x + head.width + 4;
         line.y = currentHeight + 12;
         line.lineTo(currentWidth + 310,currentHeight + 12);
         line.thickness = 4;
         line.color = 7039851;
         scrollArea.addChild(head);
         scrollArea.addChild(line);
         currentHeight += 40;
      }
      
      private function addSlider(param1:Slider, param2:Number, param3:String) : void
      {
         param1.minimum = 0;
         param1.maximum = 1;
         param1.step = 0.1;
         param1.value = param2;
         param1.direction = "horizontal";
         param1.useHandCursor = true;
         var _loc4_:Text = new Text(currentWidth + 2,currentHeight,false,"Verdana");
         _loc4_.text = param3;
         param1.x = currentWidth + 140;
         param1.y = currentHeight;
         scrollArea.addChild(_loc4_);
         scrollArea.addChild(param1);
         currentHeight += 30;
      }
   }
}
