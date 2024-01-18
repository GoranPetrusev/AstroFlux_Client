package com.google.analytics.core
{
   public function validateAccount(param1:String) : Boolean
   {
      var _loc2_:RegExp = /^UA-[0-9]*-[0-9]*$/;
      return _loc2_.test(param1);
   }
}
