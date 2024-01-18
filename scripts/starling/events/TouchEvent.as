package starling.events
{
   import starling.core.starling_internal;
   import starling.display.DisplayObject;
   
   use namespace starling_internal;
   
   public class TouchEvent extends Event
   {
      
      public static const TOUCH:String = "touch";
      
      private static var sTouches:Vector.<Touch> = new Vector.<Touch>(0);
       
      
      private var _shiftKey:Boolean;
      
      private var _ctrlKey:Boolean;
      
      private var _timestamp:Number;
      
      private var _visitedObjects:Vector.<EventDispatcher>;
      
      public function TouchEvent(param1:String, param2:Vector.<Touch> = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true)
      {
         super(param1,param5,param2);
         _shiftKey = param3;
         _ctrlKey = param4;
         _visitedObjects = new Vector.<EventDispatcher>(0);
         updateTimestamp(param2);
      }
      
      internal function resetTo(param1:String, param2:Vector.<Touch> = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true) : TouchEvent
      {
         super.starling_internal::reset(param1,param5,param2);
         _shiftKey = param3;
         _ctrlKey = param4;
         _visitedObjects.length = 0;
         updateTimestamp(param2);
         return this;
      }
      
      private function updateTimestamp(param1:Vector.<Touch>) : void
      {
         var _loc2_:int = 0;
         _timestamp = -1;
         var _loc3_:int = int(!!param1 ? param1.length : 0);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1[_loc2_].timestamp > _timestamp)
            {
               _timestamp = param1[_loc2_].timestamp;
            }
            _loc2_++;
         }
      }
      
      public function getTouches(param1:DisplayObject, param2:String = null, param3:Vector.<Touch> = null) : Vector.<Touch>
      {
         var _loc6_:int = 0;
         var _loc7_:Touch = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(param3 == null)
         {
            param3 = new Vector.<Touch>(0);
         }
         var _loc8_:Vector.<Touch>;
         var _loc9_:int = int((_loc8_ = data as Vector.<Touch>).length);
         _loc6_ = 0;
         while(_loc6_ < _loc9_)
         {
            _loc4_ = (_loc7_ = _loc8_[_loc6_]).isTouching(param1);
            _loc5_ = param2 == null || param2 == _loc7_.phase;
            if(_loc4_ && _loc5_)
            {
               param3[param3.length] = _loc7_;
            }
            _loc6_++;
         }
         return param3;
      }
      
      public function getTouch(param1:DisplayObject, param2:String = null, param3:int = -1) : Touch
      {
         var _loc4_:Touch = null;
         var _loc5_:int = 0;
         getTouches(param1,param2,sTouches);
         var _loc6_:int;
         if((_loc6_ = int(sTouches.length)) > 0)
         {
            _loc4_ = null;
            if(param3 < 0)
            {
               _loc4_ = sTouches[0];
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  if(sTouches[_loc5_].id == param3)
                  {
                     _loc4_ = sTouches[_loc5_];
                     break;
                  }
                  _loc5_++;
               }
            }
            sTouches.length = 0;
            return _loc4_;
         }
         return null;
      }
      
      public function interactsWith(param1:DisplayObject) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         getTouches(param1,null,sTouches);
         _loc3_ = sTouches.length - 1;
         while(_loc3_ >= 0)
         {
            if(sTouches[_loc3_].phase != "ended")
            {
               _loc2_ = true;
               break;
            }
            _loc3_--;
         }
         sTouches.length = 0;
         return _loc2_;
      }
      
      internal function dispatch(param1:Vector.<EventDispatcher>) : void
      {
         var _loc2_:int = 0;
         var _loc6_:EventDispatcher = null;
         var _loc4_:int = 0;
         var _loc3_:EventDispatcher = null;
         var _loc5_:Boolean = false;
         if(param1 && param1.length)
         {
            _loc2_ = int(bubbles ? param1.length : 1);
            _loc6_ = target;
            setTarget(param1[0] as EventDispatcher);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = param1[_loc4_] as EventDispatcher;
               if(_visitedObjects.indexOf(_loc3_) == -1)
               {
                  _loc5_ = _loc3_.invokeEvent(this);
                  _visitedObjects[_visitedObjects.length] = _loc3_;
                  if(_loc5_)
                  {
                     break;
                  }
               }
               _loc4_++;
            }
            setTarget(_loc6_);
         }
      }
      
      public function get timestamp() : Number
      {
         return _timestamp;
      }
      
      public function get touches() : Vector.<Touch>
      {
         return (data as Vector.<Touch>).concat();
      }
      
      public function get shiftKey() : Boolean
      {
         return _shiftKey;
      }
      
      public function get ctrlKey() : Boolean
      {
         return _ctrlKey;
      }
   }
}
