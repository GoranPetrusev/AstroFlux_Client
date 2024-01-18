package feathers.layout
{
   import feathers.core.IFeathersControl;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.EventDispatcher;
   
   public class AnchorLayout extends EventDispatcher implements ILayout
   {
      
      protected static const CIRCULAR_REFERENCE_ERROR:String = "It is impossible to create this layout due to a circular reference in the AnchorLayoutData.";
      
      private static const HELPER_POINT:Point = new Point();
       
      
      protected var _helperVector1:Vector.<DisplayObject>;
      
      protected var _helperVector2:Vector.<DisplayObject>;
      
      public function AnchorLayout()
      {
         _helperVector1 = new Vector.<DisplayObject>(0);
         _helperVector2 = new Vector.<DisplayObject>(0);
         super();
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return false;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc8_:Number = !!param2 ? param2.x : 0;
         var _loc9_:Number = !!param2 ? param2.y : 0;
         var _loc5_:Number = !!param2 ? param2.minWidth : 0;
         var _loc6_:Number = !!param2 ? param2.minHeight : 0;
         var _loc15_:Number = !!param2 ? param2.maxWidth : Infinity;
         var _loc10_:Number = !!param2 ? param2.maxHeight : Infinity;
         var _loc7_:Number = !!param2 ? param2.explicitWidth : NaN;
         var _loc13_:Number = !!param2 ? param2.explicitHeight : NaN;
         var _loc11_:* = _loc7_;
         var _loc14_:* = _loc13_;
         var _loc4_:* = _loc7_ !== _loc7_;
         var _loc12_:* = _loc13_ !== _loc13_;
         if(_loc4_ || _loc12_)
         {
            this.validateItems(param1,_loc7_,_loc13_,_loc15_,_loc10_,true);
            this.measureViewPort(param1,_loc11_,_loc14_,HELPER_POINT);
            if(_loc4_)
            {
               if((_loc11_ = HELPER_POINT.x) < _loc5_)
               {
                  _loc11_ = _loc5_;
               }
               else if(_loc11_ > _loc15_)
               {
                  _loc11_ = _loc15_;
               }
            }
            if(_loc12_)
            {
               if((_loc14_ = HELPER_POINT.y) < _loc6_)
               {
                  _loc14_ = _loc6_;
               }
               else if(_loc14_ > _loc10_)
               {
                  _loc14_ = _loc10_;
               }
            }
         }
         else
         {
            this.validateItems(param1,_loc7_,_loc13_,_loc15_,_loc10_,false);
         }
         this.layoutWithBounds(param1,_loc8_,_loc9_,_loc11_,_loc14_);
         this.measureContent(param1,_loc11_,_loc14_,HELPER_POINT);
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentWidth = HELPER_POINT.x;
         param3.contentHeight = HELPER_POINT.y;
         param3.viewPortWidth = _loc11_;
         param3.viewPortHeight = _loc14_;
         return param3;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         return this.getScrollPositionForIndex(param1,param4,param5,param6,param7,param8,param9);
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         if(!param7)
         {
            param7 = new Point();
         }
         param7.x = 0;
         param7.y = 0;
         return param7;
      }
      
      protected function measureViewPort(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Point = null) : Point
      {
         var _loc6_:* = NaN;
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
         HELPER_POINT.x = 0;
         HELPER_POINT.y = 0;
         var _loc7_:* = param1;
         var _loc8_:Vector.<DisplayObject> = this._helperVector1;
         this.measureVector(param1,_loc8_,HELPER_POINT);
         var _loc5_:Number = _loc8_.length;
         while(_loc5_ > 0)
         {
            if(_loc8_ == this._helperVector1)
            {
               _loc7_ = this._helperVector1;
               _loc8_ = this._helperVector2;
            }
            else
            {
               _loc7_ = this._helperVector2;
               _loc8_ = this._helperVector1;
            }
            this.measureVector(_loc7_,_loc8_,HELPER_POINT);
            _loc6_ = _loc5_;
            _loc5_ = _loc8_.length;
            if(_loc6_ == _loc5_)
            {
               this._helperVector1.length = 0;
               this._helperVector2.length = 0;
               throw new IllegalOperationError("It is impossible to create this layout due to a circular reference in the AnchorLayoutData.");
            }
         }
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
         if(!param4)
         {
            param4 = HELPER_POINT.clone();
         }
         return param4;
      }
      
      protected function measureVector(param1:Vector.<DisplayObject>, param2:Vector.<DisplayObject>, param3:Point = null) : Point
      {
         var _loc8_:int = 0;
         var _loc6_:DisplayObject = null;
         var _loc4_:AnchorLayoutData = null;
         var _loc7_:ILayoutDisplayObject = null;
         var _loc5_:Boolean = false;
         if(!param3)
         {
            param3 = new Point();
         }
         param2.length = 0;
         var _loc10_:int = int(param1.length);
         var _loc9_:int = 0;
         _loc8_ = 0;
         for(; _loc8_ < _loc10_; _loc8_++)
         {
            if((_loc6_ = param1[_loc8_]) is ILayoutDisplayObject)
            {
               if(!(_loc7_ = ILayoutDisplayObject(_loc6_)).includeInLayout)
               {
                  continue;
               }
               _loc4_ = _loc7_.layoutData as AnchorLayoutData;
            }
            if(!(_loc5_ = !_loc4_ || this.isReadyForLayout(_loc4_,_loc8_,param1,param2)))
            {
               param2[_loc9_] = _loc6_;
               _loc9_++;
            }
            else
            {
               this.measureItem(_loc6_,param3);
            }
         }
         return param3;
      }
      
      protected function measureItem(param1:DisplayObject, param2:Point) : void
      {
         var _loc4_:ILayoutDisplayObject = null;
         var _loc3_:AnchorLayoutData = null;
         var _loc8_:Number = NaN;
         var _loc6_:* = param2.x;
         var _loc5_:* = param2.y;
         var _loc7_:Boolean = false;
         if(param1 is ILayoutDisplayObject)
         {
            _loc3_ = (_loc4_ = ILayoutDisplayObject(param1)).layoutData as AnchorLayoutData;
            if(_loc3_)
            {
               if((_loc8_ = this.measureItemHorizontally(_loc4_,_loc3_)) > _loc6_)
               {
                  _loc6_ = _loc8_;
               }
               if((_loc8_ = this.measureItemVertically(_loc4_,_loc3_)) > _loc5_)
               {
                  _loc5_ = _loc8_;
               }
               _loc7_ = true;
            }
         }
         if(!_loc7_)
         {
            if((_loc8_ = param1.x - param1.pivotX + param1.width) > _loc6_)
            {
               _loc6_ = _loc8_;
            }
            if((_loc8_ = param1.y - param1.pivotY + param1.height) > _loc5_)
            {
               _loc5_ = _loc8_;
            }
         }
         param2.x = _loc6_;
         param2.y = _loc5_;
      }
      
      protected function measureItemHorizontally(param1:ILayoutDisplayObject, param2:AnchorLayoutData) : Number
      {
         var _loc7_:Number = NaN;
         var _loc4_:Number = Number(param1.width);
         if(param2 && param1 is IFeathersControl)
         {
            _loc7_ = param2.percentWidth;
            this.doNothing();
            if(_loc7_ === _loc7_)
            {
               _loc4_ = Number(IFeathersControl(param1).minWidth);
            }
         }
         var _loc6_:DisplayObject = DisplayObject(param1);
         var _loc3_:Number = this.getLeftOffset(_loc6_);
         var _loc5_:Number = this.getRightOffset(_loc6_);
         return _loc4_ + _loc3_ + _loc5_;
      }
      
      protected function measureItemVertically(param1:ILayoutDisplayObject, param2:AnchorLayoutData) : Number
      {
         var _loc3_:Number = NaN;
         var _loc6_:Number = Number(param1.height);
         if(param2 && param1 is IFeathersControl)
         {
            _loc3_ = param2.percentHeight;
            this.doNothing();
            if(_loc3_ === _loc3_)
            {
               _loc6_ = Number(IFeathersControl(param1).minHeight);
            }
         }
         var _loc7_:DisplayObject = DisplayObject(param1);
         var _loc4_:Number = this.getTopOffset(_loc7_);
         var _loc5_:Number = this.getBottomOffset(_loc7_);
         return _loc6_ + _loc4_ + _loc5_;
      }
      
      protected function doNothing() : void
      {
      }
      
      protected function getTopOffset(param1:DisplayObject) : Number
      {
         var _loc5_:ILayoutDisplayObject = null;
         var _loc2_:AnchorLayoutData = null;
         var _loc12_:Number = NaN;
         var _loc8_:* = false;
         var _loc4_:DisplayObject = null;
         var _loc6_:Number = NaN;
         var _loc9_:* = false;
         var _loc10_:DisplayObject = null;
         var _loc3_:Number = NaN;
         var _loc13_:* = false;
         var _loc11_:DisplayObject = null;
         var _loc7_:Number = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc2_ = (_loc5_ = ILayoutDisplayObject(param1)).layoutData as AnchorLayoutData;
            if(_loc2_)
            {
               _loc12_ = _loc2_.top;
               if(_loc8_ = _loc12_ === _loc12_)
               {
                  if(!(_loc4_ = _loc2_.topAnchorDisplayObject))
                  {
                     return _loc12_;
                  }
                  _loc12_ += _loc4_.height + this.getTopOffset(_loc4_);
               }
               else
               {
                  _loc12_ = 0;
               }
               _loc6_ = _loc2_.bottom;
               if(_loc9_ = _loc6_ === _loc6_)
               {
                  if(_loc10_ = _loc2_.bottomAnchorDisplayObject)
                  {
                     _loc12_ = Math.max(_loc12_,-_loc10_.height - _loc6_ + this.getTopOffset(_loc10_));
                  }
               }
               _loc3_ = _loc2_.verticalCenter;
               if(_loc13_ = _loc3_ === _loc3_)
               {
                  if(_loc11_ = _loc2_.verticalCenterAnchorDisplayObject)
                  {
                     _loc7_ = _loc3_ - Math.round((param1.height - _loc11_.height) / 2);
                     _loc12_ = Math.max(_loc12_,_loc7_ + this.getTopOffset(_loc11_));
                  }
                  else if(_loc3_ > 0)
                  {
                     return _loc3_ * 2;
                  }
               }
               return _loc12_;
            }
         }
         return 0;
      }
      
      protected function getRightOffset(param1:DisplayObject) : Number
      {
         var _loc3_:ILayoutDisplayObject = null;
         var _loc2_:AnchorLayoutData = null;
         var _loc4_:Number = NaN;
         var _loc6_:* = false;
         var _loc13_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc11_:* = false;
         var _loc10_:DisplayObject = null;
         var _loc5_:Number = NaN;
         var _loc12_:* = false;
         var _loc8_:DisplayObject = null;
         var _loc7_:Number = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc3_ = ILayoutDisplayObject(param1);
            _loc2_ = _loc3_.layoutData as AnchorLayoutData;
            if(_loc2_)
            {
               _loc4_ = _loc2_.right;
               if(_loc6_ = _loc4_ === _loc4_)
               {
                  if(!(_loc13_ = _loc2_.rightAnchorDisplayObject))
                  {
                     return _loc4_;
                  }
                  _loc4_ += _loc13_.width + this.getRightOffset(_loc13_);
               }
               else
               {
                  _loc4_ = 0;
               }
               _loc9_ = _loc2_.left;
               if(_loc11_ = _loc9_ === _loc9_)
               {
                  if(_loc10_ = _loc2_.leftAnchorDisplayObject)
                  {
                     _loc4_ = Math.max(_loc4_,-_loc10_.width - _loc9_ + this.getRightOffset(_loc10_));
                  }
               }
               _loc5_ = _loc2_.horizontalCenter;
               if(_loc12_ = _loc5_ === _loc5_)
               {
                  if(_loc8_ = _loc2_.horizontalCenterAnchorDisplayObject)
                  {
                     _loc7_ = -_loc5_ - Math.round((param1.width - _loc8_.width) / 2);
                     _loc4_ = Math.max(_loc4_,_loc7_ + this.getRightOffset(_loc8_));
                  }
                  else if(_loc5_ < 0)
                  {
                     return -_loc5_ * 2;
                  }
               }
               return _loc4_;
            }
         }
         return 0;
      }
      
      protected function getBottomOffset(param1:DisplayObject) : Number
      {
         var _loc5_:ILayoutDisplayObject = null;
         var _loc2_:AnchorLayoutData = null;
         var _loc6_:Number = NaN;
         var _loc9_:* = false;
         var _loc10_:DisplayObject = null;
         var _loc12_:Number = NaN;
         var _loc8_:* = false;
         var _loc4_:DisplayObject = null;
         var _loc3_:Number = NaN;
         var _loc13_:* = false;
         var _loc11_:DisplayObject = null;
         var _loc7_:Number = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc2_ = (_loc5_ = ILayoutDisplayObject(param1)).layoutData as AnchorLayoutData;
            if(_loc2_)
            {
               _loc6_ = _loc2_.bottom;
               if(_loc9_ = _loc6_ === _loc6_)
               {
                  if(!(_loc10_ = _loc2_.bottomAnchorDisplayObject))
                  {
                     return _loc6_;
                  }
                  _loc6_ += _loc10_.height + this.getBottomOffset(_loc10_);
               }
               else
               {
                  _loc6_ = 0;
               }
               _loc12_ = _loc2_.top;
               if(_loc8_ = _loc12_ === _loc12_)
               {
                  if(_loc4_ = _loc2_.topAnchorDisplayObject)
                  {
                     _loc6_ = Math.max(_loc6_,-_loc4_.height - _loc12_ + this.getBottomOffset(_loc4_));
                  }
               }
               _loc3_ = _loc2_.verticalCenter;
               if(_loc13_ = _loc3_ === _loc3_)
               {
                  if(_loc11_ = _loc2_.verticalCenterAnchorDisplayObject)
                  {
                     _loc7_ = -_loc3_ - Math.round((param1.height - _loc11_.height) / 2);
                     _loc6_ = Math.max(_loc6_,_loc7_ + this.getBottomOffset(_loc11_));
                  }
                  else if(_loc3_ < 0)
                  {
                     return -_loc3_ * 2;
                  }
               }
               return _loc6_;
            }
         }
         return 0;
      }
      
      protected function getLeftOffset(param1:DisplayObject) : Number
      {
         var _loc3_:ILayoutDisplayObject = null;
         var _loc2_:AnchorLayoutData = null;
         var _loc9_:Number = NaN;
         var _loc11_:* = false;
         var _loc10_:DisplayObject = null;
         var _loc4_:Number = NaN;
         var _loc6_:* = false;
         var _loc13_:DisplayObject = null;
         var _loc5_:Number = NaN;
         var _loc12_:* = false;
         var _loc8_:DisplayObject = null;
         var _loc7_:Number = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc3_ = ILayoutDisplayObject(param1);
            _loc2_ = _loc3_.layoutData as AnchorLayoutData;
            if(_loc2_)
            {
               _loc9_ = _loc2_.left;
               if(_loc11_ = _loc9_ === _loc9_)
               {
                  if(!(_loc10_ = _loc2_.leftAnchorDisplayObject))
                  {
                     return _loc9_;
                  }
                  _loc9_ += _loc10_.width + this.getLeftOffset(_loc10_);
               }
               else
               {
                  _loc9_ = 0;
               }
               _loc4_ = _loc2_.right;
               if(_loc6_ = _loc4_ === _loc4_)
               {
                  if(_loc13_ = _loc2_.rightAnchorDisplayObject)
                  {
                     _loc9_ = Math.max(_loc9_,-_loc13_.width - _loc4_ + this.getLeftOffset(_loc13_));
                  }
               }
               _loc5_ = _loc2_.horizontalCenter;
               if(_loc12_ = _loc5_ === _loc5_)
               {
                  if(_loc8_ = _loc2_.horizontalCenterAnchorDisplayObject)
                  {
                     _loc7_ = _loc5_ - Math.round((param1.width - _loc8_.width) / 2);
                     _loc9_ = Math.max(_loc9_,_loc7_ + this.getLeftOffset(_loc8_));
                  }
                  else if(_loc5_ > 0)
                  {
                     return _loc5_ * 2;
                  }
               }
               return _loc9_;
            }
         }
         return 0;
      }
      
      protected function layoutWithBounds(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc7_:* = NaN;
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
         var _loc8_:* = param1;
         var _loc9_:Vector.<DisplayObject> = this._helperVector1;
         this.layoutVector(param1,_loc9_,param2,param3,param4,param5);
         var _loc6_:Number = _loc9_.length;
         while(_loc6_ > 0)
         {
            if(_loc9_ == this._helperVector1)
            {
               _loc8_ = this._helperVector1;
               _loc9_ = this._helperVector2;
            }
            else
            {
               _loc8_ = this._helperVector2;
               _loc9_ = this._helperVector1;
            }
            this.layoutVector(_loc8_,_loc9_,param2,param3,param4,param5);
            _loc7_ = _loc6_;
            _loc6_ = _loc9_.length;
            if(_loc7_ == _loc6_)
            {
               this._helperVector1.length = 0;
               this._helperVector2.length = 0;
               throw new IllegalOperationError("It is impossible to create this layout due to a circular reference in the AnchorLayoutData.");
            }
         }
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
      }
      
      protected function layoutVector(param1:Vector.<DisplayObject>, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc11_:int = 0;
         var _loc9_:DisplayObject = null;
         var _loc10_:ILayoutDisplayObject = null;
         var _loc7_:AnchorLayoutData = null;
         var _loc8_:Boolean = false;
         param2.length = 0;
         var _loc13_:int = int(param1.length);
         var _loc12_:int = 0;
         _loc11_ = 0;
         while(_loc11_ < _loc13_)
         {
            if(!(!(_loc10_ = (_loc9_ = param1[_loc11_]) as ILayoutDisplayObject) || !_loc10_.includeInLayout))
            {
               if(_loc7_ = _loc10_.layoutData as AnchorLayoutData)
               {
                  if(!(_loc8_ = this.isReadyForLayout(_loc7_,_loc11_,param1,param2)))
                  {
                     param2[_loc12_] = _loc9_;
                     _loc12_++;
                  }
                  else
                  {
                     this.positionHorizontally(_loc10_,_loc7_,param3,param4,param5,param6);
                     this.positionVertically(_loc10_,_loc7_,param3,param4,param5,param6);
                  }
               }
            }
            _loc11_++;
         }
      }
      
      protected function positionHorizontally(param1:ILayoutDisplayObject, param2:AnchorLayoutData, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc19_:* = NaN;
         var _loc8_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc17_:DisplayObject = null;
         var _loc21_:DisplayObject = null;
         var _loc7_:* = NaN;
         var _loc13_:DisplayObject = null;
         var _loc22_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:IFeathersControl = param1 as IFeathersControl;
         var _loc11_:Number = param2.percentWidth;
         if(_loc11_ === _loc11_)
         {
            if(_loc11_ < 0)
            {
               _loc11_ = 0;
            }
            else if(_loc11_ > 100)
            {
               _loc11_ = 100;
            }
            _loc19_ = _loc11_ * 0.01 * param5;
            if(_loc16_)
            {
               _loc8_ = Number(_loc16_.minWidth);
               _loc23_ = Number(_loc16_.maxWidth);
               if(_loc19_ < _loc8_)
               {
                  _loc19_ = _loc8_;
               }
               else if(_loc19_ > _loc23_)
               {
                  _loc19_ = _loc23_;
               }
            }
            if(_loc19_ > param5)
            {
               _loc19_ = param5;
            }
            param1.width = _loc19_;
         }
         var _loc14_:Number = param2.left;
         var _loc18_:*;
         if(_loc18_ = _loc14_ === _loc14_)
         {
            if(_loc17_ = param2.leftAnchorDisplayObject)
            {
               param1.x = param1.pivotX + _loc17_.x - _loc17_.pivotX + _loc17_.width + _loc14_;
            }
            else
            {
               param1.x = param1.pivotX + param3 + _loc14_;
            }
         }
         var _loc10_:Number = param2.horizontalCenter;
         var _loc20_:* = _loc10_ === _loc10_;
         var _loc9_:Number = param2.right;
         var _loc12_:*;
         if(_loc12_ = _loc9_ === _loc9_)
         {
            _loc21_ = param2.rightAnchorDisplayObject;
            if(_loc18_)
            {
               _loc7_ = param5;
               if(_loc21_)
               {
                  _loc7_ = _loc21_.x - _loc21_.pivotX;
               }
               if(_loc17_)
               {
                  _loc7_ -= _loc17_.x - _loc17_.pivotX + _loc17_.width;
               }
               param1.width = _loc7_ - _loc9_ - _loc14_;
            }
            else if(_loc20_)
            {
               if(_loc13_ = param2.horizontalCenterAnchorDisplayObject)
               {
                  _loc22_ = _loc13_.x - _loc13_.pivotX + Math.round(_loc13_.width / 2) + _loc10_;
               }
               else
               {
                  _loc22_ = Math.round(param5 / 2) + _loc10_;
               }
               if(_loc21_)
               {
                  _loc15_ = _loc21_.x - _loc21_.pivotX - _loc9_;
               }
               else
               {
                  _loc15_ = param5 - _loc9_;
               }
               param1.width = 2 * (_loc15_ - _loc22_);
               param1.x = param1.pivotX + param5 - _loc9_ - param1.width;
            }
            else if(_loc21_)
            {
               param1.x = param1.pivotX + _loc21_.x - _loc21_.pivotX - param1.width - _loc9_;
            }
            else
            {
               param1.x = param1.pivotX + param3 + param5 - _loc9_ - param1.width;
            }
         }
         else if(_loc20_)
         {
            if(_loc13_ = param2.horizontalCenterAnchorDisplayObject)
            {
               _loc22_ = _loc13_.x - _loc13_.pivotX + Math.round(_loc13_.width / 2) + _loc10_;
            }
            else
            {
               _loc22_ = Math.round(param5 / 2) + _loc10_;
            }
            if(_loc18_)
            {
               param1.width = 2 * (_loc22_ - param1.x + param1.pivotX);
            }
            else
            {
               param1.x = param1.pivotX + _loc22_ - Math.round(param1.width / 2);
            }
         }
      }
      
      protected function positionVertically(param1:ILayoutDisplayObject, param2:AnchorLayoutData, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc10_:* = NaN;
         var _loc12_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc8_:DisplayObject = null;
         var _loc14_:DisplayObject = null;
         var _loc22_:* = NaN;
         var _loc15_:DisplayObject = null;
         var _loc16_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc20_:IFeathersControl = param1 as IFeathersControl;
         var _loc17_:Number = param2.percentHeight;
         if(_loc17_ === _loc17_)
         {
            if(_loc17_ < 0)
            {
               _loc17_ = 0;
            }
            else if(_loc17_ > 100)
            {
               _loc17_ = 100;
            }
            _loc10_ = _loc17_ * 0.01 * param6;
            if(_loc20_)
            {
               _loc12_ = Number(_loc20_.minHeight);
               _loc19_ = Number(_loc20_.maxHeight);
               if(_loc10_ < _loc12_)
               {
                  _loc10_ = _loc12_;
               }
               else if(_loc10_ > _loc19_)
               {
                  _loc10_ = _loc19_;
               }
            }
            if(_loc10_ > param6)
            {
               _loc10_ = param6;
            }
            param1.height = _loc10_;
         }
         var _loc18_:Number = param2.top;
         var _loc11_:*;
         if(_loc11_ = _loc18_ === _loc18_)
         {
            if(_loc8_ = param2.topAnchorDisplayObject)
            {
               param1.y = param1.pivotY + _loc8_.y - _loc8_.pivotY + _loc8_.height + _loc18_;
            }
            else
            {
               param1.y = param1.pivotY + param4 + _loc18_;
            }
         }
         var _loc7_:Number = param2.verticalCenter;
         var _loc21_:* = _loc7_ === _loc7_;
         var _loc9_:Number = param2.bottom;
         var _loc13_:*;
         if(_loc13_ = _loc9_ === _loc9_)
         {
            _loc14_ = param2.bottomAnchorDisplayObject;
            if(_loc11_)
            {
               _loc22_ = param6;
               if(_loc14_)
               {
                  _loc22_ = _loc14_.y - _loc14_.pivotY;
               }
               if(_loc8_)
               {
                  _loc22_ -= _loc8_.y - _loc8_.pivotY + _loc8_.height;
               }
               param1.height = _loc22_ - _loc9_ - _loc18_;
            }
            else if(_loc21_)
            {
               if(_loc15_ = param2.verticalCenterAnchorDisplayObject)
               {
                  _loc16_ = _loc15_.y - _loc15_.pivotY + Math.round(_loc15_.height / 2) + _loc7_;
               }
               else
               {
                  _loc16_ = Math.round(param6 / 2) + _loc7_;
               }
               if(_loc14_)
               {
                  _loc23_ = _loc14_.y - _loc14_.pivotY - _loc9_;
               }
               else
               {
                  _loc23_ = param6 - _loc9_;
               }
               param1.height = 2 * (_loc23_ - _loc16_);
               param1.y = param1.pivotY + param6 - _loc9_ - param1.height;
            }
            else if(_loc14_)
            {
               param1.y = param1.pivotY + _loc14_.y - _loc14_.pivotY - param1.height - _loc9_;
            }
            else
            {
               param1.y = param1.pivotY + param4 + param6 - _loc9_ - param1.height;
            }
         }
         else if(_loc21_)
         {
            if(_loc15_ = param2.verticalCenterAnchorDisplayObject)
            {
               _loc16_ = _loc15_.y - _loc15_.pivotY + Math.round(_loc15_.height / 2) + _loc7_;
            }
            else
            {
               _loc16_ = Math.round(param6 / 2) + _loc7_;
            }
            if(_loc11_)
            {
               param1.height = 2 * (_loc16_ - param1.y + param1.pivotY);
            }
            else
            {
               param1.y = param1.pivotY + _loc16_ - Math.round(param1.height / 2);
            }
         }
      }
      
      protected function measureContent(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Point = null) : Point
      {
         var _loc9_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc10_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:* = param2;
         var _loc7_:* = param3;
         var _loc11_:int = int(param1.length);
         _loc9_ = 0;
         while(_loc9_ < _loc11_)
         {
            _loc10_ = (_loc5_ = param1[_loc9_]).x - _loc5_.pivotX + _loc5_.width;
            _loc6_ = _loc5_.y - _loc5_.pivotY + _loc5_.height;
            if(_loc10_ === _loc10_ && _loc10_ > _loc8_)
            {
               _loc8_ = _loc10_;
            }
            if(_loc6_ === _loc6_ && _loc6_ > _loc7_)
            {
               _loc7_ = _loc6_;
            }
            _loc9_++;
         }
         param4.x = _loc8_;
         param4.y = _loc7_;
         return param4;
      }
      
      protected function isReadyForLayout(param1:AnchorLayoutData, param2:int, param3:Vector.<DisplayObject>, param4:Vector.<DisplayObject>) : Boolean
      {
         var _loc10_:int = param2 + 1;
         var _loc9_:DisplayObject;
         if((_loc9_ = param1.leftAnchorDisplayObject) && (param3.indexOf(_loc9_,_loc10_) >= _loc10_ || param4.indexOf(_loc9_) >= 0))
         {
            return false;
         }
         var _loc11_:DisplayObject;
         if((_loc11_ = param1.rightAnchorDisplayObject) && (param3.indexOf(_loc11_,_loc10_) >= _loc10_ || param4.indexOf(_loc11_) >= 0))
         {
            return false;
         }
         var _loc5_:DisplayObject;
         if((_loc5_ = param1.topAnchorDisplayObject) && (param3.indexOf(_loc5_,_loc10_) >= _loc10_ || param4.indexOf(_loc5_) >= 0))
         {
            return false;
         }
         var _loc6_:DisplayObject;
         if((_loc6_ = param1.bottomAnchorDisplayObject) && (param3.indexOf(_loc6_,_loc10_) >= _loc10_ || param4.indexOf(_loc6_) >= 0))
         {
            return false;
         }
         var _loc7_:DisplayObject;
         if((_loc7_ = param1.horizontalCenterAnchorDisplayObject) && (param3.indexOf(_loc7_,_loc10_) >= _loc10_ || param4.indexOf(_loc7_) >= 0))
         {
            return false;
         }
         var _loc8_:DisplayObject;
         if((_loc8_ = param1.verticalCenterAnchorDisplayObject) && (param3.indexOf(_loc8_,_loc10_) >= _loc10_ || param4.indexOf(_loc8_) >= 0))
         {
            return false;
         }
         return true;
      }
      
      protected function isReferenced(param1:DisplayObject, param2:Vector.<DisplayObject>) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:ILayoutDisplayObject = null;
         var _loc3_:AnchorLayoutData = null;
         var _loc6_:int = int(param2.length);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            if(!(!(_loc5_ = param2[_loc4_] as ILayoutDisplayObject) || _loc5_ == param1))
            {
               _loc3_ = _loc5_.layoutData as AnchorLayoutData;
               if(_loc3_)
               {
                  if(_loc3_.leftAnchorDisplayObject == param1 || _loc3_.horizontalCenterAnchorDisplayObject == param1 || _loc3_.rightAnchorDisplayObject == param1 || _loc3_.topAnchorDisplayObject == param1 || _loc3_.verticalCenterAnchorDisplayObject == param1 || _loc3_.bottomAnchorDisplayObject == param1)
                  {
                     return true;
                  }
               }
            }
            _loc4_++;
         }
         return false;
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean) : void
      {
         var _loc25_:int = 0;
         var _loc26_:IFeathersControl = null;
         var _loc15_:ILayoutDisplayObject = null;
         var _loc20_:AnchorLayoutData = null;
         var _loc34_:Number = NaN;
         var _loc35_:* = false;
         var _loc33_:DisplayObject = null;
         var _loc27_:Number = NaN;
         var _loc7_:DisplayObject = null;
         var _loc10_:* = false;
         var _loc11_:Number = NaN;
         var _loc17_:* = false;
         var _loc9_:Number = NaN;
         var _loc19_:* = false;
         var _loc13_:Number = NaN;
         var _loc24_:* = false;
         var _loc28_:DisplayObject = null;
         var _loc23_:Number = NaN;
         var _loc31_:* = false;
         var _loc8_:DisplayObject = null;
         var _loc14_:Number = NaN;
         var _loc29_:* = false;
         var _loc21_:Number = NaN;
         var _loc16_:* = false;
         var _loc22_:* = param2 !== param2;
         var _loc18_:* = param3 !== param3;
         var _loc12_:* = param2;
         if(_loc22_ && param4 < Infinity)
         {
            _loc12_ = param4;
         }
         var _loc32_:* = param3;
         if(_loc18_ && param5 < Infinity)
         {
            _loc32_ = param5;
         }
         var _loc30_:int = int(param1.length);
         _loc25_ = 0;
         for(; _loc25_ < _loc30_; _loc25_++)
         {
            if(_loc26_ = param1[_loc25_] as IFeathersControl)
            {
               if(_loc26_ is ILayoutDisplayObject)
               {
                  if(!(_loc15_ = ILayoutDisplayObject(_loc26_)).includeInLayout)
                  {
                     continue;
                  }
                  if(_loc20_ = _loc15_.layoutData as AnchorLayoutData)
                  {
                     _loc34_ = _loc20_.left;
                     _loc35_ = _loc34_ === _loc34_;
                     _loc33_ = _loc20_.leftAnchorDisplayObject;
                     _loc27_ = _loc20_.right;
                     _loc7_ = _loc20_.rightAnchorDisplayObject;
                     _loc10_ = _loc27_ === _loc27_;
                     _loc11_ = _loc20_.percentWidth;
                     _loc17_ = _loc11_ === _loc11_;
                     if(!_loc22_)
                     {
                        if(_loc35_ && _loc33_ === null && _loc10_ && _loc7_ === null)
                        {
                           _loc26_.width = _loc12_ - _loc34_ - _loc27_;
                        }
                        else if(_loc17_)
                        {
                           if(_loc11_ < 0)
                           {
                              _loc11_ = 0;
                           }
                           else if(_loc11_ > 100)
                           {
                              _loc11_ = 100;
                           }
                           _loc26_.width = _loc11_ * 0.01 * _loc12_;
                        }
                     }
                     _loc9_ = _loc20_.horizontalCenter;
                     _loc19_ = _loc9_ === _loc9_;
                     _loc13_ = _loc20_.top;
                     _loc24_ = _loc13_ === _loc13_;
                     _loc28_ = _loc20_.topAnchorDisplayObject;
                     _loc23_ = _loc20_.bottom;
                     _loc31_ = _loc23_ === _loc23_;
                     _loc8_ = _loc20_.bottomAnchorDisplayObject;
                     _loc14_ = _loc20_.percentHeight;
                     _loc29_ = _loc14_ === _loc14_;
                     if(!_loc18_)
                     {
                        if(_loc24_ && _loc28_ === null && _loc31_ && _loc8_ === null)
                        {
                           _loc26_.height = _loc32_ - _loc13_ - _loc23_;
                        }
                        else if(_loc29_)
                        {
                           if(_loc14_ < 0)
                           {
                              _loc14_ = 0;
                           }
                           else if(_loc14_ > 100)
                           {
                              _loc14_ = 100;
                           }
                           _loc26_.height = _loc14_ * 0.01 * _loc32_;
                        }
                     }
                     _loc21_ = _loc20_.verticalCenter;
                     _loc16_ = _loc21_ === _loc21_;
                     if(_loc10_ && !_loc35_ && !_loc19_ || _loc19_)
                     {
                        _loc26_.validate();
                        continue;
                     }
                     if(_loc31_ && !_loc24_ && !_loc16_ || _loc16_)
                     {
                        _loc26_.validate();
                        continue;
                     }
                  }
               }
               if(param6)
               {
                  _loc26_.validate();
               }
               else if(this.isReferenced(DisplayObject(_loc26_),param1))
               {
                  _loc26_.validate();
               }
            }
         }
      }
   }
}
