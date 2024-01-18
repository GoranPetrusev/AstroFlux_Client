package starling.display
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.starling_internal;
   import starling.geom.Polygon;
   import starling.rendering.IndexData;
   import starling.rendering.Painter;
   import starling.rendering.VertexData;
   import starling.rendering.VertexDataFormat;
   import starling.styles.MeshStyle;
   import starling.textures.Texture;
   import starling.utils.MatrixUtil;
   import starling.utils.MeshUtil;
   
   use namespace starling_internal;
   
   public class Mesh extends DisplayObject
   {
      
      private static var sDefaultStyle:Class = MeshStyle;
      
      private static var sDefaultStyleFactory:Function = null;
       
      
      internal var _style:MeshStyle;
      
      internal var _vertexData:VertexData;
      
      internal var _indexData:IndexData;
      
      internal var _pixelSnapping:Boolean;
      
      public function Mesh(param1:VertexData, param2:IndexData, param3:MeshStyle = null)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("VertexData must not be null");
         }
         if(param2 == null)
         {
            throw new ArgumentError("IndexData must not be null");
         }
         _vertexData = param1;
         _indexData = param2;
         setStyle(param3,false);
      }
      
      public static function get defaultStyle() : Class
      {
         return sDefaultStyle;
      }
      
      public static function set defaultStyle(param1:Class) : void
      {
         sDefaultStyle = param1;
      }
      
      public static function get defaultStyleFactory() : Function
      {
         return sDefaultStyleFactory;
      }
      
      public static function set defaultStyleFactory(param1:Function) : void
      {
         sDefaultStyleFactory = param1;
      }
      
      public static function fromPolygon(param1:Polygon, param2:MeshStyle = null) : Mesh
      {
         var _loc3_:VertexData = new VertexData(null,param1.numVertices);
         var _loc4_:IndexData = new IndexData(param1.numTriangles);
         param1.copyToVertexData(_loc3_);
         param1.triangulate(_loc4_);
         return new Mesh(_loc3_,_loc4_,param2);
      }
      
      override public function dispose() : void
      {
         _vertexData.clear();
         _indexData.clear();
         super.dispose();
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         if(!visible || !touchable || !hitTestMask(param1))
         {
            return null;
         }
         return MeshUtil.containsPoint(_vertexData,_indexData,param1) ? this : null;
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         return MeshUtil.calculateBounds(_vertexData,this,param1,param2);
      }
      
      override public function render(param1:Painter) : void
      {
         if(_pixelSnapping)
         {
            MatrixUtil.snapToPixels(param1.state.modelviewMatrix,param1.pixelSize);
         }
         param1.batchMesh(this);
      }
      
      public function setStyle(param1:MeshStyle = null, param2:Boolean = true) : void
      {
         if(param1 == null)
         {
            param1 = createDefaultMeshStyle();
         }
         else
         {
            if(param1 == _style)
            {
               return;
            }
            if(param1.target)
            {
               param1.target.setStyle();
            }
         }
         if(_style)
         {
            if(param2)
            {
               param1.copyFrom(_style);
            }
            _style.starling_internal::setTarget();
         }
         _style = param1;
         _style.starling_internal::setTarget(this,_vertexData,_indexData);
         setRequiresRedraw();
      }
      
      private function createDefaultMeshStyle() : MeshStyle
      {
         var _loc1_:MeshStyle = null;
         if(sDefaultStyleFactory != null)
         {
            if(sDefaultStyleFactory.length == 0)
            {
               _loc1_ = sDefaultStyleFactory();
            }
            else
            {
               _loc1_ = sDefaultStyleFactory(this);
            }
         }
         if(_loc1_ == null)
         {
            _loc1_ = new sDefaultStyle() as MeshStyle;
         }
         return _loc1_;
      }
      
      public function setVertexDataChanged() : void
      {
         setRequiresRedraw();
      }
      
      public function setIndexDataChanged() : void
      {
         setRequiresRedraw();
      }
      
      public function getVertexPosition(param1:int, param2:Point = null) : Point
      {
         return _style.getVertexPosition(param1,param2);
      }
      
      public function setVertexPosition(param1:int, param2:Number, param3:Number) : void
      {
         _style.setVertexPosition(param1,param2,param3);
      }
      
      public function getVertexAlpha(param1:int) : Number
      {
         return _style.getVertexAlpha(param1);
      }
      
      public function setVertexAlpha(param1:int, param2:Number) : void
      {
         _style.setVertexAlpha(param1,param2);
      }
      
      public function getVertexColor(param1:int) : uint
      {
         return _style.getVertexColor(param1);
      }
      
      public function setVertexColor(param1:int, param2:uint) : void
      {
         _style.setVertexColor(param1,param2);
      }
      
      public function getTexCoords(param1:int, param2:Point = null) : Point
      {
         return _style.getTexCoords(param1,param2);
      }
      
      public function setTexCoords(param1:int, param2:Number, param3:Number) : void
      {
         _style.setTexCoords(param1,param2,param3);
      }
      
      protected function get vertexData() : VertexData
      {
         return _vertexData;
      }
      
      protected function get indexData() : IndexData
      {
         return _indexData;
      }
      
      public function get style() : MeshStyle
      {
         return _style;
      }
      
      public function set style(param1:MeshStyle) : void
      {
         setStyle(param1);
      }
      
      public function get texture() : Texture
      {
         return _style.texture;
      }
      
      public function set texture(param1:Texture) : void
      {
         _style.texture = param1;
      }
      
      public function get color() : uint
      {
         return _style.color;
      }
      
      public function set color(param1:uint) : void
      {
         _style.color = param1;
      }
      
      public function get textureSmoothing() : String
      {
         return _style.textureSmoothing;
      }
      
      public function set textureSmoothing(param1:String) : void
      {
         _style.textureSmoothing = param1;
      }
      
      public function get textureRepeat() : Boolean
      {
         return _style.textureRepeat;
      }
      
      public function set textureRepeat(param1:Boolean) : void
      {
         _style.textureRepeat = param1;
      }
      
      public function get pixelSnapping() : Boolean
      {
         return _pixelSnapping;
      }
      
      public function set pixelSnapping(param1:Boolean) : void
      {
         _pixelSnapping = param1;
      }
      
      public function get numVertices() : int
      {
         return _vertexData.numVertices;
      }
      
      public function get numIndices() : int
      {
         return _indexData.numIndices;
      }
      
      public function get numTriangles() : int
      {
         return _indexData.numTriangles;
      }
      
      public function get vertexFormat() : VertexDataFormat
      {
         return _style.vertexFormat;
      }
   }
}
