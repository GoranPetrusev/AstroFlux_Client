package starling.utils
{
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import starling.errors.AbstractClassError;
   
   public class MatrixUtil
   {
      
      private static var sRawData:Vector.<Number> = new <Number>[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
      
      private static var sRawData2:Vector.<Number> = new Vector.<Number>(16,true);
      
      private static var sPoint3D:Vector3D = new Vector3D();
      
      private static var sMatrixData:Vector.<Number> = new <Number>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
       
      
      public function MatrixUtil()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function convertTo3D(param1:Matrix, param2:Matrix3D = null) : Matrix3D
      {
         if(param2 == null)
         {
            param2 = new Matrix3D();
         }
         sRawData[0] = param1.a;
         sRawData[1] = param1.b;
         sRawData[4] = param1.c;
         sRawData[5] = param1.d;
         sRawData[12] = param1.tx;
         sRawData[13] = param1.ty;
         param2.copyRawDataFrom(sRawData);
         return param2;
      }
      
      public static function convertTo2D(param1:Matrix3D, param2:Matrix = null) : Matrix
      {
         if(param2 == null)
         {
            param2 = new Matrix();
         }
         param1.copyRawDataTo(sRawData2);
         param2.a = sRawData2[0];
         param2.b = sRawData2[1];
         param2.c = sRawData2[4];
         param2.d = sRawData2[5];
         param2.tx = sRawData2[12];
         param2.ty = sRawData2[13];
         return param2;
      }
      
      public static function isIdentity(param1:Matrix) : Boolean
      {
         return param1.a == 1 && param1.b == 0 && param1.c == 0 && param1.d == 1 && param1.tx == 0 && param1.ty == 0;
      }
      
      public static function isIdentity3D(param1:Matrix3D) : Boolean
      {
         var _loc2_:Vector.<Number> = sRawData2;
         param1.copyRawDataTo(_loc2_);
         return _loc2_[0] == 1 && _loc2_[1] == 0 && _loc2_[2] == 0 && _loc2_[3] == 0 && _loc2_[4] == 0 && _loc2_[5] == 1 && _loc2_[6] == 0 && _loc2_[7] == 0 && _loc2_[8] == 0 && _loc2_[9] == 0 && _loc2_[10] == 1 && _loc2_[11] == 0 && _loc2_[12] == 0 && _loc2_[13] == 0 && _loc2_[14] == 0 && _loc2_[15] == 1;
      }
      
      public static function transformPoint(param1:Matrix, param2:Point, param3:Point = null) : Point
      {
         return transformCoords(param1,param2.x,param2.y,param3);
      }
      
      public static function transformPoint3D(param1:Matrix3D, param2:Vector3D, param3:Vector3D = null) : Vector3D
      {
         return transformCoords3D(param1,param2.x,param2.y,param2.z,param3);
      }
      
      public static function transformCoords(param1:Matrix, param2:Number, param3:Number, param4:Point = null) : Point
      {
         if(param4 == null)
         {
            param4 = new Point();
         }
         param4.x = param1.a * param2 + param1.c * param3 + param1.tx;
         param4.y = param1.d * param3 + param1.b * param2 + param1.ty;
         return param4;
      }
      
      public static function transformCoords3D(param1:Matrix3D, param2:Number, param3:Number, param4:Number, param5:Vector3D = null) : Vector3D
      {
         if(param5 == null)
         {
            param5 = new Vector3D();
         }
         param1.copyRawDataTo(sRawData2);
         param5.x = param2 * sRawData2[0] + param3 * sRawData2[4] + param4 * sRawData2[8] + sRawData2[12];
         param5.y = param2 * sRawData2[1] + param3 * sRawData2[5] + param4 * sRawData2[9] + sRawData2[13];
         param5.z = param2 * sRawData2[2] + param3 * sRawData2[6] + param4 * sRawData2[10] + sRawData2[14];
         param5.w = param2 * sRawData2[3] + param3 * sRawData2[7] + param4 * sRawData2[11] + sRawData2[15];
         return param5;
      }
      
      public static function skew(param1:Matrix, param2:Number, param3:Number) : void
      {
         var _loc5_:Number = Math.sin(param2);
         var _loc7_:Number = Math.cos(param2);
         var _loc4_:Number = Math.sin(param3);
         var _loc6_:Number = Math.cos(param3);
         param1.setTo(param1.a * _loc6_ - param1.b * _loc5_,param1.a * _loc4_ + param1.b * _loc7_,param1.c * _loc6_ - param1.d * _loc5_,param1.c * _loc4_ + param1.d * _loc7_,param1.tx * _loc6_ - param1.ty * _loc5_,param1.tx * _loc4_ + param1.ty * _loc7_);
      }
      
      public static function prependMatrix(param1:Matrix, param2:Matrix) : void
      {
         param1.setTo(param1.a * param2.a + param1.c * param2.b,param1.b * param2.a + param1.d * param2.b,param1.a * param2.c + param1.c * param2.d,param1.b * param2.c + param1.d * param2.d,param1.tx + param1.a * param2.tx + param1.c * param2.ty,param1.ty + param1.b * param2.tx + param1.d * param2.ty);
      }
      
      public static function prependTranslation(param1:Matrix, param2:Number, param3:Number) : void
      {
         param1.tx += param1.a * param2 + param1.c * param3;
         param1.ty += param1.b * param2 + param1.d * param3;
      }
      
      public static function prependScale(param1:Matrix, param2:Number, param3:Number) : void
      {
         param1.setTo(param1.a * param2,param1.b * param2,param1.c * param3,param1.d * param3,param1.tx,param1.ty);
      }
      
      public static function prependRotation(param1:Matrix, param2:Number) : void
      {
         var _loc4_:Number = Math.sin(param2);
         var _loc3_:Number = Math.cos(param2);
         param1.setTo(param1.a * _loc3_ + param1.c * _loc4_,param1.b * _loc3_ + param1.d * _loc4_,param1.c * _loc3_ - param1.a * _loc4_,param1.d * _loc3_ - param1.b * _loc4_,param1.tx,param1.ty);
      }
      
      public static function prependSkew(param1:Matrix, param2:Number, param3:Number) : void
      {
         var _loc5_:Number = Math.sin(param2);
         var _loc7_:Number = Math.cos(param2);
         var _loc4_:Number = Math.sin(param3);
         var _loc6_:Number = Math.cos(param3);
         param1.setTo(param1.a * _loc6_ + param1.c * _loc4_,param1.b * _loc6_ + param1.d * _loc4_,param1.c * _loc7_ - param1.a * _loc5_,param1.d * _loc7_ - param1.b * _loc5_,param1.tx,param1.ty);
      }
      
      public static function toString3D(param1:Matrix3D, param2:Boolean = true, param3:int = 3) : String
      {
         if(param2)
         {
            param1.transpose();
         }
         param1.copyRawDataTo(sRawData2);
         if(param2)
         {
            param1.transpose();
         }
         return "[Matrix3D rawData=\n" + formatRawData(sRawData2,4,4,param3) + "\n]";
      }
      
      public static function toString(param1:Matrix, param2:int = 3) : String
      {
         sRawData2[0] = param1.a;
         sRawData2[1] = param1.c;
         sRawData2[2] = param1.tx;
         sRawData2[3] = param1.b;
         sRawData2[4] = param1.d;
         sRawData2[5] = param1.ty;
         return "[Matrix rawData=\n" + formatRawData(sRawData2,3,2,param2) + "\n]";
      }
      
      private static function formatRawData(param1:Vector.<Number>, param2:int, param3:int, param4:int, param5:String = "  ") : String
      {
         var _loc10_:String = null;
         var _loc14_:Number = NaN;
         var _loc6_:int = 0;
         var _loc12_:int = 0;
         var _loc11_:int = 0;
         var _loc9_:* = param5;
         var _loc7_:int = param2 * param3;
         var _loc13_:* = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if((_loc14_ = Math.abs(param1[_loc6_])) > _loc13_)
            {
               _loc13_ = _loc14_;
            }
            _loc6_++;
         }
         var _loc8_:int = _loc13_.toFixed(param4).length + 1;
         _loc12_ = 0;
         while(_loc12_ < param3)
         {
            _loc11_ = 0;
            while(_loc11_ < param2)
            {
               _loc10_ = (_loc14_ = param1[param2 * _loc12_ + _loc11_]).toFixed(param4);
               while(_loc10_.length < _loc8_)
               {
                  _loc10_ = " " + _loc10_;
               }
               _loc9_ += _loc10_;
               if(_loc11_ != param2 - 1)
               {
                  _loc9_ += ", ";
               }
               _loc11_++;
            }
            if(_loc12_ != param3 - 1)
            {
               _loc9_ += "\n" + param5;
            }
            _loc12_++;
         }
         return _loc9_;
      }
      
      public static function snapToPixels(param1:Matrix, param2:Number) : void
      {
         var _loc6_:Number = NaN;
         _loc6_ = 0.0001;
         var _loc4_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc7_:Boolean = false;
         if(param1.b + 0.0001 > 0 && param1.b - 0.0001 < 0 && param1.c + 0.0001 > 0 && param1.c - 0.0001 < 0)
         {
            _loc8_ = param1.a * param1.a;
            _loc5_ = param1.d * param1.d;
            _loc7_ = _loc8_ + 0.0001 > 1 && _loc8_ - 0.0001 < 1 && _loc5_ + 0.0001 > 1 && _loc5_ - 0.0001 < 1;
         }
         else if(param1.a + 0.0001 > 0 && param1.a - 0.0001 < 0 && param1.d + 0.0001 > 0 && param1.d - 0.0001 < 0)
         {
            _loc4_ = param1.b * param1.b;
            _loc3_ = param1.c * param1.c;
            _loc7_ = _loc4_ + 0.0001 > 1 && _loc4_ - 0.0001 < 1 && _loc3_ + 0.0001 > 1 && _loc3_ - 0.0001 < 1;
         }
         if(_loc7_)
         {
            param1.tx = Math.round(param1.tx / param2) * param2;
            param1.ty = Math.round(param1.ty / param2) * param2;
         }
      }
      
      public static function createPerspectiveProjectionMatrix(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 0, param6:Number = 0, param7:Vector3D = null, param8:Matrix3D = null) : Matrix3D
      {
         var _loc14_:Number = NaN;
         _loc14_ = 1;
         if(param8 == null)
         {
            param8 = new Matrix3D();
         }
         if(param5 <= 0)
         {
            param5 = param3;
         }
         if(param6 <= 0)
         {
            param6 = param4;
         }
         if(param7 == null)
         {
            (param7 = sPoint3D).setTo(param5 / 2,param6 / 2,param5 / Math.tan(0.5) * 0.5);
         }
         var _loc15_:Number = Math.abs(param7.z);
         var _loc9_:Number = param7.x - param5 / 2;
         var _loc12_:Number = param7.y - param6 / 2;
         var _loc13_:Number = _loc15_ * 20;
         var _loc10_:Number = param5 / param3;
         var _loc11_:Number = param6 / param4;
         sMatrixData[0] = 2 * _loc15_ / param5;
         sMatrixData[5] = -2 * _loc15_ / param6;
         sMatrixData[10] = _loc13_ / (_loc13_ - 1);
         sMatrixData[14] = -_loc13_ * 1 / (_loc13_ - 1);
         sMatrixData[11] = 1;
         sMatrixData[0] *= _loc10_;
         sMatrixData[5] *= _loc11_;
         sMatrixData[8] = _loc10_ - 1 - 2 * _loc10_ * (param1 - _loc9_) / param5;
         sMatrixData[9] = -_loc11_ + 1 + 2 * _loc11_ * (param2 - _loc12_) / param6;
         param8.copyRawDataFrom(sMatrixData);
         param8.prependTranslation(-param5 / 2 - _loc9_,-param6 / 2 - _loc12_,_loc15_);
         return param8;
      }
      
      public static function createOrthographicProjectionMatrix(param1:Number, param2:Number, param3:Number, param4:Number, param5:Matrix = null) : Matrix
      {
         if(param5 == null)
         {
            param5 = new Matrix();
         }
         param5.setTo(2 / param3,0,0,-2 / param4,-(2 * param1 + param3) / param3,(2 * param2 + param4) / param4);
         return param5;
      }
   }
}
