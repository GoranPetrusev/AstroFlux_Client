package com.hurlant.util.der
{
   import flash.utils.ByteArray;
   
   public class UTCTime implements IAsn1Type
   {
       
      
      protected var type:uint;
      
      protected var len:uint;
      
      public var date:Date;
      
      public function UTCTime(param1:uint, param2:uint)
      {
         super();
         this.type = param1;
         this.len = param2;
      }
      
      public function getLength() : uint
      {
         return len;
      }
      
      public function getType() : uint
      {
         return type;
      }
      
      public function setUTCTime(param1:String) : void
      {
         var _loc4_:uint;
         if((_loc4_ = parseInt(param1.substr(0,2))) < 50)
         {
            _loc4_ += 2000;
         }
         else
         {
            _loc4_ += 1900;
         }
         var _loc3_:uint = parseInt(param1.substr(2,2));
         var _loc6_:uint = parseInt(param1.substr(4,2));
         var _loc5_:uint = parseInt(param1.substr(6,2));
         var _loc2_:uint = parseInt(param1.substr(8,2));
         date = new Date(_loc4_,_loc3_ - 1,_loc6_,_loc5_,_loc2_);
      }
      
      public function toString() : String
      {
         return DER.indent + "UTCTime[" + type + "][" + len + "][" + date + "]";
      }
      
      public function toDER() : ByteArray
      {
         return null;
      }
   }
}
