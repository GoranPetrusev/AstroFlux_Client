package feathers.layout
{
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.EventDispatcher;
   
   public class VerticalLayout extends EventDispatcher implements IVariableVirtualLayout, ITrimmedVirtualLayout, IGroupedLayout
   {
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";
       
      
      protected var _heightCache:Array;
      
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
      
      protected var _stickyHeader:Boolean = false;
      
      protected var _headerIndices:Vector.<int>;
      
      protected var _useVirtualLayout:Boolean = true;
      
      protected var _hasVariableItemDimensions:Boolean = false;
      
      protected var _distributeHeights:Boolean = false;
      
      protected var _requestedRowCount:int = 0;
      
      protected var _beforeVirtualizedItemCount:int = 0;
      
      protected var _afterVirtualizedItemCount:int = 0;
      
      protected var _typicalItem:DisplayObject;
      
      protected var _resetTypicalItemDimensionsOnMeasure:Boolean = false;
      
      protected var _typicalItemWidth:Number = NaN;
      
      protected var _typicalItemHeight:Number = NaN;
      
      protected var _scrollPositionVerticalAlign:String = "middle";
      
      public function VerticalLayout()
      {
         _heightCache = [];
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
      
      public function get stickyHeader() : Boolean
      {
         return this._stickyHeader;
      }
      
      public function set stickyHeader(param1:Boolean) : void
      {
         if(this._stickyHeader == param1)
         {
            return;
         }
         this._stickyHeader = param1;
         this.dispatchEventWith("change");
      }
      
      public function get headerIndices() : Vector.<int>
      {
         return this._headerIndices;
      }
      
      public function set headerIndices(param1:Vector.<int>) : void
      {
         if(this._headerIndices == param1)
         {
            return;
         }
         this._headerIndices = param1;
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
      
      public function get distributeHeights() : Boolean
      {
         return this._distributeHeights;
      }
      
      public function set distributeHeights(param1:Boolean) : void
      {
         if(this._distributeHeights == param1)
         {
            return;
         }
         this._distributeHeights = param1;
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
      
      public function get scrollPositionVerticalAlign() : String
      {
         return this._scrollPositionVerticalAlign;
      }
      
      public function set scrollPositionVerticalAlign(param1:String) : void
      {
         this._scrollPositionVerticalAlign = param1;
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return this._useVirtualLayout || this._headerIndices && this._stickyHeader;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc25_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc42_:int = 0;
         var _loc20_:DisplayObject = null;
         var _loc11_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:* = NaN;
         var _loc7_:* = NaN;
         var _loc30_:DisplayObject = null;
         var _loc37_:Number = NaN;
         var _loc6_:ILayoutDisplayObject = null;
         var _loc18_:VerticalLayoutData = null;
         var _loc33_:Number = NaN;
         var _loc31_:IFeathersControl = null;
         var _loc29_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc12_:* = NaN;
         var _loc55_:Number = !!param2 ? param2.scrollX : 0;
         var _loc52_:Number = !!param2 ? param2.scrollY : 0;
         var _loc49_:Number = !!param2 ? param2.x : 0;
         var _loc51_:Number = !!param2 ? param2.y : 0;
         var _loc43_:Number = !!param2 ? param2.minWidth : 0;
         var _loc9_:Number = !!param2 ? param2.minHeight : 0;
         var _loc16_:Number = !!param2 ? param2.maxWidth : Infinity;
         var _loc35_:Number = !!param2 ? param2.maxHeight : Infinity;
         var _loc47_:Number = !!param2 ? param2.explicitWidth : NaN;
         var _loc53_:Number = !!param2 ? param2.explicitHeight : NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(_loc47_ - this._paddingLeft - this._paddingRight);
            _loc25_ = !!this._typicalItem ? this._typicalItem.width : 0;
            _loc23_ = !!this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc44_:* = _loc47_ !== _loc47_;
         var _loc41_:*;
         if(!(_loc41_ = _loc53_ !== _loc53_) && this._distributeHeights)
         {
            _loc38_ = this.calculateDistributedHeight(param1,_loc53_,_loc9_,_loc35_,false);
         }
         if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeHeights || this._horizontalAlign != "justify" || _loc44_)
         {
            this.validateItems(param1,_loc47_ - this._paddingLeft - this._paddingRight,_loc43_ - this._paddingLeft - this._paddingRight,_loc16_ - this._paddingLeft - this._paddingRight,_loc53_ - this._paddingTop - this._paddingBottom,_loc9_ - this._paddingTop - this._paddingBottom,_loc35_ - this._paddingTop - this._paddingBottom,_loc38_);
         }
         if(_loc41_ && this._distributeHeights)
         {
            _loc38_ = this.calculateDistributedHeight(param1,_loc53_,_loc9_,_loc35_,true);
         }
         var _loc19_:* = _loc38_ === _loc38_;
         if(!this._useVirtualLayout)
         {
            this.applyPercentHeights(param1,_loc53_,_loc9_,_loc35_);
         }
         var _loc32_:* = this._firstGap === this._firstGap;
         var _loc28_:* = this._lastGap === this._lastGap;
         var _loc54_:* = this._useVirtualLayout ? _loc25_ : 0;
         var _loc26_:Number;
         var _loc10_:* = _loc26_ = _loc51_ + this._paddingTop;
         var _loc50_:int = 0;
         var _loc45_:int;
         var _loc46_:* = _loc45_ = int(param1.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc46_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            _loc50_ = this._beforeVirtualizedItemCount;
            _loc10_ += this._beforeVirtualizedItemCount * (_loc23_ + this._gap);
            if(_loc32_ && this._beforeVirtualizedItemCount > 0)
            {
               _loc10_ = _loc10_ - this._gap + this._firstGap;
            }
         }
         var _loc17_:int = _loc46_ - 2;
         this._discoveredItemsCache.length = 0;
         var _loc34_:int = 0;
         var _loc36_:Number = 0;
         var _loc27_:int = -1;
         var _loc22_:int = -1;
         var _loc8_:int = 0;
         var _loc48_:* = Infinity;
         if(this._headerIndices && this._stickyHeader)
         {
            if((_loc8_ = int(this._headerIndices.length)) > 0)
            {
               _loc27_ = 0;
               _loc22_ = this._headerIndices[_loc27_];
            }
         }
         _loc42_ = 0;
         while(_loc42_ < _loc45_)
         {
            _loc20_ = param1[_loc42_];
            _loc11_ = _loc42_ + _loc50_;
            if(_loc22_ === _loc11_)
            {
               if(_loc10_ - _loc26_ < _loc52_)
               {
                  _loc27_++;
                  if(_loc27_ < _loc8_)
                  {
                     _loc22_ = this._headerIndices[_loc27_];
                  }
               }
               else
               {
                  _loc27_--;
                  if(_loc27_ >= 0)
                  {
                     _loc22_ = this._headerIndices[_loc27_];
                     _loc48_ = _loc10_;
                  }
               }
            }
            _loc36_ = this._gap;
            if(_loc32_ && _loc11_ == 0)
            {
               _loc36_ = this._firstGap;
            }
            else if(_loc28_ && _loc11_ > 0 && _loc11_ == _loc17_)
            {
               _loc36_ = this._lastGap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc13_ = Number(this._heightCache[_loc11_]);
            }
            if(this._useVirtualLayout && !_loc20_)
            {
               if(!this._hasVariableItemDimensions || _loc13_ !== _loc13_)
               {
                  _loc10_ += _loc23_ + _loc36_;
               }
               else
               {
                  _loc10_ += _loc13_ + _loc36_;
               }
            }
            else if(!(_loc20_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc20_).includeInLayout))
            {
               _loc20_.y = _loc20_.pivotY + _loc10_;
               _loc14_ = _loc20_.width;
               if(_loc19_)
               {
                  _loc20_.height = _loc7_ = _loc38_;
               }
               else
               {
                  _loc7_ = _loc20_.height;
               }
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc7_ != _loc13_)
                     {
                        this._heightCache[_loc11_] = _loc7_;
                        if(_loc10_ < _loc52_ && _loc13_ !== _loc13_ && _loc7_ != _loc23_)
                        {
                           this.dispatchEventWith("scroll",false,new Point(0,_loc7_ - _loc23_));
                        }
                        this.dispatchEventWith("change");
                     }
                  }
                  else if(_loc23_ >= 0)
                  {
                     _loc20_.height = _loc7_ = _loc23_;
                  }
               }
               _loc10_ += _loc7_ + _loc36_;
               if(_loc14_ > _loc54_)
               {
                  _loc54_ = _loc14_;
               }
               if(this._useVirtualLayout)
               {
                  this._discoveredItemsCache[_loc34_] = _loc20_;
                  _loc34_++;
               }
            }
            _loc42_++;
         }
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc10_ += this._afterVirtualizedItemCount * (_loc23_ + this._gap);
            if(_loc28_ && this._afterVirtualizedItemCount > 0)
            {
               _loc10_ = _loc10_ - this._gap + this._lastGap;
            }
         }
         if(_loc22_ >= 0)
         {
            _loc30_ = param1[_loc22_];
            this.positionStickyHeader(_loc30_,_loc52_,_loc48_);
         }
         var _loc39_:Vector.<DisplayObject>;
         var _loc21_:int = int((_loc39_ = this._useVirtualLayout ? this._discoveredItemsCache : param1).length);
         var _loc15_:Number = _loc54_ + this._paddingLeft + this._paddingRight;
         var _loc40_:* = _loc47_;
         if(_loc40_ !== _loc40_)
         {
            if((_loc40_ = _loc15_) < _loc43_)
            {
               _loc40_ = _loc43_;
            }
            else if(_loc40_ > _loc16_)
            {
               _loc40_ = _loc16_;
            }
         }
         var _loc4_:Number = _loc10_ - _loc36_ + this._paddingBottom - _loc51_;
         var _loc5_:* = _loc53_;
         if(_loc5_ !== _loc5_)
         {
            _loc5_ = _loc4_;
            if(this._requestedRowCount > 0)
            {
               _loc5_ = this._requestedRowCount * (_loc23_ + this._gap) - this._gap + this._paddingTop + this._paddingBottom;
            }
            else
            {
               _loc5_ = _loc4_;
            }
            if(_loc5_ < _loc9_)
            {
               _loc5_ = _loc9_;
            }
            else if(_loc5_ > _loc35_)
            {
               _loc5_ = _loc35_;
            }
         }
         if(_loc4_ < _loc5_)
         {
            _loc37_ = 0;
            if(this._verticalAlign == "bottom")
            {
               _loc37_ = _loc5_ - _loc4_;
            }
            else if(this._verticalAlign == "middle")
            {
               _loc37_ = Math.round((_loc5_ - _loc4_) / 2);
            }
            if(_loc37_ != 0)
            {
               _loc42_ = 0;
               while(_loc42_ < _loc21_)
               {
                  if(!((_loc20_ = _loc39_[_loc42_]) is ILayoutDisplayObject && !ILayoutDisplayObject(_loc20_).includeInLayout))
                  {
                     _loc20_.y += _loc37_;
                  }
                  _loc42_++;
               }
            }
         }
         _loc42_ = 0;
         while(_loc42_ < _loc21_)
         {
            if(!((_loc6_ = (_loc20_ = _loc39_[_loc42_]) as ILayoutDisplayObject) && !_loc6_.includeInLayout))
            {
               if(this._horizontalAlign == "justify")
               {
                  _loc20_.x = _loc20_.pivotX + _loc49_ + this._paddingLeft;
                  _loc20_.width = _loc40_ - this._paddingLeft - this._paddingRight;
               }
               else
               {
                  if(_loc6_)
                  {
                     if(_loc18_ = _loc6_.layoutData as VerticalLayoutData)
                     {
                        _loc33_ = _loc18_.percentWidth;
                        if(_loc33_ === _loc33_)
                        {
                           if(_loc33_ < 0)
                           {
                              _loc33_ = 0;
                           }
                           if(_loc33_ > 100)
                           {
                              _loc33_ = 100;
                           }
                           _loc14_ = _loc33_ * (_loc40_ - this._paddingLeft - this._paddingRight) / 100;
                           if(_loc20_ is IFeathersControl)
                           {
                              _loc29_ = Number((_loc31_ = IFeathersControl(_loc20_)).minWidth);
                              if(_loc14_ < _loc29_)
                              {
                                 _loc14_ = _loc29_;
                              }
                              else
                              {
                                 _loc24_ = Number(_loc31_.maxWidth);
                                 if(_loc14_ > _loc24_)
                                 {
                                    _loc14_ = _loc24_;
                                 }
                              }
                           }
                           _loc20_.width = _loc14_;
                        }
                     }
                  }
                  _loc12_ = _loc40_;
                  if(_loc15_ > _loc12_)
                  {
                     _loc12_ = _loc15_;
                  }
                  switch(this._horizontalAlign)
                  {
                     case "right":
                        _loc20_.x = _loc20_.pivotX + _loc49_ + _loc12_ - this._paddingRight - _loc20_.width;
                        break;
                     case "center":
                        _loc20_.x = _loc20_.pivotX + _loc49_ + this._paddingLeft + Math.round((_loc12_ - this._paddingLeft - this._paddingRight - _loc20_.width) / 2);
                        break;
                     default:
                        _loc20_.x = _loc20_.pivotX + _loc49_ + this._paddingLeft;
                  }
               }
            }
            _loc42_++;
         }
         this._discoveredItemsCache.length = 0;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentX = 0;
         param3.contentWidth = this._horizontalAlign == "justify" ? _loc40_ : _loc15_;
         param3.contentY = 0;
         param3.contentHeight = _loc4_;
         param3.viewPortWidth = _loc40_;
         param3.viewPortHeight = _loc5_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc14_:Number = NaN;
         var _loc20_:* = NaN;
         var _loc6_:int = 0;
         var _loc17_:Number = NaN;
         var _loc11_:* = NaN;
         var _loc9_:* = NaN;
         if(!param3)
         {
            param3 = new Point();
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.");
         }
         var _loc12_:Number = !!param2 ? param2.explicitWidth : NaN;
         var _loc19_:Number = !!param2 ? param2.explicitHeight : NaN;
         var _loc4_:* = _loc12_ !== _loc12_;
         var _loc18_:* = _loc19_ !== _loc19_;
         if(!_loc4_ && !_loc18_)
         {
            param3.x = _loc12_;
            param3.y = _loc19_;
            return param3;
         }
         var _loc7_:Number = !!param2 ? param2.minWidth : 0;
         var _loc13_:Number = !!param2 ? param2.minHeight : 0;
         var _loc21_:Number = !!param2 ? param2.maxWidth : Infinity;
         var _loc16_:Number = !!param2 ? param2.maxHeight : Infinity;
         this.prepareTypicalItem(_loc12_ - this._paddingLeft - this._paddingRight);
         var _loc10_:Number = !!this._typicalItem ? this._typicalItem.width : 0;
         var _loc5_:Number = !!this._typicalItem ? this._typicalItem.height : 0;
         var _loc8_:* = this._firstGap === this._firstGap;
         var _loc15_:* = this._lastGap === this._lastGap;
         if(this._distributeHeights)
         {
            _loc14_ = (_loc5_ + this._gap) * param1;
         }
         else
         {
            _loc14_ = 0;
            _loc20_ = _loc10_;
            if(!this._hasVariableItemDimensions)
            {
               _loc14_ += (_loc5_ + this._gap) * param1;
            }
            else
            {
               _loc6_ = 0;
               while(_loc6_ < param1)
               {
                  _loc17_ = Number(this._heightCache[_loc6_]);
                  if(_loc17_ !== _loc17_)
                  {
                     _loc14_ += _loc5_ + this._gap;
                  }
                  else
                  {
                     _loc14_ += _loc17_ + this._gap;
                  }
                  _loc6_++;
               }
            }
         }
         _loc14_ -= this._gap;
         if(_loc8_ && param1 > 1)
         {
            _loc14_ = _loc14_ - this._gap + this._firstGap;
         }
         if(_loc15_ && param1 > 2)
         {
            _loc14_ = _loc14_ - this._gap + this._lastGap;
         }
         if(_loc4_)
         {
            if((_loc11_ = _loc20_ + this._paddingLeft + this._paddingRight) < _loc7_)
            {
               _loc11_ = _loc7_;
            }
            else if(_loc11_ > _loc21_)
            {
               _loc11_ = _loc21_;
            }
            param3.x = _loc11_;
         }
         else
         {
            param3.x = _loc12_;
         }
         if(_loc18_)
         {
            if(this._requestedRowCount > 0)
            {
               _loc9_ = (_loc5_ + this._gap) * this._requestedRowCount - this._gap;
            }
            else
            {
               _loc9_ = _loc14_;
            }
            if((_loc9_ += this._paddingTop + this._paddingBottom) < _loc13_)
            {
               _loc9_ = _loc13_;
            }
            else if(_loc9_ > _loc16_)
            {
               _loc9_ = _loc16_;
            }
            param3.y = _loc9_;
         }
         else
         {
            param3.y = _loc19_;
         }
         return param3;
      }
      
      public function resetVariableVirtualCache() : void
      {
         this._heightCache.length = 0;
      }
      
      public function resetVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         delete this._heightCache[param1];
         if(param2)
         {
            this._heightCache[param1] = param2.height;
            this.dispatchEventWith("change");
         }
      }
      
      public function addToVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         var _loc3_:* = !!param2 ? param2.height : undefined;
         this._heightCache.insertAt(param1,_loc3_);
      }
      
      public function removeFromVariableVirtualCacheAtIndex(param1:int) : void
      {
         this._heightCache.removeAt(param1);
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc15_:Number = NaN;
         var _loc33_:int = 0;
         var _loc36_:int = 0;
         var _loc34_:int = 0;
         var _loc26_:* = 0;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc8_:* = NaN;
         var _loc12_:* = NaN;
         var _loc21_:Boolean = false;
         var _loc13_:int = 0;
         var _loc10_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:* = 0;
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
         var _loc27_:Number = !!this._typicalItem ? this._typicalItem.width : 0;
         var _loc24_:Number = !!this._typicalItem ? this._typicalItem.height : 0;
         var _loc11_:* = this._firstGap === this._firstGap;
         var _loc32_:* = this._lastGap === this._lastGap;
         var _loc7_:* = 0;
         var _loc30_:int = Math.ceil(param4 / (_loc24_ + this._gap)) + 1;
         if(!this._hasVariableItemDimensions)
         {
            _loc15_ = param5 * (_loc24_ + this._gap) - this._gap;
            if(_loc11_ && param5 > 1)
            {
               _loc15_ = _loc15_ - this._gap + this._firstGap;
            }
            if(_loc32_ && param5 > 2)
            {
               _loc15_ = _loc15_ - this._gap + this._lastGap;
            }
            _loc33_ = 0;
            if(_loc15_ < param4)
            {
               if(this._verticalAlign == "bottom")
               {
                  _loc33_ = Math.ceil((param4 - _loc15_) / (_loc24_ + this._gap));
               }
               else if(this._verticalAlign == "middle")
               {
                  _loc33_ = Math.ceil((param4 - _loc15_) / (_loc24_ + this._gap) / 2);
               }
            }
            if((_loc36_ = (param2 - this._paddingTop) / (_loc24_ + this._gap)) < 0)
            {
               _loc36_ = 0;
            }
            if((_loc34_ = (_loc36_ -= _loc33_) + _loc30_) >= param5)
            {
               _loc34_ = param5 - 1;
            }
            if((_loc36_ = _loc34_ - _loc30_) < 0)
            {
               _loc36_ = 0;
            }
            _loc26_ = _loc36_;
            while(_loc26_ <= _loc34_)
            {
               if(_loc26_ >= 0 && _loc26_ < param5)
               {
                  param6[_loc7_] = _loc26_;
               }
               else if(_loc26_ < 0)
               {
                  param6[_loc7_] = param5 + _loc26_;
               }
               else if(_loc26_ >= param5)
               {
                  param6[_loc7_] = _loc26_ - param5;
               }
               _loc7_++;
               _loc26_++;
            }
            return param6;
         }
         var _loc31_:int = -1;
         var _loc22_:int = -1;
         var _loc9_:int = 0;
         if(this._headerIndices && this._stickyHeader)
         {
            if((_loc9_ = int(this._headerIndices.length)) > 0)
            {
               _loc31_ = 0;
               _loc22_ = this._headerIndices[_loc31_];
            }
         }
         var _loc20_:int = param5 - 2;
         var _loc23_:Number = param2 + param4;
         var _loc28_:Number = this._paddingTop;
         var _loc29_:Boolean = false;
         var _loc14_:* = _loc28_;
         _loc26_ = 0;
         while(_loc26_ < param5)
         {
            if(_loc22_ === _loc26_)
            {
               if(_loc14_ - _loc28_ < param2)
               {
                  _loc31_++;
                  if(_loc31_ < _loc9_)
                  {
                     _loc22_ = this._headerIndices[_loc31_];
                  }
               }
               else
               {
                  _loc31_--;
                  if(_loc31_ >= 0)
                  {
                     _loc22_ = this._headerIndices[_loc31_];
                     _loc29_ = true;
                  }
               }
            }
            _loc18_ = this._gap;
            if(_loc11_ && _loc26_ == 0)
            {
               _loc18_ = this._firstGap;
            }
            else if(_loc32_ && _loc26_ > 0 && _loc26_ == _loc20_)
            {
               _loc18_ = this._lastGap;
            }
            _loc19_ = Number(this._heightCache[_loc26_]);
            if(_loc19_ !== _loc19_)
            {
               _loc8_ = _loc24_;
            }
            else
            {
               _loc8_ = _loc19_;
            }
            _loc12_ = _loc14_;
            if((_loc14_ += _loc8_ + _loc18_) > param2 && _loc12_ < _loc23_)
            {
               param6[_loc7_] = _loc26_;
               _loc7_++;
            }
            if(_loc14_ >= _loc23_)
            {
               if(!_loc29_)
               {
                  _loc31_--;
                  if(_loc31_ >= 0)
                  {
                     _loc22_ = this._headerIndices[_loc31_];
                  }
               }
               break;
            }
            _loc26_++;
         }
         if(_loc22_ >= 0 && param6.indexOf(_loc22_) < 0)
         {
            _loc21_ = false;
            _loc26_ = 0;
            while(_loc26_ < _loc7_)
            {
               if(_loc22_ <= param6[_loc26_])
               {
                  param6.insertAt(_loc26_,_loc22_);
                  _loc21_ = true;
                  break;
               }
               _loc26_++;
            }
            if(!_loc21_)
            {
               param6[_loc7_] = _loc22_;
            }
            _loc7_++;
         }
         var _loc35_:int = int(param6.length);
         var _loc25_:int;
         if((_loc25_ = _loc30_ - _loc35_) > 0 && _loc35_ > 0)
         {
            if((_loc10_ = (_loc13_ = param6[0]) - _loc25_) < 0)
            {
               _loc10_ = 0;
            }
            _loc26_ = _loc13_ - 1;
            while(_loc26_ >= _loc10_)
            {
               if(_loc26_ !== _loc22_)
               {
                  param6.insertAt(0,_loc26_);
               }
               _loc26_--;
            }
         }
         _loc35_ = int(param6.length);
         _loc25_ = _loc30_ - _loc35_;
         _loc7_ = _loc35_;
         if(_loc25_ > 0)
         {
            if((_loc17_ = (_loc16_ = int(_loc35_ > 0 ? param6[_loc35_ - 1] + 1 : 0)) + _loc25_) > param5)
            {
               _loc17_ = param5;
            }
            _loc26_ = _loc16_;
            while(_loc26_ < _loc17_)
            {
               if(_loc26_ !== _loc22_)
               {
                  param6[_loc7_] = _loc26_;
                  _loc7_++;
               }
               _loc26_++;
            }
         }
         return param6;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         var _loc11_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc10_:Number = this.calculateMaxScrollYOfIndex(param1,param4,param5,param6,param7,param8);
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc11_ = Number(this._heightCache[param1]);
               if(_loc11_ !== _loc11_)
               {
                  _loc11_ = this._typicalItem.height;
               }
            }
            else
            {
               _loc11_ = this._typicalItem.height;
            }
         }
         else
         {
            _loc11_ = param4[param1].height;
         }
         if(!param9)
         {
            param9 = new Point();
         }
         param9.x = 0;
         var _loc12_:Number = _loc10_ - (param8 - _loc11_);
         if(param3 >= _loc12_ && param3 <= _loc10_)
         {
            param9.y = param3;
         }
         else
         {
            _loc13_ = Math.abs(_loc10_ - param3);
            if((_loc14_ = Math.abs(_loc12_ - param3)) < _loc13_)
            {
               param9.y = _loc12_;
            }
            else
            {
               param9.y = _loc10_;
            }
         }
         return param9;
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         var _loc9_:Number = NaN;
         var _loc8_:Number = this.calculateMaxScrollYOfIndex(param1,param2,param3,param4,param5,param6);
         if(this._useVirtualLayout)
         {
            if(this._hasVariableItemDimensions)
            {
               _loc9_ = Number(this._heightCache[param1]);
               if(_loc9_ !== _loc9_)
               {
                  _loc9_ = this._typicalItem.height;
               }
            }
            else
            {
               _loc9_ = this._typicalItem.height;
            }
         }
         else
         {
            _loc9_ = param2[param1].height;
         }
         if(!param7)
         {
            param7 = new Point();
         }
         param7.x = 0;
         if(this._scrollPositionVerticalAlign == "middle")
         {
            _loc8_ -= Math.round((param6 - _loc9_) / 2);
         }
         else if(this._scrollPositionVerticalAlign == "bottom")
         {
            _loc8_ -= param6 - _loc9_;
         }
         param7.y = _loc8_;
         return param7;
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc23_:int = 0;
         var _loc20_:DisplayObject = null;
         var _loc12_:IFeathersControl = null;
         var _loc9_:ILayoutDisplayObject = null;
         var _loc19_:VerticalLayoutData = null;
         var _loc13_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc18_:* = NaN;
         var _loc26_:IMeasureDisplayObject = null;
         var _loc21_:Number = NaN;
         var _loc11_:* = NaN;
         var _loc15_:Number = NaN;
         var _loc22_:* = param2 !== param2;
         var _loc17_:* = param5 !== param5;
         var _loc14_:* = param2;
         if(_loc22_)
         {
            _loc14_ = param3;
         }
         var _loc25_:* = param5;
         if(_loc17_)
         {
            _loc25_ = param6;
         }
         var _loc10_:* = this._horizontalAlign == "justify";
         var _loc24_:int = int(param1.length);
         _loc23_ = 0;
         while(_loc23_ < _loc24_)
         {
            if(!(!(_loc20_ = param1[_loc23_]) || _loc20_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc20_).includeInLayout))
            {
               if(_loc10_)
               {
                  _loc20_.width = param2;
                  if(_loc20_ is IFeathersControl)
                  {
                     (_loc12_ = IFeathersControl(_loc20_)).minWidth = param3;
                     _loc12_.maxWidth = param4;
                  }
               }
               else if(_loc20_ is ILayoutDisplayObject)
               {
                  if((_loc19_ = (_loc9_ = ILayoutDisplayObject(_loc20_)).layoutData as VerticalLayoutData) !== null)
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
                        _loc20_.width = _loc18_;
                     }
                     if(_loc16_ === _loc16_)
                     {
                        _loc11_ = _loc25_ * _loc16_ / 100;
                        _loc15_ = (_loc26_ = IMeasureDisplayObject(_loc20_)).explicitMinHeight;
                        if(_loc26_.explicitMinHeight === _loc26_.explicitMinHeight && _loc11_ < _loc15_)
                        {
                           _loc11_ = _loc15_;
                        }
                        _loc26_.maxHeight = _loc11_;
                        _loc20_.height = NaN;
                     }
                  }
               }
               if(this._distributeHeights)
               {
                  _loc20_.height = param8;
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
         var _loc3_:VerticalLayoutData = null;
         var _loc5_:Number = NaN;
         if(!this._typicalItem)
         {
            return;
         }
         var _loc2_:Boolean = false;
         if(this._horizontalAlign == "justify" && param1 === param1)
         {
            _loc2_ = true;
            this._typicalItem.width = param1;
         }
         else if(this._typicalItem is ILayoutDisplayObject)
         {
            _loc3_ = (_loc4_ = ILayoutDisplayObject(this._typicalItem)).layoutData as VerticalLayoutData;
            if(_loc3_ !== null)
            {
               _loc5_ = _loc3_.percentWidth;
               if(_loc5_ === _loc5_)
               {
                  if(_loc5_ < 0)
                  {
                     _loc5_ = 0;
                  }
                  if(_loc5_ > 100)
                  {
                     _loc5_ = 100;
                  }
                  _loc2_ = true;
                  this._typicalItem.width = param1 * _loc5_ / 100;
               }
            }
         }
         if(!_loc2_ && this._resetTypicalItemDimensionsOnMeasure)
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
      
      protected function calculateDistributedHeight(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Boolean) : Number
      {
         var _loc6_:* = NaN;
         var _loc9_:int = 0;
         var _loc7_:DisplayObject = null;
         var _loc8_:Number = NaN;
         var _loc12_:Boolean = false;
         var _loc13_:* = param2 !== param2;
         var _loc10_:int = int(param1.length);
         if(param5 && _loc13_)
         {
            _loc6_ = 0;
            _loc9_ = 0;
            while(_loc9_ < _loc10_)
            {
               if((_loc8_ = (_loc7_ = param1[_loc9_]).height) > _loc6_)
               {
                  _loc6_ = _loc8_;
               }
               _loc9_++;
            }
            param2 = _loc6_ * _loc10_ + this._paddingTop + this._paddingBottom + this._gap * (_loc10_ - 1);
            _loc12_ = false;
            if(param2 > param4)
            {
               param2 = param4;
               _loc12_ = true;
            }
            else if(param2 < param3)
            {
               param2 = param3;
               _loc12_ = true;
            }
            if(!_loc12_)
            {
               return _loc6_;
            }
         }
         var _loc11_:* = param2;
         if(_loc13_ && param4 < Infinity)
         {
            _loc11_ = param4;
         }
         _loc11_ = _loc11_ - this._paddingTop - this._paddingBottom - this._gap * (_loc10_ - 1);
         if(_loc10_ > 1 && this._firstGap === this._firstGap)
         {
            _loc11_ += this._gap - this._firstGap;
         }
         if(_loc10_ > 2 && this._lastGap === this._lastGap)
         {
            _loc11_ += this._gap - this._lastGap;
         }
         return _loc11_ / _loc10_;
      }
      
      protected function applyPercentHeights(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc10_:int = 0;
         var _loc7_:DisplayObject = null;
         var _loc8_:ILayoutDisplayObject = null;
         var _loc6_:VerticalLayoutData = null;
         var _loc17_:Number = NaN;
         var _loc11_:IFeathersControl = null;
         var _loc12_:Boolean = false;
         var _loc20_:Number = NaN;
         var _loc9_:* = NaN;
         var _loc21_:* = NaN;
         var _loc18_:Number = NaN;
         var _loc5_:* = param2;
         this._discoveredItemsCache.length = 0;
         var _loc16_:Number = 0;
         var _loc19_:Number = 0;
         var _loc13_:Number = 0;
         var _loc15_:int = int(param1.length);
         var _loc14_:int = 0;
         _loc10_ = 0;
         for(; _loc10_ < _loc15_; _loc10_++)
         {
            if((_loc7_ = param1[_loc10_]) is ILayoutDisplayObject)
            {
               if(!(_loc8_ = ILayoutDisplayObject(_loc7_)).includeInLayout)
               {
                  continue;
               }
               if(_loc6_ = _loc8_.layoutData as VerticalLayoutData)
               {
                  _loc17_ = _loc6_.percentHeight;
                  if(_loc17_ === _loc17_)
                  {
                     if(_loc8_ is IFeathersControl)
                     {
                        _loc11_ = IFeathersControl(_loc8_);
                        _loc19_ += _loc11_.minHeight;
                     }
                     _loc13_ += _loc17_;
                     this._discoveredItemsCache[_loc14_] = _loc7_;
                     _loc14_++;
                     continue;
                  }
               }
            }
            _loc16_ += _loc7_.height;
         }
         _loc16_ += this._gap * (_loc15_ - 1);
         if(this._firstGap === this._firstGap && _loc15_ > 1)
         {
            _loc16_ += this._firstGap - this._gap;
         }
         else if(this._lastGap === this._lastGap && _loc15_ > 2)
         {
            _loc16_ += this._lastGap - this._gap;
         }
         _loc16_ += this._paddingTop + this._paddingBottom;
         if(_loc13_ < 100)
         {
            _loc13_ = 100;
         }
         if(_loc5_ !== _loc5_)
         {
            if((_loc5_ = _loc16_ + _loc19_) < param3)
            {
               _loc5_ = param3;
            }
            else if(_loc5_ > param4)
            {
               _loc5_ = param4;
            }
         }
         if((_loc5_ -= _loc16_) < 0)
         {
            _loc5_ = 0;
         }
         do
         {
            _loc12_ = false;
            _loc20_ = _loc5_ / _loc13_;
            _loc10_ = 0;
            while(_loc10_ < _loc14_)
            {
               if(_loc8_ = ILayoutDisplayObject(this._discoveredItemsCache[_loc10_]))
               {
                  _loc17_ = (_loc6_ = VerticalLayoutData(_loc8_.layoutData)).percentHeight;
                  _loc9_ = _loc20_ * _loc17_;
                  if(_loc8_ is IFeathersControl)
                  {
                     if((_loc21_ = Number((_loc11_ = IFeathersControl(_loc8_)).minHeight)) > _loc5_)
                     {
                        _loc21_ = _loc5_;
                     }
                     if(_loc9_ < _loc21_)
                     {
                        _loc9_ = _loc21_;
                        _loc5_ -= _loc9_;
                        _loc13_ -= _loc17_;
                        this._discoveredItemsCache[_loc10_] = null;
                        _loc12_ = true;
                     }
                     else
                     {
                        _loc18_ = Number(_loc11_.maxHeight);
                        if(_loc9_ > _loc18_)
                        {
                           _loc9_ = _loc18_;
                           _loc5_ -= _loc9_;
                           _loc13_ -= _loc17_;
                           this._discoveredItemsCache[_loc10_] = null;
                           _loc12_ = true;
                        }
                     }
                  }
                  _loc8_.height = _loc9_;
                  if(_loc8_ is IValidating)
                  {
                     IValidating(_loc8_).validate();
                  }
               }
               _loc10_++;
            }
         }
         while(_loc12_);
         
         this._discoveredItemsCache.length = 0;
      }
      
      protected function calculateMaxScrollYOfIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         var _loc13_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc11_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc18_:int = 0;
         var _loc21_:Number = NaN;
         var _loc10_:* = NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(param5 - this._paddingLeft - this._paddingRight);
            _loc13_ = !!this._typicalItem ? this._typicalItem.width : 0;
            _loc9_ = !!this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc12_:* = this._firstGap === this._firstGap;
         var _loc19_:* = this._lastGap === this._lastGap;
         var _loc16_:Number = param4 + this._paddingTop;
         var _loc23_:* = 0;
         var _loc20_:Number = this._gap;
         var _loc17_:int = 0;
         var _loc22_:Number = 0;
         var _loc14_:int;
         var _loc15_:* = _loc14_ = int(param2.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc15_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            if(param1 < this._beforeVirtualizedItemCount)
            {
               _loc17_ = param1 + 1;
               _loc23_ = _loc9_;
               _loc20_ = this._gap;
            }
            else
            {
               _loc17_ = this._beforeVirtualizedItemCount;
               if((_loc22_ = param1 - param2.length - this._beforeVirtualizedItemCount + 1) < 0)
               {
                  _loc22_ = 0;
               }
               _loc16_ += _loc22_ * (_loc9_ + this._gap);
            }
            _loc16_ += _loc17_ * (_loc9_ + this._gap);
         }
         param1 -= _loc17_ + _loc22_;
         var _loc7_:int = _loc15_ - 2;
         _loc11_ = 0;
         while(_loc11_ <= param1)
         {
            _loc8_ = param2[_loc11_];
            _loc18_ = _loc11_ + _loc17_;
            if(_loc12_ && _loc18_ == 0)
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
               _loc21_ = Number(this._heightCache[_loc18_]);
            }
            if(this._useVirtualLayout && !_loc8_)
            {
               if(!this._hasVariableItemDimensions || _loc21_ !== _loc21_)
               {
                  _loc23_ = _loc9_;
               }
               else
               {
                  _loc23_ = _loc21_;
               }
            }
            else
            {
               _loc10_ = _loc8_.height;
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc10_ != _loc21_)
                     {
                        this._heightCache[_loc18_] = _loc10_;
                        this.dispatchEventWith("change");
                     }
                  }
                  else if(_loc9_ >= 0)
                  {
                     _loc8_.height = _loc10_ = _loc9_;
                  }
               }
               _loc23_ = _loc10_;
            }
            _loc16_ += _loc23_ + _loc20_;
            _loc11_++;
         }
         return _loc16_ - (_loc23_ + _loc20_);
      }
      
      protected function positionStickyHeader(param1:DisplayObject, param2:Number, param3:Number) : void
      {
         if(!param1 || param1.y >= param2)
         {
            return;
         }
         if(param1 is IValidating)
         {
            IValidating(param1).validate();
         }
         param3 -= param1.height;
         if(param3 > param2)
         {
            param3 = param2;
         }
         param1.y = param3;
         var _loc4_:DisplayObjectContainer;
         if(_loc4_ = param1.parent)
         {
            _loc4_.setChildIndex(param1,_loc4_.numChildren - 1);
         }
      }
   }
}
