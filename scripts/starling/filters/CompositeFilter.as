package starling.filters
{
   import flash.geom.Point;
   import starling.rendering.FilterEffect;
   import starling.rendering.Painter;
   import starling.textures.Texture;
   
   public class CompositeFilter extends FragmentFilter
   {
       
      
      public function CompositeFilter()
      {
         super();
      }
      
      override public function process(param1:Painter, param2:IFilterHelper, param3:Texture = null, param4:Texture = null, param5:Texture = null, param6:Texture = null) : Texture
      {
         compositeEffect.texture = param3;
         compositeEffect.getLayerAt(1).texture = param4;
         compositeEffect.getLayerAt(2).texture = param5;
         compositeEffect.getLayerAt(3).texture = param6;
         if(param4)
         {
            param4.setupTextureCoordinates(vertexData,0,"texCoords1");
         }
         if(param5)
         {
            param5.setupTextureCoordinates(vertexData,0,"texCoords2");
         }
         if(param6)
         {
            param6.setupTextureCoordinates(vertexData,0,"texCoords3");
         }
         return super.process(param1,param2,param3,param4,param5,param6);
      }
      
      override protected function createEffect() : FilterEffect
      {
         return new CompositeEffect();
      }
      
      public function getOffsetAt(param1:int, param2:Point = null) : Point
      {
         if(param2 == null)
         {
            param2 = new Point();
         }
         param2.x = compositeEffect.getLayerAt(param1).x;
         param2.y = compositeEffect.getLayerAt(param1).y;
         return param2;
      }
      
      public function setOffsetAt(param1:int, param2:Number, param3:Number) : void
      {
         compositeEffect.getLayerAt(param1).x = param2;
         compositeEffect.getLayerAt(param1).y = param3;
      }
      
      public function getColorAt(param1:int) : uint
      {
         return compositeEffect.getLayerAt(param1).color;
      }
      
      public function setColorAt(param1:int, param2:uint, param3:Boolean = false) : void
      {
         compositeEffect.getLayerAt(param1).color = param2;
         compositeEffect.getLayerAt(param1).replaceColor = param3;
      }
      
      public function getAlphaAt(param1:int) : Number
      {
         return compositeEffect.getLayerAt(param1).alpha;
      }
      
      public function setAlphaAt(param1:int, param2:Number) : void
      {
         compositeEffect.getLayerAt(param1).alpha = param2;
      }
      
      private function get compositeEffect() : CompositeEffect
      {
         return this.effect as CompositeEffect;
      }
   }
}

import flash.display3D.Context3D;
import starling.rendering.FilterEffect;
import starling.rendering.Program;
import starling.rendering.VertexDataFormat;
import starling.textures.Texture;
import starling.utils.Color;
import starling.utils.RenderUtil;
import starling.utils.StringUtil;

class CompositeEffect extends FilterEffect
{
   
   public static const VERTEX_FORMAT:VertexDataFormat = FilterEffect.VERTEX_FORMAT.extend("texCoords1:float2, texCoords2:float2, texCoords3:float2");
   
   private static var sLayers:Array = [];
   
   private static var sOffset:Vector.<Number> = new <Number>[0,0,0,0];
   
   private static var sColor:Vector.<Number> = new <Number>[0,0,0,0];
    
   
   private var _layers:Vector.<CompositeLayer>;
   
   public function CompositeEffect(param1:int = 4)
   {
      var _loc2_:int = 0;
      super();
      if(param1 < 1 || param1 > 4)
      {
         throw new ArgumentError("number of layers must be between 1 and 4");
      }
      _layers = new Vector.<CompositeLayer>(param1,true);
      _loc2_ = 0;
      while(_loc2_ < param1)
      {
         _layers[_loc2_] = new CompositeLayer();
         _loc2_++;
      }
   }
   
   public function getLayerAt(param1:int) : CompositeLayer
   {
      return _layers[param1];
   }
   
   private function getUsedLayers(param1:Array = null) : Array
   {
      if(param1 == null)
      {
         param1 = [];
      }
      else
      {
         param1.length = 0;
      }
      for each(var _loc2_ in _layers)
      {
         if(_loc2_.texture)
         {
            param1[param1.length] = _loc2_;
         }
      }
      return param1;
   }
   
