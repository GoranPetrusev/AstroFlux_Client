package feathers.utils.geom
{
   import flash.geom.Matrix;
   
   public function matrixToRotation(param1:Matrix) : Number
   {
      var _loc2_:Number = param1.c;
      var _loc3_:Number = param1.d;
      return -Math.atan(_loc2_ / _loc3_);
   }
}
