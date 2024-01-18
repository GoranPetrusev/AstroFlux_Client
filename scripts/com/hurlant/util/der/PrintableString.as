package com.hurlant.util.der
{
   import flash.utils.ByteArray;
   
   public class PrintableString implements IAsn1Type
   {
       
      
      protected var type:uint;
      
      protected var len:uint;
      
      protected var str:String;
      
      public function PrintableString(param1:uint, param2:uint)
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
      
      public function setString(param1:String) : void
      {
         str = param1;
      }
      
      public function getString() : String
      {
         return str;
      }
      
      public function toString() : String
      {
         return DER.indent + str;
      }
      
      public function toDER() : ByteArray
      {
         return null;
      }
   }
}
