package com.hurlant.util.der
{
   import flash.utils.ByteArray;
   
   public class DER
   {
      
      public static var indent:String = "";
       
      
      public function DER()
      {
         super();
      }
      
      public static function parse(param1:ByteArray, param2:* = null) : IAsn1Type
      {
         var _loc4_:* = 0;
         var _loc5_:ByteArray = null;
         var _loc18_:int = 0;
         var _loc7_:Sequence = null;
         var _loc21_:Array = null;
         var _loc12_:Object = null;
         var _loc13_:* = false;
         var _loc15_:Boolean = false;
         var _loc17_:String = null;
         var _loc19_:* = undefined;
         var _loc14_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc20_:IAsn1Type = null;
         var _loc16_:Set = null;
         var _loc10_:ByteString = null;
         var _loc22_:PrintableString = null;
         var _loc8_:UTCTime = null;
         var _loc11_:*;
         var _loc6_:* = ((_loc11_ = int(param1.readUnsignedByte())) & 32) != 0;
         _loc11_ &= 31;
         var _loc9_:*;
         if((_loc9_ = int(param1.readUnsignedByte())) >= 128)
         {
            _loc4_ = _loc9_ & 127;
            _loc9_ = 0;
            while(_loc4_ > 0)
            {
               _loc9_ = _loc9_ << 8 | param1.readUnsignedByte();
               _loc4_--;
            }
         }
         switch(_loc11_)
         {
            case 0:
            case 16:
               _loc18_ = int(param1.position);
               _loc7_ = new Sequence(_loc11_,_loc9_);
               if((_loc21_ = param2 as Array) != null)
               {
                  _loc21_ = _loc21_.concat();
               }
               while(param1.position < _loc18_ + _loc9_)
               {
                  _loc12_ = null;
                  if(_loc21_ != null)
                  {
                     _loc12_ = _loc21_.shift();
                  }
                  if(_loc12_ != null)
                  {
                     while(_loc12_ && _loc12_.optional)
                     {
                        _loc13_ = _loc12_.value is Array;
                        _loc15_ = isConstructedType(param1);
                        if(_loc13_ == _loc15_)
                        {
                           break;
                        }
                        _loc7_.push(_loc12_.defaultValue);
                        _loc7_[_loc12_.name] = _loc12_.defaultValue;
                        _loc12_ = _loc21_.shift();
                     }
                  }
                  if(_loc12_ != null)
                  {
                     _loc17_ = String(_loc12_.name);
                     _loc19_ = _loc12_.value;
                     if(_loc12_.extract)
                     {
                        _loc14_ = getLengthOfNextElement(param1);
                        _loc3_ = new ByteArray();
                        _loc3_.writeBytes(param1,param1.position,_loc14_);
                        _loc7_[_loc17_ + "_bin"] = _loc3_;
                     }
                     _loc20_ = DER.parse(param1,_loc19_);
                     _loc7_.push(_loc20_);
                     _loc7_[_loc17_] = _loc20_;
                  }
                  else
                  {
                     _loc7_.push(DER.parse(param1));
                  }
               }
               return _loc7_;
            case 17:
               _loc18_ = int(param1.position);
               _loc16_ = new Set(_loc11_,_loc9_);
               while(param1.position < _loc18_ + _loc9_)
               {
                  _loc16_.push(DER.parse(param1));
               }
               return _loc16_;
            case 2:
               _loc5_ = new ByteArray();
               param1.readBytes(_loc5_,0,_loc9_);
               _loc5_.position = 0;
               return new Integer(_loc11_,_loc9_,_loc5_);
            case 6:
               _loc5_ = new ByteArray();
               param1.readBytes(_loc5_,0,_loc9_);
               _loc5_.position = 0;
               return new ObjectIdentifier(_loc11_,_loc9_,_loc5_);
            default:
               trace("I DONT KNOW HOW TO HANDLE DER stuff of TYPE " + _loc11_);
            case 3:
               if(param1[param1.position] == 0)
               {
                  param1.position++;
                  _loc9_--;
               }
               break;
            case 4:
               break;
            case 5:
               return null;
            case 19:
               (_loc22_ = new PrintableString(_loc11_,_loc9_)).setString(param1.readMultiByte(_loc9_,"US-ASCII"));
               return _loc22_;
            case 34:
            case 20:
               (_loc22_ = new PrintableString(_loc11_,_loc9_)).setString(param1.readMultiByte(_loc9_,"latin1"));
               return _loc22_;
            case 23:
               (_loc8_ = new UTCTime(_loc11_,_loc9_)).setUTCTime(param1.readMultiByte(_loc9_,"US-ASCII"));
               return _loc8_;
         }
         _loc10_ = new ByteString(_loc11_,_loc9_);
         param1.readBytes(_loc10_,0,_loc9_);
         return _loc10_;
      }
      
      private static function getLengthOfNextElement(param1:ByteArray) : int
      {
         var _loc2_:* = 0;
         var _loc3_:uint = param1.position;
         param1.position++;
         var _loc4_:*;
         if((_loc4_ = int(param1.readUnsignedByte())) >= 128)
         {
            _loc2_ = _loc4_ & 127;
            _loc4_ = 0;
            while(_loc2_ > 0)
            {
               _loc4_ = _loc4_ << 8 | param1.readUnsignedByte();
               _loc2_--;
            }
         }
         _loc4_ += param1.position - _loc3_;
         param1.position = _loc3_;
         return _loc4_;
      }
      
      private static function isConstructedType(param1:ByteArray) : Boolean
      {
         var _loc2_:int = int(param1[param1.position]);
         return (_loc2_ & 32) != 0;
      }
      
      public static function wrapDER(param1:int, param2:ByteArray) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         var _loc4_:int;
         if((_loc4_ = int(param2.length)) < 128)
         {
            _loc3_.writeByte(_loc4_);
         }
         else if(_loc4_ < 256)
         {
            _loc3_.writeByte(129);
            _loc3_.writeByte(_loc4_);
         }
         else if(_loc4_ < 65536)
         {
            _loc3_.writeByte(130);
            _loc3_.writeByte(_loc4_ >> 8);
            _loc3_.writeByte(_loc4_);
         }
         else if(_loc4_ < 16777216)
         {
            _loc3_.writeByte(131);
            _loc3_.writeByte(_loc4_ >> 16);
            _loc3_.writeByte(_loc4_ >> 8);
            _loc3_.writeByte(_loc4_);
         }
         else
         {
            _loc3_.writeByte(132);
            _loc3_.writeByte(_loc4_ >> 24);
            _loc3_.writeByte(_loc4_ >> 16);
            _loc3_.writeByte(_loc4_ >> 8);
            _loc3_.writeByte(_loc4_);
         }
         _loc3_.writeBytes(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
   }
}
