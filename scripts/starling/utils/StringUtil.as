package starling.utils
{
   import starling.errors.AbstractClassError;
   
   public class StringUtil
   {
       
      
      public function StringUtil()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function format(param1:String, ... rest) : String
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < rest.length)
         {
            param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
            _loc3_++;
         }
         return param1;
      }
      
      public static function clean(param1:String) : String
      {
         return ("_" + param1).substr(1);
      }
      
      public static function trimStart(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.charCodeAt(_loc2_) > 32)
            {
               break;
            }
            _loc2_++;
         }
         return param1.substring(_loc2_,_loc3_);
      }
      
      public static function trimEnd(param1:String) : String
      {
         var _loc2_:int = 0;
         _loc2_ = param1.length - 1;
         while(_loc2_ >= 0)
         {
            if(param1.charCodeAt(_loc2_) > 32)
            {
               break;
            }
            _loc2_--;
         }
         return param1.substring(0,_loc2_ + 1);
      }
      
      public static function trim(param1:String) : String
      {
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc2_:int = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1.charCodeAt(_loc3_) > 32)
            {
               break;
            }
            _loc3_++;
         }
         _loc4_ = param1.length - 1;
         while(_loc4_ >= _loc3_)
         {
            if(param1.charCodeAt(_loc4_) > 32)
            {
               break;
            }
            _loc4_--;
         }
         return param1.substring(_loc3_,_loc4_ + 1);
      }
   }
}
