package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.PropertyProxy;
   import feathers.data.ListCollection;
   import feathers.layout.FlowLayout;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.ILayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.VerticalLayout;
   import feathers.layout.ViewPortBounds;
   import feathers.skins.IStyleProvider;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class ButtonGroup extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";
      
      protected static const LABEL_FIELD:String = "label";
      
      protected static const ENABLED_FIELD:String = "isEnabled";
      
      private static const DEFAULT_BUTTON_FIELDS:Vector.<String> = new <String>["defaultIcon","upIcon","downIcon","hoverIcon","disabledIcon","defaultSelectedIcon","selectedUpIcon","selectedDownIcon","selectedHoverIcon","selectedDisabledIcon","isSelected","isToggle","isLongPressEnabled","name"];
      
      private static const DEFAULT_BUTTON_EVENTS:Vector.<String> = new <String>["triggered","change","longPress"];
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";
      
      public static const DEFAULT_CHILD_STYLE_NAME_BUTTON:String = "feathers-button-group-button";
       
      
      protected var buttonStyleName:String = "feathers-button-group-button";
      
      protected var firstButtonStyleName:String = "feathers-button-group-button";
      
      protected var lastButtonStyleName:String = "feathers-button-group-button";
      
      protected var activeFirstButton:Button;
      
      protected var inactiveFirstButton:Button;
      
      protected var activeLastButton:Button;
      
      protected var inactiveLastButton:Button;
      
      protected var _layoutItems:Vector.<DisplayObject>;
      
      protected var activeButtons:Vector.<Button>;
      
      protected var inactiveButtons:Vector.<Button>;
      
      protected var _buttonToItem:Dictionary;
      
      protected var _dataProvider:ListCollection;
      
      protected var layout:ILayout;
      
      protected var _viewPortBounds:ViewPortBounds;
      
      protected var _layoutResult:LayoutBoundsResult;
      
      protected var _direction:String = "vertical";
      
      protected var _horizontalAlign:String = "justify";
      
      protected var _verticalAlign:String = "justify";
      
      protected var _distributeButtonSizes:Boolean = true;
      
      protected var _gap:Number = 0;
      
      protected var _firstGap:Number = NaN;
      
      protected var _lastGap:Number = NaN;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _buttonFactory:Function;
      
      protected var _firstButtonFactory:Function;
      
      protected var _lastButtonFactory:Function;
      
      protected var _buttonInitializer:Function;
      
      protected var _buttonReleaser:Function;
      
      protected var _customButtonStyleName:String;
      
      protected var _customFirstButtonStyleName:String;
      
      protected var _customLastButtonStyleName:String;
      
      protected var _buttonProperties:PropertyProxy;
      
      public function ButtonGroup()
      {
         _layoutItems = new Vector.<DisplayObject>(0);
         activeButtons = new Vector.<Button>(0);
         inactiveButtons = new Vector.<Button>(0);
         _buttonToItem = new Dictionary(true);
         _viewPortBounds = new ViewPortBounds();
         _layoutResult = new LayoutBoundsResult();
         _buttonFactory = defaultButtonFactory;
         _buttonInitializer = defaultButtonInitializer;
         _buttonReleaser = defaultButtonReleaser;
         super();
      }
      
      protected static function defaultButtonFactory() : Button
      {
         return new Button();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ButtonGroup.globalStyleProvider;
      }
      
      public function get dataProvider() : ListCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:ListCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener("updateAll",dataProvider_updateAllHandler);
            this._dataProvider.removeEventListener("updateItem",dataProvider_updateItemHandler);
            this._dataProvider.removeEventListener("change",dataProvider_changeHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener("updateAll",dataProvider_updateAllHandler);
            this._dataProvider.addEventListener("updateItem",dataProvider_updateItemHandler);
            this._dataProvider.addEventListener("change",dataProvider_changeHandler);
         }
         this.invalidate("data");
      }
      
      public function get direction() : String
      {
         return _direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(this._direction == param1)
         {
            return;
         }
         this._direction = param1;
         this.invalidate("styles");
      }
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this._horizontalAlign == param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this.invalidate("styles");
      }
      
      public function get verticalAlign() : String
      {
         return _verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign == param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this.invalidate("styles");
      }
      
      public function get distributeButtonSizes() : Boolean
      {
         return this._distributeButtonSizes;
      }
      
      public function set distributeButtonSizes(param1:Boolean) : void
      {
         if(this._distributeButtonSizes == param1)
         {
            return;
         }
         this._distributeButtonSizes = param1;
         this.invalidate("styles");
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
         this.invalidate("styles");
      }
      
      public function get firstGap() : Number
      {
         return this._firstGap;
      }
      
      public function set firstGap(param1:Number) : void
      {
         if(this._firstGap == param1)
         {
            return;
         }
         this._firstGap = param1;
         this.invalidate("styles");
      }
      
      public function get lastGap() : Number
      {
         return this._lastGap;
      }
      
      public function set lastGap(param1:Number) : void
      {
         if(this._lastGap == param1)
         {
            return;
         }
         this._lastGap = param1;
         this.invalidate("styles");
      }
      
      public function get padding() : Number
      {
         return this._paddingTop;
      }
      
      public function set padding(param1:Number) : void
      {
         this.paddingTop = param1;
         this.paddingRight = param1;
         this.paddingBottom = param1;
         this.paddingLeft = param1;
      }
      
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(param1:Number) : void
      {
         if(this._paddingTop == param1)
         {
            return;
         }
         this._paddingTop = param1;
         this.invalidate("styles");
      }
      
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:Number) : void
      {
         if(this._paddingRight == param1)
         {
            return;
         }
         this._paddingRight = param1;
         this.invalidate("styles");
      }
      
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:Number) : void
      {
         if(this._paddingBottom == param1)
         {
            return;
         }
         this._paddingBottom = param1;
         this.invalidate("styles");
      }
      
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:Number) : void
      {
         if(this._paddingLeft == param1)
         {
            return;
         }
         this._paddingLeft = param1;
         this.invalidate("styles");
      }
      
      public function get buttonFactory() : Function
      {
         return this._buttonFactory;
      }
      
      public function set buttonFactory(param1:Function) : void
      {
         if(this._buttonFactory == param1)
         {
            return;
         }
         this._buttonFactory = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get firstButtonFactory() : Function
      {
         return this._firstButtonFactory;
      }
      
      public function set firstButtonFactory(param1:Function) : void
      {
         if(this._firstButtonFactory == param1)
         {
            return;
         }
         this._firstButtonFactory = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get lastButtonFactory() : Function
      {
         return this._lastButtonFactory;
      }
      
      public function set lastButtonFactory(param1:Function) : void
      {
         if(this._lastButtonFactory == param1)
         {
            return;
         }
         this._lastButtonFactory = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get buttonInitializer() : Function
      {
         return this._buttonInitializer;
      }
      
      public function set buttonInitializer(param1:Function) : void
      {
         if(this._buttonInitializer == param1)
         {
            return;
         }
         this._buttonInitializer = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get buttonReleaser() : Function
      {
         return this._buttonReleaser;
      }
      
      public function set buttonReleaser(param1:Function) : void
      {
         if(this._buttonReleaser == param1)
         {
            return;
         }
         this._buttonReleaser = param1;
         this.invalidate("data");
      }
      
      public function get customButtonStyleName() : String
      {
         return this._customButtonStyleName;
      }
      
      public function set customButtonStyleName(param1:String) : void
      {
         if(this._customButtonStyleName == param1)
         {
            return;
         }
         this._customButtonStyleName = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get customFirstButtonStyleName() : String
      {
         return this._customFirstButtonStyleName;
      }
      
      public function set customFirstButtonStyleName(param1:String) : void
      {
         if(this._customFirstButtonStyleName == param1)
         {
            return;
         }
         this._customFirstButtonStyleName = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get customLastButtonStyleName() : String
      {
         return this._customLastButtonStyleName;
      }
      
      public function set customLastButtonStyleName(param1:String) : void
      {
         if(this._customLastButtonStyleName == param1)
         {
            return;
         }
         this._customLastButtonStyleName = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get buttonProperties() : Object
      {
         if(!this._buttonProperties)
         {
            this._buttonProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._buttonProperties;
      }
      
      public function set buttonProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._buttonProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            param1 = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc2_ = new PropertyProxy();
            for(var _loc3_ in param1)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
            param1 = _loc2_;
         }
         if(this._buttonProperties)
         {
            this._buttonProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._buttonProperties = PropertyProxy(param1);
         if(this._buttonProperties)
         {
            this._buttonProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get baseline() : Number
      {
         if(!this.activeButtons || this.activeButtons.length === 0)
         {
            return this.scaledActualHeight;
         }
         var _loc1_:Button = this.activeButtons[0];
         return this.scaleY * (_loc1_.y + _loc1_.baseline);
      }
      
      override public function dispose() : void
      {
         this.dataProvider = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc4_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("state");
         var _loc5_:Boolean = this.isInvalid("buttonFactory");
         var _loc1_:Boolean = this.isInvalid("size");
         if(_loc3_ || _loc2_ || _loc5_)
         {
            this.refreshButtons(_loc5_);
         }
         if(_loc3_ || _loc5_ || _loc4_)
         {
            this.refreshButtonStyles();
         }
         if(_loc3_ || _loc2_ || _loc5_)
         {
            this.commitEnabled();
         }
         if(_loc4_)
         {
            this.refreshLayoutStyles();
         }
         this.layoutButtons();
      }
      
      protected function commitEnabled() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Button = null;
         var _loc2_:int = int(this.activeButtons.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.activeButtons[_loc3_];
            _loc1_.isEnabled &&= this._isEnabled;
            _loc3_++;
         }
      }
      
      protected function refreshButtonStyles() : void
      {
         var _loc3_:Object = null;
         for(var _loc2_ in this._buttonProperties)
         {
            _loc3_ = this._buttonProperties[_loc2_];
            for each(var _loc1_ in this.activeButtons)
            {
               _loc1_[_loc2_] = _loc3_;
            }
         }
      }
      
      protected function refreshLayoutStyles() : void
      {
         var _loc2_:VerticalLayout = null;
         var _loc3_:HorizontalLayout = null;
         var _loc1_:FlowLayout = null;
         if(this._direction == "vertical")
         {
            _loc2_ = this.layout as VerticalLayout;
            if(!_loc2_)
            {
               this.layout = _loc2_ = new VerticalLayout();
            }
            _loc2_.distributeHeights = this._distributeButtonSizes;
            _loc2_.horizontalAlign = this._horizontalAlign;
            _loc2_.verticalAlign = this._verticalAlign == "justify" ? "top" : this._verticalAlign;
            _loc2_.gap = this._gap;
            _loc2_.firstGap = this._firstGap;
            _loc2_.lastGap = this._lastGap;
            _loc2_.paddingTop = this._paddingTop;
            _loc2_.paddingRight = this._paddingRight;
            _loc2_.paddingBottom = this._paddingBottom;
            _loc2_.paddingLeft = this._paddingLeft;
         }
         else if(this._distributeButtonSizes)
         {
            _loc3_ = this.layout as HorizontalLayout;
            if(!_loc3_)
            {
               this.layout = _loc3_ = new HorizontalLayout();
            }
            _loc3_.distributeWidths = true;
            _loc3_.horizontalAlign = this._horizontalAlign == "justify" ? "left" : this._horizontalAlign;
            _loc3_.verticalAlign = this._verticalAlign;
            _loc3_.gap = this._gap;
            _loc3_.firstGap = this._firstGap;
            _loc3_.lastGap = this._lastGap;
            _loc3_.paddingTop = this._paddingTop;
            _loc3_.paddingRight = this._paddingRight;
            _loc3_.paddingBottom = this._paddingBottom;
            _loc3_.paddingLeft = this._paddingLeft;
         }
         else
         {
            _loc1_ = this.layout as FlowLayout;
            if(!_loc1_)
            {
               this.layout = _loc1_ = new FlowLayout();
            }
            _loc1_.horizontalAlign = this._horizontalAlign == "justify" ? "left" : this._horizontalAlign;
            _loc1_.verticalAlign = this._verticalAlign;
            _loc1_.gap = this._gap;
            _loc1_.firstHorizontalGap = this._firstGap;
            _loc1_.lastHorizontalGap = this._lastGap;
            _loc1_.paddingTop = this._paddingTop;
            _loc1_.paddingRight = this._paddingRight;
            _loc1_.paddingBottom = this._paddingBottom;
            _loc1_.paddingLeft = this._paddingLeft;
         }
         if(layout is IVirtualLayout)
         {
            IVirtualLayout(layout).useVirtualLayout = false;
         }
      }
      
      protected function defaultButtonInitializer(param1:Button, param2:Object) : void
      {
         var _loc5_:Boolean = false;
         var _loc4_:Function = null;
         if(param2 is Object)
         {
            if(param2.hasOwnProperty("label"))
            {
               param1.label = param2.label as String;
            }
            else
            {
               param1.label = param2.toString();
            }
            if(param2.hasOwnProperty("isEnabled"))
            {
               param1.isEnabled = param2.isEnabled as Boolean;
            }
            else
            {
               param1.isEnabled = this._isEnabled;
            }
            for each(var _loc3_ in DEFAULT_BUTTON_FIELDS)
            {
               if(param2.hasOwnProperty(_loc3_))
               {
                  param1[_loc3_] = param2[_loc3_];
               }
            }
            for each(_loc3_ in DEFAULT_BUTTON_EVENTS)
            {
               _loc5_ = true;
               if(param2.hasOwnProperty(_loc3_))
               {
                  if((_loc4_ = param2[_loc3_] as Function) === null)
                  {
                     continue;
                  }
                  _loc5_ = false;
                  param1.addEventListener(_loc3_,defaultButtonEventsListener);
               }
               if(_loc5_)
               {
                  param1.removeEventListener(_loc3_,defaultButtonEventsListener);
               }
            }
         }
         else
         {
            param1.label = "";
            param1.isEnabled = this._isEnabled;
         }
      }
      
      protected function defaultButtonReleaser(param1:Button, param2:Object) : void
      {
         var _loc5_:Boolean = false;
         var _loc4_:Function = null;
         param1.label = null;
         for each(var _loc3_ in DEFAULT_BUTTON_FIELDS)
         {
            if(param2.hasOwnProperty(_loc3_))
            {
               param1[_loc3_] = null;
            }
         }
         for each(_loc3_ in DEFAULT_BUTTON_EVENTS)
         {
            _loc5_ = true;
            if(param2.hasOwnProperty(_loc3_))
            {
               if((_loc4_ = param2[_loc3_] as Function) !== null)
               {
                  param1.removeEventListener(_loc3_,defaultButtonEventsListener);
               }
            }
         }
      }
      
      protected function refreshButtons(param1:Boolean) : void
      {
         var _loc5_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:* = null;
         var _loc3_:Vector.<Button> = this.inactiveButtons;
         this.inactiveButtons = this.activeButtons;
         this.activeButtons = _loc3_;
         this.activeButtons.length = 0;
         this._layoutItems.length = 0;
         _loc3_ = null;
         if(param1)
         {
            this.clearInactiveButtons();
         }
         else
         {
            if(this.activeFirstButton)
            {
               this.inactiveButtons.shift();
            }
            this.inactiveFirstButton = this.activeFirstButton;
            if(this.activeLastButton)
            {
               this.inactiveButtons.pop();
            }
            this.inactiveLastButton = this.activeLastButton;
         }
         this.activeFirstButton = null;
         this.activeLastButton = null;
         var _loc7_:int = 0;
         var _loc8_:int;
         var _loc6_:int = (_loc8_ = int(!!this._dataProvider ? this._dataProvider.length : 0)) - 1;
         _loc5_ = 0;
         while(_loc5_ < _loc8_)
         {
            _loc4_ = this._dataProvider.getItemAt(_loc5_);
            if(_loc5_ == 0)
            {
               _loc2_ = this.activeFirstButton = this.createFirstButton(_loc4_);
            }
            else if(_loc5_ == _loc6_)
            {
               _loc2_ = this.activeLastButton = this.createLastButton(_loc4_);
            }
            else
            {
               _loc2_ = this.createButton(_loc4_);
            }
            this.activeButtons[_loc7_] = _loc2_;
            this._layoutItems[_loc7_] = _loc2_;
            _loc7_++;
            _loc5_++;
         }
         this.clearInactiveButtons();
      }
      
      protected function clearInactiveButtons() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Button = null;
         var _loc3_:int = int(this.inactiveButtons.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.inactiveButtons.shift();
            this.destroyButton(_loc1_);
            _loc2_++;
         }
         if(this.inactiveFirstButton)
         {
            this.destroyButton(this.inactiveFirstButton);
            this.inactiveFirstButton = null;
         }
         if(this.inactiveLastButton)
         {
            this.destroyButton(this.inactiveLastButton);
            this.inactiveLastButton = null;
         }
      }
      
      protected function createFirstButton(param1:Object) : Button
      {
         var _loc2_:Button = null;
         var _loc3_:Function = null;
         var _loc4_:Boolean = false;
         if(this.inactiveFirstButton !== null)
         {
            _loc2_ = this.inactiveFirstButton;
            this.releaseButton(_loc2_);
            this.inactiveFirstButton = null;
         }
         else
         {
            _loc4_ = true;
            _loc3_ = this._firstButtonFactory != null ? this._firstButtonFactory : this._buttonFactory;
            _loc2_ = Button(_loc3_());
            if(this._customFirstButtonStyleName)
            {
               _loc2_.styleNameList.add(this._customFirstButtonStyleName);
            }
            else if(this._customButtonStyleName)
            {
               _loc2_.styleNameList.add(this._customButtonStyleName);
            }
            else
            {
               _loc2_.styleNameList.add(this.firstButtonStyleName);
            }
            this.addChild(_loc2_);
         }
         this._buttonInitializer(_loc2_,param1);
         this._buttonToItem[_loc2_] = param1;
         if(_loc4_)
         {
            _loc2_.addEventListener("triggered",button_triggeredHandler);
         }
         return _loc2_;
      }
      
      protected function createLastButton(param1:Object) : Button
      {
         var _loc2_:Button = null;
         var _loc3_:Function = null;
         var _loc4_:Boolean = false;
         if(this.inactiveLastButton !== null)
         {
            _loc2_ = this.inactiveLastButton;
            this.releaseButton(_loc2_);
            this.inactiveLastButton = null;
         }
         else
         {
            _loc4_ = true;
            _loc3_ = this._lastButtonFactory != null ? this._lastButtonFactory : this._buttonFactory;
            _loc2_ = Button(_loc3_());
            if(this._customLastButtonStyleName)
            {
               _loc2_.styleNameList.add(this._customLastButtonStyleName);
            }
            else if(this._customButtonStyleName)
            {
               _loc2_.styleNameList.add(this._customButtonStyleName);
            }
            else
            {
               _loc2_.styleNameList.add(this.lastButtonStyleName);
            }
            this.addChild(_loc2_);
         }
         this._buttonInitializer(_loc2_,param1);
         this._buttonToItem[_loc2_] = param1;
         if(_loc4_)
         {
            _loc2_.addEventListener("triggered",button_triggeredHandler);
         }
         return _loc2_;
      }
      
      protected function createButton(param1:Object) : Button
      {
         var _loc2_:Button = null;
         var _loc3_:Boolean = false;
         if(this.inactiveButtons.length === 0)
         {
            _loc3_ = true;
            _loc2_ = this._buttonFactory();
            if(this._customButtonStyleName)
            {
               _loc2_.styleNameList.add(this._customButtonStyleName);
            }
            else
            {
               _loc2_.styleNameList.add(this.buttonStyleName);
            }
            this.addChild(_loc2_);
         }
         else
         {
            _loc2_ = this.inactiveButtons.shift();
            this.releaseButton(_loc2_);
         }
         this._buttonInitializer(_loc2_,param1);
         this._buttonToItem[_loc2_] = param1;
         if(_loc3_)
         {
            _loc2_.addEventListener("triggered",button_triggeredHandler);
         }
         return _loc2_;
      }
      
      protected function releaseButton(param1:Button) : void
      {
         var _loc2_:Object = this._buttonToItem[param1];
         delete this._buttonToItem[param1];
         if(this._buttonReleaser.length === 1)
         {
            this._buttonReleaser(param1);
         }
         else
         {
            this._buttonReleaser(param1,_loc2_);
         }
      }
      
      protected function destroyButton(param1:Button) : void
      {
         param1.removeEventListener("triggered",button_triggeredHandler);
         this.releaseButton(param1);
         this.removeChild(param1,true);
      }
      
      protected function layoutButtons() : void
      {
         this._viewPortBounds.x = 0;
         this._viewPortBounds.y = 0;
         this._viewPortBounds.scrollX = 0;
         this._viewPortBounds.scrollY = 0;
         this._viewPortBounds.explicitWidth = this._explicitWidth;
         this._viewPortBounds.explicitHeight = this._explicitHeight;
         this._viewPortBounds.minWidth = this._explicitMinWidth;
         this._viewPortBounds.minHeight = this._explicitMinHeight;
         this._viewPortBounds.maxWidth = this._explicitMaxWidth;
         this._viewPortBounds.maxHeight = this._explicitMaxHeight;
         this.layout.layout(this._layoutItems,this._viewPortBounds,this._layoutResult);
         var _loc2_:Number = this._layoutResult.contentWidth;
         var _loc3_:Number = this._layoutResult.contentHeight;
         this.saveMeasurements(_loc2_,_loc3_,_loc2_,_loc3_);
         for each(var _loc1_ in this.activeButtons)
         {
            _loc1_.validate();
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      protected function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate("data");
      }
      
      protected function dataProvider_updateAllHandler(param1:Event) : void
      {
         this.invalidate("data");
      }
      
      protected function dataProvider_updateItemHandler(param1:Event, param2:int) : void
      {
         this.invalidate("data");
      }
      
      protected function button_triggeredHandler(param1:Event) : void
      {
         if(!this._dataProvider || !this.activeButtons)
         {
            return;
         }
         var _loc2_:Button = Button(param1.currentTarget);
         var _loc4_:int = this.activeButtons.indexOf(_loc2_);
         var _loc3_:Object = this._dataProvider.getItemAt(_loc4_);
         this.dispatchEventWith("triggered",false,_loc3_);
      }
      
      protected function defaultButtonEventsListener(param1:Event) : void
      {
         var _loc6_:Function = null;
         var _loc5_:int = 0;
         var _loc2_:Button = Button(param1.currentTarget);
         var _loc7_:int = this.activeButtons.indexOf(_loc2_);
         var _loc3_:Object = this._dataProvider.getItemAt(_loc7_);
         var _loc4_:String = param1.type;
         if(_loc3_.hasOwnProperty(_loc4_))
         {
            if((_loc6_ = _loc3_[_loc4_] as Function) == null)
            {
               return;
            }
            switch((_loc5_ = _loc6_.length) - 1)
            {
               case 0:
                  _loc6_(param1);
                  break;
               case 1:
                  _loc6_(param1,param1.data);
                  break;
               case 2:
                  _loc6_(param1,param1.data,_loc3_);
                  break;
               default:
                  _loc6_();
            }
         }
      }
   }
}
