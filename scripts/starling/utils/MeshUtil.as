package starling.utils
{
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import starling.display.DisplayObject;
   import starling.display.Stage;
   import starling.errors.AbstractClassError;
   import starling.rendering.IndexData;
   import starling.rendering.VertexData;
   
   public class MeshUtil
   {
      
      private static var sPoint3D:Vector3D = new Vector3D();
      
      private static var sMatrix:Matrix = new Matrix();
      
      private static var sMatrix3D:Matrix3D = new Matrix3D();
       
      
      public function MeshUtil()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function containsPoint(param1:VertexData, param2:IndexData, param3:Point) : Boolean
      {
         var _loc9_:int = 0;
         var _loc4_:Boolean = false;
         var _loc7_:int = param2.numIndices;
         var _loc5_:Point = Pool.getPoint();
         var _loc6_:Point = Pool.getPoint();
         var _loc8_:Point = Pool.getPoint();
         _loc9_ = 0;
         while(_loc9_ < _loc7_)
         {
            param1.getPoint(param2.getIndex(_loc9_),"position",_loc5_);
            param1.getPoint(param2.getIndex(_loc9_ + 1),"position",_loc6_);
            param1.getPoint(param2.getIndex(_loc9_ + 2),"position",_loc8_);
            if(MathUtil.isPointInTriangle(param3,_loc5_,_loc6_,_loc8_))
            {
               _loc4_ = true;
               break;
            }
            _loc9_ += 3;
         }
         Pool.putPoint(_loc5_);
         Pool.putPoint(_loc6_);
         Pool.putPoint(_loc8_);
         return _loc4_;
      }
      
      public static function calculateBounds(param1:VertexData, param2:DisplayObject, param3:DisplayObject, param4:Rectangle = null) : Rectangle
      {
         if(param4 == null)
         {
            param4 = new Rectangle();
         }
         var _loc5_:Stage = param2.stage;
         if(param2.is3D && _loc5_)
         {
            _loc5_.getCameraPosition(param3,sPoint3D);
            param2.getTransformationMatrix3D(param3,sMatrix3D);
            param1.getBoundsProjected("position",sMatrix3D,sPoint3D,0,-1,param4);
         }
         else
         {
            param2.getTransformationMatrix(param3,sMatrix);
            param1.getBounds("position",sMatrix,0,-1,param4);
         }
         return param4;
      }
   }
}
