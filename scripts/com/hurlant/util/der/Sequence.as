package com.hurlant.util.der
{
   import flash.utils.ByteArray;
   
   public dynamic class Sequence extends Array implements IAsn1Type
   {
       
      
      protected var type:uint;
      
      protected var len:uint;
      
      public function Sequence(param1:uint = 48, param2:uint = 0)
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
         var _loc3_:int = 0;
         var _loc1_:IAsn1Type = null;
         var _loc2_:ByteArray = new ByteArray();
         _loc3_ = 0;
         while(_loc3_ < length)
         {
            _loc1_ = this[_loc3_];
            if(_loc1_ == null)
            {
               _loc2_.writeByte(5);
               _loc2_.writeByte(0);
            }
            else
            {
               _loc2_.writeBytes(_loc1_.toDER());
            }
            _loc3_++;
         }
         return DER.wrapDER(type,_loc2_);
      }
      
      public function toString() : String
      {
         var _loc5_:int = 0;
         var _loc4_:Boolean = false;
         var _loc2_:String = DER.indent;
         DER.indent += "    ";
         var _loc1_:String = "";
         _loc5_ = 0;
         while(_loc5_ < length)
         {
            if(this[_loc5_] != null)
            {
               _loc4_ = false;
               for(var _loc3_ in this)
               {
                  if(_loc5_.toString() != _loc3_ && this[_loc5_] == this[_loc3_])
                  {
                     _loc1_ += _loc3_ + ": " + this[_loc5_] + "\n";
                     _loc4_ = true;
                     break;
                  }
               }
               if(!_loc4_)
               {
                  _loc1_ += this[_loc5_] + "\n";
               }
            }
            _loc5_++;
         }
         DER.indent = _loc2_;
         return DER.indent + "Sequence[" + type + "][" + len + "][\n" + _loc1_ + "\n" + _loc2_ + "]";
      }
      
      public function findAttributeValue(param1:String) : IAsn1Type
      {
         var _loc3_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:ObjectIdentifier = null;
         for each(var _loc4_ in this)
         {
            if(_loc4_ is Set)
            {
               _loc3_ = _loc4_[0];
               if(_loc3_ is Sequence)
               {
                  if((_loc5_ = _loc3_[0]) is ObjectIdentifier)
                  {
                     _loc2_ = _loc5_ as ObjectIdentifier;
                     if(_loc2_.toString() == param1)
                     {
                        return _loc3_[1] as IAsn1Type;
                     }
                  }
               }
            }
         }
         return null;
      }
   }
}
