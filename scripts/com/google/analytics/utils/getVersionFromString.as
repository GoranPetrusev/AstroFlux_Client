package com.google.analytics.utils
{
   import core.version;
   
   public function getVersionFromString(param1:String, param2:String = ".") : version
   {
      var _loc4_:Array = null;
      var _loc3_:version = new version();
      if(param1 == "" || param1 == null)
      {
         return _loc3_;
      }
      if(param1.indexOf(param2) > -1)
      {
         _loc4_ = param1.split(param2);
         _loc3_.major = parseInt(_loc4_[0]);
         _loc3_.minor = parseInt(_loc4_[1]);
         _loc3_.build = parseInt(_loc4_[2]);
         _loc3_.revision = parseInt(_loc4_[3]);
      }
      else
      {
         _loc3_.major = parseInt(param1);
      }
      return _loc3_;
   }
}
