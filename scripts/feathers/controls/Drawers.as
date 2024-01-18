package feathers.controls
{
   import feathers.controls.supportClasses.BaseScreenNavigator;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.events.ExclusiveTouch;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import feathers.utils.math.roundToNearest;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Quad;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.ResizeEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class Drawers extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DOCK_MODE_PORTRAIT:String = "portrait";
      
      public static const DOCK_MODE_LANDSCAPE:String = "landscape";
      
      public static const DOCK_MODE_BOTH:String = "both";
      
      public static const DOCK_MODE_NONE:String = "none";
      
      public static const OPEN_MODE_ABOVE:String = "overlay";
      
      public static const OPEN_MODE_BELOW:String = "below";
      
      public static const AUTO_SIZE_MODE_STAGE:String = "stage";
      
      public static const AUTO_SIZE_MODE_CONTENT:String = "content";
      
      public static const OPEN_GESTURE_DRAG_CONTENT_EDGE:String = "dragContentEdge";
      
      public static const OPEN_GESTURE_DRAG_CONTENT:String = "dragContent";
      
      public static const OPEN_GESTURE_NONE:String = "none";
      
      protected static const SCREEN_NAVIGATOR_CONTENT_EVENT_DISPATCHER_FIELD:String = "activeScreen";
      
      private static const CURRENT_VELOCITY_WEIGHT:Number = 2.33;
      
      private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[1,1.33,1.66,2];
      
      private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;
      
      private static const HELPER_POINT:Point = new Point();
       
      
      protected var contentEventDispatcher:EventDispatcher;
      
      protected var _originalContentWidth:Number = NaN;
      
      protected var _originalContentHeight:Number = NaN;
      
      protected var _content:IFeathersControl;
      
      protected var _overlaySkinOriginalAlpha:Number = 1;
      
      protected var _overlaySkin:DisplayObject;
      
      protected var _originalTopDrawerWidth:Number = NaN;
      
      protected var _originalTopDrawerHeight:Number = NaN;
      
      protected var _topDrawer:IFeathersControl;
      
      protected var _topDrawerDivider:DisplayObject;
      
      protected var _topDrawerDockMode:String = "none";
      
      protected var _topDrawerToggleEventType:String;
      
      protected var _isTopDrawerOpen:Boolean = false;
      
      protected var _originalRightDrawerWidth:Number = NaN;
      
      protected var _originalRightDrawerHeight:Number = NaN;
      
      protected var _rightDrawer:IFeathersControl;
      
      protected var _rightDrawerDivider:DisplayObject;
      
      protected var _rightDrawerDockMode:String = "none";
      
      protected var _rightDrawerToggleEventType:String;
      
      protected var _isRightDrawerOpen:Boolean = false;
      
      protected var _originalBottomDrawerWidth:Number = NaN;
      
      protected var _originalBottomDrawerHeight:Number = NaN;
      
      protected var _bottomDrawer:IFeathersControl;
      
      protected var _bottomDrawerDivider:DisplayObject;
      
      protected var _bottomDrawerDockMode:String = "none";
      
      protected var _bottomDrawerToggleEventType:String;
      
      protected var _isBottomDrawerOpen:Boolean = false;
      
      protected var _originalLeftDrawerWidth:Number = NaN;
      
      protected var _originalLeftDrawerHeight:Number = NaN;
      
      protected var _leftDrawer:IFeathersControl;
      
      protected var _leftDrawerDivider:DisplayObject;
      
      protected var _leftDrawerDockMode:String = "none";
      
      protected var _leftDrawerToggleEventType:String;
      
      protected var _isLeftDrawerOpen:Boolean = false;
      
      protected var _autoSizeMode:String = "stage";
      
      protected var _clipDrawers:Boolean = true;
      
      protected var _openMode:String = "below";
      
      protected var _openGesture:String = "edge";
      
      protected var _minimumDragDistance:Number = 0.04;
      
      protected var _minimumDrawerThrowVelocity:Number = 5;
      
      protected var _openGestureEdgeSize:Number = 0.1;
      
      protected var _contentEventDispatcherChangeEventType:String;
      
      protected var _contentEventDispatcherField:String;
      
      protected var _contentEventDispatcherFunction:Function;
      
      protected var _openOrCloseTween:Tween;
      
      protected var _openOrCloseDuration:Number = 0.25;
      
      protected var _openOrCloseEase:Object = "easeOut";
      
      protected var isToggleTopDrawerPending:Boolean = false;
      
      protected var isToggleRightDrawerPending:Boolean = false;
      
      protected var isToggleBottomDrawerPending:Boolean = false;
      
      protected var isToggleLeftDrawerPending:Boolean = false;
      
      protected var pendingToggleDuration:Number;
      
      protected var touchPointID:int = -1;
      
      protected var _isDragging:Boolean = false;
      
      protected var _isDraggingTopDrawer:Boolean = false;
      
      protected var _isDraggingRightDrawer:Boolean = false;
      
      protected var _isDraggingBottomDrawer:Boolean = false;
      
      protected var _isDraggingLeftDrawer:Boolean = false;
      
      protected var _startTouchX:Number;
      
      protected var _startTouchY:Number;
      
      protected var _currentTouchX:Number;
      
      protected var _currentTouchY:Number;
      
      protected var _previousTouchTime:int;
      
      protected var _previousTouchX:Number;
      
      protected var _previousTouchY:Number;
      
      protected var _velocityX:Number = 0;
      
      protected var _velocityY:Number = 0;
      
      protected var _previousVelocityX:Vector.<Number>;
      
      protected var _previousVelocityY:Vector.<Number>;
      
      public function Drawers(param1:IFeathersControl = null)
      {
         _previousVelocityX = new Vector.<Number>(0);
         _previousVelocityY = new Vector.<Number>(0);
         super();
         this.content = param1;
         this.addEventListener("addedToStage",drawers_addedToStageHandler);
         this.addEventListener("removedFromStage",drawers_removedFromStageHandler);
         this.addEventListener("touch",drawers_touchHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Drawers.globalStyleProvider;
      }
      
      public function get content() : IFeathersControl
      {
         return this._content;
      }
      
      public function set content(param1:IFeathersControl) : void
      {
         if(this._content === param1)
         {
            return;
         }
         if(this._content)
         {
            if(this._contentEventDispatcherChangeEventType)
            {
               this._content.removeEventListener(this._contentEventDispatcherChangeEventType,content_eventDispatcherChangeHandler);
            }
            this._content.removeEventListener("resize",content_resizeHandler);
            if(this._content.parent === this)
            {
               this.removeChild(DisplayObject(this._content),false);
            }
         }
         this._content = param1;
         this._originalContentWidth = NaN;
         this._originalContentHeight = NaN;
         if(this._content)
         {
            if(this._content is BaseScreenNavigator)
            {
               this.contentEventDispatcherField = "activeScreen";
               this.contentEventDispatcherChangeEventType = "change";
            }
            if(this._contentEventDispatcherChangeEventType)
            {
               this._content.addEventListener(this._contentEventDispatcherChangeEventType,content_eventDispatcherChangeHandler);
            }
            if(this._autoSizeMode === "content" || !this.stage)
            {
               this._content.addEventListener("resize",content_resizeHandler);
            }
            if(this._openMode === "above")
            {
               this.addChildAt(DisplayObject(this._content),0);
            }
            else if(this._overlaySkin)
            {
               this.addChildAt(DisplayObject(this._content),this.getChildIndex(this._overlaySkin));
            }
            else
            {
               this.addChild(DisplayObject(this._content));
            }
         }
         this.invalidate("data");
      }
      
      public function get overlaySkin() : DisplayObject
      {
         return this._overlaySkin;
      }
      
      public function set overlaySkin(param1:DisplayObject) : void
      {
         if(this._overlaySkin == param1)
         {
            return;
         }
         if(this._overlaySkin && this._overlaySkin.parent == this)
         {
            this.removeChild(this._overlaySkin,false);
         }
         this._overlaySkin = param1;
         if(this._overlaySkin)
         {
            this._overlaySkinOriginalAlpha = this._overlaySkin.alpha;
            this._overlaySkin.visible = this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen;
            this.addChild(this._overlaySkin);
         }
         this.invalidate("data");
      }
      
      public function get topDrawer() : IFeathersControl
      {
         return this._topDrawer;
      }
      
      public function set topDrawer(param1:IFeathersControl) : void
      {
         if(this._topDrawer === param1)
         {
            return;
         }
         if(this.isTopDrawerOpen && param1 === null)
         {
            this.isTopDrawerOpen = false;
         }
         if(this._topDrawer && this._topDrawer.parent === this)
         {
            this.removeChild(DisplayObject(this._topDrawer),false);
         }
         this._topDrawer = param1;
         this._originalTopDrawerWidth = NaN;
         this._originalTopDrawerHeight = NaN;
         if(this._topDrawer)
         {
            this._topDrawer.visible = false;
            this._topDrawer.addEventListener("resize",drawer_resizeHandler);
            if(this._openMode === "above")
            {
               this.addChild(DisplayObject(this._topDrawer));
            }
            else
            {
               this.addChildAt(DisplayObject(this._topDrawer),0);
            }
         }
         this.invalidate("data");
      }
      
      public function get topDrawerDivider() : DisplayObject
      {
         return this._topDrawerDivider;
      }
      
      public function set topDrawerDivider(param1:DisplayObject) : void
      {
         if(this._topDrawerDivider === param1)
         {
            return;
         }
         if(this._topDrawerDivider && this._topDrawerDivider.parent == this)
         {
            this.removeChild(this._topDrawerDivider,false);
         }
         this._topDrawerDivider = param1;
         if(this._topDrawerDivider)
         {
            this._topDrawerDivider.visible = false;
            this.addChild(this._topDrawerDivider);
         }
         this.invalidate("styles");
      }
      
      public function get topDrawerDockMode() : String
      {
         return this._topDrawerDockMode;
      }
      
      public function set topDrawerDockMode(param1:String) : void
      {
         if(this._topDrawerDockMode == param1)
         {
            return;
         }
         this._topDrawerDockMode = param1;
         this.invalidate("layout");
      }
      
      public function get topDrawerToggleEventType() : String
      {
         return this._topDrawerToggleEventType;
      }
      
      public function set topDrawerToggleEventType(param1:String) : void
      {
         if(this._topDrawerToggleEventType == param1)
         {
            return;
         }
         if(this.contentEventDispatcher && this._topDrawerToggleEventType)
         {
            this.contentEventDispatcher.removeEventListener(this._topDrawerToggleEventType,content_topDrawerToggleEventTypeHandler);
         }
         this._topDrawerToggleEventType = param1;
         if(this.contentEventDispatcher && this._topDrawerToggleEventType)
         {
            this.contentEventDispatcher.addEventListener(this._topDrawerToggleEventType,content_topDrawerToggleEventTypeHandler);
         }
      }
      
      public function get isTopDrawerOpen() : Boolean
      {
         return this._topDrawer && this._isTopDrawerOpen;
      }
      
      public function set isTopDrawerOpen(param1:Boolean) : void
      {
         if(this.isTopDrawerDocked || this._isTopDrawerOpen == param1)
         {
            return;
         }
         if(param1)
         {
            this.isRightDrawerOpen = false;
            this.isBottomDrawerOpen = false;
            this.isLeftDrawerOpen = false;
         }
         this._isTopDrawerOpen = param1;
         this.invalidate("selected");
      }
      
      public function get isTopDrawerDocked() : Boolean
      {
         if(!this._topDrawer)
         {
            return false;
         }
         if(this._topDrawerDockMode === "both")
         {
            return true;
         }
         if(this._topDrawerDockMode === "none")
         {
            return false;
         }
         var _loc1_:Stage = this.stage;
         if(!_loc1_)
         {
            _loc1_ = Starling.current.stage;
         }
         if(_loc1_.stageWidth > _loc1_.stageHeight)
         {
            return this._topDrawerDockMode === "landscape";
         }
         return this._topDrawerDockMode === "portrait";
      }
      
      public function get rightDrawer() : IFeathersControl
      {
         return this._rightDrawer;
      }
      
      public function set rightDrawer(param1:IFeathersControl) : void
      {
         if(this._rightDrawer == param1)
         {
            return;
         }
         if(this.isRightDrawerOpen && param1 === null)
         {
            this.isRightDrawerOpen = false;
         }
         if(this._rightDrawer && this._rightDrawer.parent == this)
         {
            this.removeChild(DisplayObject(this._rightDrawer),false);
         }
         this._rightDrawer = param1;
         this._originalRightDrawerWidth = NaN;
         this._originalRightDrawerHeight = NaN;
         if(this._rightDrawer)
         {
            this._rightDrawer.visible = false;
            this._rightDrawer.addEventListener("resize",drawer_resizeHandler);
            if(this._openMode === "above")
            {
               this.addChild(DisplayObject(this._rightDrawer));
            }
            else
            {
               this.addChildAt(DisplayObject(this._rightDrawer),0);
            }
         }
         this.invalidate("data");
      }
      
      public function get rightDrawerDivider() : DisplayObject
      {
         return this._rightDrawerDivider;
      }
      
      public function set rightDrawerDivider(param1:DisplayObject) : void
      {
         if(this._rightDrawerDivider === param1)
         {
            return;
         }
         if(this._rightDrawerDivider && this._rightDrawerDivider.parent == this)
         {
            this.removeChild(this._rightDrawerDivider,false);
         }
         this._rightDrawerDivider = param1;
         if(this._rightDrawerDivider)
         {
            this._rightDrawerDivider.visible = false;
            this.addChild(this._rightDrawerDivider);
         }
         this.invalidate("styles");
      }
      
      public function get rightDrawerDockMode() : String
      {
         return this._rightDrawerDockMode;
      }
      
      public function set rightDrawerDockMode(param1:String) : void
      {
         if(this._rightDrawerDockMode == param1)
         {
            return;
         }
         this._rightDrawerDockMode = param1;
         this.invalidate("layout");
      }
      
      public function get rightDrawerToggleEventType() : String
      {
         return this._rightDrawerToggleEventType;
      }
      
      public function set rightDrawerToggleEventType(param1:String) : void
      {
         if(this._rightDrawerToggleEventType == param1)
         {
            return;
         }
         if(this.contentEventDispatcher && this._rightDrawerToggleEventType)
         {
            this.contentEventDispatcher.removeEventListener(this._rightDrawerToggleEventType,content_rightDrawerToggleEventTypeHandler);
         }
         this._rightDrawerToggleEventType = param1;
         if(this.contentEventDispatcher && this._rightDrawerToggleEventType)
         {
            this.contentEventDispatcher.addEventListener(this._rightDrawerToggleEventType,content_rightDrawerToggleEventTypeHandler);
         }
      }
      
      public function get isRightDrawerOpen() : Boolean
      {
         return this._rightDrawer && this._isRightDrawerOpen;
      }
      
      public function set isRightDrawerOpen(param1:Boolean) : void
      {
         if(this.isRightDrawerDocked || this._isRightDrawerOpen == param1)
         {
            return;
         }
         if(param1)
         {
            this.isTopDrawerOpen = false;
            this.isBottomDrawerOpen = false;
            this.isLeftDrawerOpen = false;
         }
         this._isRightDrawerOpen = param1;
         this.invalidate("selected");
      }
      
      public function get isRightDrawerDocked() : Boolean
      {
         if(!this._rightDrawer)
         {
            return false;
         }
         if(this._rightDrawerDockMode === "both")
         {
            return true;
         }
         if(this._rightDrawerDockMode === "none")
         {
            return false;
         }
         var _loc1_:Stage = this.stage;
         if(!_loc1_)
         {
            _loc1_ = Starling.current.stage;
         }
         if(_loc1_.stageWidth > _loc1_.stageHeight)
         {
            return this._rightDrawerDockMode === "landscape";
         }
         return this._rightDrawerDockMode === "portrait";
      }
      
      public function get bottomDrawer() : IFeathersControl
      {
         return this._bottomDrawer;
      }
      
      public function set bottomDrawer(param1:IFeathersControl) : void
      {
         if(this._bottomDrawer === param1)
         {
            return;
         }
         if(this.isBottomDrawerOpen && param1 === null)
         {
            this.isBottomDrawerOpen = false;
         }
         if(this._bottomDrawer && this._bottomDrawer.parent === this)
         {
            this.removeChild(DisplayObject(this._bottomDrawer),false);
         }
         this._bottomDrawer = param1;
         this._originalBottomDrawerWidth = NaN;
         this._originalBottomDrawerHeight = NaN;
         if(this._bottomDrawer)
         {
            this._bottomDrawer.visible = false;
            this._bottomDrawer.addEventListener("resize",drawer_resizeHandler);
            if(this._openMode === "above")
            {
               this.addChild(DisplayObject(this._bottomDrawer));
            }
            else
            {
               this.addChildAt(DisplayObject(this._bottomDrawer),0);
            }
         }
         this.invalidate("data");
      }
      
      public function get bottomDrawerDivider() : DisplayObject
      {
         return this._bottomDrawerDivider;
      }
      
      public function set bottomDrawerDivider(param1:DisplayObject) : void
      {
         if(this._bottomDrawerDivider === param1)
         {
            return;
         }
         if(this._bottomDrawerDivider && this._bottomDrawerDivider.parent == this)
         {
            this.removeChild(this._bottomDrawerDivider,false);
         }
         this._bottomDrawerDivider = param1;
         if(this._bottomDrawerDivider)
         {
            this._bottomDrawerDivider.visible = false;
            this.addChild(this._bottomDrawerDivider);
         }
         this.invalidate("styles");
      }
      
      public function get bottomDrawerDockMode() : String
      {
         return this._bottomDrawerDockMode;
      }
      
      public function set bottomDrawerDockMode(param1:String) : void
      {
         if(this._bottomDrawerDockMode == param1)
         {
            return;
         }
         this._bottomDrawerDockMode = param1;
         this.invalidate("layout");
      }
      
      public function get bottomDrawerToggleEventType() : String
      {
         return this._bottomDrawerToggleEventType;
      }
      
      public function set bottomDrawerToggleEventType(param1:String) : void
      {
         if(this._bottomDrawerToggleEventType == param1)
         {
            return;
         }
         if(this.contentEventDispatcher && this._bottomDrawerToggleEventType)
         {
            this.contentEventDispatcher.removeEventListener(this._bottomDrawerToggleEventType,content_bottomDrawerToggleEventTypeHandler);
         }
         this._bottomDrawerToggleEventType = param1;
         if(this.contentEventDispatcher && this._bottomDrawerToggleEventType)
         {
            this.contentEventDispatcher.addEventListener(this._bottomDrawerToggleEventType,content_bottomDrawerToggleEventTypeHandler);
         }
      }
      
      public function get isBottomDrawerOpen() : Boolean
      {
         return this._bottomDrawer && this._isBottomDrawerOpen;
      }
      
      public function set isBottomDrawerOpen(param1:Boolean) : void
      {
         if(this.isBottomDrawerDocked || this._isBottomDrawerOpen == param1)
         {
            return;
         }
         if(param1)
         {
            this.isTopDrawerOpen = false;
            this.isRightDrawerOpen = false;
            this.isLeftDrawerOpen = false;
         }
         this._isBottomDrawerOpen = param1;
         this.invalidate("selected");
      }
      
      public function get isBottomDrawerDocked() : Boolean
      {
         if(!this._bottomDrawer)
         {
            return false;
         }
         if(this._bottomDrawerDockMode === "both")
         {
            return true;
         }
         if(this._bottomDrawerDockMode === "none")
         {
            return false;
         }
         var _loc1_:Stage = this.stage;
         if(!_loc1_)
         {
            _loc1_ = Starling.current.stage;
         }
         if(_loc1_.stageWidth > _loc1_.stageHeight)
         {
            return this._bottomDrawerDockMode === "landscape";
         }
         return this._bottomDrawerDockMode === "portrait";
      }
      
      public function get leftDrawer() : IFeathersControl
      {
         return this._leftDrawer;
      }
      
      public function set leftDrawer(param1:IFeathersControl) : void
      {
         if(this._leftDrawer === param1)
         {
            return;
         }
         if(this.isLeftDrawerOpen && param1 === null)
         {
            this.isLeftDrawerOpen = false;
         }
         if(this._leftDrawer && this._leftDrawer.parent === this)
         {
            this.removeChild(DisplayObject(this._leftDrawer),false);
         }
         this._leftDrawer = param1;
         this._originalLeftDrawerWidth = NaN;
         this._originalLeftDrawerHeight = NaN;
         if(this._leftDrawer)
         {
            this._leftDrawer.visible = false;
            this._leftDrawer.addEventListener("resize",drawer_resizeHandler);
            if(this._openMode === "above")
            {
               this.addChild(DisplayObject(this._leftDrawer));
            }
            else
            {
               this.addChildAt(DisplayObject(this._leftDrawer),0);
            }
         }
         this.invalidate("data");
      }
      
      public function get leftDrawerDivider() : DisplayObject
      {
         return this._leftDrawerDivider;
      }
      
      public function set leftDrawerDivider(param1:DisplayObject) : void
      {
         if(this._leftDrawerDivider === param1)
         {
            return;
         }
         if(this._leftDrawerDivider && this._leftDrawerDivider.parent == this)
         {
            this.removeChild(this._leftDrawerDivider,false);
         }
         this._leftDrawerDivider = param1;
         if(this._leftDrawerDivider)
         {
            this._leftDrawerDivider.visible = false;
            this.addChild(this._leftDrawerDivider);
         }
         this.invalidate("styles");
      }
      
      public function get leftDrawerDockMode() : String
      {
         return this._leftDrawerDockMode;
      }
      
      public function set leftDrawerDockMode(param1:String) : void
      {
         if(this._leftDrawerDockMode == param1)
         {
            return;
         }
         this._leftDrawerDockMode = param1;
         this.invalidate("layout");
      }
      
      public function get leftDrawerToggleEventType() : String
      {
         return this._leftDrawerToggleEventType;
      }
      
      public function set leftDrawerToggleEventType(param1:String) : void
      {
         if(this._leftDrawerToggleEventType == param1)
         {
            return;
         }
         if(this.contentEventDispatcher && this._leftDrawerToggleEventType)
         {
            this.contentEventDispatcher.removeEventListener(this._leftDrawerToggleEventType,content_leftDrawerToggleEventTypeHandler);
         }
         this._leftDrawerToggleEventType = param1;
         if(this.contentEventDispatcher && this._leftDrawerToggleEventType)
         {
            this.contentEventDispatcher.addEventListener(this._leftDrawerToggleEventType,content_leftDrawerToggleEventTypeHandler);
         }
      }
      
      public function get isLeftDrawerOpen() : Boolean
      {
         return this._leftDrawer && this._isLeftDrawerOpen;
      }
      
      public function set isLeftDrawerOpen(param1:Boolean) : void
      {
         if(this.isLeftDrawerDocked || this._isLeftDrawerOpen == param1)
         {
            return;
         }
         if(param1)
         {
            this.isTopDrawerOpen = false;
            this.isRightDrawerOpen = false;
            this.isBottomDrawerOpen = false;
         }
         this._isLeftDrawerOpen = param1;
         this.invalidate("selected");
      }
      
      public function get isLeftDrawerDocked() : Boolean
      {
         if(!this._leftDrawer)
         {
            return false;
         }
         if(this._leftDrawerDockMode === "both")
         {
            return true;
         }
         if(this._leftDrawerDockMode === "none")
         {
            return false;
         }
         var _loc1_:Stage = this.stage;
         if(!_loc1_)
         {
            _loc1_ = Starling.current.stage;
         }
         if(_loc1_.stageWidth > _loc1_.stageHeight)
         {
            return this._leftDrawerDockMode === "landscape";
         }
         return this._leftDrawerDockMode == "portrait";
      }
      
      public function get autoSizeMode() : String
      {
         return this._autoSizeMode;
      }
      
      public function set autoSizeMode(param1:String) : void
      {
         if(this._autoSizeMode == param1)
         {
            return;
         }
         this._autoSizeMode = param1;
         if(this._content)
         {
            if(this._autoSizeMode == "content")
            {
               this._content.addEventListener("resize",content_resizeHandler);
            }
            else
            {
               this._content.removeEventListener("resize",content_resizeHandler);
            }
         }
         this.invalidate("size");
      }
      
      public function get clipDrawers() : Boolean
      {
         return this._clipDrawers;
      }
      
      public function set clipDrawers(param1:Boolean) : void
      {
         if(this._clipDrawers == param1)
         {
            return;
         }
         this._clipDrawers = param1;
         this.invalidate("layout");
      }
      
      public function get openMode() : String
      {
         return this._openMode;
      }
      
      public function set openMode(param1:String) : void
      {
         if(param1 === "overlay")
         {
            param1 = "above";
         }
         if(this._openMode == param1)
         {
            return;
         }
         this._openMode = param1;
         if(this._content)
         {
            if(this._openMode === "above")
            {
               this.setChildIndex(DisplayObject(this._content),0);
            }
            else if(this._overlaySkin)
            {
               this.setChildIndex(DisplayObject(this._content),this.numChildren - 1);
               this.setChildIndex(this._overlaySkin,this.numChildren - 1);
            }
            else
            {
               this.setChildIndex(DisplayObject(this._content),this.numChildren - 1);
            }
         }
         this.invalidate("layout");
      }
      
      public function get openGesture() : String
      {
         return this._openGesture;
      }
      
      public function set openGesture(param1:String) : void
      {
         if(param1 === "dragContent")
         {
            param1 = "content";
         }
         else if(param1 === "dragContentEdge")
         {
            param1 = "edge";
         }
         this._openGesture = param1;
      }
      
      public function get minimumDragDistance() : Number
      {
         return this._minimumDragDistance;
      }
      
      public function set minimumDragDistance(param1:Number) : void
      {
         this._minimumDragDistance = param1;
      }
      
      public function get minimumDrawerThrowVelocity() : Number
      {
         return this._minimumDrawerThrowVelocity;
      }
      
      public function set minimumDrawerThrowVelocity(param1:Number) : void
      {
         this._minimumDrawerThrowVelocity = param1;
      }
      
      public function get openGestureEdgeSize() : Number
      {
         return this._openGestureEdgeSize;
      }
      
      public function set openGestureEdgeSize(param1:Number) : void
      {
         this._openGestureEdgeSize = param1;
      }
      
      public function get contentEventDispatcherChangeEventType() : String
      {
         return this._contentEventDispatcherChangeEventType;
      }
      
      public function set contentEventDispatcherChangeEventType(param1:String) : void
      {
         if(this._contentEventDispatcherChangeEventType == param1)
         {
            return;
         }
         if(this._content && this._contentEventDispatcherChangeEventType)
         {
            this._content.removeEventListener(this._contentEventDispatcherChangeEventType,content_eventDispatcherChangeHandler);
         }
         this._contentEventDispatcherChangeEventType = param1;
         if(this._content && this._contentEventDispatcherChangeEventType)
         {
            this._content.addEventListener(this._contentEventDispatcherChangeEventType,content_eventDispatcherChangeHandler);
         }
      }
      
      public function get contentEventDispatcherField() : String
      {
         return this._contentEventDispatcherField;
      }
      
      public function set contentEventDispatcherField(param1:String) : void
      {
         if(this._contentEventDispatcherField == param1)
         {
            return;
         }
         this._contentEventDispatcherField = param1;
         this.invalidate("data");
      }
      
      public function get contentEventDispatcherFunction() : Function
      {
         return this._contentEventDispatcherFunction;
      }
      
      public function set contentEventDispatcherFunction(param1:Function) : void
      {
         if(this._contentEventDispatcherFunction == param1)
         {
            return;
         }
         this._contentEventDispatcherFunction = param1;
         this.invalidate("data");
      }
      
      public function get openOrCloseDuration() : Number
      {
         return this._openOrCloseDuration;
      }
      
      public function set openOrCloseDuration(param1:Number) : void
      {
         this._openOrCloseDuration = param1;
      }
      
      public function get openOrCloseEase() : Object
      {
         return this._openOrCloseEase;
      }
      
      public function set openOrCloseEase(param1:Object) : void
      {
         this._openOrCloseEase = param1;
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc2_:DisplayObject = super.hitTest(param1);
         if(_loc2_)
         {
            if(this._isDragging)
            {
               return this;
            }
            if(this.isTopDrawerOpen && _loc2_ != this._topDrawer && !(this._topDrawer is DisplayObjectContainer && Boolean(DisplayObjectContainer(this._topDrawer).contains(_loc2_))))
            {
               return this;
            }
            if(this.isRightDrawerOpen && _loc2_ != this._rightDrawer && !(this._rightDrawer is DisplayObjectContainer && Boolean(DisplayObjectContainer(this._rightDrawer).contains(_loc2_))))
            {
               return this;
            }
            if(this.isBottomDrawerOpen && _loc2_ != this._bottomDrawer && !(this._bottomDrawer is DisplayObjectContainer && Boolean(DisplayObjectContainer(this._bottomDrawer).contains(_loc2_))))
            {
               return this;
            }
            if(this.isLeftDrawerOpen && _loc2_ != this._leftDrawer && !(this._leftDrawer is DisplayObjectContainer && Boolean(DisplayObjectContainer(this._leftDrawer).contains(_loc2_))))
            {
               return this;
            }
            return _loc2_;
         }
         if(!this.visible || !this.touchable)
         {
            return null;
         }
         return this._hitArea.contains(param1.x,param1.y) ? this : null;
      }
      
      public function toggleTopDrawer(param1:Number = NaN) : void
      {
         if(!this._topDrawer || this.isTopDrawerDocked)
         {
            return;
         }
         this.pendingToggleDuration = param1;
         if(this.isToggleTopDrawerPending)
         {
            return;
         }
         if(!this.isTopDrawerOpen)
         {
            this.isRightDrawerOpen = false;
            this.isBottomDrawerOpen = false;
            this.isLeftDrawerOpen = false;
         }
         this.isToggleTopDrawerPending = true;
         this.isToggleRightDrawerPending = false;
         this.isToggleBottomDrawerPending = false;
         this.isToggleLeftDrawerPending = false;
         this.invalidate("selected");
      }
      
      public function toggleRightDrawer(param1:Number = NaN) : void
      {
         if(!this._rightDrawer || this.isRightDrawerDocked)
         {
            return;
         }
         this.pendingToggleDuration = param1;
         if(this.isToggleRightDrawerPending)
         {
            return;
         }
         if(!this.isRightDrawerOpen)
         {
            this.isTopDrawerOpen = false;
            this.isBottomDrawerOpen = false;
            this.isLeftDrawerOpen = false;
         }
         this.isToggleTopDrawerPending = false;
         this.isToggleRightDrawerPending = true;
         this.isToggleBottomDrawerPending = false;
         this.isToggleLeftDrawerPending = false;
         this.invalidate("selected");
      }
      
      public function toggleBottomDrawer(param1:Number = NaN) : void
      {
         if(!this._bottomDrawer || this.isBottomDrawerDocked)
         {
            return;
         }
         this.pendingToggleDuration = param1;
         if(this.isToggleBottomDrawerPending)
         {
            return;
         }
         if(!this.isBottomDrawerOpen)
         {
            this.isTopDrawerOpen = false;
            this.isRightDrawerOpen = false;
            this.isLeftDrawerOpen = false;
         }
         this.isToggleTopDrawerPending = false;
         this.isToggleRightDrawerPending = false;
         this.isToggleBottomDrawerPending = true;
         this.isToggleLeftDrawerPending = false;
         this.invalidate("selected");
      }
      
      public function toggleLeftDrawer(param1:Number = NaN) : void
      {
         if(!this._leftDrawer || this.isLeftDrawerDocked)
         {
            return;
         }
         this.pendingToggleDuration = param1;
         if(this.isToggleLeftDrawerPending)
         {
            return;
         }
         if(!this.isLeftDrawerOpen)
         {
            this.isTopDrawerOpen = false;
            this.isRightDrawerOpen = false;
            this.isBottomDrawerOpen = false;
         }
         this.isToggleTopDrawerPending = false;
         this.isToggleRightDrawerPending = false;
         this.isToggleBottomDrawerPending = false;
         this.isToggleLeftDrawerPending = true;
         this.invalidate("selected");
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc4_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("layout");
         var _loc3_:Boolean = this.isInvalid("selected");
         if(_loc4_)
         {
            this.refreshCurrentEventTarget();
         }
         if(_loc1_ || _loc2_)
         {
            this.refreshDrawerStates();
         }
         if(_loc1_ || _loc2_ || _loc3_)
         {
            this.refreshOverlayState();
         }
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layoutChildren();
         this.handlePendingActions();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc2_:* = this._explicitWidth !== this._explicitWidth;
         var _loc11_:* = this._explicitHeight !== this._explicitHeight;
         var _loc9_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc13_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc2_ && !_loc11_ && !_loc9_ && !_loc13_)
         {
            return false;
         }
         var _loc4_:Boolean = this._autoSizeMode === "content" || !this.stage;
         var _loc3_:Boolean = this.isTopDrawerDocked;
         var _loc7_:Boolean = this.isRightDrawerDocked;
         var _loc12_:Boolean = this.isBottomDrawerDocked;
         var _loc6_:Boolean = this.isLeftDrawerDocked;
         if(_loc4_)
         {
            if(this._content)
            {
               this._content.validate();
               if(this._originalContentWidth !== this._originalContentWidth)
               {
                  this._originalContentWidth = this._content.width;
               }
               if(this._originalContentHeight !== this._originalContentHeight)
               {
                  this._originalContentHeight = this._content.height;
               }
            }
            if(_loc3_)
            {
               this._topDrawer.validate();
               if(this._originalTopDrawerWidth !== this._originalTopDrawerWidth)
               {
                  this._originalTopDrawerWidth = this._topDrawer.width;
               }
               if(this._originalTopDrawerHeight !== this._originalTopDrawerHeight)
               {
                  this._originalTopDrawerHeight = this._topDrawer.height;
               }
            }
            if(_loc7_)
            {
               this._rightDrawer.validate();
               if(this._originalRightDrawerWidth !== this._originalRightDrawerWidth)
               {
                  this._originalRightDrawerWidth = this._rightDrawer.width;
               }
               if(this._originalRightDrawerHeight !== this._originalRightDrawerHeight)
               {
                  this._originalRightDrawerHeight = this._rightDrawer.height;
               }
            }
            if(_loc12_)
            {
               this._bottomDrawer.validate();
               if(this._originalBottomDrawerWidth !== this._originalBottomDrawerWidth)
               {
                  this._originalBottomDrawerWidth = this._bottomDrawer.width;
               }
               if(this._originalBottomDrawerHeight !== this._originalBottomDrawerHeight)
               {
                  this._originalBottomDrawerHeight = this._bottomDrawer.height;
               }
            }
            if(_loc6_)
            {
               this._leftDrawer.validate();
               if(this._originalLeftDrawerWidth !== this._originalLeftDrawerWidth)
               {
                  this._originalLeftDrawerWidth = this._leftDrawer.width;
               }
               if(this._originalLeftDrawerHeight !== this._originalLeftDrawerHeight)
               {
                  this._originalLeftDrawerHeight = this._leftDrawer.height;
               }
            }
         }
         var _loc1_:Number = this._explicitWidth;
         if(_loc2_)
         {
            if(_loc4_)
            {
               if(this._content)
               {
                  _loc1_ = this._originalContentWidth;
               }
               else
               {
                  _loc1_ = 0;
               }
               if(_loc6_)
               {
                  _loc1_ += this._originalLeftDrawerWidth;
               }
               if(_loc7_)
               {
                  _loc1_ += this._originalRightDrawerWidth;
               }
               if(_loc3_ && this._originalTopDrawerWidth > _loc1_)
               {
                  _loc1_ = this._originalTopDrawerWidth;
               }
               if(_loc12_ && this._originalBottomDrawerWidth > _loc1_)
               {
                  _loc1_ = this._originalBottomDrawerWidth;
               }
            }
            else
            {
               _loc1_ = this.stage.stageWidth;
            }
         }
         var _loc5_:Number = this._explicitHeight;
         if(_loc11_)
         {
            if(_loc4_)
            {
               if(this._content)
               {
                  _loc5_ = this._originalContentHeight;
               }
               else
               {
                  _loc5_ = 0;
               }
               if(_loc3_)
               {
                  _loc5_ += this._originalTopDrawerHeight;
               }
               if(_loc12_)
               {
                  _loc5_ += this._originalBottomDrawerHeight;
               }
               if(_loc6_ && this._originalLeftDrawerHeight > _loc5_)
               {
                  _loc5_ = this._originalLeftDrawerHeight;
               }
               if(_loc7_ && this._originalRightDrawerHeight > _loc5_)
               {
                  _loc5_ = this._originalRightDrawerHeight;
               }
            }
            else
            {
               _loc5_ = this.stage.stageHeight;
            }
         }
         var _loc8_:Number = this._explicitMinWidth;
         if(_loc9_)
         {
            if(_loc4_)
            {
               _loc8_ = Number(this._content.minWidth);
               if(_loc6_)
               {
                  _loc8_ += this._leftDrawer.minWidth;
               }
               if(_loc7_)
               {
                  _loc8_ += this._rightDrawer.minWidth;
               }
               if(_loc3_ && this._topDrawer.minWidth > _loc8_)
               {
                  _loc8_ = Number(this._topDrawer.minWidth);
               }
               if(_loc12_ && this._bottomDrawer.minWidth > _loc8_)
               {
                  _loc8_ = Number(this._bottomDrawer.minWidth);
               }
            }
            else
            {
               _loc8_ = this.stage.stageWidth;
            }
         }
         var _loc10_:Number = this._explicitMinHeight;
         if(_loc13_)
         {
            if(_loc4_)
            {
               _loc10_ = Number(this._content.minHeight);
               if(_loc3_)
               {
                  _loc10_ += this._topDrawer.minHeight;
               }
               if(_loc12_)
               {
                  _loc10_ += this._bottomDrawer.minHeight;
               }
               if(_loc6_ && this._leftDrawer.minHeight > _loc10_)
               {
                  _loc10_ = Number(this._leftDrawer.minHeight);
               }
               if(_loc7_ && this._rightDrawer.minHeight > _loc10_)
               {
                  _loc10_ = Number(this._rightDrawer.minHeight);
               }
            }
            else
            {
               _loc10_ = this.stage.stageHeight;
            }
         }
         return this.saveMeasurements(_loc1_,_loc5_,_loc8_,_loc10_);
      }
      
      protected function layoutChildren() : void
      {
         var _loc11_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc13_:Boolean = this.isTopDrawerOpen;
         var _loc4_:Boolean = this.isRightDrawerOpen;
         var _loc16_:Boolean = this.isBottomDrawerOpen;
         var _loc5_:Boolean = this.isLeftDrawerOpen;
         var _loc7_:Boolean = this.isTopDrawerDocked;
         var _loc18_:Boolean = this.isRightDrawerDocked;
         var _loc21_:Boolean = this.isBottomDrawerDocked;
         var _loc12_:Boolean = this.isLeftDrawerDocked;
         var _loc6_:Number = 0;
         var _loc22_:Number = 0;
         if(this._topDrawer !== null)
         {
            this._topDrawer.width = this.actualWidth;
            this._topDrawer.validate();
            _loc6_ = Number(this._topDrawer.height);
            if(this._topDrawerDivider !== null)
            {
               this._topDrawerDivider.width = this._topDrawer.width;
               if(this._topDrawerDivider is IValidating)
               {
                  IValidating(this._topDrawerDivider).validate();
               }
            }
         }
         if(this._bottomDrawer !== null)
         {
            this._bottomDrawer.width = this.actualWidth;
            this._bottomDrawer.validate();
            _loc22_ = Number(this._bottomDrawer.height);
            if(this._bottomDrawerDivider !== null)
            {
               this._bottomDrawerDivider.width = this._bottomDrawer.width;
               if(this._bottomDrawerDivider is IValidating)
               {
                  IValidating(this._bottomDrawerDivider).validate();
               }
            }
         }
         var _loc14_:Number = this.actualHeight;
         if(_loc7_)
         {
            _loc14_ -= _loc6_;
            if(this._topDrawerDivider !== null)
            {
               _loc14_ -= this._topDrawerDivider.height;
            }
         }
         if(_loc21_)
         {
            _loc14_ -= _loc22_;
            if(this._bottomDrawerDivider !== null)
            {
               _loc14_ -= this._bottomDrawerDivider.height;
            }
         }
         if(_loc14_ < 0)
         {
            _loc14_ = 0;
         }
         var _loc20_:Number = 0;
         var _loc8_:Number = 0;
         if(this._rightDrawer !== null)
         {
            if(_loc18_)
            {
               this._rightDrawer.height = _loc14_;
            }
            else
            {
               this._rightDrawer.height = this.actualHeight;
            }
            this._rightDrawer.validate();
            _loc20_ = Number(this._rightDrawer.width);
            if(this._rightDrawerDivider !== null)
            {
               this._rightDrawerDivider.height = this._rightDrawer.height;
               if(this._rightDrawerDivider is IValidating)
               {
                  IValidating(this._rightDrawerDivider).validate();
               }
            }
         }
         if(this._leftDrawer !== null)
         {
            if(_loc12_)
            {
               this._leftDrawer.height = _loc14_;
            }
            else
            {
               this._leftDrawer.height = this.actualHeight;
            }
            this._leftDrawer.validate();
            _loc8_ = Number(this._leftDrawer.width);
            if(this._leftDrawerDivider !== null)
            {
               this._leftDrawerDivider.height = this._leftDrawer.height;
               if(this._leftDrawerDivider is IValidating)
               {
                  IValidating(this._leftDrawerDivider).validate();
               }
            }
         }
         var _loc19_:Number = this.actualWidth;
         if(_loc12_)
         {
            _loc19_ -= _loc8_;
            if(this._leftDrawerDivider !== null)
            {
               _loc19_ -= this._leftDrawerDivider.width;
            }
         }
         if(_loc18_)
         {
            _loc19_ -= _loc20_;
            if(this._rightDrawerDivider !== null)
            {
               _loc19_ -= this._rightDrawerDivider.width;
            }
         }
         if(_loc19_ < 0)
         {
            _loc19_ = 0;
         }
         var _loc17_:* = 0;
         if(_loc4_ && this._openMode === "below")
         {
            _loc17_ = -_loc20_;
            if(_loc12_)
            {
               _loc17_ += _loc8_;
               if(this._leftDrawerDivider)
               {
                  _loc17_ += this._leftDrawerDivider.width;
               }
            }
         }
         else if(_loc5_ && this._openMode === "below" || _loc12_)
         {
            _loc17_ = _loc8_;
            if(this._leftDrawerDivider && _loc12_)
            {
               _loc17_ += this._leftDrawerDivider.width;
            }
         }
         this._content.x = _loc17_;
         var _loc15_:* = 0;
         if(_loc16_ && this._openMode === "below")
         {
            _loc15_ = -_loc22_;
            if(_loc7_)
            {
               _loc15_ += _loc6_;
               if(this._topDrawerDivider)
               {
                  _loc15_ += this._topDrawerDivider.height;
               }
            }
         }
         else if(_loc13_ && this._openMode === "below" || _loc7_)
         {
            _loc15_ = _loc6_;
            if(this._topDrawerDivider && _loc7_)
            {
               _loc15_ += this._topDrawerDivider.height;
            }
         }
         this._content.y = _loc15_;
         if(this._autoSizeMode !== "content")
         {
            this._content.width = _loc19_;
            this._content.height = _loc14_;
            this._content.validate();
         }
         if(this._topDrawer !== null)
         {
            _loc11_ = 0;
            _loc10_ = 0;
            if(_loc7_)
            {
               if(_loc16_ && this._openMode === "below")
               {
                  _loc10_ -= _loc22_;
               }
               if(!_loc12_)
               {
                  _loc11_ = Number(this._content.x);
               }
            }
            else if(this._openMode === "above" && !this._isTopDrawerOpen)
            {
               _loc10_ -= _loc6_;
            }
            this._topDrawer.x = _loc11_;
            this._topDrawer.y = _loc10_;
            this._topDrawer.visible = _loc13_ || _loc7_ || this._isDraggingTopDrawer;
            if(this._topDrawerDivider !== null)
            {
               this._topDrawerDivider.visible = _loc7_;
               this._topDrawerDivider.x = _loc11_;
               this._topDrawerDivider.y = _loc10_ + _loc6_;
            }
            this._topDrawer.validate();
         }
         if(this._rightDrawer !== null)
         {
            _loc3_ = this.actualWidth - _loc20_;
            _loc9_ = 0;
            if(_loc18_)
            {
               _loc3_ = this._content.x + this._content.width;
               if(this._rightDrawerDivider)
               {
                  _loc3_ += this._rightDrawerDivider.width;
               }
               _loc9_ = Number(this._content.y);
            }
            else if(this._openMode === "above" && !this._isRightDrawerOpen)
            {
               _loc3_ += _loc20_;
            }
            this._rightDrawer.x = _loc3_;
            this._rightDrawer.y = _loc9_;
            this._rightDrawer.visible = _loc4_ || _loc18_ || this._isDraggingRightDrawer;
            if(this._rightDrawerDivider !== null)
            {
               this._rightDrawerDivider.visible = _loc18_;
               this._rightDrawerDivider.x = _loc3_ - this._rightDrawerDivider.width;
               this._rightDrawerDivider.y = _loc9_;
            }
            this._rightDrawer.validate();
         }
         if(this._bottomDrawer !== null)
         {
            _loc23_ = 0;
            _loc24_ = this.actualHeight - _loc22_;
            if(_loc21_)
            {
               if(!_loc12_)
               {
                  _loc23_ = Number(this._content.x);
               }
               _loc24_ = this._content.y + this._content.height;
               if(this._bottomDrawerDivider)
               {
                  _loc24_ += this._bottomDrawerDivider.height;
               }
            }
            else if(this._openMode === "above" && !this._isBottomDrawerOpen)
            {
               _loc24_ += _loc22_;
            }
            this._bottomDrawer.x = _loc23_;
            this._bottomDrawer.y = _loc24_;
            this._bottomDrawer.visible = _loc16_ || _loc21_ || this._isDraggingBottomDrawer;
            if(this._bottomDrawerDivider !== null)
            {
               this._bottomDrawerDivider.visible = _loc21_;
               this._bottomDrawerDivider.x = _loc23_;
               this._bottomDrawerDivider.y = _loc24_ - this._bottomDrawerDivider.height;
            }
            this._bottomDrawer.validate();
         }
         if(this._leftDrawer !== null)
         {
            _loc1_ = 0;
            _loc2_ = 0;
            if(_loc12_)
            {
               if(_loc4_ && this._openMode === "below")
               {
                  _loc1_ -= _loc20_;
               }
               _loc2_ = Number(this._content.y);
            }
            else if(this._openMode === "above" && !this._isLeftDrawerOpen)
            {
               _loc1_ -= _loc8_;
            }
            this._leftDrawer.x = _loc1_;
            this._leftDrawer.y = _loc2_;
            this._leftDrawer.visible = _loc5_ || _loc12_ || this._isDraggingLeftDrawer;
            if(this._leftDrawerDivider !== null)
            {
               this._leftDrawerDivider.visible = _loc12_;
               this._leftDrawerDivider.x = _loc1_ + _loc8_;
               this._leftDrawerDivider.y = _loc2_;
            }
            this._leftDrawer.validate();
         }
         if(this._overlaySkin !== null)
         {
            this.positionOverlaySkin();
            this._overlaySkin.width = this.actualWidth;
            this._overlaySkin.height = this.actualHeight;
            if(this._overlaySkin is IValidating)
            {
               IValidating(this._overlaySkin).validate();
            }
         }
      }
      
      protected function handlePendingActions() : void
      {
         if(this.isToggleTopDrawerPending)
         {
            this._isTopDrawerOpen = !this._isTopDrawerOpen;
            this.isToggleTopDrawerPending = false;
            this.openOrCloseTopDrawer();
         }
         else if(this.isToggleRightDrawerPending)
         {
            this._isRightDrawerOpen = !this._isRightDrawerOpen;
            this.isToggleRightDrawerPending = false;
            this.openOrCloseRightDrawer();
         }
         else if(this.isToggleBottomDrawerPending)
         {
            this._isBottomDrawerOpen = !this._isBottomDrawerOpen;
            this.isToggleBottomDrawerPending = false;
            this.openOrCloseBottomDrawer();
         }
         else if(this.isToggleLeftDrawerPending)
         {
            this._isLeftDrawerOpen = !this._isLeftDrawerOpen;
            this.isToggleLeftDrawerPending = false;
            this.openOrCloseLeftDrawer();
         }
      }
      
      protected function openOrCloseTopDrawer() : void
      {
         if(!this._topDrawer || this.isTopDrawerDocked)
         {
            return;
         }
         if(this._openOrCloseTween)
         {
            this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
            Starling.juggler.remove(this._openOrCloseTween);
            this._openOrCloseTween = null;
         }
         this.prepareTopDrawer();
         if(this._overlaySkin)
         {
            this._overlaySkin.visible = true;
            if(this._isTopDrawerOpen)
            {
               this._overlaySkin.alpha = 0;
            }
            else
            {
               this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
            }
         }
         var _loc2_:Number = Number(this._isTopDrawerOpen ? this._topDrawer.height : 0);
         var _loc1_:Number = this.pendingToggleDuration;
         if(_loc1_ !== _loc1_)
         {
            _loc1_ = this._openOrCloseDuration;
         }
         this.pendingToggleDuration = NaN;
         if(this._openMode === "above")
         {
            _loc2_ = _loc2_ === 0 ? -this._topDrawer.height : 0;
            this._openOrCloseTween = new Tween(this._topDrawer,_loc1_,this._openOrCloseEase);
         }
         else
         {
            this._openOrCloseTween = new Tween(this._content,_loc1_,this._openOrCloseEase);
         }
         this._openOrCloseTween.animate("y",_loc2_);
         this._openOrCloseTween.onUpdate = topDrawerOpenOrCloseTween_onUpdate;
         this._openOrCloseTween.onComplete = topDrawerOpenOrCloseTween_onComplete;
         Starling.juggler.add(this._openOrCloseTween);
      }
      
      protected function openOrCloseRightDrawer() : void
      {
         if(!this._rightDrawer || this.isRightDrawerDocked)
         {
            return;
         }
         if(this._openOrCloseTween)
         {
            this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
            Starling.juggler.remove(this._openOrCloseTween);
            this._openOrCloseTween = null;
         }
         this.prepareRightDrawer();
         if(this._overlaySkin)
         {
            this._overlaySkin.visible = true;
            if(this._isRightDrawerOpen)
            {
               this._overlaySkin.alpha = 0;
            }
            else
            {
               this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
            }
         }
         var _loc2_:Number = 0;
         if(this._isRightDrawerOpen)
         {
            _loc2_ = -this._rightDrawer.width;
         }
         if(this.isLeftDrawerDocked && this._openMode === "below")
         {
            _loc2_ += this._leftDrawer.width;
            if(this._leftDrawerDivider)
            {
               _loc2_ += this._leftDrawerDivider.width;
            }
         }
         var _loc1_:Number = this.pendingToggleDuration;
         if(_loc1_ !== _loc1_)
         {
            _loc1_ = this._openOrCloseDuration;
         }
         this.pendingToggleDuration = NaN;
         if(this._openMode === "above")
         {
            this._openOrCloseTween = new Tween(this._rightDrawer,_loc1_,this._openOrCloseEase);
            _loc2_ += this.actualWidth;
         }
         else
         {
            this._openOrCloseTween = new Tween(this._content,_loc1_,this._openOrCloseEase);
         }
         this._openOrCloseTween.animate("x",_loc2_);
         this._openOrCloseTween.onUpdate = rightDrawerOpenOrCloseTween_onUpdate;
         this._openOrCloseTween.onComplete = rightDrawerOpenOrCloseTween_onComplete;
         Starling.juggler.add(this._openOrCloseTween);
      }
      
      protected function openOrCloseBottomDrawer() : void
      {
         if(!this._bottomDrawer || this.isBottomDrawerDocked)
         {
            return;
         }
         if(this._openOrCloseTween)
         {
            this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
            Starling.juggler.remove(this._openOrCloseTween);
            this._openOrCloseTween = null;
         }
         this.prepareBottomDrawer();
         if(this._overlaySkin)
         {
            this._overlaySkin.visible = true;
            if(this._isBottomDrawerOpen)
            {
               this._overlaySkin.alpha = 0;
            }
            else
            {
               this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
            }
         }
         var _loc2_:Number = 0;
         if(this._isBottomDrawerOpen)
         {
            _loc2_ = -this._bottomDrawer.height;
         }
         if(this.isTopDrawerDocked && this._openMode === "below")
         {
            _loc2_ += this._topDrawer.height;
            if(this._topDrawerDivider)
            {
               _loc2_ += this._topDrawerDivider.height;
            }
         }
         var _loc1_:Number = this.pendingToggleDuration;
         if(_loc1_ !== _loc1_)
         {
            _loc1_ = this._openOrCloseDuration;
         }
         this.pendingToggleDuration = NaN;
         if(this._openMode === "above")
         {
            _loc2_ += this.actualHeight;
            this._openOrCloseTween = new Tween(this._bottomDrawer,_loc1_,this._openOrCloseEase);
         }
         else
         {
            this._openOrCloseTween = new Tween(this._content,_loc1_,this._openOrCloseEase);
         }
         this._openOrCloseTween.animate("y",_loc2_);
         this._openOrCloseTween.onUpdate = bottomDrawerOpenOrCloseTween_onUpdate;
         this._openOrCloseTween.onComplete = bottomDrawerOpenOrCloseTween_onComplete;
         Starling.juggler.add(this._openOrCloseTween);
      }
      
      protected function openOrCloseLeftDrawer() : void
      {
         if(!this._leftDrawer || this.isLeftDrawerDocked)
         {
            return;
         }
         if(this._openOrCloseTween)
         {
            this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
            Starling.juggler.remove(this._openOrCloseTween);
            this._openOrCloseTween = null;
         }
         this.prepareLeftDrawer();
         if(this._overlaySkin)
         {
            this._overlaySkin.visible = true;
            if(this._isLeftDrawerOpen)
            {
               this._overlaySkin.alpha = 0;
            }
            else
            {
               this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
            }
         }
         var _loc2_:Number = Number(this._isLeftDrawerOpen ? this._leftDrawer.width : 0);
         var _loc1_:Number = this.pendingToggleDuration;
         if(_loc1_ !== _loc1_)
         {
            _loc1_ = this._openOrCloseDuration;
         }
         this.pendingToggleDuration = NaN;
         if(this._openMode === "above")
         {
            _loc2_ = _loc2_ === 0 ? -this._leftDrawer.width : 0;
            this._openOrCloseTween = new Tween(this._leftDrawer,_loc1_,this._openOrCloseEase);
         }
         else
         {
            this._openOrCloseTween = new Tween(this._content,_loc1_,this._openOrCloseEase);
         }
         this._openOrCloseTween.animate("x",_loc2_);
         this._openOrCloseTween.onUpdate = leftDrawerOpenOrCloseTween_onUpdate;
         this._openOrCloseTween.onComplete = leftDrawerOpenOrCloseTween_onComplete;
         Starling.juggler.add(this._openOrCloseTween);
      }
      
      protected function prepareTopDrawer() : void
      {
         var _loc1_:Quad = null;
         this._topDrawer.visible = true;
         if(this._openMode === "above")
         {
            if(this._overlaySkin)
            {
               this.setChildIndex(this._overlaySkin,this.numChildren - 1);
            }
            this.setChildIndex(DisplayObject(this._topDrawer),this.numChildren - 1);
         }
         if(!this._clipDrawers || this._openMode !== "below")
         {
            return;
         }
         if(this._topDrawer.mask === null)
         {
            _loc1_ = new Quad(1,1,16711935);
            _loc1_.width = this.actualWidth;
            _loc1_.height = this._content.y;
            this._topDrawer.mask = _loc1_;
         }
      }
      
      protected function prepareRightDrawer() : void
      {
         var _loc1_:Quad = null;
         this._rightDrawer.visible = true;
         if(this._openMode === "above")
         {
            if(this._overlaySkin)
            {
               this.setChildIndex(this._overlaySkin,this.numChildren - 1);
            }
            this.setChildIndex(DisplayObject(this._rightDrawer),this.numChildren - 1);
         }
         if(!this._clipDrawers || this._openMode !== "below")
         {
            return;
         }
         if(this._rightDrawer.mask === null)
         {
            _loc1_ = new Quad(1,1,16711935);
            if(this.isLeftDrawerDocked)
            {
               _loc1_.width = -this._leftDrawer.x;
            }
            else
            {
               _loc1_.width = -this._content.x;
            }
            _loc1_.height = this.actualHeight;
            this._rightDrawer.mask = _loc1_;
         }
      }
      
      protected function prepareBottomDrawer() : void
      {
         var _loc1_:Quad = null;
         this._bottomDrawer.visible = true;
         if(this._openMode === "above")
         {
            if(this._overlaySkin)
            {
               this.setChildIndex(this._overlaySkin,this.numChildren - 1);
            }
            this.setChildIndex(DisplayObject(this._bottomDrawer),this.numChildren - 1);
         }
         if(!this._clipDrawers || this._openMode !== "below")
         {
            return;
         }
         if(this._bottomDrawer.mask === null)
         {
            _loc1_ = new Quad(1,1,16711935);
            _loc1_.width = this.actualWidth;
            if(this.isTopDrawerDocked)
            {
               _loc1_.height = -this._topDrawer.y;
            }
            else
            {
               _loc1_.height = -this._content.y;
            }
            this._bottomDrawer.mask = _loc1_;
         }
      }
      
      protected function prepareLeftDrawer() : void
      {
         var _loc1_:Quad = null;
         this._leftDrawer.visible = true;
         if(this._openMode === "above")
         {
            if(this._overlaySkin)
            {
               this.setChildIndex(this._overlaySkin,this.numChildren - 1);
            }
            this.setChildIndex(DisplayObject(this._leftDrawer),this.numChildren - 1);
         }
         if(!this._clipDrawers || this._openMode !== "below")
         {
            return;
         }
         if(this._leftDrawer.mask === null)
         {
            _loc1_ = new Quad(1,1,16711935);
            _loc1_.width = this._content.x;
            _loc1_.height = this.actualHeight;
            this._leftDrawer.mask = _loc1_;
         }
      }
      
      protected function contentToContentEventDispatcher() : EventDispatcher
      {
         if(this._contentEventDispatcherFunction !== null)
         {
            return this._contentEventDispatcherFunction(this._content) as EventDispatcher;
         }
         if(this._contentEventDispatcherField !== null && this._content && this._contentEventDispatcherField in this._content)
         {
            return this._content[this._contentEventDispatcherField] as EventDispatcher;
         }
         return this._content as EventDispatcher;
      }
      
      protected function refreshCurrentEventTarget() : void
      {
         if(this.contentEventDispatcher)
         {
            if(this._topDrawerToggleEventType)
            {
               this.contentEventDispatcher.removeEventListener(this._topDrawerToggleEventType,content_topDrawerToggleEventTypeHandler);
            }
            if(this._rightDrawerToggleEventType)
            {
               this.contentEventDispatcher.removeEventListener(this._rightDrawerToggleEventType,content_rightDrawerToggleEventTypeHandler);
            }
            if(this._bottomDrawerToggleEventType)
            {
               this.contentEventDispatcher.removeEventListener(this._bottomDrawerToggleEventType,content_bottomDrawerToggleEventTypeHandler);
            }
            if(this._leftDrawerToggleEventType)
            {
               this.contentEventDispatcher.removeEventListener(this._leftDrawerToggleEventType,content_leftDrawerToggleEventTypeHandler);
            }
         }
         this.contentEventDispatcher = this.contentToContentEventDispatcher();
         if(this.contentEventDispatcher)
         {
            if(this._topDrawerToggleEventType)
            {
               this.contentEventDispatcher.addEventListener(this._topDrawerToggleEventType,content_topDrawerToggleEventTypeHandler);
            }
            if(this._rightDrawerToggleEventType)
            {
               this.contentEventDispatcher.addEventListener(this._rightDrawerToggleEventType,content_rightDrawerToggleEventTypeHandler);
            }
            if(this._bottomDrawerToggleEventType)
            {
               this.contentEventDispatcher.addEventListener(this._bottomDrawerToggleEventType,content_bottomDrawerToggleEventTypeHandler);
            }
            if(this._leftDrawerToggleEventType)
            {
               this.contentEventDispatcher.addEventListener(this._leftDrawerToggleEventType,content_leftDrawerToggleEventTypeHandler);
            }
         }
      }
      
      protected function refreshDrawerStates() : void
      {
         if(this.isTopDrawerDocked && this._isTopDrawerOpen)
         {
            this._isTopDrawerOpen = false;
         }
         if(this.isRightDrawerDocked && this._isRightDrawerOpen)
         {
            this._isRightDrawerOpen = false;
         }
         if(this.isBottomDrawerDocked && this._isBottomDrawerOpen)
         {
            this._isBottomDrawerOpen = false;
         }
         if(this.isLeftDrawerDocked && this._isLeftDrawerOpen)
         {
            this._isLeftDrawerOpen = false;
         }
      }
      
      protected function refreshOverlayState() : void
      {
         if(!this._overlaySkin || this._isDragging)
         {
            return;
         }
         var _loc1_:Boolean = this._isTopDrawerOpen && !this.isTopDrawerDocked || this._isRightDrawerOpen && !this.isRightDrawerDocked || this._isBottomDrawerOpen && !this.isBottomDrawerDocked || this._isLeftDrawerOpen && !this.isLeftDrawerDocked;
         if(_loc1_ !== this._overlaySkin.visible)
         {
            this._overlaySkin.visible = _loc1_;
            this._overlaySkin.alpha = _loc1_ ? this._overlaySkinOriginalAlpha : 0;
         }
      }
      
      protected function handleTapToClose(param1:Touch) : void
      {
         param1.getLocation(this.stage,HELPER_POINT);
         if(this !== this.stage.hitTest(HELPER_POINT))
         {
            return;
         }
         if(this.isTopDrawerOpen)
         {
            this._isTopDrawerOpen = false;
            this.openOrCloseTopDrawer();
         }
         else if(this.isRightDrawerOpen)
         {
            this._isRightDrawerOpen = false;
            this.openOrCloseRightDrawer();
         }
         else if(this.isBottomDrawerOpen)
         {
            this._isBottomDrawerOpen = false;
            this.openOrCloseBottomDrawer();
         }
         else if(this.isLeftDrawerOpen)
         {
            this._isLeftDrawerOpen = false;
            this.openOrCloseLeftDrawer();
         }
      }
      
      protected function handleTouchBegan(param1:Touch) : void
      {
         var _loc7_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
         if(_loc3_.getClaim(param1.id))
         {
            return;
         }
         param1.getLocation(this,HELPER_POINT);
         var _loc5_:Number = HELPER_POINT.x;
         var _loc4_:Number = HELPER_POINT.y;
         if(!this.isTopDrawerOpen && !this.isRightDrawerOpen && !this.isBottomDrawerOpen && !this.isLeftDrawerOpen)
         {
            if(this._openGesture === "none")
            {
               return;
            }
            if(this._openGesture === "edge")
            {
               _loc7_ = false;
               if(this._topDrawer && !this.isTopDrawerDocked)
               {
                  _loc2_ = _loc4_ / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
                  if(_loc2_ >= 0 && _loc2_ <= this._openGestureEdgeSize)
                  {
                     _loc7_ = true;
                  }
               }
               if(!_loc7_)
               {
                  if(this._rightDrawer && !this.isRightDrawerDocked)
                  {
                     if((_loc8_ = (this.actualWidth - _loc5_) / (DeviceCapabilities.dpi / Starling.contentScaleFactor)) >= 0 && _loc8_ <= this._openGestureEdgeSize)
                     {
                        _loc7_ = true;
                     }
                  }
                  if(!_loc7_)
                  {
                     if(this._bottomDrawer && !this.isBottomDrawerDocked)
                     {
                        if((_loc9_ = (this.actualHeight - _loc4_) / (DeviceCapabilities.dpi / Starling.contentScaleFactor)) >= 0 && _loc9_ <= this._openGestureEdgeSize)
                        {
                           _loc7_ = true;
                        }
                     }
                     if(!_loc7_)
                     {
                        if(this._leftDrawer && !this.isLeftDrawerDocked)
                        {
                           if((_loc6_ = _loc5_ / (DeviceCapabilities.dpi / Starling.contentScaleFactor)) >= 0 && _loc6_ <= this._openGestureEdgeSize)
                           {
                              _loc7_ = true;
                           }
                        }
                     }
                  }
               }
               if(!_loc7_)
               {
                  return;
               }
            }
         }
         else if(this._openMode === "below" && param1.target !== this)
         {
            return;
         }
         this.touchPointID = param1.id;
         this._velocityX = 0;
         this._velocityY = 0;
         this._previousVelocityX.length = 0;
         this._previousVelocityY.length = 0;
         this._previousTouchTime = getTimer();
         this._previousTouchX = this._startTouchX = this._currentTouchX = _loc5_;
         this._previousTouchY = this._startTouchY = this._currentTouchY = _loc4_;
         this._isDragging = false;
         this._isDraggingTopDrawer = false;
         this._isDraggingRightDrawer = false;
         this._isDraggingBottomDrawer = false;
         this._isDraggingLeftDrawer = false;
         _loc3_.addEventListener("change",exclusiveTouch_changeHandler);
      }
      
      protected function handleTouchMoved(param1:Touch) : void
      {
         param1.getLocation(this,HELPER_POINT);
         this._currentTouchX = HELPER_POINT.x;
         this._currentTouchY = HELPER_POINT.y;
         var _loc2_:int = getTimer();
         var _loc3_:int = _loc2_ - this._previousTouchTime;
         if(_loc3_ > 0)
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
            this._velocityX = (this._currentTouchX - this._previousTouchX) / _loc3_;
            this._velocityY = (this._currentTouchY - this._previousTouchY) / _loc3_;
            this._previousTouchTime = _loc2_;
            this._previousTouchX = this._currentTouchX;
            this._previousTouchY = this._currentTouchY;
         }
      }
      
      protected function handleDragEnd() : void
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc7_:Number = this._velocityX * 2.33;
         var _loc1_:int = int(this._previousVelocityX.length);
         var _loc4_:Number = 2.33;
         _loc5_ = 0;
         while(_loc5_ < _loc1_)
         {
            _loc6_ = VELOCITY_WEIGHTS[_loc5_];
            _loc7_ += this._previousVelocityX.shift() * _loc6_;
            _loc4_ += _loc6_;
            _loc5_++;
         }
         var _loc3_:Number = 1000 * (_loc7_ / _loc4_) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         _loc7_ = this._velocityY * 2.33;
         _loc1_ = int(this._previousVelocityY.length);
         _loc4_ = 2.33;
         _loc5_ = 0;
         while(_loc5_ < _loc1_)
         {
            _loc6_ = VELOCITY_WEIGHTS[_loc5_];
            _loc7_ += this._previousVelocityY.shift() * _loc6_;
            _loc4_ += _loc6_;
            _loc5_++;
         }
         var _loc8_:Number = 1000 * (_loc7_ / _loc4_) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         this._isDragging = false;
         if(this._isDraggingTopDrawer)
         {
            this._isDraggingTopDrawer = false;
            if(!this._isTopDrawerOpen && _loc8_ > this._minimumDrawerThrowVelocity)
            {
               this._isTopDrawerOpen = true;
            }
            else if(this._isTopDrawerOpen && _loc8_ < -this._minimumDrawerThrowVelocity)
            {
               this._isTopDrawerOpen = false;
            }
            else if(this._openMode === "above")
            {
               this._isTopDrawerOpen = roundToNearest(this._topDrawer.y,this._topDrawer.height) == 0;
            }
            else
            {
               this._isTopDrawerOpen = roundToNearest(this._content.y,this._topDrawer.height) != 0;
            }
            this.openOrCloseTopDrawer();
         }
         else if(this._isDraggingRightDrawer)
         {
            this._isDraggingRightDrawer = false;
            if(!this._isRightDrawerOpen && _loc3_ < -this._minimumDrawerThrowVelocity)
            {
               this._isRightDrawerOpen = true;
            }
            else if(this._isRightDrawerOpen && _loc3_ > this._minimumDrawerThrowVelocity)
            {
               this._isRightDrawerOpen = false;
            }
            else if(this._openMode === "above")
            {
               this._isRightDrawerOpen = roundToNearest(this.actualWidth - this._rightDrawer.x,this._rightDrawer.width) != 0;
            }
            else
            {
               _loc2_ = Number(this._content.x);
               if(this.isLeftDrawerDocked)
               {
                  _loc2_ -= this._leftDrawer.width;
               }
               this._isRightDrawerOpen = roundToNearest(_loc2_,this._rightDrawer.width) != 0;
            }
            this.openOrCloseRightDrawer();
         }
         else if(this._isDraggingBottomDrawer)
         {
            this._isDraggingBottomDrawer = false;
            if(!this._isBottomDrawerOpen && _loc8_ < -this._minimumDrawerThrowVelocity)
            {
               this._isBottomDrawerOpen = true;
            }
            else if(this._isBottomDrawerOpen && _loc8_ > this._minimumDrawerThrowVelocity)
            {
               this._isBottomDrawerOpen = false;
            }
            else if(this._openMode === "above")
            {
               this._isBottomDrawerOpen = roundToNearest(this.actualHeight - this._bottomDrawer.y,this._bottomDrawer.height) != 0;
            }
            else
            {
               _loc2_ = Number(this._content.y);
               if(this.isTopDrawerDocked)
               {
                  _loc2_ -= this._topDrawer.height;
               }
               this._isBottomDrawerOpen = roundToNearest(_loc2_,this._bottomDrawer.height) != 0;
            }
            this.openOrCloseBottomDrawer();
         }
         else if(this._isDraggingLeftDrawer)
         {
            this._isDraggingLeftDrawer = false;
            if(!this._isLeftDrawerOpen && _loc3_ > this._minimumDrawerThrowVelocity)
            {
               this._isLeftDrawerOpen = true;
            }
            else if(this._isLeftDrawerOpen && _loc3_ < -this._minimumDrawerThrowVelocity)
            {
               this._isLeftDrawerOpen = false;
            }
            else if(this._openMode === "above")
            {
               this._isLeftDrawerOpen = roundToNearest(this._leftDrawer.x,this._leftDrawer.width) == 0;
            }
            else
            {
               this._isLeftDrawerOpen = roundToNearest(this._content.x,this._leftDrawer.width) != 0;
            }
            this.openOrCloseLeftDrawer();
         }
      }
      
      protected function handleDragMove() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:* = 0;
         var _loc6_:* = 0;
         if(this.isLeftDrawerDocked)
         {
            _loc1_ = Number(this._leftDrawer.width);
            if(this._leftDrawerDivider !== null)
            {
               _loc1_ += this._leftDrawerDivider.width;
            }
         }
         if(this.isTopDrawerDocked)
         {
            _loc6_ = Number(this._topDrawer.height);
            if(this._topDrawerDivider !== null)
            {
               _loc6_ += this._topDrawerDivider.height;
            }
         }
         if(this._isDraggingLeftDrawer)
         {
            _loc3_ = Number(this._leftDrawer.width);
            if(this.isLeftDrawerOpen)
            {
               _loc1_ = _loc3_ + this._currentTouchX - this._startTouchX;
            }
            else
            {
               _loc1_ = this._currentTouchX - this._startTouchX;
            }
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            if(_loc1_ > _loc3_)
            {
               _loc1_ = _loc3_;
            }
         }
         else if(this._isDraggingRightDrawer)
         {
            _loc4_ = Number(this._rightDrawer.width);
            if(this.isRightDrawerOpen)
            {
               _loc1_ = -_loc4_ + this._currentTouchX - this._startTouchX;
            }
            else
            {
               _loc1_ = this._currentTouchX - this._startTouchX;
            }
            if(_loc1_ < -_loc4_)
            {
               _loc1_ = -_loc4_;
            }
            if(_loc1_ > 0)
            {
               _loc1_ = 0;
            }
            if(this.isLeftDrawerDocked && this._openMode === "below")
            {
               _loc1_ += this._leftDrawer.width;
               if(this._leftDrawerDivider !== null)
               {
                  _loc1_ += this._leftDrawerDivider.width;
               }
            }
         }
         else if(this._isDraggingTopDrawer)
         {
            _loc2_ = Number(this._topDrawer.height);
            if(this.isTopDrawerOpen)
            {
               _loc6_ = _loc2_ + this._currentTouchY - this._startTouchY;
            }
            else
            {
               _loc6_ = this._currentTouchY - this._startTouchY;
            }
            if(_loc6_ < 0)
            {
               _loc6_ = 0;
            }
            if(_loc6_ > _loc2_)
            {
               _loc6_ = _loc2_;
            }
         }
         else if(this._isDraggingBottomDrawer)
         {
            _loc5_ = Number(this._bottomDrawer.height);
            if(this.isBottomDrawerOpen)
            {
               _loc6_ = -_loc5_ + this._currentTouchY - this._startTouchY;
            }
            else
            {
               _loc6_ = this._currentTouchY - this._startTouchY;
            }
            if(_loc6_ < -_loc5_)
            {
               _loc6_ = -_loc5_;
            }
            if(_loc6_ > 0)
            {
               _loc6_ = 0;
            }
            if(this.isTopDrawerDocked && this._openMode === "below")
            {
               _loc6_ += this._topDrawer.height;
               if(this._topDrawerDivider !== null)
               {
                  _loc6_ += this._topDrawerDivider.height;
               }
            }
         }
         if(this._openMode === "above")
         {
            if(this._isDraggingTopDrawer)
            {
               this._topDrawer.y = _loc6_ - this._topDrawer.height;
            }
            else if(this._isDraggingRightDrawer)
            {
               this._rightDrawer.x = this.actualWidth + _loc1_;
            }
            else if(this._isDraggingBottomDrawer)
            {
               this._bottomDrawer.y = this.actualHeight + _loc6_;
            }
            else if(this._isDraggingLeftDrawer)
            {
               this._leftDrawer.x = _loc1_ - this._leftDrawer.width;
            }
         }
         else
         {
            this._content.x = _loc1_;
            this._content.y = _loc6_;
         }
         if(this._isDraggingTopDrawer)
         {
            this.topDrawerOpenOrCloseTween_onUpdate();
         }
         else if(this._isDraggingRightDrawer)
         {
            this.rightDrawerOpenOrCloseTween_onUpdate();
         }
         else if(this._isDraggingBottomDrawer)
         {
            this.bottomDrawerOpenOrCloseTween_onUpdate();
         }
         else if(this._isDraggingLeftDrawer)
         {
            this.leftDrawerOpenOrCloseTween_onUpdate();
         }
      }
      
      protected function checkForDragToClose() : void
      {
         var _loc1_:ExclusiveTouch = null;
         var _loc2_:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         var _loc3_:Number = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         if(this.isLeftDrawerOpen && _loc2_ <= -this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingLeftDrawer = true;
            this.prepareLeftDrawer();
         }
         else if(this.isRightDrawerOpen && _loc2_ >= this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingRightDrawer = true;
            this.prepareRightDrawer();
         }
         else if(this.isTopDrawerOpen && _loc3_ <= -this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingTopDrawer = true;
            this.prepareTopDrawer();
         }
         else if(this.isBottomDrawerOpen && _loc3_ >= this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingBottomDrawer = true;
            this.prepareBottomDrawer();
         }
         if(this._isDragging)
         {
            if(this._overlaySkin)
            {
               this._overlaySkin.visible = true;
               this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
            }
            this._startTouchX = this._currentTouchX;
            this._startTouchY = this._currentTouchY;
            _loc1_ = ExclusiveTouch.forStage(this.stage);
            _loc1_.removeEventListener("change",exclusiveTouch_changeHandler);
            _loc1_.claimTouch(this.touchPointID,this);
            this.dispatchEventWith("beginInteraction");
         }
      }
      
      protected function checkForDragToOpen() : void
      {
         var _loc1_:ExclusiveTouch = null;
         var _loc2_:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         var _loc3_:Number = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
         if(this._leftDrawer && !this.isLeftDrawerDocked && _loc2_ >= this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingLeftDrawer = true;
            this.prepareLeftDrawer();
         }
         else if(this._rightDrawer && !this.isRightDrawerDocked && _loc2_ <= -this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingRightDrawer = true;
            this.prepareRightDrawer();
         }
         else if(this._topDrawer && !this.isTopDrawerDocked && _loc3_ >= this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingTopDrawer = true;
            this.prepareTopDrawer();
         }
         else if(this._bottomDrawer && !this.isBottomDrawerDocked && _loc3_ <= -this._minimumDragDistance)
         {
            this._isDragging = true;
            this._isDraggingBottomDrawer = true;
            this.prepareBottomDrawer();
         }
         if(this._isDragging)
         {
            if(this._overlaySkin)
            {
               this._overlaySkin.visible = true;
               this._overlaySkin.alpha = 0;
            }
            this._startTouchX = this._currentTouchX;
            this._startTouchY = this._currentTouchY;
            _loc1_ = ExclusiveTouch.forStage(this.stage);
            _loc1_.claimTouch(this.touchPointID,this);
            _loc1_.removeEventListener("change",exclusiveTouch_changeHandler);
            this.dispatchEventWith("beginInteraction");
         }
      }
      
      protected function positionOverlaySkin() : void
      {
         if(!this._overlaySkin)
         {
            return;
         }
         if(this.isLeftDrawerDocked)
         {
            this._overlaySkin.x = this._leftDrawer.x;
         }
         else if(this._openMode === "above" && this._leftDrawer)
         {
            this._overlaySkin.x = this._leftDrawer.x + this._leftDrawer.width;
         }
         else
         {
            this._overlaySkin.x = this._content.x;
         }
         if(this.isTopDrawerDocked)
         {
            this._overlaySkin.y = this._topDrawer.y;
         }
         else if(this._openMode === "above" && this._topDrawer)
         {
            this._overlaySkin.y = this._topDrawer.y + this._topDrawer.height;
         }
         else
         {
            this._overlaySkin.y = this._content.y;
         }
      }
      
      protected function topDrawerOpenOrCloseTween_onUpdate() : void
      {
         var _loc1_:Number = NaN;
         if(this._overlaySkin)
         {
            if(this._openMode === "above")
            {
               _loc1_ = 1 + this._topDrawer.y / this._topDrawer.height;
            }
            else
            {
               _loc1_ = this._content.y / this._topDrawer.height;
            }
            this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * _loc1_;
         }
         this.openOrCloseTween_onUpdate();
      }
      
      protected function rightDrawerOpenOrCloseTween_onUpdate() : void
      {
         var _loc1_:Number = NaN;
         if(this._overlaySkin)
         {
            if(this._openMode === "above")
            {
               _loc1_ = -(this._rightDrawer.x - this.actualWidth) / this._rightDrawer.width;
            }
            else
            {
               _loc1_ = (this.actualWidth - this._content.x - this._content.width) / this._rightDrawer.width;
            }
            this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * _loc1_;
         }
         this.openOrCloseTween_onUpdate();
      }
      
      protected function bottomDrawerOpenOrCloseTween_onUpdate() : void
      {
         var _loc1_:Number = NaN;
         if(this._overlaySkin)
         {
            if(this._openMode === "above")
            {
               _loc1_ = -(this._bottomDrawer.y - this.actualHeight) / this._bottomDrawer.height;
            }
            else
            {
               _loc1_ = (this.actualHeight - this._content.y - this._content.height) / this._bottomDrawer.height;
            }
            this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * _loc1_;
         }
         this.openOrCloseTween_onUpdate();
      }
      
      protected function leftDrawerOpenOrCloseTween_onUpdate() : void
      {
         var _loc1_:Number = NaN;
         if(this._overlaySkin)
         {
            if(this._openMode === "above")
            {
               _loc1_ = 1 + this._leftDrawer.x / this._leftDrawer.width;
            }
            else
            {
               _loc1_ = this._content.x / this._leftDrawer.width;
            }
            this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * _loc1_;
         }
         this.openOrCloseTween_onUpdate();
      }
      
      protected function openOrCloseTween_onUpdate() : void
      {
         var _loc5_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc1_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc10_:Quad = null;
         var _loc4_:Number = NaN;
         var _loc8_:Number = NaN;
         if(this._clipDrawers && this._openMode === "below")
         {
            _loc5_ = this.isTopDrawerDocked;
            _loc3_ = this.isRightDrawerDocked;
            _loc7_ = this.isBottomDrawerDocked;
            _loc6_ = this.isLeftDrawerDocked;
            _loc1_ = Number(this._content.x);
            _loc9_ = Number(this._content.y);
            if(_loc5_)
            {
               if(_loc6_)
               {
                  _loc2_ = Number(this._leftDrawer.width);
                  if(this._leftDrawerDivider !== null)
                  {
                     _loc2_ += this._leftDrawerDivider.width;
                  }
                  this._topDrawer.x = _loc1_ - _loc2_;
               }
               else
               {
                  this._topDrawer.x = _loc1_;
               }
               if(this._topDrawerDivider !== null)
               {
                  this._topDrawerDivider.x = this._topDrawer.x;
                  this._topDrawerDivider.y = _loc9_ - this._topDrawerDivider.height;
                  this._topDrawer.y = this._topDrawerDivider.y - this._topDrawer.height;
               }
               else
               {
                  this._topDrawer.y = _loc9_ - this._topDrawer.height;
               }
            }
            if(_loc3_)
            {
               if(this._rightDrawerDivider !== null)
               {
                  this._rightDrawerDivider.x = _loc1_ + this._content.width;
                  this._rightDrawer.x = this._rightDrawerDivider.x + this._rightDrawerDivider.width;
                  this._rightDrawerDivider.y = _loc9_;
               }
               else
               {
                  this._rightDrawer.x = _loc1_ + this._content.width;
               }
               this._rightDrawer.y = _loc9_;
            }
            if(_loc7_)
            {
               if(_loc6_)
               {
                  _loc2_ = Number(this._leftDrawer.width);
                  if(this._leftDrawerDivider !== null)
                  {
                     _loc2_ += this._leftDrawerDivider.width;
                  }
                  this._bottomDrawer.x = _loc1_ - _loc2_;
               }
               else
               {
                  this._bottomDrawer.x = _loc1_;
               }
               if(this._bottomDrawerDivider !== null)
               {
                  this._bottomDrawerDivider.x = this._bottomDrawer.x;
                  this._bottomDrawerDivider.y = _loc9_ + this._content.height;
                  this._bottomDrawer.y = this._bottomDrawerDivider.y + this._bottomDrawerDivider.height;
               }
               else
               {
                  this._bottomDrawer.y = _loc9_ + this._content.height;
               }
            }
            if(_loc6_)
            {
               if(this._leftDrawerDivider !== null)
               {
                  this._leftDrawerDivider.x = _loc1_ - this._leftDrawerDivider.width;
                  this._leftDrawer.x = this._leftDrawerDivider.x - this._leftDrawer.width;
                  this._leftDrawerDivider.y = _loc9_;
               }
               else
               {
                  this._leftDrawer.x = _loc1_ - this._leftDrawer.width;
               }
               this._leftDrawer.y = _loc9_;
            }
            if(this._topDrawer !== null)
            {
               if((_loc10_ = this._topDrawer.mask as Quad) !== null)
               {
                  _loc10_.height = _loc9_;
               }
            }
            if(this._rightDrawer !== null)
            {
               if((_loc10_ = this._rightDrawer.mask as Quad) !== null)
               {
                  _loc4_ = -_loc1_;
                  if(_loc6_)
                  {
                     _loc4_ = -this._leftDrawer.x;
                  }
                  _loc10_.x = this._rightDrawer.width - _loc4_;
                  _loc10_.width = _loc4_;
               }
            }
            if(this._bottomDrawer !== null)
            {
               if((_loc10_ = this._bottomDrawer.mask as Quad) !== null)
               {
                  _loc8_ = -_loc9_;
                  if(_loc5_)
                  {
                     _loc8_ = -this._topDrawer.y;
                  }
                  _loc10_.y = this._bottomDrawer.height - _loc8_;
                  _loc10_.height = _loc8_;
               }
            }
            if(this._leftDrawer !== null)
            {
               if((_loc10_ = this._leftDrawer.mask as Quad) !== null)
               {
                  _loc10_.width = _loc1_;
               }
            }
         }
         if(this._overlaySkin !== null)
         {
            this.positionOverlaySkin();
         }
      }
      
      protected function topDrawerOpenOrCloseTween_onComplete() : void
      {
         if(this._overlaySkin)
         {
            this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
         }
         this._openOrCloseTween = null;
         this._topDrawer.mask = null;
         var _loc2_:Boolean = this.isTopDrawerOpen;
         var _loc1_:Boolean = this.isTopDrawerDocked;
         this._topDrawer.visible = _loc2_ || _loc1_;
         if(this._overlaySkin)
         {
            this._overlaySkin.visible = _loc2_;
         }
         if(_loc2_)
         {
            this.dispatchEventWith("open",false,this._topDrawer);
         }
         else
         {
            this.dispatchEventWith("close",false,this._topDrawer);
         }
      }
      
      protected function rightDrawerOpenOrCloseTween_onComplete() : void
      {
         this._openOrCloseTween = null;
         this._rightDrawer.mask = null;
         var _loc2_:Boolean = this.isRightDrawerOpen;
         var _loc1_:Boolean = this.isRightDrawerDocked;
         this._rightDrawer.visible = _loc2_ || _loc1_;
         if(this._overlaySkin)
         {
            this._overlaySkin.visible = _loc2_;
         }
         if(_loc2_)
         {
            this.dispatchEventWith("open",false,this._rightDrawer);
         }
         else
         {
            this.dispatchEventWith("close",false,this._rightDrawer);
         }
      }
      
      protected function bottomDrawerOpenOrCloseTween_onComplete() : void
      {
         this._openOrCloseTween = null;
         this._bottomDrawer.mask = null;
         var _loc1_:Boolean = this.isBottomDrawerOpen;
         var _loc2_:Boolean = this.isBottomDrawerDocked;
         this._bottomDrawer.visible = _loc1_ || _loc2_;
         if(this._overlaySkin)
         {
            this._overlaySkin.visible = _loc1_;
         }
         if(_loc1_)
         {
            this.dispatchEventWith("open",false,this._bottomDrawer);
         }
         else
         {
            this.dispatchEventWith("close",false,this._bottomDrawer);
         }
      }
      
      protected function leftDrawerOpenOrCloseTween_onComplete() : void
      {
         this._openOrCloseTween = null;
         this._leftDrawer.mask = null;
         var _loc1_:Boolean = this.isLeftDrawerOpen;
         var _loc2_:Boolean = this.isLeftDrawerDocked;
         this._leftDrawer.visible = _loc1_ || _loc2_;
         if(this._overlaySkin)
         {
            this._overlaySkin.visible = _loc1_;
         }
         if(_loc1_)
         {
            this.dispatchEventWith("open",false,this._leftDrawer);
         }
         else
         {
            this.dispatchEventWith("close",false,this._leftDrawer);
         }
      }
      
      protected function content_eventDispatcherChangeHandler(param1:Event) : void
      {
         this.refreshCurrentEventTarget();
      }
      
      protected function drawers_addedToStageHandler(param1:Event) : void
      {
         this.stage.addEventListener("resize",stage_resizeHandler);
         var _loc2_:int = -getDisplayObjectDepthFromStage(this);
         Starling.current.nativeStage.addEventListener("keyDown",drawers_nativeStage_keyDownHandler,false,_loc2_,true);
      }
      
      protected function drawers_removedFromStageHandler(param1:Event) : void
      {
         var _loc2_:ExclusiveTouch = null;
         if(this.touchPointID >= 0)
         {
            _loc2_ = ExclusiveTouch.forStage(this.stage);
            _loc2_.removeEventListener("change",exclusiveTouch_changeHandler);
         }
         this.touchPointID = -1;
         this._isDragging = false;
         this._isDraggingTopDrawer = false;
         this._isDraggingRightDrawer = false;
         this._isDraggingBottomDrawer = false;
         this._isDraggingLeftDrawer = false;
         this.stage.removeEventListener("resize",stage_resizeHandler);
         Starling.current.nativeStage.removeEventListener("keyDown",drawers_nativeStage_keyDownHandler);
      }
      
      protected function drawers_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled || this._openOrCloseTween)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this,null,this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            if(_loc2_.phase == "moved")
            {
               this.handleTouchMoved(_loc2_);
               if(!this._isDragging)
               {
                  if(this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen)
                  {
                     this.checkForDragToClose();
                  }
                  else
                  {
                     this.checkForDragToOpen();
                  }
               }
               if(this._isDragging)
               {
                  this.handleDragMove();
               }
            }
            else if(_loc2_.phase == "ended")
            {
               this.touchPointID = -1;
               if(this._isDragging)
               {
                  this.handleDragEnd();
                  this.dispatchEventWith("endInteraction");
               }
               else
               {
                  ExclusiveTouch.forStage(this.stage).removeEventListener("change",exclusiveTouch_changeHandler);
                  if(this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen)
                  {
                     this.handleTapToClose(_loc2_);
                  }
               }
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this,"began");
            if(!_loc2_)
            {
               return;
            }
            this.handleTouchBegan(_loc2_);
         }
      }
      
      protected function exclusiveTouch_changeHandler(param1:Event, param2:int) : void
      {
         if(this.touchPointID < 0 || this.touchPointID != param2 || this._isDragging)
         {
            return;
         }
         var _loc3_:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
         if(_loc3_.getClaim(param2) == this)
         {
            return;
         }
         this.touchPointID = -1;
      }
      
      protected function stage_resizeHandler(param1:ResizeEvent) : void
      {
         this.invalidate("size");
      }
      
      protected function drawers_nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:Boolean = false;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(param1.keyCode == 16777238)
         {
            _loc2_ = false;
            if(this.isTopDrawerOpen)
            {
               this.toggleTopDrawer();
               _loc2_ = true;
            }
            else if(this.isRightDrawerOpen)
            {
               this.toggleRightDrawer();
               _loc2_ = true;
            }
            else if(this.isBottomDrawerOpen)
            {
               this.toggleBottomDrawer();
               _loc2_ = true;
            }
            else if(this.isLeftDrawerOpen)
            {
               this.toggleLeftDrawer();
               _loc2_ = true;
            }
            if(_loc2_)
            {
               param1.preventDefault();
            }
         }
      }
      
      protected function content_topDrawerToggleEventTypeHandler(param1:Event) : void
      {
         if(!this._topDrawer || this.isTopDrawerDocked)
         {
            return;
         }
         this._isTopDrawerOpen = !this._isTopDrawerOpen;
         this.openOrCloseTopDrawer();
      }
      
      protected function content_rightDrawerToggleEventTypeHandler(param1:Event) : void
      {
         if(!this._rightDrawer || this.isRightDrawerDocked)
         {
            return;
         }
         this._isRightDrawerOpen = !this._isRightDrawerOpen;
         this.openOrCloseRightDrawer();
      }
      
      protected function content_bottomDrawerToggleEventTypeHandler(param1:Event) : void
      {
         if(!this._bottomDrawer || this.isBottomDrawerDocked)
         {
            return;
         }
         this._isBottomDrawerOpen = !this._isBottomDrawerOpen;
         this.openOrCloseBottomDrawer();
      }
      
      protected function content_leftDrawerToggleEventTypeHandler(param1:Event) : void
      {
         if(!this._leftDrawer || this.isLeftDrawerDocked)
         {
            return;
         }
         this._isLeftDrawerOpen = !this._isLeftDrawerOpen;
         this.openOrCloseLeftDrawer();
      }
      
      protected function content_resizeHandler(param1:Event) : void
      {
         if(this._isValidating || this._autoSizeMode != "content")
         {
            return;
         }
         this.invalidate("size");
      }
      
      protected function drawer_resizeHandler(param1:Event) : void
      {
         if(this._isValidating)
         {
            return;
         }
         this.invalidate("size");
      }
   }
}
