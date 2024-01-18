package starling.rendering
{
   import flash.display3D.Context3D;
   import flash.display3D.VertexBuffer3D;
   import flash.errors.IllegalOperationError;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.ByteArray;
   import starling.core.Starling;
   import starling.errors.MissingContextError;
   import starling.styles.MeshStyle;
   import starling.utils.MathUtil;
   import starling.utils.MatrixUtil;
   import starling.utils.StringUtil;
   
   public class VertexData
   {
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sHelperPoint3D:Vector3D = new Vector3D();
      
      private static var sBytes:ByteArray = new ByteArray();
       
      
      private var _rawData:ByteArray;
      
      private var _numVertices:int;
      
      private var _format:VertexDataFormat;
      
      private var _attributes:Vector.<VertexDataAttribute>;
      
      private var _numAttributes:int;
      
      private var _premultipliedAlpha:Boolean;
      
      private var _tinted:Boolean;
      
      private var _posOffset:int;
      
      private var _colOffset:int;
      
      private var _vertexSize:int;
      
      public function VertexData(param1:* = null, param2:int = 32)
      {
         super();
         if(param1 == null)
         {
            _format = MeshStyle.VERTEX_FORMAT;
         }
         else if(param1 is VertexDataFormat)
         {
            _format = param1;
         }
         else
         {
            if(!(param1 is String))
            {
               throw new ArgumentError("\'format\' must be String or VertexDataFormat");
            }
            _format = VertexDataFormat.fromString(param1 as String);
         }
         _attributes = _format.attributes;
         _numAttributes = _attributes.length;
         _posOffset = _format.hasAttribute("position") ? _format.getOffset("position") : 0;
         _colOffset = _format.hasAttribute("color") ? _format.getOffset("color") : 0;
         _vertexSize = _format.vertexSize;
         _numVertices = 0;
         _premultipliedAlpha = true;
         _rawData = new ByteArray();
         _rawData.endian = sBytes.endian = "littleEndian";
         _rawData.length = param2 * _vertexSize;
         _rawData.length = 0;
      }
      
      private static function switchEndian(param1:uint) : uint
      {
         return (param1 & 255) << 24 | (param1 >> 8 & 255) << 16 | (param1 >> 16 & 255) << 8 | param1 >> 24 & 255;
      }
      
      private static function premultiplyAlpha(param1:uint) : uint
      {
         var _loc6_:Number = NaN;
         var _loc2_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:uint;
         if((_loc4_ = uint(param1 & 255)) == 255)
         {
            return param1;
         }
         _loc6_ = _loc4_ / 255;
         _loc2_ = (param1 >> 24 & 255) * _loc6_;
         _loc5_ = (param1 >> 16 & 255) * _loc6_;
         _loc3_ = (param1 >> 8 & 255) * _loc6_;
         return (_loc2_ & 255) << 24 | (_loc5_ & 255) << 16 | (_loc3_ & 255) << 8 | _loc4_;
      }
      
      private static function unmultiplyAlpha(param1:uint) : uint
      {
         var _loc6_:Number = NaN;
         var _loc2_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:uint;
         if((_loc4_ = uint(param1 & 255)) == 255 || _loc4_ == 0)
         {
            return param1;
         }
         _loc6_ = _loc4_ / 255;
         _loc2_ = (param1 >> 24 & 255) / _loc6_;
         _loc5_ = (param1 >> 16 & 255) / _loc6_;
         _loc3_ = (param1 >> 8 & 255) / _loc6_;
         return (_loc2_ & 255) << 24 | (_loc5_ & 255) << 16 | (_loc3_ & 255) << 8 | _loc4_;
      }
      
      public function clear() : void
      {
         _rawData.clear();
         _numVertices = 0;
         _tinted = false;
      }
      
      public function clone() : VertexData
      {
         var _loc1_:VertexData = new VertexData(_format,_numVertices);
         _loc1_._rawData.writeBytes(_rawData);
         _loc1_._numVertices = _numVertices;
         _loc1_._premultipliedAlpha = _premultipliedAlpha;
         _loc1_._tinted = _tinted;
         return _loc1_;
      }
      
      public function copyTo(param1:VertexData, param2:int = 0, param3:Matrix = null, param4:int = 0, param5:int = -1) : void
      {
         var _loc8_:ByteArray = null;
         var _loc13_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc11_:int = 0;
         var _loc9_:int = 0;
         var _loc7_:int = 0;
         var _loc10_:VertexDataAttribute = null;
         var _loc6_:VertexDataAttribute = null;
         if(param5 < 0 || param4 + param5 > _numVertices)
         {
            param5 = _numVertices - param4;
         }
         if(_format === param1._format)
         {
            if(param1._numVertices < param2 + param5)
            {
               param1._numVertices = param2 + param5;
            }
            param1._tinted ||= _tinted;
            (_loc8_ = param1._rawData).position = param2 * _vertexSize;
            _loc8_.writeBytes(_rawData,param4 * _vertexSize,param5 * _vertexSize);
            if(param3)
            {
               _loc9_ = (_loc11_ = param2 * _vertexSize + _posOffset) + param5 * _vertexSize;
               while(_loc11_ < _loc9_)
               {
                  _loc8_.position = _loc11_;
                  _loc12_ = _loc8_.readFloat();
                  _loc13_ = _loc8_.readFloat();
                  _loc8_.position = _loc11_;
                  _loc8_.writeFloat(param3.a * _loc12_ + param3.c * _loc13_ + param3.tx);
                  _loc8_.writeFloat(param3.d * _loc13_ + param3.b * _loc12_ + param3.ty);
                  _loc11_ += _vertexSize;
               }
            }
         }
         else
         {
            if(param1._numVertices < param2 + param5)
            {
               param1.numVertices = param2 + param5;
            }
            _loc7_ = 0;
            while(_loc7_ < _numAttributes)
            {
               _loc10_ = _attributes[_loc7_];
               if(_loc6_ = param1.getAttribute(_loc10_.name))
               {
                  if(_loc10_.offset == _posOffset)
                  {
                     copyAttributeTo_internal(param1,param2,param3,_loc10_,_loc6_,param4,param5);
                  }
                  else
                  {
                     copyAttributeTo_internal(param1,param2,null,_loc10_,_loc6_,param4,param5);
                  }
               }
               _loc7_++;
            }
         }
      }
      
      public function copyAttributeTo(param1:VertexData, param2:int, param3:String, param4:Matrix = null, param5:int = 0, param6:int = -1) : void
      {
         var _loc8_:VertexDataAttribute = getAttribute(param3);
         var _loc7_:VertexDataAttribute = param1.getAttribute(param3);
         if(_loc8_ == null)
         {
            throw new ArgumentError("Attribute \'" + param3 + "\' not found in source data");
         }
         if(_loc7_ == null)
         {
            throw new ArgumentError("Attribute \'" + param3 + "\' not found in target data");
         }
         if(_loc8_.isColor)
         {
            param1._tinted ||= _tinted;
         }
         copyAttributeTo_internal(param1,param2,param4,_loc8_,_loc7_,param5,param6);
      }
      
      private function copyAttributeTo_internal(param1:VertexData, param2:int, param3:Matrix, param4:VertexDataAttribute, param5:VertexDataAttribute, param6:int, param7:int) : void
      {
         var _loc11_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc10_:int = 0;
         if(param4.format != param5.format)
         {
            throw new IllegalOperationError("Attribute formats differ between source and target");
         }
         if(param7 < 0 || param6 + param7 > _numVertices)
         {
            param7 = _numVertices - param6;
         }
         if(param1._numVertices < param2 + param7)
         {
            param1._numVertices = param2 + param7;
         }
         var _loc16_:ByteArray = _rawData;
         var _loc8_:ByteArray = param1._rawData;
         var _loc12_:int = _vertexSize - param4.size;
         var _loc15_:int = param1._vertexSize - param5.size;
         var _loc9_:int = param4.size / 4;
         _loc16_.position = param6 * _vertexSize + param4.offset;
         _loc8_.position = param2 * param1._vertexSize + param5.offset;
         if(param3)
         {
            _loc10_ = 0;
            while(_loc10_ < param7)
            {
               _loc13_ = _loc16_.readFloat();
               _loc14_ = _loc16_.readFloat();
               _loc8_.writeFloat(param3.a * _loc13_ + param3.c * _loc14_ + param3.tx);
               _loc8_.writeFloat(param3.d * _loc14_ + param3.b * _loc13_ + param3.ty);
               _loc16_.position += _loc12_;
               _loc8_.position += _loc15_;
               _loc10_++;
            }
         }
         else
         {
            _loc10_ = 0;
            while(_loc10_ < param7)
            {
               _loc11_ = 0;
               while(_loc11_ < _loc9_)
               {
                  _loc8_.writeUnsignedInt(_loc16_.readUnsignedInt());
                  _loc11_++;
               }
               _loc16_.position += _loc12_;
               _loc8_.position += _loc15_;
               _loc10_++;
            }
         }
      }
      
      public function trim() : void
      {
         var _loc1_:int = _numVertices * _vertexSize;
         sBytes.length = _loc1_;
         sBytes.position = 0;
         sBytes.writeBytes(_rawData,0,_loc1_);
         _rawData.clear();
         _rawData.length = _loc1_;
         _rawData.writeBytes(sBytes);
         sBytes.clear();
      }
      
      public function toString() : String
      {
         return StringUtil.format("[VertexData format=\"{0}\" numVertices={1}]",_format.formatString,_numVertices);
      }
      
      public function getUnsignedInt(param1:int, param2:String) : uint
      {
         _rawData.position = param1 * _vertexSize + getAttribute(param2).offset;
         return _rawData.readUnsignedInt();
      }
      
      public function setUnsignedInt(param1:int, param2:String, param3:uint) : void
      {
         if(_numVertices < param1 + 1)
         {
            numVertices = param1 + 1;
         }
         _rawData.position = param1 * _vertexSize + getAttribute(param2).offset;
         _rawData.writeUnsignedInt(param3);
      }
      
      public function getFloat(param1:int, param2:String) : Number
      {
         _rawData.position = param1 * _vertexSize + getAttribute(param2).offset;
         return _rawData.readFloat();
      }
      
      public function setFloat(param1:int, param2:String, param3:Number) : void
      {
         if(_numVertices < param1 + 1)
         {
            numVertices = param1 + 1;
         }
         _rawData.position = param1 * _vertexSize + getAttribute(param2).offset;
         _rawData.writeFloat(param3);
      }
      
      public function getPoint(param1:int, param2:String, param3:Point = null) : Point
      {
         if(param3 == null)
         {
            param3 = new Point();
         }
         var _loc4_:int = param2 == "position" ? _posOffset : getAttribute(param2).offset;
         _rawData.position = param1 * _vertexSize + _loc4_;
         param3.x = _rawData.readFloat();
         param3.y = _rawData.readFloat();
         return param3;
      }
      
      public function setPoint(param1:int, param2:String, param3:Number, param4:Number) : void
      {
         if(_numVertices < param1 + 1)
         {
            numVertices = param1 + 1;
         }
         var _loc5_:int = param2 == "position" ? _posOffset : getAttribute(param2).offset;
         _rawData.position = param1 * _vertexSize + _loc5_;
         _rawData.writeFloat(param3);
         _rawData.writeFloat(param4);
      }
      
      public function getPoint3D(param1:int, param2:String, param3:Vector3D = null) : Vector3D
      {
         if(param3 == null)
         {
            param3 = new Vector3D();
         }
         _rawData.position = param1 * _vertexSize + getAttribute(param2).offset;
         param3.x = _rawData.readFloat();
         param3.y = _rawData.readFloat();
         param3.z = _rawData.readFloat();
         return param3;
      }
      
      public function setPoint3D(param1:int, param2:String, param3:Number, param4:Number, param5:Number) : void
      {
         if(_numVertices < param1 + 1)
         {
            numVertices = param1 + 1;
         }
         _rawData.position = param1 * _vertexSize + getAttribute(param2).offset;
         _rawData.writeFloat(param3);
         _rawData.writeFloat(param4);
         _rawData.writeFloat(param5);
      }
      
      public function getPoint4D(param1:int, param2:String, param3:Vector3D = null) : Vector3D
      {
         if(param3 == null)
         {
            param3 = new Vector3D();
         }
         _rawData.position = param1 * _vertexSize + getAttribute(param2).offset;
         param3.x = _rawData.readFloat();
         param3.y = _rawData.readFloat();
         param3.z = _rawData.readFloat();
         param3.w = _rawData.readFloat();
         return param3;
      }
      
      public function setPoint4D(param1:int, param2:String, param3:Number, param4:Number, param5:Number, param6:Number = 1) : void
      {
         if(_numVertices < param1 + 1)
         {
            numVertices = param1 + 1;
         }
         _rawData.position = param1 * _vertexSize + getAttribute(param2).offset;
         _rawData.writeFloat(param3);
         _rawData.writeFloat(param4);
         _rawData.writeFloat(param5);
         _rawData.writeFloat(param6);
      }
      
      public function getColor(param1:int, param2:String = "color") : uint
      {
         var _loc4_:int = param2 == "color" ? _colOffset : getAttribute(param2).offset;
         _rawData.position = param1 * _vertexSize + _loc4_;
         var _loc3_:uint = switchEndian(_rawData.readUnsignedInt());
         if(_premultipliedAlpha)
         {
            _loc3_ = unmultiplyAlpha(_loc3_);
         }
         return _loc3_ >> 8 & 16777215;
      }
      
      public function setColor(param1:int, param2:String, param3:uint) : void
      {
         if(_numVertices < param1 + 1)
         {
            numVertices = param1 + 1;
         }
         var _loc4_:Number = getAlpha(param1,param2);
         colorize(param2,param3,_loc4_,param1,1);
      }
      
      public function getAlpha(param1:int, param2:String = "color") : Number
      {
         var _loc4_:int = param2 == "color" ? _colOffset : getAttribute(param2).offset;
         _rawData.position = param1 * _vertexSize + _loc4_;
         var _loc3_:uint = switchEndian(_rawData.readUnsignedInt());
         return (_loc3_ & 255) / 255;
      }
      
      public function setAlpha(param1:int, param2:String, param3:Number) : void
      {
         if(_numVertices < param1 + 1)
         {
            numVertices = param1 + 1;
         }
         var _loc4_:uint = getColor(param1,param2);
         colorize(param2,_loc4_,param3,param1,1);
      }
      
      public function getBounds(param1:String = "position", param2:Matrix = null, param3:int = 0, param4:int = -1, param5:Rectangle = null) : Rectangle
      {
         var _loc11_:* = NaN;
         var _loc10_:* = NaN;
         var _loc6_:int = 0;
         var _loc14_:int = 0;
         var _loc13_:Number = NaN;
         var _loc9_:int = 0;
         var _loc12_:Number = NaN;
         if(param5 == null)
         {
            param5 = new Rectangle();
         }
         if(param4 < 0 || param3 + param4 > _numVertices)
         {
            param4 = _numVertices - param3;
         }
         if(param4 == 0)
         {
            if(param2 == null)
            {
               param5.setEmpty();
            }
            else
            {
               MatrixUtil.transformCoords(param2,0,0,sHelperPoint);
               param5.setTo(sHelperPoint.x,sHelperPoint.y,0,0);
            }
         }
         else
         {
            _loc11_ = 1.7976931348623157e+308;
            var _loc8_:* = -1.7976931348623157e+308;
            _loc10_ = 1.7976931348623157e+308;
            var _loc7_:* = -1.7976931348623157e+308;
            _loc6_ = param1 == "position" ? _posOffset : getAttribute(param1).offset;
            _loc14_ = param3 * _vertexSize + _loc6_;
            if(param2 == null)
            {
               _loc9_ = 0;
               while(_loc9_ < param4)
               {
                  _rawData.position = _loc14_;
                  _loc12_ = _rawData.readFloat();
                  _loc13_ = _rawData.readFloat();
                  _loc14_ += _vertexSize;
                  if(_loc11_ > _loc12_)
                  {
                     _loc11_ = _loc12_;
                  }
                  if(_loc8_ < _loc12_)
                  {
                     _loc8_ = _loc12_;
                  }
                  if(_loc10_ > _loc13_)
                  {
                     _loc10_ = _loc13_;
                  }
                  if(_loc7_ < _loc13_)
                  {
                     _loc7_ = _loc13_;
                  }
                  _loc9_++;
               }
            }
            else
            {
               _loc9_ = 0;
               while(_loc9_ < param4)
               {
                  _rawData.position = _loc14_;
                  _loc12_ = _rawData.readFloat();
                  _loc13_ = _rawData.readFloat();
                  _loc14_ += _vertexSize;
                  MatrixUtil.transformCoords(param2,_loc12_,_loc13_,sHelperPoint);
                  if(_loc11_ > sHelperPoint.x)
                  {
                     _loc11_ = sHelperPoint.x;
                  }
                  if(_loc8_ < sHelperPoint.x)
                  {
                     _loc8_ = sHelperPoint.x;
                  }
                  if(_loc10_ > sHelperPoint.y)
                  {
                     _loc10_ = sHelperPoint.y;
                  }
                  if(_loc7_ < sHelperPoint.y)
                  {
                     _loc7_ = sHelperPoint.y;
                  }
                  _loc9_++;
               }
            }
            param5.setTo(_loc11_,_loc10_,_loc8_ - _loc11_,_loc7_ - _loc10_);
         }
         return param5;
      }
      
      public function getBoundsProjected(param1:String, param2:Matrix3D, param3:Vector3D, param4:int = 0, param5:int = -1, param6:Rectangle = null) : Rectangle
      {
         var _loc12_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc7_:int = 0;
         var _loc15_:int = 0;
         var _loc14_:Number = NaN;
         var _loc10_:int = 0;
         var _loc13_:Number = NaN;
         if(param6 == null)
         {
            param6 = new Rectangle();
         }
         if(param3 == null)
         {
            throw new ArgumentError("camPos must not be null");
         }
         if(param5 < 0 || param4 + param5 > _numVertices)
         {
            param5 = _numVertices - param4;
         }
         if(param5 == 0)
         {
            if(param2)
            {
               MatrixUtil.transformCoords3D(param2,0,0,0,sHelperPoint3D);
            }
            else
            {
               sHelperPoint3D.setTo(0,0,0);
            }
            MathUtil.intersectLineWithXYPlane(param3,sHelperPoint3D,sHelperPoint);
            param6.setTo(sHelperPoint.x,sHelperPoint.y,0,0);
         }
         else
         {
            _loc12_ = 1.7976931348623157e+308;
            var _loc9_:Number = -1.7976931348623157e+308;
            _loc11_ = 1.7976931348623157e+308;
            var _loc8_:Number = -1.7976931348623157e+308;
            _loc7_ = param1 == "position" ? _posOffset : getAttribute(param1).offset;
            _loc15_ = param4 * _vertexSize + _loc7_;
            _loc10_ = 0;
            while(_loc10_ < param5)
            {
               _rawData.position = _loc15_;
               _loc13_ = _rawData.readFloat();
               _loc14_ = _rawData.readFloat();
               _loc15_ += _vertexSize;
               if(param2)
               {
                  MatrixUtil.transformCoords3D(param2,_loc13_,_loc14_,0,sHelperPoint3D);
               }
               else
               {
                  sHelperPoint3D.setTo(_loc13_,_loc14_,0);
               }
               MathUtil.intersectLineWithXYPlane(param3,sHelperPoint3D,sHelperPoint);
               if(_loc12_ > sHelperPoint.x)
               {
                  _loc12_ = sHelperPoint.x;
               }
               if(_loc9_ < sHelperPoint.x)
               {
                  _loc9_ = sHelperPoint.x;
               }
               if(_loc11_ > sHelperPoint.y)
               {
                  _loc11_ = sHelperPoint.y;
               }
               if(_loc8_ < sHelperPoint.y)
               {
                  _loc8_ = sHelperPoint.y;
               }
               _loc10_++;
            }
            param6.setTo(_loc12_,_loc11_,_loc9_ - _loc12_,_loc8_ - _loc11_);
         }
         return param6;
      }
      
      public function get premultipliedAlpha() : Boolean
      {
         return _premultipliedAlpha;
      }
      
      public function set premultipliedAlpha(param1:Boolean) : void
      {
         setPremultipliedAlpha(param1,false);
      }
      
      public function setPremultipliedAlpha(param1:Boolean, param2:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc8_:VertexDataAttribute = null;
         var _loc4_:int = 0;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         var _loc7_:int = 0;
         if(param2 && param1 != _premultipliedAlpha)
         {
            _loc6_ = 0;
            while(_loc6_ < _numAttributes)
            {
               if((_loc8_ = _attributes[_loc6_]).isColor)
               {
                  _loc4_ = _loc8_.offset;
                  _loc7_ = 0;
                  while(_loc7_ < _numVertices)
                  {
                     _rawData.position = _loc4_;
                     _loc3_ = switchEndian(_rawData.readUnsignedInt());
                     _loc5_ = param1 ? premultiplyAlpha(_loc3_) : unmultiplyAlpha(_loc3_);
                     _rawData.position = _loc4_;
                     _rawData.writeUnsignedInt(switchEndian(_loc5_));
                     _loc4_ += _vertexSize;
                     _loc7_++;
                  }
               }
               _loc6_++;
            }
         }
         _premultipliedAlpha = param1;
      }
      
      public function updateTinted(param1:String = "color") : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:int = param1 == "color" ? _colOffset : getAttribute(param1).offset;
         _tinted = false;
         _loc3_ = 0;
         while(_loc3_ < _numVertices)
         {
            _rawData.position = _loc2_;
            if(_rawData.readUnsignedInt() != 4294967295)
            {
               _tinted = true;
               break;
            }
            _loc2_ += _vertexSize;
            _loc3_++;
         }
         return _tinted;
      }
      
      public function transformPoints(param1:String, param2:Matrix, param3:int = 0, param4:int = -1) : void
      {
         var _loc8_:Number = NaN;
         var _loc7_:Number = NaN;
         if(param4 < 0 || param3 + param4 > _numVertices)
         {
            param4 = _numVertices - param3;
         }
         var _loc5_:int = param1 == "position" ? _posOffset : getAttribute(param1).offset;
         var _loc6_:int;
         var _loc9_:int = (_loc6_ = param3 * _vertexSize + _loc5_) + param4 * _vertexSize;
         while(_loc6_ < _loc9_)
         {
            _rawData.position = _loc6_;
            _loc7_ = _rawData.readFloat();
            _loc8_ = _rawData.readFloat();
            _rawData.position = _loc6_;
            _rawData.writeFloat(param2.a * _loc7_ + param2.c * _loc8_ + param2.tx);
            _rawData.writeFloat(param2.d * _loc8_ + param2.b * _loc7_ + param2.ty);
            _loc6_ += _vertexSize;
         }
      }
      
      public function translatePoints(param1:String, param2:Number, param3:Number, param4:int = 0, param5:int = -1) : void
      {
         var _loc9_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param5 < 0 || param4 + param5 > _numVertices)
         {
            param5 = _numVertices - param4;
         }
         var _loc6_:int = param1 == "position" ? _posOffset : getAttribute(param1).offset;
         var _loc7_:int;
         var _loc10_:int = (_loc7_ = param4 * _vertexSize + _loc6_) + param5 * _vertexSize;
         while(_loc7_ < _loc10_)
         {
            _rawData.position = _loc7_;
            _loc8_ = _rawData.readFloat();
            _loc9_ = _rawData.readFloat();
            _rawData.position = _loc7_;
            _rawData.writeFloat(_loc8_ + param2);
            _rawData.writeFloat(_loc9_ + param3);
            _loc7_ += _vertexSize;
         }
      }
      
      public function scaleAlphas(param1:String, param2:Number, param3:int = 0, param4:int = -1) : void
      {
         var _loc9_:int = 0;
         var _loc8_:Number = NaN;
         var _loc5_:* = 0;
         var _loc10_:int = 0;
         if(param2 == 1)
         {
            return;
         }
         if(param4 < 0 || param3 + param4 > _numVertices)
         {
            param4 = _numVertices - param3;
         }
         _tinted = true;
         var _loc6_:int = param1 == "color" ? _colOffset : getAttribute(param1).offset;
         var _loc7_:int = param3 * _vertexSize + _loc6_;
         _loc9_ = 0;
         while(_loc9_ < param4)
         {
            _loc10_ = _loc7_ + 3;
            if((_loc8_ = _rawData[_loc10_] / 255 * param2) > 1)
            {
               _loc8_ = 1;
            }
            else if(_loc8_ < 0)
            {
               _loc8_ = 0;
            }
            if(_loc8_ == 1 || !_premultipliedAlpha)
            {
               _rawData[_loc10_] = int(_loc8_ * 255);
            }
            else
            {
               _rawData.position = _loc7_;
               _loc5_ = uint((_loc5_ = unmultiplyAlpha(switchEndian(_rawData.readUnsignedInt()))) & 4294967040 | int(_loc8_ * 255) & 255);
               _loc5_ = premultiplyAlpha(_loc5_);
               _rawData.position = _loc7_;
               _rawData.writeUnsignedInt(switchEndian(_loc5_));
            }
            _loc7_ += _vertexSize;
            _loc9_++;
         }
      }
      
      public function colorize(param1:String = "color", param2:uint = 16777215, param3:Number = 1, param4:int = 0, param5:int = -1) : void
      {
         if(param5 < 0 || param4 + param5 > _numVertices)
         {
            param5 = _numVertices - param4;
         }
         var _loc7_:int = param1 == "color" ? _colOffset : getAttribute(param1).offset;
         var _loc8_:int;
         var _loc9_:int = (_loc8_ = param4 * _vertexSize + _loc7_) + param5 * _vertexSize;
         if(param3 > 1)
         {
            param3 = 1;
         }
         else if(param3 < 0)
         {
            param3 = 0;
         }
         var _loc6_:uint;
         if((_loc6_ = uint(param2 << 8 & 4294967040 | int(param3 * 255) & 255)) == 4294967295 && param5 == _numVertices)
         {
            _tinted = false;
         }
         else if(_loc6_ != 4294967295)
         {
            _tinted = true;
         }
         if(_premultipliedAlpha && param3 != 1)
         {
            _loc6_ = premultiplyAlpha(_loc6_);
         }
         _rawData.position = param4 * _vertexSize + _loc7_;
         _rawData.writeUnsignedInt(switchEndian(_loc6_));
         while(_loc8_ < _loc9_)
         {
            _rawData.position = _loc8_;
            _rawData.writeUnsignedInt(switchEndian(_loc6_));
            _loc8_ += _vertexSize;
         }
      }
      
      public function getFormat(param1:String) : String
      {
         return getAttribute(param1).format;
      }
      
      public function getSize(param1:String) : int
      {
         return getAttribute(param1).size;
      }
      
      public function getSizeIn32Bits(param1:String) : int
      {
         return getAttribute(param1).size / 4;
      }
      
      public function getOffset(param1:String) : int
      {
         return getAttribute(param1).offset;
      }
      
      public function getOffsetIn32Bits(param1:String) : int
      {
         return getAttribute(param1).offset / 4;
      }
      
      public function hasAttribute(param1:String) : Boolean
      {
         return getAttribute(param1) != null;
      }
      
      public function createVertexBuffer(param1:Boolean = false, param2:String = "staticDraw") : VertexBuffer3D
      {
         var _loc3_:Context3D = Starling.context;
         if(_loc3_ == null)
         {
            throw new MissingContextError();
         }
         if(_numVertices == 0)
         {
            return null;
         }
         var _loc4_:VertexBuffer3D = _loc3_.createVertexBuffer(_numVertices,_vertexSize / 4,param2);
         if(param1)
         {
            uploadToVertexBuffer(_loc4_);
         }
         return _loc4_;
      }
      
      public function uploadToVertexBuffer(param1:VertexBuffer3D, param2:int = 0, param3:int = -1) : void
      {
         if(param3 < 0 || param2 + param3 > _numVertices)
         {
            param3 = _numVertices - param2;
         }
         if(param3 > 0)
         {
            param1.uploadFromByteArray(_rawData,0,param2,param3);
         }
      }
      
      final private function getAttribute(param1:String) : VertexDataAttribute
      {
         var _loc3_:VertexDataAttribute = null;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _numAttributes)
         {
            _loc3_ = _attributes[_loc2_];
            if(_loc3_.name == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function get numVertices() : int
      {
         return _numVertices;
      }
      
      public function set numVertices(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:VertexDataAttribute = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         if(param1 > _numVertices)
         {
            _loc2_ = _numVertices * vertexSize;
            _loc3_ = param1 * _vertexSize;
            if(_rawData.length > _loc2_)
            {
               _rawData.position = _loc2_;
               while(_rawData.bytesAvailable)
               {
                  _rawData.writeUnsignedInt(0);
               }
            }
            if(_rawData.length < _loc3_)
            {
               _rawData.length = _loc3_;
            }
            _loc5_ = 0;
            while(_loc5_ < _numAttributes)
            {
               if((_loc7_ = _attributes[_loc5_]).isColor)
               {
                  _loc4_ = _numVertices * _vertexSize + _loc7_.offset;
                  _loc6_ = _numVertices;
                  while(_loc6_ < param1)
                  {
                     _rawData.position = _loc4_;
                     _rawData.writeUnsignedInt(4294967295);
                     _loc4_ += _vertexSize;
                     _loc6_++;
                  }
               }
               _loc5_++;
            }
         }
         if(param1 == 0)
         {
            _tinted = false;
         }
         _numVertices = param1;
      }
      
      public function get rawData() : ByteArray
      {
         return _rawData;
      }
      
      public function get format() : VertexDataFormat
      {
         return _format;
      }
      
      public function set format(param1:VertexDataFormat) : void
      {
         var _loc8_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:VertexDataAttribute = null;
         var _loc5_:VertexDataAttribute = null;
         if(_format === param1)
         {
            return;
         }
         var _loc2_:int = _format.vertexSize;
         var _loc9_:int = param1.vertexSize;
         var _loc3_:int = param1.numAttributes;
         sBytes.length = param1.vertexSize * _numVertices;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc7_ = param1.attributes[_loc4_];
            if(_loc5_ = getAttribute(_loc7_.name))
            {
               _loc6_ = _loc7_.offset;
               _loc8_ = 0;
               while(_loc8_ < _numVertices)
               {
                  sBytes.position = _loc6_;
                  sBytes.writeBytes(_rawData,_loc2_ * _loc8_ + _loc5_.offset,_loc5_.size);
                  _loc6_ += _loc9_;
                  _loc8_++;
               }
            }
            else if(_loc7_.isColor)
            {
               _loc6_ = _loc7_.offset;
               _loc8_ = 0;
               while(_loc8_ < _numVertices)
               {
                  sBytes.position = _loc6_;
                  sBytes.writeUnsignedInt(4294967295);
                  _loc6_ += _loc9_;
                  _loc8_++;
               }
            }
            _loc4_++;
         }
         _rawData.clear();
         _rawData.length = sBytes.length;
         _rawData.writeBytes(sBytes);
         sBytes.clear();
         _format = param1;
         _attributes = _format.attributes;
         _numAttributes = _attributes.length;
         _vertexSize = _format.vertexSize;
         _posOffset = _format.hasAttribute("position") ? _format.getOffset("position") : 0;
         _colOffset = _format.hasAttribute("color") ? _format.getOffset("color") : 0;
      }
      
      public function get tinted() : Boolean
      {
         return _tinted;
      }
      
      public function set tinted(param1:Boolean) : void
      {
         _tinted = param1;
      }
      
      public function get formatString() : String
      {
         return _format.formatString;
      }
      
      public function get vertexSize() : int
      {
         return _vertexSize;
      }
      
      public function get vertexSizeIn32Bits() : int
      {
         return _vertexSize / 4;
      }
      
      public function get size() : int
      {
         return _numVertices * _vertexSize;
      }
      
      public function get sizeIn32Bits() : int
      {
         return _numVertices * _vertexSize / 4;
      }
   }
}
