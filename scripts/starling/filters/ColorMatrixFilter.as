package starling.filters
{
   import starling.rendering.FilterEffect;
   import starling.utils.Color;
   
   public class ColorMatrixFilter extends FragmentFilter
   {
      
      private static const LUMA_R:Number = 0.299;
      
      private static const LUMA_G:Number = 0.587;
      
      private static const LUMA_B:Number = 0.114;
      
      private static var sMatrix:Vector.<Number> = new Vector.<Number>(0);
       
      
      public function ColorMatrixFilter(param1:Vector.<Number> = null)
      {
         super();
         if(param1)
         {
            colorEffect.matrix = param1;
         }
      }
      
      override protected function createEffect() : FilterEffect
      {
         return new ColorMatrixEffect();
      }
      
      public function invert() : void
      {
         concatValues(-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0);
      }
      
      public function adjustSaturation(param1:Number) : void
      {
         param1 += 1;
         var _loc3_:Number = 1 - param1;
         var _loc4_:Number = _loc3_ * 0.299;
         var _loc2_:Number = _loc3_ * 0.587;
         var _loc5_:Number = _loc3_ * 0.114;
         concatValues(_loc4_ + param1,_loc2_,_loc5_,0,0,_loc4_,_loc2_ + param1,_loc5_,0,0,_loc4_,_loc2_,_loc5_ + param1,0,0,0,0,0,1,0);
      }
      
      public function adjustContrast(param1:Number) : void
      {
         var _loc2_:Number = param1 + 1;
         var _loc3_:Number = 128 * (1 - _loc2_);
         concatValues(_loc2_,0,0,0,_loc3_,0,_loc2_,0,0,_loc3_,0,0,_loc2_,0,_loc3_,0,0,0,1,0);
      }
      
      public function adjustBrightness(param1:Number) : void
      {
         param1 *= 255;
         concatValues(1,0,0,0,param1,0,1,0,0,param1,0,0,1,0,param1,0,0,0,1,0);
      }
      
      public function adjustHue(param1:Number) : void
      {
         param1 *= 3.141592653589793;
         var _loc2_:Number = Math.cos(param1);
         var _loc3_:Number = Math.sin(param1);
         concatValues(0.299 + _loc2_ * (1 - 0.299) + _loc3_ * -0.299,0.587 + _loc2_ * -0.587 + _loc3_ * -0.587,0.114 + _loc2_ * -0.114 + _loc3_ * (1 - 0.114),0,0,0.299 + _loc2_ * -0.299 + _loc3_ * 0.143,0.587 + _loc2_ * (1 - 0.587) + _loc3_ * 0.14,0.114 + _loc2_ * -0.114 + _loc3_ * -0.283,0,0,0.299 + _loc2_ * -0.299 + _loc3_ * -0.7010000000000001,0.587 + _loc2_ * -0.587 + _loc3_ * 0.587,0.114 + _loc2_ * (1 - 0.114) + _loc3_ * 0.114,0,0,0,0,0,1,0);
      }
      
      public function tint(param1:uint, param2:Number = 1) : void
      {
         var _loc4_:Number = Color.getRed(param1) / 255;
         var _loc6_:Number = Color.getGreen(param1) / 255;
         var _loc5_:Number = Color.getBlue(param1) / 255;
         var _loc3_:Number = 1 - param2;
         var _loc8_:Number = param2 * _loc4_;
         var _loc7_:Number = param2 * _loc6_;
         var _loc9_:Number = param2 * _loc5_;
         concatValues(_loc3_ + _loc8_ * 0.299,_loc8_ * 0.587,_loc8_ * 0.114,0,0,_loc7_ * 0.299,_loc3_ + _loc7_ * 0.587,_loc7_ * 0.114,0,0,_loc9_ * 0.299,_loc9_ * 0.587,_loc3_ + _loc9_ * 0.114,0,0,0,0,0,1,0);
      }
      
      public function reset() : void
      {
         matrix = null;
      }
      
      public function concat(param1:Vector.<Number>) : void
      {
         colorEffect.concat(param1);
         setRequiresRedraw();
      }
      
      public function concatValues(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number, param15:Number, param16:Number, param17:Number, param18:Number, param19:Number, param20:Number) : void
      {
         sMatrix.length = 0;
         sMatrix.push(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15,param16,param17,param18,param19,param20);
         concat(sMatrix);
      }
      
      public function get matrix() : Vector.<Number>
      {
         return colorEffect.matrix;
      }
      
      public function set matrix(param1:Vector.<Number>) : void
      {
         colorEffect.matrix = param1;
         setRequiresRedraw();
      }
      
      private function get colorEffect() : ColorMatrixEffect
      {
         return this.effect as ColorMatrixEffect;
      }
   }
}

