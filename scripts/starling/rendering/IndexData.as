package starling.rendering
{
   import flash.display3D.Context3D;
   import flash.display3D.IndexBuffer3D;
   import flash.errors.EOFError;
   import flash.utils.ByteArray;
   import starling.core.Starling;
   import starling.errors.MissingContextError;
   import starling.utils.StringUtil;
   
   public class IndexData
   {
      
      private static const INDEX_SIZE:int = 2;
      
      private static var sQuadData:ByteArray = new ByteArray();
      
      private static var sQuadDataNumIndices:uint = 0;
      
      private static var sVector:Vector.<uint> = new Vector.<uint>(0);
      
      private static var sTrimData:ByteArray = new ByteArray();
       
      
      private var _rawData:ByteArray;
      
      private var _numIndices:int;
      
      private var _initialCapacity:int;
      
      private var _useQuadLayout:Boolean;
      
      public function IndexData(param1:int = 48)
      {
         super();
         _numIndices = 0;
         _initialCapacity = param1;
         _useQuadLayout = true;
      }
      
      private static function getBasicQuadIndexAt(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = param1 / 6;
         var _loc4_:int;
         if((_loc4_ = param1 - _loc2_ * 6) == 0)
         {
            _loc3_ = 0;
         }
         else if(_loc4_ == 1 || _loc4_ == 3)
         {
            _loc3_ = 1;
         }
         else if(_loc4_ == 2 || _loc4_ == 5)
         {
            _loc3_ = 2;
         }
         else
         {
            _loc3_ = 3;
         }
         return _loc2_ * 4 + _loc3_;
      }
      
      public function clear() : void
      {
         if(_rawData)
         {
            _rawData.clear();
         }
         _numIndices = 0;
         _useQuadLayout = true;
      }
      
      public function clone() : IndexData
      {
         var _loc1_:IndexData = new IndexData(_numIndices);
         if(!_useQuadLayout)
         {
            _loc1_.switchToGenericData();
            _loc1_._rawData.writeBytes(_rawData);
         }
         _loc1_._numIndices = _numIndices;
         return _loc1_;
      }
      
      public function copyTo(param1:IndexData, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = -1) : void
      {
         var _loc6_:ByteArray = null;
         var _loc15_:ByteArray = null;
         var _loc16_:* = false;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc13_:int = 0;
         var _loc12_:int = 0;
         var _loc11_:* = 0;
         var _loc10_:* = 0;
         var _loc14_:* = 0;
         if(param5 < 0 || param4 + param5 > _numIndices)
         {
            param5 = _numIndices - param4;
         }
         var _loc8_:int = param2 + param5;
         if(param1._numIndices < _loc8_)
         {
            param1._numIndices = _loc8_;
            if(sQuadDataNumIndices < _loc8_)
            {
               ensureQuadDataCapacity(_loc8_);
            }
         }
         if(_useQuadLayout)
         {
            if(param1._useQuadLayout)
            {
               _loc16_ = true;
               _loc9_ = (_loc7_ = param2 - param4) / 6;
               _loc13_ = param3 / 4;
               if(_loc9_ == _loc13_ && (param3 & 3) == 0 && _loc9_ * 6 == _loc7_)
               {
                  _loc16_ = true;
               }
               else if(param5 > 2)
               {
                  _loc16_ = false;
               }
               else
               {
                  _loc12_ = 0;
                  while(_loc12_ < param5)
                  {
                     if(_loc16_)
                     {
                        _loc16_ = getBasicQuadIndexAt(param4 + _loc12_) + param3 == getBasicQuadIndexAt(param2 + _loc12_);
                     }
                     _loc12_++;
                  }
               }
               if(_loc16_)
               {
                  return;
               }
               param1.switchToGenericData();
            }
            _loc15_ = sQuadData;
            _loc6_ = param1._rawData;
            if((param3 & 3) == 0)
            {
               param4 += 6 * param3 / 4;
               param3 = 0;
               ensureQuadDataCapacity(param4 + param5);
            }
         }
         else
         {
            if(param1._useQuadLayout)
            {
               param1.switchToGenericData();
            }
            _loc15_ = _rawData;
            _loc6_ = param1._rawData;
         }
         _loc6_.position = param2 * 2;
         if(param3 == 0)
         {
            _loc6_.writeBytes(_loc15_,param4 * 2,param5 * 2);
         }
         else
         {
            _loc15_.position = param4 * 2;
            while(param5 > 1)
            {
               _loc10_ = uint((((_loc11_ = _loc15_.readUnsignedInt()) & 4294901760) >> 16) + param3);
               _loc14_ = uint((_loc11_ & 65535) + param3);
               _loc6_.writeUnsignedInt(_loc10_ << 16 | _loc14_);
               param5 -= 2;
            }
            if(param5)
            {
               _loc6_.writeShort(_loc15_.readUnsignedShort() + param3);
            }
         }
      }
      
      public function setIndex(param1:int, param2:uint) : void
      {
         if(_numIndices < param1 + 1)
         {
            numIndices = param1 + 1;
         }
         if(_useQuadLayout)
         {
            if(getBasicQuadIndexAt(param1) == param2)
            {
               return;
            }
            switchToGenericData();
         }
         _rawData.position = param1 * 2;
         _rawData.writeShort(param2);
      }
      
      public function getIndex(param1:int) : int
      {
         if(_useQuadLayout)
         {
            if(param1 < _numIndices)
            {
               return getBasicQuadIndexAt(param1);
            }
            throw new EOFError();
         }
         _rawData.position = param1 * 2;
         return _rawData.readUnsignedShort();
      }
      
      public function offsetIndices(param1:int, param2:int = 0, param3:int = -1) : void
      {
         var _loc5_:* = 0;
         if(param3 < 0 || param2 + param3 > _numIndices)
         {
            param3 = _numIndices - param2;
         }
         var _loc4_:int = param2 + param3;
         _loc5_ = param2;
         while(_loc5_ < _loc4_)
         {
            setIndex(_loc5_,getIndex(_loc5_) + param1);
            _loc5_++;
         }
      }
      
      public function addTriangle(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc5_:* = false;
         var _loc4_:* = false;
         if(_useQuadLayout)
         {
            if(param1 == getBasicQuadIndexAt(_numIndices))
            {
               if((_loc4_ = !(_loc5_ = (_numIndices & 1) != 0)) && param2 == param1 + 1 && param3 == param2 + 1 || _loc5_ && param3 == param1 + 1 && param2 == param3 + 1)
               {
                  _numIndices += 3;
                  ensureQuadDataCapacity(_numIndices);
                  return;
               }
            }
            switchToGenericData();
         }
         _rawData.position = _numIndices * 2;
         _rawData.writeShort(param1);
         _rawData.writeShort(param2);
         _rawData.writeShort(param3);
         _numIndices += 3;
      }
      
      public function addQuad(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         if(_useQuadLayout)
         {
            if(param1 == getBasicQuadIndexAt(_numIndices) && param2 == param1 + 1 && param3 == param2 + 1 && param4 == param3 + 1)
            {
               _numIndices += 6;
               ensureQuadDataCapacity(_numIndices);
               return;
            }
            switchToGenericData();
         }
         _rawData.position = _numIndices * 2;
         _rawData.writeShort(param1);
         _rawData.writeShort(param2);
         _rawData.writeShort(param3);
         _rawData.writeShort(param2);
         _rawData.writeShort(param4);
         _rawData.writeShort(param3);
         _numIndices += 6;
      }
      
      public function toVector(param1:Vector.<uint> = null) : Vector.<uint>
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            param1 = new Vector.<uint>(_numIndices);
         }
         else
         {
            param1.length = _numIndices;
         }
         var _loc3_:ByteArray = _useQuadLayout ? sQuadData : _rawData;
         _loc3_.position = 0;
         _loc2_ = 0;
         while(_loc2_ < _numIndices)
         {
            param1[_loc2_] = _loc3_.readUnsignedShort();
            _loc2_++;
         }
         return param1;
      }
      
      public function toString() : String
      {
         var _loc1_:String = StringUtil.format("[IndexData numIndices={0} indices=\"{1}\"]",_numIndices,toVector(sVector).join());
         sVector.length = 0;
         return _loc1_;
      }
      
      private function switchToGenericData() : void
      {
         if(_useQuadLayout)
         {
            _useQuadLayout = false;
            if(_rawData == null)
            {
               _rawData = new ByteArray();
               _rawData.endian = "littleEndian";
               _rawData.length = _initialCapacity * 2;
               _rawData.length = _numIndices * 2;
            }
            if(_numIndices)
            {
               _rawData.writeBytes(sQuadData,0,_numIndices * 2);
            }
         }
      }
      
      private function ensureQuadDataCapacity(param1:int) : void
      {
         var _loc2_:* = 0;
         if(sQuadDataNumIndices >= param1)
         {
            return;
         }
         var _loc4_:int = sQuadDataNumIndices / 6;
         var _loc3_:int = Math.ceil(param1 / 6);
         sQuadData.endian = "littleEndian";
         sQuadData.position = sQuadData.length;
         sQuadDataNumIndices = _loc3_ * 6;
         _loc2_ = _loc4_;
         while(_loc2_ < _loc3_)
         {
            sQuadData.writeShort(4 * _loc2_);
            sQuadData.writeShort(4 * _loc2_ + 1);
            sQuadData.writeShort(4 * _loc2_ + 2);
            sQuadData.writeShort(4 * _loc2_ + 1);
            sQuadData.writeShort(4 * _loc2_ + 3);
            sQuadData.writeShort(4 * _loc2_ + 2);
            _loc2_++;
         }
      }
      
      public function createIndexBuffer(param1:Boolean = false, param2:String = "staticDraw") : IndexBuffer3D
      {
         var _loc3_:Context3D = Starling.context;
         if(_loc3_ == null)
         {
            throw new MissingContextError();
         }
         if(_numIndices == 0)
         {
            return null;
         }
         var _loc4_:IndexBuffer3D = _loc3_.createIndexBuffer(_numIndices,param2);
         if(param1)
         {
            uploadToIndexBuffer(_loc4_);
         }
         return _loc4_;
      }
      
      public function uploadToIndexBuffer(param1:IndexBuffer3D, param2:int = 0, param3:int = -1) : void
      {
         if(param3 < 0 || param2 + param3 > _numIndices)
         {
            param3 = _numIndices - param2;
         }
         if(param3 > 0)
         {
            param1.uploadFromByteArray(rawData,0,param2,param3);
         }
      }
      
      public function trim() : void
      {
         if(_useQuadLayout)
         {
            return;
         }
         sTrimData.length = _rawData.length;
         sTrimData.position = 0;
         sTrimData.writeBytes(_rawData);
         _rawData.clear();
         _rawData.length = sTrimData.length;
         _rawData.writeBytes(sTrimData);
         sTrimData.clear();
      }
      
      public function get numIndices() : int
      {
         return _numIndices;
      }
      
      public function set numIndices(param1:int) : void
      {
         if(param1 != _numIndices)
         {
            if(_useQuadLayout)
            {
               ensureQuadDataCapacity(param1);
            }
            else
            {
               _rawData.length = param1 * 2;
            }
            if(param1 == 0)
            {
               _useQuadLayout = true;
            }
            _numIndices = param1;
         }
      }
      
      public function get numTriangles() : int
      {
         return _numIndices / 3;
      }
      
      public function set numTriangles(param1:int) : void
      {
         numIndices = param1 * 3;
      }
      
      public function get numQuads() : int
      {
         return _numIndices / 6;
      }
      
      public function set numQuads(param1:int) : void
      {
         numIndices = param1 * 6;
      }
      
      public function get indexSizeInBytes() : int
      {
         return 2;
      }
      
      public function get useQuadLayout() : Boolean
      {
         return _useQuadLayout;
      }
      
      public function set useQuadLayout(param1:Boolean) : void
      {
         if(param1 != _useQuadLayout)
         {
            if(param1)
            {
               ensureQuadDataCapacity(_numIndices);
               _rawData.length = 0;
               _useQuadLayout = true;
            }
            else
            {
               switchToGenericData();
            }
         }
      }
      
      public function get rawData() : ByteArray
      {
         if(_useQuadLayout)
         {
            return sQuadData;
         }
         return _rawData;
      }
   }
}
