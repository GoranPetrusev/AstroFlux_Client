package starling.animation
{
   import starling.core.starling_internal;
   import starling.events.EventDispatcher;
   
   use namespace starling_internal;
   
   public class DelayedCall extends EventDispatcher implements IAnimatable
   {
      
      private static var sPool:Vector.<DelayedCall> = new Vector.<DelayedCall>(0);
       
      
      private var _currentTime:Number;
      
      private var _totalTime:Number;
      
      private var _callback:Function;
      
      private var _args:Array;
      
      private var _repeatCount:int;
      
      public function DelayedCall(param1:Function, param2:Number, param3:Array = null)
      {
         super();
         reset(param1,param2,param3);
      }
      
      starling_internal static function fromPool(param1:Function, param2:Number, param3:Array = null) : DelayedCall
      {
         if(sPool.length)
         {
            return sPool.pop().reset(param1,param2,param3);
         }
         return new DelayedCall(param1,param2,param3);
      }
      
      starling_internal static function toPool(param1:DelayedCall) : void
      {
         param1._callback = null;
         param1._args = null;
         param1.removeEventListeners();
         sPool.push(param1);
      }
      
      public function reset(param1:Function, param2:Number, param3:Array = null) : DelayedCall
      {
         _currentTime = 0;
         _totalTime = Math.max(param2,0.0001);
         _callback = param1;
         _args = param3;
         _repeatCount = 1;
         return this;
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:Function = null;
         var _loc3_:Array = null;
         var _loc4_:Number = _currentTime;
         _currentTime += param1;
         if(_currentTime > _totalTime)
         {
            _currentTime = _totalTime;
         }
         if(_loc4_ < _totalTime && _currentTime >= _totalTime)
         {
            if(_repeatCount == 0 || _repeatCount > 1)
            {
               _callback.apply(null,_args);
               if(_repeatCount > 0)
               {
                  _repeatCount -= 1;
               }
               _currentTime = 0;
               advanceTime(_loc4_ + param1 - _totalTime);
            }
            else
            {
               _loc2_ = _callback;
               _loc3_ = _args;
               dispatchEventWith("removeFromJuggler");
               _loc2_.apply(null,_loc3_);
            }
         }
      }
      
      public function complete() : void
      {
         var _loc1_:Number = _totalTime - _currentTime;
         if(_loc1_ > 0)
         {
            advanceTime(_loc1_);
         }
      }
      
      public function get isComplete() : Boolean
      {
         return _repeatCount == 1 && _currentTime >= _totalTime;
      }
      
      public function get totalTime() : Number
      {
         return _totalTime;
      }
      
      public function get currentTime() : Number
      {
         return _currentTime;
      }
      
      public function get repeatCount() : int
      {
         return _repeatCount;
      }
      
      public function set repeatCount(param1:int) : void
      {
         _repeatCount = param1;
      }
      
      public function get callback() : Function
      {
         return _callback;
      }
      
      public function get arguments() : Array
      {
         return _args;
      }
   }
}
