package starling.textures
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display3D.textures.TextureBase;
   import flash.media.Camera;
   import flash.net.NetStream;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import starling.core.Starling;
   import starling.core.starling_internal;
   import starling.errors.AbstractClassError;
   import starling.errors.AbstractMethodError;
   import starling.errors.NotSupportedError;
   import starling.rendering.Painter;
   import starling.utils.Color;
   import starling.utils.execute;
   
   use namespace starling_internal;
   
   public class ConcreteTexture extends Texture
   {
       
      
      private var _base:TextureBase;
      
      private var _format:String;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _mipMapping:Boolean;
      
      private var _premultipliedAlpha:Boolean;
      
      private var _optimizedForRenderTexture:Boolean;
      
      private var _scale:Number;
      
      private var _onRestore:Function;
      
      private var _dataUploaded:Boolean;
      
      public function ConcreteTexture(param1:TextureBase, param2:String, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean = false, param8:Number = 1)
      {
         super();
         if(Capabilities.isDebugger && getQualifiedClassName(this) == "starling.textures::ConcreteTexture")
         {
            throw new AbstractClassError();
         }
         _scale = param8 <= 0 ? 1 : param8;
         _base = param1;
         _format = param2;
         _width = param3;
         _height = param4;
         _mipMapping = param5;
         _premultipliedAlpha = param6;
         _optimizedForRenderTexture = param7;
         _onRestore = null;
         _dataUploaded = false;
      }
      
      override public function dispose() : void
      {
         if(_base)
         {
            _base.dispose();
         }
         this.onRestore = null;
         super.dispose();
      }
      
      public function uploadBitmap(param1:Bitmap) : void
      {
         uploadBitmapData(param1.bitmapData);
      }
      
      public function uploadBitmapData(param1:BitmapData) : void
      {
         throw new NotSupportedError();
      }
      
      public function uploadAtfData(param1:ByteArray, param2:int = 0, param3:* = null) : void
      {
         throw new NotSupportedError();
      }
      
      public function attachNetStream(param1:NetStream, param2:Function = null) : void
      {
         attachVideo("NetStream",param1,param2);
      }
      
      public function attachCamera(param1:Camera, param2:Function = null) : void
      {
         attachVideo("Camera",param1,param2);
      }
      
      internal function attachVideo(param1:String, param2:Object, param3:Function = null) : void
      {
         throw new NotSupportedError();
      }
      
      private function onContextCreated() : void
      {
         _dataUploaded = false;
         _base = createBase();
         execute(_onRestore,this);
         if(!_dataUploaded)
         {
            clear();
         }
      }
      
      protected function createBase() : TextureBase
      {
         throw new AbstractMethodError();
      }
      
      starling_internal function recreateBase() : void
      {
         _base = createBase();
      }
      
      public function clear(param1:uint = 0, param2:Number = 0) : void
      {
         if(_premultipliedAlpha && param2 < 1)
         {
            param1 = Color.rgb(Color.getRed(param1) * param2,Color.getGreen(param1) * param2,Color.getBlue(param1) * param2);
         }
         var _loc3_:Painter = Starling.painter;
         _loc3_.pushState();
         _loc3_.state.renderTarget = this;
         try
         {
            _loc3_.clear(param1,param2);
         }
         catch(e:Error)
         {
         }
         _loc3_.popState();
         setDataUploaded();
      }
      
      protected function setDataUploaded() : void
      {
         _dataUploaded = true;
      }
      
      public function get optimizedForRenderTexture() : Boolean
      {
         return _optimizedForRenderTexture;
      }
      
      public function get isPotTexture() : Boolean
      {
         return false;
      }
      
      public function get onRestore() : Function
      {
         return _onRestore;
      }
      
      public function set onRestore(param1:Function) : void
      {
         Starling.current.removeEventListener("context3DCreate",onContextCreated);
         if(param1 != null)
         {
            _onRestore = param1;
            Starling.current.addEventListener("context3DCreate",onContextCreated);
         }
         else
         {
            _onRestore = null;
         }
      }
      
      override public function get base() : TextureBase
      {
         return _base;
      }
      
      override public function get root() : ConcreteTexture
      {
         return this;
      }
      
      override public function get format() : String
      {
         return _format;
      }
      
      override public function get width() : Number
      {
         return _width / _scale;
      }
      
      override public function get height() : Number
      {
         return _height / _scale;
      }
      
      override public function get nativeWidth() : Number
      {
         return _width;
      }
      
      override public function get nativeHeight() : Number
      {
         return _height;
      }
      
      override public function get scale() : Number
      {
         return _scale;
      }
      
      override public function get mipMapping() : Boolean
      {
         return _mipMapping;
      }
      
      override public function get premultipliedAlpha() : Boolean
      {
         return _premultipliedAlpha;
      }
   }
}
