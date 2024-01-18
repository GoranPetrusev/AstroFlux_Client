package starling.styles
{
   import flash.display3D.textures.TextureBase;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import starling.core.starling_internal;
   import starling.display.Mesh;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.rendering.*;
   import starling.textures.Texture;
   
   use namespace starling_internal;
   
   public class MeshStyle extends EventDispatcher
   {
      
      public static const VERTEX_FORMAT:VertexDataFormat = MeshEffect.VERTEX_FORMAT;
      
      private static var sPoint:Point = new Point();
       
      
      private var _type:Class;
      
      private var _target:Mesh;
      
      private var _texture:Texture;
      
      private var _textureBase:TextureBase;
      
      private var _textureSmoothing:String;
      
      private var _textureRepeat:Boolean;
      
      private var _vertexData:VertexData;
      
      private var _indexData:IndexData;
      
      public function MeshStyle()
      {
         super();
         _textureSmoothing = "bilinear";
         _type = Object(this).constructor as Class;
      }
      
      public function copyFrom(param1:MeshStyle) : void
      {
         _texture = param1._texture;
         _textureBase = param1._textureBase;
         _textureRepeat = param1._textureRepeat;
         _textureSmoothing = param1._textureSmoothing;
      }
      
      public function clone() : MeshStyle
      {
         var _loc1_:MeshStyle = new _type();
         _loc1_.copyFrom(this);
         return _loc1_;
      }
      
      public function createEffect() : MeshEffect
      {
         return new MeshEffect();
      }
      
      public function updateEffect(param1:MeshEffect, param2:RenderState) : void
      {
         param1.texture = _texture;
         param1.textureRepeat = _textureRepeat;
         param1.textureSmoothing = _textureSmoothing;
         param1.mvpMatrix3D = param2.mvpMatrix3D;
         param1.alpha = param2.alpha;
         param1.tinted = _vertexData.tinted;
      }
      
      public function canBatchWith(param1:MeshStyle) : Boolean
      {
         var _loc2_:Texture = null;
         if(_type == param1._type)
         {
            _loc2_ = param1._texture;
            if(_texture == null && _loc2_ == null)
            {
               return true;
            }
            if(_texture && _loc2_)
            {
               return _textureBase == param1._textureBase && _textureSmoothing == param1._textureSmoothing && _textureRepeat == param1._textureRepeat;
            }
            return false;
         }
         return false;
      }
      
      public function batchVertexData(param1:MeshStyle, param2:int = 0, param3:Matrix = null, param4:int = 0, param5:int = -1) : void
      {
         _vertexData.copyTo(param1._vertexData,param2,param3,param4,param5);
      }
      
      public function batchIndexData(param1:MeshStyle, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = -1) : void
      {
         _indexData.copyTo(param1._indexData,param2,param3,param4,param5);
      }
      
      protected function setRequiresRedraw() : void
      {
         if(_target)
         {
            _target.setRequiresRedraw();
         }
      }
      
      protected function setVertexDataChanged() : void
      {
         if(_target)
         {
            _target.setVertexDataChanged();
         }
      }
      
      protected function setIndexDataChanged() : void
      {
         if(_target)
         {
            _target.setIndexDataChanged();
         }
      }
      
      protected function onTargetAssigned(param1:Mesh) : void
      {
      }
      
      override public function addEventListener(param1:String, param2:Function) : void
      {
         if(param1 == "enterFrame" && _target)
         {
            _target.addEventListener("enterFrame",onEnterFrame);
         }
         super.addEventListener(param1,param2);
      }
      
      override public function removeEventListener(param1:String, param2:Function) : void
      {
         if(param1 == "enterFrame" && _target)
         {
            _target.removeEventListener(param1,onEnterFrame);
         }
         super.removeEventListener(param1,param2);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      starling_internal function setTarget(param1:Mesh = null, param2:VertexData = null, param3:IndexData = null) : void
      {
         if(_target != param1)
         {
            if(_target)
            {
               _target.removeEventListener("enterFrame",onEnterFrame);
            }
            if(param2)
            {
               param2.format = vertexFormat;
            }
            _target = param1;
            _vertexData = param2;
            _indexData = param3;
            if(param1)
            {
               if(hasEventListener("enterFrame"))
               {
                  param1.addEventListener("enterFrame",onEnterFrame);
               }
               onTargetAssigned(param1);
            }
         }
      }
      
      public function getVertexPosition(param1:int, param2:Point = null) : Point
      {
         return _vertexData.getPoint(param1,"position",param2);
      }
      
      public function setVertexPosition(param1:int, param2:Number, param3:Number) : void
      {
         _vertexData.setPoint(param1,"position",param2,param3);
         setVertexDataChanged();
      }
      
      public function getVertexAlpha(param1:int) : Number
      {
         return _vertexData.getAlpha(param1);
      }
      
      public function setVertexAlpha(param1:int, param2:Number) : void
      {
         _vertexData.setAlpha(param1,"color",param2);
         setVertexDataChanged();
      }
      
      public function getVertexColor(param1:int) : uint
      {
         return _vertexData.getColor(param1);
      }
      
      public function setVertexColor(param1:int, param2:uint) : void
      {
         _vertexData.setColor(param1,"color",param2);
         setVertexDataChanged();
      }
      
      public function getTexCoords(param1:int, param2:Point = null) : Point
      {
         if(_texture)
         {
            return _texture.getTexCoords(_vertexData,param1,"texCoords",param2);
         }
         return _vertexData.getPoint(param1,"texCoords",param2);
      }
      
      public function setTexCoords(param1:int, param2:Number, param3:Number) : void
      {
         if(_texture)
         {
            _texture.setTexCoords(_vertexData,param1,"texCoords",param2,param3);
         }
         else
         {
            _vertexData.setPoint(param1,"texCoords",param2,param3);
         }
         setVertexDataChanged();
      }
      
      protected function get vertexData() : VertexData
      {
         return _vertexData;
      }
      
      protected function get indexData() : IndexData
      {
         return _indexData;
      }
      
      public function get type() : Class
      {
         return _type;
      }
      
      public function get color() : uint
      {
         if(_vertexData.numVertices > 0)
         {
            return _vertexData.getColor(0);
         }
         return 0;
      }
      
      public function set color(param1:uint) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = _vertexData.numVertices;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _vertexData.setColor(_loc3_,"color",param1);
            _loc3_++;
         }
         if(param1 == 16777215 && _vertexData.tinted)
         {
            _vertexData.updateTinted();
         }
         setVertexDataChanged();
      }
      
      public function get vertexFormat() : VertexDataFormat
      {
         return VERTEX_FORMAT;
      }
      
      public function get texture() : Texture
      {
         return _texture;
      }
      
      public function set texture(param1:Texture) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         if(param1 != _texture)
         {
            if(param1)
            {
               _loc2_ = int(!!_vertexData ? _vertexData.numVertices : 0);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  getTexCoords(_loc3_,sPoint);
                  param1.setTexCoords(_vertexData,_loc3_,"texCoords",sPoint.x,sPoint.y);
                  _loc3_++;
               }
               setVertexDataChanged();
            }
            else
            {
               setRequiresRedraw();
            }
            _texture = param1;
            _textureBase = !!param1 ? param1.base : null;
         }
      }
      
      public function get textureSmoothing() : String
      {
         return _textureSmoothing;
      }
      
      public function set textureSmoothing(param1:String) : void
      {
         if(param1 != _textureSmoothing)
         {
            _textureSmoothing = param1;
            setRequiresRedraw();
         }
      }
      
      public function get textureRepeat() : Boolean
      {
         return _textureRepeat;
      }
      
      public function set textureRepeat(param1:Boolean) : void
      {
         _textureRepeat = param1;
      }
      
      public function get target() : Mesh
      {
         return _target;
      }
   }
}
