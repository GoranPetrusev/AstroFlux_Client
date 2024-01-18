package starling.textures
{
   import flash.display.BitmapData;
   import flash.display3D.textures.Texture;
   import flash.display3D.textures.TextureBase;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import starling.core.Starling;
   import starling.utils.MathUtil;
   import starling.utils.execute;
   
   internal class ConcretePotTexture extends ConcreteTexture
   {
      
      private static var sMatrix:Matrix = new Matrix();
      
      private static var sRectangle:Rectangle = new Rectangle();
      
      private static var sOrigin:Point = new Point();
       
      
      private var _textureReadyCallback:Function;
      
      public function ConcretePotTexture(param1:flash.display3D.textures.Texture, param2:String, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean = false, param8:Number = 1)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
         if(param3 != MathUtil.getNextPowerOfTwo(param3))
         {
            throw new ArgumentError("width must be a power of two");
         }
         if(param4 != MathUtil.getNextPowerOfTwo(param4))
         {
            throw new ArgumentError("height must be a power of two");
         }
      }
      
      override public function dispose() : void
      {
         base.removeEventListener("textureReady",onTextureReady);
         super.dispose();
      }
      
      override protected function createBase() : TextureBase
      {
         return Starling.context.createTexture(nativeWidth,nativeHeight,format,optimizedForRenderTexture);
      }
      
      override public function uploadBitmapData(param1:BitmapData) : void
      {
         var _loc3_:* = 0;
         var _loc6_:* = 0;
         var _loc4_:int = 0;
         var _loc2_:BitmapData = null;
         var _loc5_:Rectangle = null;
         var _loc8_:Matrix = null;
         potBase.uploadFromBitmapData(param1);
         var _loc7_:BitmapData = null;
         if(param1.width != nativeWidth || param1.height != nativeHeight)
         {
            (_loc7_ = new BitmapData(nativeWidth,nativeHeight,true,0)).copyPixels(param1,param1.rect,sOrigin);
            param1 = _loc7_;
         }
         if(mipMapping && param1.width > 1 && param1.height > 1)
         {
            _loc3_ = param1.width >> 1;
            _loc6_ = param1.height >> 1;
            _loc4_ = 1;
            _loc2_ = new BitmapData(_loc3_,_loc6_,true,0);
            _loc5_ = sRectangle;
            (_loc8_ = sMatrix).setTo(0.5,0,0,0.5,0,0);
            while(_loc3_ >= 1 || _loc6_ >= 1)
            {
               _loc5_.setTo(0,0,_loc3_,_loc6_);
               _loc2_.fillRect(_loc5_,0);
               _loc2_.draw(param1,_loc8_,null,null,null,true);
               potBase.uploadFromBitmapData(_loc2_,_loc4_++);
               _loc8_.scale(0.5,0.5);
               _loc3_ >>= 1;
               _loc6_ >>= 1;
            }
            _loc2_.dispose();
         }
         if(_loc7_)
         {
            _loc7_.dispose();
         }
         setDataUploaded();
      }
      
      override public function get isPotTexture() : Boolean
      {
         return true;
      }
      
      override public function uploadAtfData(param1:ByteArray, param2:int = 0, param3:* = null) : void
      {
         var _loc4_:Boolean = param3 is Function || param3 === true;
         if(param3 is Function)
         {
            _textureReadyCallback = param3 as Function;
            base.addEventListener("textureReady",onTextureReady);
         }
         potBase.uploadCompressedTextureFromByteArray(param1,param2,_loc4_);
         setDataUploaded();
      }
      
      private function onTextureReady(param1:Event) : void
      {
         base.removeEventListener("textureReady",onTextureReady);
         execute(_textureReadyCallback,this);
         _textureReadyCallback = null;
      }
      
      private function get potBase() : flash.display3D.textures.Texture
      {
         return base as flash.display3D.textures.Texture;
      }
   }
}
