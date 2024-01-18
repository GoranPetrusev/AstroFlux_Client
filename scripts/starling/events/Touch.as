package starling.events
{
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.utils.StringUtil;
   
   public class Touch
   {
      
      private static var sHelperPoint:Point = new Point();
       
      
      private var _id:int;
      
      private var _globalX:Number;
      
      private var _globalY:Number;
      
      private var _previousGlobalX:Number;
      
      private var _previousGlobalY:Number;
      
      private var _tapCount:int;
      
      private var _phase:String;
      
      private var _target:DisplayObject;
      
      private var _timestamp:Number;
      
      private var _pressure:Number;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _cancelled:Boolean;
      
      private var _bubbleChain:Vector.<EventDispatcher>;
      
      public function Touch(param1:int)
      {
         super();
         _id = param1;
         _tapCount = 0;
         _phase = "hover";
         _pressure = _width = _height = 1;
         _bubbleChain = new Vector.<EventDispatcher>(0);
      }
      
      public function getLocation(param1:DisplayObject, param2:Point = null) : Point
      {
         sHelperPoint.setTo(_globalX,_globalY);
         return param1.globalToLocal(sHelperPoint,param2);
      }
      
      public function getPreviousLocation(param1:DisplayObject, param2:Point = null) : Point
      {
         sHelperPoint.setTo(_previousGlobalX,_previousGlobalY);
         return param1.globalToLocal(sHelperPoint,param2);
      }
      
      public function getMovement(param1:DisplayObject, param2:Point = null) : Point
      {
         if(param2 == null)
         {
            param2 = new Point();
         }
         getLocation(param1,param2);
         var _loc3_:Number = param2.x;
         var _loc4_:Number = param2.y;
         getPreviousLocation(param1,param2);
         param2.setTo(_loc3_ - param2.x,_loc4_ - param2.y);
         return param2;
      }
      
      public function isTouching(param1:DisplayObject) : Boolean
      {
         return _bubbleChain.indexOf(param1) != -1;
      }
      
      public function toString() : String
      {
         return StringUtil.format("[Touch {0}: globalX={1}, globalY={2}, phase={3}]",_id,_globalX,_globalY,_phase);
      }
      
      public function clone() : Touch
      {
         var _loc1_:Touch = new Touch(_id);
         _loc1_._globalX = _globalX;
         _loc1_._globalY = _globalY;
         _loc1_._previousGlobalX = _previousGlobalX;
         _loc1_._previousGlobalY = _previousGlobalY;
         _loc1_._phase = _phase;
         _loc1_._tapCount = _tapCount;
         _loc1_._timestamp = _timestamp;
         _loc1_._pressure = _pressure;
         _loc1_._width = _width;
         _loc1_._height = _height;
         _loc1_._cancelled = _cancelled;
         _loc1_.target = _target;
         return _loc1_;
      }
      
      private function updateBubbleChain() : void
      {
         var _loc1_:int = 0;
         var _loc2_:DisplayObject = null;
         if(_target)
         {
            _loc1_ = 1;
            _loc2_ = _target;
            _bubbleChain.length = 1;
            _bubbleChain[0] = _loc2_;
            while((_loc2_ = _loc2_.parent) != null)
            {
               _bubbleChain[_loc1_++] = _loc2_;
            }
         }
         else
         {
            _bubbleChain.length = 0;
         }
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function get previousGlobalX() : Number
      {
         return _previousGlobalX;
      }
      
      public function get previousGlobalY() : Number
      {
         return _previousGlobalY;
      }
      
      public function get globalX() : Number
      {
         return _globalX;
      }
      
      public function set globalX(param1:Number) : void
      {
         _previousGlobalX = _globalX != _globalX ? param1 : _globalX;
         _globalX = param1;
      }
      
      public function get globalY() : Number
      {
         return _globalY;
      }
      
      public function set globalY(param1:Number) : void
      {
         _previousGlobalY = _globalY != _globalY ? param1 : _globalY;
         _globalY = param1;
      }
      
      public function get tapCount() : int
      {
         return _tapCount;
      }
      
      public function set tapCount(param1:int) : void
      {
         _tapCount = param1;
      }
      
      public function get phase() : String
      {
         return _phase;
      }
      
      public function set phase(param1:String) : void
      {
         _phase = param1;
      }
      
      public function get target() : DisplayObject
      {
         return _target;
      }
      
      public function set target(param1:DisplayObject) : void
      {
         if(_target != param1)
         {
            _target = param1;
            updateBubbleChain();
         }
      }
      
      public function get timestamp() : Number
      {
         return _timestamp;
      }
      
      public function set timestamp(param1:Number) : void
      {
         _timestamp = param1;
      }
      
      public function get pressure() : Number
      {
         return _pressure;
      }
      
      public function set pressure(param1:Number) : void
      {
         _pressure = param1;
      }
      
      public function get width() : Number
      {
         return _width;
      }
      
      public function set width(param1:Number) : void
      {
         _width = param1;
      }
      
      public function get height() : Number
      {
         return _height;
      }
      
      public function set height(param1:Number) : void
      {
         _height = param1;
      }
      
      public function get cancelled() : Boolean
      {
         return _cancelled;
      }
      
      public function set cancelled(param1:Boolean) : void
      {
         _cancelled = param1;
      }
      
      internal function dispatchEvent(param1:TouchEvent) : void
      {
         if(_target)
         {
            param1.dispatch(_bubbleChain);
         }
      }
      
      internal function get bubbleChain() : Vector.<EventDispatcher>
      {
         return _bubbleChain.concat();
      }
   }
}