import flash.display3D.Context3D;
import starling.rendering.FilterEffect;
import starling.rendering.Program;

class ColorMatrixEffect extends FilterEffect
{
   
   private static const MIN_COLOR:Vector.<Number> = new <Number>[0,0,0,0.0001];
   
   private static const IDENTITY:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
   
   private static var sMatrix:Vector.<Number> = new Vector.<Number>(20,true);
    
   
   private var _userMatrix:Vector.<Number>;
   
   private var _shaderMatrix:Vector.<Number>;
   
   public function ColorMatrixEffect()
   {
      super();
      _userMatrix = new Vector.<Number>(0);
      _shaderMatrix = new Vector.<Number>(0);
      this.matrix = null;
   }
   
   override protected function createProgram() : Program
   {
      var _loc1_:String = "m44 op, va0, vc0 \nmov v0, va1";
      var _loc2_:String = [tex("ft0","v0",0,texture),"max ft0, ft0, fc5              ","div ft0.xyz, ft0.xyz, ft0.www  ","m44 ft0, ft0, fc0              ","add ft0, ft0, fc4              ","mul ft0.xyz, ft0.xyz, ft0.www  ","mov oc, ft0                    "].join("\n");
      return Program.fromSource(_loc1_,_loc2_);
   }
   
   override protected function beforeDraw(param1:Context3D) : void
   {
      super.beforeDraw(param1);
      param1.setProgramConstantsFromVector("fragment",0,_shaderMatrix);
      param1.setProgramConstantsFromVector("fragment",5,MIN_COLOR);
   }
   
   public function reset() : void
   {
      matrix = null;
   }
   
   public function concat(param1:Vector.<Number>) : void
   {
      var _loc4_:int = 0;
      var _loc2_:int = 0;
      var _loc3_:int = 0;
      _loc4_ = 0;
      while(_loc4_ < 4)
      {
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            sMatrix[_loc3_ + _loc2_] = param1[_loc3_] * _userMatrix[_loc2_] + param1[_loc3_ + 1] * _userMatrix[_loc2_ + 5] + param1[_loc3_ + 2] * _userMatrix[_loc2_ + 10] + param1[_loc3_ + 3] * _userMatrix[_loc2_ + 15] + (_loc2_ == 4 ? param1[_loc3_ + 4] : 0);
            _loc2_++;
         }
         _loc3_ += 5;
         _loc4_++;
      }
      copyMatrix(sMatrix,_userMatrix);
      updateShaderMatrix();
   }
   
   private function copyMatrix(param1:Vector.<Number>, param2:Vector.<Number>) : void
   {
      var _loc3_:int = 0;
      _loc3_ = 0;
      while(_loc3_ < 20)
      {
         param2[_loc3_] = param1[_loc3_];
         _loc3_++;
      }
   }
   
   private function updateShaderMatrix() : void
   {
      _shaderMatrix.length = 0;
      _shaderMatrix.push(_userMatrix[0],_userMatrix[1],_userMatrix[2],_userMatrix[3],_userMatrix[5],_userMatrix[6],_userMatrix[7],_userMatrix[8],_userMatrix[10],_userMatrix[11],_userMatrix[12],_userMatrix[13],_userMatrix[15],_userMatrix[16],_userMatrix[17],_userMatrix[18],_userMatrix[4] / 255,_userMatrix[9] / 255,_userMatrix[14] / 255,_userMatrix[19] / 255);
   }
   
   public function get matrix() : Vector.<Number>
   {
      return _userMatrix;
   }
   
   public function set matrix(param1:Vector.<Number>) : void
   {
      if(param1 && param1.length != 20)
      {
         throw new ArgumentError("Invalid matrix length: must be 20");
      }
      if(param1 == null)
      {
         _userMatrix.length = 0;
         _userMatrix.push.apply(_userMatrix,IDENTITY);
      }
      else
      {
         copyMatrix(param1,_userMatrix);
      }
      updateShaderMatrix();
   }
}
