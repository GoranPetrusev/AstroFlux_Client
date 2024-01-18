package starling.utils
{
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import starling.errors.AbstractClassError;
   
   public class MathUtil
   {
      
      private static const TWO_PI:Number = 6.283185307179586;
       
      
      public function MathUtil()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function intersectLineWithXYPlane(param1:Vector3D, param2:Vector3D, param3:Point = null) : Point
      {
         if(param3 == null)
         {
            param3 = new Point();
         }
         var _loc7_:Number = param2.x - param1.x;
         var _loc5_:Number = param2.y - param1.y;
         var _loc6_:Number = param2.z - param1.z;
         var _loc4_:Number = -param1.z / _loc6_;
         param3.x = param1.x + _loc4_ * _loc7_;
         param3.y = param1.y + _loc4_ * _loc5_;
         return param3;
      }
      
      public static function isPointInTriangle(param1:Point, param2:Point, param3:Point, param4:Point) : Boolean
      {
         var _loc15_:Number = param4.x - param2.x;
         var _loc13_:Number = param4.y - param2.y;
         var _loc8_:Number = param3.x - param2.x;
         var _loc16_:Number = param3.y - param2.y;
         var _loc12_:Number = param1.x - param2.x;
         var _loc9_:Number = param1.y - param2.y;
         var _loc10_:Number = _loc15_ * _loc15_ + _loc13_ * _loc13_;
         var _loc17_:Number = _loc15_ * _loc8_ + _loc13_ * _loc16_;
         var _loc14_:Number = _loc15_ * _loc12_ + _loc13_ * _loc9_;
         var _loc11_:Number = _loc8_ * _loc8_ + _loc16_ * _loc16_;
         var _loc18_:Number = _loc8_ * _loc12_ + _loc16_ * _loc9_;
         var _loc5_:Number = 1 / (_loc10_ * _loc11_ - _loc17_ * _loc17_);
         var _loc6_:Number = (_loc11_ * _loc14_ - _loc17_ * _loc18_) * _loc5_;
         var _loc7_:Number = (_loc10_ * _loc18_ - _loc17_ * _loc14_) * _loc5_;
         return _loc6_ >= 0 && _loc7_ >= 0 && _loc6_ + _loc7_ < 1;
      }
      
      public static function normalizeAngle(param1:Number) : Number
      {
         param1 %= 6.283185307179586;
         if(param1 < -3.141592653589793)
         {
            param1 += 6.283185307179586;
         }
         if(param1 > 3.141592653589793)
         {
            param1 -= 6.283185307179586;
         }
         return param1;
      }
      
      public static function getNextPowerOfTwo(param1:Number) : int
      {
         var _loc2_:* = 0;
         if(param1 is int && param1 > 0 && (param1 & param1 - 1) == 0)
         {
            return param1;
         }
         _loc2_ = 1;
         param1 -= 1e-9;
         while(_loc2_ < param1)
         {
            _loc2_ <<= 1;
         }
         return _loc2_;
      }
      
      public static function isEquivalent(param1:Number, param2:Number, param3:Number = 0.0001) : Boolean
      {
         return param1 - param3 < param2 && param1 + param3 > param2;
      }
      
      public static function max(param1:Number, param2:Number) : Number
      {
         return param1 > param2 ? param1 : param2;
      }
      
      public static function min(param1:Number, param2:Number) : Number
      {
         return param1 < param2 ? param1 : param2;
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 < param2 ? param2 : (param1 > param3 ? param3 : param1);
      }
   }
}
