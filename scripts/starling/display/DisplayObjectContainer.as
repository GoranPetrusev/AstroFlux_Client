package starling.display
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.utils.getQualifiedClassName;
   import starling.core.starling_internal;
   import starling.errors.AbstractClassError;
   import starling.events.Event;
   import starling.filters.FragmentFilter;
   import starling.rendering.BatchToken;
   import starling.rendering.Painter;
   import starling.utils.MatrixUtil;
   
   use namespace starling_internal;
   
   public class DisplayObjectContainer extends DisplayObject
   {
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sBroadcastListeners:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private static var sSortBuffer:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private static var sCacheToken:BatchToken = new BatchToken();
       
      
      private var _children:Vector.<DisplayObject>;
      
      private var _touchGroup:Boolean;
      
      public function DisplayObjectContainer()
      {
         super();
         if(Capabilities.isDebugger && getQualifiedClassName(this) == "starling.display::DisplayObjectContainer")
         {
            throw new AbstractClassError();
         }
         _children = new Vector.<DisplayObject>(0);
      }
      
      private static function mergeSort(param1:Vector.<DisplayObject>, param2:Function, param3:int, param4:int, param5:Vector.<DisplayObject>) : void
      {
         var _loc9_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:* = 0;
         var _loc6_:int = 0;
         if(param4 > 1)
         {
            _loc7_ = param3 + param4;
            _loc8_ = param4 / 2;
            _loc10_ = param3;
            _loc6_ = param3 + _loc8_;
            mergeSort(param1,param2,param3,_loc8_,param5);
            mergeSort(param1,param2,param3 + _loc8_,param4 - _loc8_,param5);
            _loc9_ = 0;
            while(_loc9_ < param4)
            {
               if(_loc10_ < param3 + _loc8_ && (_loc6_ == _loc7_ || param2(param1[_loc10_],param1[_loc6_]) <= 0))
               {
                  param5[_loc9_] = param1[_loc10_];
                  _loc10_++;
               }
               else
               {
                  param5[_loc9_] = param1[_loc6_];
                  _loc6_++;
               }
               _loc9_++;
            }
            _loc9_ = param3;
            while(_loc9_ < _loc7_)
            {
               param1[_loc9_] = param5[_loc9_ - param3];
               _loc9_++;
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         _loc1_ = _children.length - 1;
         while(_loc1_ >= 0)
         {
            _children[_loc1_].dispose();
            _loc1_--;
         }
         super.dispose();
      }
      
      public function addChild(param1:DisplayObject) : DisplayObject
      {
         return addChildAt(param1,_children.length);
      }
      
      public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = int(_children.length);
         if(param2 >= 0 && param2 <= _loc4_)
         {
            setRequiresRedraw();
            if(param1.parent == this)
            {
               setChildIndex(param1,param2);
            }
            else
            {
               _children.insertAt(param2,param1);
               param1.removeFromParent();
               param1.starling_internal::setParent(this);
               param1.dispatchEventWith("added",true);
               if(stage)
               {
                  _loc3_ = param1 as DisplayObjectContainer;
                  if(_loc3_)
                  {
                     _loc3_.broadcastEventWith("addedToStage");
                  }
                  else
                  {
                     param1.dispatchEventWith("addedToStage");
                  }
               }
            }
            return param1;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChild(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:int = getChildIndex(param1);
         if(_loc3_ != -1)
         {
            return removeChildAt(_loc3_,param2);
         }
         return null;
      }
      
      public function removeChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:DisplayObjectContainer = null;
         if(param1 >= 0 && param1 < _children.length)
         {
            setRequiresRedraw();
            (_loc4_ = _children[param1]).dispatchEventWith("removed",true);
            if(stage)
            {
               _loc3_ = _loc4_ as DisplayObjectContainer;
               if(_loc3_)
               {
                  _loc3_.broadcastEventWith("removedFromStage");
               }
               else
               {
                  _loc4_.dispatchEventWith("removedFromStage");
               }
            }
            _loc4_.starling_internal::setParent(null);
            param1 = _children.indexOf(_loc4_);
            if(param1 >= 0)
            {
               _children.removeAt(param1);
            }
            if(param2)
            {
               _loc4_.dispose();
            }
            return _loc4_;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChildren(param1:int = 0, param2:int = -1, param3:Boolean = false) : void
      {
         var _loc4_:* = 0;
         if(param2 < 0 || param2 >= numChildren)
         {
            param2 = numChildren - 1;
         }
         _loc4_ = param1;
         while(_loc4_ <= param2)
         {
            removeChildAt(param1,param3);
            _loc4_++;
         }
      }
      
      public function getChildAt(param1:int) : DisplayObject
      {
         var _loc2_:int = int(_children.length);
         if(param1 < 0)
         {
            param1 = _loc2_ + param1;
         }
         if(param1 >= 0 && param1 < _loc2_)
         {
            return _children[param1];
         }
         throw new RangeError("Invalid child index");
      }
      
      public function getChildByName(param1:String) : DisplayObject
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(_children.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(_children[_loc3_].name == param1)
            {
               return _children[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getChildIndex(param1:DisplayObject) : int
      {
         return _children.indexOf(param1);
      }
      
      public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         var _loc3_:int = getChildIndex(param1);
         if(_loc3_ == param2)
         {
            return;
         }
         if(_loc3_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         _children.removeAt(_loc3_);
         _children.insertAt(param2,param1);
         setRequiresRedraw();
      }
      
      public function swapChildren(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:int = getChildIndex(param1);
         var _loc4_:int = getChildIndex(param2);
         if(_loc3_ == -1 || _loc4_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         swapChildrenAt(_loc3_,_loc4_);
      }
      
      public function swapChildrenAt(param1:int, param2:int) : void
      {
         var _loc4_:DisplayObject = getChildAt(param1);
         var _loc3_:DisplayObject = getChildAt(param2);
         _children[param1] = _loc3_;
         _children[param2] = _loc4_;
         setRequiresRedraw();
      }
      
      public function sortChildren(param1:Function) : void
      {
         sSortBuffer.length = _children.length;
         mergeSort(_children,param1,0,_children.length,sSortBuffer);
         sSortBuffer.length = 0;
         setRequiresRedraw();
      }
      
      public function contains(param1:DisplayObject) : Boolean
      {
         while(param1)
         {
            if(param1 == this)
            {
               return true;
            }
            param1 = param1.parent;
         }
         return false;
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         var _loc4_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc8_:int = 0;
         if(param2 == null)
         {
            param2 = new Rectangle();
         }
         var _loc7_:int;
         if((_loc7_ = int(_children.length)) == 0)
         {
            getTransformationMatrix(param1,sHelperMatrix);
            MatrixUtil.transformCoords(sHelperMatrix,0,0,sHelperPoint);
            param2.setTo(sHelperPoint.x,sHelperPoint.y,0,0);
         }
         else if(_loc7_ == 1)
         {
            _children[0].getBounds(param1,param2);
         }
         else
         {
            _loc4_ = 1.7976931348623157e+308;
            var _loc6_:Number = -1.7976931348623157e+308;
            _loc3_ = 1.7976931348623157e+308;
            var _loc5_:Number = -1.7976931348623157e+308;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _children[_loc8_].getBounds(param1,param2);
               if(_loc4_ > param2.x)
               {
                  _loc4_ = param2.x;
               }
               if(_loc6_ < param2.right)
               {
                  _loc6_ = param2.right;
               }
               if(_loc3_ > param2.y)
               {
                  _loc3_ = param2.y;
               }
               if(_loc5_ < param2.bottom)
               {
                  _loc5_ = param2.bottom;
               }
               _loc8_++;
            }
            param2.setTo(_loc4_,_loc3_,_loc6_ - _loc4_,_loc5_ - _loc3_);
         }
         return param2;
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc4_:int = 0;
         var _loc7_:DisplayObject = null;
         if(!visible || !touchable || !hitTestMask(param1))
         {
            return null;
         }
         var _loc6_:DisplayObject = null;
         var _loc5_:Number = param1.x;
         var _loc2_:Number = param1.y;
         var _loc3_:int = int(_children.length);
         _loc4_ = _loc3_ - 1;
         while(_loc4_ >= 0)
         {
            if(!(_loc7_ = _children[_loc4_]).isMask)
            {
               sHelperMatrix.copyFrom(_loc7_.transformationMatrix);
               sHelperMatrix.invert();
               MatrixUtil.transformCoords(sHelperMatrix,_loc5_,_loc2_,sHelperPoint);
               if(_loc6_ = _loc7_.hitTest(sHelperPoint))
               {
                  return _touchGroup ? this : _loc6_;
               }
            }
            _loc4_--;
         }
         return null;
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc7_:int = 0;
         var _loc10_:DisplayObject = null;
         var _loc9_:BatchToken = null;
         var _loc3_:BatchToken = null;
         var _loc2_:FragmentFilter = null;
         var _loc11_:DisplayObject = null;
         var _loc6_:int = int(_children.length);
         var _loc5_:uint;
         var _loc4_:* = (_loc5_ = param1.frameID) != 0;
         var _loc8_:* = _lastParentOrSelfChangeFrameID == _loc5_;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            if((_loc10_ = _children[_loc7_])._hasVisibleArea)
            {
               if(_loc8_)
               {
                  _loc10_._lastParentOrSelfChangeFrameID = _loc5_;
               }
               if(false && _loc10_._lastParentOrSelfChangeFrameID != _loc5_ && _loc10_._lastChildChangeFrameID != _loc5_ && _loc10_._tokenFrameID == _loc5_ - 1 && _loc4_)
               {
                  param1.pushState(sCacheToken);
                  param1.drawFromCache(_loc10_._pushToken,_loc10_._popToken);
                  param1.popState(_loc10_._popToken);
                  _loc10_._pushToken.copyFrom(sCacheToken);
               }
               else
               {
                  _loc9_ = _loc4_ ? _loc10_._pushToken : null;
                  _loc3_ = _loc4_ ? _loc10_._popToken : null;
                  _loc2_ = _loc10_._filter;
                  _loc11_ = _loc10_._mask;
                  param1.pushState(_loc9_);
                  param1.setStateTo(_loc10_.transformationMatrix,_loc10_.alpha,_loc10_.blendMode);
                  if(_loc11_)
                  {
                     param1.drawMask(_loc11_,_loc10_);
                  }
                  if(_loc2_)
                  {
                     _loc2_.render(param1);
                  }
                  else
                  {
                     _loc10_.render(param1);
                  }
                  if(_loc11_)
                  {
                     param1.eraseMask(_loc11_,_loc10_);
                  }
                  param1.popState(_loc3_);
               }
               if(_loc4_)
               {
                  _loc10_._tokenFrameID = _loc5_;
               }
            }
            _loc7_++;
         }
      }
      
      public function broadcastEvent(param1:Event) : void
      {
         var _loc3_:* = 0;
         if(param1.bubbles)
         {
            throw new ArgumentError("Broadcast of bubbling events is prohibited");
         }
         var _loc4_:int = int(sBroadcastListeners.length);
         getChildEventListeners(this,param1.type,sBroadcastListeners);
         var _loc2_:int = int(sBroadcastListeners.length);
         _loc3_ = _loc4_;
         while(_loc3_ < _loc2_)
         {
            sBroadcastListeners[_loc3_].dispatchEvent(param1);
            _loc3_++;
         }
         sBroadcastListeners.length = _loc4_;
      }
      
      public function broadcastEventWith(param1:String, param2:Object = null) : void
      {
         var _loc3_:Event = Event.starling_internal::fromPool(param1,false,param2);
         broadcastEvent(_loc3_);
         Event.starling_internal::toPool(_loc3_);
      }
      
      public function get numChildren() : int
      {
         return _children.length;
      }
      
      public function get touchGroup() : Boolean
      {
         return _touchGroup;
      }
      
      public function set touchGroup(param1:Boolean) : void
      {
         _touchGroup = param1;
      }
      
      internal function getChildEventListeners(param1:DisplayObject, param2:String, param3:Vector.<DisplayObject>) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if(param1.hasEventListener(param2))
         {
            param3[param3.length] = param1;
         }
         if(_loc4_)
         {
            _loc6_ = int((_loc5_ = _loc4_._children).length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               getChildEventListeners(_loc5_[_loc7_],param2,param3);
               _loc7_++;
            }
         }
      }
   }
}
