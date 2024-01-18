package starling.filters
{
   import starling.rendering.FilterEffect;
   import starling.rendering.Painter;
   import starling.textures.Texture;
   
   public class BlurFilter extends FragmentFilter
   {
       
      
      private var _blurX:Number;
      
      private var _blurY:Number;
      
      public function BlurFilter(param1:Number = 1, param2:Number = 1, param3:Number = 1)
      {
         super();
         _blurX = param1;
         _blurY = param2;
         this.resolution = param3;
      }
      
      override public function process(param1:Painter, param2:IFilterHelper, param3:Texture = null, param4:Texture = null, param5:Texture = null, param6:Texture = null) : Texture
      {
         var _loc11_:* = null;
         var _loc10_:BlurEffect = this.effect as BlurEffect;
         if(_blurX == 0 && _blurY == 0)
         {
            _loc10_.strength = 0;
            return super.process(param1,param2,param3);
         }
         var _loc9_:Number = Math.abs(_blurX);
         var _loc8_:Number = Math.abs(_blurY);
         var _loc7_:* = param3;
         _loc10_.direction = "horizontal";
         while(_loc9_ > 0)
         {
            _loc10_.strength = Math.min(1,_loc9_);
            _loc9_ -= _loc10_.strength;
            _loc11_ = _loc7_;
            _loc7_ = super.process(param1,param2,_loc11_);
            if(_loc11_ != param3)
            {
               param2.putTexture(_loc11_);
            }
         }
         _loc10_.direction = "vertical";
         while(_loc8_ > 0)
         {
            _loc10_.strength = Math.min(1,_loc8_);
            _loc8_ -= _loc10_.strength;
            _loc11_ = _loc7_;
            _loc7_ = super.process(param1,param2,_loc11_);
            if(_loc11_ != param3)
            {
               param2.putTexture(_loc11_);
            }
         }
         return _loc7_;
      }
      
      override protected function createEffect() : FilterEffect
      {
         return new BlurEffect();
      }
      
      override public function set resolution(param1:Number) : void
      {
         super.resolution = param1;
         updatePadding();
      }
      
      override public function get numPasses() : int
      {
         return Math.ceil(_blurX) + Math.ceil(_blurY) || 1;
      }
      
      private function updatePadding() : void
      {
         var _loc1_:Number = (!!_blurX ? Math.ceil(Math.abs(_blurX)) + 3 : 1) / resolution;
         var _loc2_:Number = (!!_blurY ? Math.ceil(Math.abs(_blurY)) + 3 : 1) / resolution;
         padding.setTo(_loc1_,_loc1_,_loc2_,_loc2_);
      }
      
      public function get blurX() : Number
      {
         return _blurX;
      }
      
      public function set blurX(param1:Number) : void
      {
         _blurX = param1;
         updatePadding();
      }
      
      public function get blurY() : Number
      {
         return _blurY;
      }
      
      public function set blurY(param1:Number) : void
      {
         _blurY = param1;
         updatePadding();
      }
   }
}

import flash.display3D.Context3D;
import starling.rendering.FilterEffect;
import starling.rendering.Program;
import starling.utils.MathUtil;

class BlurEffect extends FilterEffect
{
   
   public static const HORIZONTAL:String = "horizontal";
   
   public static const VERTICAL:String = "vertical";
   
   private static const MAX_SIGMA:Number = 2;
    
   
   private var _strength:Number;
   
   private var _direction:String;
   
   private var _offsets:Vector.<Number>;
   
   private var _weights:Vector.<Number>;
   
   private var sTmpWeights:Vector.<Number>;
   
   public function BlurEffect(param1:String = "horizontal", param2:Number = 1)
   {
      _offsets = new <Number>[0,0,0,0];
      _weights = new <Number>[0,0,0,0];
      sTmpWeights = new Vector.<Number>(5,true);
      super();
      this.strength = param2;
      this.direction = param1;
   }
   
