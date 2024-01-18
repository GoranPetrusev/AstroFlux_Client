package com.google.analytics.utils
{
   public function getDomainFromHost(param1:String) : String
   {
      var _loc2_:Array = null;
      if(param1 != "" && param1.indexOf(".") > -1)
      {
         _loc2_ = param1.split(".");
         switch(_loc2_.length)
         {
            case 2:
               return param1;
            case 3:
               if(_loc2_[1] == "co")
               {
                  return param1;
               }
               _loc2_.shift();
               return _loc2_.join(".");
               break;
            case 4:
               _loc2_.shift();
               return _loc2_.join(".");
         }
      }
      return "";
   }
}
