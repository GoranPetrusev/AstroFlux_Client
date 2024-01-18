package feathers.layout
{
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.EventDispatcher;
   
   public class FlowLayout extends EventDispatcher implements IVariableVirtualLayout
   {
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
       
      
      protected var _rowItems:Vector.<DisplayObject>;
      
      protected var _horizontalGap:Number = 0;
      
      protected var _verticalGap:Number = 0;
      
      protected var _firstHorizontalGap:Number = NaN;
      
      protected var _lastHorizontalGap:Number = NaN;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _horizontalAlign:String = "left";
      
      protected var _verticalAlign:String = "top";
      
      protected var _rowVerticalAlign:String = "top";
      
      protected var _useVirtualLayout:Boolean = true;
      
      protected var _typicalItem:DisplayObject;
      
      protected var _hasVariableItemDimensions:Boolean = true;
      
      protected var _widthCache:Array;
      
      protected var _heightCache:Array;
      
      public function FlowLayout()
      {
         _rowItems = new Vector.<DisplayObject>(0);
         _widthCache = [];
         _heightCache = [];
         super();
      }
      
      public function get gap() : Number
      {
         return this._horizontalGap;
      }
      
      public function set gap(param1:Number) : void
      {
         this.horizontalGap = param1;
         this.verticalGap = param1;
      }
      
      public function get horizontalGap() : Number
      {
         return this._horizontalGap;
      }
      
      public function set horizontalGap(param1:Number) : void
      {
         if(this._horizontalGap == param1)
         {
            return;
         }
         this._horizontalGap = param1;
         this.dispatchEventWith("change");
      }
      
      public function get verticalGap() : Number
      {
         return this._verticalGap;
      }
      
      public function set verticalGap(param1:Number) : void
      {
         if(this._verticalGap == param1)
         {
            return;
         }
         this._verticalGap = param1;
         this.dispatchEventWith("change");
      }
      
      public function get firstHorizontalGap() : Number
      {
         return this._firstHorizontalGap;
      }
      
      public function set firstHorizontalGap(param1:Number) : void
      {
         if(this._firstHorizontalGap == param1)
         {
            return;
         }
         this._firstHorizontalGap = param1;
         this.dispatchEventWith("change");
      }
      
      public function get lastHorizontalGap() : Number
      {
         return this._lastHorizontalGap;
      }
      
      public function set lastHorizontalGap(param1:Number) : void
      {
         if(this._lastHorizontalGap == param1)
         {
            return;
         }
         this._lastHorizontalGap = param1;
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
      
      public function get rowVerticalAlign() : String
      {
         return this._rowVerticalAlign;
      }
      
      public function set rowVerticalAlign(param1:String) : void
      {
         if(this._rowVerticalAlign == param1)
         {
            return;
         }
         this._rowVerticalAlign = param1;
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
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return this._useVirtualLayout;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc31_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc30_:int = 0;
         var _loc36_:Number = NaN;
         var _loc22_:DisplayObject = null;
         var _loc34_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:* = NaN;
         var _loc7_:* = NaN;
         var _loc42_:int = 0;
         var _loc8_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc29_:int = 0;
         var _loc6_:ILayoutDisplayObject = null;
         var _loc32_:* = NaN;
         var _loc13_:Number = NaN;
         var _loc37_:Number = !!param2 ? param2.x : 0;
         var _loc38_:Number = !!param2 ? param2.y : 0;
         var _loc28_:Number = !!param2 ? param2.minWidth : 0;
         var _loc11_:Number = !!param2 ? param2.minHeight : 0;
         var _loc18_:Number = !!param2 ? param2.maxWidth : Infinity;
         var _loc14_:Number = !!param2 ? param2.maxHeight : Infinity;
         var _loc35_:Number = !!param2 ? param2.explicitWidth : NaN;
         var _loc40_:Number = !!param2 ? param2.explicitHeight : NaN;
         var _loc23_:* = _loc35_ !== _loc35_;
         var _loc20_:Boolean = true;
         var _loc24_:* = _loc35_;
         if(_loc23_)
         {
            if((_loc24_ = _loc18_) === Infinity)
            {
               _loc20_ = false;
            }
         }
         if(this._useVirtualLayout)
         {
            if(this._typicalItem is IValidating)
            {
               IValidating(this._typicalItem).validate();
            }
            _loc31_ = !!this._typicalItem ? this._typicalItem.width : 0;
            _loc25_ = !!this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc27_:int = 0;
         var _loc33_:int = int(param1.length);
         var _loc12_:Number = _loc38_ + this._paddingTop;
         var _loc15_:* = 0;
         var _loc21_:* = 0;
         var _loc9_:Number = this._verticalGap;
         var _loc26_:* = this._firstHorizontalGap === this._firstHorizontalGap;
         var _loc41_:* = this._lastHorizontalGap === this._lastHorizontalGap;
         var _loc19_:int = _loc33_ - 2;
         do
         {
            if(_loc27_ > 0)
            {
               _loc12_ += _loc21_ + _loc9_;
            }
            _loc21_ = this._useVirtualLayout ? _loc25_ : 0;
            _loc10_ = _loc37_ + this._paddingLeft;
            this._rowItems.length = 0;
            _loc30_ = 0;
            _loc36_ = 0;
            for(; _loc27_ < _loc33_; _loc27_++)
            {
               _loc22_ = param1[_loc27_];
               _loc36_ = this._horizontalGap;
               if(_loc26_ && _loc27_ === 0)
               {
                  _loc36_ = this._firstHorizontalGap;
               }
               else if(_loc41_ && _loc27_ > 0 && _loc27_ == _loc19_)
               {
                  _loc36_ = this._lastHorizontalGap;
               }
               if(this._useVirtualLayout && this._hasVariableItemDimensions)
               {
                  _loc34_ = Number(this._widthCache[_loc27_]);
                  _loc16_ = Number(this._heightCache[_loc27_]);
               }
               if(this._useVirtualLayout && !_loc22_)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc34_ !== _loc34_)
                     {
                        _loc17_ = _loc31_;
                     }
                     else
                     {
                        _loc17_ = _loc34_;
                     }
                     if(_loc16_ !== _loc16_)
                     {
                        _loc7_ = _loc25_;
                     }
                     else
                     {
                        _loc7_ = _loc16_;
                     }
                  }
                  else
                  {
                     _loc17_ = _loc31_;
                     _loc7_ = _loc25_;
                  }
               }
               else
               {
                  if(_loc22_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc22_).includeInLayout)
                  {
                     continue;
                  }
                  if(_loc22_ is IValidating)
                  {
                     IValidating(_loc22_).validate();
                  }
                  _loc17_ = _loc22_.width;
                  _loc7_ = _loc22_.height;
                  if(this._useVirtualLayout)
                  {
                     if(this._hasVariableItemDimensions)
                     {
                        if(_loc17_ != _loc34_)
                        {
                           this._widthCache[_loc27_] = _loc17_;
                           this.dispatchEventWith("change");
                        }
                        if(_loc7_ != _loc16_)
                        {
                           this._heightCache[_loc27_] = _loc7_;
                           this.dispatchEventWith("change");
                        }
                     }
                     else
                     {
                        if(_loc31_ >= 0)
                        {
                           _loc22_.width = _loc17_ = _loc31_;
                        }
                        if(_loc25_ >= 0)
                        {
                           _loc22_.height = _loc7_ = _loc25_;
                        }
                     }
                  }
               }
               if(_loc20_ && _loc30_ > 0 && _loc10_ + _loc17_ > _loc24_ - this._paddingRight)
               {
                  _loc42_ = _loc27_ - 1;
                  _loc36_ = this._horizontalGap;
                  if(_loc26_ && _loc42_ === 0)
                  {
                     _loc36_ = this._firstHorizontalGap;
                  }
                  else if(_loc41_ && _loc42_ > 0 && _loc42_ == _loc19_)
                  {
                     _loc36_ = this._lastHorizontalGap;
                  }
                  break;
               }
               if(_loc22_)
               {
                  this._rowItems[this._rowItems.length] = _loc22_;
                  _loc22_.x = _loc22_.pivotX + _loc10_;
               }
               _loc10_ += _loc17_ + _loc36_;
               if(_loc7_ > _loc21_)
               {
                  _loc21_ = _loc7_;
               }
               _loc30_++;
            }
            if((_loc8_ = _loc10_ - _loc36_ + this._paddingRight - _loc37_) > _loc15_)
            {
               _loc15_ = _loc8_;
            }
            _loc30_ = int(this._rowItems.length);
            if(_loc20_)
            {
               _loc39_ = 0;
               if(this._horizontalAlign === "right")
               {
                  _loc39_ = _loc24_ - _loc8_;
               }
               else if(this._horizontalAlign === "center")
               {
                  _loc39_ = Math.round((_loc24_ - _loc8_) / 2);
               }
               if(_loc39_ != 0)
               {
                  _loc29_ = 0;
                  while(_loc29_ < _loc30_)
                  {
                     if(!((_loc22_ = this._rowItems[_loc29_]) is ILayoutDisplayObject && !ILayoutDisplayObject(_loc22_).includeInLayout))
                     {
                        _loc22_.x += _loc39_;
                     }
                     _loc29_++;
                  }
               }
            }
            _loc29_ = 0;
            while(_loc29_ < _loc30_)
            {
               if(!((_loc6_ = (_loc22_ = this._rowItems[_loc29_]) as ILayoutDisplayObject) && !_loc6_.includeInLayout))
               {
                  switch(this._rowVerticalAlign)
                  {
                     case "bottom":
                        _loc22_.y = _loc22_.pivotY + _loc12_ + _loc21_ - _loc22_.height;
                        break;
                     case "middle":
                        _loc22_.y = _loc22_.pivotY + _loc12_ + Math.round((_loc21_ - _loc22_.height) / 2);
                        break;
                     default:
                        _loc22_.y = _loc22_.pivotY + _loc12_;
                  }
               }
               _loc29_++;
            }
         }
         while(_loc27_ < _loc33_);
         
         this._rowItems.length = 0;
         if(_loc20_)
         {
            if(_loc23_)
            {
               _loc32_ = _loc24_;
               if((_loc24_ = _loc15_) < _loc28_)
               {
                  _loc24_ = _loc28_;
               }
               else if(_loc24_ > _loc18_)
               {
                  _loc24_ = _loc18_;
               }
               _loc39_ = 0;
               if(this._horizontalAlign === "right")
               {
                  _loc39_ = _loc32_ - _loc24_;
               }
               else if(this._horizontalAlign === "center")
               {
                  _loc39_ = Math.round((_loc32_ - _loc24_) / 2);
               }
               if(_loc39_ !== 0)
               {
                  _loc27_ = 0;
                  while(_loc27_ < _loc33_)
                  {
                     if(!(!(_loc22_ = param1[_loc27_]) || _loc22_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc22_).includeInLayout))
                     {
                        _loc22_.x -= _loc39_;
                     }
                     _loc27_++;
                  }
               }
            }
         }
         else
         {
            _loc24_ = _loc15_;
         }
         var _loc4_:Number = _loc12_ + _loc21_ + this._paddingBottom;
         var _loc5_:* = _loc40_;
         if(_loc5_ !== _loc5_)
         {
            if((_loc5_ = _loc4_) < _loc11_)
            {
               _loc5_ = _loc11_;
            }
            else if(_loc5_ > _loc14_)
            {
               _loc5_ = _loc14_;
            }
         }
         if(_loc4_ < _loc5_ && this._verticalAlign != "top")
         {
            _loc13_ = _loc5_ - _loc4_;
            if(this._verticalAlign === "middle")
            {
               _loc13_ /= 2;
            }
            _loc27_ = 0;
            while(_loc27_ < _loc33_)
            {
               if(!(!(_loc22_ = param1[_loc27_]) || _loc22_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc22_).includeInLayout))
               {
                  _loc22_.y += _loc13_;
               }
               _loc27_++;
            }
         }
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentX = 0;
         param3.contentWidth = _loc15_;
         param3.contentY = 0;
         param3.contentHeight = _loc4_;
         param3.viewPortWidth = _loc24_;
         param3.viewPortHeight = _loc5_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc9_:Number = NaN;
         var _loc25_:int = 0;
         var _loc29_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:Number = NaN;
         if(!param3)
         {
            param3 = new Point();
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.");
         }
         var _loc30_:Number = !!param2 ? param2.x : 0;
         var _loc31_:Number = !!param2 ? param2.y : 0;
         var _loc24_:Number = !!param2 ? param2.minWidth : 0;
         var _loc10_:Number = !!param2 ? param2.minHeight : 0;
         var _loc16_:Number = !!param2 ? param2.maxWidth : Infinity;
         var _loc12_:Number = !!param2 ? param2.maxHeight : Infinity;
         var _loc28_:Number = !!param2 ? param2.explicitWidth : NaN;
         var _loc32_:Number = !!param2 ? param2.explicitHeight : NaN;
         var _loc18_:Boolean = true;
         var _loc20_:* = _loc28_;
         if(_loc20_ !== _loc20_)
         {
            if((_loc20_ = _loc16_) === Infinity)
            {
               _loc18_ = false;
            }
         }
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
         var _loc26_:Number = !!this._typicalItem ? this._typicalItem.width : 0;
         var _loc21_:Number = !!this._typicalItem ? this._typicalItem.height : 0;
         var _loc23_:int = 0;
         var _loc11_:Number = _loc31_ + this._paddingTop;
         var _loc13_:* = 0;
         var _loc19_:* = 0;
         var _loc8_:Number = this._verticalGap;
         var _loc22_:* = this._firstHorizontalGap === this._firstHorizontalGap;
         var _loc33_:* = this._lastHorizontalGap === this._lastHorizontalGap;
         var _loc17_:int = param1 - 2;
         do
         {
            if(_loc23_ > 0)
            {
               _loc11_ += _loc19_ + _loc8_;
            }
            _loc19_ = this._useVirtualLayout ? _loc21_ : 0;
            _loc9_ = _loc30_ + this._paddingLeft;
            _loc25_ = 0;
            _loc29_ = 0;
            while(_loc23_ < param1)
            {
               _loc29_ = this._horizontalGap;
               if(_loc22_ && _loc23_ === 0)
               {
                  _loc29_ = this._firstHorizontalGap;
               }
               else if(_loc33_ && _loc23_ > 0 && _loc23_ == _loc17_)
               {
                  _loc29_ = this._lastHorizontalGap;
               }
               if(this._hasVariableItemDimensions)
               {
                  _loc27_ = Number(this._widthCache[_loc23_]);
                  _loc14_ = Number(this._heightCache[_loc23_]);
                  if(_loc27_ !== _loc27_)
                  {
                     _loc15_ = _loc26_;
                  }
                  else
                  {
                     _loc15_ = _loc27_;
                  }
                  if(_loc14_ !== _loc14_)
                  {
                     _loc6_ = _loc21_;
                  }
                  else
                  {
                     _loc6_ = _loc14_;
                  }
               }
               else
               {
                  _loc15_ = _loc26_;
                  _loc6_ = _loc21_;
               }
               if(_loc18_ && _loc25_ > 0 && _loc9_ + _loc15_ > _loc20_ - this._paddingRight)
               {
                  break;
               }
               _loc9_ += _loc15_ + _loc29_;
               if(_loc6_ > _loc19_)
               {
                  _loc19_ = _loc6_;
               }
               _loc25_++;
               _loc23_++;
            }
            if((_loc7_ = _loc9_ - _loc29_ + this._paddingRight - _loc30_) > _loc13_)
            {
               _loc13_ = _loc7_;
            }
         }
         while(_loc23_ < param1);
         
         if(_loc18_)
         {
            if(_loc28_ !== _loc28_)
            {
               if((_loc20_ = _loc13_) < _loc24_)
               {
                  _loc20_ = _loc24_;
               }
               else if(_loc20_ > _loc16_)
               {
                  _loc20_ = _loc16_;
               }
            }
         }
         else
         {
            _loc20_ = _loc13_;
         }
         var _loc4_:Number = _loc11_ + _loc19_ + this._paddingBottom;
         var _loc5_:* = _loc32_;
         if(_loc5_ !== _loc5_)
         {
            if((_loc5_ = _loc4_) < _loc10_)
            {
               _loc5_ = _loc10_;
            }
            else if(_loc5_ > _loc12_)
            {
               _loc5_ = _loc12_;
            }
         }
         param3.x = _loc20_;
         param3.y = _loc5_;
         return param3;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc10_:Number = (param9 = this.calculateMaxScrollYAndRowHeightOfIndex(param1,param4,param5,param6,param7,param8,param9)).x;
         var _loc14_:Number = param9.y;
         param9.x = 0;
         var _loc11_:Number = _loc10_ - (param8 - _loc14_);
         if(param3 >= _loc11_ && param3 <= _loc10_)
         {
            param9.y = param3;
         }
         else
         {
            _loc12_ = Math.abs(_loc10_ - param3);
            if((_loc13_ = Math.abs(_loc11_ - param3)) < _loc12_)
            {
               param9.y = _loc11_;
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
         var _loc8_:Number = (param7 = this.calculateMaxScrollYAndRowHeightOfIndex(param1,param2,param3,param4,param5,param6,param7)).x;
         var _loc10_:Number = param7.y;
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
         param7.y = _loc8_ - Math.round((param6 - _loc9_) / 2);
         return param7;
      }
      
      public function resetVariableVirtualCache() : void
      {
         this._widthCache.length = 0;
         this._heightCache.length = 0;
      }
      
      public function resetVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         delete this._widthCache[param1];
         delete this._heightCache[param1];
         if(param2)
         {
            this._widthCache[param1] = param2.width;
            this._heightCache[param1] = param2.height;
            this.dispatchEventWith("change");
         }
      }
      
      public function addToVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         var _loc3_:* = !!param2 ? param2.width : undefined;
         var _loc4_:* = !!param2 ? param2.height : undefined;
         this._widthCache.insertAt(param1,_loc3_);
         this._heightCache.insertAt(param1,_loc4_);
      }
      
      public function removeFromVariableVirtualCacheAtIndex(param1:int) : void
      {
         this._widthCache.removeAt(param1);
         this._heightCache.removeAt(param1);
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc18_:Number = NaN;
         var _loc16_:int = 0;
         var _loc21_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:* = NaN;
         var _loc12_:* = NaN;
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
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
         var _loc17_:Number = !!this._typicalItem ? this._typicalItem.width : 0;
         var _loc11_:Number = !!this._typicalItem ? this._typicalItem.height : 0;
         var _loc8_:int = 0;
         var _loc14_:int = 0;
         var _loc20_:Number = this._paddingTop;
         var _loc9_:* = 0;
         var _loc15_:Number = this._verticalGap;
         var _loc10_:Number = param2 + param4;
         var _loc13_:* = this._firstHorizontalGap === this._firstHorizontalGap;
         var _loc24_:* = this._lastHorizontalGap === this._lastHorizontalGap;
         var _loc7_:int = param5 - 2;
         do
         {
            if(_loc14_ > 0)
            {
               if((_loc20_ += _loc9_ + _loc15_) >= _loc10_)
               {
                  break;
               }
            }
            _loc9_ = _loc11_;
            _loc18_ = this._paddingLeft;
            _loc16_ = 0;
            while(_loc14_ < param5)
            {
               _loc21_ = this._horizontalGap;
               if(_loc13_ && _loc14_ === 0)
               {
                  _loc21_ = this._firstHorizontalGap;
               }
               else if(_loc24_ && _loc14_ > 0 && _loc14_ == _loc7_)
               {
                  _loc21_ = this._lastHorizontalGap;
               }
               if(this._hasVariableItemDimensions)
               {
                  _loc19_ = Number(this._widthCache[_loc14_]);
                  _loc22_ = Number(this._heightCache[_loc14_]);
               }
               if(this._hasVariableItemDimensions)
               {
                  if(_loc19_ !== _loc19_)
                  {
                     _loc23_ = _loc17_;
                  }
                  else
                  {
                     _loc23_ = _loc19_;
                  }
                  if(_loc22_ !== _loc22_)
                  {
                     _loc12_ = _loc11_;
                  }
                  else
                  {
                     _loc12_ = _loc22_;
                  }
               }
               else
               {
                  _loc23_ = _loc17_;
                  _loc12_ = _loc11_;
               }
               if(_loc16_ > 0 && _loc18_ + _loc23_ > param3 - this._paddingRight)
               {
                  break;
               }
               if(_loc20_ + _loc12_ > param2)
               {
                  param6[_loc8_] = _loc14_;
                  _loc8_++;
               }
               _loc18_ += _loc23_ + _loc21_;
               if(_loc12_ > _loc9_)
               {
                  _loc9_ = _loc12_;
               }
               _loc16_++;
               _loc14_++;
            }
         }
         while(_loc14_ < param5);
         
         return param6;
      }
      
      protected function calculateMaxScrollYAndRowHeightOfIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         var _loc15_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc14_:int = 0;
         var _loc9_:DisplayObject = null;
         var _loc18_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:* = NaN;
         var _loc11_:* = NaN;
         if(!param7)
         {
            param7 = new Point();
         }
         if(this._useVirtualLayout)
         {
            if(this._typicalItem is IValidating)
            {
               IValidating(this._typicalItem).validate();
            }
            _loc15_ = !!this._typicalItem ? this._typicalItem.width : 0;
            _loc10_ = !!this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc20_:Number = this._horizontalGap;
         var _loc13_:Number = this._verticalGap;
         var _loc8_:* = 0;
         var _loc19_:Number = param4 + this._paddingTop;
         var _loc12_:int = 0;
         var _loc16_:int = int(param2.length);
         var _loc21_:Boolean = false;
         while(!_loc21_)
         {
            if(_loc12_ > 0)
            {
               _loc19_ += _loc8_ + _loc13_;
            }
            _loc8_ = this._useVirtualLayout ? _loc10_ : 0;
            _loc17_ = param3 + this._paddingLeft;
            _loc14_ = 0;
            for(; _loc12_ < _loc16_; _loc12_++)
            {
               _loc9_ = param2[_loc12_];
               if(this._useVirtualLayout && this._hasVariableItemDimensions)
               {
                  _loc18_ = Number(this._widthCache[_loc12_]);
                  _loc22_ = Number(this._heightCache[_loc12_]);
               }
               if(this._useVirtualLayout && !_loc9_)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc18_ !== _loc18_)
                     {
                        _loc23_ = _loc15_;
                     }
                     else
                     {
                        _loc23_ = _loc18_;
                     }
                     if(_loc22_ !== _loc22_)
                     {
                        _loc11_ = _loc10_;
                     }
                     else
                     {
                        _loc11_ = _loc22_;
                     }
                  }
                  else
                  {
                     _loc23_ = _loc15_;
                     _loc11_ = _loc10_;
                  }
               }
               else
               {
                  if(_loc9_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc9_).includeInLayout)
                  {
                     continue;
                  }
                  if(_loc9_ is IValidating)
                  {
                     IValidating(_loc9_).validate();
                  }
                  _loc23_ = _loc9_.width;
                  _loc11_ = _loc9_.height;
                  if(this._useVirtualLayout && this._hasVariableItemDimensions)
                  {
                     if(this._hasVariableItemDimensions)
                     {
                        if(_loc23_ != _loc18_)
                        {
                           this._widthCache[_loc12_] = _loc23_;
                           this.dispatchEventWith("change");
                        }
                        if(_loc11_ != _loc22_)
                        {
                           this._heightCache[_loc12_] = _loc11_;
                           this.dispatchEventWith("change");
                        }
                     }
                     else
                     {
                        if(_loc15_ >= 0)
                        {
                           _loc23_ = _loc15_;
                        }
                        if(_loc10_ >= 0)
                        {
                           _loc11_ = _loc10_;
                        }
                     }
                  }
               }
               if(_loc14_ > 0 && _loc17_ + _loc23_ > param5 - this._paddingRight)
               {
                  break;
               }
               if(_loc12_ === param1)
               {
                  _loc21_ = true;
               }
               if(_loc11_ > _loc8_)
               {
                  _loc8_ = _loc11_;
               }
               _loc17_ += _loc23_ + _loc20_;
               _loc14_++;
            }
            if(_loc12_ >= _loc16_)
            {
               break;
            }
         }
         param7.setTo(_loc19_,_loc8_);
         return param7;
      }
   }
}
