package starling.textures
{
   import flash.display.BitmapData;
   import flash.display3D.textures.RectangleTexture;
   import flash.display3D.textures.TextureBase;
   import starling.core.Starling;
   
   internal class ConcreteRectangleTexture extends ConcreteTexture
   {
       
      
      public function ConcreteRectangleTexture(param1:RectangleTexture, param2:String, param3:int, param4:int, param5:Boolean, param6:Boolean = false, param7:Number = 1)
      {
         super(param1,param2,param3,param4,false,param5,param6,param7);
      }
      
      override public function uploadBitmapData(param1:BitmapData) : void
      {
         rectangleBase.uploadFromBitmapData(param1);
         setDataUploaded();
      }
      
      override protected function createBase() : TextureBase
      {
         return Starling.context.createRectangleTexture(nativeWidth,nativeHeight,format,optimizedForRenderTexture);
      }
      
      private function get rectangleBase() : RectangleTexture
      {
         return base as RectangleTexture;
      }
   }
}
