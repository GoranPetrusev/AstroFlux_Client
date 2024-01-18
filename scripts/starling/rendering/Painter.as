package starling.rendering
{
   import flash.display.Stage3D;
   import flash.display3D.Context3D;
   import flash.display3D.textures.TextureBase;
   import flash.errors.IllegalOperationError;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import starling.core.starling_internal;
   import starling.display.BlendMode;
   import starling.display.DisplayObject;
   import starling.display.Mesh;
   import starling.display.MeshBatch;
   import starling.display.Quad;
   import starling.textures.Texture;
   import starling.utils.MathUtil;
   import starling.utils.MatrixUtil;
   import starling.utils.MeshSubset;
   import starling.utils.Pool;
   import starling.utils.RectangleUtil;
   import starling.utils.RenderUtil;
   import starling.utils.SystemUtil;
   
   use namespace starling_internal;
   
   public class Painter
   {
      
      private static const PROGRAM_DATA_NAME:String = "starling.rendering.Painter.Programs";
      
      private static var sSharedData:Dictionary = new Dictionary();
      
      private static var sMatrix:Matrix = new Matrix();
      
      private static var sPoint3D:Vector3D = new Vector3D();
      
      private static var sMatrix3D:Matrix3D = new Matrix3D();
      
      private static var sClipRect:Rectangle = new Rectangle();
      
      private static var sBufferRect:Rectangle = new Rectangle();
      
      private static var sScissorRect:Rectangle = new Rectangle();
      
      private static var sMeshSubset:MeshSubset = new MeshSubset();
       
      
      private var _stage3D:Stage3D;
      
      private var _context:Context3D;
      
      private var _shareContext:Boolean;
      
      private var _drawCount:int;
      
      private var _frameID:uint;
      
      private var _pixelSize:Number;
      
      private var _enableErrorChecking:Boolean;
      
      private var _stencilReferenceValues:Dictionary;
      
      private var _clipRectStack:Vector.<Rectangle>;
      
      private var _batchCacheExclusions:Vector.<DisplayObject>;
      
      private var _batchProcessor:BatchProcessor;
      
      private var _batchProcessorCurr:BatchProcessor;
      
      private var _batchProcessorPrev:BatchProcessor;
      
      private var _batchProcessorSpec:BatchProcessor;
      
      private var _actualRenderTarget:TextureBase;
      
      private var _actualRenderTargetOptions:uint;
      
      private var _actualCulling:String;
      
      private var _actualBlendMode:String;
      
      private var _backBufferWidth:Number;
      
      private var _backBufferHeight:Number;
      
      private var _backBufferScaleFactor:Number;
      
      private var _state:RenderState;
      
      private var _stateStack:Vector.<RenderState>;
      
      private var _stateStackPos:int;
      
      private var _stateStackLength:int;
      
      public function Painter(param1:Stage3D)
      {
         super();
         _stage3D = param1;
         _stage3D.addEventListener("context3DCreate",onContextCreated,false,40,true);
         _context = _stage3D.context3D;
         _shareContext = _context && _context.driverInfo != "Disposed";
         _backBufferWidth = !!_context ? _context.backBufferWidth : 0;
         _backBufferHeight = !!_context ? _context.backBufferHeight : 0;
         _backBufferScaleFactor = _pixelSize = 1;
         _stencilReferenceValues = new Dictionary(true);
         _clipRectStack = new Vector.<Rectangle>(0);
         _batchProcessorCurr = new BatchProcessor();
         _batchProcessorCurr.onBatchComplete = drawBatch;
         _batchProcessorPrev = new BatchProcessor();
         _batchProcessorPrev.onBatchComplete = drawBatch;
         _batchProcessorSpec = new BatchProcessor();
         _batchProcessorSpec.onBatchComplete = drawBatch;
         _batchProcessor = _batchProcessorCurr;
         _batchCacheExclusions = new Vector.<DisplayObject>();
         _state = new RenderState();
         _state.onDrawRequired = finishMeshBatch;
         _stateStack = new Vector.<RenderState>(0);
         _stateStackPos = -1;
         _stateStackLength = 0;
      }
      
      public function dispose() : void
      {
         _batchProcessorCurr.dispose();
         _batchProcessorPrev.dispose();
         _batchProcessorSpec.dispose();
         if(!_shareContext)
         {
            _context.dispose(false);
            sSharedData = new Dictionary();
         }
      }
      
      public function requestContext3D(param1:String, param2:*) : void
      {
         RenderUtil.requestContext3D(_stage3D,param1,param2);
      }
      
      private function onContextCreated(param1:Object) : void
      {
         _context = _stage3D.context3D;
         _context.enableErrorChecking = _enableErrorChecking;
         _context.setDepthTest(false,"always");
         _actualBlendMode = null;
         _actualCulling = null;
      }
      
      public function configureBackBuffer(param1:Rectangle, param2:Number, param3:int, param4:Boolean) : void
      {
         if(!_shareContext)
         {
            if(param4)
            {
               param4 = SystemUtil.supportsDepthAndStencil;
            }
            if(_context.profile == "baselineConstrained")
            {
               _context.configureBackBuffer(32,32,param3,param4);
            }
            if(param1.width * param2 > _context.maxBackBufferWidth || param1.height * param2 > _context.maxBackBufferHeight)
            {
               param2 = 1;
            }
            _stage3D.x = param1.x;
            _stage3D.y = param1.y;
            _context.configureBackBuffer(param1.width,param1.height,param3,param4,param2 != 1);
         }
         _backBufferWidth = param1.width;
         _backBufferHeight = param1.height;
         _backBufferScaleFactor = param2;
      }
      
      public function registerProgram(param1:String, param2:Program) : void
      {
         deleteProgram(param1);
         programs[param1] = param2;
      }
      
      public function deleteProgram(param1:String) : void
      {
         var _loc2_:Program = getProgram(param1);
         if(_loc2_)
         {
            _loc2_.dispose();
            delete programs[param1];
         }
      }
      
      public function getProgram(param1:String) : Program
      {
         return programs[param1] as Program;
      }
      
      public function hasProgram(param1:String) : Boolean
      {
         return param1 in programs;
      }
      
      public function pushState(param1:BatchToken = null) : void
      {
         _stateStackPos++;
         if(_stateStackLength < _stateStackPos + 1)
         {
            _stateStack[_stateStackLength++] = new RenderState();
         }
         if(param1)
         {
            _batchProcessor.fillToken(param1);
         }
         _stateStack[_stateStackPos].copyFrom(_state);
      }
      
      public function setStateTo(param1:Matrix, param2:Number = 1, param3:String = "auto") : void
      {
         if(param1)
         {
            MatrixUtil.prependMatrix(_state._modelviewMatrix,param1);
         }
         if(param2 != 1)
         {
            _state._alpha *= param2;
         }
         if(param3 != "auto")
         {
            _state.blendMode = param3;
         }
      }
      
      public function popState(param1:BatchToken = null) : void
      {
         if(_stateStackPos < 0)
         {
            throw new IllegalOperationError("Cannot pop empty state stack");
         }
         _state.copyFrom(_stateStack[_stateStackPos]);
         _stateStackPos--;
         if(param1)
         {
            _batchProcessor.fillToken(param1);
         }
      }
      
      public function drawMask(param1:DisplayObject, param2:DisplayObject = null) : void
      {
         if(_context == null)
         {
            return;
         }
         finishMeshBatch();
         if(isRectangularMask(param1,param2,sMatrix))
         {
            param1.getBounds(param1,sClipRect);
            RectangleUtil.getBounds(sClipRect,sMatrix,sClipRect);
            pushClipRect(sClipRect);
         }
         else
         {
            _context.setStencilActions("frontAndBack","equal","incrementSaturate");
            renderMask(param1);
            stencilReferenceValue++;
            _context.setStencilActions("frontAndBack","equal","keep");
         }
         excludeFromCache(param2);
      }
      
      public function eraseMask(param1:DisplayObject, param2:DisplayObject = null) : void
      {
         if(_context == null)
         {
            return;
         }
         finishMeshBatch();
         if(isRectangularMask(param1,param2,sMatrix))
         {
            popClipRect();
         }
         else
         {
            _context.setStencilActions("frontAndBack","equal","decrementSaturate");
            renderMask(param1);
            stencilReferenceValue--;
            _context.setStencilActions("frontAndBack","equal","keep");
         }
      }
      
      private function renderMask(param1:DisplayObject) : void
      {
         var _loc2_:Boolean = cacheEnabled;
         pushState();
         cacheEnabled = false;
         _state.alpha = 0;
         var _loc4_:Matrix = null;
         var _loc3_:Matrix3D = null;
         if(param1.stage)
         {
            _state.setModelviewMatricesToIdentity();
            if(param1.is3D)
            {
               _loc3_ = param1.getTransformationMatrix3D(null,sMatrix3D);
            }
            else
            {
               _loc4_ = param1.getTransformationMatrix(null,sMatrix);
            }
         }
         else if(param1.is3D)
         {
            _loc3_ = param1.transformationMatrix3D;
         }
         else
         {
            _loc4_ = param1.transformationMatrix;
         }
         if(_loc3_)
         {
            _state.transformModelviewMatrix3D(_loc3_);
         }
         else
         {
            _state.transformModelviewMatrix(_loc4_);
         }
         param1.render(this);
         finishMeshBatch();
         cacheEnabled = _loc2_;
         popState();
      }
      
      private function pushClipRect(param1:Rectangle) : void
      {
         var _loc2_:Vector.<Rectangle> = _clipRectStack;
         var _loc4_:uint = _loc2_.length;
         var _loc3_:Rectangle = Pool.getRectangle();
         if(_loc4_)
         {
            RectangleUtil.intersect(_loc2_[_loc4_ - 1],param1,_loc3_);
         }
         else
         {
            _loc3_.copyFrom(param1);
         }
         _loc2_[_loc4_] = _loc3_;
         _state.clipRect = _loc3_;
      }
      
      private function popClipRect() : void
      {
         var _loc1_:Vector.<Rectangle> = _clipRectStack;
         var _loc2_:uint = _loc1_.length;
         if(_loc2_ == 0)
         {
            throw new Error("Trying to pop from empty clip rectangle stack");
         }
         _loc2_--;
         Pool.putRectangle(_loc1_.pop());
         _state.clipRect = !!_loc2_ ? _loc1_[_loc2_ - 1] : null;
      }
      
      private function isRectangularMask(param1:DisplayObject, param2:DisplayObject, param3:Matrix) : Boolean
      {
         var _loc4_:Quad = param1 as Quad;
         var _loc5_:Boolean = param1.is3D || param2 && param2.is3D && param1.stage == null;
         if(_loc4_ && !_loc5_ && _loc4_.texture == null)
         {
            if(param1.stage)
            {
               param1.getTransformationMatrix(null,param3);
            }
            else
            {
               param3.copyFrom(param1.transformationMatrix);
               param3.concat(_state.modelviewMatrix);
            }
            return MathUtil.isEquivalent(param3.a,0) && MathUtil.isEquivalent(param3.d,0) || MathUtil.isEquivalent(param3.b,0) && MathUtil.isEquivalent(param3.c,0);
         }
         return false;
      }
      
      public function batchMesh(param1:Mesh, param2:MeshSubset = null) : void
      {
         _batchProcessor.addMesh(param1,_state,param2);
      }
      
      public function finishMeshBatch() : void
      {
         _batchProcessor.finishBatch();
      }
      
      public function finishFrame() : void
      {
         if(_frameID % 99 == 0)
         {
            _batchProcessorCurr.trim();
         }
         if(_frameID % 150 == 0)
         {
            _batchProcessorSpec.trim();
         }
         _batchProcessor.finishBatch();
         _batchProcessor = _batchProcessorSpec;
         processCacheExclusions();
      }
      
      private function processCacheExclusions() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(_batchCacheExclusions.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _batchCacheExclusions[_loc2_].starling_internal::excludeFromCache();
            _loc2_++;
         }
         _batchCacheExclusions.length = 0;
      }
      
      public function nextFrame() : void
      {
         _batchProcessor = swapBatchProcessors();
         _batchProcessor.clear();
         _batchProcessorSpec.clear();
         _actualBlendMode = null;
         _actualCulling = null;
         _context.setDepthTest(false,"always");
         stencilReferenceValue = 0;
         _clipRectStack.length = 0;
         _drawCount = 0;
         _stateStackPos = -1;
         _state.reset();
      }
      
      private function swapBatchProcessors() : BatchProcessor
      {
         var _loc1_:BatchProcessor = _batchProcessorPrev;
         _batchProcessorPrev = _batchProcessorCurr;
         return _batchProcessorCurr = _loc1_;
      }
      
      public function drawFromCache(param1:BatchToken, param2:BatchToken) : void
      {
         var _loc3_:MeshBatch = null;
         var _loc4_:int = 0;
         var _loc5_:MeshSubset = sMeshSubset;
         if(!param1.equals(param2))
         {
            pushState();
            _loc4_ = param1.batchID;
            while(_loc4_ <= param2.batchID)
            {
               _loc3_ = _batchProcessorPrev.getBatchAt(_loc4_);
               _loc5_.setTo();
               if(_loc4_ == param1.batchID)
               {
                  _loc5_.vertexID = param1.vertexID;
                  _loc5_.indexID = param1.indexID;
                  _loc5_.numVertices = _loc3_.numVertices - _loc5_.vertexID;
                  _loc5_.numIndices = _loc3_.numIndices - _loc5_.indexID;
               }
               if(_loc4_ == param2.batchID)
               {
                  _loc5_.numVertices = param2.vertexID - _loc5_.vertexID;
                  _loc5_.numIndices = param2.indexID - _loc5_.indexID;
               }
               if(_loc5_.numVertices)
               {
                  _state.alpha = 1;
                  _state.blendMode = _loc3_.blendMode;
                  _batchProcessor.addMesh(_loc3_,_state,_loc5_,true);
               }
               _loc4_++;
            }
            popState();
         }
      }
      
      public function excludeFromCache(param1:DisplayObject) : void
      {
         if(param1)
         {
            _batchCacheExclusions[_batchCacheExclusions.length] = param1;
         }
      }
      
      private function drawBatch(param1:MeshBatch) : void
      {
         pushState();
         state.blendMode = param1.blendMode;
         state.modelviewMatrix.identity();
         state.alpha = 1;
         param1.render(this);
         popState();
      }
      
      public function prepareToDraw() : void
      {
         applyBlendMode();
         applyRenderTarget();
         applyClipRect();
         applyCulling();
      }
      
      public function clear(param1:uint = 0, param2:Number = 0) : void
      {
         applyRenderTarget();
         stencilReferenceValue = 0;
         RenderUtil.clear(param1,param2);
      }
      
      public function present() : void
      {
         _state.renderTarget = null;
         _actualRenderTarget = null;
         _context.present();
      }
      
      private function applyBlendMode() : void
      {
         var _loc1_:String = _state.blendMode;
         if(_loc1_ != _actualBlendMode)
         {
            BlendMode.get(_state.blendMode).activate();
            _actualBlendMode = _loc1_;
         }
      }
      
      private function applyCulling() : void
      {
         var _loc1_:String = _state.culling;
         if(_loc1_ != _actualCulling)
         {
            _context.setCulling(_loc1_);
            _actualCulling = _loc1_;
         }
      }
      
      private function applyRenderTarget() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Boolean = false;
         var _loc4_:TextureBase = _state.renderTargetBase;
         var _loc2_:uint = _state.renderTargetOptions;
         if(_loc4_ != _actualRenderTarget || _loc2_ != _actualRenderTargetOptions)
         {
            if(_loc4_)
            {
               _loc3_ = _state.renderTargetAntiAlias;
               _loc1_ = _state.renderTargetSupportsDepthAndStencil;
               _context.setRenderToTexture(_loc4_,_loc1_,_loc3_);
            }
            else
            {
               _context.setRenderToBackBuffer();
            }
            _context.setStencilReferenceValue(stencilReferenceValue);
            _actualRenderTargetOptions = _loc2_;
            _actualRenderTarget = _loc4_;
         }
      }
      
      private function applyClipRect() : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Matrix3D = null;
         var _loc2_:Texture = null;
         var _loc1_:Rectangle = _state.clipRect;
         if(_loc1_)
         {
            _loc4_ = _state.projectionMatrix3D;
            _loc2_ = _state.renderTarget;
            if(_loc2_)
            {
               _loc3_ = _loc2_.root.nativeWidth;
               _loc5_ = _loc2_.root.nativeHeight;
            }
            else
            {
               _loc3_ = _backBufferWidth;
               _loc5_ = _backBufferHeight;
            }
            MatrixUtil.transformCoords3D(_loc4_,_loc1_.x,_loc1_.y,0,sPoint3D);
            sPoint3D.project();
            sClipRect.x = (sPoint3D.x * 0.5 + 0.5) * _loc3_;
            sClipRect.y = (0.5 - sPoint3D.y * 0.5) * _loc5_;
            MatrixUtil.transformCoords3D(_loc4_,_loc1_.right,_loc1_.bottom,0,sPoint3D);
            sPoint3D.project();
            sClipRect.right = (sPoint3D.x * 0.5 + 0.5) * _loc3_;
            sClipRect.bottom = (0.5 - sPoint3D.y * 0.5) * _loc5_;
            sBufferRect.setTo(0,0,_loc3_,_loc5_);
            RectangleUtil.intersect(sClipRect,sBufferRect,sScissorRect);
            if(sScissorRect.width < 1 || sScissorRect.height < 1)
            {
               sScissorRect.setTo(0,0,1,1);
            }
            _context.setScissorRectangle(sScissorRect);
         }
         else
         {
            _context.setScissorRectangle(null);
         }
      }
      
      public function get drawCount() : int
      {
         return _drawCount;
      }
      
      public function set drawCount(param1:int) : void
      {
         _drawCount = param1;
      }
      
      public function get stencilReferenceValue() : uint
      {
         var _loc1_:Object = !!_state.renderTarget ? _state.renderTargetBase : this;
         if(_loc1_ in _stencilReferenceValues)
         {
            return _stencilReferenceValues[_loc1_];
         }
         return 0;
      }
      
      public function set stencilReferenceValue(param1:uint) : void
      {
         var _loc2_:Object = !!_state.renderTarget ? _state.renderTargetBase : this;
         _stencilReferenceValues[_loc2_] = param1;
         if(contextValid)
         {
            _context.setStencilReferenceValue(param1);
         }
      }
      
      public function get cacheEnabled() : Boolean
      {
         return _batchProcessor == _batchProcessorCurr;
      }
      
      public function set cacheEnabled(param1:Boolean) : void
      {
         if(param1 != cacheEnabled)
         {
            finishMeshBatch();
            if(param1)
            {
               _batchProcessor = _batchProcessorCurr;
            }
            else
            {
               _batchProcessor = _batchProcessorSpec;
            }
         }
      }
      
      public function get state() : RenderState
      {
         return _state;
      }
      
      public function get stage3D() : Stage3D
      {
         return _stage3D;
      }
      
      public function get context() : Context3D
      {
         return _context;
      }
      
      public function set frameID(param1:uint) : void
      {
         _frameID = param1;
      }
      
      public function get frameID() : uint
      {
         return _batchProcessor == _batchProcessorCurr ? _frameID : 0;
      }
      
      public function get pixelSize() : Number
      {
         return _pixelSize;
      }
      
      public function set pixelSize(param1:Number) : void
      {
         _pixelSize = param1;
      }
      
      public function get shareContext() : Boolean
      {
         return _shareContext;
      }
      
      public function set shareContext(param1:Boolean) : void
      {
         _shareContext = param1;
      }
      
      public function get enableErrorChecking() : Boolean
      {
         return _enableErrorChecking;
      }
      
      public function set enableErrorChecking(param1:Boolean) : void
      {
         _enableErrorChecking = param1;
         if(_context)
         {
            _context.enableErrorChecking = param1;
         }
      }
      
      public function get backBufferWidth() : int
      {
         return _backBufferWidth;
      }
      
      public function get backBufferHeight() : int
      {
         return _backBufferHeight;
      }
      
      public function get backBufferScaleFactor() : Number
      {
         return _backBufferScaleFactor;
      }
      
      public function get contextValid() : Boolean
      {
         var _loc1_:String = null;
         if(_context)
         {
            _loc1_ = _context.driverInfo;
            return _loc1_ != null && _loc1_ != "" && _loc1_ != "Disposed";
         }
         return false;
      }
      
      public function get profile() : String
      {
         if(_context)
         {
            return _context.profile;
         }
         return null;
      }
      
      public function get sharedData() : Dictionary
      {
         var _loc1_:Dictionary = sSharedData[stage3D] as Dictionary;
         if(_loc1_ == null)
         {
            _loc1_ = new Dictionary();
            sSharedData[stage3D] = _loc1_;
         }
         return _loc1_;
      }
      
      private function get programs() : Dictionary
      {
         var _loc1_:Dictionary = sharedData["starling.rendering.Painter.Programs"] as Dictionary;
         if(_loc1_ == null)
         {
            _loc1_ = new Dictionary();
            sharedData["starling.rendering.Painter.Programs"] = _loc1_;
         }
         return _loc1_;
      }
   }
}
