package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ViewPortBounds;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.display.Stage;
   import flash.events.FullScreenEvent;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class Header extends FeathersControl
   {
      
      protected static const INVALIDATION_FLAG_LEFT_CONTENT:String = "leftContent";
      
      protected static const INVALIDATION_FLAG_RIGHT_CONTENT:String = "rightContent";
      
      protected static const INVALIDATION_FLAG_CENTER_CONTENT:String = "centerContent";
      
      protected static const IOS_STATUS_BAR_HEIGHT:Number = 20;
      
      protected static const IPAD_1X_DPI:Number = 132;
      
      protected static const IPHONE_1X_DPI:Number = 163;
      
      protected static const IOS_NAME_PREFIX:String = "iPhone OS ";
      
      protected static const STATUS_BAR_MIN_IOS_VERSION:int = 7;
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const TITLE_ALIGN_CENTER:String = "center";
      
      public static const TITLE_ALIGN_PREFER_LEFT:String = "preferLeft";
      
      public static const TITLE_ALIGN_PREFER_RIGHT:String = "preferRight";
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ITEM:String = "feathers-header-item";
      
      public static const DEFAULT_CHILD_STYLE_NAME_TITLE:String = "feathers-header-title";
      
      private static const HELPER_BOUNDS:ViewPortBounds = new ViewPortBounds();
      
      private static const HELPER_LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();
      
      private static const HELPER_POINT:Point = new Point();
       
      
      protected var titleTextRenderer:ITextRenderer;
      
      protected var titleStyleName:String = "feathers-header-title";
      
      protected var itemStyleName:String = "feathers-header-item";
      
      protected var leftItemsWidth:Number = 0;
      
      protected var rightItemsWidth:Number = 0;
      
      protected var _layout:HorizontalLayout;
      
      protected var _title:String = null;
      
      protected var _titleFactory:Function;
      
      protected var _disposeItems:Boolean = true;
      
      protected var _leftItems:Vector.<DisplayObject>;
      
      protected var _centerItems:Vector.<DisplayObject>;
      
      protected var _rightItems:Vector.<DisplayObject>;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _gap:Number = 0;
      
      protected var _titleGap:Number = NaN;
      
      protected var _useExtraPaddingForOSStatusBar:Boolean = false;
      
      protected var _verticalAlign:String = "middle";
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _customTitleStyleName:String;
      
      protected var _titleProperties:PropertyProxy;
      
      protected var _titleAlign:String = "center";
      
      public function Header()
      {
         super();
         this.addEventListener("addedToStage",header_addedToStageHandler);
         this.addEventListener("removedFromStage",header_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Header.globalStyleProvider;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         if(this._title === param1)
         {
            return;
         }
         this._title = param1;
         this.invalidate("data");
      }
      
      public function get titleFactory() : Function
      {
         return this._titleFactory;
      }
      
      public function set titleFactory(param1:Function) : void
      {
         if(this._titleFactory == param1)
         {
            return;
         }
         this._titleFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get disposeItems() : Boolean
      {
         return this._disposeItems;
      }
      
      public function set disposeItems(param1:Boolean) : void
      {
         this._disposeItems = param1;
      }
      
      public function get leftItems() : Vector.<DisplayObject>
      {
         return this._leftItems;
      }
      
      public function set leftItems(param1:Vector.<DisplayObject>) : void
      {
         if(this._leftItems == param1)
         {
            return;
         }
         if(this._leftItems)
         {
            for each(var _loc2_ in this._leftItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).styleNameList.remove(this.itemStyleName);
                  _loc2_.removeEventListener("resize",item_resizeHandler);
               }
               _loc2_.removeFromParent();
            }
         }
         this._leftItems = param1;
         if(this._leftItems)
         {
            for each(_loc2_ in this._leftItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  _loc2_.addEventListener("resize",item_resizeHandler);
               }
            }
         }
         this.invalidate("leftContent");
      }
      
      public function get centerItems() : Vector.<DisplayObject>
      {
         return this._centerItems;
      }
      
      public function set centerItems(param1:Vector.<DisplayObject>) : void
      {
         if(this._centerItems == param1)
         {
            return;
         }
         if(this._centerItems)
         {
            for each(var _loc2_ in this._centerItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).styleNameList.remove(this.itemStyleName);
                  _loc2_.removeEventListener("resize",item_resizeHandler);
               }
               _loc2_.removeFromParent();
            }
         }
         this._centerItems = param1;
         if(this._centerItems)
         {
            for each(_loc2_ in this._centerItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  _loc2_.addEventListener("resize",item_resizeHandler);
               }
            }
         }
         this.invalidate("centerContent");
      }
      
      public function get rightItems() : Vector.<DisplayObject>
      {
         return this._rightItems;
      }
      
      public function set rightItems(param1:Vector.<DisplayObject>) : void
      {
         if(this._rightItems == param1)
         {
            return;
         }
         if(this._rightItems)
         {
            for each(var _loc2_ in this._rightItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).styleNameList.remove(this.itemStyleName);
                  _loc2_.removeEventListener("resize",item_resizeHandler);
               }
               _loc2_.removeFromParent();
            }
         }
         this._rightItems = param1;
         if(this._rightItems)
         {
            for each(_loc2_ in this._rightItems)
            {
               if(_loc2_ is IFeathersControl)
               {
                  _loc2_.addEventListener("resize",item_resizeHandler);
               }
            }
         }
         this.invalidate("rightContent");
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
      
      public function get gap() : Number
      {
         return _gap;
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
      
      public function get titleGap() : Number
      {
         return _titleGap;
      }
      
      public function set titleGap(param1:Number) : void
      {
         if(this._titleGap == param1)
         {
            return;
         }
         this._titleGap = param1;
         this.invalidate("styles");
      }
      
      public function get useExtraPaddingForOSStatusBar() : Boolean
      {
         return this._useExtraPaddingForOSStatusBar;
      }
      
      public function set useExtraPaddingForOSStatusBar(param1:Boolean) : void
      {
         if(this._useExtraPaddingForOSStatusBar == param1)
         {
            return;
         }
         this._useExtraPaddingForOSStatusBar = param1;
         this.invalidate("styles");
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
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
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this._backgroundSkin == param1)
         {
            return;
         }
         if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
         {
            this.removeChild(this._backgroundSkin);
         }
         this._backgroundSkin = param1;
         if(this._backgroundSkin && this._backgroundSkin.parent != this)
         {
            this._backgroundSkin.visible = false;
            this.addChildAt(this._backgroundSkin,0);
         }
         this.invalidate("styles");
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this._backgroundDisabledSkin;
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this._backgroundDisabledSkin == param1)
         {
            return;
         }
         if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
         {
            this.removeChild(this._backgroundDisabledSkin);
         }
         this._backgroundDisabledSkin = param1;
         if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
         {
            this._backgroundDisabledSkin.visible = false;
            this.addChildAt(this._backgroundDisabledSkin,0);
         }
         this.invalidate("styles");
      }
      
      public function get customTitleStyleName() : String
      {
         return this._customTitleStyleName;
      }
      
      public function set customTitleStyleName(param1:String) : void
      {
         if(this._customTitleStyleName == param1)
         {
            return;
         }
         this._customTitleStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      public function get titleProperties() : Object
      {
         if(!this._titleProperties)
         {
            this._titleProperties = new PropertyProxy(titleProperties_onChange);
         }
         return this._titleProperties;
      }
      
      public function set titleProperties(param1:Object) : void
      {
         if(this._titleProperties == param1)
         {
            return;
         }
         if(param1 && !(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._titleProperties)
         {
            this._titleProperties.removeOnChangeCallback(titleProperties_onChange);
         }
         this._titleProperties = PropertyProxy(param1);
         if(this._titleProperties)
         {
            this._titleProperties.addOnChangeCallback(titleProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get titleAlign() : String
      {
         return this._titleAlign;
      }
      
      public function set titleAlign(param1:String) : void
      {
         if(param1 === "preferLeft")
         {
            param1 = "left";
         }
         else if(param1 === "preferRight")
         {
            param1 = "right";
         }
         if(this._titleAlign == param1)
         {
            return;
         }
         this._titleAlign = param1;
         this.invalidate("styles");
      }
      
      override public function dispose() : void
      {
         if(this._disposeItems)
         {
            for each(var _loc1_ in this._leftItems)
            {
               _loc1_.dispose();
            }
            for each(_loc1_ in this._centerItems)
            {
               _loc1_.dispose();
            }
            for each(_loc1_ in this._rightItems)
            {
               _loc1_.dispose();
            }
         }
         this.leftItems = null;
         this.rightItems = null;
         this.centerItems = null;
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         if(!this._layout)
         {
            this._layout = new HorizontalLayout();
            this._layout.useVirtualLayout = false;
            this._layout.verticalAlign = "middle";
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc7_:Boolean = this.isInvalid("data");
         var _loc8_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("state");
         var _loc9_:Boolean = this.isInvalid("leftContent");
         var _loc4_:Boolean = this.isInvalid("rightContent");
         var _loc6_:Boolean = this.isInvalid("centerContent");
         var _loc5_:Boolean;
         if(_loc5_ = this.isInvalid("textRenderer"))
         {
            this.createTitle();
         }
         if(_loc5_ || _loc7_)
         {
            this.titleTextRenderer.text = this._title;
         }
         if(_loc3_ || _loc8_)
         {
            this.refreshBackground();
         }
         if(_loc5_ || _loc8_ || _loc1_)
         {
            this.refreshLayout();
         }
         if(_loc5_ || _loc8_)
         {
            this.refreshTitleStyles();
         }
         if(_loc9_)
         {
            if(this._leftItems)
            {
               for each(var _loc2_ in this._leftItems)
               {
                  if(_loc2_ is IFeathersControl)
                  {
                     IFeathersControl(_loc2_).styleNameList.add(this.itemStyleName);
                  }
                  this.addChild(_loc2_);
               }
            }
         }
         if(_loc4_)
         {
            if(this._rightItems)
            {
               for each(_loc2_ in this._rightItems)
               {
                  if(_loc2_ is IFeathersControl)
                  {
                     IFeathersControl(_loc2_).styleNameList.add(this.itemStyleName);
                  }
                  this.addChild(_loc2_);
               }
            }
         }
         if(_loc6_)
         {
            if(this._centerItems)
            {
               for each(_loc2_ in this._centerItems)
               {
                  if(_loc2_ is IFeathersControl)
                  {
                     IFeathersControl(_loc2_).styleNameList.add(this.itemStyleName);
                  }
                  this.addChild(_loc2_);
               }
            }
         }
         if(_loc3_ || _loc5_)
         {
            this.refreshEnabled();
         }
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layoutBackground();
         if(_loc1_ || _loc9_ || _loc4_ || _loc6_ || _loc8_)
         {
            this.leftItemsWidth = 0;
            this.rightItemsWidth = 0;
            if(this._leftItems)
            {
               this.layoutLeftItems();
            }
            if(this._rightItems)
            {
               this.layoutRightItems();
            }
            if(this._centerItems)
            {
               this.layoutCenterItems();
            }
         }
         if(_loc5_ || _loc1_ || _loc8_ || _loc7_ || _loc9_ || _loc4_ || _loc6_)
         {
            this.layoutTitle();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc12_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:DisplayObject = null;
         var _loc21_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc5_:* = this._explicitWidth !== this._explicitWidth;
         var _loc20_:* = this._explicitHeight !== this._explicitHeight;
         var _loc15_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc24_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc5_ && !_loc20_ && !_loc15_ && !_loc24_)
         {
            return false;
         }
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc22_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc10_:Number = this.calculateExtraOSStatusBarPadding();
         var _loc11_:Number = 0;
         var _loc18_:* = 0;
         var _loc23_:Boolean = this._leftItems !== null && this._leftItems.length > 0;
         var _loc13_:Boolean = this._rightItems !== null && this._rightItems.length > 0;
         var _loc19_:Boolean = this._centerItems !== null && this._centerItems.length > 0;
         if(_loc23_)
         {
            _loc12_ = int(this._leftItems.length);
            _loc9_ = 0;
            while(_loc9_ < _loc12_)
            {
               _loc1_ = this._leftItems[_loc9_];
               if(_loc1_ is IValidating)
               {
                  IValidating(_loc1_).validate();
               }
               _loc21_ = _loc1_.width;
               if(_loc21_ === _loc21_)
               {
                  _loc11_ += _loc21_;
                  if(_loc9_ > 0)
                  {
                     _loc11_ += this._gap;
                  }
               }
               _loc7_ = _loc1_.height;
               if(_loc7_ === _loc7_ && _loc7_ > _loc18_)
               {
                  _loc18_ = _loc7_;
               }
               _loc9_++;
            }
         }
         if(_loc19_)
         {
            _loc12_ = int(this._centerItems.length);
            _loc9_ = 0;
            while(_loc9_ < _loc12_)
            {
               _loc1_ = this._centerItems[_loc9_];
               if(_loc1_ is IValidating)
               {
                  IValidating(_loc1_).validate();
               }
               _loc21_ = _loc1_.width;
               if(_loc21_ === _loc21_)
               {
                  _loc11_ += _loc21_;
                  if(_loc9_ > 0)
                  {
                     _loc11_ += this._gap;
                  }
               }
               _loc7_ = _loc1_.height;
               if(_loc7_ === _loc7_ && _loc7_ > _loc18_)
               {
                  _loc18_ = _loc7_;
               }
               _loc9_++;
            }
         }
         if(_loc13_)
         {
            _loc12_ = int(this._rightItems.length);
            _loc9_ = 0;
            while(_loc9_ < _loc12_)
            {
               _loc1_ = this._rightItems[_loc9_];
               if(_loc1_ is IValidating)
               {
                  IValidating(_loc1_).validate();
               }
               _loc21_ = _loc1_.width;
               if(_loc21_ === _loc21_)
               {
                  _loc11_ += _loc21_;
                  if(_loc9_ > 0)
                  {
                     _loc11_ += this._gap;
                  }
               }
               _loc7_ = _loc1_.height;
               if(_loc7_ === _loc7_ && _loc7_ > _loc18_)
               {
                  _loc18_ = _loc7_;
               }
               _loc9_++;
            }
         }
         if(this._titleAlign === "center" && _loc19_)
         {
            if(_loc23_)
            {
               _loc11_ += this._gap;
            }
            if(_loc13_)
            {
               _loc11_ += this._gap;
            }
         }
         else
         {
            switch(_loc2_)
            {
               default:
                  _loc2_ = this._gap;
               case _loc2_:
                  _loc8_ = this._explicitWidth;
                  if(_loc5_)
                  {
                     _loc8_ = this._explicitMaxWidth;
                  }
                  _loc8_ -= _loc11_;
                  if(_loc23_)
                  {
                     _loc8_ -= _loc2_;
                  }
                  if(_loc19_)
                  {
                     _loc8_ -= _loc2_;
                  }
                  if(_loc13_)
                  {
                     _loc8_ -= _loc2_;
                  }
                  if(_loc8_ < 0)
                  {
                     _loc8_ = 0;
                  }
                  this.titleTextRenderer.maxWidth = _loc8_;
                  this.titleTextRenderer.measureText(HELPER_POINT);
                  _loc16_ = HELPER_POINT.x;
                  _loc3_ = HELPER_POINT.y;
                  if(_loc16_ === _loc16_)
                  {
                     if(_loc23_)
                     {
                        _loc16_ += _loc2_;
                     }
                     if(_loc13_)
                     {
                        _loc16_ += _loc2_;
                     }
                  }
                  else
                  {
                     _loc16_ = 0;
                  }
                  _loc11_ += _loc16_;
                  if(_loc3_ === _loc3_ && _loc3_ > _loc18_)
                  {
                     _loc18_ = _loc3_;
                  }
                  break;
               case null:
            }
         }
         var _loc4_:Number = this._explicitWidth;
         if(_loc5_)
         {
            _loc4_ = _loc11_ + this._paddingLeft + this._paddingRight;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.width > _loc4_)
            {
               _loc4_ = this.currentBackgroundSkin.width;
            }
         }
         var _loc6_:* = this._explicitHeight;
         if(_loc20_)
         {
            _loc6_ = (_loc6_ = _loc18_) + (this._paddingTop + this._paddingBottom);
            if(_loc10_ > 0)
            {
               if(_loc6_ < this._explicitMinHeight)
               {
                  _loc6_ = this._explicitMinHeight;
               }
               _loc6_ += _loc10_;
            }
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.height > _loc6_)
            {
               _loc6_ = this.currentBackgroundSkin.height;
            }
         }
         var _loc14_:Number = this._explicitMinWidth;
         if(_loc15_)
         {
            _loc14_ = _loc11_ + this._paddingLeft + this._paddingRight;
            switch(_loc22_)
            {
               default:
                  if(_loc22_.minWidth > _loc14_)
                  {
                     _loc14_ = _loc22_.minWidth;
                  }
                  break;
               case null:
                  if(this._explicitBackgroundMinWidth > _loc14_)
                  {
                     _loc14_ = this._explicitBackgroundMinWidth;
                  }
                  break;
               case null:
            }
         }
         var _loc17_:* = this._explicitMinHeight;
         if(_loc24_)
         {
            _loc17_ = (_loc17_ = _loc18_) + (this._paddingTop + this._paddingBottom);
            if(_loc10_ > 0)
            {
               if(_loc17_ < this._explicitMinHeight)
               {
                  _loc17_ = this._explicitMinHeight;
               }
               _loc17_ += _loc10_;
            }
            switch(_loc22_)
            {
               default:
                  if(_loc22_.minHeight > _loc17_)
                  {
                     _loc17_ = _loc22_.minHeight;
                  }
                  break;
               case null:
                  if(this._explicitBackgroundMinHeight > _loc17_)
                  {
                     _loc17_ = this._explicitBackgroundMinHeight;
                  }
                  break;
               case null:
            }
         }
         return this.saveMeasurements(_loc4_,_loc6_,_loc14_,_loc17_);
      }
      
      protected function createTitle() : void
      {
         if(this.titleTextRenderer)
         {
            this.removeChild(DisplayObject(this.titleTextRenderer),true);
            this.titleTextRenderer = null;
         }
         var _loc1_:Function = this._titleFactory != null ? this._titleFactory : FeathersControl.defaultTextRendererFactory;
         this.titleTextRenderer = ITextRenderer(_loc1_());
         var _loc2_:IFeathersControl = IFeathersControl(this.titleTextRenderer);
         var _loc3_:String = this._customTitleStyleName != null ? this._customTitleStyleName : this.titleStyleName;
         _loc2_.styleNameList.add(_loc3_);
         this.addChild(DisplayObject(_loc2_));
      }
      
      protected function refreshBackground() : void
      {
         var _loc1_:IMeasureDisplayObject = null;
         this.currentBackgroundSkin = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin)
         {
            if(this._backgroundSkin !== null)
            {
               this._backgroundSkin.visible = false;
            }
            this.currentBackgroundSkin = this._backgroundDisabledSkin;
         }
         else if(this._backgroundDisabledSkin !== null)
         {
            this._backgroundDisabledSkin.visible = false;
         }
         if(this.currentBackgroundSkin !== null)
         {
            this.currentBackgroundSkin.visible = true;
            if(this.currentBackgroundSkin is IFeathersControl)
            {
               IFeathersControl(this.currentBackgroundSkin).initializeNow();
            }
            if(this.currentBackgroundSkin is IMeasureDisplayObject)
            {
               _loc1_ = IMeasureDisplayObject(this.currentBackgroundSkin);
               this._explicitBackgroundWidth = _loc1_.explicitWidth;
               this._explicitBackgroundHeight = _loc1_.explicitHeight;
               this._explicitBackgroundMinWidth = _loc1_.explicitMinWidth;
               this._explicitBackgroundMinHeight = _loc1_.explicitMinHeight;
               this._explicitBackgroundMaxWidth = _loc1_.explicitMaxWidth;
               this._explicitBackgroundMaxHeight = _loc1_.explicitMaxHeight;
            }
            else
            {
               this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
               this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
               this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
               this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
               this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
               this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
            }
         }
      }
      
      protected function refreshLayout() : void
      {
         this._layout.gap = this._gap;
         this._layout.paddingTop = this._paddingTop + this.calculateExtraOSStatusBarPadding();
         this._layout.paddingBottom = this._paddingBottom;
         this._layout.verticalAlign = this._verticalAlign;
      }
      
      protected function refreshEnabled() : void
      {
         this.titleTextRenderer.isEnabled = this._isEnabled;
      }
      
      protected function refreshTitleStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._titleProperties)
         {
            _loc2_ = this._titleProperties[_loc1_];
            this.titleTextRenderer[_loc1_] = _loc2_;
         }
      }
      
      protected function calculateExtraOSStatusBarPadding() : Number
      {
         if(!this._useExtraPaddingForOSStatusBar)
         {
            return 0;
         }
         var _loc2_:String = Capabilities.os;
         if(_loc2_.indexOf("iPhone OS ") != 0 || parseInt(_loc2_.substr("iPhone OS ".length,1),10) < 7)
         {
            return 0;
         }
         var _loc1_:Stage = Starling.current.nativeStage;
         if(_loc1_.displayState != "normal")
         {
            return 0;
         }
         if(DeviceCapabilities.dpi % 132 === 0)
         {
            return 20 * Math.floor(DeviceCapabilities.dpi / 132) / Starling.current.contentScaleFactor;
         }
         return 20 * Math.floor(DeviceCapabilities.dpi / 163) / Starling.current.contentScaleFactor;
      }
      
      protected function layoutBackground() : void
      {
         if(!this.currentBackgroundSkin)
         {
            return;
         }
         this.currentBackgroundSkin.width = this.actualWidth;
         this.currentBackgroundSkin.height = this.actualHeight;
      }
      
      protected function layoutLeftItems() : void
      {
         for each(var _loc1_ in this._leftItems)
         {
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
         }
         HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
         HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
         HELPER_BOUNDS.explicitWidth = this.actualWidth;
         HELPER_BOUNDS.explicitHeight = this.actualHeight;
         this._layout.horizontalAlign = "left";
         this._layout.paddingRight = 0;
         this._layout.paddingLeft = this._paddingLeft;
         this._layout.layout(this._leftItems,HELPER_BOUNDS,HELPER_LAYOUT_RESULT);
         this.leftItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
         if(this.leftItemsWidth !== this.leftItemsWidth)
         {
            this.leftItemsWidth = 0;
         }
      }
      
      protected function layoutRightItems() : void
      {
         for each(var _loc1_ in this._rightItems)
         {
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
         }
         HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
         HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
         HELPER_BOUNDS.explicitWidth = this.actualWidth;
         HELPER_BOUNDS.explicitHeight = this.actualHeight;
         this._layout.horizontalAlign = "right";
         this._layout.paddingRight = this._paddingRight;
         this._layout.paddingLeft = 0;
         this._layout.layout(this._rightItems,HELPER_BOUNDS,HELPER_LAYOUT_RESULT);
         this.rightItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
         if(this.rightItemsWidth !== this.rightItemsWidth)
         {
            this.rightItemsWidth = 0;
         }
      }
      
      protected function layoutCenterItems() : void
      {
         for each(var _loc1_ in this._centerItems)
         {
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
         }
         HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
         HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
         HELPER_BOUNDS.explicitWidth = this.actualWidth;
         HELPER_BOUNDS.explicitHeight = this.actualHeight;
         this._layout.horizontalAlign = "center";
         this._layout.paddingRight = this._paddingRight;
         this._layout.paddingLeft = this._paddingLeft;
         this._layout.layout(this._centerItems,HELPER_BOUNDS,HELPER_LAYOUT_RESULT);
      }
      
      protected function layoutTitle() : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc10_:Boolean = this._leftItems !== null && this._leftItems.length > 0;
         var _loc1_:Boolean = this._rightItems !== null && this._rightItems.length > 0;
         var _loc4_:Boolean = this._centerItems !== null && this._centerItems.length > 0;
         if(this._titleAlign === "center" && _loc4_)
         {
            this.titleTextRenderer.visible = false;
            return;
         }
         if(this._titleAlign === "left" && _loc10_ && _loc4_)
         {
            this.titleTextRenderer.visible = false;
            return;
         }
         if(this._titleAlign === "right" && _loc1_ && _loc4_)
         {
            this.titleTextRenderer.visible = false;
            return;
         }
         this.titleTextRenderer.visible = true;
         var _loc2_:Number = this._titleGap;
         if(_loc2_ !== _loc2_)
         {
            _loc2_ = this._gap;
         }
         var _loc5_:Number = this._paddingLeft;
         if(_loc10_)
         {
            _loc5_ = this.leftItemsWidth + _loc2_;
         }
         var _loc3_:Number = this._paddingRight;
         if(_loc1_)
         {
            _loc3_ = this.rightItemsWidth + _loc2_;
         }
         if(this._titleAlign === "left")
         {
            if((_loc7_ = this.actualWidth - _loc5_ - _loc3_) < 0)
            {
               _loc7_ = 0;
            }
            this.titleTextRenderer.maxWidth = _loc7_;
            this.titleTextRenderer.validate();
            this.titleTextRenderer.x = _loc5_;
         }
         else if(this._titleAlign === "right")
         {
            if((_loc7_ = this.actualWidth - _loc5_ - _loc3_) < 0)
            {
               _loc7_ = 0;
            }
            this.titleTextRenderer.maxWidth = _loc7_;
            this.titleTextRenderer.validate();
            this.titleTextRenderer.x = this.actualWidth - this.titleTextRenderer.width - _loc3_;
         }
         else
         {
            if((_loc8_ = this.actualWidth - this._paddingLeft - this._paddingRight) < 0)
            {
               _loc8_ = 0;
            }
            if((_loc11_ = this.actualWidth - _loc5_ - _loc3_) < 0)
            {
               _loc11_ = 0;
            }
            this.titleTextRenderer.maxWidth = _loc11_;
            this.titleTextRenderer.validate();
            _loc6_ = this._paddingLeft + Math.round((_loc8_ - this.titleTextRenderer.width) / 2);
            if(_loc5_ > _loc6_ || _loc6_ + this.titleTextRenderer.width > this.actualWidth - _loc3_)
            {
               this.titleTextRenderer.x = _loc5_ + Math.round((_loc11_ - this.titleTextRenderer.width) / 2);
            }
            else
            {
               this.titleTextRenderer.x = _loc6_;
            }
         }
         var _loc9_:Number = this._paddingTop + this.calculateExtraOSStatusBarPadding();
         switch(this._verticalAlign)
         {
            case "top":
               this.titleTextRenderer.y = _loc9_;
               break;
            case "bottom":
               this.titleTextRenderer.y = this.actualHeight - this._paddingBottom - this.titleTextRenderer.height;
               break;
            default:
               this.titleTextRenderer.y = _loc9_ + Math.round((this.actualHeight - _loc9_ - this._paddingBottom - this.titleTextRenderer.height) / 2);
         }
      }
      
      protected function header_addedToStageHandler(param1:Event) : void
      {
         Starling.current.nativeStage.addEventListener("fullScreen",nativeStage_fullScreenHandler);
      }
      
      protected function header_removedFromStageHandler(param1:Event) : void
      {
         Starling.current.nativeStage.removeEventListener("fullScreen",nativeStage_fullScreenHandler);
      }
      
      protected function nativeStage_fullScreenHandler(param1:FullScreenEvent) : void
      {
         this.invalidate("size");
      }
      
      protected function titleProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      protected function item_resizeHandler(param1:Event) : void
      {
         this.invalidate("size");
      }
   }
}
