package feathers.layout
{
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.EventDispatcher;
   
   public class VerticalSpinnerLayout extends EventDispatcher implements ISpinnerLayout, ITrimmedVirtualLayout
   {
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";
       
      
      protected var _discoveredItemsCache:Vector.<DisplayObject>;
      
      protected var _gap:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _horizontalAlign:String = "justify";
      
      protected var _useVirtualLayout:Boolean = true;
      
      protected var _requestedRowCount:int = 0;
      
      protected var _beforeVirtualizedItemCount:int = 0;
      
      protected var _afterVirtualizedItemCount:int = 0;
      
      protected var _typicalItem:DisplayObject;
      
      protected var _resetTypicalItemDimensionsOnMeasure:Boolean = false;
      
      protected var _typicalItemWidth:Number = NaN;
      
      protected var _typicalItemHeight:Number = NaN;
      
      protected var _repeatItems:Boolean = true;
      
      public function VerticalSpinnerLayout()
      {
         _discoveredItemsCache = new Vector.<DisplayObject>(0);
         super();
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
         this.dispatchEventWith("change");
      }
      
      public function get padding() : Number
      {
         return this._paddingLeft;
      }
      
      public function set padding(param1:Number) : void
      {
         this.paddingRight = param1;
         this.paddingLeft = param1;
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
         this.dispatchEventWith("change");
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
         this.dispatchEventWith("change");
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
         this.dispatchEventWith("change");
      }
      
      public function get useVirtualLayout() : Boolean
      {
         return this._useVirtualLayout;
      }
      
      public function set useVirtualLayout(param1:Boolean) : void
      {
         if(this._useVirtualLayout == param1)
         {
            return;
         }
         this._useVirtualLayout = param1;
         this.dispatchEventWith("change");
      }
      
      public function get requestedRowCount() : int
      {
         return this._requestedRowCount;
      }
      
      public function set requestedRowCount(param1:int) : void
      {
         if(param1 < 0)
         {
            throw RangeError("requestedRowCount requires a value >= 0");
         }
         if(this._requestedRowCount == param1)
         {
            return;
         }
         this._requestedRowCount = param1;
         this.dispatchEventWith("change");
      }
      
      public function get beforeVirtualizedItemCount() : int
      {
         return this._beforeVirtualizedItemCount;
      }
      
      public function set beforeVirtualizedItemCount(param1:int) : void
      {
         if(this._beforeVirtualizedItemCount == param1)
         {
            return;
         }
         this._beforeVirtualizedItemCount = param1;
         this.dispatchEventWith("change");
      }
      
      public function get afterVirtualizedItemCount() : int
      {
         return this._afterVirtualizedItemCount;
      }
      
      public function set afterVirtualizedItemCount(param1:int) : void
      {
         if(this._afterVirtualizedItemCount == param1)
         {
            return;
         }
         this._afterVirtualizedItemCount = param1;
         this.dispatchEventWith("change");
      }
      
      public function get typicalItem() : DisplayObject
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(param1:DisplayObject) : void
      {
         if(this._typicalItem == param1)
         {
            return;
         }
         this._typicalItem = param1;
         this.dispatchEventWith("change");
      }
      
      public function get resetTypicalItemDimensionsOnMeasure() : Boolean
      {
         return this._resetTypicalItemDimensionsOnMeasure;
      }
      
      public function set resetTypicalItemDimensionsOnMeasure(param1:Boolean) : void
      {
         if(this._resetTypicalItemDimensionsOnMeasure == param1)
         {
            return;
         }
         this._resetTypicalItemDimensionsOnMeasure = param1;
         this.dispatchEventWith("change");
      }
      
      public function get typicalItemWidth() : Number
      {
         return this._typicalItemWidth;
      }
      
      public function set typicalItemWidth(param1:Number) : void
      {
         if(this._typicalItemWidth == param1)
         {
            return;
         }
         this._typicalItemWidth = param1;
         this.dispatchEventWith("change");
      }
      
      public function get typicalItemHeight() : Number
      {
         return this._typicalItemHeight;
      }
      
      public function set typicalItemHeight(param1:Number) : void
      {
         if(this._typicalItemHeight == param1)
         {
            return;
         }
         this._typicalItemHeight = param1;
         this.dispatchEventWith("change");
      }
      
      public function get repeatItems() : Boolean
      {
         return this._repeatItems;
      }
      
      public function set repeatItems(param1:Boolean) : void
      {
         if(this._repeatItems == param1)
         {
            return;
         }
         this._repeatItems = param1;
         this.dispatchEventWith("change");
      }
      
      public function get snapInterval() : Number
      {
         return this._typicalItem.height + this._gap;
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return true;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc26_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:int = 0;
         var _loc19_:DisplayObject = null;
         var _loc13_:Number = NaN;
         var _loc6_:ILayoutDisplayObject = null;
         var _loc18_:Number = NaN;
         var _loc10_:* = NaN;
         var _loc35_:Number = !!param2 ? param2.scrollX : 0;
         var _loc32_:Number = !!param2 ? param2.scrollY : 0;
         var _loc30_:Number = !!param2 ? param2.x : 0;
         var _loc31_:Number = !!param2 ? param2.y : 0;
         var _loc25_:Number = !!param2 ? param2.minWidth : 0;
         var _loc7_:Number = !!param2 ? param2.minHeight : 0;
         var _loc17_:Number = !!param2 ? param2.maxWidth : Infinity;
         var _loc11_:Number = !!param2 ? param2.maxHeight : Infinity;
         var _loc29_:Number = !!param2 ? param2.explicitWidth : NaN;
         var _loc33_:Number = !!param2 ? param2.explicitHeight : NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(_loc29_ - this._paddingLeft - this._paddingRight);
            _loc26_ = !!this._typicalItem ? this._typicalItem.width : 0;
            _loc23_ = !!this._typicalItem ? this._typicalItem.height : 0;
         }
         if(!this._useVirtualLayout || this._horizontalAlign != "justify" || _loc29_ !== _loc29_)
         {
            this.validateItems(param1,_loc29_ - this._paddingLeft - this._paddingRight,_loc33_);
         }
         var _loc34_:* = this._useVirtualLayout ? _loc26_ : 0;
         var _loc8_:* = _loc31_;
         var _loc12_:Number = this._gap;
         var _loc27_:int;
         var _loc28_:* = _loc27_ = int(param1.length);
         if(this._useVirtualLayout)
         {
            _loc28_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            _loc8_ += this._beforeVirtualizedItemCount * (_loc23_ + _loc12_);
         }
         this._discoveredItemsCache.length = 0;
         var _loc9_:int = 0;
         _loc24_ = 0;
         for(; _loc24_ < _loc27_; _loc24_++)
         {
            if(_loc19_ = param1[_loc24_])
            {
               if(_loc19_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc19_).includeInLayout)
               {
                  continue;
               }
               _loc19_.y = _loc19_.pivotY + _loc8_;
               _loc19_.height = _loc23_;
               if((_loc13_ = _loc19_.width) > _loc34_)
               {
                  _loc34_ = _loc13_;
               }
               if(this._useVirtualLayout)
               {
                  this._discoveredItemsCache[_loc9_] = _loc19_;
                  _loc9_++;
               }
            }
            _loc8_ += _loc23_ + _loc12_;
         }
         if(this._useVirtualLayout)
         {
            _loc8_ += this._afterVirtualizedItemCount * (_loc23_ + _loc12_);
         }
         var _loc20_:Vector.<DisplayObject>;
         var _loc21_:int = int((_loc20_ = this._useVirtualLayout ? this._discoveredItemsCache : param1).length);
         var _loc15_:Number = _loc34_ + this._paddingLeft + this._paddingRight;
         var _loc22_:* = _loc29_;
         if(_loc22_ !== _loc22_)
         {
            if((_loc22_ = _loc15_) < _loc25_)
            {
               _loc22_ = _loc25_;
            }
            else if(_loc22_ > _loc17_)
            {
               _loc22_ = _loc17_;
            }
         }
         var _loc4_:Number = _loc8_ - _loc12_ - _loc31_;
         var _loc5_:* = _loc33_;
         if(_loc5_ !== _loc5_)
         {
            if(this._requestedRowCount > 0)
            {
               _loc5_ = this._requestedRowCount * (_loc23_ + _loc12_) - _loc12_;
            }
            else
            {
               _loc5_ = _loc4_;
            }
            if(_loc5_ < _loc7_)
            {
               _loc5_ = _loc7_;
            }
            else if(_loc5_ > _loc11_)
            {
               _loc5_ = _loc11_;
            }
         }
         var _loc16_:Boolean;
         if(_loc16_ = this._repeatItems && _loc4_ > _loc5_)
         {
            _loc4_ += _loc12_;
         }
         var _loc14_:Number = Math.round((_loc5_ - _loc23_) / 2);
         if(!_loc16_)
         {
            _loc4_ += 2 * _loc14_;
         }
         _loc24_ = 0;
         while(_loc24_ < _loc21_)
         {
            if(!((_loc19_ = _loc20_[_loc24_]) is ILayoutDisplayObject && !ILayoutDisplayObject(_loc19_).includeInLayout))
            {
               _loc19_.y += _loc14_;
            }
            _loc24_++;
         }
         _loc24_ = 0;
         while(_loc24_ < _loc21_)
         {
            if(!((_loc6_ = (_loc19_ = _loc20_[_loc24_]) as ILayoutDisplayObject) && !_loc6_.includeInLayout))
            {
               if(_loc16_)
               {
                  if((_loc18_ = _loc32_ - _loc14_) > 0)
                  {
                     _loc19_.y += _loc4_ * (int((_loc18_ + _loc5_) / _loc4_));
                     if(_loc19_.y >= _loc32_ + _loc5_)
                     {
                        _loc19_.y -= _loc4_;
                     }
                  }
                  else if(_loc18_ < 0)
                  {
                     _loc19_.y += _loc4_ * (int(_loc18_ / _loc4_) - 1);
                     if(_loc19_.y + _loc19_.height < _loc32_)
                     {
                        _loc19_.y += _loc4_;
                     }
                  }
               }
               if(this._horizontalAlign == "justify")
               {
                  _loc19_.x = _loc19_.pivotX + _loc30_ + this._paddingLeft;
                  _loc19_.width = _loc22_ - this._paddingLeft - this._paddingRight;
               }
               else
               {
                  _loc10_ = _loc22_;
                  if(_loc15_ > _loc10_)
                  {
                     _loc10_ = _loc15_;
                  }
                  switch(this._horizontalAlign)
                  {
                     case "right":
                        _loc19_.x = _loc19_.pivotX + _loc30_ + _loc10_ - this._paddingRight - _loc19_.width;
                        break;
                     case "center":
                        _loc19_.x = _loc19_.pivotX + _loc30_ + this._paddingLeft + Math.round((_loc10_ - this._paddingLeft - this._paddingRight - _loc19_.width) / 2);
                        break;
                     default:
                        _loc19_.x = _loc19_.pivotX + _loc30_ + this._paddingLeft;
                  }
               }
            }
            _loc24_++;
         }
         this._discoveredItemsCache.length = 0;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentX = 0;
         param3.contentWidth = this._horizontalAlign == "justify" ? _loc22_ : _loc15_;
         if(_loc16_)
         {
            param3.contentY = -Infinity;
            param3.contentHeight = Infinity;
         }
         else
         {
            param3.contentY = 0;
            param3.contentHeight = _loc4_;
         }
         param3.viewPortWidth = _loc22_;
         param3.viewPortHeight = _loc5_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc9_:* = NaN;
         var _loc7_:* = NaN;
         if(!param3)
         {
            param3 = new Point();
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.");
         }
         var _loc10_:Number = !!param2 ? param2.explicitWidth : NaN;
         var _loc16_:Number = !!param2 ? param2.explicitHeight : NaN;
         var _loc4_:* = _loc10_ !== _loc10_;
         var _loc15_:* = _loc16_ !== _loc16_;
         if(!_loc4_ && !_loc15_)
         {
            param3.x = _loc10_;
            param3.y = _loc16_;
            return param3;
         }
         var _loc6_:Number = !!param2 ? param2.minWidth : 0;
         var _loc11_:Number = !!param2 ? param2.minHeight : 0;
         var _loc18_:Number = !!param2 ? param2.maxWidth : Infinity;
         var _loc13_:Number = !!param2 ? param2.maxHeight : Infinity;
         this.prepareTypicalItem(_loc10_ - this._paddingLeft - this._paddingRight);
         var _loc8_:Number = !!this._typicalItem ? this._typicalItem.width : 0;
         var _loc5_:Number = !!this._typicalItem ? this._typicalItem.height : 0;
         var _loc14_:Number = this._gap;
         var _loc12_:Number = 0;
         var _loc17_:* = _loc8_;
         _loc12_ = (_loc12_ += (_loc5_ + _loc14_) * param1) - _loc14_;
         if(_loc4_)
         {
            if((_loc9_ = _loc17_ + this._paddingLeft + this._paddingRight) < _loc6_)
            {
               _loc9_ = _loc6_;
            }
            else if(_loc9_ > _loc18_)
            {
               _loc9_ = _loc18_;
            }
            param3.x = _loc9_;
         }
         else
         {
            param3.x = _loc10_;
         }
         if(_loc15_)
         {
            if(this._requestedRowCount > 0)
            {
               _loc7_ = (_loc5_ + _loc14_) * this._requestedRowCount - _loc14_;
            }
            else
            {
               _loc7_ = _loc12_;
            }
            if(_loc7_ < _loc11_)
            {
               _loc7_ = _loc11_;
            }
            else if(_loc7_ > _loc13_)
            {
               _loc7_ = _loc13_;
            }
            param3.y = _loc7_;
         }
         else
         {
            param3.y = _loc16_;
         }
         return param3;
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc14_:int = 0;
         var _loc13_:int = 0;
         var _loc9_:* = 0;
         var _loc15_:int = 0;
         if(param6)
         {
            param6.length = 0;
         }
         else
         {
            param6 = new Vector.<int>(0);
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("getVisibleIndicesAtScrollPosition() may be called only if useVirtualLayout is true.");
         }
         this.prepareTypicalItem(param3 - this._paddingLeft - this._paddingRight);
         var _loc8_:Number = !!this._typicalItem ? this._typicalItem.height : 0;
         var _loc12_:Number = this._gap;
         var _loc7_:int = 0;
         var _loc11_:int = Math.ceil(param4 / (_loc8_ + _loc12_)) + 1;
         var _loc10_:Number = param5 * (_loc8_ + _loc12_) - _loc12_;
         param2 -= Math.round((param4 - _loc8_) / 2);
         var _loc16_:Boolean;
         if(_loc16_ = this._repeatItems && _loc10_ > param4)
         {
            _loc10_ += _loc12_;
            param2 %= _loc10_;
            if(param2 < 0)
            {
               param2 += _loc10_;
            }
            _loc13_ = (_loc14_ = param2 / (_loc8_ + _loc12_)) + _loc11_;
         }
         else
         {
            if((_loc14_ = param2 / (_loc8_ + _loc12_)) < 0)
            {
               _loc14_ = 0;
            }
            if((_loc13_ = _loc14_ + _loc11_) >= param5)
            {
               _loc13_ = param5 - 1;
            }
            if((_loc14_ = _loc13_ - _loc11_) < 0)
            {
               _loc14_ = 0;
            }
         }
         _loc9_ = _loc14_;
         while(_loc9_ <= _loc13_)
         {
            if(!_loc16_ || _loc9_ >= 0 && _loc9_ < param5)
            {
               param6[_loc7_] = _loc9_;
            }
            else if(_loc9_ < 0)
            {
               param6[_loc7_] = param5 + _loc9_;
            }
            else if(_loc9_ >= param5)
            {
               if((_loc15_ = _loc9_ - param5) === _loc14_)
               {
                  break;
               }
               param6[_loc7_] = _loc15_;
            }
            _loc7_++;
            _loc9_++;
         }
         return param6;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         return this.getScrollPositionForIndex(param1,param4,param5,param6,param7,param8,param9);
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         this.prepareTypicalItem(param5 - this._paddingLeft - this._paddingRight);
         var _loc8_:Number = !!this._typicalItem ? this._typicalItem.height : 0;
         if(!param7)
         {
            param7 = new Point();
         }
         param7.x = 0;
         param7.y = _loc8_ * param1;
         return param7;
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>, param2:Number, param3:Number) : void
      {
         var _loc7_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:*;
         var _loc4_:Boolean = (_loc6_ = this._horizontalAlign == "justify") && param2 === param2;
         var _loc8_:int = int(param1.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(!(!(_loc5_ = param1[_loc7_]) || _loc5_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc5_).includeInLayout))
            {
               if(_loc4_)
               {
                  _loc5_.width = param2;
               }
               else if(_loc6_ && _loc5_ is IFeathersControl)
               {
                  _loc5_.width = NaN;
               }
               if(_loc5_ is IValidating)
               {
                  IValidating(_loc5_).validate();
               }
            }
            _loc7_++;
         }
      }
      
      protected function prepareTypicalItem(param1:Number) : void
      {
         if(!this._typicalItem)
         {
            return;
         }
         if(this._horizontalAlign == "justify" && param1 === param1)
         {
            this._typicalItem.width = param1;
         }
         else if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.width = this._typicalItemWidth;
         }
         if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.height = this._typicalItemHeight;
         }
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
      }
   }
}