   override protected function createProgram() : Program
   {
      if(_strength == 0)
      {
         return super.createProgram();
      }
      var _loc1_:String = ["m44 op, va0, vc0     ","mov v0, va1          ","sub v1, va1, vc4.zwxx","sub v2, va1, vc4.xyxx","add v3, va1, vc4.xyxx","add v4, va1, vc4.zwxx"].join("\n");
      var _loc2_:String = [tex("ft0","v0",0,texture),"mul ft5, ft0, fc0.xxxx       ",tex("ft1","v1",0,texture),"mul ft1, ft1, fc0.zzzz       ","add ft5, ft5, ft1            ",tex("ft2","v2",0,texture),"mul ft2, ft2, fc0.yyyy       ","add ft5, ft5, ft2            ",tex("ft3","v3",0,texture),"mul ft3, ft3, fc0.yyyy       ","add ft5, ft5, ft3            ",tex("ft4","v4",0,texture),"mul ft4, ft4, fc0.zzzz       ","add  oc, ft5, ft4            "].join("\n");
      return Program.fromSource(_loc1_,_loc2_);
   }
   
   override protected function beforeDraw(param1:Context3D) : void
   {
      super.beforeDraw(param1);
      if(_strength)
      {
         updateParameters();
         param1.setProgramConstantsFromVector("vertex",4,_offsets);
         param1.setProgramConstantsFromVector("fragment",0,_weights);
      }
   }
   
   override protected function get programVariantName() : uint
   {
      return super.programVariantName | (!!_strength ? 16 : 0);
   }
   
   private function updateParameters() : void
   {
      var _loc1_:Number = NaN;
      var _loc8_:Number = NaN;
      var _loc5_:int = 0;
      if(_direction == "horizontal")
      {
         _loc1_ = _strength * 2;
         _loc8_ = 1 / texture.root.width;
      }
      else
      {
         _loc1_ = _strength * 2;
         _loc8_ = 1 / texture.root.height;
      }
      var _loc9_:Number = 2 * _loc1_ * _loc1_;
      var _loc3_:Number = 1 / Math.sqrt(_loc9_ * 3.141592653589793);
      _loc5_ = 0;
      while(_loc5_ < 5)
      {
         sTmpWeights[_loc5_] = _loc3_ * Math.exp(-_loc5_ * _loc5_ / _loc9_);
         _loc5_++;
      }
      _weights[0] = sTmpWeights[0];
      _weights[1] = sTmpWeights[1] + sTmpWeights[2];
      _weights[2] = sTmpWeights[3] + sTmpWeights[4];
      var _loc2_:Number = _weights[0] + 2 * _weights[1] + 2 * _weights[2];
      var _loc4_:Number = 1 / _loc2_;
      _weights[0] *= _loc4_;
      _weights[1] *= _loc4_;
      _weights[2] *= _loc4_;
      var _loc7_:Number = (_loc8_ * sTmpWeights[1] + 2 * _loc8_ * sTmpWeights[2]) / _weights[1];
      var _loc6_:Number = (3 * _loc8_ * sTmpWeights[3] + 4 * _loc8_ * sTmpWeights[4]) / _weights[2];
      if(_direction == "horizontal")
      {
         _offsets[0] = _loc7_;
         _offsets[1] = 0;
         _offsets[2] = _loc6_;
         _offsets[3] = 0;
      }
      else
      {
         _offsets[0] = 0;
         _offsets[1] = _loc7_;
         _offsets[2] = 0;
         _offsets[3] = _loc6_;
      }
   }
   
   public function get direction() : String
   {
      return _direction;
   }
   
   public function set direction(param1:String) : void
   {
      _direction = param1;
   }
   
   public function get strength() : Number
   {
      return _strength;
   }
   
   public function set strength(param1:Number) : void
   {
      _strength = MathUtil.clamp(param1,0,1);
   }
}
