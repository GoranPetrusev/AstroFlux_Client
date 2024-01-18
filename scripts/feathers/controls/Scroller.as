package feathers.controls
{
   import feathers.controls.supportClasses.IViewPort;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.events.ExclusiveTouch;
   import feathers.system.DeviceCapabilities;
   import feathers.utils.display.stageToStarling;
   import feathers.utils.math.roundDownToNearest;
   import feathers.utils.math.roundToNearest;
   import feathers.utils.math.roundUpToNearest;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.utils.MathUtil;
   
   public class Scroller extends FeathersControl implements IFocusDisplayObject
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      protected static const INVALIDATION_FLAG_SCROLL_BAR_RENDERER:String = "scrollBarRenderer";
      
      protected static const INVALIDATION_FLAG_PENDING_SCROLL:String = "pendingScroll";
      
      protected static const INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS:String = "pendingRevealScrollBars";
      
      public static const SCROLL_POLICY_AUTO:String = "auto";
      
      public static const SCROLL_POLICY_ON:String = "on";
      
      public static const SCROLL_POLICY_OFF:String = "off";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT:String = "fixedFloat";
      
      public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";
      
      public static const VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";
      
      public static const VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";
      
      public static const INTERACTION_MODE_TOUCH:String = "touch";
      
      public static const INTERACTION_MODE_MOUSE:String = "mouse";
      
      public static const INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";
      
      public static const MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";
      
      public static const MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";
      
      protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
      
      private static const MINIMUM_VELOCITY:Number = 0.02;
      
      private static const CURRENT_VELOCITY_WEIGHT:Number = 2.33;
      
      private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[1,1.33,1.66,2];
      
      private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;
      
      public static const DECELERATION_RATE_NORMAL:Number = 0.998;
      
      public static const DECELERATION_RATE_FAST:Number = 0.99;
      
      public static const DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR:String = "feathers-scroller-horizontal-scroll-bar";
      
      public static const DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR:String = "feathers-scroller-vertical-scroll-bar";
      
      protected static const FUZZY_PAGE_SIZE_PADDING:Number = 0.000001;
      
      protected static const PAGE_INDEX_EPSILON:Number = 0.01;
       
      
      protected var horizontalScrollBarStyleName:String = "feathers-scroller-horizontal-scroll-bar";
      
      protected var verticalScrollBarStyleName:String = "feathers-scroller-vertical-scroll-bar";
      
      protected var horizontalScrollBar:IScrollBar;
      
      protected var verticalScrollBar:IScrollBar;
      
      protected var _topViewPortOffset:Number;
      
      protected var _rightViewPortOffset:Number;
      
      protected var _bottomViewPortOffset:Number;
      
      protected var _leftViewPortOffset:Number;
      
      protected var _hasHorizontalScrollBar:Boolean = false;
      
      protected var _hasVerticalScrollBar:Boolean = false;
      
      protected var _horizontalScrollBarTouchPointID:int = -1;
      
      protected var _verticalScrollBarTouchPointID:int = -1;
      
      protected var _touchPointID:int = -1;
      
      protected var _startTouchX:Number;
      
      protected var _startTouchY:Number;
      
      protected var _startHorizontalScrollPosition:Number;
      
      protected var _startVerticalScrollPosition:Number;
      
      protected var _currentTouchX:Number;
      
      protected var _currentTouchY:Number;
      
      protected var _previousTouchTime:int;
      
      protected var _previousTouchX:Number;
      
      protected var _previousTouchY:Number;
      
      protected var _velocityX:Number = 0;
      
      protected var _velocityY:Number = 0;
      
      protected var _previousVelocityX:Vector.<Number>;
      
      protected var _previousVelocityY:Vector.<Number>;
      
      protected var _lastViewPortWidth:Number = 0;
      
      protected var _lastViewPortHeight:Number = 0;
      
      protected var _hasViewPortBoundsChanged:Boolean = false;
      
      protected var _horizontalAutoScrollTween:Tween;
      
      protected var _verticalAutoScrollTween:Tween;
      
      protected var _isDraggingHorizontally:Boolean = false;
      
      protected var _isDraggingVertically:Boolean = false;
      
      protected var ignoreViewPortResizing:Boolean = false;
      
      protected var _touchBlocker:Quad;
      
      protected var _viewPort:IViewPort;
      
      protected var _explicitViewPortWidth:Number;
      
      protected var _explicitViewPortHeight:Number;
      
      protected var _explicitViewPortMinWidth:Number;
      
      protected var _explicitViewPortMinHeight:Number;
      
      protected var _measureViewPort:Boolean = true;
      
      protected var _snapToPages:Boolean = false;
      
      protected var _snapOnComplete:Boolean = false;
      
      protected var _horizontalScrollBarFactory:Function;
      
      protected var _customHorizontalScrollBarStyleName:String;
      
      protected var _horizontalScrollBarProperties:PropertyProxy;
      
      protected var _verticalScrollBarPosition:String = "right";
      
      protected var _verticalScrollBarFactory:Function;
      
      protected var _customVerticalScrollBarStyleName:String;
      
      protected var _verticalScrollBarProperties:PropertyProxy;
      
      protected var actualHorizontalScrollStep:Number = 1;
      
      protected var explicitHorizontalScrollStep:Number = NaN;
      
      protected var _targetHorizontalScrollPosition:Number;
      
      protected var _horizontalScrollPosition:Number = 0;
      
      protected var _minHorizontalScrollPosition:Number = 0;
      
      protected var _maxHorizontalScrollPosition:Number = 0;
      
      protected var _horizontalPageIndex:int = 0;
      
      protected var _minHorizontalPageIndex:int = 0;
      
      protected var _maxHorizontalPageIndex:int = 0;
      
      protected var _horizontalScrollPolicy:String = "auto";
      
      protected var actualVerticalScrollStep:Number = 1;
      
      protected var explicitVerticalScrollStep:Number = NaN;
      
      protected var _verticalMouseWheelScrollStep:Number = NaN;
      
      protected var _targetVerticalScrollPosition:Number;
      
      protected var _verticalScrollPosition:Number = 0;
      
      protected var _minVerticalScrollPosition:Number = 0;
      
      protected var _maxVerticalScrollPosition:Number = 0;
      
      protected var _verticalPageIndex:int = 0;
      
      protected var _minVerticalPageIndex:int = 0;
      
      protected var _maxVerticalPageIndex:int = 0;
      
      protected var _verticalScrollPolicy:String = "auto";
      
      protected var _clipContent:Boolean = true;
      
      protected var actualPageWidth:Number = 0;
      
      protected var explicitPageWidth:Number = NaN;
      
      protected var actualPageHeight:Number = 0;
      
      protected var explicitPageHeight:Number = NaN;
      
      protected var _hasElasticEdges:Boolean = true;
      
      protected var _elasticity:Number = 0.33;
      
      protected var _throwElasticity:Number = 0.05;
      
      protected var _scrollBarDisplayMode:String = "float";
      
      protected var _interactionMode:String = "touch";
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _autoHideBackground:Boolean = false;
      
      protected var _minimumDragDistance:Number = 0.04;
      
      protected var _minimumPageThrowVelocity:Number = 5;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _horizontalScrollBarHideTween:Tween;
      
      protected var _verticalScrollBarHideTween:Tween;
      
      protected var _hideScrollBarAnimationDuration:Number = 0.2;
      
      protected var _hideScrollBarAnimationEase:Object = "easeOut";
      
      protected var _elasticSnapDuration:Number = 0.5;
      
      protected var _logDecelerationRate:Number = -0.0020020026706730793;
      
      protected var _decelerationRate:Number = 0.998;
      
      protected var _fixedThrowDuration:Number = 2.996998998998728;
      
      protected var _useFixedThrowDuration:Boolean = true;
      
      protected var _pageThrowDuration:Number = 0.5;
      
      protected var _mouseWheelScrollDuration:Number = 0.35;
      
      protected var _verticalMouseWheelScrollDirection:String = "vertical";
      
      protected var _throwEase:Object;
      
      protected var _snapScrollPositionsToPixels:Boolean = true;
      
      protected var _horizontalScrollBarIsScrolling:Boolean = false;
      
      protected var _verticalScrollBarIsScrolling:Boolean = false;
      
      protected var _isScrolling:Boolean = false;
      
      protected var _isScrollingStopped:Boolean = false;
      
      protected var pendingHorizontalScrollPosition:Number = NaN;
      
      protected var pendingVerticalScrollPosition:Number = NaN;
      
      protected var hasPendingHorizontalPageIndex:Boolean = false;
      
      protected var hasPendingVerticalPageIndex:Boolean = false;
      
      protected var pendingHorizontalPageIndex:int;
      
      protected var pendingVerticalPageIndex:int;
      
      protected var pendingScrollDuration:Number;
      
      protected var isScrollBarRevealPending:Boolean = false;
      
      protected var _revealScrollBarsDuration:Number = 1;
      
      protected var _horizontalAutoScrollTweenEndRatio:Number = 1;
      
      protected var _verticalAutoScrollTweenEndRatio:Number = 1;
      
      public function Scroller()
      {
         _previousVelocityX = new Vector.<Number>(0);
         _previousVelocityY = new Vector.<Number>(0);
         _horizontalScrollBarFactory = defaultScrollBarFactory;
         _verticalScrollBarFactory = defaultScrollBarFactory;
         _throwEase = defaultThrowEase;
         super();
         this.addEventListener("addedToStage",scroller_addedToStageHandler);
         this.addEventListener("removedFromStage",scroller_removedFromStageHandler);
      }
      
      protected static function defaultScrollBarFactory() : IScrollBar
      {
         return new SimpleScrollBar();
      }
      
      protected static function defaultThrowEase(param1:Number) : Number
      {
         param1 -= 1;
         return 1 - param1 * param1 * param1 * param1;
      }
      
      override public function get isFocusEnabled() : Boolean
      {
         return (this._maxVerticalScrollPosition != this._minVerticalScrollPosition || this._maxHorizontalScrollPosition != this._minHorizontalScrollPosition) && super.isFocusEnabled;
      }
      
      public function get viewPort() : IViewPort
      {
         return this._viewPort;
      }
      
      public function set viewPort(param1:IViewPort) : void
      {
         if(this._viewPort == param1)
         {
            return;
         }
         if(this._viewPort !== null)
         {
            this._viewPort.removeEventListener("resize",viewPort_resizeHandler);
            this.removeRawChildInternal(DisplayObject(this._viewPort));
         }
         this._viewPort = param1;
         if(this._viewPort !== null)
         {
            this._viewPort.addEventListener("resize",viewPort_resizeHandler);
            this.addRawChildAtInternal(DisplayObject(this._viewPort),0);
            if(this._viewPort is IFeathersControl)
            {
               IFeathersControl(this._viewPort).initializeNow();
            }
            this._explicitViewPortWidth = this._viewPort.explicitWidth;
            this._explicitViewPortHeight = this._viewPort.explicitHeight;
            this._explicitViewPortMinWidth = this._viewPort.explicitMinWidth;
            this._explicitViewPortMinHeight = this._viewPort.explicitMinHeight;
         }
         this.invalidate("size");
      }
      
      public function get measureViewPort() : Boolean
      {
         return this._measureViewPort;
      }
      
      public function set measureViewPort(param1:Boolean) : void
      {
         if(this._measureViewPort == param1)
         {
            return;
         }
         this._measureViewPort = param1;
         this.invalidate("size");
      }
      
      public function get snapToPages() : Boolean
      {
         return this._snapToPages;
      }
      
      public function set snapToPages(param1:Boolean) : void
      {
         if(this._snapToPages == param1)
         {
            return;
         }
         this._snapToPages = param1;
         this.invalidate("scroll");
      }
      
      public function get horizontalScrollBarFactory() : Function
      {
         return this._horizontalScrollBarFactory;
      }
      
      public function set horizontalScrollBarFactory(param1:Function) : void
      {
         if(this._horizontalScrollBarFactory == param1)
         {
            return;
         }
         this._horizontalScrollBarFactory = param1;
         this.invalidate("scrollBarRenderer");
      }
      
      public function get customHorizontalScrollBarStyleName() : String
      {
         return this._customHorizontalScrollBarStyleName;
      }
      
      public function set customHorizontalScrollBarStyleName(param1:String) : void
      {
         if(this._customHorizontalScrollBarStyleName == param1)
         {
            return;
         }
         this._customHorizontalScrollBarStyleName = param1;
         this.invalidate("scrollBarRenderer");
      }
      
      public function get horizontalScrollBarProperties() : Object
      {
         if(!this._horizontalScrollBarProperties)
         {
            this._horizontalScrollBarProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._horizontalScrollBarProperties;
      }
      
      public function set horizontalScrollBarProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._horizontalScrollBarProperties == param1)
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
         if(this._horizontalScrollBarProperties)
         {
            this._horizontalScrollBarProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._horizontalScrollBarProperties = PropertyProxy(param1);
         if(this._horizontalScrollBarProperties)
         {
            this._horizontalScrollBarProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get verticalScrollBarPosition() : String
      {
         return this._verticalScrollBarPosition;
      }
      
      public function set verticalScrollBarPosition(param1:String) : void
      {
         if(this._verticalScrollBarPosition == param1)
         {
            return;
         }
         this._verticalScrollBarPosition = param1;
         this.invalidate("styles");
      }
      
      public function get verticalScrollBarFactory() : Function
      {
         return this._verticalScrollBarFactory;
      }
      
      public function set verticalScrollBarFactory(param1:Function) : void
      {
         if(this._verticalScrollBarFactory == param1)
         {
            return;
         }
         this._verticalScrollBarFactory = param1;
         this.invalidate("scrollBarRenderer");
      }
      
      public function get customVerticalScrollBarStyleName() : String
      {
         return this._customVerticalScrollBarStyleName;
      }
      
      public function set customVerticalScrollBarStyleName(param1:String) : void
      {
         if(this._customVerticalScrollBarStyleName == param1)
         {
            return;
         }
         this._customVerticalScrollBarStyleName = param1;
         this.invalidate("scrollBarRenderer");
      }
      
      public function get verticalScrollBarProperties() : Object
      {
         if(!this._verticalScrollBarProperties)
         {
            this._verticalScrollBarProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._verticalScrollBarProperties;
      }
      
      public function set verticalScrollBarProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._horizontalScrollBarProperties == param1)
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
         if(this._verticalScrollBarProperties)
         {
            this._verticalScrollBarProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._verticalScrollBarProperties = PropertyProxy(param1);
         if(this._verticalScrollBarProperties)
         {
            this._verticalScrollBarProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get horizontalScrollStep() : Number
      {
         return this.actualHorizontalScrollStep;
      }
      
      public function set horizontalScrollStep(param1:Number) : void
      {
         if(this.explicitHorizontalScrollStep == param1)
         {
            return;
         }
         this.explicitHorizontalScrollStep = param1;
         this.invalidate("scroll");
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("horizontalScrollPosition cannot be NaN.");
         }
         this._horizontalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get minHorizontalScrollPosition() : Number
      {
         return this._minHorizontalScrollPosition;
      }
      
      public function get maxHorizontalScrollPosition() : Number
      {
         return this._maxHorizontalScrollPosition;
      }
      
      public function get horizontalPageIndex() : int
      {
         if(this.hasPendingHorizontalPageIndex)
         {
            return this.pendingHorizontalPageIndex;
         }
         return this._horizontalPageIndex;
      }
      
      public function get minHorizontalPageIndex() : int
      {
         return this._minHorizontalPageIndex;
      }
      
      public function get maxHorizontalPageIndex() : int
      {
         return this._maxHorizontalPageIndex;
      }
      
      public function get horizontalPageCount() : int
      {
         if(this._maxHorizontalPageIndex == 2147483647 || this._minHorizontalPageIndex == -2147483648)
         {
            return 2147483647;
         }
         return this._maxHorizontalPageIndex - this._minHorizontalPageIndex + 1;
      }
      
      public function get horizontalScrollPolicy() : String
      {
         return this._horizontalScrollPolicy;
      }
      
      public function set horizontalScrollPolicy(param1:String) : void
      {
         if(this._horizontalScrollPolicy == param1)
         {
            return;
         }
         this._horizontalScrollPolicy = param1;
         this.invalidate("scroll");
         this.invalidate("scrollBarRenderer");
      }
      
      public function get verticalScrollStep() : Number
      {
         return this.actualVerticalScrollStep;
      }
      
      public function set verticalScrollStep(param1:Number) : void
      {
         if(this.explicitVerticalScrollStep == param1)
         {
            return;
         }
         this.explicitVerticalScrollStep = param1;
         this.invalidate("scroll");
      }
      
      public function get verticalMouseWheelScrollStep() : Number
      {
         return this._verticalMouseWheelScrollStep;
      }
      
      public function set verticalMouseWheelScrollStep(param1:Number) : void
      {
         if(this._verticalMouseWheelScrollStep == param1)
         {
            return;
         }
         this._verticalMouseWheelScrollStep = param1;
         this.invalidate("scroll");
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("verticalScrollPosition cannot be NaN.");
         }
         this._verticalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get minVerticalScrollPosition() : Number
      {
         return this._minVerticalScrollPosition;
      }
      
      public function get maxVerticalScrollPosition() : Number
      {
         return this._maxVerticalScrollPosition;
      }
      
      public function get verticalPageIndex() : int
      {
         if(this.hasPendingVerticalPageIndex)
         {
            return this.pendingVerticalPageIndex;
         }
         return this._verticalPageIndex;
      }
      
      public function get minVerticalPageIndex() : int
      {
         return this._minVerticalPageIndex;
      }
      
      public function get maxVerticalPageIndex() : int
      {
         return this._maxVerticalPageIndex;
      }
      
      public function get verticalPageCount() : int
      {
         if(this._maxVerticalPageIndex == 2147483647 || this._minVerticalPageIndex == -2147483648)
         {
            return 2147483647;
         }
         return this._maxVerticalPageIndex - this._minVerticalPageIndex + 1;
      }
      
      public function get verticalScrollPolicy() : String
      {
         return this._verticalScrollPolicy;
      }
      
      public function set verticalScrollPolicy(param1:String) : void
      {
         if(this._verticalScrollPolicy == param1)
         {
            return;
         }
         this._verticalScrollPolicy = param1;
         this.invalidate("scroll");
         this.invalidate("scrollBarRenderer");
      }
      
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(param1:Boolean) : void
      {
         if(this._clipContent == param1)
         {
            return;
         }
         this._clipContent = param1;
         if(!param1 && this._viewPort)
         {
            this._viewPort.mask = null;
         }
         this.invalidate("clipping");
      }
      
      public function get pageWidth() : Number
      {
         return this.actualPageWidth;
      }
      
      public function set pageWidth(param1:Number) : void
      {
         if(this.explicitPageWidth == param1)
         {
            return;
         }
         var _loc2_:* = param1 !== param1;
         if(_loc2_ && this.explicitPageWidth !== this.explicitPageWidth)
         {
            return;
         }
         this.explicitPageWidth = param1;
         if(_loc2_)
         {
            this.actualPageWidth = 0;
         }
         else
         {
            this.actualPageWidth = this.explicitPageWidth;
         }
      }
      
      public function get pageHeight() : Number
      {
         return this.actualPageHeight;
      }
      
      public function set pageHeight(param1:Number) : void
      {
         if(this.explicitPageHeight == param1)
         {
            return;
         }
         var _loc2_:* = param1 !== param1;
         if(_loc2_ && this.explicitPageHeight !== this.explicitPageHeight)
         {
            return;
         }
         this.explicitPageHeight = param1;
         if(_loc2_)
         {
            this.actualPageHeight = 0;
         }
         else
         {
            this.actualPageHeight = this.explicitPageHeight;
         }
      }
      
      public function get hasElasticEdges() : Boolean
      {
         return this._hasElasticEdges;
      }
      
      public function set hasElasticEdges(param1:Boolean) : void
      {
         this._hasElasticEdges = param1;
      }
      
      public function get elasticity() : Number
      {
         return this._elasticity;
      }
      
      public function set elasticity(param1:Number) : void
      {
         this._elasticity = param1;
      }
      
      public function get throwElasticity() : Number
      {
         return this._throwElasticity;
      }
      
      public function set throwElasticity(param1:Number) : void
      {
         this._throwElasticity = param1;
      }
      
      public function get scrollBarDisplayMode() : String
      {
         return this._scrollBarDisplayMode;
      }
      
      public function set scrollBarDisplayMode(param1:String) : void
      {
         if(this._scrollBarDisplayMode == param1)
         {
            return;
         }
         this._scrollBarDisplayMode = param1;
         this.invalidate("styles");
      }
      
      public function get interactionMode() : String
      {
         return this._interactionMode;
      }
      
      public function set interactionMode(param1:String) : void
      {
         if(this._interactionMode == param1)
         {
            return;
         }
         this._interactionMode = param1;
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
         if(this._backgroundSkin && this.currentBackgroundSkin == this._backgroundSkin)
         {
            this.removeRawChildInternal(this._backgroundSkin);
            this.currentBackgroundSkin = null;
         }
         this._backgroundSkin = param1;
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
         if(this._backgroundDisabledSkin && this.currentBackgroundSkin == this._backgroundDisabledSkin)
         {
            this.removeRawChildInternal(this._backgroundDisabledSkin);
            this.currentBackgroundSkin = null;
         }
         this._backgroundDisabledSkin = param1;
         this.invalidate("styles");
      }
      
      public function get autoHideBackground() : Boolean
      {
         return this._autoHideBackground;
      }
      
      public function set autoHideBackground(param1:Boolean) : void
      {
         if(this._autoHideBackground == param1)
         {
            return;
         }
         this._autoHideBackground = param1;
         this.invalidate("styles");
      }
      
      public function get minimumDragDistance() : Number
      {
         return this._minimumDragDistance;
      }
      
      public function set minimumDragDistance(param1:Number) : void
      {
         this._minimumDragDistance = param1;
      }
      
      public function get minimumPageThrowVelocity() : Number
      {
         return this._minimumPageThrowVelocity;
      }
      
      public function set minimumPageThrowVelocity(param1:Number) : void
      {
         this._minimumPageThrowVelocity = param1;
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
      
      public function get hideScrollBarAnimationDuration() : Number
      {
         return this._hideScrollBarAnimationDuration;
      }
      
      public function set hideScrollBarAnimationDuration(param1:Number) : void
      {
         this._hideScrollBarAnimationDuration = param1;
      }
      
      public function get hideScrollBarAnimationEase() : Object
      {
         return this._hideScrollBarAnimationEase;
      }
      
      public function set hideScrollBarAnimationEase(param1:Object) : void
      {
         this._hideScrollBarAnimationEase = param1;
      }
      
      public function get elasticSnapDuration() : Number
      {
         return this._elasticSnapDuration;
      }
      
      public function set elasticSnapDuration(param1:Number) : void
      {
         this._elasticSnapDuration = param1;
      }
      
      public function get decelerationRate() : Number
      {
         return this._decelerationRate;
      }
      
      public function set decelerationRate(param1:Number) : void
      {
         if(this._decelerationRate == param1)
         {
            return;
         }
         this._decelerationRate = param1;
         this._logDecelerationRate = Math.log(this._decelerationRate);
         this._fixedThrowDuration = -0.1 / Math.log(Math.pow(this._decelerationRate,16.666666666666668));
      }
      
      public function get useFixedThrowDuration() : Boolean
      {
         return this._useFixedThrowDuration;
      }
      
      public function set useFixedThrowDuration(param1:Boolean) : void
      {
         this._useFixedThrowDuration = param1;
      }
      
      public function get pageThrowDuration() : Number
      {
         return this._pageThrowDuration;
      }
      
      public function set pageThrowDuration(param1:Number) : void
      {
         this._pageThrowDuration = param1;
      }
      
      public function get mouseWheelScrollDuration() : Number
      {
         return this._mouseWheelScrollDuration;
      }
      
      public function set mouseWheelScrollDuration(param1:Number) : void
      {
         this._mouseWheelScrollDuration = param1;
      }
      
      public function get verticalMouseWheelScrollDirection() : String
      {
         return this._verticalMouseWheelScrollDirection;
      }
      
      public function set verticalMouseWheelScrollDirection(param1:String) : void
      {
         this._verticalMouseWheelScrollDirection = param1;
      }
      
      public function get throwEase() : Object
      {
         return this._throwEase;
      }
      
      public function set throwEase(param1:Object) : void
      {
         if(param1 == null)
         {
            param1 = defaultThrowEase;
         }
         this._throwEase = param1;
      }
      
      public function get snapScrollPositionsToPixels() : Boolean
      {
         return this._snapScrollPositionsToPixels;
      }
      
      public function set snapScrollPositionsToPixels(param1:Boolean) : void
      {
         if(this._snapScrollPositionsToPixels == param1)
         {
            return;
         }
         this._snapScrollPositionsToPixels = param1;
         this.invalidate("scroll");
      }
      
      public function get isScrolling() : Boolean
      {
         return this._isScrolling;
      }
      
      public function get revealScrollBarsDuration() : Number
      {
         return this._revealScrollBarsDuration;
      }
      
      public function set revealScrollBarsDuration(param1:Number) : void
      {
         this._revealScrollBarsDuration = param1;
      }
      
      override public function dispose() : void
      {
         Starling.current.nativeStage.removeEventListener("mouseWheel",nativeStage_mouseWheelHandler);
         Starling.current.nativeStage.removeEventListener("orientationChange",nativeStage_orientationChangeHandler);
         if(this._backgroundSkin && this._backgroundSkin.parent !== this)
         {
            this._backgroundSkin.dispose();
         }
         if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent !== this)
         {
            this._backgroundDisabledSkin.dispose();
         }
         super.dispose();
      }
      
      public function stopScrolling() : void
      {
         if(this._horizontalAutoScrollTween)
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
         }
         if(this._verticalAutoScrollTween)
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
         }
         this._isScrollingStopped = true;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this.hideHorizontalScrollBar();
         this.hideVerticalScrollBar();
      }
      
      public function scrollToPosition(param1:Number, param2:Number, param3:Number = NaN) : void
      {
         if(param3 !== param3)
         {
            if(this._useFixedThrowDuration)
            {
               param3 = this._fixedThrowDuration;
            }
            else
            {
               HELPER_POINT.setTo(param1 - this._horizontalScrollPosition,param2 - this._verticalScrollPosition);
               param3 = this.calculateDynamicThrowDuration(HELPER_POINT.length * this._logDecelerationRate + 0.02);
            }
         }
         this.hasPendingHorizontalPageIndex = false;
         this.hasPendingVerticalPageIndex = false;
         if(this.pendingHorizontalScrollPosition == param1 && this.pendingVerticalScrollPosition == param2 && this.pendingScrollDuration == param3)
         {
            return;
         }
         this.pendingHorizontalScrollPosition = param1;
         this.pendingVerticalScrollPosition = param2;
         this.pendingScrollDuration = param3;
         this.invalidate("pendingScroll");
      }
      
      public function scrollToPageIndex(param1:int, param2:int, param3:Number = NaN) : void
      {
         if(param3 !== param3)
         {
            param3 = this._pageThrowDuration;
         }
         this.pendingHorizontalScrollPosition = NaN;
         this.pendingVerticalScrollPosition = NaN;
         this.hasPendingHorizontalPageIndex = this._horizontalPageIndex !== param1;
         this.hasPendingVerticalPageIndex = this._verticalPageIndex !== param2;
         if(!this.hasPendingHorizontalPageIndex && !this.hasPendingVerticalPageIndex)
         {
            return;
         }
         this.pendingHorizontalPageIndex = param1;
         this.pendingVerticalPageIndex = param2;
         this.pendingScrollDuration = param3;
         this.invalidate("pendingScroll");
      }
      
      public function revealScrollBars() : void
      {
         this.isScrollBarRevealPending = true;
         this.invalidate("pendingRevealScrollBars");
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc4_:Number = param1.x;
         var _loc3_:Number = param1.y;
         var _loc2_:DisplayObject = super.hitTest(param1);
         if(!_loc2_)
         {
            if(!this.visible || !this.touchable)
            {
               return null;
            }
            return this._hitArea.contains(_loc4_,_loc3_) ? this : null;
         }
         return _loc2_;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc7_:Boolean = this.isInvalid("data");
         var _loc11_:Boolean = this.isInvalid("scroll");
         var _loc10_:Boolean = this.isInvalid("clipping");
         var _loc8_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("state");
         var _loc9_:Boolean = this.isInvalid("scrollBarRenderer");
         var _loc12_:Boolean = this.isInvalid("pendingScroll");
         var _loc2_:Boolean = this.isInvalid("pendingRevealScrollBars");
         if(_loc9_)
         {
            this.createScrollBars();
         }
         if(_loc1_ || _loc8_ || _loc3_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc9_ || _loc8_)
         {
            this.refreshScrollBarStyles();
            this.refreshInteractionModeEvents();
         }
         if(_loc9_ || _loc3_)
         {
            this.refreshEnabled();
         }
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.validate();
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.validate();
         }
         var _loc4_:Number = this._maxHorizontalScrollPosition;
         var _loc6_:Number = this._maxVerticalScrollPosition;
         var _loc5_:Boolean = _loc11_ && this._viewPort.requiresMeasurementOnScroll || _loc7_ || _loc1_ || _loc8_ || _loc9_;
         this.refreshViewPort(_loc5_);
         if(_loc4_ != this._maxHorizontalScrollPosition)
         {
            this.refreshHorizontalAutoScrollTweenEndRatio();
            _loc11_ = true;
         }
         if(_loc6_ != this._maxVerticalScrollPosition)
         {
            this.refreshVerticalAutoScrollTweenEndRatio();
            _loc11_ = true;
         }
         if(_loc11_)
         {
            this.dispatchEventWith("scroll");
         }
         this.showOrHideChildren();
         this.layoutChildren();
         if(_loc11_ || _loc1_ || _loc8_ || _loc9_)
         {
            this.refreshScrollBarValues();
         }
         if(_loc5_ || _loc11_ || _loc10_)
         {
            this.refreshMask();
         }
         this.refreshFocusIndicator();
         if(_loc12_)
         {
            this.handlePendingScroll();
         }
         if(_loc2_)
         {
            this.handlePendingRevealScrollBars();
         }
      }
      
      protected function refreshViewPort(param1:Boolean) : void
      {
         this._viewPort.horizontalScrollPosition = this._horizontalScrollPosition;
         this._viewPort.verticalScrollPosition = this._verticalScrollPosition;
         if(!param1)
         {
            this._viewPort.validate();
            this.refreshScrollValues();
            return;
         }
         var _loc2_:int = 0;
         do
         {
            this._hasViewPortBoundsChanged = false;
            if(this._measureViewPort)
            {
               this.calculateViewPortOffsets(true,false);
               this.refreshViewPortBoundsForMeasurement();
            }
            this.calculateViewPortOffsets(false,false);
            this.autoSizeIfNeeded();
            this.calculateViewPortOffsets(false,true);
            this.refreshViewPortBoundsForLayout();
            this.refreshScrollValues();
            _loc2_++;
            if(_loc2_ >= 10)
            {
               break;
            }
         }
         while(this._hasViewPortBoundsChanged);
         
         this._lastViewPortWidth = this._viewPort.width;
         this._lastViewPortHeight = this._viewPort.height;
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc7_:* = this._explicitHeight !== this._explicitHeight;
         var _loc4_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc9_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc3_ && !_loc7_ && !_loc4_ && !_loc9_)
         {
            return false;
         }
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc8_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc2_:Number = this._explicitWidth;
         var _loc5_:Number = this._explicitHeight;
         var _loc1_:Number = this._explicitMinWidth;
         var _loc6_:Number = this._explicitMinHeight;
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
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.width > _loc2_)
            {
               _loc2_ = this.currentBackgroundSkin.width;
            }
         }
         if(_loc7_)
         {
            if(this._measureViewPort)
            {
               _loc5_ = this._viewPort.visibleHeight;
            }
            else
            {
               _loc5_ = 0;
            }
            _loc5_ += this._bottomViewPortOffset + this._topViewPortOffset;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.height > _loc5_)
            {
               _loc5_ = this.currentBackgroundSkin.height;
            }
         }
         if(_loc4_)
         {
            if(this._measureViewPort)
            {
               _loc1_ = this._viewPort.minVisibleWidth;
            }
            else
            {
               _loc1_ = 0;
            }
            _loc1_ += this._rightViewPortOffset + this._leftViewPortOffset;
            switch(_loc8_)
            {
               default:
                  if(_loc8_.minWidth > _loc1_)
                  {
                     _loc1_ = _loc8_.minWidth;
                  }
                  break;
               case null:
                  if(this._explicitBackgroundMinWidth > _loc1_)
                  {
                     _loc1_ = this._explicitBackgroundMinWidth;
                  }
                  break;
               case null:
            }
         }
         if(_loc9_)
         {
            if(this._measureViewPort)
            {
               _loc6_ = this._viewPort.minVisibleHeight;
            }
            else
            {
               _loc6_ = 0;
            }
            _loc6_ += this._bottomViewPortOffset + this._topViewPortOffset;
            switch(_loc8_)
            {
               default:
                  if(_loc8_.minHeight > _loc6_)
                  {
                     _loc6_ = _loc8_.minHeight;
                  }
                  break;
               case null:
                  if(this._explicitBackgroundMinHeight > _loc6_)
                  {
                     _loc6_ = this._explicitBackgroundMinHeight;
                  }
                  break;
               case null:
            }
         }
         return this.saveMeasurements(_loc2_,_loc5_,_loc1_,_loc6_);
      }
      
      protected function createScrollBars() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.removeEventListener("beginInteraction",horizontalScrollBar_beginInteractionHandler);
            this.horizontalScrollBar.removeEventListener("endInteraction",horizontalScrollBar_endInteractionHandler);
            this.horizontalScrollBar.removeEventListener("change",horizontalScrollBar_changeHandler);
            this.removeRawChildInternal(DisplayObject(this.horizontalScrollBar),true);
            this.horizontalScrollBar = null;
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.removeEventListener("beginInteraction",verticalScrollBar_beginInteractionHandler);
            this.verticalScrollBar.removeEventListener("endInteraction",verticalScrollBar_endInteractionHandler);
            this.verticalScrollBar.removeEventListener("change",verticalScrollBar_changeHandler);
            this.removeRawChildInternal(DisplayObject(this.verticalScrollBar),true);
            this.verticalScrollBar = null;
         }
         if(this._scrollBarDisplayMode != "none" && this._horizontalScrollPolicy != "off" && this._horizontalScrollBarFactory != null)
         {
            this.horizontalScrollBar = IScrollBar(this._horizontalScrollBarFactory());
            if(this.horizontalScrollBar is IDirectionalScrollBar)
            {
               IDirectionalScrollBar(this.horizontalScrollBar).direction = "horizontal";
            }
            _loc1_ = this._customHorizontalScrollBarStyleName != null ? this._customHorizontalScrollBarStyleName : this.horizontalScrollBarStyleName;
            this.horizontalScrollBar.styleNameList.add(_loc1_);
            this.horizontalScrollBar.addEventListener("change",horizontalScrollBar_changeHandler);
            this.horizontalScrollBar.addEventListener("beginInteraction",horizontalScrollBar_beginInteractionHandler);
            this.horizontalScrollBar.addEventListener("endInteraction",horizontalScrollBar_endInteractionHandler);
            this.addRawChildInternal(DisplayObject(this.horizontalScrollBar));
         }
         if(this._scrollBarDisplayMode != "none" && this._verticalScrollPolicy != "off" && this._verticalScrollBarFactory != null)
         {
            this.verticalScrollBar = IScrollBar(this._verticalScrollBarFactory());
            if(this.verticalScrollBar is IDirectionalScrollBar)
            {
               IDirectionalScrollBar(this.verticalScrollBar).direction = "vertical";
            }
            _loc2_ = this._customVerticalScrollBarStyleName != null ? this._customVerticalScrollBarStyleName : this.verticalScrollBarStyleName;
            this.verticalScrollBar.styleNameList.add(_loc2_);
            this.verticalScrollBar.addEventListener("change",verticalScrollBar_changeHandler);
            this.verticalScrollBar.addEventListener("beginInteraction",verticalScrollBar_beginInteractionHandler);
            this.verticalScrollBar.addEventListener("endInteraction",verticalScrollBar_endInteractionHandler);
            this.addRawChildInternal(DisplayObject(this.verticalScrollBar));
         }
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin)
         {
            _loc1_ = this._backgroundDisabledSkin;
         }
         if(this.currentBackgroundSkin != _loc1_)
         {
            if(this.currentBackgroundSkin)
            {
               this.removeRawChildInternal(this.currentBackgroundSkin);
            }
            this.currentBackgroundSkin = _loc1_;
            if(this.currentBackgroundSkin !== null)
            {
               this.addRawChildAtInternal(this.currentBackgroundSkin,0);
               if(this.currentBackgroundSkin is IFeathersControl)
               {
                  IFeathersControl(this.currentBackgroundSkin).initializeNow();
               }
               if(this.currentBackgroundSkin is IMeasureDisplayObject)
               {
                  _loc2_ = IMeasureDisplayObject(this.currentBackgroundSkin);
                  this._explicitBackgroundWidth = _loc2_.explicitWidth;
                  this._explicitBackgroundHeight = _loc2_.explicitHeight;
                  this._explicitBackgroundMinWidth = _loc2_.explicitMinWidth;
                  this._explicitBackgroundMinHeight = _loc2_.explicitMinHeight;
                  this._explicitBackgroundMaxWidth = _loc2_.explicitMaxWidth;
                  this._explicitBackgroundMaxHeight = _loc2_.explicitMaxHeight;
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
         if(this.currentBackgroundSkin !== null)
         {
            this.setRawChildIndexInternal(this.currentBackgroundSkin,0);
         }
      }
      
      protected function refreshScrollBarStyles() : void
      {
         var _loc2_:Object = null;
         if(this.horizontalScrollBar)
         {
            for(var _loc1_ in this._horizontalScrollBarProperties)
            {
               _loc2_ = this._horizontalScrollBarProperties[_loc1_];
               this.horizontalScrollBar[_loc1_] = _loc2_;
            }
            if(this._horizontalScrollBarHideTween)
            {
               Starling.juggler.remove(this._horizontalScrollBarHideTween);
               this._horizontalScrollBarHideTween = null;
            }
            this.horizontalScrollBar.alpha = this._scrollBarDisplayMode == "float" ? 0 : 1;
         }
         if(this.verticalScrollBar)
         {
            for(_loc1_ in this._verticalScrollBarProperties)
            {
               _loc2_ = this._verticalScrollBarProperties[_loc1_];
               this.verticalScrollBar[_loc1_] = _loc2_;
            }
            if(this._verticalScrollBarHideTween)
            {
               Starling.juggler.remove(this._verticalScrollBarHideTween);
               this._verticalScrollBarHideTween = null;
            }
            this.verticalScrollBar.alpha = this._scrollBarDisplayMode == "float" ? 0 : 1;
         }
      }
      
      protected function refreshEnabled() : void
      {
         if(this._viewPort)
         {
            this._viewPort.isEnabled = this._isEnabled;
         }
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.isEnabled = this._isEnabled;
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.isEnabled = this._isEnabled;
         }
      }
      
      override protected function refreshFocusIndicator() : void
      {
         if(this._focusIndicatorSkin)
         {
            if(this._hasFocus && this._showFocus)
            {
               if(this._focusIndicatorSkin.parent != this)
               {
                  this.addRawChildInternal(this._focusIndicatorSkin);
               }
               else
               {
                  this.setRawChildIndexInternal(this._focusIndicatorSkin,this.numRawChildrenInternal - 1);
               }
            }
            else if(this._focusIndicatorSkin.parent == this)
            {
               this.removeRawChildInternal(this._focusIndicatorSkin,false);
            }
            this._focusIndicatorSkin.x = this._focusPaddingLeft;
            this._focusIndicatorSkin.y = this._focusPaddingTop;
            this._focusIndicatorSkin.width = this.actualWidth - this._focusPaddingLeft - this._focusPaddingRight;
            this._focusIndicatorSkin.height = this.actualHeight - this._focusPaddingTop - this._focusPaddingBottom;
         }
      }
      
      protected function refreshViewPortBoundsForMeasurement() : void
      {
         var _loc4_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:Number = this._leftViewPortOffset + this._rightViewPortOffset;
         var _loc1_:Number = this._topViewPortOffset + this._bottomViewPortOffset;
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc5_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc3_:* = this._explicitMinWidth;
         if(_loc3_ !== _loc3_ || this._explicitViewPortMinWidth > _loc3_)
         {
            _loc3_ = this._explicitViewPortMinWidth;
         }
         if(_loc3_ !== _loc3_ || this._explicitWidth > _loc3_)
         {
            _loc3_ = this._explicitWidth;
         }
         switch(_loc5_)
         {
            default:
               _loc4_ = _loc5_.minWidth;
            case null:
               if(_loc3_ !== _loc3_ || _loc4_ > _loc3_)
               {
                  _loc3_ = _loc4_;
               }
               break;
            case null:
         }
         _loc3_ -= _loc2_;
         var _loc7_:* = this._explicitMinHeight;
         if(_loc7_ !== _loc7_ || this._explicitViewPortMinHeight > _loc7_)
         {
            _loc7_ = this._explicitViewPortMinHeight;
         }
         if(_loc7_ !== _loc7_ || this._explicitHeight > _loc7_)
         {
            _loc7_ = this._explicitHeight;
         }
         switch(_loc5_)
         {
            default:
               _loc8_ = _loc5_.minHeight;
            case null:
               if(_loc7_ !== _loc7_ || _loc8_ > _loc7_)
               {
                  _loc7_ = _loc8_;
               }
               break;
            case null:
         }
         _loc7_ -= _loc1_;
         var _loc6_:Boolean = this.ignoreViewPortResizing;
         this.ignoreViewPortResizing = true;
         this._viewPort.visibleWidth = this._explicitWidth - _loc2_;
         this._viewPort.minVisibleWidth = this._explicitMinWidth - _loc2_;
         this._viewPort.maxVisibleWidth = this._explicitMaxWidth - _loc2_;
         this._viewPort.minWidth = _loc3_;
         this._viewPort.visibleHeight = this._explicitHeight - _loc1_;
         this._viewPort.minVisibleHeight = this._explicitMinHeight - _loc1_;
         this._viewPort.maxVisibleHeight = this._explicitMaxHeight - _loc1_;
         this._viewPort.minHeight = _loc7_;
         this._viewPort.validate();
         this.ignoreViewPortResizing = _loc6_;
      }
      
      protected function refreshViewPortBoundsForLayout() : void
      {
         var _loc2_:Number = this._leftViewPortOffset + this._rightViewPortOffset;
         var _loc1_:Number = this._topViewPortOffset + this._bottomViewPortOffset;
         var _loc5_:Boolean = this.ignoreViewPortResizing;
         this.ignoreViewPortResizing = true;
         var _loc3_:Number = this.actualWidth - _loc2_;
         if(this._viewPort.visibleWidth !== _loc3_)
         {
            this._viewPort.visibleWidth = _loc3_;
         }
         this._viewPort.minVisibleWidth = this.actualWidth - _loc2_;
         this._viewPort.maxVisibleWidth = this._explicitMaxWidth - _loc2_;
         this._viewPort.minWidth = _loc3_;
         var _loc4_:Number = this.actualHeight - _loc1_;
         if(this._viewPort.visibleHeight !== _loc4_)
         {
            this._viewPort.visibleHeight = _loc4_;
         }
         this._viewPort.minVisibleHeight = this.actualMinHeight - _loc1_;
         this._viewPort.maxVisibleHeight = this._explicitMaxHeight - _loc1_;
         this._viewPort.minHeight = _loc4_;
         this.ignoreViewPortResizing = _loc5_;
         this._viewPort.validate();
      }
      
      protected function refreshScrollValues() : void
      {
         this.refreshScrollSteps();
         var _loc2_:Number = this._maxHorizontalScrollPosition;
         var _loc3_:Number = this._maxVerticalScrollPosition;
         this.refreshMinAndMaxScrollPositions();
         var _loc1_:Boolean = this._maxHorizontalScrollPosition != _loc2_ || this._maxVerticalScrollPosition != _loc3_;
         if(_loc1_ && this._touchPointID < 0)
         {
            this.clampScrollPositions();
         }
         this.refreshPageCount();
         this.refreshPageIndices();
      }
      
      protected function clampScrollPositions() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(!this._horizontalAutoScrollTween)
         {
            if(this._snapToPages)
            {
               this._horizontalScrollPosition = roundToNearest(this._horizontalScrollPosition,this.actualPageWidth);
            }
            _loc1_ = this._horizontalScrollPosition;
            if(_loc1_ < this._minHorizontalScrollPosition)
            {
               _loc1_ = this._minHorizontalScrollPosition;
            }
            else if(_loc1_ > this._maxHorizontalScrollPosition)
            {
               _loc1_ = this._maxHorizontalScrollPosition;
            }
            this.horizontalScrollPosition = _loc1_;
         }
         if(!this._verticalAutoScrollTween)
         {
            if(this._snapToPages)
            {
               this._verticalScrollPosition = roundToNearest(this._verticalScrollPosition,this.actualPageHeight);
            }
            _loc2_ = this._verticalScrollPosition;
            if(_loc2_ < this._minVerticalScrollPosition)
            {
               _loc2_ = this._minVerticalScrollPosition;
            }
            else if(_loc2_ > this._maxVerticalScrollPosition)
            {
               _loc2_ = this._maxVerticalScrollPosition;
            }
            this.verticalScrollPosition = _loc2_;
         }
      }
      
      protected function refreshScrollSteps() : void
      {
         if(this.explicitHorizontalScrollStep !== this.explicitHorizontalScrollStep)
         {
            if(this._viewPort)
            {
               this.actualHorizontalScrollStep = this._viewPort.horizontalScrollStep;
            }
            else
            {
               this.actualHorizontalScrollStep = 1;
            }
         }
         else
         {
            this.actualHorizontalScrollStep = this.explicitHorizontalScrollStep;
         }
         if(this.explicitVerticalScrollStep !== this.explicitVerticalScrollStep)
         {
            if(this._viewPort)
            {
               this.actualVerticalScrollStep = this._viewPort.verticalScrollStep;
            }
            else
            {
               this.actualVerticalScrollStep = 1;
            }
         }
         else
         {
            this.actualVerticalScrollStep = this.explicitVerticalScrollStep;
         }
      }
      
      protected function refreshMinAndMaxScrollPositions() : void
      {
         var _loc1_:Number = this.actualWidth - (this._leftViewPortOffset + this._rightViewPortOffset);
         var _loc2_:Number = this.actualHeight - (this._topViewPortOffset + this._bottomViewPortOffset);
         if(this.explicitPageWidth !== this.explicitPageWidth)
         {
            this.actualPageWidth = _loc1_;
         }
         if(this.explicitPageHeight !== this.explicitPageHeight)
         {
            this.actualPageHeight = _loc2_;
         }
         if(this._viewPort)
         {
            this._minHorizontalScrollPosition = this._viewPort.contentX;
            if(this._viewPort.width == Infinity)
            {
               this._maxHorizontalScrollPosition = Infinity;
            }
            else
            {
               this._maxHorizontalScrollPosition = this._minHorizontalScrollPosition + this._viewPort.width - _loc1_;
            }
            if(this._maxHorizontalScrollPosition < this._minHorizontalScrollPosition)
            {
               this._maxHorizontalScrollPosition = this._minHorizontalScrollPosition;
            }
            this._minVerticalScrollPosition = this._viewPort.contentY;
            if(this._viewPort.height == Infinity)
            {
               this._maxVerticalScrollPosition = Infinity;
            }
            else
            {
               this._maxVerticalScrollPosition = this._minVerticalScrollPosition + this._viewPort.height - _loc2_;
            }
            if(this._maxVerticalScrollPosition < this._minVerticalScrollPosition)
            {
               this._maxVerticalScrollPosition = this._minVerticalScrollPosition;
            }
         }
         else
         {
            this._minHorizontalScrollPosition = 0;
            this._minVerticalScrollPosition = 0;
            this._maxHorizontalScrollPosition = 0;
            this._maxVerticalScrollPosition = 0;
         }
      }
      
      protected function refreshPageCount() : void
      {
         var _loc1_:* = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:* = NaN;
         if(this._snapToPages)
         {
            _loc1_ = this._maxHorizontalScrollPosition - this._minHorizontalScrollPosition;
            if(_loc1_ == Infinity)
            {
               if(this._minHorizontalScrollPosition == -Infinity)
               {
                  this._minHorizontalPageIndex = -2147483648;
               }
               else
               {
                  this._minHorizontalPageIndex = 0;
               }
               this._maxHorizontalPageIndex = 2147483647;
            }
            else
            {
               this._minHorizontalPageIndex = 0;
               _loc2_ = roundDownToNearest(_loc1_,this.actualPageWidth);
               if(_loc1_ - _loc2_ < 0.000001)
               {
                  _loc1_ = _loc2_;
               }
               this._maxHorizontalPageIndex = Math.ceil(_loc1_ / this.actualPageWidth);
            }
            _loc3_ = this._maxVerticalScrollPosition - this._minVerticalScrollPosition;
            if(_loc3_ == Infinity)
            {
               if(this._minVerticalScrollPosition == -Infinity)
               {
                  this._minVerticalPageIndex = -2147483648;
               }
               else
               {
                  this._minVerticalPageIndex = 0;
               }
               this._maxVerticalPageIndex = 2147483647;
            }
            else
            {
               this._minVerticalPageIndex = 0;
               _loc2_ = roundDownToNearest(_loc3_,this.actualPageHeight);
               if(_loc3_ - _loc2_ < 0.000001)
               {
                  _loc3_ = _loc2_;
               }
               this._maxVerticalPageIndex = Math.ceil(_loc3_ / this.actualPageHeight);
            }
         }
         else
         {
            this._maxHorizontalPageIndex = 0;
            this._maxHorizontalPageIndex = 0;
            this._minVerticalPageIndex = 0;
            this._maxVerticalPageIndex = 0;
         }
      }
      
      protected function refreshPageIndices() : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc1_:int = 0;
         var _loc4_:Number = NaN;
         if(!this._horizontalAutoScrollTween && !this.hasPendingHorizontalPageIndex)
         {
            if(this._snapToPages)
            {
               if(this._horizontalScrollPosition == this._maxHorizontalScrollPosition)
               {
                  this._horizontalPageIndex = this._maxHorizontalPageIndex;
               }
               else if(this._horizontalScrollPosition == this._minHorizontalScrollPosition)
               {
                  this._horizontalPageIndex = this._minHorizontalPageIndex;
               }
               else
               {
                  if(this._minHorizontalScrollPosition == -Infinity && this._horizontalScrollPosition < 0)
                  {
                     _loc3_ = this._horizontalScrollPosition / this.actualPageWidth;
                  }
                  else if(this._maxHorizontalScrollPosition == Infinity && this._horizontalScrollPosition >= 0)
                  {
                     _loc3_ = this._horizontalScrollPosition / this.actualPageWidth;
                  }
                  else
                  {
                     _loc2_ = this._horizontalScrollPosition - this._minHorizontalScrollPosition;
                     _loc3_ = _loc2_ / this.actualPageWidth;
                  }
                  _loc1_ = Math.round(_loc3_);
                  if(_loc3_ !== _loc1_ && MathUtil.isEquivalent(_loc3_,_loc1_,0.01))
                  {
                     this._horizontalPageIndex = _loc1_;
                  }
                  else
                  {
                     this._horizontalPageIndex = Math.floor(_loc3_);
                  }
               }
            }
            else
            {
               this._horizontalPageIndex = this._minHorizontalPageIndex;
            }
            if(this._horizontalPageIndex < this._minHorizontalPageIndex)
            {
               this._horizontalPageIndex = this._minHorizontalPageIndex;
            }
            if(this._horizontalPageIndex > this._maxHorizontalPageIndex)
            {
               this._horizontalPageIndex = this._maxHorizontalPageIndex;
            }
         }
         if(!this._verticalAutoScrollTween && !this.hasPendingVerticalPageIndex)
         {
            if(this._snapToPages)
            {
               if(this._verticalScrollPosition == this._maxVerticalScrollPosition)
               {
                  this._verticalPageIndex = this._maxVerticalPageIndex;
               }
               else if(this._verticalScrollPosition == this._minVerticalScrollPosition)
               {
                  this._verticalPageIndex = this._minVerticalPageIndex;
               }
               else
               {
                  if(this._minVerticalScrollPosition == -Infinity && this._verticalScrollPosition < 0)
                  {
                     _loc3_ = this._verticalScrollPosition / this.actualPageHeight;
                  }
                  else if(this._maxVerticalScrollPosition == Infinity && this._verticalScrollPosition >= 0)
                  {
                     _loc3_ = this._verticalScrollPosition / this.actualPageHeight;
                  }
                  else
                  {
                     _loc3_ = (_loc4_ = this._verticalScrollPosition - this._minVerticalScrollPosition) / this.actualPageHeight;
                  }
                  _loc1_ = Math.round(_loc3_);
                  if(_loc3_ !== _loc1_ && MathUtil.isEquivalent(_loc3_,_loc1_,0.01))
                  {
                     this._verticalPageIndex = _loc1_;
                  }
                  else
                  {
                     this._verticalPageIndex = Math.floor(_loc3_);
                  }
               }
            }
            else
            {
               this._verticalPageIndex = this._minVerticalScrollPosition;
            }
            if(this._verticalPageIndex < this._minVerticalScrollPosition)
            {
               this._verticalPageIndex = this._minVerticalScrollPosition;
            }
            if(this._verticalPageIndex > this._maxVerticalPageIndex)
            {
               this._verticalPageIndex = this._maxVerticalPageIndex;
            }
         }
      }
      
      protected function refreshScrollBarValues() : void
      {
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.minimum = this._minHorizontalScrollPosition;
            this.horizontalScrollBar.maximum = this._maxHorizontalScrollPosition;
            this.horizontalScrollBar.value = this._horizontalScrollPosition;
            this.horizontalScrollBar.page = (this._maxHorizontalScrollPosition - this._minHorizontalScrollPosition) * this.actualPageWidth / this._viewPort.width;
            this.horizontalScrollBar.step = this.actualHorizontalScrollStep;
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.minimum = this._minVerticalScrollPosition;
            this.verticalScrollBar.maximum = this._maxVerticalScrollPosition;
            this.verticalScrollBar.value = this._verticalScrollPosition;
            this.verticalScrollBar.page = (this._maxVerticalScrollPosition - this._minVerticalScrollPosition) * this.actualPageHeight / this._viewPort.height;
            this.verticalScrollBar.step = this.actualVerticalScrollStep;
         }
      }
      
      protected function showOrHideChildren() : void
      {
         var _loc1_:int = this.numRawChildrenInternal;
         if(this._touchBlocker !== null && this._touchBlocker.parent !== null)
         {
            _loc1_--;
         }
         if(this.verticalScrollBar)
         {
            this.verticalScrollBar.visible = this._hasVerticalScrollBar;
            this.verticalScrollBar.touchable = this._hasVerticalScrollBar && this._interactionMode != "touch";
            this.setRawChildIndexInternal(DisplayObject(this.verticalScrollBar),_loc1_ - 1);
         }
         if(this.horizontalScrollBar)
         {
            this.horizontalScrollBar.visible = this._hasHorizontalScrollBar;
            this.horizontalScrollBar.touchable = this._hasHorizontalScrollBar && this._interactionMode != "touch";
            if(this.verticalScrollBar)
            {
               this.setRawChildIndexInternal(DisplayObject(this.horizontalScrollBar),_loc1_ - 2);
            }
            else
            {
               this.setRawChildIndexInternal(DisplayObject(this.horizontalScrollBar),_loc1_ - 1);
            }
         }
         if(this.currentBackgroundSkin)
         {
            if(this._autoHideBackground)
            {
               this.currentBackgroundSkin.visible = this._viewPort.width <= this.actualWidth || this._viewPort.height <= this.actualHeight || this._horizontalScrollPosition < 0 || this._horizontalScrollPosition > this._maxHorizontalScrollPosition || this._verticalScrollPosition < 0 || this._verticalScrollPosition > this._maxVerticalScrollPosition;
            }
            else
            {
               this.currentBackgroundSkin.visible = true;
            }
         }
      }
      
      protected function calculateViewPortOffsetsForFixedHorizontalScrollBar(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.horizontalScrollBar && (this._measureViewPort || param2))
         {
            _loc3_ = param2 ? this.actualWidth : this._explicitWidth;
            _loc4_ = this._viewPort.width + this._leftViewPortOffset + this._rightViewPortOffset;
            if(param1 || this._horizontalScrollPolicy == "on" || (_loc4_ > _loc3_ || _loc4_ > this._explicitMaxWidth) && this._horizontalScrollPolicy != "off")
            {
               this._hasHorizontalScrollBar = true;
               if(this._scrollBarDisplayMode == "fixed")
               {
                  this._bottomViewPortOffset += this.horizontalScrollBar.height;
               }
            }
            else
            {
               this._hasHorizontalScrollBar = false;
            }
         }
         else
         {
            this._hasHorizontalScrollBar = false;
         }
      }
      
      protected function calculateViewPortOffsetsForFixedVerticalScrollBar(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc4_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.verticalScrollBar && (this._measureViewPort || param2))
         {
            _loc4_ = param2 ? this.actualHeight : this._explicitHeight;
            _loc3_ = this._viewPort.height + this._topViewPortOffset + this._bottomViewPortOffset;
            if(param1 || this._verticalScrollPolicy == "on" || (_loc3_ > _loc4_ || _loc3_ > this._explicitMaxHeight) && this._verticalScrollPolicy != "off")
            {
               this._hasVerticalScrollBar = true;
               if(this._scrollBarDisplayMode == "fixed")
               {
                  if(this._verticalScrollBarPosition == "left")
                  {
                     this._leftViewPortOffset += this.verticalScrollBar.width;
                  }
                  else
                  {
                     this._rightViewPortOffset += this.verticalScrollBar.width;
                  }
               }
            }
            else
            {
               this._hasVerticalScrollBar = false;
            }
         }
         else
         {
            this._hasVerticalScrollBar = false;
         }
      }
      
      protected function calculateViewPortOffsets(param1:Boolean = false, param2:Boolean = false) : void
      {
         this._topViewPortOffset = this._paddingTop;
         this._rightViewPortOffset = this._paddingRight;
         this._bottomViewPortOffset = this._paddingBottom;
         this._leftViewPortOffset = this._paddingLeft;
         this.calculateViewPortOffsetsForFixedHorizontalScrollBar(param1,param2);
         this.calculateViewPortOffsetsForFixedVerticalScrollBar(param1,param2);
         if(this._scrollBarDisplayMode == "fixed" && this._hasVerticalScrollBar && !this._hasHorizontalScrollBar)
         {
            this.calculateViewPortOffsetsForFixedHorizontalScrollBar(param1,param2);
         }
      }
      
      protected function refreshInteractionModeEvents() : void
      {
         if(this._interactionMode == "touch" || this._interactionMode == "touchAndScrollBars")
         {
            this.addEventListener("touch",scroller_touchHandler);
            if(!this._touchBlocker)
            {
               this._touchBlocker = new Quad(100,100,16711935);
               this._touchBlocker.alpha = 0;
            }
         }
         else
         {
            this.removeEventListener("touch",scroller_touchHandler);
            if(this._touchBlocker)
            {
               this.removeRawChildInternal(this._touchBlocker,true);
               this._touchBlocker = null;
            }
         }
         if((this._interactionMode == "mouse" || this._interactionMode == "touchAndScrollBars") && this._scrollBarDisplayMode == "float")
         {
            if(this.horizontalScrollBar)
            {
               this.horizontalScrollBar.addEventListener("touch",horizontalScrollBar_touchHandler);
            }
            if(this.verticalScrollBar)
            {
               this.verticalScrollBar.addEventListener("touch",verticalScrollBar_touchHandler);
            }
         }
         else
         {
            if(this.horizontalScrollBar)
            {
               this.horizontalScrollBar.removeEventListener("touch",horizontalScrollBar_touchHandler);
            }
            if(this.verticalScrollBar)
            {
               this.verticalScrollBar.removeEventListener("touch",verticalScrollBar_touchHandler);
            }
         }
      }
      
      protected function layoutChildren() : void
      {
         var _loc1_:Starling = null;
         var _loc4_:Number = NaN;
         var _loc2_:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
         var _loc3_:Number = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
         if(this.currentBackgroundSkin !== null)
         {
            this.currentBackgroundSkin.width = this.actualWidth;
            this.currentBackgroundSkin.height = this.actualHeight;
         }
         if(this.horizontalScrollBar !== null)
         {
            this.horizontalScrollBar.validate();
         }
         if(this.verticalScrollBar !== null)
         {
            this.verticalScrollBar.validate();
         }
         if(this._touchBlocker !== null)
         {
            this._touchBlocker.x = this._leftViewPortOffset;
            this._touchBlocker.y = this._topViewPortOffset;
            this._touchBlocker.width = _loc2_;
            this._touchBlocker.height = _loc3_;
         }
         if(this._snapScrollPositionsToPixels)
         {
            _loc1_ = stageToStarling(this.stage);
            if(_loc1_ === null)
            {
               _loc1_ = Starling.current;
            }
            _loc4_ = 1 / _loc1_.contentScaleFactor;
            this._viewPort.x = Math.round((this._leftViewPortOffset - this._horizontalScrollPosition) / _loc4_) * _loc4_;
            this._viewPort.y = Math.round((this._topViewPortOffset - this._verticalScrollPosition) / _loc4_) * _loc4_;
         }
         else
         {
            this._viewPort.x = this._leftViewPortOffset - this._horizontalScrollPosition;
            this._viewPort.y = this._topViewPortOffset - this._verticalScrollPosition;
         }
         if(this.horizontalScrollBar !== null)
         {
            this.horizontalScrollBar.x = this._leftViewPortOffset;
            this.horizontalScrollBar.y = this._topViewPortOffset + _loc3_;
            if(this._scrollBarDisplayMode !== "fixed")
            {
               this.horizontalScrollBar.y -= this.horizontalScrollBar.height;
               if((this._hasVerticalScrollBar || this._verticalScrollBarHideTween) && this.verticalScrollBar)
               {
                  this.horizontalScrollBar.width = _loc2_ - this.verticalScrollBar.width;
               }
               else
               {
                  this.horizontalScrollBar.width = _loc2_;
               }
            }
            else
            {
               this.horizontalScrollBar.width = _loc2_;
            }
         }
         if(this.verticalScrollBar !== null)
         {
            if(this._verticalScrollBarPosition === "left")
            {
               this.verticalScrollBar.x = this._paddingLeft;
            }
            else
            {
               this.verticalScrollBar.x = this._leftViewPortOffset + _loc2_;
            }
            this.verticalScrollBar.y = this._topViewPortOffset;
            if(this._scrollBarDisplayMode !== "fixed")
            {
               this.verticalScrollBar.x -= this.verticalScrollBar.width;
               if((this._hasHorizontalScrollBar || this._horizontalScrollBarHideTween) && this.horizontalScrollBar)
               {
                  this.verticalScrollBar.height = _loc3_ - this.horizontalScrollBar.height;
               }
               else
               {
                  this.verticalScrollBar.height = _loc3_;
               }
            }
            else
            {
               this.verticalScrollBar.height = _loc3_;
            }
         }
      }
      
      protected function refreshMask() : void
      {
         if(!this._clipContent)
         {
            return;
         }
         var _loc1_:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         var _loc2_:Number = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         var _loc3_:Quad = this._viewPort.mask as Quad;
         if(!_loc3_)
         {
            _loc3_ = new Quad(1,1,1044735);
            this._viewPort.mask = _loc3_;
         }
         _loc3_.x = this._horizontalScrollPosition;
         _loc3_.y = this._verticalScrollPosition;
         _loc3_.width = _loc1_;
         _loc3_.height = _loc2_;
      }
      
      protected function get numRawChildrenInternal() : int
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).numRawChildren;
         }
         return this.numChildren;
      }
      
      protected function addRawChildInternal(param1:DisplayObject) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).addRawChild(param1);
         }
         return this.addChild(param1);
      }
      
      protected function addRawChildAtInternal(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).addRawChildAt(param1,param2);
         }
         return this.addChildAt(param1,param2);
      }
      
      protected function removeRawChildInternal(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).removeRawChild(param1,param2);
         }
         return this.removeChild(param1,param2);
      }
      
      protected function removeRawChildAtInternal(param1:int, param2:Boolean = false) : DisplayObject
      {
         if(this is IScrollContainer)
         {
            return IScrollContainer(this).removeRawChildAt(param1,param2);
         }
         return this.removeChildAt(param1,param2);
      }
      
      protected function setRawChildIndexInternal(param1:DisplayObject, param2:int) : void
      {
         if(this is IScrollContainer)
         {
            IScrollContainer(this).setRawChildIndex(param1,param2);
            return;
         }
         this.setChildIndex(param1,param2);
      }
      
      protected function updateHorizontalScrollFromTouchPosition(param1:Number) : void
      {
         var _loc2_:Number = this._startTouchX - param1;
         var _loc3_:Number = this._startHorizontalScrollPosition + _loc2_;
         if(_loc3_ < this._minHorizontalScrollPosition)
         {
            if(this._hasElasticEdges)
            {
               _loc3_ -= (_loc3_ - this._minHorizontalScrollPosition) * (1 - this._elasticity);
            }
            else
            {
               _loc3_ = this._minHorizontalScrollPosition;
            }
         }
         else if(_loc3_ > this._maxHorizontalScrollPosition)
         {
            if(this._hasElasticEdges)
            {
               _loc3_ -= (_loc3_ - this._maxHorizontalScrollPosition) * (1 - this._elasticity);
            }
            else
            {
               _loc3_ = this._maxHorizontalScrollPosition;
            }
         }
         this.horizontalScrollPosition = _loc3_;
      }
      
      protected function updateVerticalScrollFromTouchPosition(param1:Number) : void
      {
         var _loc2_:Number = this._startTouchY - param1;
         var _loc3_:Number = this._startVerticalScrollPosition + _loc2_;
         if(_loc3_ < this._minVerticalScrollPosition)
         {
            if(this._hasElasticEdges)
            {
               _loc3_ -= (_loc3_ - this._minVerticalScrollPosition) * (1 - this._elasticity);
            }
            else
            {
               _loc3_ = this._minVerticalScrollPosition;
            }
         }
         else if(_loc3_ > this._maxVerticalScrollPosition)
         {
            if(this._hasElasticEdges)
            {
               _loc3_ -= (_loc3_ - this._maxVerticalScrollPosition) * (1 - this._elasticity);
            }
            else
            {
               _loc3_ = this._maxVerticalScrollPosition;
            }
         }
         this.verticalScrollPosition = _loc3_;
      }
      
      protected function throwTo(param1:Number = NaN, param2:Number = NaN, param3:Number = 0.5) : void
      {
         var _loc4_:Boolean = false;
         if(param1 === param1)
         {
            if(this._snapToPages && param1 > this._minHorizontalScrollPosition && param1 < this._maxHorizontalScrollPosition)
            {
               param1 = roundToNearest(param1,this.actualPageWidth);
            }
            if(this._horizontalAutoScrollTween)
            {
               Starling.juggler.remove(this._horizontalAutoScrollTween);
               this._horizontalAutoScrollTween = null;
            }
            if(this._horizontalScrollPosition != param1)
            {
               _loc4_ = true;
               this.revealHorizontalScrollBar();
               this.startScroll();
               if(param3 == 0)
               {
                  this.horizontalScrollPosition = param1;
               }
               else
               {
                  this._startHorizontalScrollPosition = this._horizontalScrollPosition;
                  this._targetHorizontalScrollPosition = param1;
                  this._horizontalAutoScrollTween = new Tween(this,param3,this._throwEase);
                  this._horizontalAutoScrollTween.animate("horizontalScrollPosition",param1);
                  this._horizontalAutoScrollTween.onComplete = horizontalAutoScrollTween_onComplete;
                  Starling.juggler.add(this._horizontalAutoScrollTween);
                  this.refreshHorizontalAutoScrollTweenEndRatio();
               }
            }
            else
            {
               this.finishScrollingHorizontally();
            }
         }
         if(param2 === param2)
         {
            if(this._snapToPages && param2 > this._minVerticalScrollPosition && param2 < this._maxVerticalScrollPosition)
            {
               param2 = roundToNearest(param2,this.actualPageHeight);
            }
            if(this._verticalAutoScrollTween)
            {
               Starling.juggler.remove(this._verticalAutoScrollTween);
               this._verticalAutoScrollTween = null;
            }
            if(this._verticalScrollPosition != param2)
            {
               _loc4_ = true;
               this.revealVerticalScrollBar();
               this.startScroll();
               if(param3 == 0)
               {
                  this.verticalScrollPosition = param2;
               }
               else
               {
                  this._startVerticalScrollPosition = this._verticalScrollPosition;
                  this._targetVerticalScrollPosition = param2;
                  this._verticalAutoScrollTween = new Tween(this,param3,this._throwEase);
                  this._verticalAutoScrollTween.animate("verticalScrollPosition",param2);
                  this._verticalAutoScrollTween.onComplete = verticalAutoScrollTween_onComplete;
                  Starling.juggler.add(this._verticalAutoScrollTween);
                  this.refreshVerticalAutoScrollTweenEndRatio();
               }
            }
            else
            {
               this.finishScrollingVertically();
            }
         }
         if(_loc4_ && param3 == 0)
         {
            this.completeScroll();
         }
      }
      
      protected function throwToPage(param1:int, param2:int, param3:Number = 0.5) : void
      {
         var _loc4_:Number = this._horizontalScrollPosition;
         if(param1 >= this._minHorizontalPageIndex)
         {
            _loc4_ = this.actualPageWidth * param1;
         }
         if(_loc4_ < this._minHorizontalScrollPosition)
         {
            _loc4_ = this._minHorizontalScrollPosition;
         }
         if(_loc4_ > this._maxHorizontalScrollPosition)
         {
            _loc4_ = this._maxHorizontalScrollPosition;
         }
         var _loc5_:Number = this._verticalScrollPosition;
         if(param2 >= this._minVerticalPageIndex)
         {
            _loc5_ = this.actualPageHeight * param2;
         }
         if(_loc5_ < this._minVerticalScrollPosition)
         {
            _loc5_ = this._minVerticalScrollPosition;
         }
         if(_loc5_ > this._maxVerticalScrollPosition)
         {
            _loc5_ = this._maxVerticalScrollPosition;
         }
         if(param3 > 0)
         {
            this.throwTo(_loc4_,_loc5_,param3);
         }
         else
         {
            this.horizontalScrollPosition = _loc4_;
            this.verticalScrollPosition = _loc5_;
         }
         if(param1 >= this._minHorizontalPageIndex)
         {
            this._horizontalPageIndex = param1;
         }
         if(param2 >= this._minVerticalPageIndex)
         {
            this._verticalPageIndex = param2;
         }
      }
      
      protected function calculateDynamicThrowDuration(param1:Number) : Number
      {
         return Math.log(0.02 / Math.abs(param1)) / this._logDecelerationRate / 1000;
      }
      
      protected function calculateThrowDistance(param1:Number) : Number
      {
         return (param1 - 0.02) / this._logDecelerationRate;
      }
      
      protected function finishScrollingHorizontally() : void
      {
         var _loc1_:Number = NaN;
         if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
         {
            _loc1_ = this._minHorizontalScrollPosition;
         }
         else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
         {
            _loc1_ = this._maxHorizontalScrollPosition;
         }
         this._isDraggingHorizontally = false;
         if(_loc1_ !== _loc1_)
         {
            this.completeScroll();
         }
         else if(Math.abs(_loc1_ - this._horizontalScrollPosition) < 1)
         {
            this.horizontalScrollPosition = _loc1_;
            this.completeScroll();
         }
         else
         {
            this.throwTo(_loc1_,NaN,this._elasticSnapDuration);
         }
      }
      
      protected function finishScrollingVertically() : void
      {
         var _loc1_:Number = NaN;
         if(this._verticalScrollPosition < this._minVerticalScrollPosition)
         {
            _loc1_ = this._minVerticalScrollPosition;
         }
         else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
         {
            _loc1_ = this._maxVerticalScrollPosition;
         }
         this._isDraggingVertically = false;
         if(_loc1_ !== _loc1_)
         {
            this.completeScroll();
         }
         else if(Math.abs(_loc1_ - this._verticalScrollPosition) < 1)
         {
            this.verticalScrollPosition = _loc1_;
            this.completeScroll();
         }
         else
         {
            this.throwTo(NaN,_loc1_,this._elasticSnapDuration);
         }
      }
      
      protected function throwHorizontally(param1:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc8_:int = 0;
         if(this._snapToPages && !this._snapOnComplete)
         {
            if((_loc4_ = 1000 * param1 / (DeviceCapabilities.dpi / Starling.contentScaleFactor)) > this._minimumPageThrowVelocity)
            {
               _loc5_ = roundDownToNearest(this._horizontalScrollPosition,this.actualPageWidth);
            }
            else if(_loc4_ < -this._minimumPageThrowVelocity)
            {
               _loc5_ = roundUpToNearest(this._horizontalScrollPosition,this.actualPageWidth);
            }
            else
            {
               _loc6_ = this._maxHorizontalScrollPosition % this.actualPageWidth;
               _loc7_ = this._maxHorizontalScrollPosition - _loc6_;
               if(_loc6_ < this.actualPageWidth && this._horizontalScrollPosition >= _loc7_)
               {
                  _loc9_ = this._horizontalScrollPosition - _loc7_;
                  if(_loc4_ > this._minimumPageThrowVelocity)
                  {
                     _loc5_ = _loc7_ + roundDownToNearest(_loc9_,_loc6_);
                  }
                  else if(_loc4_ < -this._minimumPageThrowVelocity)
                  {
                     _loc5_ = _loc7_ + roundUpToNearest(_loc9_,_loc6_);
                  }
                  else
                  {
                     _loc5_ = _loc7_ + roundToNearest(_loc9_,_loc6_);
                  }
               }
               else
               {
                  _loc5_ = roundToNearest(this._horizontalScrollPosition,this.actualPageWidth);
               }
            }
            if(_loc5_ < this._minHorizontalScrollPosition)
            {
               _loc5_ = this._minHorizontalScrollPosition;
            }
            else if(_loc5_ > this._maxHorizontalScrollPosition)
            {
               _loc5_ = this._maxHorizontalScrollPosition;
            }
            if(_loc5_ == this._maxHorizontalScrollPosition)
            {
               _loc8_ = this._maxHorizontalPageIndex;
            }
            else if(this._minHorizontalScrollPosition == -Infinity)
            {
               _loc8_ = Math.round(_loc5_ / this.actualPageWidth);
            }
            else
            {
               _loc8_ = Math.round((_loc5_ - this._minHorizontalScrollPosition) / this.actualPageWidth);
            }
            this.throwToPage(_loc8_,-1,this._pageThrowDuration);
            return;
         }
         var _loc3_:Number = Math.abs(param1);
         if(!this._snapToPages && _loc3_ <= 0.02)
         {
            this.finishScrollingHorizontally();
            return;
         }
         var _loc2_:Number = this._fixedThrowDuration;
         if(!this._useFixedThrowDuration)
         {
            _loc2_ = this.calculateDynamicThrowDuration(param1);
         }
         this.throwTo(this._horizontalScrollPosition + this.calculateThrowDistance(param1),NaN,_loc2_);
      }
      
      protected function throwVertically(param1:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         if(this._snapToPages && !this._snapOnComplete)
         {
            if((_loc4_ = 1000 * param1 / (DeviceCapabilities.dpi / Starling.contentScaleFactor)) > this._minimumPageThrowVelocity)
            {
               _loc6_ = roundDownToNearest(this._verticalScrollPosition,this.actualPageHeight);
            }
            else if(_loc4_ < -this._minimumPageThrowVelocity)
            {
               _loc6_ = roundUpToNearest(this._verticalScrollPosition,this.actualPageHeight);
            }
            else
            {
               _loc9_ = this._maxVerticalScrollPosition % this.actualPageHeight;
               _loc5_ = this._maxVerticalScrollPosition - _loc9_;
               if(_loc9_ < this.actualPageHeight && this._verticalScrollPosition >= _loc5_)
               {
                  _loc7_ = this._verticalScrollPosition - _loc5_;
                  if(_loc4_ > this._minimumPageThrowVelocity)
                  {
                     _loc6_ = _loc5_ + roundDownToNearest(_loc7_,_loc9_);
                  }
                  else if(_loc4_ < -this._minimumPageThrowVelocity)
                  {
                     _loc6_ = _loc5_ + roundUpToNearest(_loc7_,_loc9_);
                  }
                  else
                  {
                     _loc6_ = _loc5_ + roundToNearest(_loc7_,_loc9_);
                  }
               }
               else
               {
                  _loc6_ = roundToNearest(this._verticalScrollPosition,this.actualPageHeight);
               }
            }
            if(_loc6_ < this._minVerticalScrollPosition)
            {
               _loc6_ = this._minVerticalScrollPosition;
            }
            else if(_loc6_ > this._maxVerticalScrollPosition)
            {
               _loc6_ = this._maxVerticalScrollPosition;
            }
            if(_loc6_ == this._maxVerticalScrollPosition)
            {
               _loc8_ = this._maxVerticalPageIndex;
            }
            else if(this._minVerticalScrollPosition == -Infinity)
            {
               _loc8_ = Math.round(_loc6_ / this.actualPageHeight);
            }
            else
            {
               _loc8_ = Math.round((_loc6_ - this._minVerticalScrollPosition) / this.actualPageHeight);
            }
            this.throwToPage(-1,_loc8_,this._pageThrowDuration);
            return;
         }
         var _loc3_:Number = Math.abs(param1);
         if(!this._snapToPages && _loc3_ <= 0.02)
         {
            this.finishScrollingVertically();
            return;
         }
         var _loc2_:Number = this._fixedThrowDuration;
         if(!this._useFixedThrowDuration)
         {
            _loc2_ = this.calculateDynamicThrowDuration(param1);
         }
         this.throwTo(NaN,this._verticalScrollPosition + this.calculateThrowDistance(param1),_loc2_);
      }
      
      protected function onHorizontalAutoScrollTweenUpdate() : void
      {
         var _loc1_:Number = this._horizontalAutoScrollTween.transitionFunc(this._horizontalAutoScrollTween.currentTime / this._horizontalAutoScrollTween.totalTime);
         if(_loc1_ >= this._horizontalAutoScrollTweenEndRatio)
         {
            if(!this._hasElasticEdges)
            {
               if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
               {
                  this._horizontalScrollPosition = this._minHorizontalScrollPosition;
               }
               else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
               {
                  this._horizontalScrollPosition = this._maxHorizontalScrollPosition;
               }
            }
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
            this.finishScrollingHorizontally();
         }
      }
      
      protected function onVerticalAutoScrollTweenUpdate() : void
      {
         var _loc1_:Number = this._verticalAutoScrollTween.transitionFunc(this._verticalAutoScrollTween.currentTime / this._verticalAutoScrollTween.totalTime);
         if(_loc1_ >= this._verticalAutoScrollTweenEndRatio)
         {
            if(!this._hasElasticEdges)
            {
               if(this._verticalScrollPosition < this._minVerticalScrollPosition)
               {
                  this._verticalScrollPosition = this._minVerticalScrollPosition;
               }
               else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
               {
                  this._verticalScrollPosition = this._maxVerticalScrollPosition;
               }
            }
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
            this.finishScrollingVertically();
         }
      }
      
      protected function refreshHorizontalAutoScrollTweenEndRatio() : void
      {
         var _loc2_:Number = Math.abs(this._targetHorizontalScrollPosition - this._startHorizontalScrollPosition);
         var _loc1_:Number = 0;
         if(this._targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
         {
            _loc1_ = (this._targetHorizontalScrollPosition - this._maxHorizontalScrollPosition) / _loc2_;
         }
         else if(this._targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
         {
            _loc1_ = (this._minHorizontalScrollPosition - this._targetHorizontalScrollPosition) / _loc2_;
         }
         if(_loc1_ > 0)
         {
            if(this._hasElasticEdges)
            {
               this._horizontalAutoScrollTweenEndRatio = 1 - _loc1_ + _loc1_ * this._throwElasticity;
            }
            else
            {
               this._horizontalAutoScrollTweenEndRatio = 1 - _loc1_;
            }
         }
         else
         {
            this._horizontalAutoScrollTweenEndRatio = 1;
         }
         if(this._horizontalAutoScrollTween)
         {
            if(this._horizontalAutoScrollTweenEndRatio < 1)
            {
               this._horizontalAutoScrollTween.onUpdate = onHorizontalAutoScrollTweenUpdate;
            }
            else
            {
               this._horizontalAutoScrollTween.onUpdate = null;
            }
         }
      }
      
      protected function refreshVerticalAutoScrollTweenEndRatio() : void
      {
         var _loc2_:Number = Math.abs(this._targetVerticalScrollPosition - this._startVerticalScrollPosition);
         var _loc1_:Number = 0;
         if(this._targetVerticalScrollPosition > this._maxVerticalScrollPosition)
         {
            _loc1_ = (this._targetVerticalScrollPosition - this._maxVerticalScrollPosition) / _loc2_;
         }
         else if(this._targetVerticalScrollPosition < this._minVerticalScrollPosition)
         {
            _loc1_ = (this._minVerticalScrollPosition - this._targetVerticalScrollPosition) / _loc2_;
         }
         if(_loc1_ > 0)
         {
            if(this._hasElasticEdges)
            {
               this._verticalAutoScrollTweenEndRatio = 1 - _loc1_ + _loc1_ * this._throwElasticity;
            }
            else
            {
               this._verticalAutoScrollTweenEndRatio = 1 - _loc1_;
            }
         }
         else
         {
            this._verticalAutoScrollTweenEndRatio = 1;
         }
         if(this._verticalAutoScrollTween)
         {
            if(this._verticalAutoScrollTweenEndRatio < 1)
            {
               this._verticalAutoScrollTween.onUpdate = onVerticalAutoScrollTweenUpdate;
            }
            else
            {
               this._verticalAutoScrollTween.onUpdate = null;
            }
         }
      }
      
      protected function hideHorizontalScrollBar(param1:Number = 0) : void
      {
         if(!this.horizontalScrollBar || this._scrollBarDisplayMode != "float" || this._horizontalScrollBarHideTween)
         {
            return;
         }
         if(this.horizontalScrollBar.alpha == 0)
         {
            return;
         }
         if(this._hideScrollBarAnimationDuration == 0 && param1 == 0)
         {
            this.horizontalScrollBar.alpha = 0;
         }
         else
         {
            this._horizontalScrollBarHideTween = new Tween(this.horizontalScrollBar,this._hideScrollBarAnimationDuration,this._hideScrollBarAnimationEase);
            this._horizontalScrollBarHideTween.fadeTo(0);
            this._horizontalScrollBarHideTween.delay = param1;
            this._horizontalScrollBarHideTween.onComplete = horizontalScrollBarHideTween_onComplete;
            Starling.juggler.add(this._horizontalScrollBarHideTween);
         }
      }
      
      protected function hideVerticalScrollBar(param1:Number = 0) : void
      {
         if(!this.verticalScrollBar || this._scrollBarDisplayMode != "float" || this._verticalScrollBarHideTween)
         {
            return;
         }
         if(this.verticalScrollBar.alpha == 0)
         {
            return;
         }
         if(this._hideScrollBarAnimationDuration == 0 && param1 == 0)
         {
            this.verticalScrollBar.alpha = 0;
         }
         else
         {
            this._verticalScrollBarHideTween = new Tween(this.verticalScrollBar,this._hideScrollBarAnimationDuration,this._hideScrollBarAnimationEase);
            this._verticalScrollBarHideTween.fadeTo(0);
            this._verticalScrollBarHideTween.delay = param1;
            this._verticalScrollBarHideTween.onComplete = verticalScrollBarHideTween_onComplete;
            Starling.juggler.add(this._verticalScrollBarHideTween);
         }
      }
      
      protected function revealHorizontalScrollBar() : void
      {
         if(!this.horizontalScrollBar || this._scrollBarDisplayMode != "float")
         {
            return;
         }
         if(this._horizontalScrollBarHideTween)
         {
            Starling.juggler.remove(this._horizontalScrollBarHideTween);
            this._horizontalScrollBarHideTween = null;
         }
         this.horizontalScrollBar.alpha = 1;
      }
      
      protected function revealVerticalScrollBar() : void
      {
         if(!this.verticalScrollBar || this._scrollBarDisplayMode != "float")
         {
            return;
         }
         if(this._verticalScrollBarHideTween)
         {
            Starling.juggler.remove(this._verticalScrollBarHideTween);
            this._verticalScrollBarHideTween = null;
         }
         this.verticalScrollBar.alpha = 1;
      }
      
      protected function startScroll() : void
      {
         if(this._isScrolling)
         {
            return;
         }
         this._isScrolling = true;
         if(this._touchBlocker)
         {
            this.addRawChildInternal(this._touchBlocker);
         }
         this.dispatchEventWith("scrollStart");
      }
      
      protected function completeScroll() : void
      {
         if(!this._isScrolling || this._verticalAutoScrollTween || this._horizontalAutoScrollTween || this._isDraggingHorizontally || this._isDraggingVertically || this._horizontalScrollBarIsScrolling || this._verticalScrollBarIsScrolling)
         {
            return;
         }
         this._isScrolling = false;
         if(this._touchBlocker)
         {
            this.removeRawChildInternal(this._touchBlocker,false);
         }
         this.hideHorizontalScrollBar();
         this.hideVerticalScrollBar();
         this.validate();
         this.dispatchEventWith("scrollComplete");
      }
      
      protected function handlePendingScroll() : void
      {
         if(this.pendingHorizontalScrollPosition === this.pendingHorizontalScrollPosition || this.pendingVerticalScrollPosition === this.pendingVerticalScrollPosition)
         {
            this.throwTo(this.pendingHorizontalScrollPosition,this.pendingVerticalScrollPosition,this.pendingScrollDuration);
            this.pendingHorizontalScrollPosition = NaN;
            this.pendingVerticalScrollPosition = NaN;
         }
         if(this.hasPendingHorizontalPageIndex && this.hasPendingVerticalPageIndex)
         {
            this.throwToPage(this.pendingHorizontalPageIndex,this.pendingVerticalPageIndex,this.pendingScrollDuration);
         }
         else if(this.hasPendingHorizontalPageIndex)
         {
            this.throwToPage(this.pendingHorizontalPageIndex,this._verticalPageIndex,this.pendingScrollDuration);
         }
         else if(this.hasPendingVerticalPageIndex)
         {
            this.throwToPage(this._horizontalPageIndex,this.pendingVerticalPageIndex,this.pendingScrollDuration);
         }
         this.hasPendingHorizontalPageIndex = false;
         this.hasPendingVerticalPageIndex = false;
      }
      
      protected function handlePendingRevealScrollBars() : void
      {
         if(!this.isScrollBarRevealPending)
         {
            return;
         }
         this.isScrollBarRevealPending = false;
         if(this._scrollBarDisplayMode != "float")
         {
            return;
         }
         this.revealHorizontalScrollBar();
         this.revealVerticalScrollBar();
         this.hideHorizontalScrollBar(this._revealScrollBarsDuration);
         this.hideVerticalScrollBar(this._revealScrollBarsDuration);
      }
      
      protected function viewPort_resizeHandler(param1:starling.events.Event) : void
      {
         if(this.ignoreViewPortResizing || this._viewPort.width === this._lastViewPortWidth && this._viewPort.height === this._lastViewPortHeight)
         {
            return;
         }
         this._lastViewPortWidth = this._viewPort.width;
         this._lastViewPortHeight = this._viewPort.height;
         if(this._isValidating)
         {
            this._hasViewPortBoundsChanged = true;
         }
         else
         {
            this.invalidate("size");
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      protected function verticalScrollBar_changeHandler(param1:starling.events.Event) : void
      {
         this.verticalScrollPosition = this.verticalScrollBar.value;
      }
      
      protected function horizontalScrollBar_changeHandler(param1:starling.events.Event) : void
      {
         this.horizontalScrollPosition = this.horizontalScrollBar.value;
      }
      
      protected function horizontalScrollBar_beginInteractionHandler(param1:starling.events.Event) : void
      {
         if(this._horizontalAutoScrollTween)
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
         }
         this._isDraggingHorizontally = false;
         this._horizontalScrollBarIsScrolling = true;
         this.dispatchEventWith("beginInteraction");
         if(!this._isScrolling)
         {
            this.startScroll();
         }
      }
      
      protected function horizontalScrollBar_endInteractionHandler(param1:starling.events.Event) : void
      {
         this._horizontalScrollBarIsScrolling = false;
         this.dispatchEventWith("endInteraction");
         this.completeScroll();
      }
      
      protected function verticalScrollBar_beginInteractionHandler(param1:starling.events.Event) : void
      {
         if(this._verticalAutoScrollTween)
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
         }
         this._isDraggingVertically = false;
         this._verticalScrollBarIsScrolling = true;
         this.dispatchEventWith("beginInteraction");
         if(!this._isScrolling)
         {
            this.startScroll();
         }
      }
      
      protected function verticalScrollBar_endInteractionHandler(param1:starling.events.Event) : void
      {
         this._verticalScrollBarIsScrolling = false;
         this.dispatchEventWith("endInteraction");
         this.completeScroll();
      }
      
      protected function horizontalAutoScrollTween_onComplete() : void
      {
         this._horizontalAutoScrollTween = null;
         this.invalidate("scroll");
         this.finishScrollingHorizontally();
      }
      
      protected function verticalAutoScrollTween_onComplete() : void
      {
         this._verticalAutoScrollTween = null;
         this.invalidate("scroll");
         this.finishScrollingVertically();
      }
      
      protected function horizontalScrollBarHideTween_onComplete() : void
      {
         this._horizontalScrollBarHideTween = null;
      }
      
      protected function verticalScrollBarHideTween_onComplete() : void
      {
         this._verticalScrollBarHideTween = null;
      }
      
      protected function scroller_touchHandler(param1:TouchEvent) : void
      {
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            return;
         }
         var _loc3_:Touch = param1.getTouch(this,"began");
         if(!_loc3_)
         {
            return;
         }
         if(this._interactionMode == "touchAndScrollBars" && (param1.interactsWith(DisplayObject(this.horizontalScrollBar)) || param1.interactsWith(DisplayObject(this.verticalScrollBar))))
         {
            return;
         }
         _loc3_.getLocation(this,HELPER_POINT);
         var _loc4_:Number = HELPER_POINT.x;
         var _loc5_:Number = HELPER_POINT.y;
         if(_loc4_ < this._leftViewPortOffset || _loc5_ < this._topViewPortOffset || _loc4_ >= this.actualWidth - this._rightViewPortOffset || _loc5_ >= this.actualHeight - this._bottomViewPortOffset)
         {
            return;
         }
         var _loc2_:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
         if(_loc2_.getClaim(_loc3_.id))
         {
            return;
         }
         if(this._horizontalAutoScrollTween && this._horizontalScrollPolicy != "off")
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
            if(this._isScrolling)
            {
               this._isDraggingHorizontally = true;
            }
         }
         if(this._verticalAutoScrollTween && this._verticalScrollPolicy != "off")
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
            if(this._isScrolling)
            {
               this._isDraggingVertically = true;
            }
         }
         this._touchPointID = _loc3_.id;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this._previousTouchTime = getTimer();
         this._previousTouchX = this._startTouchX = this._currentTouchX = _loc4_;
         this._previousTouchY = this._startTouchY = this._currentTouchY = _loc5_;
         this._startHorizontalScrollPosition = this._horizontalScrollPosition;
         this._startVerticalScrollPosition = this._verticalScrollPosition;
         this._isScrollingStopped = false;
         this.addEventListener("enterFrame",scroller_enterFrameHandler);
         this.stage.addEventListener("touch",stage_touchHandler);
         if(this._isScrolling && (this._isDraggingHorizontally || this._isDraggingVertically))
         {
            _loc2_.claimTouch(this._touchPointID,this);
         }
         else
         {
            _loc2_.addEventListener("change",exclusiveTouch_changeHandler);
         }
      }
      
      protected function scroller_enterFrameHandler(param1:starling.events.Event) : void
      {
         var _loc2_:ExclusiveTouch = null;
         if(this._isScrollingStopped)
         {
            return;
         }
         var _loc3_:int = getTimer();
         var _loc5_:int;
         if((_loc5_ = _loc3_ - this._previousTouchTime) > 0)
         {
            this._previousVelocityX[this._previousVelocityX.length] = this._velocityX;
            if(this._previousVelocityX.length > 4)
            {
               this._previousVelocityX.shift();
            }
            this._previousVelocityY[this._previousVelocityY.length] = this._velocityY;
            if(this._previousVelocityY.length > 4)
            {
               this._previousVelocityY.shift();
            }
            this._velocityX = (this._currentTouchX - this._previousTouchX) / _loc5_;
            this._velocityY = (this._currentTouchY - this._previousTouchY) / _loc5_;
            this._previousTouchTime = _loc3_;
            this._previousTouchX = this._currentTouchX;
            this._previousTouchY = this._currentTouchY;
         }
         var _loc4_:Number = Math.abs(this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         var _loc6_:Number = Math.abs(this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         if((this._horizontalScrollPolicy == "on" || this._horizontalScrollPolicy == "auto" && this._minHorizontalScrollPosition != this._maxHorizontalScrollPosition) && !this._isDraggingHorizontally && _loc4_ >= this._minimumDragDistance)
         {
            if(this.horizontalScrollBar)
            {
               this.revealHorizontalScrollBar();
            }
            this._startTouchX = this._currentTouchX;
            this._startHorizontalScrollPosition = this._horizontalScrollPosition;
            this._isDraggingHorizontally = true;
            if(!this._isDraggingVertically)
            {
               this.dispatchEventWith("beginInteraction");
               _loc2_ = ExclusiveTouch.forStage(this.stage);
               _loc2_.removeEventListener("change",exclusiveTouch_changeHandler);
               _loc2_.claimTouch(this._touchPointID,this);
               this.startScroll();
            }
         }
         if((this._verticalScrollPolicy == "on" || this._verticalScrollPolicy == "auto" && this._minVerticalScrollPosition != this._maxVerticalScrollPosition) && !this._isDraggingVertically && _loc6_ >= this._minimumDragDistance)
         {
            if(this.verticalScrollBar)
            {
               this.revealVerticalScrollBar();
            }
            this._startTouchY = this._currentTouchY;
            this._startVerticalScrollPosition = this._verticalScrollPosition;
            this._isDraggingVertically = true;
            if(!this._isDraggingHorizontally)
            {
               _loc2_ = ExclusiveTouch.forStage(this.stage);
               _loc2_.removeEventListener("change",exclusiveTouch_changeHandler);
               _loc2_.claimTouch(this._touchPointID,this);
               this.dispatchEventWith("beginInteraction");
               this.startScroll();
            }
         }
         if(this._isDraggingHorizontally && !this._horizontalAutoScrollTween)
         {
            this.updateHorizontalScrollFromTouchPosition(this._currentTouchX);
         }
         if(this._isDraggingVertically && !this._verticalAutoScrollTween)
         {
            this.updateVerticalScrollFromTouchPosition(this._currentTouchY);
         }
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc8_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc9_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc4_:Touch;
         if(!(_loc4_ = param1.getTouch(this.stage,null,this._touchPointID)))
         {
            return;
         }
         if(_loc4_.phase == "moved")
         {
            _loc4_.getLocation(this,HELPER_POINT);
            this._currentTouchX = HELPER_POINT.x;
            this._currentTouchY = HELPER_POINT.y;
         }
         else if(_loc4_.phase == "ended")
         {
            if(!this._isDraggingHorizontally && !this._isDraggingVertically)
            {
               ExclusiveTouch.forStage(this.stage).removeEventListener("change",exclusiveTouch_changeHandler);
            }
            this.removeEventListener("enterFrame",scroller_enterFrameHandler);
            this.stage.removeEventListener("touch",stage_touchHandler);
            this._touchPointID = -1;
            this.dispatchEventWith("endInteraction");
            _loc8_ = false;
            _loc5_ = false;
            if(this._horizontalScrollPosition < this._minHorizontalScrollPosition || this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
            {
               _loc8_ = true;
               this.finishScrollingHorizontally();
            }
            if(this._verticalScrollPosition < this._minVerticalScrollPosition || this._verticalScrollPosition > this._maxVerticalScrollPosition)
            {
               _loc5_ = true;
               this.finishScrollingVertically();
            }
            if(_loc8_ && _loc5_)
            {
               return;
            }
            if(!_loc8_ && this._isDraggingHorizontally)
            {
               _loc9_ = this._velocityX * 2.33;
               _loc2_ = int(this._previousVelocityX.length);
               _loc3_ = 2.33;
               _loc6_ = 0;
               while(_loc6_ < _loc2_)
               {
                  _loc7_ = VELOCITY_WEIGHTS[_loc6_];
                  _loc9_ += this._previousVelocityX.shift() * _loc7_;
                  _loc3_ += _loc7_;
                  _loc6_++;
               }
               this.throwHorizontally(_loc9_ / _loc3_);
            }
            else
            {
               this.hideHorizontalScrollBar();
            }
            if(!_loc5_ && this._isDraggingVertically)
            {
               _loc9_ = this._velocityY * 2.33;
               _loc2_ = int(this._previousVelocityY.length);
               _loc3_ = 2.33;
               _loc6_ = 0;
               while(_loc6_ < _loc2_)
               {
                  _loc7_ = VELOCITY_WEIGHTS[_loc6_];
                  _loc9_ += this._previousVelocityY.shift() * _loc7_;
                  _loc3_ += _loc7_;
                  _loc6_++;
               }
               this.throwVertically(_loc9_ / _loc3_);
            }
            else
            {
               this.hideVerticalScrollBar();
            }
         }
      }
      
      protected function exclusiveTouch_changeHandler(param1:starling.events.Event, param2:int) : void
      {
         if(this._touchPointID < 0 || this._touchPointID != param2 || this._isDraggingHorizontally || this._isDraggingVertically)
         {
            return;
         }
         var _loc3_:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
         if(_loc3_.getClaim(param2) == this)
         {
            return;
         }
         this._touchPointID = -1;
         this.removeEventListener("enterFrame",scroller_enterFrameHandler);
         this.stage.removeEventListener("touch",stage_touchHandler);
         _loc3_.removeEventListener("change",exclusiveTouch_changeHandler);
         this.dispatchEventWith("endInteraction");
      }
      
      protected function nativeStage_mouseWheelHandler(param1:MouseEvent) : void
      {
         var _loc8_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._verticalMouseWheelScrollDirection == "vertical" && (this._maxVerticalScrollPosition == this._minVerticalScrollPosition || this._verticalScrollPolicy == "off") || this._verticalMouseWheelScrollDirection == "horizontal" && (this._maxHorizontalScrollPosition == this._minHorizontalScrollPosition || this._horizontalScrollPolicy == "off"))
         {
            return;
         }
         var _loc7_:Number = 1;
         if(Starling.current.supportHighResolutions)
         {
            _loc7_ = Starling.current.nativeStage.contentsScaleFactor;
         }
         var _loc2_:Rectangle = Starling.current.viewPort;
         var _loc3_:Number = _loc7_ / Starling.contentScaleFactor;
         HELPER_POINT.x = (param1.stageX - _loc2_.x) * _loc3_;
         HELPER_POINT.y = (param1.stageY - _loc2_.y) * _loc3_;
         if(this.contains(this.stage.hitTest(HELPER_POINT)))
         {
            this.globalToLocal(HELPER_POINT,HELPER_POINT);
            _loc8_ = HELPER_POINT.x;
            _loc4_ = HELPER_POINT.y;
            if(_loc8_ < this._leftViewPortOffset || _loc4_ < this._topViewPortOffset || _loc8_ >= this.actualWidth - this._rightViewPortOffset || _loc4_ >= this.actualHeight - this._bottomViewPortOffset)
            {
               return;
            }
            _loc5_ = this._horizontalScrollPosition;
            _loc9_ = this._verticalScrollPosition;
            _loc6_ = this._verticalMouseWheelScrollStep;
            if(this._verticalMouseWheelScrollDirection == "horizontal")
            {
               if(_loc6_ !== _loc6_)
               {
                  _loc6_ = this.actualHorizontalScrollStep;
               }
               if((_loc5_ -= param1.delta * _loc6_) < this._minHorizontalScrollPosition)
               {
                  _loc5_ = this._minHorizontalScrollPosition;
               }
               else if(_loc5_ > this._maxHorizontalScrollPosition)
               {
                  _loc5_ = this._maxHorizontalScrollPosition;
               }
            }
            else
            {
               if(_loc6_ !== _loc6_)
               {
                  _loc6_ = this.actualVerticalScrollStep;
               }
               if((_loc9_ -= param1.delta * _loc6_) < this._minVerticalScrollPosition)
               {
                  _loc9_ = this._minVerticalScrollPosition;
               }
               else if(_loc9_ > this._maxVerticalScrollPosition)
               {
                  _loc9_ = this._maxVerticalScrollPosition;
               }
            }
            this.throwTo(_loc5_,_loc9_,this._mouseWheelScrollDuration);
         }
      }
      
      protected function nativeStage_orientationChangeHandler(param1:flash.events.Event) : void
      {
         if(this._touchPointID < 0)
         {
            return;
         }
         this._startTouchX = this._previousTouchX = this._currentTouchX;
         this._startTouchY = this._previousTouchY = this._currentTouchY;
         this._startHorizontalScrollPosition = this._horizontalScrollPosition;
         this._startVerticalScrollPosition = this._verticalScrollPosition;
      }
      
      protected function horizontalScrollBar_touchHandler(param1:TouchEvent) : void
      {
         var _loc4_:Touch = null;
         var _loc3_:* = false;
         if(!this._isEnabled)
         {
            this._horizontalScrollBarTouchPointID = -1;
            return;
         }
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget);
         if(this._horizontalScrollBarTouchPointID >= 0)
         {
            if(!(_loc4_ = param1.getTouch(_loc2_,"ended",this._horizontalScrollBarTouchPointID)))
            {
               return;
            }
            this._horizontalScrollBarTouchPointID = -1;
            _loc4_.getLocation(_loc2_,HELPER_POINT);
            _loc3_ = this.horizontalScrollBar.hitTest(HELPER_POINT) !== null;
            if(!_loc3_)
            {
               this.hideHorizontalScrollBar();
            }
         }
         else
         {
            if(_loc4_ = param1.getTouch(_loc2_,"began"))
            {
               this._horizontalScrollBarTouchPointID = _loc4_.id;
               return;
            }
            if(this._isScrolling)
            {
               return;
            }
            if(_loc4_ = param1.getTouch(_loc2_,"hover"))
            {
               this.revealHorizontalScrollBar();
               return;
            }
            this.hideHorizontalScrollBar();
         }
      }
      
      protected function verticalScrollBar_touchHandler(param1:TouchEvent) : void
      {
         var _loc4_:Touch = null;
         var _loc3_:* = false;
         if(!this._isEnabled)
         {
            this._verticalScrollBarTouchPointID = -1;
            return;
         }
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget);
         if(this._verticalScrollBarTouchPointID >= 0)
         {
            if(!(_loc4_ = param1.getTouch(_loc2_,"ended",this._verticalScrollBarTouchPointID)))
            {
               return;
            }
            this._verticalScrollBarTouchPointID = -1;
            _loc4_.getLocation(_loc2_,HELPER_POINT);
            _loc3_ = this.verticalScrollBar.hitTest(HELPER_POINT) !== null;
            if(!_loc3_)
            {
               this.hideVerticalScrollBar();
            }
         }
         else
         {
            if(_loc4_ = param1.getTouch(_loc2_,"began"))
            {
               this._verticalScrollBarTouchPointID = _loc4_.id;
               return;
            }
            if(this._isScrolling)
            {
               return;
            }
            if(_loc4_ = param1.getTouch(_loc2_,"hover"))
            {
               this.revealVerticalScrollBar();
               return;
            }
            this.hideVerticalScrollBar();
         }
      }
      
      protected function scroller_addedToStageHandler(param1:starling.events.Event) : void
      {
         Starling.current.nativeStage.addEventListener("mouseWheel",nativeStage_mouseWheelHandler,false,0,true);
         Starling.current.nativeStage.addEventListener("orientationChange",nativeStage_orientationChangeHandler,false,0,true);
      }
      
      protected function scroller_removedFromStageHandler(param1:starling.events.Event) : void
      {
         var _loc2_:ExclusiveTouch = null;
         Starling.current.nativeStage.removeEventListener("mouseWheel",nativeStage_mouseWheelHandler);
         Starling.current.nativeStage.removeEventListener("orientationChange",nativeStage_orientationChangeHandler);
         if(this._touchPointID >= 0)
         {
            _loc2_ = ExclusiveTouch.forStage(this.stage);
            _loc2_.removeEventListener("change",exclusiveTouch_changeHandler);
         }
         this._touchPointID = -1;
         this._horizontalScrollBarTouchPointID = -1;
         this._verticalScrollBarTouchPointID = -1;
         this._isDraggingHorizontally = false;
         this._isDraggingVertically = false;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this._horizontalScrollBarIsScrolling = false;
         this._verticalScrollBarIsScrolling = false;
         this.removeEventListener("enterFrame",scroller_enterFrameHandler);
         this.stage.removeEventListener("touch",stage_touchHandler);
         if(this._verticalAutoScrollTween)
         {
            Starling.juggler.remove(this._verticalAutoScrollTween);
            this._verticalAutoScrollTween = null;
         }
         if(this._horizontalAutoScrollTween)
         {
            Starling.juggler.remove(this._horizontalAutoScrollTween);
            this._horizontalAutoScrollTween = null;
         }
         var _loc4_:Number = this._horizontalScrollPosition;
         var _loc3_:Number = this._verticalScrollPosition;
         if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
         {
            this._horizontalScrollPosition = this._minHorizontalScrollPosition;
         }
         else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
         {
            this._horizontalScrollPosition = this._maxHorizontalScrollPosition;
         }
         if(this._verticalScrollPosition < this._minVerticalScrollPosition)
         {
            this._verticalScrollPosition = this._minVerticalScrollPosition;
         }
         else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
         {
            this._verticalScrollPosition = this._maxVerticalScrollPosition;
         }
         if(_loc4_ != this._horizontalScrollPosition || _loc3_ != this._verticalScrollPosition)
         {
            this.dispatchEventWith("scroll");
         }
         this.completeScroll();
      }
      
      override protected function focusInHandler(param1:starling.events.Event) : void
      {
         super.focusInHandler(param1);
         this.stage.addEventListener("keyDown",stage_keyDownHandler);
      }
      
      override protected function focusOutHandler(param1:starling.events.Event) : void
      {
         super.focusOutHandler(param1);
         this.stage.removeEventListener("keyDown",stage_keyDownHandler);
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 36)
         {
            this.verticalScrollPosition = this._minVerticalScrollPosition;
         }
         else if(param1.keyCode == 35)
         {
            this.verticalScrollPosition = this._maxVerticalScrollPosition;
         }
         else if(param1.keyCode == 33)
         {
            this.verticalScrollPosition = Math.max(this._minVerticalScrollPosition,this._verticalScrollPosition - this.viewPort.visibleHeight);
         }
         else if(param1.keyCode == 34)
         {
            this.verticalScrollPosition = Math.min(this._maxVerticalScrollPosition,this._verticalScrollPosition + this.viewPort.visibleHeight);
         }
         else if(param1.keyCode == 38)
         {
            this.verticalScrollPosition = Math.max(this._minVerticalScrollPosition,this._verticalScrollPosition - this.verticalScrollStep);
         }
         else if(param1.keyCode == 40)
         {
            this.verticalScrollPosition = Math.min(this._maxVerticalScrollPosition,this._verticalScrollPosition + this.verticalScrollStep);
         }
         else if(param1.keyCode == 37)
         {
            this.horizontalScrollPosition = Math.max(this._maxHorizontalScrollPosition,this._horizontalScrollPosition - this.horizontalScrollStep);
         }
         else if(param1.keyCode == 39)
         {
            this.horizontalScrollPosition = Math.min(this._maxHorizontalScrollPosition,this._horizontalScrollPosition + this.horizontalScrollStep);
         }
      }
   }
}
