package starling.filters
{
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.core.starling_internal;
   import starling.display.DisplayObject;
   import starling.textures.SubTexture;
   import starling.textures.Texture;
   import starling.utils.MathUtil;
   import starling.utils.Pool;
   
   use namespace starling_internal;
   
   internal class FilterHelper implements IFilterHelper
   {
       
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _nativeWidth:int;
      
      private var _nativeHeight:int;
      
      private var _pool:Vector.<Texture>;
      
      private var _usePotTextures:Boolean;
      
      private var _textureFormat:String;
      
      private var _preferredScale:Number;
      
      private var _scale:Number;
      
      private var _sizeStep:int;
      
      private var _numPasses:int;
      
      private var _projectionMatrix:Matrix3D;
      
      private var _renderTarget:Texture;
      
      private var _targetBounds:Rectangle;
      
      private var _target:DisplayObject;
      
      private var _clipRect:Rectangle;
      
      private var sRegion:Rectangle;
      
      public function FilterHelper(param1:String = "bgra")
      {
         sRegion = new Rectangle();
         super();
         _usePotTextures = Starling.current.profile == "baselineConstrained";
         _preferredScale = Starling.contentScaleFactor;
         _textureFormat = param1;
         _sizeStep = 64;
         _pool = new Vector.<Texture>(0);
         _projectionMatrix = new Matrix3D();
         _targetBounds = new Rectangle();
         setSize(_sizeStep,_sizeStep);
      }
      
      public function dispose() : void
      {
         Pool.putRectangle(_clipRect);
         _clipRect = null;
         purge();
      }
      
      public function start(param1:int, param2:Boolean) : void
      {
         _numPasses = param2 ? param1 : -1;
      }
      
      public function getTexture(param1:Number = 1) : Texture
      {
         var _loc3_:Texture = null;
         var _loc2_:SubTexture = null;
         if(_numPasses >= 0)
         {
            if(_numPasses-- == 0)
            {
               return null;
            }
         }
         if(_pool.length)
         {
            _loc3_ = _pool.pop();
         }
         else
         {
            _loc3_ = Texture.empty(_nativeWidth / _scale,_nativeHeight / _scale,true,false,true,_scale,_textureFormat);
         }
         if(!MathUtil.isEquivalent(_loc3_.width,_width,0.1) || !MathUtil.isEquivalent(_loc3_.height,_height,0.1) || !MathUtil.isEquivalent(_loc3_.scale,_scale * param1))
         {
            sRegion.setTo(0,0,_width * param1,_height * param1);
            _loc2_ = _loc3_ as SubTexture;
            if(_loc2_)
            {
               _loc2_.starling_internal::setTo(_loc3_.root,sRegion,true,null,false,param1);
            }
            else
            {
               _loc3_ = new SubTexture(_loc3_.root,sRegion,true,null,false,param1);
            }
         }
         _loc3_.root.clear();
         return _loc3_;
      }
      
      public function putTexture(param1:Texture) : void
      {
         if(param1)
         {
            if(param1.root.nativeWidth == _nativeWidth && param1.root.nativeHeight == _nativeHeight)
            {
               _pool.insertAt(_pool.length,param1);
            }
            else
            {
               param1.dispose();
            }
         }
      }
      
      public function purge() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         _loc2_ = 0;
         _loc1_ = int(_pool.length);
         while(_loc2_ < _loc1_)
         {
            _pool[_loc2_].dispose();
            _loc2_++;
         }
         _pool.length = 0;
      }
      
      private function setSize(param1:Number, param2:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = _preferredScale;
         var _loc4_:int = Texture.maxSize;
         var _loc5_:int = getNativeSize(param1,_loc7_);
         var _loc3_:int = getNativeSize(param2,_loc7_);
         if(_loc5_ > _loc4_ || _loc3_ > _loc4_)
         {
            _loc6_ = _loc4_ / Math.max(_loc5_,_loc3_);
            _loc5_ *= _loc6_;
            _loc3_ *= _loc6_;
            _loc7_ *= _loc6_;
         }
         if(_nativeWidth != _loc5_ || _nativeHeight != _loc3_ || _scale != _loc7_)
         {
            purge();
            _scale = _loc7_;
            _nativeWidth = _loc5_;
            _nativeHeight = _loc3_;
         }
         _width = param1;
         _height = param2;
      }
      
      private function getNativeSize(param1:Number, param2:Number) : int
      {
         var _loc3_:Number = param1 * param2;
         if(_usePotTextures)
         {
            return _loc3_ > _sizeStep ? MathUtil.getNextPowerOfTwo(_loc3_) : _sizeStep;
         }
         return Math.ceil(_loc3_ / _sizeStep) * _sizeStep;
      }
      
      public function get projectionMatrix3D() : Matrix3D
      {
         return _projectionMatrix;
      }
      
      public function set projectionMatrix3D(param1:Matrix3D) : void
      {
         _projectionMatrix.copyFrom(param1);
      }
      
      public function get renderTarget() : Texture
      {
         return _renderTarget;
      }
      
      public function set renderTarget(param1:Texture) : void
      {
         _renderTarget = param1;
      }
      
      public function get clipRect() : Rectangle
      {
         return _clipRect;
      }
      
      public function set clipRect(param1:Rectangle) : void
      {
         if(param1)
         {
            if(_clipRect)
            {
               _clipRect.copyFrom(param1);
            }
            else
            {
               _clipRect = Pool.getRectangle(param1.x,param1.y,param1.width,param1.height);
            }
         }
         else if(_clipRect)
         {
            Pool.putRectangle(_clipRect);
            _clipRect = null;
         }
      }
      
      public function get targetBounds() : Rectangle
      {
         return _targetBounds;
      }
      
      public function set targetBounds(param1:Rectangle) : void
      {
         _targetBounds.copyFrom(param1);
         setSize(param1.width,param1.height);
      }
      
      public function get target() : DisplayObject
      {
         return _target;
      }
      
      public function set target(param1:DisplayObject) : void
      {
         _target = param1;
      }
      
      public function get textureScale() : Number
      {
         return _preferredScale;
      }
      
      public function set textureScale(param1:Number) : void
      {
         _preferredScale = param1 > 0 ? param1 : Starling.contentScaleFactor;
      }
      
      public function get textureFormat() : String
      {
         return _textureFormat;
      }
      
      public function set textureFormat(param1:String) : void
      {
         _textureFormat = param1;
      }
   }
}
