package starling.animation
{
   import flash.utils.Dictionary;
   import starling.core.starling_internal;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   
   use namespace starling_internal;
   
   public class Juggler implements IAnimatable
   {
      
      private static var sCurrentObjectID:uint;
       
      
      private var _objects:Vector.<IAnimatable>;
      
      private var _objectIDs:Dictionary;
      
      private var _elapsedTime:Number;
      
      private var _timeScale:Number;
      
      public function Juggler()
      {
         super();
         _elapsedTime = 0;
         _timeScale = 1;
         _objects = new Vector.<IAnimatable>(0);
         _objectIDs = new Dictionary(true);
      }
      
      private static function getNextID() : uint
      {
         return ++sCurrentObjectID;
      }
      
      public function add(param1:IAnimatable) : uint
      {
         return addWithID(param1,getNextID());
      }
      
      private function addWithID(param1:IAnimatable, param2:uint) : uint
      {
         var _loc3_:EventDispatcher = null;
         if(param1 && !(param1 in _objectIDs))
         {
            _loc3_ = param1 as EventDispatcher;
            if(_loc3_)
            {
               _loc3_.addEventListener("removeFromJuggler",onRemove);
            }
            _objects[_objects.length] = param1;
            _objectIDs[param1] = param2;
            return param2;
         }
         return 0;
      }
      
      public function contains(param1:IAnimatable) : Boolean
      {
         return param1 in _objectIDs;
      }
      
      public function remove(param1:IAnimatable) : uint
      {
         var _loc3_:EventDispatcher = null;
         var _loc2_:int = 0;
         var _loc4_:uint = 0;
         if(param1 && param1 in _objectIDs)
         {
            _loc3_ = param1 as EventDispatcher;
            if(_loc3_)
            {
               _loc3_.removeEventListener("removeFromJuggler",onRemove);
            }
            _loc2_ = _objects.indexOf(param1);
            _objects[_loc2_] = null;
            _loc4_ = uint(_objectIDs[param1]);
            delete _objectIDs[param1];
         }
         return _loc4_;
      }
      
      public function removeByID(param1:uint) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:IAnimatable = null;
         _loc2_ = _objects.length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = _objects[_loc2_];
            if(_objectIDs[_loc3_] == param1)
            {
               remove(_loc3_);
               return param1;
            }
            _loc2_--;
         }
         return 0;
      }
      
      public function removeTweens(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Tween = null;
         if(param1 == null)
         {
            return;
         }
         _loc3_ = _objects.length - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = _objects[_loc3_] as Tween;
            if(_loc2_ && _loc2_.target == param1)
            {
               _loc2_.removeEventListener("removeFromJuggler",onRemove);
               _objects[_loc3_] = null;
               delete _objectIDs[_loc2_];
            }
            _loc3_--;
         }
      }
      
      public function removeDelayedCalls(param1:Function) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DelayedCall = null;
         if(param1 == null)
         {
            return;
         }
         _loc2_ = _objects.length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = _objects[_loc2_] as DelayedCall;
            if(_loc3_ && _loc3_.callback == param1)
            {
               _loc3_.removeEventListener("removeFromJuggler",onRemove);
               _objects[_loc2_] = null;
               delete _objectIDs[tween];
            }
            _loc2_--;
         }
      }
      
      public function containsTweens(param1:Object) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Tween = null;
         if(param1)
         {
            _loc3_ = _objects.length - 1;
            while(_loc3_ >= 0)
            {
               _loc2_ = _objects[_loc3_] as Tween;
               if(_loc2_ && _loc2_.target == param1)
               {
                  return true;
               }
               _loc3_--;
            }
         }
         return false;
      }
      
      public function containsDelayedCalls(param1:Function) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:DelayedCall = null;
         if(param1 != null)
         {
            _loc2_ = _objects.length - 1;
            while(_loc2_ >= 0)
            {
               _loc3_ = _objects[_loc2_] as DelayedCall;
               if(_loc3_ && _loc3_.callback == param1)
               {
                  return true;
               }
               _loc2_--;
            }
         }
         return false;
      }
      
      public function purge() : void
      {
         var _loc1_:int = 0;
         var _loc3_:IAnimatable = null;
         var _loc2_:EventDispatcher = null;
         _loc1_ = _objects.length - 1;
         while(_loc1_ >= 0)
         {
            _loc3_ = _objects[_loc1_];
            _loc2_ = _loc3_ as EventDispatcher;
            if(_loc2_)
            {
               _loc2_.removeEventListener("removeFromJuggler",onRemove);
            }
            _objects[_loc1_] = null;
            delete _objectIDs[_loc3_];
            _loc1_--;
         }
      }
      
      public function delayCall(param1:Function, param2:Number, ... rest) : uint
      {
         if(param1 == null)
         {
            throw new ArgumentError("call must not be null");
         }
         var _loc4_:DelayedCall;
         (_loc4_ = DelayedCall.starling_internal::fromPool(param1,param2,rest)).addEventListener("removeFromJuggler",onPooledDelayedCallComplete);
         return add(_loc4_);
      }
      
      public function repeatCall(param1:Function, param2:Number, param3:int = 0, ... rest) : uint
      {
         if(param1 == null)
         {
            throw new ArgumentError("call must not be null");
         }
         var _loc5_:DelayedCall;
         (_loc5_ = DelayedCall.starling_internal::fromPool(param1,param2,rest)).repeatCount = param3;
         _loc5_.addEventListener("removeFromJuggler",onPooledDelayedCallComplete);
         return add(_loc5_);
      }
      
      private function onPooledDelayedCallComplete(param1:Event) : void
      {
         DelayedCall.starling_internal::toPool(param1.target as DelayedCall);
      }
      
      public function tween(param1:Object, param2:Number, param3:Object) : uint
      {
         var _loc6_:Object = null;
         if(param1 == null)
         {
            throw new ArgumentError("target must not be null");
         }
         var _loc4_:Tween = Tween.starling_internal::fromPool(param1,param2);
         for(var _loc5_ in param3)
         {
            _loc6_ = param3[_loc5_];
            if(_loc4_.hasOwnProperty(_loc5_))
            {
               _loc4_[_loc5_] = _loc6_;
            }
            else
            {
               if(!param1.hasOwnProperty(Tween.getPropertyName(_loc5_)))
               {
                  throw new ArgumentError("Invalid property: " + _loc5_);
               }
               _loc4_.animate(_loc5_,_loc6_ as Number);
            }
         }
         _loc4_.addEventListener("removeFromJuggler",onPooledTweenComplete);
         return add(_loc4_);
      }
      
      private function onPooledTweenComplete(param1:Event) : void
      {
         Tween.starling_internal::toPool(param1.target as Tween);
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc5_:IAnimatable = null;
         var _loc4_:int = int(_objects.length);
         var _loc3_:int = 0;
         param1 *= _timeScale;
         if(_loc4_ == 0 || param1 == 0)
         {
            return;
         }
         _elapsedTime += param1;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            if(_loc5_ = _objects[_loc2_])
            {
               if(_loc3_ != _loc2_)
               {
                  _objects[_loc3_] = _loc5_;
                  _objects[_loc2_] = null;
               }
               _loc5_.advanceTime(param1);
               _loc3_++;
            }
            _loc2_++;
         }
         if(_loc3_ != _loc2_)
         {
            _loc4_ = int(_objects.length);
            while(_loc2_ < _loc4_)
            {
               _objects[_loc3_++] = _objects[_loc2_++];
            }
            _objects.length = _loc3_;
         }
      }
      
      private function onRemove(param1:Event) : void
      {
         var _loc2_:Tween = null;
         var _loc3_:uint = remove(param1.target as IAnimatable);
         if(_loc3_)
         {
            _loc2_ = param1.target as Tween;
            if(_loc2_ && _loc2_.isComplete)
            {
               addWithID(_loc2_.nextTween,_loc3_);
            }
         }
      }
      
      public function get elapsedTime() : Number
      {
         return _elapsedTime;
      }
      
      public function get timeScale() : Number
      {
         return _timeScale;
      }
      
      public function set timeScale(param1:Number) : void
      {
         _timeScale = param1;
      }
      
      protected function get objects() : Vector.<IAnimatable>
      {
         return _objects;
      }
   }
}
