package com.google.analytics.utils
{
   public function getSubDomainFromHost(param1:String) : String
   {
      var _loc2_:String = getDomainFromHost(param1);
      if(_loc2_ != "" && _loc2_ != param1)
      {
         return param1.split("." + _loc2_).join("");
      }
      return "";
   }
}
