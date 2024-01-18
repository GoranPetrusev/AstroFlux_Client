package com.google.analytics.core
{
   public function generateHash(param1:String) : int
   {
      var _loc4_:int = 0;
      var _loc5_:int = 0;
      var _loc2_:* = 1;
      var _loc3_:* = 0;
      if(param1 != null && param1 != "")
      {
         _loc2_ = 0;
         _loc4_ = param1.length - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = param1.charCodeAt(_loc4_);
            _loc2_ = (_loc2_ << 6 & 268435455) + _loc5_ + (_loc5_ << 14);
            _loc3_ = _loc2_ & 266338304;
            if(_loc3_ != 0)
            {
               _loc2_ ^= _loc3_ >> 21;
            }
            _loc4_--;
         }
      }
      return _loc2_;
   }
}
