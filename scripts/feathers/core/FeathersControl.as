package feathers.core
{
   import feathers.controls.text.BitmapFontTextRenderer;
   import feathers.controls.text.StageTextTextEditor;
   import feathers.layout.ILayoutData;
   import feathers.layout.ILayoutDisplayObject;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import feathers.utils.display.stageToStarling;
   import flash.errors.IllegalOperationError;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.utils.MatrixUtil;
   
   public class FeathersControl extends Sprite implements IFeathersControl, ILayoutDisplayObject
   {
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
      
      public static const INVALIDATION_FLAG_ALL:String = "all";
      
      public static const INVALIDATION_FLAG_STATE:String = "state";
      
      public static const INVALIDATION_FLAG_SIZE:String = "size";
      
      public static const INVALIDATION_FLAG_STYLES:String = "styles";
      
      public static const INVALIDATION_FLAG_SKIN:String = "skin";
      
      public static const INVALIDATION_FLAG_LAYOUT:String = "layout";
      
      public static const INVALIDATION_FLAG_DATA:String = "data";
      
      public static const INVALIDATION_FLAG_SCROLL:String = "scroll";
      
      public static const INVALIDATION_FLAG_SELECTED:String = "selected";
      
      public static const INVALIDATION_FLAG_FOCUS:String = "focus";
      
      protected static const INVALIDATION_FLAG_TEXT_RENDERER:String = "textRenderer";
      
      protected static const INVALIDATION_FLAG_TEXT_EDITOR:String = "textEditor";
      
      protected static const ILLEGAL_WIDTH_ERROR:String = "A component\'s width cannot be NaN.";
      
      protected static const ILLEGAL_HEIGHT_ERROR:String = "A component\'s height cannot be NaN.";
      
      protected static const ABSTRACT_CLASS_ERROR:String = "FeathersControl is an abstract class. For a lightweight Feathers wrapper, use feathers.controls.LayoutGroup.";
      
      public static function defaultTextRendererFactory():ITextRenderer
      {
         return new BitmapFontTextRenderer();
      }
      public static function defaultTextEditorFactory():ITextEditor
      {
         return new StageTextTextEditor();
      } 
      
      protected var _validationQueue:ValidationQueue;
      
      protected var _styleNameList:TokenList;
      
      protected var _styleProvider:IStyleProvider;
      
      protected var _isQuickHitAreaEnabled:Boolean = false;
      
      protected var _hitArea:Rectangle;
      
      protected var _isInitializing:Boolean = false;
      
      protected var _isInitialized:Boolean = false;
      
      protected var _isAllInvalid:Boolean = false;
      
      protected var _invalidationFlags:Object;
      
      protected var _delayedInvalidationFlags:Object;
      
      protected var _isEnabled:Boolean = true;
      
      protected var _explicitWidth:Number = NaN;
      
      protected var actualWidth:Number = 0;
      
      protected var scaledActualWidth:Number = 0;
      
      protected var _explicitHeight:Number = NaN;
      
      protected var actualHeight:Number = 0;
      
      protected var scaledActualHeight:Number = 0;
      
      protected var _minTouchWidth:Number = 0;
      
      protected var _minTouchHeight:Number = 0;
      
      protected var _explicitMinWidth:Number = NaN;
      
      protected var actualMinWidth:Number = 0;
      
      protected var scaledActualMinWidth:Number = 0;
      
      protected var _explicitMinHeight:Number = NaN;
      
      protected var actualMinHeight:Number = 0;
      
      protected var scaledActualMinHeight:Number = 0;
      
      protected var _explicitMaxWidth:Number = Infinity;
      
      protected var _explicitMaxHeight:Number = Infinity;
      
      protected var _includeInLayout:Boolean = true;
      
      protected var _layoutData:ILayoutData;
      
      protected var _toolTip:String;
      
      protected var _focusManager:IFocusManager;
      
      protected var _focusOwner:IFocusDisplayObject;
      
      protected var _isFocusEnabled:Boolean = true;
      
      protected var _nextTabFocus:IFocusDisplayObject;
      
      protected var _previousTabFocus:IFocusDisplayObject;
      
      protected var _focusIndicatorSkin:DisplayObject;
      
      protected var _focusPaddingTop:Number = 0;
      
      protected var _focusPaddingRight:Number = 0;
      
      protected var _focusPaddingBottom:Number = 0;
      
      protected var _focusPaddingLeft:Number = 0;
      
      protected var _hasFocus:Boolean = false;
      
      protected var _showFocus:Boolean = false;
      
      protected var _isValidating:Boolean = false;
      
      protected var _hasValidated:Boolean = false;
      
      protected var _depth:int = -1;
      
      protected var _invalidateCount:int = 0;
      
      protected var _isDisposed:Boolean = false;
      
      public function FeathersControl()
      {
         _styleNameList = new TokenList();
         _hitArea = new Rectangle();
         _invalidationFlags = {};
         _delayedInvalidationFlags = {};
         super();
         if(Object(this).constructor == FeathersControl)
         {
            throw new Error("FeathersControl is an abstract class. For a lightweight Feathers wrapper, use feathers.controls.LayoutGroup.");
         }
         this._styleProvider = this.defaultStyleProvider;
         this.addEventListener("addedToStage",feathersControl_addedToStageHandler);
         this.addEventListener("removedFromStage",feathersControl_removedFromStageHandler);
      }
      
      public function get styleName() : String
      {
         return this._styleNameList.value;
      }
      
      public function set styleName(param1:String) : void
      {
         this._styleNameList.value = param1;
      }
      
      public function get styleNameList() : TokenList
      {
         return this._styleNameList;
      }
      
      public function get styleProvider() : IStyleProvider
      {
         return this._styleProvider;
      }
      
      public function set styleProvider(param1:IStyleProvider) : void
      {
         this._styleProvider = param1;
         if(this._styleProvider && this.isInitialized)
         {
            this._styleProvider.applyStyles(this);
         }
      }
      
      protected function get defaultStyleProvider() : IStyleProvider
      {
         return null;
      }
      
      public function get isQuickHitAreaEnabled() : Boolean
      {
         return this._isQuickHitAreaEnabled;
      }
      
      public function set isQuickHitAreaEnabled(param1:Boolean) : void
      {
         this._isQuickHitAreaEnabled = param1;
      }
      
      public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      public function get isEnabled() : Boolean
      {
         return _isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         if(this._isEnabled == param1)
         {
            return;
         }
         this._isEnabled = param1;
         this.invalidate("state");
      }
      
      public function get explicitWidth() : Number
      {
         return this._explicitWidth;
      }
      
      override public function get width() : Number
      {
         return this.scaledActualWidth;
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = param1 !== param1;
         if(_loc3_ && this._explicitWidth !== this._explicitWidth)
         {
            return;
         }
         if(this.scaleX !== 1)
         {
            param1 /= this.scaleX;
         }
         if(this._explicitWidth == param1)
         {
            return;
         }
         this._explicitWidth = param1;
         if(_loc3_)
         {
            this.actualWidth = this.scaledActualWidth = 0;
            this.invalidate("size");
         }
         else
         {
            _loc2_ = this.saveMeasurements(param1,this.actualHeight,this.actualMinWidth,this.actualMinHeight);
            if(_loc2_)
            {
               this.invalidate("size");
            }
         }
      }
      
      public function get explicitHeight() : Number
      {
         return this._explicitHeight;
      }
      
      override public function get height() : Number
      {
         return this.scaledActualHeight;
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = param1 !== param1;
         if(_loc3_ && this._explicitHeight !== this._explicitHeight)
         {
            return;
         }
         if(this.scaleY !== 1)
         {
            param1 /= this.scaleY;
         }
         if(this._explicitHeight == param1)
         {
            return;
         }
         this._explicitHeight = param1;
         if(_loc3_)
         {
            this.actualHeight = this.scaledActualHeight = 0;
            this.invalidate("size");
         }
         else
         {
            _loc2_ = this.saveMeasurements(this.actualWidth,param1,this.actualMinWidth,this.actualMinHeight);
            if(_loc2_)
            {
               this.invalidate("size");
            }
         }
      }
      
      public function get minTouchWidth() : Number
      {
         return this._minTouchWidth;
      }
      
      public function set minTouchWidth(param1:Number) : void
      {
         if(this._minTouchWidth == param1)
         {
            return;
         }
         this._minTouchWidth = param1;
         this.refreshHitAreaX();
      }
      
      public function get minTouchHeight() : Number
      {
         return this._minTouchHeight;
      }
      
      public function set minTouchHeight(param1:Number) : void
      {
         if(this._minTouchHeight == param1)
         {
            return;
         }
         this._minTouchHeight = param1;
         this.refreshHitAreaY();
      }
      
      public function get explicitMinWidth() : Number
      {
         return this._explicitMinWidth;
      }
      
      public function get minWidth() : Number
      {
         return this.scaledActualMinWidth;
      }
      
      public function set minWidth(param1:Number) : void
      {
         var _loc2_:* = param1 !== param1;
         if(_loc2_ && this._explicitMinWidth !== this._explicitMinWidth)
         {
            return;
         }
         if(this.scaleX !== 1)
         {
            param1 /= this.scaleX;
         }
         if(this._explicitMinWidth == param1)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinWidth;
         this._explicitMinWidth = param1;
         if(_loc2_)
         {
            this.actualMinWidth = this.scaledActualMinWidth = 0;
            this.invalidate("size");
         }
         else
         {
            this.saveMeasurements(this.actualWidth,this.actualHeight,param1,this.actualMinHeight);
            if(this._explicitWidth !== this._explicitWidth && (this.actualWidth < param1 || this.actualWidth === _loc3_))
            {
               this.invalidate("size");
            }
         }
      }
      
      public function get explicitMinHeight() : Number
      {
         return this._explicitMinHeight;
      }
      
      public function get minHeight() : Number
      {
         return this.scaledActualMinHeight;
      }
      
      public function set minHeight(param1:Number) : void
      {
         var _loc2_:* = param1 !== param1;
         if(_loc2_ && this._explicitMinHeight !== this._explicitMinHeight)
         {
            return;
         }
         if(this.scaleY !== 1)
         {
            param1 /= this.scaleY;
         }
         if(this._explicitMinHeight == param1)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinHeight;
         this._explicitMinHeight = param1;
         if(_loc2_)
         {
            this.actualMinHeight = this.scaledActualMinHeight = 0;
            this.invalidate("size");
         }
         else
         {
            this.saveMeasurements(this.actualWidth,this.actualHeight,this.actualMinWidth,param1);
            if(this._explicitHeight !== this._explicitHeight && (this.actualHeight < param1 || this.actualHeight === _loc3_))
            {
               this.invalidate("size");
            }
         }
      }
      
      public function get explicitMaxWidth() : Number
      {
         return this._explicitMaxWidth;
      }
      
      public function get maxWidth() : Number
      {
         return this._explicitMaxWidth;
      }
      
      public function set maxWidth(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(this._explicitMaxWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxWidth cannot be NaN");
         }
         var _loc2_:Number = this._explicitMaxWidth;
         this._explicitMaxWidth = param1;
         if(this._explicitWidth !== this._explicitWidth && (this.actualWidth > param1 || this.actualWidth === _loc2_))
         {
            this.invalidate("size");
         }
      }
      
      public function get explicitMaxHeight() : Number
      {
         return this._explicitMaxHeight;
      }
      
      public function get maxHeight() : Number
      {
         return this._explicitMaxHeight;
      }
      
      public function set maxHeight(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(this._explicitMaxHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxHeight cannot be NaN");
         }
         var _loc2_:Number = this._explicitMaxHeight;
         this._explicitMaxHeight = param1;
         if(this._explicitHeight !== this._explicitHeight && (this.actualHeight > param1 || this.actualHeight === _loc2_))
         {
            this.invalidate("size");
         }
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         this.saveMeasurements(this.actualWidth,this.actualHeight,this.actualMinWidth,this.actualMinHeight);
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         this.saveMeasurements(this.actualWidth,this.actualHeight,this.actualMinWidth,this.actualMinHeight);
      }
      
      public function get includeInLayout() : Boolean
      {
         return this._includeInLayout;
      }
      
      public function set includeInLayout(param1:Boolean) : void
      {
         if(this._includeInLayout == param1)
         {
            return;
         }
         this._includeInLayout = param1;
         this.dispatchEventWith("layoutDataChange");
      }
      
      public function get layoutData() : ILayoutData
      {
         return this._layoutData;
      }
      
      public function set layoutData(param1:ILayoutData) : void
      {
         if(this._layoutData == param1)
         {
            return;
         }
         if(this._layoutData)
         {
            this._layoutData.removeEventListener("change",layoutData_changeHandler);
         }
         this._layoutData = param1;
         if(this._layoutData)
         {
            this._layoutData.addEventListener("change",layoutData_changeHandler);
         }
         this.dispatchEventWith("layoutDataChange");
      }
      
      public function get toolTip() : String
      {
         return this._toolTip;
      }
      
      public function set toolTip(param1:String) : void
      {
         this._toolTip = param1;
      }
      
      public function get focusManager() : IFocusManager
      {
         return this._focusManager;
      }
      
      public function set focusManager(param1:IFocusManager) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot pass a focus manager to a component that does not implement feathers.core.IFocusDisplayObject");
         }
         if(this._focusManager == param1)
         {
            return;
         }
         this._focusManager = param1;
         if(this._focusManager)
         {
            this.addEventListener("focusIn",focusInHandler);
            this.addEventListener("focusOut",focusOutHandler);
         }
         else
         {
            this.removeEventListener("focusIn",focusInHandler);
            this.removeEventListener("focusOut",focusOutHandler);
         }
      }
      
      public function get focusOwner() : IFocusDisplayObject
      {
         return this._focusOwner;
      }
      
      public function set focusOwner(param1:IFocusDisplayObject) : void
      {
         this._focusOwner = param1;
      }
      
      public function get isFocusEnabled() : Boolean
      {
         return this._isEnabled && this._isFocusEnabled;
      }
      
      public function set isFocusEnabled(param1:Boolean) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot enable focus on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         if(this._isFocusEnabled == param1)
         {
            return;
         }
         this._isFocusEnabled = param1;
      }
      
      public function get nextTabFocus() : IFocusDisplayObject
      {
         return this._nextTabFocus;
      }
      
      public function set nextTabFocus(param1:IFocusDisplayObject) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot set next tab focus on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         this._nextTabFocus = param1;
      }
      
      public function get previousTabFocus() : IFocusDisplayObject
      {
         return this._previousTabFocus;
      }
      
      public function set previousTabFocus(param1:IFocusDisplayObject) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot set previous tab focus on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         this._previousTabFocus = param1;
      }
      
      public function get focusIndicatorSkin() : DisplayObject
      {
         return this._focusIndicatorSkin;
      }
      
      public function set focusIndicatorSkin(param1:DisplayObject) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot set focus indicator skin on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         if(this._focusIndicatorSkin == param1)
         {
            return;
         }
         if(this._focusIndicatorSkin)
         {
            if(this._focusIndicatorSkin.parent == this)
            {
               this._focusIndicatorSkin.removeFromParent(false);
            }
            if(this._focusIndicatorSkin is IStateObserver && this is IStateContext)
            {
               IStateObserver(this._focusIndicatorSkin).stateContext = null;
            }
         }
         this._focusIndicatorSkin = param1;
         if(this._focusIndicatorSkin)
         {
            this._focusIndicatorSkin.touchable = false;
         }
         if(this._focusIndicatorSkin is IStateObserver && this is IStateContext)
         {
            IStateObserver(this._focusIndicatorSkin).stateContext = IStateContext(this);
         }
         if(this._focusManager && this._focusManager.focus == this)
         {
            this.invalidate("styles");
         }
      }
      
      public function get focusPadding() : Number
      {
         return this._focusPaddingTop;
      }
      
      public function set focusPadding(param1:Number) : void
      {
         this.focusPaddingTop = param1;
         this.focusPaddingRight = param1;
         this.focusPaddingBottom = param1;
         this.focusPaddingLeft = param1;
      }
      
      public function get focusPaddingTop() : Number
      {
         return this._focusPaddingTop;
      }
      
      public function set focusPaddingTop(param1:Number) : void
      {
         if(this._focusPaddingTop == param1)
         {
            return;
         }
         this._focusPaddingTop = param1;
         this.invalidate("focus");
      }
      
      public function get focusPaddingRight() : Number
      {
         return this._focusPaddingRight;
      }
      
      public function set focusPaddingRight(param1:Number) : void
      {
         if(this._focusPaddingRight == param1)
         {
            return;
         }
         this._focusPaddingRight = param1;
         this.invalidate("focus");
      }
      
      public function get focusPaddingBottom() : Number
      {
         return this._focusPaddingBottom;
      }
      
      public function set focusPaddingBottom(param1:Number) : void
      {
         if(this._focusPaddingBottom == param1)
         {
            return;
         }
         this._focusPaddingBottom = param1;
         this.invalidate("focus");
      }
      
      public function get focusPaddingLeft() : Number
      {
         return this._focusPaddingLeft;
      }
      
      public function set focusPaddingLeft(param1:Number) : void
      {
         if(this._focusPaddingLeft == param1)
         {
            return;
         }
         this._focusPaddingLeft = param1;
         this.invalidate("focus");
      }
      
      public function get isCreated() : Boolean
      {
         return this._hasValidated;
      }
      
      public function get depth() : int
      {
         return this._depth;
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         if(!param2)
         {
            param2 = new Rectangle();
         }
         var _loc4_:Number = 1.7976931348623157e+308;
         var _loc6_:Number = -1.7976931348623157e+308;
         var _loc3_:Number = 1.7976931348623157e+308;
         var _loc5_:Number = -1.7976931348623157e+308;
         if(param1 == this)
         {
            _loc4_ = 0;
            _loc3_ = 0;
            _loc6_ = this.actualWidth;
            _loc5_ = this.actualHeight;
         }
         else
         {
            this.getTransformationMatrix(param1,HELPER_MATRIX);
            MatrixUtil.transformCoords(HELPER_MATRIX,0,0,HELPER_POINT);
            _loc4_ = _loc4_ < HELPER_POINT.x ? _loc4_ : HELPER_POINT.x;
            _loc6_ = _loc6_ > HELPER_POINT.x ? _loc6_ : HELPER_POINT.x;
            _loc3_ = _loc3_ < HELPER_POINT.y ? _loc3_ : HELPER_POINT.y;
            _loc5_ = _loc5_ > HELPER_POINT.y ? _loc5_ : HELPER_POINT.y;
            MatrixUtil.transformCoords(HELPER_MATRIX,0,this.actualHeight,HELPER_POINT);
            _loc4_ = _loc4_ < HELPER_POINT.x ? _loc4_ : HELPER_POINT.x;
            _loc6_ = _loc6_ > HELPER_POINT.x ? _loc6_ : HELPER_POINT.x;
            _loc3_ = _loc3_ < HELPER_POINT.y ? _loc3_ : HELPER_POINT.y;
            _loc5_ = _loc5_ > HELPER_POINT.y ? _loc5_ : HELPER_POINT.y;
            MatrixUtil.transformCoords(HELPER_MATRIX,this.actualWidth,0,HELPER_POINT);
            _loc4_ = _loc4_ < HELPER_POINT.x ? _loc4_ : HELPER_POINT.x;
            _loc6_ = _loc6_ > HELPER_POINT.x ? _loc6_ : HELPER_POINT.x;
            _loc3_ = _loc3_ < HELPER_POINT.y ? _loc3_ : HELPER_POINT.y;
            _loc5_ = _loc5_ > HELPER_POINT.y ? _loc5_ : HELPER_POINT.y;
            MatrixUtil.transformCoords(HELPER_MATRIX,this.actualWidth,this.actualHeight,HELPER_POINT);
            _loc4_ = _loc4_ < HELPER_POINT.x ? _loc4_ : HELPER_POINT.x;
            _loc6_ = _loc6_ > HELPER_POINT.x ? _loc6_ : HELPER_POINT.x;
            _loc3_ = _loc3_ < HELPER_POINT.y ? _loc3_ : HELPER_POINT.y;
            _loc5_ = _loc5_ > HELPER_POINT.y ? _loc5_ : HELPER_POINT.y;
         }
         param2.x = _loc4_;
         param2.y = _loc3_;
         param2.width = _loc6_ - _loc4_;
         param2.height = _loc5_ - _loc3_;
         return param2;
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         if(this._isQuickHitAreaEnabled)
         {
            if(!this.visible || !this.touchable)
            {
               return null;
            }
            if(this.mask && !this.hitTestMask(param1))
            {
               return null;
            }
            return this._hitArea.containsPoint(param1) ? this : null;
         }
         return super.hitTest(param1);
      }
      
      override public function dispose() : void
      {
         this._isDisposed = true;
         this._validationQueue = null;
         super.dispose();
      }
      
      public function invalidate(param1:String = "all") : void
      {
         var _loc4_:Boolean = this.isInvalid();
         var _loc3_:Boolean = false;
         if(this._isValidating)
         {
            var _loc6_:int = 0;
            var _loc5_:* = this._delayedInvalidationFlags;
            for(var _loc2_ in _loc5_)
            {
               _loc3_ = true;
            }
         }
         if(!param1 || param1 == "all")
         {
            if(this._isValidating)
            {
               this._delayedInvalidationFlags["all"] = true;
            }
            else
            {
               this._isAllInvalid = true;
            }
         }
         else if(this._isValidating)
         {
            this._delayedInvalidationFlags[param1] = true;
         }
         else if(param1 != "all" && !this._invalidationFlags.hasOwnProperty(param1))
         {
            this._invalidationFlags[param1] = true;
         }
         if(!this._validationQueue || !this._isInitialized)
         {
            return;
         }
         if(this._isValidating)
         {
            if(_loc3_)
            {
               return;
            }
            this._invalidateCount++;
            this._validationQueue.addControl(this,this._invalidateCount >= 10);
            return;
         }
         if(_loc4_)
         {
            return;
         }
         this._invalidateCount = 0;
         this._validationQueue.addControl(this,false);
      }
      
      public function validate() : void
      {
         if(this._isDisposed)
         {
            return;
         }
         if(!this._isInitialized)
         {
            if(this._isInitializing)
            {
               return;
            }
            this.initializeNow();
         }
         if(!this.isInvalid())
         {
            return;
         }
         if(this._isValidating)
         {
            if(this._validationQueue)
            {
               this._validationQueue.addControl(this,true);
            }
            return;
         }
         this._isValidating = true;
         this.draw();
         for(var _loc1_ in this._invalidationFlags)
         {
            delete this._invalidationFlags[_loc1_];
         }
         this._isAllInvalid = false;
         for(_loc1_ in this._delayedInvalidationFlags)
         {
            if(_loc1_ == "all")
            {
               this._isAllInvalid = true;
            }
            else
            {
               this._invalidationFlags[_loc1_] = true;
            }
            delete this._delayedInvalidationFlags[_loc1_];
         }
         this._isValidating = false;
         if(!this._hasValidated)
         {
            this._hasValidated = true;
            this.dispatchEventWith("creationComplete");
         }
      }
      
      public function isInvalid(param1:String = null) : Boolean
      {
         if(this._isAllInvalid)
         {
            return true;
         }
         if(!param1)
         {
            var _loc3_:int = 0;
            var _loc2_:* = this._invalidationFlags;
            for(param1 in _loc2_)
            {
               return true;
            }
            return false;
         }
         return this._invalidationFlags[param1];
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var _loc3_:Boolean = false;
         this._explicitWidth = param1;
         var _loc4_:*;
         if(_loc4_ = param1 !== param1)
         {
            this.actualWidth = this.scaledActualWidth = 0;
         }
         this._explicitHeight = param2;
         var _loc5_:*;
         if(_loc5_ = param2 !== param2)
         {
            this.actualHeight = this.scaledActualHeight = 0;
         }
         if(_loc4_ || _loc5_)
         {
            this.invalidate("size");
         }
         else
         {
            _loc3_ = this.saveMeasurements(param1,param2,this.actualMinWidth,this.actualMinHeight);
            if(_loc3_)
            {
               this.invalidate("size");
            }
         }
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function resetStyleProvider() : void
      {
         this.styleProvider = this.defaultStyleProvider;
      }
      
      public function showFocus() : void
      {
         if(!this._hasFocus || !this._focusIndicatorSkin)
         {
            return;
         }
         this._showFocus = true;
         this.invalidate("focus");
      }
      
      public function hideFocus() : void
      {
         if(!this._hasFocus || !this._focusIndicatorSkin)
         {
            return;
         }
         this._showFocus = false;
         this.invalidate("focus");
      }
      
      public function initializeNow() : void
      {
         if(this._isInitialized || this._isInitializing)
         {
            return;
         }
         this._isInitializing = true;
         this.initialize();
         this.invalidate();
         this._isInitializing = false;
         this._isInitialized = true;
         this.dispatchEventWith("initialize");
         if(this._styleProvider)
         {
            this._styleProvider.applyStyles(this);
         }
         this._styleNameList.addEventListener("change",styleNameList_changeHandler);
      }
      
      protected function setSizeInternal(param1:Number, param2:Number, param3:Boolean) : Boolean
      {
         var _loc4_:Boolean = this.saveMeasurements(param1,param2,this.actualMinWidth,this.actualMinHeight);
         if(param3 && _loc4_)
         {
            this.invalidate("size");
         }
         return _loc4_;
      }
      
      protected function saveMeasurements(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0) : Boolean
      {
         if(this._explicitMinWidth === this._explicitMinWidth)
         {
            param3 = this._explicitMinWidth;
         }
         if(this._explicitMinHeight === this._explicitMinHeight)
         {
            param4 = this._explicitMinHeight;
         }
         if(this._explicitWidth === this._explicitWidth)
         {
            param1 = this._explicitWidth;
         }
         else if(param1 < param3)
         {
            param1 = param3;
         }
         else if(param1 > this._explicitMaxWidth)
         {
            param1 = this._explicitMaxWidth;
         }
         if(this._explicitHeight === this._explicitHeight)
         {
            param2 = this._explicitHeight;
         }
         else if(param2 < param4)
         {
            param2 = param4;
         }
         else if(param2 > this._explicitMaxHeight)
         {
            param2 = this._explicitMaxHeight;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("A component\'s width cannot be NaN.");
         }
         if(param2 !== param2)
         {
            throw new ArgumentError("A component\'s height cannot be NaN.");
         }
         var _loc5_:Number;
         if((_loc5_ = this.scaleX) < 0)
         {
            _loc5_ = -_loc5_;
         }
         var _loc6_:Number;
         if((_loc6_ = this.scaleY) < 0)
         {
            _loc6_ = -_loc6_;
         }
         var _loc7_:Boolean = false;
         if(this.actualWidth !== param1)
         {
            this.actualWidth = param1;
            this.refreshHitAreaX();
            _loc7_ = true;
         }
         if(this.actualHeight !== param2)
         {
            this.actualHeight = param2;
            this.refreshHitAreaY();
            _loc7_ = true;
         }
         if(this.actualMinWidth !== param3)
         {
            this.actualMinWidth = param3;
            _loc7_ = true;
         }
         if(this.actualMinHeight !== param4)
         {
            this.actualMinHeight = param4;
            _loc7_ = true;
         }
         param1 = this.scaledActualWidth;
         param2 = this.scaledActualHeight;
         this.scaledActualWidth = this.actualWidth * _loc5_;
         this.scaledActualHeight = this.actualHeight * _loc6_;
         this.scaledActualMinWidth = this.actualMinWidth * _loc5_;
         this.scaledActualMinHeight = this.actualMinHeight * _loc6_;
         if(param1 !== this.scaledActualWidth || param2 !== this.scaledActualHeight)
         {
            _loc7_ = true;
            this.dispatchEventWith("resize");
         }
         return _loc7_;
      }
      
      protected function initialize() : void
      {
      }
      
      protected function draw() : void
      {
      }
      
      protected function setInvalidationFlag(param1:String) : void
      {
         if(this._invalidationFlags.hasOwnProperty(param1))
         {
            return;
         }
         this._invalidationFlags[param1] = true;
      }
      
      protected function clearInvalidationFlag(param1:String) : void
      {
         delete this._invalidationFlags[param1];
      }
      
      protected function refreshFocusIndicator() : void
      {
         if(this._focusIndicatorSkin)
         {
            if(this._hasFocus && this._showFocus)
            {
               if(this._focusIndicatorSkin.parent != this)
               {
                  this.addChild(this._focusIndicatorSkin);
               }
               else
               {
                  this.setChildIndex(this._focusIndicatorSkin,this.numChildren - 1);
               }
            }
            else if(this._focusIndicatorSkin.parent)
            {
               this._focusIndicatorSkin.removeFromParent(false);
            }
            this._focusIndicatorSkin.x = this._focusPaddingLeft;
            this._focusIndicatorSkin.y = this._focusPaddingTop;
            this._focusIndicatorSkin.width = this.actualWidth - this._focusPaddingLeft - this._focusPaddingRight;
            this._focusIndicatorSkin.height = this.actualHeight - this._focusPaddingTop - this._focusPaddingBottom;
         }
      }
      
      protected function refreshHitAreaX() : void
      {
         if(this.actualWidth < this._minTouchWidth)
         {
            this._hitArea.width = this._minTouchWidth;
         }
         else
         {
            this._hitArea.width = this.actualWidth;
         }
         var _loc1_:Number = (this.actualWidth - this._hitArea.width) / 2;
         if(_loc1_ !== _loc1_)
         {
            this._hitArea.x = 0;
         }
         else
         {
            this._hitArea.x = _loc1_;
         }
      }
      
      protected function refreshHitAreaY() : void
      {
         if(this.actualHeight < this._minTouchHeight)
         {
            this._hitArea.height = this._minTouchHeight;
         }
         else
         {
            this._hitArea.height = this.actualHeight;
         }
         var _loc1_:Number = (this.actualHeight - this._hitArea.height) / 2;
         if(_loc1_ !== _loc1_)
         {
            this._hitArea.y = 0;
         }
         else
         {
            this._hitArea.y = _loc1_;
         }
      }
      
      protected function focusInHandler(param1:Event) : void
      {
         this._hasFocus = true;
         this.invalidate("focus");
      }
      
      protected function focusOutHandler(param1:Event) : void
      {
         this._hasFocus = false;
         this._showFocus = false;
         this.invalidate("focus");
      }
      
      protected function feathersControl_addedToStageHandler(param1:Event) : void
      {
         this._depth = getDisplayObjectDepthFromStage(this);
         var _loc2_:Starling = stageToStarling(this.stage);
         this._validationQueue = ValidationQueue.forStarling(_loc2_);
         if(!this._isInitialized)
         {
            this.initializeNow();
         }
         if(this.isInvalid())
         {
            this._invalidateCount = 0;
            this._validationQueue.addControl(this,false);
         }
      }
      
      protected function feathersControl_removedFromStageHandler(param1:Event) : void
      {
         this._depth = -1;
         this._validationQueue = null;
      }
      
      protected function layoutData_changeHandler(param1:Event) : void
      {
         this.dispatchEventWith("layoutDataChange");
      }
      
      protected function styleNameList_changeHandler(param1:Event) : void
      {
         if(!this._styleProvider)
         {
            return;
         }
         this._styleProvider.applyStyles(this);
      }
   }
}
