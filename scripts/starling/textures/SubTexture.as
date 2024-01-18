package starling.textures
{
   import flash.display3D.textures.TextureBase;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import starling.core.starling_internal;
   
   use namespace starling_internal;
   
   public class SubTexture extends Texture
   {
       
      
      private var _parent:Texture;
      
      private var _ownsParent:Boolean;
      
      private var _region:Rectangle;
      
      private var _frame:Rectangle;
      
      private var _rotated:Boolean;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _scale:Number;
      
      private var _transformationMatrix:Matrix;
      
      private var _transformationMatrixToRoot:Matrix;
      
      public function SubTexture(param1:Texture, param2:Rectangle = null, param3:Boolean = false, param4:Rectangle = null, param5:Boolean = false, param6:Number = 1)
      {
         super();
         starling_internal::setTo(param1,param2,param3,param4,param5,param6);
      }
      
      starling_internal function setTo(param1:Texture, param2:Rectangle = null, param3:Boolean = false, param4:Rectangle = null, param5:Boolean = false, param6:Number = 1) : void
      {
         if(_region == null)
         {
            _region = new Rectangle();
         }
         if(param2)
         {
            _region.copyFrom(param2);
         }
         else
         {
            _region.setTo(0,0,param1.width,param1.height);
         }
         if(param4)
         {
            if(_frame)
            {
               _frame.copyFrom(param4);
            }
            else
            {
               _frame = param4.clone();
            }
         }
         else
         {
            _frame = null;
         }
         _parent = param1;
         _ownsParent = param3;
         _rotated = param5;
         _width = (param5 ? _region.height : _region.width) / param6;
         _height = (param5 ? _region.width : _region.height) / param6;
         _scale = _parent.scale * param6;
         if(_frame && (_frame.x > 0 || _frame.y > 0 || _frame.right < _width || _frame.bottom < _height))
         {
            trace("[Starling] Warning: frames inside the texture\'s region are unsupported.");
         }
         updateMatrices();
      }
      
      private function updateMatrices() : void
      {
         if(_transformationMatrix)
         {
            _transformationMatrix.identity();
         }
         else
         {
            _transformationMatrix = new Matrix();
         }
         if(_transformationMatrixToRoot)
         {
            _transformationMatrixToRoot.identity();
         }
         else
         {
            _transformationMatrixToRoot = new Matrix();
         }
         if(_rotated)
         {
            _transformationMatrix.translate(0,-1);
            _transformationMatrix.rotate(3.141592653589793 / 2);
         }
         _transformationMatrix.scale(_region.width / _parent.width,_region.height / _parent.height);
         _transformationMatrix.translate(_region.x / _parent.width,_region.y / _parent.height);
         var _loc1_:* = this;
         while(_loc1_)
         {
            _transformationMatrixToRoot.concat(_loc1_._transformationMatrix);
            _loc1_ = _loc1_.parent as SubTexture;
         }
      }
      
      override public function dispose() : void
      {
         if(_ownsParent)
         {
            _parent.dispose();
         }
         super.dispose();
      }
      
      public function get parent() : Texture
      {
         return _parent;
      }
      
      public function get ownsParent() : Boolean
      {
         return _ownsParent;
      }
      
      public function get rotated() : Boolean
      {
         return _rotated;
      }
      
      public function get region() : Rectangle
      {
         return _region;
      }
      
      override public function get transformationMatrix() : Matrix
      {
         return _transformationMatrix;
      }
      
      override public function get transformationMatrixToRoot() : Matrix
      {
         return _transformationMatrixToRoot;
      }
      
      override public function get base() : TextureBase
      {
         return _parent.base;
      }
      
      override public function get root() : ConcreteTexture
      {
         return _parent.root;
      }
      
      override public function get format() : String
      {
         return _parent.format;
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      override public function get height() : Number
      {
         return _height;
      }
      
      override public function get nativeWidth() : Number
      {
         return _width * _scale;
      }
      
      override public function get nativeHeight() : Number
      {
         return _height * _scale;
      }
      
      override public function get mipMapping() : Boolean
      {
         return _parent.mipMapping;
      }
      
      override public function get premultipliedAlpha() : Boolean
      {
         return _parent.premultipliedAlpha;
      }
      
      override public function get scale() : Number
      {
         return _scale;
      }
      
      override public function get frame() : Rectangle
      {
         return _frame;
      }
   }
}
