package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.core.PropertyProxy;
   import feathers.data.ListCollection;
   import feathers.layout.VerticalLayout;
   import feathers.skins.IStyleProvider;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class Alert extends Panel
   {
      
      public static const DEFAULT_CHILD_STYLE_NAME_HEADER:String = "feathers-alert-header";
      
      public static const DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP:String = "feathers-alert-button-group";
      
      public static const DEFAULT_CHILD_STYLE_NAME_MESSAGE:String = "feathers-alert-message";
      
      public static var overlayFactory:Function;
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static var alertFactory:Function = defaultAlertFactory;
       
      
      protected var messageStyleName:String = "feathers-alert-message";
      
      protected var headerHeader:Header;
      
      protected var buttonGroupFooter:ButtonGroup;
      
      protected var messageTextRenderer:ITextRenderer;
      
      protected var _message:String = null;
      
      protected var _icon:DisplayObject;
      
      protected var _gap:Number = 0;
      
      protected var _buttonsDataProvider:ListCollection;
      
      protected var _messageFactory:Function;
      
      protected var _messageProperties:PropertyProxy;
      
      protected var _customMessageStyleName:String;
      
      public function Alert()
      {
         super();
         this.headerStyleName = "feathers-alert-header";
         this.footerStyleName = "feathers-alert-button-group";
         this.buttonGroupFactory = defaultButtonGroupFactory;
      }
      
      public static function defaultAlertFactory() : Alert
      {
         return new Alert();
      }
      
      public static function show(param1:String, param2:String = null, param3:ListCollection = null, param4:DisplayObject = null, param5:Boolean = true, param6:Boolean = true, param7:Function = null, param8:Function = null) : Alert
      {
         var _loc9_:*;
         if((_loc9_ = param7) == null)
         {
            _loc9_ = alertFactory != null ? alertFactory : defaultAlertFactory;
         }
         var _loc10_:Alert;
         (_loc10_ = Alert(_loc9_())).title = param2;
         _loc10_.message = param1;
         _loc10_.buttonsDataProvider = param3;
         _loc10_.icon = param4;
         if((_loc9_ = param8) == null)
         {
            _loc9_ = overlayFactory;
         }
         PopUpManager.addPopUp(_loc10_,param5,param6,_loc9_);
         return _loc10_;
      }
      
      protected static function defaultButtonGroupFactory() : ButtonGroup
      {
         return new ButtonGroup();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Alert.globalStyleProvider;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function set message(param1:String) : void
      {
         if(this._message == param1)
         {
            return;
         }
         this._message = param1;
         this.invalidate("data");
      }
      
      public function get icon() : DisplayObject
      {
         return this._icon;
      }
      
      public function set icon(param1:DisplayObject) : void
      {
         if(this._icon == param1)
         {
            return;
         }
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         if(this._icon)
         {
            this._icon.removeEventListener("resize",icon_resizeHandler);
            this.removeChild(this._icon);
         }
         this._icon = param1;
         if(this._icon)
         {
            this._icon.addEventListener("resize",icon_resizeHandler);
            this.addChild(this._icon);
         }
         this.displayListBypassEnabled = _loc2_;
         this.invalidate("data");
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         if(this._gap == param1)
         {
            return;
         }
         this._gap = param1;
         this.invalidate("layout");
      }
      
      public function get buttonsDataProvider() : ListCollection
      {
         return this._buttonsDataProvider;
      }
      
      public function set buttonsDataProvider(param1:ListCollection) : void
      {
         if(this._buttonsDataProvider == param1)
         {
            return;
         }
         this._buttonsDataProvider = param1;
         this.invalidate("styles");
      }
      
      public function get messageFactory() : Function
      {
         return this._messageFactory;
      }
      
      public function set messageFactory(param1:Function) : void
      {
         if(this._messageFactory == param1)
         {
            return;
         }
         this._messageFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get messageProperties() : Object
      {
         if(!this._messageProperties)
         {
            this._messageProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._messageProperties;
      }
      
      public function set messageProperties(param1:Object) : void
      {
         if(this._messageProperties == param1)
         {
            return;
         }
         if(param1 && !(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._messageProperties)
         {
            this._messageProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._messageProperties = PropertyProxy(param1);
         if(this._messageProperties)
         {
            this._messageProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get customMessageStyleName() : String
      {
         return this._customMessageStyleName;
      }
      
      public function set customMessageStyleName(param1:String) : void
      {
         if(this._customMessageStyleName == param1)
         {
            return;
         }
         this._customMessageStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      public function get buttonGroupFactory() : Function
      {
         return super.footerFactory;
      }
      
      public function set buttonGroupFactory(param1:Function) : void
      {
         super.footerFactory = param1;
      }
      
      public function get customButtonGroupStyleName() : String
      {
         return super.customFooterStyleName;
      }
      
      public function set customButtonGroupStyleName(param1:String) : void
      {
         super.customFooterStyleName = param1;
      }
      
      public function get buttonGroupProperties() : Object
      {
         return super.footerProperties;
      }
      
      public function set buttonGroupProperties(param1:Object) : void
      {
         super.footerProperties = param1;
      }
      
      override protected function initialize() : void
      {
         var _loc1_:VerticalLayout = null;
         if(!this.layout)
         {
            _loc1_ = new VerticalLayout();
            _loc1_.horizontalAlign = "justify";
            this.layout = _loc1_;
         }
         super.initialize();
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("textRenderer");
         if(_loc1_)
         {
            this.createMessage();
         }
         if(_loc1_ || _loc2_)
         {
            this.messageTextRenderer.text = this._message;
         }
         if(_loc1_ || _loc3_)
         {
            this.refreshMessageStyles();
         }
         super.draw();
         if(this._icon)
         {
            if(this._icon is IValidating)
            {
               IValidating(this._icon).validate();
            }
            this._icon.x = this._paddingLeft;
            this._icon.y = this._topViewPortOffset + (this._viewPort.visibleHeight - this._icon.height) / 2;
         }
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc5_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc7_:Number = NaN;
         if(this._autoSizeMode === "stage")
         {
            return super.autoSizeIfNeeded();
         }
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc12_:* = this._explicitHeight !== this._explicitHeight;
         var _loc10_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc14_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc3_ && !_loc12_ && !_loc10_ && !_loc14_)
         {
            return false;
         }
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc6_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         if(this._icon is IValidating)
         {
            IValidating(this._icon).validate();
         }
         var _loc2_:* = this._explicitWidth;
         var _loc4_:* = this._explicitHeight;
         var _loc9_:* = this._explicitMinWidth;
         var _loc11_:* = this._explicitMinHeight;
         if(_loc3_)
         {
            if(this._measureViewPort)
            {
               _loc2_ = this._viewPort.visibleWidth;
            }
            else
            {
               _loc2_ = 0;
            }
            _loc2_ += this._rightViewPortOffset + this._leftViewPortOffset;
            if((_loc5_ = this.header.width + this._outerPaddingLeft + this._outerPaddingRight) > _loc2_)
            {
               _loc2_ = _loc5_;
            }
            if(this.footer !== null)
            {
               if((_loc8_ = this.footer.width + this._outerPaddingLeft + this._outerPaddingRight) > _loc2_)
               {
                  _loc2_ = _loc8_;
               }
            }
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.width > _loc2_)
            {
               _loc2_ = this.currentBackgroundSkin.width;
            }
         }
         if(_loc12_)
         {
            if(this._measureViewPort)
            {
               _loc4_ = this._viewPort.visibleHeight;
            }
            else
            {
               _loc4_ = 0;
            }
            if(this._icon !== null)
            {
               _loc1_ = this._icon.height;
               if(_loc1_ === _loc1_ && _loc1_ > _loc4_)
               {
                  _loc4_ = _loc1_;
               }
            }
            _loc4_ += this._bottomViewPortOffset + this._topViewPortOffset;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.height > _loc4_)
            {
               _loc4_ = this.currentBackgroundSkin.height;
            }
         }
         if(_loc10_)
         {
            if(this._measureViewPort)
            {
               _loc9_ = this._viewPort.minVisibleWidth;
            }
            else
            {
               _loc9_ = 0;
            }
            _loc9_ += this._rightViewPortOffset + this._leftViewPortOffset;
            if((_loc13_ = this.header.minWidth + this._outerPaddingLeft + this._outerPaddingRight) > _loc9_)
            {
               _loc9_ = _loc13_;
            }
            if(this.footer !== null)
            {
               if((_loc7_ = this.footer.minWidth + this._outerPaddingLeft + this._outerPaddingRight) > _loc9_)
               {
                  _loc9_ = _loc7_;
               }
            }
            switch(_loc6_)
            {
               default:
                  if(_loc6_.minWidth > _loc9_)
                  {
                     _loc9_ = _loc6_.minWidth;
                  }
                  break;
               case null:
                  if(this._explicitBackgroundMinWidth > _loc9_)
                  {
                     _loc9_ = this._explicitBackgroundMinWidth;
                  }
                  break;
               case null:
            }
         }
         if(_loc14_)
         {
            if(this._measureViewPort)
            {
               _loc11_ = this._viewPort.minVisibleHeight;
            }
            else
            {
               _loc11_ = 0;
            }
            if(this._icon !== null)
            {
               _loc1_ = this._icon.height;
               if(_loc1_ === _loc1_ && _loc1_ > _loc11_)
               {
                  _loc11_ = _loc1_;
               }
            }
            _loc11_ += this._bottomViewPortOffset + this._topViewPortOffset;
            switch(_loc6_)
            {
               default:
                  if(_loc6_.minHeight > _loc11_)
                  {
                     _loc11_ = _loc6_.minHeight;
                  }
                  break;
               case null:
                  if(this._explicitBackgroundMinHeight > _loc11_)
                  {
                     _loc11_ = this._explicitBackgroundMinHeight;
                  }
                  break;
               case null:
            }
         }
         return this.saveMeasurements(_loc2_,_loc4_,_loc9_,_loc11_);
      }
      
      override protected function createHeader() : void
      {
         super.createHeader();
         this.headerHeader = Header(this.header);
      }
      
      protected function createButtonGroup() : void
      {
         if(this.buttonGroupFooter)
         {
            this.buttonGroupFooter.removeEventListener("triggered",buttonsFooter_triggeredHandler);
         }
         super.createFooter();
         this.buttonGroupFooter = ButtonGroup(this.footer);
         this.buttonGroupFooter.addEventListener("triggered",buttonsFooter_triggeredHandler);
      }
      
      override protected function createFooter() : void
      {
         this.createButtonGroup();
      }
      
      protected function createMessage() : void
      {
         if(this.messageTextRenderer)
         {
            this.removeChild(DisplayObject(this.messageTextRenderer),true);
            this.messageTextRenderer = null;
         }
         var _loc1_:Function = this._messageFactory != null ? this._messageFactory : FeathersControl.defaultTextRendererFactory;
         this.messageTextRenderer = ITextRenderer(_loc1_());
         var _loc2_:String = this._customMessageStyleName != null ? this._customMessageStyleName : this.messageStyleName;
         var _loc3_:IFeathersControl = IFeathersControl(this.messageTextRenderer);
         _loc3_.styleNameList.add(_loc2_);
         _loc3_.touchable = false;
         this.addChild(DisplayObject(this.messageTextRenderer));
      }
      
      override protected function refreshFooterStyles() : void
      {
         super.refreshFooterStyles();
         this.buttonGroupFooter.dataProvider = this._buttonsDataProvider;
      }
      
      protected function refreshMessageStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._messageProperties)
         {
            _loc2_ = this._messageProperties[_loc1_];
            this.messageTextRenderer[_loc1_] = _loc2_;
         }
      }
      
      override protected function calculateViewPortOffsets(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         super.calculateViewPortOffsets(param1,param2);
         if(this._icon !== null)
         {
            if(this._icon is IValidating)
            {
               IValidating(this._icon).validate();
            }
            _loc3_ = this._icon.width;
            if(_loc3_ === _loc3_)
            {
               this._leftViewPortOffset += _loc3_ + this._gap;
            }
         }
      }
      
      protected function buttonsFooter_triggeredHandler(param1:Event, param2:Object) : void
      {
         this.removeFromParent();
         this.dispatchEventWith("close",false,param2);
         this.dispose();
      }
      
      protected function icon_resizeHandler(param1:Event) : void
      {
         this.invalidate("layout");
      }
   }
}
