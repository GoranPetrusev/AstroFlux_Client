package feathers.layout
{
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.EventDispatcher;
   
   public class HorizontalLayout extends EventDispatcher implements IVariableVirtualLayout, ITrimmedVirtualLayout
   {
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
       
      
      protected var _widthCache:Array;
      
      protected var _discoveredItemsCache:Vector.<DisplayObject>;
      
      protected var _gap:Number = 0;
      
      protected var _firstGap:Number = NaN;
      
      protected var _lastGap:Number = NaN;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _verticalAlign:String = "top";
      
      protected var _horizontalAlign:String = "left";
      
      protected var _useVirtualLayout:Boolean = true;
      
      protected var _hasVariableItemDimensions:Boolean = false;
      
      protected var _requestedColumnCount:int = 0;
      
      protected var _distributeWidths:Boolean = false;
      
      protected var _beforeVirtualizedItemCount:int = 0;
      
      protected var _afterVirtualizedItemCount:int = 0;
      
      protected var _typicalItem:DisplayObject;
      
      protected var _resetTypicalItemDimensionsOnMeasure:Boolean = false;
      
      protected var _typicalItemWidth:Number = NaN;
      
      protected var _typicalItemHeight:Number = NaN;
      
      protected var _scrollPositionHorizontalAlign:String = "center";
      
      public function HorizontalLayout()
      {
         _widthCache = [];
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
         this.dispatchEventWith("change");
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
         this.dispatchEventWith("change");
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
         this.dispatchEventWith("change");
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
      
      public function get hasVariableItemDimensions() : Boolean
      {
         return this._hasVariableItemDimensions;
      }
      
      public function set hasVariableItemDimensions(param1:Boolean) : void
      {
         if(this._hasVariableItemDimensions == param1)
         {
            return;
         }
         this._hasVariableItemDimensions = param1;
         this.dispatchEventWith("change");
      }
      
      public function get requestedColumnCount() : int
      {
         return this._requestedColumnCount;
      }
      
      public function set requestedColumnCount(param1:int) : void
      {
         if(param1 < 0)
         {
            throw RangeError("requestedColumnCount requires a value >= 0");
         }
         if(this._requestedColumnCount == param1)
         {
            return;
         }
         this._requestedColumnCount = param1;
         this.dispatchEventWith("change");
      }
      
      public function get distributeWidths() : Boolean
      {
         return this._distributeWidths;
      }
      
      public function set distributeWidths(param1:Boolean) : void
      {
         if(this._distributeWidths == param1)
         {
            return;
         }
         this._distributeWidths = param1;
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
      
      public function get scrollPositionHorizontalAlign() : String
      {
         return this._scrollPositionHorizontalAlign;
      }
      
      public function set scrollPositionHorizontalAlign(param1:String) : void
      {
         this._scrollPositionHorizontalAlign = param1;
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return this._useVirtualLayout;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc35_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:int = 0;
         var _loc25_:DisplayObject = null;
         var _loc14_:int = 0;
         var _loc38_:Number = NaN;
         var _loc19_:* = NaN;
         var _loc8_:* = NaN;
         var _loc44_:Number = NaN;
         var _loc7_:ILayoutDisplayObject = null;
         var _loc23_:HorizontalLayoutData = null;
         var _loc16_:Number = NaN;
         var _loc10_:IFeathersControl = null;
         var _loc48_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc6_:* = NaN;
         var _loc47_:Number = !!param2 ? param2.scrollX : 0;
         var _loc45_:Number = !!param2 ? param2.scrollY : 0;
         var _loc40_:Number = !!param2 ? param2.x : 0;
         var _loc42_:Number = !!param2 ? param2.y : 0;
         var _loc33_:Number = !!param2 ? param2.minWidth : 0;
         var _loc13_:Number = !!param2 ? param2.minHeight : 0;
         var _loc21_:Number = !!param2 ? param2.maxWidth : Infinity;
         var _loc17_:Number = !!param2 ? param2.maxHeight : Infinity;
         var _loc39_:Number = !!param2 ? param2.explicitWidth : NaN;
         var _loc46_:Number = !!param2 ? param2.explicitHeight : NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(_loc46_ - this._paddingTop - this._paddingBottom);
            _loc35_ = !!this._typicalItem ? this._typicalItem.width : 0;
            _loc30_ = !!this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc34_:* = _loc39_ !== _loc39_;
         var _loc29_:* = _loc46_ !== _loc46_;
         if(!_loc34_ && this._distributeWidths)
         {
            _loc31_ = this.calculateDistributedWidth(param1,_loc39_,_loc33_,_loc21_,false);
         }
         if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeWidths || this._verticalAlign != "justify" || _loc29_)
         {
            this.validateItems(param1,_loc46_ - this._paddingTop - this._paddingBottom,_loc13_ - this._paddingTop - this._paddingBottom,_loc17_ - this._paddingTop - this._paddingBottom,_loc39_ - this._paddingLeft - this._paddingRight,_loc33_ - this._paddingLeft - this._paddingRight,_loc21_ - this._paddingLeft - this._paddingRight,_loc31_);
         }
         if(_loc34_ && this._distributeWidths)
         {
            _loc31_ = this.calculateDistributedWidth(param1,_loc39_,_loc33_,_loc21_,false);
         }
         var _loc9_:* = _loc31_ === _loc31_;
         if(!this._useVirtualLayout)
         {
            this.applyPercentWidths(param1,_loc39_,_loc33_,_loc21_);
         }
         var _loc11_:* = this._firstGap === this._firstGap;
         var _loc41_:* = this._lastGap === this._lastGap;
         var _loc24_:* = this._useVirtualLayout ? _loc30_ : 0;
         var _loc12_:Number = _loc40_ + this._paddingLeft;
         var _loc36_:int;
         var _loc37_:* = _loc36_ = int(param1.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc37_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            _loc12_ += this._beforeVirtualizedItemCount * (_loc35_ + this._gap);
            if(_loc11_ && this._beforeVirtualizedItemCount > 0)
            {
               _loc12_ = _loc12_ - this._gap + this._firstGap;
            }
         }
         var _loc22_:int = _loc37_ - 2;
         this._discoveredItemsCache.length = 0;
         var _loc15_:int = 0;
         var _loc18_:Number = 0;
         _loc32_ = 0;
         while(_loc32_ < _loc36_)
         {
            _loc25_ = param1[_loc32_];
            _loc14_ = _loc32_ + this._beforeVirtualizedItemCount;
            _loc18_ = this._gap;
            if(_loc11_ && _loc14_ == 0)
            {
               _loc18_ = this._firstGap;
            }
            else if(_loc41_ && _loc14_ > 0 && _loc14_ == _loc22_)
            {
               _loc18_ = this._lastGap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc38_ = Number(this._widthCache[_loc14_]);
            }
            if(this._useVirtualLayout && !_loc25_)
            {
               if(!this._hasVariableItemDimensions || _loc38_ !== _loc38_)
               {
                  _loc12_ += _loc35_ + _loc18_;
               }
               else
               {
                  _loc12_ += _loc38_ + _loc18_;
               }
            }
            else if(!(_loc25_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc25_).includeInLayout))
            {
               _loc25_.x = _loc25_.pivotX + _loc12_;
               if(_loc9_)
               {
                  _loc25_.width = _loc19_ = _loc31_;
               }
               else
               {
                  _loc19_ = _loc25_.width;
               }
               _loc8_ = _loc25_.height;
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc19_ != _loc38_)
                     {
                        this._widthCache[_loc14_] = _loc19_;
                        if(_loc12_ < _loc47_ && _loc38_ !== _loc38_ && _loc19_ != _loc35_)
                        {
                           this.dispatchEventWith("scroll",false,new Point(_loc19_ - _loc35_,0));
                        }
                        this.dispatchEventWith("change");
                     }
                  }
                  else if(_loc35_ >= 0)
                  {
                     _loc25_.width = _loc19_ = _loc35_;
                  }
               }
               _loc12_ += _loc19_ + _loc18_;
               if(_loc8_ > _loc24_)
               {
                  _loc24_ = _loc8_;
               }
               if(this._useVirtualLayout)
               {
                  this._discoveredItemsCache[_loc15_] = _loc25_;
                  _loc15_++;
               }
            }
            _loc32_++;
         }
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc12_ += this._afterVirtualizedItemCount * (_loc35_ + this._gap);
            if(_loc41_ && this._afterVirtualizedItemCount > 0)
            {
               _loc12_ = _loc12_ - this._gap + this._lastGap;
            }
         }
         var _loc26_:Vector.<DisplayObject>;
         var _loc27_:int = int((_loc26_ = this._useVirtualLayout ? this._discoveredItemsCache : param1).length);
         var _loc4_:Number = _loc24_ + this._paddingTop + this._paddingBottom;
         var _loc5_:* = _loc46_;
         if(_loc5_ !== _loc5_)
         {
            if((_loc5_ = _loc4_) < _loc13_)
            {
               _loc5_ = _loc13_;
            }
            else if(_loc5_ > _loc17_)
            {
               _loc5_ = _loc17_;
            }
         }
         var _loc20_:Number = _loc12_ - _loc18_ + this._paddingRight - _loc40_;
         var _loc28_:* = _loc39_;
         if(_loc28_ !== _loc28_)
         {
            if(this._requestedColumnCount > 0)
            {
               _loc28_ = (_loc35_ + this._gap) * this._requestedColumnCount - this._gap + this._paddingLeft + this._paddingRight;
            }
            else
            {
               _loc28_ = _loc20_;
            }
            if(_loc28_ < _loc33_)
            {
               _loc28_ = _loc33_;
            }
            else if(_loc28_ > _loc21_)
            {
               _loc28_ = _loc21_;
            }
         }
         if(_loc20_ < _loc28_)
         {
            _loc44_ = 0;
            if(this._horizontalAlign == "right")
            {
               _loc44_ = _loc28_ - _loc20_;
            }
            else if(this._horizontalAlign == "center")
            {
               _loc44_ = Math.round((_loc28_ - _loc20_) / 2);
            }
            if(_loc44_ != 0)
            {
               _loc32_ = 0;
               while(_loc32_ < _loc27_)
               {
                  if(!((_loc25_ = _loc26_[_loc32_]) is ILayoutDisplayObject && !ILayoutDisplayObject(_loc25_).includeInLayout))
                  {
                     _loc25_.x += _loc44_;
                  }
                  _loc32_++;
               }
            }
         }
         _loc32_ = 0;
         while(_loc32_ < _loc27_)
         {
            if(!((_loc7_ = (_loc25_ = _loc26_[_loc32_]) as ILayoutDisplayObject) && !_loc7_.includeInLayout))
            {
               if(this._verticalAlign == "justify")
               {
                  _loc25_.y = _loc25_.pivotY + _loc42_ + this._paddingTop;
                  _loc25_.height = _loc5_ - this._paddingTop - this._paddingBottom;
               }
               else
               {
                  if(_loc7_)
                  {
                     if(_loc23_ = _loc7_.layoutData as HorizontalLayoutData)
                     {
                        _loc16_ = _loc23_.percentHeight;
                        if(_loc16_ === _loc16_)
                        {
                           if(_loc16_ < 0)
                           {
                              _loc16_ = 0;
                           }
                           if(_loc16_ > 100)
                           {
                              _loc16_ = 100;
                           }
                           _loc8_ = _loc16_ * (_loc5_ - this._paddingTop - this._paddingBottom) / 100;
                           if(_loc25_ is IFeathersControl)
                           {
                              _loc48_ = Number((_loc10_ = IFeathersControl(_loc25_)).minHeight);
                              if(_loc8_ < _loc48_)
                              {
                                 _loc8_ = _loc48_;
                              }
                              else
                              {
                                 _loc43_ = Number(_loc10_.maxHeight);
                                 if(_loc8_ > _loc43_)
                                 {
                                    _loc8_ = _loc43_;
                                 }
                              }
                           }
                           _loc25_.height = _loc8_;
                        }
                     }
                  }
                  _loc6_ = _loc5_;
                  if(_loc4_ > _loc6_)
                  {
                     _loc6_ = _loc4_;
                  }
                  switch(this._verticalAlign)
                  {
                     case "bottom":
                        _loc25_.y = _loc25_.pivotY + _loc42_ + _loc6_ - this._paddingBottom - _loc25_.height;
                        break;
                     case "middle":
                        _loc25_.y = _loc25_.pivotY + _loc42_ + this._paddingTop + Math.round((_loc6_ - this._paddingTop - this._paddingBottom - _loc25_.height) / 2);
                        break;
                     default:
                        _loc25_.y = _loc25_.pivotY + _loc42_ + this._paddingTop;
                  }
               }
            }
            _loc32_++;
         }
         this._discoveredItemsCache.length = 0;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentX = 0;
         param3.contentWidth = _loc20_;
         param3.contentY = 0;
         param3.contentHeight = this._verticalAlign == "justify" ? _loc5_ : _loc4_;
         param3.viewPortWidth = _loc28_;
         param3.viewPortHeight = _loc5_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc12_:Number = NaN;
         var _loc4_:* = NaN;
         var _loc7_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:* = NaN;
         var _loc10_:* = NaN;
         if(!param3)
         {
            param3 = new Point();
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.");
         }
         var _loc15_:Number = !!param2 ? param2.explicitWidth : NaN;
         var _loc20_:Number = !!param2 ? param2.explicitHeight : NaN;
         var _loc5_:* = _loc15_ !== _loc15_;
         var _loc19_:* = _loc20_ !== _loc20_;
         if(!_loc5_ && !_loc19_)
         {
            param3.x = _loc15_;
            param3.y = _loc20_;
            return param3;
         }
         var _loc8_:Number = !!param2 ? param2.minWidth : 0;
         var _loc16_:Number = !!param2 ? param2.minHeight : 0;
         var _loc21_:Number = !!param2 ? param2.maxWidth : Infinity;
         var _loc18_:Number = !!param2 ? param2.maxHeight : Infinity;
         this.prepareTypicalItem(_loc20_ - this._paddingTop - this._paddingBottom);
         var _loc11_:Number = !!this._typicalItem ? this._typicalItem.width : 0;
         var _loc6_:Number = !!this._typicalItem ? this._typicalItem.height : 0;
         var _loc9_:* = this._firstGap === this._firstGap;
         var _loc17_:* = this._lastGap === this._lastGap;
         if(this._distributeWidths)
         {
            _loc12_ = (_loc11_ + this._gap) * param1;
         }
         else
         {
            _loc12_ = 0;
            _loc4_ = _loc6_;
            if(!this._hasVariableItemDimensions)
            {
               _loc12_ += (_loc11_ + this._gap) * param1;
            }
            else
            {
               _loc7_ = 0;
               while(_loc7_ < param1)
               {
                  _loc13_ = Number(this._widthCache[_loc7_]);
                  if(_loc13_ !== _loc13_)
                  {
                     _loc12_ += _loc11_ + this._gap;
                  }
                  else
                  {
                     _loc12_ += _loc13_ + this._gap;
                  }
                  _loc7_++;
               }
            }
         }
         _loc12_ -= this._gap;
         if(_loc9_ && param1 > 1)
         {
            _loc12_ = _loc12_ - this._gap + this._firstGap;
         }
         if(_loc17_ && param1 > 2)
         {
            _loc12_ = _loc12_ - this._gap + this._lastGap;
         }
         if(_loc5_)
         {
            if(this._requestedColumnCount > 0)
            {
               _loc14_ = (_loc11_ + this._gap) * this._requestedColumnCount - this._gap + this._paddingLeft + this._paddingRight;
            }
            else
            {
               _loc14_ = _loc12_ + this._paddingLeft + this._paddingRight;
            }
            if(_loc14_ < _loc8_)
            {
               _loc14_ = _loc8_;
            }
            else if(_loc14_ > _loc21_)
            {
               _loc14_ = _loc21_;
            }
            param3.x = _loc14_;
         }
         else
         {
            param3.x = _loc15_;
         }
         if(_loc19_)
         {
            if((_loc10_ = _loc4_ + this._paddingTop + this._paddingBottom) < _loc16_)
            {
               _loc10_ = _loc16_;
            }
            else if(_loc10_ > _loc18_)
            {
               _loc10_ = _loc18_;
            }
            param3.y = _loc10_;
         }
         else
         {
            param3.y = _loc20_;
         }
         return param3;
      }
      
      public function resetVariableVirtualCache() : void
      {
         this._widthCache.length = 0;
      }
      
      public function resetVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         delete this._widthCache[param1];
         if(param2)
         {
            this._widthCache[param1] = param2.width;
            this.dispatchEventWith("change");
         }
      }
      
      public function addToVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         var _loc3_:* = !!param2 ? param2.width : undefined;
         this._widthCache.insertAt(param1,_loc3_);
      }
      
      public function removeFromVariableVirtualCacheAtIndex(param1:int) : void
      {
         this._widthCache.removeAt(param1);
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc8_:Number = NaN;
         var _loc27_:int = 0;
         var _loc30_:int = 0;
         var _loc28_:int = 0;
         var _loc22_:* = 0;
         var _loc16_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc17_:* = NaN;
         var _loc10_:* = NaN;
         var _loc13_:int = 0;
         var _loc9_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:* = 0;
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
         this.prepareTypicalItem(param4 - this._paddingTop - this._paddingBottom);
         var _loc23_:Number = !!this._typicalItem ? this._typicalItem.width : 0;
         var _loc20_:Number = !!this._typicalItem ? this._typicalItem.height : 0;
         var _loc11_:* = this._firstGap === this._firstGap;
         var _loc26_:* = this._lastGap === this._lastGap;
         var _loc7_:* = 0;
         var _loc25_:int = Math.ceil(param3 / (_loc23_ + this._gap)) + 1;
         if(!this._hasVariableItemDimensions)
         {
            _loc8_ = param5 * (_loc23_ + this._gap) - this._gap;
            if(_loc11_ && param5 > 1)
            {
               _loc8_ = _loc8_ - this._gap + this._firstGap;
            }
            if(_loc26_ && param5 > 2)
            {
               _loc8_ = _loc8_ - this._gap + this._lastGap;
            }
            _loc27_ = 0;
            if(_loc8_ < param3)
            {
               if(this._horizontalAlign == "right")
               {
                  _loc27_ = Math.ceil((param3 - _loc8_) / (_loc23_ + this._gap));
               }
               else if(this._horizontalAlign == "center")
               {
                  _loc27_ = Math.ceil((param3 - _loc8_) / (_loc23_ + this._gap) / 2);
               }
            }
            if((_loc30_ = (param1 - this._paddingLeft) / (_loc23_ + this._gap)) < 0)
            {
               _loc30_ = 0;
            }
            if((_loc28_ = (_loc30_ -= _loc27_) + _loc25_) >= param5)
            {
               _loc28_ = param5 - 1;
            }
            if((_loc30_ = _loc28_ - _loc25_) < 0)
            {
               _loc30_ = 0;
            }
            _loc22_ = _loc30_;
            while(_loc22_ <= _loc28_)
            {
               if(_loc22_ >= 0 && _loc22_ < param5)
               {
                  param6[_loc7_] = _loc22_;
               }
               else if(_loc22_ < 0)
               {
                  param6[_loc7_] = param5 + _loc22_;
               }
               else if(_loc22_ >= param5)
               {
                  param6[_loc7_] = _loc22_ - param5;
               }
               _loc7_++;
               _loc22_++;
            }
            return param6;
         }
         var _loc18_:int = param5 - 2;
         var _loc19_:Number = param1 + param3;
         var _loc12_:Number = this._paddingLeft;
         _loc22_ = 0;
         while(_loc22_ < param5)
         {
            _loc16_ = this._gap;
            if(_loc11_ && _loc22_ == 0)
            {
               _loc16_ = this._firstGap;
            }
            else if(_loc26_ && _loc22_ > 0 && _loc22_ == _loc18_)
            {
               _loc16_ = this._lastGap;
            }
            _loc24_ = Number(this._widthCache[_loc22_]);
            if(_loc24_ !== _loc24_)
            {
               _loc17_ = _loc23_;
            }
            else
            {
               _loc17_ = _loc24_;
            }
            _loc10_ = _loc12_;
            if((_loc12_ += _loc17_ + _loc16_) > param1 && _loc10_ < _loc19_)
            {
               param6[_loc7_] = _loc22_;
               _loc7_++;
            }
            if(_loc12_ >= _loc19_)
            {
               break;
            }
            _loc22_++;
         }
         var _loc29_:int = int(param6.length);
         var _loc21_:int;
         if((_loc21_ = _loc25_ - _loc29_) > 0 && _loc29_ > 0)
         {
            if((_loc9_ = (_loc13_ = param6[0]) - _loc21_) < 0)
            {
               _loc9_ = 0;
            }
            _loc22_ = _loc13_ - 1;
            while(_loc22_ >= _loc9_)
            {
               param6.insertAt(0,_loc22_);
               _loc22_--;
            }
         }
         _loc7_ = _loc29_ = int(param6.length);
         if((_loc21_ = _loc25_ - _loc29_) > 0)
         {
            if((_loc15_ = (_loc14_ = int(_loc29_ > 0 ? param6[_loc29_ - 1] + 1 : 0)) + _loc21_) > param5)
            {
               _loc15_ = param5;
            }
            _loc22_ = _loc14_;
            while(_loc22_ < _loc15_)
            {
               param6[_loc7_] = _loc22_;
               _loc7_++;
               _loc22_++;
            }
         }
         return param6;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         var _loc12_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc11_:Number = this.calculateMaxScrollXOfIndex(param1,param4,param5,param6,param7,param8);
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc12_ = Number(this._widthCache[param1]);
               if(_loc12_ !== _loc12_)
               {
                  _loc12_ = this._typicalItem.width;
               }
            }
            else
            {
               _loc12_ = this._typicalItem.width;
            }
         }
         else
         {
            _loc12_ = param4[param1].width;
         }
         if(!param9)
         {
            param9 = new Point();
         }
         var _loc13_:Number = _loc11_ - (param7 - _loc12_);
         if(param2 >= _loc13_ && param2 <= _loc11_)
         {
            param9.x = param2;
         }
         else
         {
            _loc10_ = Math.abs(_loc11_ - param2);
            if((_loc14_ = Math.abs(_loc13_ - param2)) < _loc10_)
            {
               param9.x = _loc13_;
            }
            else
            {
               param9.x = _loc11_;
            }
         }
         param9.y = 0;
         return param9;
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         var _loc9_:Number = NaN;
         var _loc8_:Number = this.calculateMaxScrollXOfIndex(param1,param2,param3,param4,param5,param6);
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc9_ = Number(this._widthCache[param1]);
               if(_loc9_ !== _loc9_)
               {
                  _loc9_ = this._typicalItem.width;
               }
            }
            else
            {
               _loc9_ = this._typicalItem.width;
            }
         }
         else
         {
            _loc9_ = param2[param1].width;
         }
         if(this._scrollPositionHorizontalAlign == "center")
         {
            _loc8_ -= Math.round((param5 - _loc9_) / 2);
         }
         else if(this._scrollPositionHorizontalAlign == "right")
         {
            _loc8_ -= param5 - _loc9_;
         }
         param7.x = _loc8_;
         param7.y = 0;
         return param7;
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc23_:int = 0;
         var _loc20_:DisplayObject = null;
         var _loc12_:IFeathersControl = null;
         var _loc9_:ILayoutDisplayObject = null;
         var _loc19_:HorizontalLayoutData = null;
         var _loc13_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc18_:* = NaN;
         var _loc26_:IMeasureDisplayObject = null;
         var _loc21_:Number = NaN;
         var _loc11_:* = NaN;
         var _loc15_:Number = NaN;
         var _loc22_:* = param5 !== param5;
         var _loc17_:* = param2 !== param2;
         var _loc14_:* = param5;
         if(_loc22_)
         {
            _loc14_ = param6;
         }
         var _loc25_:* = param2;
         if(_loc17_)
         {
            _loc25_ = param3;
         }
         var _loc10_:* = this._verticalAlign == "justify";
         var _loc24_:int = int(param1.length);
         _loc23_ = 0;
         while(_loc23_ < _loc24_)
         {
            if(!(!(_loc20_ = param1[_loc23_]) || _loc20_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc20_).includeInLayout))
            {
               if(this._distributeWidths)
               {
                  _loc20_.width = param8;
               }
               if(_loc10_)
               {
                  _loc20_.height = param2;
                  if(_loc20_ is IFeathersControl)
                  {
                     (_loc12_ = IFeathersControl(_loc20_)).minHeight = param3;
                     _loc12_.maxHeight = param4;
                  }
               }
               else if(_loc20_ is ILayoutDisplayObject)
               {
                  if((_loc19_ = (_loc9_ = ILayoutDisplayObject(_loc20_)).layoutData as HorizontalLayoutData) !== null)
                  {
                     _loc13_ = _loc19_.percentWidth;
                     _loc16_ = _loc19_.percentHeight;
                     if(_loc13_ === _loc13_)
                     {
                        if(_loc13_ < 0)
                        {
                           _loc13_ = 0;
                        }
                        if(_loc13_ > 100)
                        {
                           _loc13_ = 100;
                        }
                        _loc18_ = _loc14_ * _loc13_ / 100;
                        _loc21_ = (_loc26_ = IMeasureDisplayObject(_loc20_)).explicitMinWidth;
                        if(_loc26_.explicitMinWidth === _loc26_.explicitMinWidth && _loc18_ < _loc21_)
                        {
                           _loc18_ = _loc21_;
                        }
                        _loc26_.maxWidth = _loc18_;
                        _loc20_.width = NaN;
                     }
                     if(_loc16_ === _loc16_)
                     {
                        if(_loc16_ < 0)
                        {
                           _loc16_ = 0;
                        }
                        if(_loc16_ > 100)
                        {
                           _loc16_ = 100;
                        }
                        _loc11_ = _loc25_ * _loc16_ / 100;
                        _loc15_ = (_loc26_ = IMeasureDisplayObject(_loc20_)).explicitMinHeight;
                        if(_loc26_.explicitMinHeight === _loc26_.explicitMinHeight && _loc11_ < _loc15_)
                        {
                           _loc11_ = _loc15_;
                        }
                        _loc20_.height = _loc11_;
                     }
                  }
               }
               if(_loc20_ is IValidating)
               {
                  IValidating(_loc20_).validate();
               }
            }
            _loc23_++;
         }
      }
      
      protected function prepareTypicalItem(param1:Number) : void
      {
         var _loc4_:ILayoutDisplayObject = null;
         var _loc2_:VerticalLayoutData = null;
         var _loc3_:Number = NaN;
         if(!this._typicalItem)
         {
            return;
         }
         if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.width = this._typicalItemWidth;
         }
         var _loc5_:Boolean = false;
         if(this._verticalAlign == "justify" && param1 === param1)
         {
            _loc5_ = true;
            this._typicalItem.height = param1;
         }
         else if(this._typicalItem is ILayoutDisplayObject)
         {
            _loc2_ = (_loc4_ = ILayoutDisplayObject(this._typicalItem)).layoutData as VerticalLayoutData;
            if(_loc2_ !== null)
            {
               _loc3_ = _loc2_.percentHeight;
               if(_loc3_ === _loc3_)
               {
                  if(_loc3_ < 0)
                  {
                     _loc3_ = 0;
                  }
                  if(_loc3_ > 100)
                  {
                     _loc3_ = 100;
                  }
                  _loc5_ = true;
                  this._typicalItem.height = param1 * _loc3_ / 100;
               }
            }
         }
         if(!_loc5_ && this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.height = this._typicalItemHeight;
         }
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
      }
      
      protected function calculateDistributedWidth(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Boolean) : Number
      {
         var _loc13_:* = NaN;
         var _loc8_:int = 0;
         var _loc6_:DisplayObject = null;
         var _loc12_:Number = NaN;
         var _loc11_:Boolean = false;
         var _loc7_:* = param2 !== param2;
         var _loc9_:int = int(param1.length);
         if(param5 && _loc7_)
         {
            _loc13_ = 0;
            _loc8_ = 0;
            while(_loc8_ < _loc9_)
            {
               if((_loc12_ = (_loc6_ = param1[_loc8_]).width) > _loc13_)
               {
                  _loc13_ = _loc12_;
               }
               _loc8_++;
            }
            param2 = _loc13_ * _loc9_ + this._paddingLeft + this._paddingRight + this._gap * (_loc9_ - 1);
            _loc11_ = false;
            if(param2 > param4)
            {
               param2 = param4;
               _loc11_ = true;
            }
            else if(param2 < param3)
            {
               param2 = param3;
               _loc11_ = true;
            }
            if(!_loc11_)
            {
               return _loc13_;
            }
         }
         var _loc10_:* = param2;
         if(_loc7_ && param4 < Infinity)
         {
            _loc10_ = param4;
         }
         _loc10_ = _loc10_ - this._paddingLeft - this._paddingRight - this._gap * (_loc9_ - 1);
         if(_loc9_ > 1 && this._firstGap === this._firstGap)
         {
            _loc10_ += this._gap - this._firstGap;
         }
         if(_loc9_ > 2 && this._lastGap === this._lastGap)
         {
            _loc10_ += this._gap - this._lastGap;
         }
         return _loc10_ / _loc9_;
      }
      
      protected function applyPercentWidths(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc9_:int = 0;
         var _loc6_:DisplayObject = null;
         var _loc7_:ILayoutDisplayObject = null;
         var _loc5_:HorizontalLayoutData = null;
         var _loc15_:Number = NaN;
         var _loc12_:IFeathersControl = null;
         var _loc13_:Boolean = false;
         var _loc19_:Number = NaN;
         var _loc18_:* = NaN;
         var _loc17_:* = NaN;
         var _loc8_:Number = NaN;
         var _loc20_:* = param2;
         this._discoveredItemsCache.length = 0;
         var _loc21_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc16_:int = int(param1.length);
         var _loc14_:int = 0;
         _loc9_ = 0;
         for(; _loc9_ < _loc16_; _loc9_++)
         {
            if((_loc6_ = param1[_loc9_]) is ILayoutDisplayObject)
            {
               if(!(_loc7_ = ILayoutDisplayObject(_loc6_)).includeInLayout)
               {
                  continue;
               }
               if(_loc5_ = _loc7_.layoutData as HorizontalLayoutData)
               {
                  _loc15_ = _loc5_.percentWidth;
                  if(_loc15_ === _loc15_)
                  {
                     if(_loc7_ is IFeathersControl)
                     {
                        _loc12_ = IFeathersControl(_loc7_);
                        _loc10_ += _loc12_.minWidth;
                     }
                     _loc11_ += _loc15_;
                     this._discoveredItemsCache[_loc14_] = _loc6_;
                     _loc14_++;
                     continue;
                  }
               }
            }
            _loc21_ += _loc6_.width;
         }
         _loc21_ += this._gap * (_loc16_ - 1);
         if(this._firstGap === this._firstGap && _loc16_ > 1)
         {
            _loc21_ += this._firstGap - this._gap;
         }
         else if(this._lastGap === this._lastGap && _loc16_ > 2)
         {
            _loc21_ += this._lastGap - this._gap;
         }
         _loc21_ += this._paddingLeft + this._paddingRight;
         if(_loc11_ < 100)
         {
            _loc11_ = 100;
         }
         if(_loc20_ !== _loc20_)
         {
            if((_loc20_ = _loc21_ + _loc10_) < param3)
            {
               _loc20_ = param3;
            }
            else if(_loc20_ > param4)
            {
               _loc20_ = param4;
            }
         }
         if((_loc20_ -= _loc21_) < 0)
         {
            _loc20_ = 0;
         }
         do
         {
            _loc13_ = false;
            _loc19_ = _loc20_ / _loc11_;
            _loc9_ = 0;
            while(_loc9_ < _loc14_)
            {
               if(_loc7_ = ILayoutDisplayObject(this._discoveredItemsCache[_loc9_]))
               {
                  _loc15_ = (_loc5_ = HorizontalLayoutData(_loc7_.layoutData)).percentWidth;
                  _loc18_ = _loc19_ * _loc15_;
                  if(_loc7_ is IFeathersControl)
                  {
                     if((_loc17_ = Number((_loc12_ = IFeathersControl(_loc7_)).minWidth)) > _loc20_)
                     {
                        _loc17_ = _loc20_;
                     }
                     if(_loc18_ < _loc17_)
                     {
                        _loc18_ = _loc17_;
                        _loc20_ -= _loc18_;
                        _loc11_ -= _loc15_;
                        this._discoveredItemsCache[_loc9_] = null;
                        _loc13_ = true;
                     }
                     else
                     {
                        _loc8_ = Number(_loc12_.maxWidth);
                        if(_loc18_ > _loc8_)
                        {
                           _loc18_ = _loc8_;
                           _loc20_ -= _loc18_;
                           _loc11_ -= _loc15_;
                           this._discoveredItemsCache[_loc9_] = null;
                           _loc13_ = true;
                        }
                     }
                  }
                  _loc7_.width = _loc18_;
                  if(_loc7_ is IValidating)
                  {
                     IValidating(_loc7_).validate();
                  }
               }
               _loc9_++;
            }
         }
         while(_loc13_);
         
         this._discoveredItemsCache.length = 0;
      }
      
      protected function calculateMaxScrollXOfIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         var _loc12_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc18_:int = 0;
         var _loc16_:Number = NaN;
         var _loc21_:* = NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(param6 - this._paddingTop - this._paddingBottom);
            _loc12_ = !!this._typicalItem ? this._typicalItem.width : 0;
            _loc9_ = !!this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc11_:* = this._firstGap === this._firstGap;
         var _loc19_:* = this._lastGap === this._lastGap;
         var _loc13_:Number = param3 + this._paddingLeft;
         var _loc22_:* = 0;
         var _loc20_:Number = this._gap;
         var _loc17_:int = 0;
         var _loc23_:Number = 0;
         var _loc14_:int;
         var _loc15_:* = _loc14_ = int(param2.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc15_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            if(param1 < this._beforeVirtualizedItemCount)
            {
               _loc17_ = param1 + 1;
               _loc22_ = _loc12_;
               _loc20_ = this._gap;
            }
            else
            {
               _loc17_ = this._beforeVirtualizedItemCount;
               if((_loc23_ = param1 - param2.length - this._beforeVirtualizedItemCount + 1) < 0)
               {
                  _loc23_ = 0;
               }
               _loc13_ += _loc23_ * (_loc12_ + this._gap);
            }
            _loc13_ += _loc17_ * (_loc12_ + this._gap);
         }
         param1 -= _loc17_ + _loc23_;
         var _loc7_:int = _loc15_ - 2;
         _loc10_ = 0;
         while(_loc10_ <= param1)
         {
            _loc8_ = param2[_loc10_];
            _loc18_ = _loc10_ + _loc17_;
            if(_loc11_ && _loc18_ == 0)
            {
               _loc20_ = this._firstGap;
            }
            else if(_loc19_ && _loc18_ > 0 && _loc18_ == _loc7_)
            {
               _loc20_ = this._lastGap;
            }
            else
            {
               _loc20_ = this._gap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc16_ = Number(this._widthCache[_loc18_]);
            }
            if(this._useVirtualLayout && !_loc8_)
            {
               if(!this._hasVariableItemDimensions || _loc16_ !== _loc16_)
               {
                  _loc22_ = _loc12_;
               }
               else
               {
                  _loc22_ = _loc16_;
               }
            }
            else
            {
               _loc21_ = _loc8_.width;
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc21_ != _loc16_)
                     {
                        this._widthCache[_loc18_] = _loc21_;
                        this.dispatchEventWith("change");
                     }
                  }
                  else if(_loc12_ >= 0)
                  {
                     _loc8_.width = _loc21_ = _loc12_;
                  }
               }
               _loc22_ = _loc21_;
            }
            _loc13_ += _loc22_ + _loc20_;
            _loc10_++;
         }
         return _loc13_ - (_loc22_ + _loc20_);
      }
   }
}
