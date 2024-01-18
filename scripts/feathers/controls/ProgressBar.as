package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.skins.IStyleProvider;
   import feathers.utils.math.clamp;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import starling.display.DisplayObject;
   
   public class ProgressBar extends FeathersControl
   {
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var _direction:String = "horizontal";
      
      protected var _value:Number = 0;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 1;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var currentBackground:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _originalFillWidth:Number = NaN;
      
      protected var _originalFillHeight:Number = NaN;
      
      protected var currentFill:DisplayObject;
      
      protected var _fillSkin:DisplayObject;
      
      protected var _fillDisabledSkin:DisplayObject;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      public function ProgressBar()
      {
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ProgressBar.globalStyleProvider;
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
      
      public function get fillSkin() : DisplayObject
      {
         return this._fillSkin;
      }
      
      public function set fillSkin(param1:DisplayObject) : void
      {
         if(this._fillSkin == param1)
         {
            return;
         }
         if(this._fillSkin && this._fillSkin != this._fillDisabledSkin)
         {
            this.removeChild(this._fillSkin);
         }
         this._fillSkin = param1;
         if(this._fillSkin && this._fillSkin.parent != this)
         {
            this._fillSkin.visible = false;
            this.addChild(this._fillSkin);
         }
         this.invalidate("styles");
      }
      
      public function get fillDisabledSkin() : DisplayObject
      {
         return this._fillDisabledSkin;
      }
      
      public function set fillDisabledSkin(param1:DisplayObject) : void
      {
         if(this._fillDisabledSkin == param1)
         {
            return;
         }
         if(this._fillDisabledSkin && this._fillDisabledSkin != this._fillSkin)
         {
            this.removeChild(this._fillDisabledSkin);
         }
         this._fillDisabledSkin = param1;
         if(this._fillDisabledSkin && this._fillDisabledSkin.parent != this)
         {
            this._fillDisabledSkin.visible = false;
            this.addChild(this._fillDisabledSkin);
         }
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
      
      override protected function draw() : void
      {
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("state");
         var _loc1_:Boolean = this.isInvalid("size");
         if(_loc3_ || _loc2_)
         {
            this.refreshBackground();
            this.refreshFill();
         }
         this.autoSizeIfNeeded();
         this.layoutChildren();
         if(this.currentBackground is IValidating)
         {
            IValidating(this.currentBackground).validate();
         }
         if(this.currentFill is IValidating)
         {
            IValidating(this.currentFill).validate();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc13_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc11_:* = this._explicitHeight !== this._explicitHeight;
         var _loc8_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc12_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc3_ && !_loc11_ && !_loc8_ && !_loc12_)
         {
            return false;
         }
         var _loc5_:IMeasureDisplayObject = this.currentBackground as IMeasureDisplayObject;
         resetFluidChildDimensionsForMeasurement(this.currentBackground,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         if(this.currentBackground is IValidating)
         {
            IValidating(this.currentBackground).validate();
         }
         if(this.currentFill is IValidating)
         {
            IValidating(this.currentFill).validate();
         }
         var _loc7_:* = this._explicitMinWidth;
         if(_loc8_)
         {
            if(_loc5_ !== null)
            {
               _loc7_ = _loc5_.minWidth;
            }
            else if(this.currentBackground !== null)
            {
               _loc7_ = this._explicitBackgroundMinWidth;
            }
            else
            {
               _loc7_ = 0;
            }
            _loc13_ = this._originalFillWidth;
            if(this.currentFill is IFeathersControl)
            {
               _loc13_ = Number(IFeathersControl(this.currentFill).minWidth);
            }
            if((_loc13_ += this._paddingLeft + this._paddingRight) > _loc7_)
            {
               _loc7_ = _loc13_;
            }
         }
         var _loc9_:* = this._explicitMinHeight;
         if(_loc12_)
         {
            if(_loc5_ !== null)
            {
               _loc9_ = _loc5_.minHeight;
            }
            else if(this.currentBackground !== null)
            {
               _loc9_ = this._explicitBackgroundMinHeight;
            }
            else
            {
               _loc9_ = 0;
            }
            _loc6_ = this._originalFillHeight;
            if(this.currentFill is IFeathersControl)
            {
               _loc6_ = Number(IFeathersControl(this.currentFill).minHeight);
            }
            if((_loc6_ += this._paddingTop + this._paddingBottom) > _loc9_)
            {
               _loc9_ = _loc6_;
            }
         }
         var _loc1_:* = this._explicitWidth;
         if(_loc3_)
         {
            if(this.currentBackground !== null)
            {
               _loc1_ = this.currentBackground.width;
            }
            else
            {
               _loc1_ = 0;
            }
            _loc2_ = this._originalFillWidth + this._paddingLeft + this._paddingRight;
            if(_loc2_ > _loc1_)
            {
               _loc1_ = _loc2_;
            }
         }
         var _loc4_:* = this._explicitHeight;
         if(_loc11_)
         {
            if(this.currentBackground !== null)
            {
               _loc4_ = this.currentBackground.height;
            }
            else
            {
               _loc4_ = 0;
            }
            if((_loc10_ = this._originalFillHeight + this._paddingTop + this._paddingBottom) > _loc4_)
            {
               _loc4_ = _loc10_;
            }
         }
         return this.saveMeasurements(_loc1_,_loc4_,_loc7_,_loc9_);
      }
      
      protected function refreshBackground() : void
      {
         var _loc1_:IMeasureDisplayObject = null;
         this.currentBackground = this._backgroundSkin;
         if(this._backgroundDisabledSkin !== null)
         {
            if(this._isEnabled)
            {
               this._backgroundDisabledSkin.visible = false;
            }
            else
            {
               this.currentBackground = this._backgroundDisabledSkin;
               if(this._backgroundSkin !== null)
               {
                  this._backgroundSkin.visible = false;
               }
            }
         }
         if(this.currentBackground !== null)
         {
            this.currentBackground.visible = true;
            if(this.currentBackground is IFeathersControl)
            {
               IFeathersControl(this.currentBackground).initializeNow();
            }
            if(this.currentBackground is IMeasureDisplayObject)
            {
               _loc1_ = IMeasureDisplayObject(this.currentBackground);
               this._explicitBackgroundWidth = _loc1_.explicitWidth;
               this._explicitBackgroundHeight = _loc1_.explicitHeight;
               this._explicitBackgroundMinWidth = _loc1_.explicitMinWidth;
               this._explicitBackgroundMinHeight = _loc1_.explicitMinHeight;
               this._explicitBackgroundMaxWidth = _loc1_.explicitMaxWidth;
               this._explicitBackgroundMaxHeight = _loc1_.explicitMaxHeight;
            }
            else
            {
               this._explicitBackgroundWidth = this.currentBackground.width;
               this._explicitBackgroundHeight = this.currentBackground.height;
               this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
               this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
               this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
               this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
            }
         }
      }
      
      protected function refreshFill() : void
      {
         this.currentFill = this._fillSkin;
         if(this._fillDisabledSkin)
         {
            if(this._isEnabled)
            {
               this._fillDisabledSkin.visible = false;
            }
            else
            {
               this.currentFill = this._fillDisabledSkin;
               if(this._backgroundSkin)
               {
                  this._fillSkin.visible = false;
               }
            }
         }
         if(this.currentFill)
         {
            if(this.currentFill is IValidating)
            {
               IValidating(this.currentFill).validate();
            }
            if(this._originalFillWidth !== this._originalFillWidth)
            {
               this._originalFillWidth = this.currentFill.width;
            }
            if(this._originalFillHeight !== this._originalFillHeight)
            {
               this._originalFillHeight = this.currentFill.height;
            }
            this.currentFill.visible = true;
         }
      }
      
      protected function layoutChildren() : void
      {
         var _loc1_:Number = NaN;
         if(this.currentBackground)
         {
            this.currentBackground.width = this.actualWidth;
            this.currentBackground.height = this.actualHeight;
         }
         if(this._minimum === this._maximum)
         {
            _loc1_ = 1;
         }
         else
         {
            _loc1_ = (this._value - this._minimum) / (this._maximum - this._minimum);
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            else if(_loc1_ > 1)
            {
               _loc1_ = 1;
            }
         }
         if(this._direction === "vertical")
         {
            this.currentFill.width = this.actualWidth - this._paddingLeft - this._paddingRight;
            this.currentFill.height = Math.round(this._originalFillHeight + _loc1_ * (this.actualHeight - this._paddingTop - this._paddingBottom - this._originalFillHeight));
            this.currentFill.x = this._paddingLeft;
            this.currentFill.y = this.actualHeight - this._paddingBottom - this.currentFill.height;
         }
         else
         {
            this.currentFill.width = Math.round(this._originalFillWidth + _loc1_ * (this.actualWidth - this._paddingLeft - this._paddingRight - this._originalFillWidth));
            this.currentFill.height = this.actualHeight - this._paddingTop - this._paddingBottom;
            this.currentFill.x = this._paddingLeft;
            this.currentFill.y = this._paddingTop;
         }
      }
   }
}