   override protected function createProgram() : Program
   {
      var _loc6_:int = 0;
      var _loc3_:Array = null;
      var _loc9_:CompositeLayer = null;
      var _loc5_:Array = null;
      var _loc7_:String = null;
      var _loc8_:String = null;
      var _loc2_:String = null;
      var _loc4_:Array;
      var _loc1_:int = int((_loc4_ = getUsedLayers(sLayers)).length);
      if(_loc1_)
      {
         _loc3_ = ["m44 op, va0, vc0"];
         _loc9_ = _layers[0];
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc3_.push(StringUtil.format("add v{0}, va{1}, vc{2}",_loc6_,_loc6_ + 1,_loc6_ + 4));
            _loc6_++;
         }
         _loc5_ = ["seq ft5, v0, v0"];
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc7_ = "ft" + _loc6_;
            _loc8_ = "fc" + _loc6_;
            _loc2_ = "v" + _loc6_;
            _loc9_ = _layers[_loc6_];
            _loc5_.push(tex(_loc7_,_loc2_,_loc6_,_loc4_[_loc6_].texture));
            if(_loc9_.replaceColor)
            {
               _loc5_.push("mul " + _loc7_ + ".w,   " + _loc7_ + ".w,   " + _loc8_ + ".w","sat " + _loc7_ + ".w,   " + _loc7_ + ".w    ","mul " + _loc7_ + ".xyz, " + _loc8_ + ".xyz, " + _loc7_ + ".www");
            }
            else
            {
               _loc5_.push("mul " + _loc7_ + ", " + _loc7_ + ", " + _loc8_);
            }
            if(_loc6_ != 0)
            {
               _loc5_.push("sub ft4, ft5, " + _loc7_ + ".wwww","mul ft0, ft0, ft4","add ft0, ft0, " + _loc7_);
            }
            _loc6_++;
         }
         _loc5_.push("mov oc, ft0");
         return Program.fromSource(_loc3_.join("\n"),_loc5_.join("\n"));
      }
      return super.createProgram();
   }
   
   override protected function get programVariantName() : uint
   {
      var _loc3_:* = 0;
      var _loc6_:CompositeLayer = null;
      var _loc5_:int = 0;
      var _loc2_:uint = 0;
      var _loc4_:Array;
      var _loc1_:int = int((_loc4_ = getUsedLayers(sLayers)).length);
      _loc5_ = 0;
      while(_loc5_ < _loc1_)
      {
         _loc6_ = _loc4_[_loc5_];
         _loc3_ = uint(RenderUtil.getTextureVariantBits(_loc6_.texture) | int(_loc6_.replaceColor) << 3);
         _loc2_ |= _loc3_ << _loc5_ * 4;
         _loc5_++;
      }
      return _loc2_;
   }
   
   override protected function beforeDraw(param1:Context3D) : void
   {
      var _loc5_:int = 0;
      var _loc6_:CompositeLayer = null;
      var _loc3_:Texture = null;
      var _loc7_:Number = NaN;
      var _loc4_:Array;
      var _loc2_:int = int((_loc4_ = getUsedLayers(sLayers)).length);
      if(_loc2_)
      {
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = (_loc6_ = _loc4_[_loc5_]).texture;
            _loc7_ = _loc6_.replaceColor ? 1 : _loc6_.alpha;
            sOffset[0] = -_loc6_.x / (_loc3_.root.nativeWidth / _loc3_.scale);
            sOffset[1] = -_loc6_.y / (_loc3_.root.nativeHeight / _loc3_.scale);
            sColor[0] = Color.getRed(_loc6_.color) * _loc7_ / 255;
            sColor[1] = Color.getGreen(_loc6_.color) * _loc7_ / 255;
            sColor[2] = Color.getBlue(_loc6_.color) * _loc7_ / 255;
            sColor[3] = _loc6_.alpha;
            param1.setProgramConstantsFromVector("vertex",_loc5_ + 4,sOffset);
            param1.setProgramConstantsFromVector("fragment",_loc5_,sColor);
            param1.setTextureAt(_loc5_,_loc3_.base);
            RenderUtil.setSamplerStateAt(_loc5_,_loc3_.mipMapping,textureSmoothing);
            _loc5_++;
         }
         _loc5_ = 1;
         while(_loc5_ < _loc2_)
         {
            vertexFormat.setVertexBufferAt(_loc5_ + 1,vertexBuffer,"texCoords" + _loc5_);
            _loc5_++;
         }
      }
      super.beforeDraw(param1);
   }
   
   override protected function afterDraw(param1:Context3D) : void
   {
      var _loc4_:int = 0;
      var _loc3_:Array = getUsedLayers(sLayers);
      var _loc2_:int = int(_loc3_.length);
      _loc4_ = 0;
      while(_loc4_ < _loc2_)
      {
         param1.setTextureAt(_loc4_,null);
         param1.setVertexBufferAt(_loc4_ + 1,null);
         _loc4_++;
      }
      super.afterDraw(param1);
   }
   
   override public function get vertexFormat() : VertexDataFormat
   {
      return VERTEX_FORMAT;
   }
   
   public function get numLayers() : int
   {
      return _layers.length;
   }
   
   override public function set texture(param1:Texture) : void
   {
      _layers[0].texture = param1;
      super.texture = param1;
   }
}

import starling.textures.Texture;

class CompositeLayer
{
    
   
   public var texture:Texture;
   
   public var x:Number;
   
   public var y:Number;
   
   public var color:uint;
   
   public var alpha:Number;
   
   public var replaceColor:Boolean;
   
   public function CompositeLayer()
   {
      super();
      x = y = 0;
      alpha = 1;
      color = 16777215;
   }
}
