package feathers.core
{
   import flash.utils.Dictionary;
   import starling.animation.IAnimatable;
   import starling.core.Starling;
   
   public final class ValidationQueue implements IAnimatable
   {
      
      private static const STARLING_TO_VALIDATION_QUEUE:Dictionary = new Dictionary(true);
       
      
      private var _starling:Starling;
      
      private var _isValidating:Boolean = false;
      
      private var _delayedQueue:Vector.<IValidating>;
      
      private var _queue:Vector.<IValidating>;
      
      public function ValidationQueue(param1:Starling)
      {
         _delayedQueue = new Vector.<IValidating>(0);
         _queue = new Vector.<IValidating>(0);
         super();
         this._starling = param1;
      }
      
      public static function forStarling(param1:Starling) : ValidationQueue
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:ValidationQueue = STARLING_TO_VALIDATION_QUEUE[param1];
         if(!_loc2_)
         {
            STARLING_TO_VALIDATION_QUEUE[param1] = _loc2_ = new ValidationQueue(param1);
         }
         return _loc2_;
      }
      
      public function get isValidating() : Boolean
      {
         return this._isValidating;
      }
      
      public function dispose() : void
      {
         if(this._starling)
         {
            this._starling.juggler.remove(this);
            this._starling = null;
         }
      }
      
      public function addControl(param1:IValidating, param2:Boolean) : void
      {
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:IValidating = null;
         var _loc6_:int = 0;
         if(!this._starling.juggler.contains(this))
         {
            this._starling.juggler.add(this);
         }
         var _loc3_:Vector.<IValidating> = this._isValidating && param2 ? this._delayedQueue : this._queue;
         if(_loc3_.indexOf(param1) >= 0)
         {
            return;
         }
         var _loc4_:int = int(_loc3_.length);
         if(this._isValidating && _loc3_ == this._queue)
         {
            _loc5_ = param1.depth;
            _loc7_ = _loc4_ - 1;
            while(_loc7_ >= 0)
            {
               _loc6_ = (_loc8_ = IValidating(_loc3_[_loc7_])).depth;
               if(_loc5_ >= _loc6_)
               {
                  break;
               }
               _loc7_--;
            }
            _loc7_++;
            _loc3_.insertAt(_loc7_,param1);
         }
         else
         {
            _loc3_[_loc4_] = param1;
         }
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc3_:IValidating = null;
         if(this._isValidating || !this._starling.contextValid)
         {
            return;
         }
         var _loc2_:int = int(this._queue.length);
         if(_loc2_ === 0)
         {
            return;
         }
         this._isValidating = true;
         if(_loc2_ > 1)
         {
            this._queue = this._queue.sort(queueSortFunction);
         }
         while(this._queue.length > 0)
         {
            _loc3_ = this._queue.shift();
            if(_loc3_.depth >= 0)
            {
               _loc3_.validate();
            }
         }
         var _loc4_:Vector.<IValidating> = this._queue;
         this._queue = this._delayedQueue;
         this._delayedQueue = _loc4_;
         this._isValidating = false;
      }
      
      protected function queueSortFunction(param1:IValidating, param2:IValidating) : int
      {
         var _loc3_:int = param2.depth - param1.depth;
         if(_loc3_ > 0)
         {
            return -1;
         }
         if(_loc3_ < 0)
         {
            return 1;
         }
         return 0;
      }
   }
}
