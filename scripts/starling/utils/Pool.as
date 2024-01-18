package starling.utils
{
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import starling.errors.AbstractClassError;
   
   public class Pool
   {
      
      private static var sPoints:Vector.<Point> = new Vector.<Point>(0);
      
      private static var sPoints3D:Vector.<Vector3D> = new Vector.<Vector3D>(0);
      
      private static var sMatrices:Vector.<Matrix> = new Vector.<Matrix>(0);
      
      private static var sMatrices3D:Vector.<Matrix3D> = new Vector.<Matrix3D>(0);
      
      private static var sRectangles:Vector.<Rectangle> = new Vector.<Rectangle>(0);
       
      
      public function Pool()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function getPoint(param1:Number = 0, param2:Number = 0) : Point
      {
         var _loc3_:Point = null;
         if(sPoints.length == 0)
         {
            return new Point(param1,param2);
         }
         _loc3_ = sPoints.pop();
         _loc3_.x = param1;
         _loc3_.y = param2;
         return _loc3_;
      }
      
      public static function putPoint(param1:Point) : void
      {
         if(param1)
         {
            sPoints[sPoints.length] = param1;
         }
      }
      
      public static function getPoint3D(param1:Number = 0, param2:Number = 0, param3:Number = 0) : Vector3D
      {
         var _loc4_:Vector3D = null;
         if(sPoints3D.length == 0)
         {
            return new Vector3D(param1,param2,param3);
         }
         (_loc4_ = sPoints3D.pop()).x = param1;
         _loc4_.y = param2;
         _loc4_.z = param3;
         return _loc4_;
      }
      
      public static function putPoint3D(param1:Vector3D) : void
      {
         if(param1)
         {
            sPoints3D[sPoints3D.length] = param1;
         }
      }
      
      public static function getMatrix(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 1, param5:Number = 0, param6:Number = 0) : Matrix
      {
         var _loc7_:Matrix = null;
         if(sMatrices.length == 0)
         {
            return new Matrix(param1,param2,param3,param4,param5,param6);
         }
         (_loc7_ = sMatrices.pop()).setTo(param1,param2,param3,param4,param5,param6);
         return _loc7_;
      }
      
      public static function putMatrix(param1:Matrix) : void
      {
         if(param1)
         {
            sMatrices[sMatrices.length] = param1;
         }
      }
      
      public static function getMatrix3D(param1:Boolean = true) : Matrix3D
      {
         var _loc2_:Matrix3D = null;
         if(sMatrices3D.length == 0)
         {
            return new Matrix3D();
         }
         _loc2_ = sMatrices3D.pop();
         if(param1)
         {
            _loc2_.identity();
         }
         return _loc2_;
      }
      
      public static function putMatrix3D(param1:Matrix3D) : void
      {
         if(param1)
         {
            sMatrices3D[sMatrices3D.length] = param1;
         }
      }
      
      public static function getRectangle(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : Rectangle
      {
         var _loc5_:Rectangle = null;
         if(sRectangles.length == 0)
         {
            return new Rectangle(param1,param2,param3,param4);
         }
         (_loc5_ = sRectangles.pop()).setTo(param1,param2,param3,param4);
         return _loc5_;
      }
      
      public static function putRectangle(param1:Rectangle) : void
      {
         if(param1)
         {
            sRectangles[sRectangles.length] = param1;
         }
      }
   }
}
