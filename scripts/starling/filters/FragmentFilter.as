package starling.filters
{
   import flash.errors.IllegalOperationError;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.core.starling_internal;
   import starling.display.DisplayObject;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.rendering.FilterEffect;
   import starling.rendering.IndexData;
   import starling.rendering.Painter;
   import starling.rendering.VertexData;
   import starling.textures.Texture;
   import starling.utils.MatrixUtil;
   import starling.utils.Padding;
   import starling.utils.Pool;
   import starling.utils.RectangleUtil;
   
   use namespace starling_internal;
   
   public class FragmentFilter extends EventDispatcher
   {
      
      private static var sMatrix3D:Matrix3D;
       
      
      private var _quad:FilterQuad;
      
      private var _target:DisplayObject;
      
      private var _effect:FilterEffect;
      
      private var _vertexData:VertexData;
      
      private var _indexData:IndexData;
      
      private var _padding:Padding;
      
      private var _helper:FilterHelper;
      
      private var _resolution:Number;
      
      private var _antiAliasing:int;
      
      private var _textureFormat:String;
      
      private var _textureSmoothing:String;
      
      private var _alwaysDrawToBackBuffer:Boolean;
      
      private var _cacheRequested:Boolean;
      
      private var _cached:Boolean;
      
      public function FragmentFilter()
      {
         super();
         _resolution = 1;
         _textureFormat = "bgra";
         _textureSmoothing = "bilinear";
         Starling.current.stage3D.addEventListener("context3DCreate",onContextCreated,false,0,true);
      }
      
      public function dispose() : void
      {
         Starling.current.stage3D.removeEventListener("context3DCreate",onContextCreated);
         if(_helper)
         {
            _helper.dispose();
         }
         if(_effect)
         {
            _effect.dispose();
         }
         if(_quad)
         {
            _quad.dispose();
         }
         _effect = null;
         _quad = null;
      }
      
      private function onContextCreated(param1:Object) : void
      {
         setRequiresRedraw();
      }
      
      public function render(param1:Painter) : void
      {
         if(_target == null)
         {
            throw new IllegalOperationError("Cannot render filter without target");
         }
         if(_target.is3D)
         {
            _cached = _cacheRequested = false;
         }
         if(!_cached || _cacheRequested)
         {
            renderPasses(param1,_cacheRequested);
            _cacheRequested = false;
         }
         else if(_quad.visible)
         {
            _quad.render(param1);
         }
      }
      
      private function renderPasses(param1:Painter, param2:Boolean) : void
      {
         var _loc4_:Rectangle = null;
         var _loc3_:Texture = null;
         if(_helper == null)
         {
            _helper = new FilterHelper(_textureFormat);
         }
         if(_quad == null)
         {
            _quad = new FilterQuad(_textureSmoothing);
         }
         else
         {
            _helper.putTexture(_quad.texture);
            _quad.texture = null;
         }
         var _loc11_:Rectangle = Pool.getRectangle();
         var _loc10_:* = false;
         var _loc12_:Number = _resolution;
         var _loc6_:DisplayObject;
         var _loc7_:* = (_loc6_ = _target.stage || _target.parent) is Stage;
         var _loc8_:Stage = Starling.current.stage;
         if(!param2 && (_alwaysDrawToBackBuffer || _target.requiresRedraw))
         {
            _loc10_ = param1.state.alpha == 1;
            param1.excludeFromCache(_target);
         }
         if(_target == Starling.current.root)
         {
            _loc8_.getStageBounds(_target,_loc11_);
         }
         else
         {
            _target.getBounds(_loc6_,_loc11_);
            if(!param2 && _loc7_)
            {
               _loc4_ = _loc8_.getStageBounds(null,Pool.getRectangle());
               RectangleUtil.intersect(_loc11_,_loc4_,_loc11_);
               Pool.putRectangle(_loc4_);
            }
         }
         _quad.visible = !_loc11_.isEmpty();
         if(!_quad.visible)
         {
            Pool.putRectangle(_loc11_);
            return;
         }
         if(_padding)
         {
            RectangleUtil.extend(_loc11_,_padding.left,_padding.right,_padding.top,_padding.bottom);
         }
         _loc11_.setTo(Math.floor(_loc11_.x),Math.floor(_loc11_.y),Math.ceil(_loc11_.width),Math.ceil(_loc11_.height));
         _helper.textureScale = Starling.contentScaleFactor * _resolution;
         _helper.projectionMatrix3D = param1.state.projectionMatrix3D;
         _helper.renderTarget = param1.state.renderTarget;
         _helper.clipRect = param1.state.clipRect;
         _helper.targetBounds = _loc11_;
         _helper.target = _target;
         _helper.start(numPasses,_loc10_);
         _quad.setBounds(_loc11_);
         _resolution = 1;
         var _loc9_:Boolean = param1.cacheEnabled;
         var _loc5_:Texture = _helper.getTexture();
         param1.cacheEnabled = false;
         param1.pushState();
         param1.state.alpha = 1;
         param1.state.clipRect = null;
         param1.state.setRenderTarget(_loc5_,true,_antiAliasing);
         param1.state.setProjectionMatrix(_loc11_.x,_loc11_.y,_loc5_.root.width,_loc5_.root.height,_loc8_.stageWidth,_loc8_.stageHeight,_loc8_.cameraPosition);
         _target.render(param1);
         param1.finishMeshBatch();
         param1.state.setModelviewMatricesToIdentity();
         _loc3_ = process(param1,_helper,_loc5_);
         param1.popState();
         param1.cacheEnabled = _loc9_;
         if(_loc3_)
         {
            param1.pushState();
            if(_target.is3D)
            {
               param1.state.setModelviewMatricesToIdentity();
            }
            else
            {
               _quad.moveVertices(_loc6_,_target);
            }
            _quad.texture = _loc3_;
            _quad.render(param1);
            param1.finishMeshBatch();
            param1.popState();
         }
         _helper.target = null;
         _helper.putTexture(_loc5_);
         _resolution = _loc12_;
         Pool.putRectangle(_loc11_);
      }
      
      public function process(param1:Painter, param2:IFilterHelper, param3:Texture = null, param4:Texture = null, param5:Texture = null, param6:Texture = null) : Texture
      {
         var _loc8_:Matrix3D = null;
         var _loc10_:* = null;
         var _loc9_:FilterEffect = this.effect;
         var _loc7_:Texture = param2.getTexture(_resolution);
         var _loc11_:Rectangle = null;
         if(_loc7_)
         {
            _loc10_ = _loc7_;
            _loc8_ = MatrixUtil.createPerspectiveProjectionMatrix(0,0,_loc7_.root.width / _resolution,_loc7_.root.height / _resolution,0,0,null,sMatrix3D);
         }
         else
         {
            _loc11_ = param2.targetBounds;
            _loc10_ = (param2 as FilterHelper).renderTarget;
            _loc8_ = (param2 as FilterHelper).projectionMatrix3D;
            _loc9_.textureSmoothing = _textureSmoothing;
            param1.state.clipRect = (param2 as FilterHelper).clipRect;
            param1.state.projectionMatrix3D.copyFrom(_loc8_);
         }
         param1.state.renderTarget = _loc10_;
         param1.prepareToDraw();
         param1.drawCount += 1;
         param3.setupVertexPositions(vertexData,0,"position",_loc11_);
         param3.setupTextureCoordinates(vertexData);
         _loc9_.texture = param3;
         _loc9_.mvpMatrix3D = _loc8_;
         _loc9_.uploadVertexData(vertexData);
         _loc9_.uploadIndexData(indexData);
         _loc9_.render(0,indexData.numTriangles);
         return _loc7_;
      }
      
      protected function createEffect() : FilterEffect
      {
         return new FilterEffect();
      }
      
      public function cache() : void
      {
         _cached = _cacheRequested = true;
         setRequiresRedraw();
      }
      
      public function clearCache() : void
      {
         _cached = _cacheRequested = false;
         setRequiresRedraw();
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
      
      protected function get effect() : FilterEffect
      {
         if(_effect == null)
         {
            _effect = createEffect();
         }
         return _effect;
      }
      
      protected function get vertexData() : VertexData
      {
         if(_vertexData == null)
         {
            _vertexData = new VertexData(effect.vertexFormat,4);
         }
         return _vertexData;
      }
      
      protected function get indexData() : IndexData
      {
         if(_indexData == null)
         {
            _indexData = new IndexData(6);
            _indexData.addQuad(0,1,2,3);
         }
         return _indexData;
      }
      
      protected function setRequiresRedraw() : void
      {
         dispatchEventWith("change");
         if(_target)
         {
            _target.setRequiresRedraw();
         }
         if(_cached)
         {
            _cacheRequested = true;
         }
      }
      
      public function get numPasses() : int
      {
         return 1;
      }
      
      protected function onTargetAssigned(param1:DisplayObject) : void
      {
      }
      
      public function get padding() : Padding
      {
         if(_padding == null)
         {
            _padding = new Padding();
            _padding.addEventListener("change",starling.§filters:FragmentFilter§.setRequiresRedraw);
         }
         return _padding;
      }
      
      public function set padding(param1:Padding) : void
      {
         padding.copyFrom(param1);
      }
      
      public function get isCached() : Boolean
      {
         return _cached;
      }
      
      public function get resolution() : Number
      {
         return _resolution;
      }
      
      public function set resolution(param1:Number) : void
      {
         if(param1 != _resolution)
         {
            if(param1 <= 0)
            {
               throw new ArgumentError("resolution must be > 0");
            }
            _resolution = param1;
            setRequiresRedraw();
         }
      }
      
      public function get antiAliasing() : int
      {
         return _antiAliasing;
      }
      
      public function set antiAliasing(param1:int) : void
      {
         if(param1 != _antiAliasing)
         {
            _antiAliasing = param1;
            setRequiresRedraw();
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
            if(_quad)
            {
               _quad.textureSmoothing = param1;
            }
            setRequiresRedraw();
         }
      }
      
      public function get textureFormat() : String
      {
         return _textureFormat;
      }
      
      public function set textureFormat(param1:String) : void
      {
         if(param1 != _textureFormat)
         {
            _textureFormat = param1;
            if(_helper)
            {
               _helper.textureFormat = param1;
            }
            setRequiresRedraw();
         }
      }
      
      public function get alwaysDrawToBackBuffer() : Boolean
      {
         return _alwaysDrawToBackBuffer;
      }
      
      public function set alwaysDrawToBackBuffer(param1:Boolean) : void
      {
         _alwaysDrawToBackBuffer = param1;
      }
      
      starling_internal function setTarget(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObject = null;
         if(param1 != _target)
         {
            _loc2_ = _target;
            _target = param1;
            if(param1 == null)
            {
               if(_helper)
               {
                  _helper.purge();
               }
               if(_effect)
               {
                  _effect.purgeBuffers();
               }
               if(_quad)
               {
                  _quad.disposeTexture();
               }
            }
            if(_loc2_)
            {
               _loc2_.filter = null;
               _loc2_.removeEventListener("enterFrame",onEnterFrame);
            }
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
   }
}

import flash.geom.Matrix;
import flash.geom.Rectangle;
import starling.display.DisplayObject;
import starling.display.Mesh;
import starling.rendering.IndexData;
import starling.rendering.VertexData;
import starling.textures.Texture;

class FilterQuad extends Mesh
{
   
   private static var sMatrix:Matrix = new Matrix();
    
   
   public function FilterQuad(param1:String)
   {
      var _loc2_:VertexData = new VertexData(null,4);
      _loc2_.numVertices = 4;
      var _loc3_:IndexData = new IndexData(6);
      _loc3_.addQuad(0,1,2,3);
      super(_loc2_,_loc3_);
      textureSmoothing = param1;
      pixelSnapping = false;
   }
   
   override public function dispose() : void
   {
      disposeTexture();
      super.dispose();
   }
   
   public function disposeTexture() : void
   {
      if(texture)
      {
         texture.dispose();
         texture = null;
      }
   }
   
   public function moveVertices(param1:DisplayObject, param2:DisplayObject) : void
   {
      if(param2.is3D)
      {
         throw new Error("cannot move vertices into 3D space");
      }
      if(param1 != param2)
      {
         param2.getTransformationMatrix(param1,sMatrix).invert();
         vertexData.transformPoints("position",sMatrix);
      }
   }
   
   public function setBounds(param1:Rectangle) : void
   {
      var _loc2_:VertexData = this.vertexData;
      var _loc3_:String = "position";
      _loc2_.setPoint(0,_loc3_,param1.x,param1.y);
      _loc2_.setPoint(1,_loc3_,param1.right,param1.y);
      _loc2_.setPoint(2,_loc3_,param1.x,param1.bottom);
      _loc2_.setPoint(3,_loc3_,param1.right,param1.bottom);
   }
   
   override public function set texture(param1:Texture) : void
   {
      super.texture = param1;
      if(param1)
      {
         param1.setupTextureCoordinates(vertexData);
      }
   }
}
