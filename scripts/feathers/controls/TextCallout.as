package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IToolTip;
   import feathers.core.PopUpManager;
   import feathers.skins.IStyleProvider;
   import starling.display.DisplayObject;
   import starling.events.EnterFrameEvent;
   
   public class TextCallout extends Callout implements IToolTip
   {
      
      public static const DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER:String = "feathers-text-callout-text-renderer";
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static var calloutFactory:Function = defaultCalloutFactory;
       
      
      protected var textRenderer:ITextRenderer;
      
      protected var textRendererStyleName:String = "feathers-text-callout-text-renderer";
      
      protected var _text:String;
      
      protected var _wordWrap:Boolean = true;
      
      protected var _textRendererFactory:Function;
      
      protected var _customTextRendererStyleName:String;
      
      public function TextCallout()
      {
         super();
         this.isQuickHitAreaEnabled = true;
      }
      
      public static function defaultCalloutFactory() : TextCallout
      {
         var _loc1_:TextCallout = new TextCallout();
         _loc1_.closeOnTouchBeganOutside = true;
         _loc1_.closeOnTouchEndedOutside = true;
         _loc1_.closeOnKeys = new <uint>[16777238,27];
         return _loc1_;
      }
      
      public static function show(param1:String, param2:DisplayObject, param3:Vector.<String> = null, param4:Boolean = true, param5:Function = null, param6:Function = null) : TextCallout
      {
         if(!param2.stage)
         {
            throw new ArgumentError("TextCallout origin must be added to the stage.");
         }
         var _loc7_:*;
         if((_loc7_ = param5) === null)
         {
            if((_loc7_ = calloutFactory) === null)
            {
               _loc7_ = defaultCalloutFactory;
            }
         }
         var _loc8_:TextCallout;
         (_loc8_ = TextCallout(_loc7_())).text = param1;
         _loc8_.supportedPositions = param3;
         _loc8_.origin = param2;
         if((_loc7_ = param6) == null)
         {
            if((_loc7_ = calloutOverlayFactory) == null)
            {
               _loc7_ = PopUpManager.defaultOverlayFactory;
            }
         }
         PopUpManager.addPopUp(_loc8_,param4,false,_loc7_);
         _loc8_.validate();
         return _loc8_;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._text === param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate("data");
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this._wordWrap == param1)
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate("styles");
      }
      
      public function get textRendererFactory() : Function
      {
         return this._textRendererFactory;
      }
      
      public function set textRendererFactory(param1:Function) : void
      {
         if(this._textRendererFactory == param1)
         {
            return;
         }
         this._textRendererFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get customTextRendererStyleName() : String
      {
         return this._customTextRendererStyleName;
      }
      
      public function set customTextRendererStyleName(param1:String) : void
      {
         if(this._customTextRendererStyleName == param1)
         {
            return;
         }
         this._customTextRendererStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         if(TextCallout.globalStyleProvider !== null)
         {
            return TextCallout.globalStyleProvider;
         }
         return Callout.globalStyleProvider;
      }
      
      override protected function draw() : void
      {
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc1_:Boolean = this.isInvalid("state");
         var _loc4_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("textRenderer");
         if(_loc2_)
         {
            this.createTextRenderer();
         }
         if(_loc2_ || _loc3_ || _loc1_)
         {
            this.refreshTextRendererData();
         }
         if(_loc2_ || _loc4_)
         {
            this.refreshTextRendererStyles();
         }
         super.draw();
      }
      
      protected function createTextRenderer() : void
      {
         if(this.textRenderer !== null)
         {
            this.removeChild(DisplayObject(this.textRenderer),true);
            this.textRenderer = null;
         }
         var _loc1_:Function = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
         this.textRenderer = ITextRenderer(_loc1_());
         var _loc2_:String = this._customTextRendererStyleName !== null ? this._customTextRendererStyleName : this.textRendererStyleName;
         this.textRenderer.styleNameList.add(_loc2_);
         this.content = DisplayObject(this.textRenderer);
      }
      
      protected function refreshTextRendererData() : void
      {
         this.textRenderer.text = this._text;
         this.textRenderer.visible = this._text && this._text.length > 0;
      }
      
      protected function refreshTextRendererStyles() : void
      {
         this.textRenderer.wordWrap = this._wordWrap;
      }
      
      override protected function callout_enterFrameHandler(param1:EnterFrameEvent) : void
      {
         if(this.isCreated)
         {
            this.positionRelativeToOrigin();
         }
      }
   }
}
