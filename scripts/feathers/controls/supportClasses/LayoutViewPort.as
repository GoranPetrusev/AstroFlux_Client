package feathers.controls.supportClasses
{
   import feathers.controls.LayoutGroup;
   import feathers.core.IValidating;
   import feathers.layout.ILayoutDisplayObject;
   import starling.display.DisplayObject;
   
   public class LayoutViewPort extends LayoutGroup implements IViewPort
   {
       
      
      private var _actualMinVisibleWidth:Number = 0;
      
      private var _explicitMinVisibleWidth:Number;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var _actualVisibleWidth:Number = 0;
      
      private var _explicitVisibleWidth:Number;
      
      private var _actualMinVisibleHeight:Number = 0;
      
      private var _explicitMinVisibleHeight:Number;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var _actualVisibleHeight:Number = 0;
      
      private var _explicitVisibleHeight:Number;
      
      private var _contentX:Number = 0;
      
      private var _contentY:Number = 0;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      public function LayoutViewPort()
      {
         super();
      }
      
      public function get minVisibleWidth() : Number
      {
         if(this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return this._actualMinVisibleWidth;
         }
         return this._explicitMinVisibleWidth;
      }
      
      public function set minVisibleWidth(param1:Number) : void
      {
         if(this._explicitMinVisibleWidth == param1)
         {
            return;
         }
         var _loc2_:* = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleWidth;
         this._explicitMinVisibleWidth = param1;
         if(_loc2_)
         {
            this._actualMinVisibleWidth = 0;
            this.invalidate("size");
         }
         else
         {
            this._actualMinVisibleWidth = param1;
            if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth < param1 || this._actualVisibleWidth === _loc3_))
            {
               this.invalidate("size");
            }
         }
      }
      
      public function get maxVisibleWidth() : Number
      {
         return this._maxVisibleWidth;
      }
      
      public function set maxVisibleWidth(param1:Number) : void
      {
         if(this._maxVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleWidth cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleWidth;
         this._maxVisibleWidth = param1;
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth > param1 || this._actualVisibleWidth === _loc2_))
         {
            this.invalidate("size");
         }
      }
      
      public function get visibleWidth() : Number
      {
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return this._actualVisibleWidth;
         }
         return this._explicitVisibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this._explicitVisibleWidth == param1 || param1 !== param1 && this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return;
         }
         this._explicitVisibleWidth = param1;
         if(this._actualVisibleWidth !== param1)
         {
            this.invalidate("size");
         }
      }
      
      public function get minVisibleHeight() : Number
      {
         if(this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return this._actualMinVisibleHeight;
         }
         return this._explicitMinVisibleHeight;
      }
      
      public function set minVisibleHeight(param1:Number) : void
      {
         if(this._explicitMinVisibleHeight == param1)
         {
            return;
         }
         var _loc2_:* = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleHeight;
         this._explicitMinVisibleHeight = param1;
         if(_loc2_)
         {
            this._actualMinVisibleHeight = 0;
            this.invalidate("size");
         }
         else
         {
            this._actualMinVisibleHeight = param1;
            if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight < param1 || this._actualVisibleHeight === _loc3_))
            {
               this.invalidate("size");
            }
         }
      }
      
      public function get maxVisibleHeight() : Number
      {
         return this._maxVisibleHeight;
      }
      
      public function set maxVisibleHeight(param1:Number) : void
      {
         if(this._maxVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleHeight cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleHeight;
         this._maxVisibleHeight = param1;
         if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight > param1 || this._actualVisibleHeight === _loc2_))
         {
            this.invalidate("size");
         }
      }
      
      public function get visibleHeight() : Number
      {
         if(this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return this._actualVisibleHeight;
         }
         return this._explicitVisibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this._explicitVisibleHeight == param1 || param1 !== param1 && this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return;
         }
         this._explicitVisibleHeight = param1;
         if(this._actualVisibleHeight !== param1)
         {
            this.invalidate("size");
         }
      }
      
      public function get contentX() : Number
      {
         return this._contentX;
      }
      
      public function get contentY() : Number
      {
         return this._contentY;
      }
      
      public function get horizontalScrollStep() : Number
      {
         if(this.actualWidth < this.actualHeight)
         {
            return this.actualWidth / 10;
         }
         return this.actualHeight / 10;
      }
      
      public function get verticalScrollStep() : Number
      {
         if(this.actualWidth < this.actualHeight)
         {
            return this.actualWidth / 10;
         }
         return this.actualHeight / 10;
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
         this._horizontalScrollPosition = param1;
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
         this._verticalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get requiresMeasurementOnScroll() : Boolean
      {
         return this._layout !== null && this._layout.requiresLayoutOnScroll && (this._explicitVisibleWidth !== this._explicitVisibleWidth || this._explicitVisibleHeight !== this._explicitVisibleHeight);
      }
      
      override public function dispose() : void
      {
         this.layout = null;
         super.dispose();
      }
      
      override protected function refreshViewPortBounds() : void
      {
         var _loc1_:* = this._explicitVisibleWidth !== this._explicitVisibleWidth;
         var _loc3_:* = this._explicitVisibleHeight !== this._explicitVisibleHeight;
         var _loc2_:* = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth;
         var _loc4_:* = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight;
         this.viewPortBounds.x = 0;
         this.viewPortBounds.y = 0;
         this.viewPortBounds.scrollX = this._horizontalScrollPosition;
         this.viewPortBounds.scrollY = this._verticalScrollPosition;
         if(this._autoSizeMode === "stage" && _loc1_)
         {
            this.viewPortBounds.explicitWidth = this.stage.stageWidth;
         }
         else
         {
            this.viewPortBounds.explicitWidth = this._explicitVisibleWidth;
         }
         if(this._autoSizeMode === "stage" && _loc3_)
         {
            this.viewPortBounds.explicitHeight = this.stage.stageHeight;
         }
         else
         {
            this.viewPortBounds.explicitHeight = this._explicitVisibleHeight;
         }
         if(_loc2_)
         {
            this.viewPortBounds.minWidth = 0;
         }
         else
         {
            this.viewPortBounds.minWidth = this._explicitMinVisibleWidth;
         }
         if(_loc4_)
         {
            this.viewPortBounds.minHeight = 0;
         }
         else
         {
            this.viewPortBounds.minHeight = this._explicitMinVisibleHeight;
         }
         this.viewPortBounds.maxWidth = this._maxVisibleWidth;
         this.viewPortBounds.maxHeight = this._maxVisibleHeight;
      }
      
      override protected function handleLayoutResult() : void
      {
         var _loc1_:Number = this._layoutResult.contentWidth;
         var _loc4_:Number = this._layoutResult.contentHeight;
         this.saveMeasurements(_loc1_,_loc4_,_loc1_,_loc4_);
         this._contentX = this._layoutResult.contentX;
         this._contentY = this._layoutResult.contentY;
         var _loc2_:Number = this._layoutResult.viewPortWidth;
         var _loc3_:Number = this._layoutResult.viewPortHeight;
         this._actualVisibleWidth = _loc2_;
         this._actualVisibleHeight = _loc3_;
         this._actualMinVisibleWidth = _loc2_;
         this._actualMinVisibleHeight = _loc3_;
      }
      
      override protected function handleManualLayout() : void
      {
         var _loc7_:int = 0;
         var _loc1_:DisplayObject = null;
         var _loc16_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc14_:* = 0;
         var _loc13_:* = 0;
         var _loc17_:Number;
         var _loc5_:* = _loc17_ = this.viewPortBounds.explicitWidth;
         this.doNothing();
         if(_loc5_ !== _loc5_)
         {
            _loc5_ = 0;
         }
         var _loc6_:Number;
         var _loc4_:* = _loc6_ = this.viewPortBounds.explicitHeight;
         this.doNothing();
         if(_loc4_ !== _loc4_)
         {
            _loc4_ = 0;
         }
         this._ignoreChildChanges = true;
         var _loc11_:int = int(this.items.length);
         _loc7_ = 0;
         while(_loc7_ < _loc11_)
         {
            _loc1_ = this.items[_loc7_];
            if(!(_loc1_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc1_).includeInLayout))
            {
               if(_loc1_ is IValidating)
               {
                  IValidating(_loc1_).validate();
               }
               _loc16_ = _loc1_.x;
               _loc18_ = _loc1_.y;
               _loc9_ = _loc16_ + _loc1_.width;
               _loc3_ = _loc18_ + _loc1_.height;
               if(_loc16_ === _loc16_ && _loc16_ < _loc14_)
               {
                  _loc14_ = _loc16_;
               }
               if(_loc18_ === _loc18_ && _loc18_ < _loc13_)
               {
                  _loc13_ = _loc18_;
               }
               if(_loc9_ === _loc9_ && _loc9_ > _loc5_)
               {
                  _loc5_ = _loc9_;
               }
               if(_loc3_ === _loc3_ && _loc3_ > _loc4_)
               {
                  _loc4_ = _loc3_;
               }
            }
            _loc7_++;
         }
         this._contentX = _loc14_;
         this._contentY = _loc13_;
         var _loc8_:Number = this.viewPortBounds.minWidth;
         var _loc19_:Number = this.viewPortBounds.maxWidth;
         var _loc12_:Number = this.viewPortBounds.minHeight;
         var _loc15_:Number = this.viewPortBounds.maxHeight;
         var _loc2_:* = _loc5_ - _loc14_;
         if(_loc2_ < _loc8_)
         {
            _loc2_ = _loc8_;
         }
         else if(_loc2_ > _loc19_)
         {
            _loc2_ = _loc19_;
         }
         var _loc10_:*;
         if((_loc10_ = _loc4_ - _loc13_) < _loc12_)
         {
            _loc10_ = _loc12_;
         }
         else if(_loc10_ > _loc15_)
         {
            _loc10_ = _loc15_;
         }
         this._ignoreChildChanges = false;
         if(_loc17_ !== _loc17_)
         {
            this._actualVisibleWidth = _loc2_;
         }
         else
         {
            this._actualVisibleWidth = _loc17_;
         }
         if(_loc6_ !== _loc6_)
         {
            this._actualVisibleHeight = _loc10_;
         }
         else
         {
            this._actualVisibleHeight = _loc6_;
         }
         this._layoutResult.contentX = 0;
         this._layoutResult.contentY = 0;
         this._layoutResult.contentWidth = _loc2_;
         this._layoutResult.contentHeight = _loc10_;
         this._layoutResult.viewPortWidth = _loc2_;
         this._layoutResult.viewPortHeight = _loc10_;
      }
      
      protected function doNothing() : void
      {
      }
   }
}
