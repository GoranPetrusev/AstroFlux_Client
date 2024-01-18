package starling.display
{
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import starling.rendering.IndexData;
   import starling.rendering.VertexData;
   import starling.styles.MeshStyle;
   import starling.textures.Texture;
   import starling.utils.RectangleUtil;
   
   public class Quad extends Mesh
   {
      
      private static var sPoint3D:Vector3D = new Vector3D();
      
      private static var sMatrix:Matrix = new Matrix();
      
      private static var sMatrix3D:Matrix3D = new Matrix3D();
       
      
      private var _bounds:Rectangle;
      
      public function Quad(param1:Number, param2:Number, param3:uint = 16777215)
      {
         _bounds = new Rectangle(0,0,param1,param2);
         var _loc4_:VertexData = new VertexData(MeshStyle.VERTEX_FORMAT,4);
         var _loc5_:IndexData = new IndexData(6);
         super(_loc4_,_loc5_);
         if(param1 == 0 || param2 == 0)
         {
            throw new ArgumentError("Invalid size: width and height must not be zero");
         }
         setupVertices();
         this.color = param3;
      }
      
      public static function fromTexture(param1:Texture) : Quad
      {
         var _loc2_:Quad = new Quad(100,100);
         _loc2_.texture = param1;
         _loc2_.readjustSize();
         return _loc2_;
      }
      
      protected function setupVertices() : void
      {
         var _loc1_:String = "position";
         var _loc5_:String = "texCoords";
         var _loc2_:Texture = style.texture;
         var _loc3_:VertexData = this.vertexData;
         var _loc4_:IndexData;
         (_loc4_ = this.indexData).numIndices = 0;
         _loc4_.addQuad(0,1,2,3);
         if(_loc3_.numVertices != 4)
         {
            _loc3_.numVertices = 4;
            _loc3_.trim();
         }
         if(_loc2_)
         {
            _loc2_.setupVertexPositions(_loc3_,0,"position",_bounds);
            _loc2_.setupTextureCoordinates(_loc3_,0,_loc5_);
         }
         else
         {
            _loc3_.setPoint(0,_loc1_,_bounds.left,_bounds.top);
            _loc3_.setPoint(1,_loc1_,_bounds.right,_bounds.top);
            _loc3_.setPoint(2,_loc1_,_bounds.left,_bounds.bottom);
            _loc3_.setPoint(3,_loc1_,_bounds.right,_bounds.bottom);
            _loc3_.setPoint(0,_loc5_,0,0);
            _loc3_.setPoint(1,_loc5_,1,0);
            _loc3_.setPoint(2,_loc5_,0,1);
            _loc3_.setPoint(3,_loc5_,1,1);
         }
         setRequiresRedraw();
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param2 == null)
         {
            param2 = new Rectangle();
         }
         if(param1 == this)
         {
            param2.copyFrom(_bounds);
         }
         else if(param1 == parent && !isRotated)
         {
            _loc3_ = this.scaleX;
            _loc4_ = this.scaleY;
            param2.setTo(x - pivotX * _loc3_,y - pivotY * _loc4_,_bounds.width * _loc3_,_bounds.height * _loc4_);
            if(_loc3_ < 0)
            {
               param2.width *= -1;
               param2.x -= param2.width;
            }
            if(_loc4_ < 0)
            {
               param2.height *= -1;
               param2.y -= param2.height;
            }
         }
         else if(is3D && stage)
         {
            stage.getCameraPosition(param1,sPoint3D);
            getTransformationMatrix3D(param1,sMatrix3D);
            RectangleUtil.getBoundsProjected(_bounds,sMatrix3D,sPoint3D,param2);
         }
         else
         {
            getTransformationMatrix(param1,sMatrix);
            RectangleUtil.getBounds(_bounds,sMatrix,param2);
         }
         return param2;
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         if(!visible || !touchable || !hitTestMask(param1))
         {
            return null;
         }
         if(_bounds.containsPoint(param1))
         {
            return this;
         }
         return null;
      }
      
      public function readjustSize(param1:Number = -1, param2:Number = -1) : void
      {
         if(param1 <= 0)
         {
            param1 = !!texture ? texture.frameWidth : _bounds.width;
         }
         if(param2 <= 0)
         {
            param2 = !!texture ? texture.frameHeight : _bounds.height;
         }
         if(param1 != _bounds.width || param2 != _bounds.height)
         {
            _bounds.setTo(0,0,param1,param2);
            setupVertices();
         }
      }
      
      override public function set texture(param1:Texture) : void
      {
         if(param1 != texture)
         {
            super.texture = param1;
            setupVertices();
         }
      }
   }
}
