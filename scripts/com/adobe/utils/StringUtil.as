package com.adobe.utils
{
   public class StringUtil
   {
       
      
      public function StringUtil()
      {
         super();
      }
      
      public static function stringsAreEqual(param1:String, param2:String, param3:Boolean) : Boolean
      {
         if(param3)
         {
            return param1 == param2;
         }
         return param1.toUpperCase() == param2.toUpperCase();
      }
      
      public static function trim(param1:String) : String
      {
         return StringUtil.ltrim(StringUtil.rtrim(param1));
      }
      
      public static function ltrim(param1:String) : String
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.charCodeAt(_loc2_) > 32)
            {
               return param1.substring(_loc2_);
            }
            _loc2_++;
         }
         return "";
      }
      
      public static function rtrim(param1:String) : String
      {
         var _loc2_:* = NaN;
         var _loc3_:Number = param1.length;
         _loc2_ = _loc3_;
         while(_loc2_ > 0)
         {
            if(param1.charCodeAt(_loc2_ - 1) > 32)
            {
               return param1.substring(0,_loc2_);
            }
            _loc2_--;
         }
         return "";
      }
      
      public static function beginsWith(param1:String, param2:String) : Boolean
      {
         return param2 == param1.substring(0,param2.length);
      }
      
      public static function endsWith(param1:String, param2:String) : Boolean
      {
         return param2 == param1.substring(param1.length - param2.length);
      }
      
      public static function remove(param1:String, param2:String) : String
      {
         return StringUtil.replace(param1,param2,"");
      }
      
      public static function replace(param1:String, param2:String, param3:String) : String
      {
         return param1.split(param2).join(param3);
      }
      
      public static function stringHasValue(param1:String) : Boolean
      {
         return param1 != null && param1.length > 0;
      }
   }
}
