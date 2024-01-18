package com.adobe.net
{
   import flash.utils.ByteArray;
   
   public class URIEncodingBitmap extends ByteArray
   {
       
      
      public function URIEncodingBitmap(param1:String)
      {
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:* = 0;
         super();
         var _loc3_:ByteArray = new ByteArray();
         _loc5_ = 0;
         while(_loc5_ < 16)
         {
            this.writeByte(0);
            _loc5_++;
         }
         _loc3_.writeUTFBytes(param1);
         _loc3_.position = 0;
         while(_loc3_.bytesAvailable)
         {
            _loc2_ = _loc3_.readByte();
            if(_loc2_ <= 127)
            {
               this.position = _loc2_ >> 3;
               _loc4_ = (_loc4_ = this.readByte()) | 1 << (_loc2_ & 7);
               this.position = _loc2_ >> 3;
               this.writeByte(_loc4_);
            }
         }
      }
      
      public function ShouldEscape(param1:String) : int
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(param1);
         _loc3_.position = 0;
         _loc2_ = _loc3_.readByte();
         if(_loc2_ & 128)
         {
            return 0;
         }
         if(_loc2_ < 31 || _loc2_ == 127)
         {
            return _loc2_;
         }
         this.position = _loc2_ >> 3;
         if((_loc4_ = this.readByte()) & 1 << (_loc2_ & 7))
         {
            return _loc2_;
         }
         return 0;
      }
   }
}
