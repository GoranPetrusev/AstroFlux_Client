package starling.rendering
{
   import flash.display3D.textures.TextureBase;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import starling.textures.Texture;
   import starling.utils.MathUtil;
   import starling.utils.MatrixUtil;
   import starling.utils.Pool;
   import starling.utils.RectangleUtil;
   
   public class RenderState
   {
      
      private static const CULLING_VALUES:Vector.<String> = new <String>["none","front","back","frontAndBack"];
      
      private static var sMatrix3D:Matrix3D = new Matrix3D();
      
      private static var sProjectionMatrix3DRev:uint = 0;
       
      
      internal var _alpha:Number;
      
      internal var _blendMode:String;
      
      internal var _modelviewMatrix:Matrix;
      
      private var _miscOptions:uint;
      
      private var _clipRect:Rectangle;
      
      private var _renderTarget:Texture;
      
      private var _onDrawRequired:Function;
      
      private var _modelviewMatrix3D:Matrix3D;
      
      private var _projectionMatrix3D:Matrix3D;
      
      private var _projectionMatrix3DRev:uint;
      
      private var _mvpMatrix3D:Matrix3D;
      
      public function RenderState()
      {
         super();
         reset();
      }
      
      public function copyFrom(param1:RenderState) : void
      {
         var _loc3_:TextureBase = null;
         var _loc4_:TextureBase = null;
         var _loc5_:* = false;
         var _loc2_:Boolean = false;
         if(_onDrawRequired != null)
         {
            _loc3_ = !!_renderTarget ? _renderTarget.base : null;
            _loc4_ = !!param1._renderTarget ? param1._renderTarget.base : null;
            _loc5_ = (_miscOptions & 3840) != (param1._miscOptions & 3840);
            _loc2_ = _clipRect || param1._clipRect ? !RectangleUtil.compare(_clipRect,param1._clipRect) : false;
            if(_blendMode != param1._blendMode || _loc3_ != _loc4_ || _loc2_ || _loc5_)
            {
               _onDrawRequired();
            }
         }
         _alpha = param1._alpha;
         _blendMode = param1._blendMode;
         _renderTarget = param1._renderTarget;
         _miscOptions = param1._miscOptions;
         _modelviewMatrix.copyFrom(param1._modelviewMatrix);
         if(_projectionMatrix3DRev != param1._projectionMatrix3DRev)
         {
            _projectionMatrix3DRev = param1._projectionMatrix3DRev;
            _projectionMatrix3D.copyFrom(param1._projectionMatrix3D);
         }
         if(_modelviewMatrix3D || param1._modelviewMatrix3D)
         {
            this.modelviewMatrix3D = param1._modelviewMatrix3D;
         }
         if(_clipRect || param1._clipRect)
         {
            this.clipRect = param1._clipRect;
         }
      }
      
      public function reset() : void
      {
         this.alpha = 1;
         this.blendMode = "normal";
         this.culling = "none";
         this.modelviewMatrix3D = null;
         this.renderTarget = null;
         this.clipRect = null;
         _projectionMatrix3DRev = 0;
         if(_modelviewMatrix)
         {
            _modelviewMatrix.identity();
         }
         else
         {
            _modelviewMatrix = new Matrix();
         }
         if(_projectionMatrix3D)
         {
            _projectionMatrix3D.identity();
         }
         else
         {
            _projectionMatrix3D = new Matrix3D();
         }
         if(_mvpMatrix3D == null)
         {
            _mvpMatrix3D = new Matrix3D();
         }
      }
      
      public function transformModelviewMatrix(param1:Matrix) : void
      {
         MatrixUtil.prependMatrix(_modelviewMatrix,param1);
      }
      
      public function transformModelviewMatrix3D(param1:Matrix3D) : void
      {
         if(_modelviewMatrix3D == null)
         {
            _modelviewMatrix3D = Pool.getMatrix3D();
         }
         _modelviewMatrix3D.prepend(MatrixUtil.convertTo3D(_modelviewMatrix,sMatrix3D));
         _modelviewMatrix3D.prepend(param1);
         _modelviewMatrix.identity();
      }
      
      public function setProjectionMatrix(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 0, param6:Number = 0, param7:Vector3D = null) : void
      {
         _projectionMatrix3DRev = ++sProjectionMatrix3DRev;
         MatrixUtil.createPerspectiveProjectionMatrix(param1,param2,param3,param4,param5,param6,param7,_projectionMatrix3D);
      }
      
      public function setProjectionMatrixChanged() : void
      {
         _projectionMatrix3DRev = ++sProjectionMatrix3DRev;
      }
      
      public function setModelviewMatricesToIdentity() : void
      {
         _modelviewMatrix.identity();
         if(_modelviewMatrix3D)
         {
            _modelviewMatrix3D.identity();
         }
      }
      
      public function get modelviewMatrix() : Matrix
      {
         return _modelviewMatrix;
      }
      
      public function set modelviewMatrix(param1:Matrix) : void
      {
         _modelviewMatrix.copyFrom(param1);
      }
      
      public function get modelviewMatrix3D() : Matrix3D
      {
         return _modelviewMatrix3D;
      }
      
      public function set modelviewMatrix3D(param1:Matrix3D) : void
      {
         if(param1)
         {
            if(_modelviewMatrix3D == null)
            {
               _modelviewMatrix3D = Pool.getMatrix3D(false);
            }
            _modelviewMatrix3D.copyFrom(param1);
         }
         else if(_modelviewMatrix3D)
         {
            Pool.putMatrix3D(_modelviewMatrix3D);
            _modelviewMatrix3D = null;
         }
      }
      
      public function get projectionMatrix3D() : Matrix3D
      {
         return _projectionMatrix3D;
      }
      
      public function set projectionMatrix3D(param1:Matrix3D) : void
      {
         setProjectionMatrixChanged();
         _projectionMatrix3D.copyFrom(param1);
      }
      
      public function get mvpMatrix3D() : Matrix3D
      {
         _mvpMatrix3D.copyFrom(_projectionMatrix3D);
         if(_modelviewMatrix3D)
         {
            _mvpMatrix3D.prepend(_modelviewMatrix3D);
         }
         _mvpMatrix3D.prepend(MatrixUtil.convertTo3D(_modelviewMatrix,sMatrix3D));
         return _mvpMatrix3D;
      }
      
      public function setRenderTarget(param1:Texture, param2:Boolean = true, param3:int = 0) : void
      {
         var _loc5_:TextureBase = !!_renderTarget ? _renderTarget.base : null;
         var _loc6_:TextureBase = !!param1 ? param1.base : null;
         var _loc7_:uint;
         var _loc4_:* = (_loc7_ = uint(MathUtil.min(param3,15) | uint(param2) << 4)) != (_miscOptions & 255);
         if(_loc5_ != _loc6_ || _loc4_)
         {
            if(_onDrawRequired != null)
            {
               _onDrawRequired();
            }
            _renderTarget = param1;
            _miscOptions = _miscOptions & 4294967040 | _loc7_;
         }
      }
      
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         _alpha = param1;
      }
      
      public function get blendMode() : String
      {
         return _blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         if(param1 != "auto" && _blendMode != param1)
         {
            if(_onDrawRequired != null)
            {
               _onDrawRequired();
            }
            _blendMode = param1;
         }
      }
      
      public function get renderTarget() : Texture
      {
         return _renderTarget;
      }
      
      public function set renderTarget(param1:Texture) : void
      {
         setRenderTarget(param1);
      }
      
      internal function get renderTargetBase() : TextureBase
      {
         return !!_renderTarget ? _renderTarget.base : null;
      }
      
      internal function get renderTargetOptions() : uint
      {
         return _miscOptions & 255;
      }
      
      public function get culling() : String
      {
         var _loc1_:* = (_miscOptions & 3840) >> 8;
         return CULLING_VALUES[_loc1_];
      }
      
      public function set culling(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.culling != param1)
         {
            if(_onDrawRequired != null)
            {
               _onDrawRequired();
            }
            _loc2_ = CULLING_VALUES.indexOf(param1);
            if(_loc2_ == -1)
            {
               throw new ArgumentError("Invalid culling mode");
            }
            _miscOptions = _miscOptions & 4294963455 | _loc2_ << 8;
         }
      }
      
      public function get clipRect() : Rectangle
      {
         return _clipRect;
      }
      
      public function set clipRect(param1:Rectangle) : void
      {
         if(!RectangleUtil.compare(_clipRect,param1))
         {
            if(_onDrawRequired != null)
            {
               _onDrawRequired();
            }
            if(param1)
            {
               if(_clipRect == null)
               {
                  _clipRect = Pool.getRectangle();
               }
               _clipRect.copyFrom(param1);
            }
            else if(_clipRect)
            {
               Pool.putRectangle(_clipRect);
               _clipRect = null;
            }
         }
      }
      
      public function get renderTargetAntiAlias() : int
      {
         return _miscOptions & 15;
      }
      
      public function get renderTargetSupportsDepthAndStencil() : Boolean
      {
         return (_miscOptions & 240) != 0;
      }
      
      public function get is3D() : Boolean
      {
         return _modelviewMatrix3D != null;
      }
      
      internal function get onDrawRequired() : Function
      {
         return _onDrawRequired;
      }
      
      internal function set onDrawRequired(param1:Function) : void
      {
         _onDrawRequired = param1;
      }
   }
}
