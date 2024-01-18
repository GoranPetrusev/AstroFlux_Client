package starling.events
{
   public class KeyboardEvent extends Event
   {
      
      public static const KEY_UP:String = "keyUp";
      
      public static const KEY_DOWN:String = "keyDown";
       
      
      private var _charCode:uint;
      
      private var _keyCode:uint;
      
      private var _keyLocation:uint;
      
      private var _altKey:Boolean;
      
      private var _ctrlKey:Boolean;
      
      private var _shiftKey:Boolean;
      
      private var _isDefaultPrevented:Boolean;
      
      public function KeyboardEvent(param1:String, param2:uint = 0, param3:uint = 0, param4:uint = 0, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false)
      {
         super(param1,false,param3);
         _charCode = param2;
         _keyCode = param3;
         _keyLocation = param4;
         _ctrlKey = param5;
         _altKey = param6;
         _shiftKey = param7;
      }
      
      public function preventDefault() : void
      {
         _isDefaultPrevented = true;
      }
      
      public function isDefaultPrevented() : Boolean
      {
         return _isDefaultPrevented;
      }
      
      public function get charCode() : uint
      {
         return _charCode;
      }
      
      public function get keyCode() : uint
      {
         return _keyCode;
      }
      
      public function get keyLocation() : uint
      {
         return _keyLocation;
      }
      
      public function get altKey() : Boolean
      {
         return _altKey;
      }
      
      public function get ctrlKey() : Boolean
      {
         return _ctrlKey;
      }
      
      public function get shiftKey() : Boolean
      {
         return _shiftKey;
      }
   }
}
