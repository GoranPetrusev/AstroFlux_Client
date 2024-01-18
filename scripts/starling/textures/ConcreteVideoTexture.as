package starling.textures
{
   import flash.display3D.textures.TextureBase;
   import flash.display3D.textures.VideoTexture;
   import flash.events.Event;
   import starling.core.Starling;
   import starling.utils.execute;
   
   internal class ConcreteVideoTexture extends ConcreteTexture
   {
       
      
      private var _textureReadyCallback:Function;
      
      public function ConcreteVideoTexture(param1:VideoTexture, param2:Number = 1)
      {
         super(param1,"bgra",param1.videoWidth,param1.videoHeight,false,false,false,param2);
      }
      
      override public function dispose() : void
      {
         base.removeEventListener("textureReady",onTextureReady);
         super.dispose();
      }
      
      override protected function createBase() : TextureBase
      {
         return Starling.context.createVideoTexture();
      }
      
      override internal function attachVideo(param1:String, param2:Object, param3:Function = null) : void
      {
         _textureReadyCallback = param3;
         base["attach" + param1](param2);
         base.addEventListener("textureReady",onTextureReady);
         setDataUploaded();
      }
      
      private function onTextureReady(param1:Event) : void
      {
         base.removeEventListener("textureReady",onTextureReady);
         execute(_textureReadyCallback,this);
         _textureReadyCallback = null;
      }
      
      override public function get nativeWidth() : Number
      {
         return videoBase.videoWidth;
      }
      
      override public function get nativeHeight() : Number
      {
         return videoBase.videoHeight;
      }
      
      override public function get width() : Number
      {
         return nativeWidth / scale;
      }
      
      override public function get height() : Number
      {
         return nativeHeight / scale;
      }
      
      private function get videoBase() : VideoTexture
      {
         return base as VideoTexture;
      }
   }
}
