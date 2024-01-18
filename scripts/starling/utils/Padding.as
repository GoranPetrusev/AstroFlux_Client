package starling.utils
{
   import starling.events.EventDispatcher;
   
   public class Padding extends EventDispatcher
   {
       
      
      private var _left:Number;
      
      private var _right:Number;
      
      private var _top:Number;
      
      private var _bottom:Number;
      
      public function Padding(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super();
         setTo(param1,param2,param3,param4);
      }
      
      public function setTo(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : void
      {
         var _loc5_:Boolean = _left != param1 || _right != param2 || _top != param3 || _bottom != param4;
         _left = param1;
         _right = param2;
         _top = param3;
         _bottom = param4;
         if(_loc5_)
         {
            dispatchEventWith("change");
         }
      }
      
      public function copyFrom(param1:Padding) : void
      {
         if(param1 == null)
         {
            setTo(0,0,0,0);
         }
         else
         {
            setTo(param1._left,param1._right,param1._top,param1._bottom);
         }
      }
      
      public function clone() : Padding
      {
         return new Padding(_left,_right,_top,_bottom);
      }
      
      public function get left() : Number
      {
         return _left;
      }
      
      public function set left(param1:Number) : void
      {
         if(_left != param1)
         {
            _left = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get right() : Number
      {
         return _right;
      }
      
      public function set right(param1:Number) : void
      {
         if(_right != param1)
         {
            _right = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get top() : Number
      {
         return _top;
      }
      
      public function set top(param1:Number) : void
      {
         if(_top != param1)
         {
            _top = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get bottom() : Number
      {
         return _bottom;
      }
      
      public function set bottom(param1:Number) : void
      {
         if(_bottom != param1)
         {
            _bottom = param1;
            dispatchEventWith("change");
         }
      }
   }
}
