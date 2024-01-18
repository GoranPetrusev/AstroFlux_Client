package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.skins.IStyleProvider;
   import feathers.utils.math.clamp;
   import feathers.utils.math.roundToNearest;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class ScrollBar extends FeathersControl implements IDirectionalScrollBar
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      protected static const INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";
      
      protected static const INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY:String = "minimumTrackFactory";
      
      protected static const INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY:String = "maximumTrackFactory";
      
      protected static const INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY:String = "decrementButtonFactory";
      
      protected static const INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY:String = "incrementButtonFactory";
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";
      
      public static const TRACK_LAYOUT_MODE_MIN_MAX:String = "minMax";
      
      public static const DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-scroll-bar-minimum-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-scroll-bar-maximum-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-scroll-bar-thumb";
      
      public static const DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON:String = "feathers-scroll-bar-decrement-button";
      
      public static const DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON:String = "feathers-scroll-bar-increment-button";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var minimumTrackStyleName:String = "feathers-scroll-bar-minimum-track";
      
      protected var maximumTrackStyleName:String = "feathers-scroll-bar-maximum-track";
      
      protected var thumbStyleName:String = "feathers-scroll-bar-thumb";
      
      protected var decrementButtonStyleName:String = "feathers-scroll-bar-decrement-button";
      
      protected var incrementButtonStyleName:String = "feathers-scroll-bar-increment-button";
      
      protected var thumbOriginalWidth:Number = NaN;
      
      protected var thumbOriginalHeight:Number = NaN;
      
      protected var minimumTrackOriginalWidth:Number = NaN;
      
      protected var minimumTrackOriginalHeight:Number = NaN;
      
      protected var maximumTrackOriginalWidth:Number = NaN;
      
      protected var maximumTrackOriginalHeight:Number = NaN;
      
      protected var decrementButton:BasicButton;
      
      protected var incrementButton:BasicButton;
      
      protected var thumb:DisplayObject;
      
      protected var minimumTrack:DisplayObject;
      
      protected var maximumTrack:DisplayObject;
      
      protected var _minimumTrackSkinExplicitWidth:Number;
      
      protected var _minimumTrackSkinExplicitHeight:Number;
      
      protected var _minimumTrackSkinExplicitMinWidth:Number;
      
      protected var _minimumTrackSkinExplicitMinHeight:Number;
      
      protected var _maximumTrackSkinExplicitWidth:Number;
      
      protected var _maximumTrackSkinExplicitHeight:Number;
      
      protected var _maximumTrackSkinExplicitMinWidth:Number;
      
      protected var _maximumTrackSkinExplicitMinHeight:Number;
      
      protected var _direction:String = "horizontal";
      
      protected var _value:Number = 0;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 0;
      
      protected var _step:Number = 0;
      
      protected var _page:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var currentRepeatAction:Function;
      
      protected var _repeatTimer:Timer;
      
      protected var _repeatDelay:Number = 0.05;
      
      protected var isDragging:Boolean = false;
      
      public var liveDragging:Boolean = true;
      
      protected var _trackLayoutMode:String = "single";
      
      protected var _minimumTrackFactory:Function;
      
      protected var _customMinimumTrackStyleName:String;
      
      protected var _minimumTrackProperties:PropertyProxy;
      
      protected var _maximumTrackFactory:Function;
      
      protected var _customMaximumTrackStyleName:String;
      
      protected var _maximumTrackProperties:PropertyProxy;
      
      protected var _thumbFactory:Function;
      
      protected var _customThumbStyleName:String;
      
      protected var _thumbProperties:PropertyProxy;
      
      protected var _decrementButtonFactory:Function;
      
      protected var _customDecrementButtonStyleName:String;
      
      protected var _decrementButtonProperties:PropertyProxy;
      
      protected var _incrementButtonFactory:Function;
      
      protected var _customIncrementButtonStyleName:String;
      
      protected var _incrementButtonProperties:PropertyProxy;
      
      protected var _touchPointID:int = -1;
      
      protected var _touchStartX:Number = NaN;
      
      protected var _touchStartY:Number = NaN;
      
      protected var _thumbStartX:Number = NaN;
      
      protected var _thumbStartY:Number = NaN;
      
      protected var _touchValue:Number;
      
      public function ScrollBar()
      {
         super();
         this.addEventListener("removedFromStage",removedFromStageHandler);
      }
      
      protected static function defaultThumbFactory() : BasicButton
      {
         return new Button();
      }
      
      protected static function defaultMinimumTrackFactory() : BasicButton
      {
         return new Button();
      }
      
      protected static function defaultMaximumTrackFactory() : BasicButton
      {
         return new Button();
      }
      
      protected static function defaultDecrementButtonFactory() : BasicButton
      {
         return new Button();
      }
      
      protected static function defaultIncrementButtonFactory() : BasicButton
      {
         return new Button();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ScrollBar.globalStyleProvider;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(this._direction == param1)
         {
            return;
         }
         this._direction = param1;
         this.invalidate("data");
         this.invalidate("decrementButtonFactory");
         this.invalidate("incrementButtonFactory");
         this.invalidate("minimumTrackFactory");
         this.invalidate("maximumTrackFactory");
         this.invalidate("thumbFactory");
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         param1 = clamp(param1,this._minimum,this._maximum);
         if(this._value == param1)
         {
            return;
         }
         this._value = param1;
         this.invalidate("data");
         if(this.liveDragging || !this.isDragging)
         {
            this.dispatchEventWith("change");
         }
      }
      
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set minimum(param1:Number) : void
      {
         if(this._minimum == param1)
         {
            return;
         }
         this._minimum = param1;
         this.invalidate("data");
      }
      
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(param1:Number) : void
      {
         if(this._maximum == param1)
         {
            return;
         }
         this._maximum = param1;
         this.invalidate("data");
      }
      
      public function get step() : Number
      {
         return this._step;
      }
      
      public function set step(param1:Number) : void
      {
         this._step = param1;
      }
      
      public function get page() : Number
      {
         return this._page;
      }
      
      public function set page(param1:Number) : void
      {
         if(this._page == param1)
         {
            return;
         }
         this._page = param1;
         this.invalidate("data");
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
      
      public function get repeatDelay() : Number
      {
         return this._repeatDelay;
      }
      
      public function set repeatDelay(param1:Number) : void
      {
         if(this._repeatDelay == param1)
         {
            return;
         }
         this._repeatDelay = param1;
         this.invalidate("styles");
      }
      
      public function get trackLayoutMode() : String
      {
         return this._trackLayoutMode;
      }
      
      public function set trackLayoutMode(param1:String) : void
      {
         if(param1 === "minMax")
         {
            param1 = "split";
         }
         if(this._trackLayoutMode == param1)
         {
            return;
         }
         this._trackLayoutMode = param1;
         this.invalidate("layout");
      }
      
      public function get minimumTrackFactory() : Function
      {
         return this._minimumTrackFactory;
      }
      
      public function set minimumTrackFactory(param1:Function) : void
      {
         if(this._minimumTrackFactory == param1)
         {
            return;
         }
         this._minimumTrackFactory = param1;
         this.invalidate("minimumTrackFactory");
      }
      
      public function get customMinimumTrackStyleName() : String
      {
         return this._customMinimumTrackStyleName;
      }
      
      public function set customMinimumTrackStyleName(param1:String) : void
      {
         if(this._customMinimumTrackStyleName == param1)
         {
            return;
         }
         this._customMinimumTrackStyleName = param1;
         this.invalidate("minimumTrackFactory");
      }
      
      public function get minimumTrackProperties() : Object
      {
         if(!this._minimumTrackProperties)
         {
            this._minimumTrackProperties = new PropertyProxy(minimumTrackProperties_onChange);
         }
         return this._minimumTrackProperties;
      }
      
      public function set minimumTrackProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._minimumTrackProperties == param1)
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
         if(this._minimumTrackProperties)
         {
            this._minimumTrackProperties.removeOnChangeCallback(minimumTrackProperties_onChange);
         }
         this._minimumTrackProperties = PropertyProxy(param1);
         if(this._minimumTrackProperties)
         {
            this._minimumTrackProperties.addOnChangeCallback(minimumTrackProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get maximumTrackFactory() : Function
      {
         return this._maximumTrackFactory;
      }
      
      public function set maximumTrackFactory(param1:Function) : void
      {
         if(this._maximumTrackFactory == param1)
         {
            return;
         }
         this._maximumTrackFactory = param1;
         this.invalidate("maximumTrackFactory");
      }
      
      public function get customMaximumTrackStyleName() : String
      {
         return this._customMaximumTrackStyleName;
      }
      
      public function set customMaximumTrackStyleName(param1:String) : void
      {
         if(this._customMaximumTrackStyleName == param1)
         {
            return;
         }
         this._customMaximumTrackStyleName = param1;
         this.invalidate("maximumTrackFactory");
      }
      
      public function get maximumTrackProperties() : Object
      {
         if(!this._maximumTrackProperties)
         {
            this._maximumTrackProperties = new PropertyProxy(maximumTrackProperties_onChange);
         }
         return this._maximumTrackProperties;
      }
      
      public function set maximumTrackProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._maximumTrackProperties == param1)
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
         if(this._maximumTrackProperties)
         {
            this._maximumTrackProperties.removeOnChangeCallback(maximumTrackProperties_onChange);
         }
         this._maximumTrackProperties = PropertyProxy(param1);
         if(this._maximumTrackProperties)
         {
            this._maximumTrackProperties.addOnChangeCallback(maximumTrackProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get thumbFactory() : Function
      {
         return this._thumbFactory;
      }
      
      public function set thumbFactory(param1:Function) : void
      {
         if(this._thumbFactory == param1)
         {
            return;
         }
         this._thumbFactory = param1;
         this.invalidate("thumbFactory");
      }
      
      public function get customThumbStyleName() : String
      {
         return this._customThumbStyleName;
      }
      
      public function set customThumbStyleName(param1:String) : void
      {
         if(this._customThumbStyleName == param1)
         {
            return;
         }
         this._customThumbStyleName = param1;
         this.invalidate("thumbFactory");
      }
      
      public function get thumbProperties() : Object
      {
         if(!this._thumbProperties)
         {
            this._thumbProperties = new PropertyProxy(thumbProperties_onChange);
         }
         return this._thumbProperties;
      }
      
      public function set thumbProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._thumbProperties == param1)
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
         if(this._thumbProperties)
         {
            this._thumbProperties.removeOnChangeCallback(thumbProperties_onChange);
         }
         this._thumbProperties = PropertyProxy(param1);
         if(this._thumbProperties)
         {
            this._thumbProperties.addOnChangeCallback(thumbProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get decrementButtonFactory() : Function
      {
         return this._decrementButtonFactory;
      }
      
      public function set decrementButtonFactory(param1:Function) : void
      {
         if(this._decrementButtonFactory == param1)
         {
            return;
         }
         this._decrementButtonFactory = param1;
         this.invalidate("decrementButtonFactory");
      }
      
      public function get customDecrementButtonStyleName() : String
      {
         return this._customDecrementButtonStyleName;
      }
      
      public function set customDecrementButtonStyleName(param1:String) : void
      {
         if(this._customDecrementButtonStyleName == param1)
         {
            return;
         }
         this._customDecrementButtonStyleName = param1;
         this.invalidate("decrementButtonFactory");
      }
      
      public function get decrementButtonProperties() : Object
      {
         if(!this._decrementButtonProperties)
         {
            this._decrementButtonProperties = new PropertyProxy(decrementButtonProperties_onChange);
         }
         return this._decrementButtonProperties;
      }
      
      public function set decrementButtonProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._decrementButtonProperties == param1)
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
         if(this._decrementButtonProperties)
         {
            this._decrementButtonProperties.removeOnChangeCallback(decrementButtonProperties_onChange);
         }
         this._decrementButtonProperties = PropertyProxy(param1);
         if(this._decrementButtonProperties)
         {
            this._decrementButtonProperties.addOnChangeCallback(decrementButtonProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get incrementButtonFactory() : Function
      {
         return this._incrementButtonFactory;
      }
      
      public function set incrementButtonFactory(param1:Function) : void
      {
         if(this._incrementButtonFactory == param1)
         {
            return;
         }
         this._incrementButtonFactory = param1;
         this.invalidate("incrementButtonFactory");
      }
      
      public function get customIncrementButtonStyleName() : String
      {
         return this._customIncrementButtonStyleName;
      }
      
      public function set customIncrementButtonStyleName(param1:String) : void
      {
         if(this._customIncrementButtonStyleName == param1)
         {
            return;
         }
         this._customIncrementButtonStyleName = param1;
         this.invalidate("incrementButtonFactory");
      }
      
      public function get incrementButtonProperties() : Object
      {
         if(!this._incrementButtonProperties)
         {
            this._incrementButtonProperties = new PropertyProxy(incrementButtonProperties_onChange);
         }
         return this._incrementButtonProperties;
      }
      
      public function set incrementButtonProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._incrementButtonProperties == param1)
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
         if(this._incrementButtonProperties)
         {
            this._incrementButtonProperties.removeOnChangeCallback(incrementButtonProperties_onChange);
         }
         this._incrementButtonProperties = PropertyProxy(param1);
         if(this._incrementButtonProperties)
         {
            this._incrementButtonProperties.addOnChangeCallback(incrementButtonProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      override protected function initialize() : void
      {
         if(this._value < this._minimum)
         {
            this.value = this._minimum;
         }
         else if(this._value > this._maximum)
         {
            this.value = this._maximum;
         }
      }
      
      override protected function draw() : void
      {
         var _loc9_:Boolean = this.isInvalid("data");
         var _loc10_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc5_:Boolean = this.isInvalid("state");
         var _loc4_:Boolean = this.isInvalid("layout");
         var _loc8_:Boolean = this.isInvalid("thumbFactory");
         var _loc6_:Boolean = this.isInvalid("minimumTrackFactory");
         var _loc3_:Boolean = this.isInvalid("maximumTrackFactory");
         var _loc1_:Boolean = this.isInvalid("incrementButtonFactory");
         var _loc7_:Boolean = this.isInvalid("decrementButtonFactory");
         if(_loc8_)
         {
            this.createThumb();
         }
         if(_loc6_)
         {
            this.createMinimumTrack();
         }
         if(_loc3_ || _loc4_)
         {
            this.createMaximumTrack();
         }
         if(_loc7_)
         {
            this.createDecrementButton();
         }
         if(_loc1_)
         {
            this.createIncrementButton();
         }
         if(_loc8_ || _loc10_)
         {
            this.refreshThumbStyles();
         }
         if(_loc6_ || _loc10_)
         {
            this.refreshMinimumTrackStyles();
         }
         if((_loc3_ || _loc10_ || _loc4_) && this.maximumTrack)
         {
            this.refreshMaximumTrackStyles();
         }
         if(_loc7_ || _loc10_)
         {
            this.refreshDecrementButtonStyles();
         }
         if(_loc1_ || _loc10_)
         {
            this.refreshIncrementButtonStyles();
         }
         if(_loc9_ || _loc5_ || _loc8_ || _loc6_ || _loc3_ || _loc7_ || _loc1_)
         {
            this.refreshEnabled();
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         this.layout();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         if(this._direction === "vertical")
         {
            return this.measureVertical();
         }
         return this.measureHorizontal();
      }
      
      protected function measureHorizontal() : Boolean
      {
         var _loc14_:IMeasureDisplayObject = null;
         var _loc6_:Number = NaN;
         var _loc7_:IMeasureDisplayObject = null;
         var _loc8_:IMeasureDisplayObject = null;
         var _loc5_:IMeasureDisplayObject = null;
         var _loc1_:IMeasureDisplayObject = null;
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc13_:* = this._explicitHeight !== this._explicitHeight;
         var _loc10_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc15_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc3_ && !_loc13_ && !_loc10_ && !_loc15_)
         {
            return false;
         }
         var _loc11_:* = this._trackLayoutMode === "single";
         if(_loc3_)
         {
            this.minimumTrack.width = this._minimumTrackSkinExplicitWidth;
         }
         else if(_loc11_)
         {
            this.minimumTrack.width = this._explicitWidth;
         }
         if(this.minimumTrack is IMeasureDisplayObject)
         {
            _loc14_ = IMeasureDisplayObject(this.minimumTrack);
            if(_loc10_)
            {
               _loc14_.minWidth = this._minimumTrackSkinExplicitMinWidth;
            }
            else if(_loc11_)
            {
               _loc6_ = this._explicitMinWidth;
               if(this._minimumTrackSkinExplicitMinWidth > _loc6_)
               {
                  _loc6_ = this._minimumTrackSkinExplicitMinWidth;
               }
               _loc14_.minWidth = _loc6_;
            }
         }
         if(!_loc11_)
         {
            if(_loc3_)
            {
               this.maximumTrack.width = this._maximumTrackSkinExplicitWidth;
            }
            if(this.maximumTrack is IMeasureDisplayObject)
            {
               _loc7_ = IMeasureDisplayObject(this.maximumTrack);
               if(_loc10_)
               {
                  _loc7_.minWidth = this._maximumTrackSkinExplicitMinWidth;
               }
            }
         }
         if(this.minimumTrack is IValidating)
         {
            IValidating(this.minimumTrack).validate();
         }
         if(this.maximumTrack is IValidating)
         {
            IValidating(this.maximumTrack).validate();
         }
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         if(this.decrementButton is IValidating)
         {
            IValidating(this.decrementButton).validate();
         }
         if(this.incrementButton is IValidating)
         {
            IValidating(this.incrementButton).validate();
         }
         var _loc2_:Number = this._explicitWidth;
         var _loc4_:Number = this._explicitHeight;
         var _loc9_:Number = this._explicitMinWidth;
         var _loc12_:Number = this._explicitMinHeight;
         if(_loc3_)
         {
            _loc2_ = this.minimumTrack.width;
            if(!_loc11_)
            {
               _loc2_ += this.maximumTrack.width;
            }
            _loc2_ += this.decrementButton.width + this.incrementButton.width;
         }
         if(_loc13_)
         {
            _loc4_ = this.minimumTrack.height;
            if(!_loc11_ && this.maximumTrack.height > _loc4_)
            {
               _loc4_ = this.maximumTrack.height;
            }
            if(this.thumb.height > _loc4_)
            {
               _loc4_ = this.thumb.height;
            }
            if(this.decrementButton.height > _loc4_)
            {
               _loc4_ = this.decrementButton.height;
            }
            if(this.incrementButton.height > _loc4_)
            {
               _loc4_ = this.incrementButton.height;
            }
         }
         if(_loc10_)
         {
            if(_loc14_ !== null)
            {
               _loc9_ = _loc14_.minWidth;
            }
            else
            {
               _loc9_ = this.minimumTrack.width;
            }
            if(!_loc11_)
            {
               if(_loc7_ !== null)
               {
                  _loc9_ += _loc7_.minWidth;
               }
               else if(this.maximumTrack.width > _loc9_)
               {
                  _loc9_ += this.maximumTrack.width;
               }
            }
            if(this.decrementButton is IMeasureDisplayObject)
            {
               _loc9_ += IMeasureDisplayObject(this.decrementButton).minWidth;
            }
            else
            {
               _loc9_ += this.decrementButton.width;
            }
            if(this.incrementButton is IMeasureDisplayObject)
            {
               _loc9_ += IMeasureDisplayObject(this.incrementButton).minWidth;
            }
            else
            {
               _loc9_ += this.incrementButton.width;
            }
         }
         if(_loc15_)
         {
            if(_loc14_ !== null)
            {
               _loc12_ = _loc14_.minHeight;
            }
            else
            {
               _loc12_ = this.minimumTrack.height;
            }
            if(!_loc11_)
            {
               if(_loc7_ !== null)
               {
                  if(_loc7_.minHeight > _loc12_)
                  {
                     _loc12_ = _loc7_.minHeight;
                  }
               }
               else if(this.maximumTrack.height > _loc12_)
               {
                  _loc12_ = this.maximumTrack.height;
               }
            }
            if(this.thumb is IMeasureDisplayObject)
            {
               if((_loc8_ = IMeasureDisplayObject(this.thumb)).minHeight > _loc12_)
               {
                  _loc12_ = _loc8_.minHeight;
               }
            }
            else if(this.thumb.height > _loc12_)
            {
               _loc12_ = this.thumb.height;
            }
            if(this.decrementButton is IMeasureDisplayObject)
            {
               if((_loc5_ = IMeasureDisplayObject(this.decrementButton)).minHeight > _loc12_)
               {
                  _loc12_ = _loc5_.minHeight;
               }
            }
            else if(this.decrementButton.height > _loc12_)
            {
               _loc12_ = this.decrementButton.height;
            }
            if(this.incrementButton is IMeasureDisplayObject)
            {
               _loc1_ = IMeasureDisplayObject(this.incrementButton);
               if(_loc1_.minHeight > _loc12_)
               {
                  _loc12_ = _loc1_.minHeight;
               }
            }
            else if(this.incrementButton.height > _loc12_)
            {
               _loc12_ = this.incrementButton.height;
            }
         }
         return this.saveMeasurements(_loc2_,_loc4_,_loc9_,_loc12_);
      }
      
      protected function measureVertical() : Boolean
      {
         var _loc13_:IMeasureDisplayObject = null;
         var _loc14_:Number = NaN;
         var _loc6_:IMeasureDisplayObject = null;
         var _loc7_:IMeasureDisplayObject = null;
         var _loc5_:IMeasureDisplayObject = null;
         var _loc1_:IMeasureDisplayObject = null;
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc12_:* = this._explicitHeight !== this._explicitHeight;
         var _loc9_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc15_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc3_ && !_loc12_ && !_loc9_ && !_loc15_)
         {
            return false;
         }
         var _loc10_:* = this._trackLayoutMode === "single";
         if(_loc12_)
         {
            this.minimumTrack.height = this._minimumTrackSkinExplicitHeight;
         }
         else if(_loc10_)
         {
            this.minimumTrack.height = this._explicitHeight;
         }
         if(this.minimumTrack is IMeasureDisplayObject)
         {
            _loc13_ = IMeasureDisplayObject(this.minimumTrack);
            if(_loc15_)
            {
               _loc13_.minHeight = this._minimumTrackSkinExplicitMinHeight;
            }
            else if(_loc10_)
            {
               _loc14_ = this._explicitMinHeight;
               if(this._minimumTrackSkinExplicitMinHeight > _loc14_)
               {
                  _loc14_ = this._minimumTrackSkinExplicitMinHeight;
               }
               _loc13_.minHeight = _loc14_;
            }
         }
         if(!_loc10_)
         {
            if(_loc12_)
            {
               this.maximumTrack.height = this._maximumTrackSkinExplicitHeight;
            }
            if(this.maximumTrack is IMeasureDisplayObject)
            {
               _loc6_ = IMeasureDisplayObject(this.maximumTrack);
               if(_loc15_)
               {
                  _loc6_.minHeight = this._maximumTrackSkinExplicitMinHeight;
               }
            }
         }
         if(this.minimumTrack is IValidating)
         {
            IValidating(this.minimumTrack).validate();
         }
         if(this.maximumTrack is IValidating)
         {
            IValidating(this.maximumTrack).validate();
         }
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         if(this.decrementButton is IValidating)
         {
            IValidating(this.decrementButton).validate();
         }
         if(this.incrementButton is IValidating)
         {
            IValidating(this.incrementButton).validate();
         }
         var _loc2_:Number = this._explicitWidth;
         var _loc4_:Number = this._explicitHeight;
         var _loc8_:Number = this._explicitMinWidth;
         var _loc11_:Number = this._explicitMinHeight;
         if(_loc3_)
         {
            _loc2_ = this.minimumTrack.width;
            if(!_loc10_ && this.maximumTrack.width > _loc2_)
            {
               _loc2_ = this.maximumTrack.width;
            }
            if(this.thumb.width > _loc2_)
            {
               _loc2_ = this.thumb.width;
            }
            if(this.decrementButton.width > _loc2_)
            {
               _loc2_ = this.decrementButton.width;
            }
            if(this.incrementButton.width > _loc2_)
            {
               _loc2_ = this.incrementButton.width;
            }
         }
         if(_loc12_)
         {
            _loc4_ = this.minimumTrack.height;
            if(!_loc10_)
            {
               _loc4_ += this.maximumTrack.height;
            }
            _loc4_ += this.decrementButton.height + this.incrementButton.height;
         }
         if(_loc9_)
         {
            if(_loc13_ !== null)
            {
               _loc8_ = _loc13_.minWidth;
            }
            else
            {
               _loc8_ = this.minimumTrack.width;
            }
            if(!_loc10_)
            {
               if(_loc6_ !== null)
               {
                  if(_loc6_.minWidth > _loc8_)
                  {
                     _loc8_ = _loc6_.minWidth;
                  }
               }
               else if(this.maximumTrack.width > _loc8_)
               {
                  _loc8_ = this.maximumTrack.width;
               }
            }
            if(this.thumb is IMeasureDisplayObject)
            {
               if((_loc7_ = IMeasureDisplayObject(this.thumb)).minWidth > _loc8_)
               {
                  _loc8_ = _loc7_.minWidth;
               }
            }
            else if(this.thumb.width > _loc8_)
            {
               _loc8_ = this.thumb.width;
            }
            if(this.decrementButton is IMeasureDisplayObject)
            {
               if((_loc5_ = IMeasureDisplayObject(this.decrementButton)).minWidth > _loc8_)
               {
                  _loc8_ = _loc5_.minWidth;
               }
            }
            else if(this.decrementButton.width > _loc8_)
            {
               _loc8_ = this.decrementButton.width;
            }
            if(this.incrementButton is IMeasureDisplayObject)
            {
               _loc1_ = IMeasureDisplayObject(this.incrementButton);
               if(_loc1_.minWidth > _loc8_)
               {
                  _loc8_ = _loc1_.minWidth;
               }
            }
            else if(this.incrementButton.width > _loc8_)
            {
               _loc8_ = this.incrementButton.width;
            }
         }
         if(_loc15_)
         {
            if(_loc13_ !== null)
            {
               _loc11_ = _loc13_.minHeight;
            }
            else
            {
               _loc11_ = this.minimumTrack.height;
            }
            if(!_loc10_)
            {
               if(_loc6_ !== null)
               {
                  _loc11_ += _loc6_.minHeight;
               }
               else
               {
                  _loc11_ += this.maximumTrack.height;
               }
            }
            if(this.decrementButton is IMeasureDisplayObject)
            {
               _loc11_ += IMeasureDisplayObject(this.decrementButton).minHeight;
            }
            else
            {
               _loc11_ += this.decrementButton.height;
            }
            if(this.incrementButton is IMeasureDisplayObject)
            {
               _loc11_ += IMeasureDisplayObject(this.incrementButton).minHeight;
            }
            else
            {
               _loc11_ += this.incrementButton.height;
            }
         }
         return this.saveMeasurements(_loc2_,_loc4_,_loc8_,_loc11_);
      }
      
      protected function createThumb() : void
      {
         if(this.thumb)
         {
            this.thumb.removeFromParent(true);
            this.thumb = null;
         }
         var _loc1_:Function = this._thumbFactory != null ? this._thumbFactory : defaultThumbFactory;
         var _loc3_:String = this._customThumbStyleName != null ? this._customThumbStyleName : this.thumbStyleName;
         var _loc2_:BasicButton = BasicButton(_loc1_());
         _loc2_.styleNameList.add(_loc3_);
         _loc2_.keepDownStateOnRollOut = true;
         if(_loc2_ is IFocusDisplayObject)
         {
            _loc2_.isFocusEnabled = false;
         }
         _loc2_.addEventListener("touch",thumb_touchHandler);
         this.addChild(_loc2_);
         this.thumb = _loc2_;
      }
      
      protected function createMinimumTrack() : void
      {
         var _loc3_:IMeasureDisplayObject = null;
         if(this.minimumTrack)
         {
            this.minimumTrack.removeFromParent(true);
            this.minimumTrack = null;
         }
         var _loc1_:Function = this._minimumTrackFactory != null ? this._minimumTrackFactory : defaultMinimumTrackFactory;
         var _loc4_:String = this._customMinimumTrackStyleName != null ? this._customMinimumTrackStyleName : this.minimumTrackStyleName;
         var _loc2_:BasicButton = BasicButton(_loc1_());
         _loc2_.styleNameList.add(_loc4_);
         _loc2_.keepDownStateOnRollOut = true;
         if(_loc2_ is IFocusDisplayObject)
         {
            _loc2_.isFocusEnabled = false;
         }
         _loc2_.addEventListener("touch",track_touchHandler);
         this.addChildAt(_loc2_,0);
         this.minimumTrack = _loc2_;
         if(this.minimumTrack is IFeathersControl)
         {
            IFeathersControl(this.minimumTrack).initializeNow();
         }
         if(this.minimumTrack is IMeasureDisplayObject)
         {
            _loc3_ = IMeasureDisplayObject(this.minimumTrack);
            this._minimumTrackSkinExplicitWidth = _loc3_.explicitWidth;
            this._minimumTrackSkinExplicitHeight = _loc3_.explicitHeight;
            this._minimumTrackSkinExplicitMinWidth = _loc3_.explicitMinWidth;
            this._minimumTrackSkinExplicitMinHeight = _loc3_.explicitMinHeight;
         }
         else
         {
            this._minimumTrackSkinExplicitWidth = this.minimumTrack.width;
            this._minimumTrackSkinExplicitHeight = this.minimumTrack.height;
            this._minimumTrackSkinExplicitMinWidth = this._minimumTrackSkinExplicitWidth;
            this._minimumTrackSkinExplicitMinHeight = this._minimumTrackSkinExplicitHeight;
         }
      }
      
      protected function createMaximumTrack() : void
      {
         var _loc4_:IMeasureDisplayObject = null;
         if(this.maximumTrack)
         {
            this.maximumTrack.removeFromParent(true);
            this.maximumTrack = null;
         }
         if(this._trackLayoutMode !== "split")
         {
            return;
         }
         var _loc1_:Function = this._maximumTrackFactory != null ? this._maximumTrackFactory : defaultMaximumTrackFactory;
         var _loc3_:String = this._customMaximumTrackStyleName != null ? this._customMaximumTrackStyleName : this.maximumTrackStyleName;
         var _loc2_:BasicButton = BasicButton(_loc1_());
         _loc2_.styleNameList.add(_loc3_);
         _loc2_.keepDownStateOnRollOut = true;
         if(_loc2_ is IFocusDisplayObject)
         {
            _loc2_.isFocusEnabled = false;
         }
         _loc2_.addEventListener("touch",track_touchHandler);
         this.addChildAt(_loc2_,1);
         this.maximumTrack = _loc2_;
         if(this.maximumTrack is IFeathersControl)
         {
            IFeathersControl(this.maximumTrack).initializeNow();
         }
         if(this.maximumTrack is IMeasureDisplayObject)
         {
            _loc4_ = IMeasureDisplayObject(this.maximumTrack);
            this._maximumTrackSkinExplicitWidth = _loc4_.explicitWidth;
            this._maximumTrackSkinExplicitHeight = _loc4_.explicitHeight;
            this._maximumTrackSkinExplicitMinWidth = _loc4_.explicitMinWidth;
            this._maximumTrackSkinExplicitMinHeight = _loc4_.explicitMinHeight;
         }
         else
         {
            this._maximumTrackSkinExplicitWidth = this.maximumTrack.width;
            this._maximumTrackSkinExplicitHeight = this.maximumTrack.height;
            this._maximumTrackSkinExplicitMinWidth = this._maximumTrackSkinExplicitWidth;
            this._maximumTrackSkinExplicitMinHeight = this._maximumTrackSkinExplicitHeight;
         }
      }
      
      protected function createDecrementButton() : void
      {
         if(this.decrementButton)
         {
            this.decrementButton.removeFromParent(true);
            this.decrementButton = null;
         }
         var _loc1_:Function = this._decrementButtonFactory != null ? this._decrementButtonFactory : defaultDecrementButtonFactory;
         var _loc2_:String = this._customDecrementButtonStyleName != null ? this._customDecrementButtonStyleName : this.decrementButtonStyleName;
         this.decrementButton = BasicButton(_loc1_());
         this.decrementButton.styleNameList.add(_loc2_);
         this.decrementButton.keepDownStateOnRollOut = true;
         if(this.decrementButton is IFocusDisplayObject)
         {
            this.decrementButton.isFocusEnabled = false;
         }
         this.decrementButton.addEventListener("touch",decrementButton_touchHandler);
         this.addChild(this.decrementButton);
      }
      
      protected function createIncrementButton() : void
      {
         if(this.incrementButton)
         {
            this.incrementButton.removeFromParent(true);
            this.incrementButton = null;
         }
         var _loc1_:Function = this._incrementButtonFactory != null ? this._incrementButtonFactory : defaultIncrementButtonFactory;
         var _loc2_:String = this._customIncrementButtonStyleName != null ? this._customIncrementButtonStyleName : this.incrementButtonStyleName;
         this.incrementButton = BasicButton(_loc1_());
         this.incrementButton.styleNameList.add(_loc2_);
         this.incrementButton.keepDownStateOnRollOut = true;
         if(this.incrementButton is IFocusDisplayObject)
         {
            this.incrementButton.isFocusEnabled = false;
         }
         this.incrementButton.addEventListener("touch",incrementButton_touchHandler);
         this.addChild(this.incrementButton);
      }
      
      protected function refreshThumbStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._thumbProperties)
         {
            _loc2_ = this._thumbProperties[_loc1_];
            this.thumb[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshMinimumTrackStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._minimumTrackProperties)
         {
            _loc2_ = this._minimumTrackProperties[_loc1_];
            this.minimumTrack[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshMaximumTrackStyles() : void
      {
         var _loc2_:Object = null;
         if(!this.maximumTrack)
         {
            return;
         }
         for(var _loc1_ in this._maximumTrackProperties)
         {
            _loc2_ = this._maximumTrackProperties[_loc1_];
            this.maximumTrack[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshDecrementButtonStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._decrementButtonProperties)
         {
            _loc2_ = this._decrementButtonProperties[_loc1_];
            this.decrementButton[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshIncrementButtonStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._incrementButtonProperties)
         {
            _loc2_ = this._incrementButtonProperties[_loc1_];
            this.incrementButton[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshEnabled() : void
      {
         var _loc1_:Boolean = this._isEnabled && this._maximum > this._minimum;
         if(this.thumb is IFeathersControl)
         {
            IFeathersControl(this.thumb).isEnabled = _loc1_;
         }
         if(this.minimumTrack is IFeathersControl)
         {
            IFeathersControl(this.minimumTrack).isEnabled = _loc1_;
         }
         if(this.maximumTrack is IFeathersControl)
         {
            IFeathersControl(this.maximumTrack).isEnabled = _loc1_;
         }
         this.decrementButton.isEnabled = _loc1_;
         this.incrementButton.isEnabled = _loc1_;
      }
      
      protected function layout() : void
      {
         this.layoutStepButtons();
         this.layoutThumb();
         if(this._trackLayoutMode == "split")
         {
            this.layoutTrackWithMinMax();
         }
         else
         {
            this.layoutTrackWithSingle();
         }
      }
      
      protected function layoutStepButtons() : void
      {
         if(this._direction == "vertical")
         {
            this.decrementButton.x = (this.actualWidth - this.decrementButton.width) / 2;
            this.decrementButton.y = 0;
            this.incrementButton.x = (this.actualWidth - this.incrementButton.width) / 2;
            this.incrementButton.y = this.actualHeight - this.incrementButton.height;
         }
         else
         {
            this.decrementButton.x = 0;
            this.decrementButton.y = (this.actualHeight - this.decrementButton.height) / 2;
            this.incrementButton.x = this.actualWidth - this.incrementButton.width;
            this.incrementButton.y = (this.actualHeight - this.incrementButton.height) / 2;
         }
         var _loc1_:* = this._maximum != this._minimum;
         this.decrementButton.visible = _loc1_;
         this.incrementButton.visible = _loc1_;
      }
      
      protected function layoutThumb() : void
      {
         var _loc1_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc4_:Number = this._maximum - this._minimum;
         this.thumb.visible = _loc4_ > 0 && _loc4_ < Infinity && this._isEnabled;
         if(!this.thumb.visible)
         {
            return;
         }
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         var _loc3_:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
         var _loc8_:Number = this.actualHeight - this._paddingTop - this._paddingBottom;
         var _loc2_:* = this._page;
         if(this._page == 0)
         {
            _loc2_ = this._step;
         }
         if(_loc2_ > _loc4_)
         {
            _loc2_ = _loc4_;
         }
         if(this._direction == "vertical")
         {
            _loc8_ -= this.decrementButton.height + this.incrementButton.height;
            _loc1_ = this.thumbOriginalHeight;
            if(this.thumb is IMeasureDisplayObject)
            {
               _loc1_ = Number(IMeasureDisplayObject(this.thumb).minHeight);
            }
            this.thumb.width = this.thumbOriginalWidth;
            this.thumb.height = Math.max(_loc1_,_loc8_ * _loc2_ / _loc4_);
            _loc6_ = _loc8_ - this.thumb.height;
            this.thumb.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width) / 2;
            this.thumb.y = this.decrementButton.height + this._paddingTop + Math.max(0,Math.min(_loc6_,_loc6_ * (this._value - this._minimum) / _loc4_));
         }
         else
         {
            _loc3_ -= this.decrementButton.width + this.decrementButton.width;
            _loc5_ = this.thumbOriginalWidth;
            if(this.thumb is IMeasureDisplayObject)
            {
               _loc5_ = Number(IMeasureDisplayObject(this.thumb).minWidth);
            }
            this.thumb.width = Math.max(_loc5_,_loc3_ * _loc2_ / _loc4_);
            this.thumb.height = this.thumbOriginalHeight;
            _loc7_ = _loc3_ - this.thumb.width;
            this.thumb.x = this.decrementButton.width + this._paddingLeft + Math.max(0,Math.min(_loc7_,_loc7_ * (this._value - this._minimum) / _loc4_));
            this.thumb.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.thumb.height) / 2;
         }
      }
      
      protected function layoutTrackWithMinMax() : void
      {
         var _loc2_:Number = this._maximum - this._minimum;
         this.minimumTrack.touchable = _loc2_ > 0 && _loc2_ < Infinity;
         if(this.maximumTrack)
         {
            this.maximumTrack.touchable = _loc2_ > 0 && _loc2_ < Infinity;
         }
         var _loc1_:* = this._maximum !== this._minimum;
         if(this._direction === "vertical")
         {
            this.minimumTrack.x = 0;
            if(_loc1_)
            {
               this.minimumTrack.y = this.decrementButton.height;
            }
            else
            {
               this.minimumTrack.y = 0;
            }
            this.minimumTrack.width = this.actualWidth;
            this.minimumTrack.height = this.thumb.y + this.thumb.height / 2 - this.minimumTrack.y;
            this.maximumTrack.x = 0;
            this.maximumTrack.y = this.minimumTrack.y + this.minimumTrack.height;
            this.maximumTrack.width = this.actualWidth;
            if(_loc1_)
            {
               this.maximumTrack.height = this.actualHeight - this.incrementButton.height - this.maximumTrack.y;
            }
            else
            {
               this.maximumTrack.height = this.actualHeight - this.maximumTrack.y;
            }
         }
         else
         {
            if(_loc1_)
            {
               this.minimumTrack.x = this.decrementButton.width;
            }
            else
            {
               this.minimumTrack.x = 0;
            }
            this.minimumTrack.y = 0;
            this.minimumTrack.width = this.thumb.x + this.thumb.width / 2 - this.minimumTrack.x;
            this.minimumTrack.height = this.actualHeight;
            this.maximumTrack.x = this.minimumTrack.x + this.minimumTrack.width;
            this.maximumTrack.y = 0;
            if(_loc1_)
            {
               this.maximumTrack.width = this.actualWidth - this.incrementButton.width - this.maximumTrack.x;
            }
            else
            {
               this.maximumTrack.width = this.actualWidth - this.maximumTrack.x;
            }
            this.maximumTrack.height = this.actualHeight;
         }
         if(this.minimumTrack is IValidating)
         {
            IValidating(this.minimumTrack).validate();
         }
         if(this.maximumTrack is IValidating)
         {
            IValidating(this.maximumTrack).validate();
         }
      }
      
      protected function layoutTrackWithSingle() : void
      {
         var _loc2_:Number = this._maximum - this._minimum;
         this.minimumTrack.touchable = _loc2_ > 0 && _loc2_ < Infinity;
         var _loc1_:* = this._maximum !== this._minimum;
         if(this._direction === "vertical")
         {
            this.minimumTrack.x = 0;
            if(_loc1_)
            {
               this.minimumTrack.y = this.decrementButton.height;
            }
            else
            {
               this.minimumTrack.y = 0;
            }
            this.minimumTrack.width = this.actualWidth;
            if(_loc1_)
            {
               this.minimumTrack.height = this.actualHeight - this.minimumTrack.y - this.incrementButton.height;
            }
            else
            {
               this.minimumTrack.height = this.actualHeight - this.minimumTrack.y;
            }
         }
         else
         {
            if(_loc1_)
            {
               this.minimumTrack.x = this.decrementButton.width;
            }
            else
            {
               this.minimumTrack.x = 0;
            }
            this.minimumTrack.y = 0;
            if(_loc1_)
            {
               this.minimumTrack.width = this.actualWidth - this.minimumTrack.x - this.incrementButton.width;
            }
            else
            {
               this.minimumTrack.width = this.actualWidth - this.minimumTrack.x;
            }
            this.minimumTrack.height = this.actualHeight;
         }
         if(this.minimumTrack is IValidating)
         {
            IValidating(this.minimumTrack).validate();
         }
      }
      
      protected function locationToValue(param1:Point) : Number
      {
         var _loc7_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc5_:Number = 0;
         if(this._direction == "vertical")
         {
            if((_loc7_ = this.actualHeight - this.thumb.height - this.decrementButton.height - this.incrementButton.height - this._paddingTop - this._paddingBottom) > 0)
            {
               _loc3_ = param1.y - this._touchStartY - this._paddingTop;
               _loc5_ = (_loc6_ = Math.min(Math.max(0,this._thumbStartY + _loc3_ - this.decrementButton.height),_loc7_)) / _loc7_;
            }
         }
         else if((_loc8_ = this.actualWidth - this.thumb.width - this.decrementButton.width - this.incrementButton.width - this._paddingLeft - this._paddingRight) > 0)
         {
            _loc4_ = param1.x - this._touchStartX - this._paddingLeft;
            _loc2_ = Math.min(Math.max(0,this._thumbStartX + _loc4_ - this.decrementButton.width),_loc8_);
            _loc5_ = _loc2_ / _loc8_;
         }
         return this._minimum + _loc5_ * (this._maximum - this._minimum);
      }
      
      protected function decrement() : void
      {
         this.value -= this._step;
      }
      
      protected function increment() : void
      {
         this.value += this._step;
      }
      
      protected function adjustPage() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Number = this._maximum - this._minimum;
         var _loc2_:* = this._page;
         if(this._page == 0)
         {
            _loc2_ = this._step;
         }
         if(_loc2_ > _loc3_)
         {
            _loc2_ = _loc3_;
         }
         if(this._touchValue < this._value)
         {
            _loc1_ = Math.max(this._touchValue,this._value - _loc2_);
            if(this._step != 0 && _loc1_ != this._maximum && _loc1_ != this._minimum)
            {
               _loc1_ = roundToNearest(_loc1_,this._step);
            }
            this.value = _loc1_;
         }
         else if(this._touchValue > this._value)
         {
            _loc1_ = Math.min(this._touchValue,this._value + _loc2_);
            if(this._step != 0 && _loc1_ != this._maximum && _loc1_ != this._minimum)
            {
               _loc1_ = roundToNearest(_loc1_,this._step);
            }
            this.value = _loc1_;
         }
      }
      
      protected function startRepeatTimer(param1:Function) : void
      {
         this.currentRepeatAction = param1;
         if(this._repeatDelay > 0)
         {
            if(!this._repeatTimer)
            {
               this._repeatTimer = new Timer(this._repeatDelay * 1000);
               this._repeatTimer.addEventListener("timer",repeatTimer_timerHandler);
            }
            else
            {
               this._repeatTimer.reset();
               this._repeatTimer.delay = this._repeatDelay * 1000;
            }
            this._repeatTimer.start();
         }
      }
      
      protected function thumbProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function minimumTrackProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function maximumTrackProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function decrementButtonProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function incrementButtonProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function removedFromStageHandler(param1:Event) : void
      {
         this._touchPointID = -1;
         if(this._repeatTimer)
         {
            this._repeatTimer.stop();
         }
      }
      
      protected function track_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         var _loc3_:DisplayObject = DisplayObject(param1.currentTarget);
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(_loc3_,"ended",this._touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this._touchPointID = -1;
            this._repeatTimer.stop();
            this.dispatchEventWith("endInteraction");
         }
         else
         {
            _loc2_ = param1.getTouch(_loc3_,"began");
            if(!_loc2_)
            {
               return;
            }
            this._touchPointID = _loc2_.id;
            this.dispatchEventWith("beginInteraction");
            _loc2_.getLocation(this,HELPER_POINT);
            this._touchStartX = HELPER_POINT.x;
            this._touchStartY = HELPER_POINT.y;
            this._thumbStartX = HELPER_POINT.x;
            this._thumbStartY = HELPER_POINT.y;
            this._touchValue = this.locationToValue(HELPER_POINT);
            this.adjustPage();
            this.startRepeatTimer(this.adjustPage);
         }
      }
      
      protected function thumb_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc2_:Number = NaN;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc3_ = param1.getTouch(this.thumb,null,this._touchPointID);
            if(!_loc3_)
            {
               return;
            }
            if(_loc3_.phase == "moved")
            {
               _loc3_.getLocation(this,HELPER_POINT);
               _loc2_ = this.locationToValue(HELPER_POINT);
               if(this._step != 0 && _loc2_ != this._maximum && _loc2_ != this._minimum)
               {
                  _loc2_ = roundToNearest(_loc2_,this._step);
               }
               this.value = _loc2_;
            }
            else if(_loc3_.phase == "ended")
            {
               this._touchPointID = -1;
               this.isDragging = false;
               if(!this.liveDragging)
               {
                  this.dispatchEventWith("change");
               }
               this.dispatchEventWith("endInteraction");
            }
         }
         else
         {
            _loc3_ = param1.getTouch(this.thumb,"began");
            if(!_loc3_)
            {
               return;
            }
            _loc3_.getLocation(this,HELPER_POINT);
            this._touchPointID = _loc3_.id;
            this._thumbStartX = this.thumb.x;
            this._thumbStartY = this.thumb.y;
            this._touchStartX = HELPER_POINT.x;
            this._touchStartY = HELPER_POINT.y;
            this.isDragging = true;
            this.dispatchEventWith("beginInteraction");
         }
      }
      
      protected function decrementButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.decrementButton,"ended",this._touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this._touchPointID = -1;
            this._repeatTimer.stop();
            this.dispatchEventWith("endInteraction");
         }
         else
         {
            _loc2_ = param1.getTouch(this.decrementButton,"began");
            if(!_loc2_)
            {
               return;
            }
            this._touchPointID = _loc2_.id;
            this.dispatchEventWith("beginInteraction");
            this.decrement();
            this.startRepeatTimer(this.decrement);
         }
      }
      
      protected function incrementButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.incrementButton,"ended",this._touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this._touchPointID = -1;
            this._repeatTimer.stop();
            this.dispatchEventWith("endInteraction");
         }
         else
         {
            _loc2_ = param1.getTouch(this.incrementButton,"began");
            if(!_loc2_)
            {
               return;
            }
            this._touchPointID = _loc2_.id;
            this.dispatchEventWith("beginInteraction");
            this.increment();
            this.startRepeatTimer(this.increment);
         }
      }
      
      protected function repeatTimer_timerHandler(param1:TimerEvent) : void
      {
         if(this._repeatTimer.currentCount < 5)
         {
            return;
         }
         this.currentRepeatAction();
      }
   }
}
