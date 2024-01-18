package com.hurlant.util.der
{
   import com.hurlant.util.Hex;
   import flash.utils.ByteArray;
   
   public class ByteString extends ByteArray implements IAsn1Type
   {
       
      
      private var type:uint;
      
      private var len:uint;
      
      public function ByteString(param1:uint = 4, param2:uint = 0)
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
      
      public function toDER() : ByteArray
      {
         return DER.wrapDER(type,this);
      }
      
      override public function toString() : String
      {
         return DER.indent + "ByteString[" + type + "][" + len + "][" + Hex.fromArray(this) + "]";
      }
   }
}
