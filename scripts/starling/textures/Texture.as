package starling.textures
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display3D.Context3D;
   import flash.display3D.textures.RectangleTexture;
   import flash.display3D.textures.Texture;
   import flash.display3D.textures.TextureBase;
   import flash.display3D.textures.VideoTexture;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.Camera;
   import flash.net.NetStream;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import starling.core.Starling;
   import starling.errors.AbstractClassError;
   import starling.errors.MissingContextError;
   import starling.errors.NotSupportedError;
   import starling.rendering.VertexData;
   import starling.utils.MathUtil;
   import starling.utils.MatrixUtil;
   import starling.utils.SystemUtil;
   
   public class Texture
   {
      
      private static var sDefaultOptions:TextureOptions = new TextureOptions();
      
      private static var sRectangle:Rectangle = new Rectangle();
      
      private static var sMatrix:Matrix = new Matrix();
      
      private static var sPoint:Point = new Point();
       
      
      public function Texture()
      {
         super();
         if(Capabilities.isDebugger && getQualifiedClassName(this) == "starling.textures::Texture")
         {
            throw new AbstractClassError();
         }
      }
      
      public static function fromData(param1:Object, param2:TextureOptions = null) : starling.textures.Texture
      {
         if(param1 is Bitmap)
         {
            param1 = (param1 as Bitmap).bitmapData;
         }
         if(param2 == null)
         {
            param2 = sDefaultOptions;
         }
         if(param1 is Class)
         {
            return fromEmbeddedAsset(param1 as Class,param2.mipMapping,param2.optimizeForRenderToTexture,param2.scale,param2.format,param2.forcePotTexture);
         }
         if(param1 is BitmapData)
         {
            return fromBitmapData(param1 as BitmapData,param2.mipMapping,param2.optimizeForRenderToTexture,param2.scale,param2.format,param2.forcePotTexture);
         }
         if(param1 is ByteArray)
         {
            return fromAtfData(param1 as ByteArray,param2.scale,param2.mipMapping,param2.onReady);
         }
         throw new ArgumentError("Unsupported \'data\' type: " + getQualifiedClassName(param1));
      }
      
      public static function fromTextureBase(param1:TextureBase, param2:int, param3:int, param4:TextureOptions = null) : ConcreteTexture
      {
         if(param4 == null)
         {
            param4 = sDefaultOptions;
         }
         if(param1 is flash.display3D.textures.Texture)
         {
            return new ConcretePotTexture(param1 as flash.display3D.textures.Texture,param4.format,param2,param3,param4.mipMapping,param4.premultipliedAlpha,param4.optimizeForRenderToTexture,param4.scale);
         }
         if(param1 is RectangleTexture)
         {
            return new ConcreteRectangleTexture(param1 as RectangleTexture,param4.format,param2,param3,param4.premultipliedAlpha,param4.optimizeForRenderToTexture,param4.scale);
         }
         if(param1 is VideoTexture)
         {
            return new ConcreteVideoTexture(param1 as VideoTexture,param4.scale);
         }
         throw new ArgumentError("Unsupported \'base\' type: " + getQualifiedClassName(param1));
      }
      
      public static function fromEmbeddedAsset(param1:Class, param2:Boolean = false, param3:Boolean = false, param4:Number = 1, param5:String = "bgra", param6:Boolean = false) : starling.textures.Texture
      {
         var texture:starling.textures.Texture;
         var assetClass:Class = param1;
         var mipMapping:Boolean = param2;
         var optimizeForRenderToTexture:Boolean = param3;
         var scale:Number = param4;
         var format:String = param5;
         var forcePotTexture:Boolean = param6;
         var asset:Object = new assetClass();
         if(asset is Bitmap)
         {
            texture = starling.textures.Texture.fromBitmap(asset as Bitmap,mipMapping,optimizeForRenderToTexture,scale,format,forcePotTexture);
            texture.root.onRestore = function():void
            {
               texture.root.uploadBitmap(new assetClass());
            };
         }
         else
         {
            if(!(asset is ByteArray))
            {
               throw new ArgumentError("Invalid asset type: " + getQualifiedClassName(asset));
            }
            texture = starling.textures.Texture.fromAtfData(asset as ByteArray,scale,mipMapping,null);
            texture.root.onRestore = function():void
            {
               texture.root.uploadAtfData(new assetClass());
            };
         }
         asset = null;
         return texture;
      }
      
      public static function fromBitmap(param1:Bitmap, param2:Boolean = false, param3:Boolean = false, param4:Number = 1, param5:String = "bgra", param6:Boolean = false) : starling.textures.Texture
      {
         return fromBitmapData(param1.bitmapData,param2,param3,param4,param5,param6);
      }
      
      public static function fromBitmapData(param1:BitmapData, param2:Boolean = false, param3:Boolean = false, param4:Number = 1, param5:String = "bgra", param6:Boolean = false) : starling.textures.Texture
      {
         var data:BitmapData = param1;
         var generateMipMaps:Boolean = param2;
         var optimizeForRenderToTexture:Boolean = param3;
         var scale:Number = param4;
         var format:String = param5;
         var forcePotTexture:Boolean = param6;
         var texture:starling.textures.Texture = starling.textures.Texture.empty(data.width / scale,data.height / scale,true,generateMipMaps,optimizeForRenderToTexture,scale,format,forcePotTexture);
         texture.root.uploadBitmapData(data);
         texture.root.onRestore = function():void
         {
            texture.root.uploadBitmapData(data);
         };
         return texture;
      }
      
      public static function fromAtfData(param1:ByteArray, param2:Number = 1, param3:Boolean = true, param4:Function = null, param5:Boolean = false) : starling.textures.Texture
      {
         var atfData:AtfData;
         var nativeTexture:flash.display3D.textures.Texture;
         var concreteTexture:ConcreteTexture;
         var data:ByteArray = param1;
         var scale:Number = param2;
         var useMipMaps:Boolean = param3;
         var async:Function = param4;
         var premultipliedAlpha:Boolean = param5;
         var context:Context3D = Starling.context;
         if(context == null)
         {
            throw new MissingContextError();
         }
         atfData = new AtfData(data);
         nativeTexture = context.createTexture(atfData.width,atfData.height,atfData.format,false);
         concreteTexture = new ConcretePotTexture(nativeTexture,atfData.format,atfData.width,atfData.height,useMipMaps && atfData.numTextures > 1,premultipliedAlpha,false,scale);
         concreteTexture.uploadAtfData(data,0,async);
         concreteTexture.onRestore = function():void
         {
            concreteTexture.uploadAtfData(data,0);
         };
         return concreteTexture;
      }
      
      public static function fromNetStream(param1:NetStream, param2:Number = 1, param3:Function = null) : starling.textures.Texture
      {
         var stream:NetStream = param1;
         var scale:Number = param2;
         var onComplete:Function = param3;
         if(stream.client == stream && !("onMetaData" in stream))
         {
            stream.client = {"onMetaData":function(param1:Object):void
            {
            }};
         }
         return fromVideoAttachment("NetStream",stream,scale,onComplete);
      }
      
      public static function fromCamera(param1:Camera, param2:Number = 1, param3:Function = null) : starling.textures.Texture
      {
         return fromVideoAttachment("Camera",param1,param2,param3);
      }
      
      private static function fromVideoAttachment(param1:String, param2:Object, param3:Number, param4:Function) : starling.textures.Texture
      {
         var context:Context3D;
         var base:VideoTexture;
         var texture:ConcreteTexture;
         var type:String = param1;
         var attachment:Object = param2;
         var scale:Number = param3;
         var onComplete:Function = param4;
         if(!SystemUtil.supportsVideoTexture)
         {
            throw new NotSupportedError("Video Textures are not supported on this platform");
         }
         context = Starling.context;
         if(context == null)
         {
            throw new MissingContextError();
         }
         base = context.createVideoTexture();
         texture = new ConcreteVideoTexture(base,scale);
         texture.attachVideo(type,attachment,onComplete);
         texture.onRestore = function():void
         {
            texture.root.attachVideo(type,attachment);
         };
         return texture;
      }
      
      public static function fromColor(param1:Number, param2:Number, param3:uint = 16777215, param4:Number = 1, param5:Boolean = false, param6:Number = -1, param7:String = "bgra", param8:Boolean = false) : starling.textures.Texture
      {
         var width:Number = param1;
         var height:Number = param2;
         var color:uint = param3;
         var alpha:Number = param4;
         var optimizeForRenderToTexture:Boolean = param5;
         var scale:Number = param6;
         var format:String = param7;
         var forcePotTexture:Boolean = param8;
         var texture:starling.textures.Texture = starling.textures.Texture.empty(width,height,true,false,optimizeForRenderToTexture,scale,format,forcePotTexture);
         texture.root.clear(color,alpha);
         texture.root.onRestore = function():void
         {
            texture.root.clear(color,alpha);
         };
         return texture;
      }
      
      public static function empty(param1:Number, param2:Number, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false, param6:Number = -1, param7:String = "bgra", param8:Boolean = false) : starling.textures.Texture
      {
         var _loc11_:int = 0;
         var _loc10_:int = 0;
         var _loc13_:TextureBase = null;
         var _loc14_:ConcreteTexture = null;
         if(param6 <= 0)
         {
            param6 = Starling.contentScaleFactor;
         }
         var _loc15_:Context3D;
         if((_loc15_ = Starling.context) == null)
         {
            throw new MissingContextError();
         }
         var _loc16_:Number = param1 * param6;
         var _loc9_:Number = param2 * param6;
         var _loc12_:Boolean;
         if(_loc12_ = !param8 && !param4 && Starling.current.profile != "baselineConstrained" && param7.indexOf("compressed") == -1)
         {
            _loc10_ = Math.ceil(_loc16_ - 1e-9);
            _loc11_ = Math.ceil(_loc9_ - 1e-9);
            _loc13_ = _loc15_.createRectangleTexture(_loc10_,_loc11_,param7,param5);
            _loc14_ = new ConcreteRectangleTexture(_loc13_ as RectangleTexture,param7,_loc10_,_loc11_,param3,param5,param6);
         }
         else
         {
            _loc10_ = MathUtil.getNextPowerOfTwo(_loc16_);
            _loc11_ = MathUtil.getNextPowerOfTwo(_loc9_);
            _loc13_ = _loc15_.createTexture(_loc10_,_loc11_,param7,param5);
            _loc14_ = new ConcretePotTexture(_loc13_ as flash.display3D.textures.Texture,param7,_loc10_,_loc11_,param4,param3,param5,param6);
         }
         _loc14_.onRestore = _loc14_.clear;
         if(_loc10_ - _loc16_ < 0.001 && _loc11_ - _loc9_ < 0.001)
         {
            return _loc14_;
         }
         return new SubTexture(_loc14_,new Rectangle(0,0,param1,param2),true);
      }
      
      public static function fromTexture(param1:starling.textures.Texture, param2:Rectangle = null, param3:Rectangle = null, param4:Boolean = false, param5:Number = 1) : starling.textures.Texture
      {
         return new SubTexture(param1,param2,false,param3,param4,param5);
      }
      
      public static function get maxSize() : int
      {
         var _loc2_:Starling = Starling.current;
         var _loc1_:String = !!_loc2_ ? _loc2_.profile : "baseline";
         if(_loc1_ == "baseline" || _loc1_ == "baselineConstrained")
         {
            return 2048;
         }
         return 4096;
      }
      
      public function dispose() : void
      {
      }
      
      public function setupVertexPositions(param1:VertexData, param2:int = 0, param3:String = "position", param4:Rectangle = null) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:Rectangle = this.frame;
         var _loc7_:Number = this.width;
         var _loc9_:Number = this.height;
         if(_loc8_)
         {
            sRectangle.setTo(-_loc8_.x,-_loc8_.y,_loc7_,_loc9_);
         }
         else
         {
            sRectangle.setTo(0,0,_loc7_,_loc9_);
         }
         param1.setPoint(param2,param3,sRectangle.left,sRectangle.top);
         param1.setPoint(param2 + 1,param3,sRectangle.right,sRectangle.top);
         param1.setPoint(param2 + 2,param3,sRectangle.left,sRectangle.bottom);
         param1.setPoint(param2 + 3,param3,sRectangle.right,sRectangle.bottom);
         if(param4)
         {
            _loc5_ = param4.width / frameWidth;
            _loc6_ = param4.height / frameHeight;
            if(_loc5_ != 1 || _loc6_ != 1 || param4.x != 0 || param4.y != 0)
            {
               sMatrix.identity();
               sMatrix.scale(_loc5_,_loc6_);
               sMatrix.translate(param4.x,param4.y);
               param1.transformPoints(param3,sMatrix,param2,4);
            }
         }
      }
      
      public function setupTextureCoordinates(param1:VertexData, param2:int = 0, param3:String = "texCoords") : void
      {
         setTexCoords(param1,param2,param3,0,0);
         setTexCoords(param1,param2 + 1,param3,1,0);
         setTexCoords(param1,param2 + 2,param3,0,1);
         setTexCoords(param1,param2 + 3,param3,1,1);
      }
      
      public function localToGlobal(param1:Number, param2:Number, param3:Point = null) : Point
      {
         if(param3 == null)
         {
            param3 = new Point();
         }
         if(this == root)
         {
            param3.setTo(param1,param2);
         }
         else
         {
            MatrixUtil.transformCoords(transformationMatrixToRoot,param1,param2,param3);
         }
         return param3;
      }
      
      public function globalToLocal(param1:Number, param2:Number, param3:Point = null) : Point
      {
         if(param3 == null)
         {
            param3 = new Point();
         }
         if(this == root)
         {
            param3.setTo(param1,param2);
         }
         else
         {
            sMatrix.identity();
            sMatrix.copyFrom(transformationMatrixToRoot);
            sMatrix.invert();
            MatrixUtil.transformCoords(sMatrix,param1,param2,param3);
         }
         return param3;
      }
      
      public function setTexCoords(param1:VertexData, param2:int, param3:String, param4:Number, param5:Number) : void
      {
         localToGlobal(param4,param5,sPoint);
         param1.setPoint(param2,param3,sPoint.x,sPoint.y);
      }
      
      public function getTexCoords(param1:VertexData, param2:int, param3:String = "texCoords", param4:Point = null) : Point
      {
         if(param4 == null)
         {
            param4 = new Point();
         }
         param1.getPoint(param2,param3,param4);
         return globalToLocal(param4.x,param4.y,param4);
      }
      
      public function get frame() : Rectangle
      {
         return null;
      }
      
      public function get frameWidth() : Number
      {
         return !!frame ? frame.width : width;
      }
      
      public function get frameHeight() : Number
      {
         return !!frame ? frame.height : height;
      }
      
      public function get width() : Number
      {
         return 0;
      }
      
      public function get height() : Number
      {
         return 0;
      }
      
      public function get nativeWidth() : Number
      {
         return 0;
      }
      
      public function get nativeHeight() : Number
      {
         return 0;
      }
      
      public function get scale() : Number
      {
         return 1;
      }
      
      public function get base() : TextureBase
      {
         return null;
      }
      
      public function get root() : ConcreteTexture
      {
         return null;
      }
      
      public function get format() : String
      {
         return "bgra";
      }
      
      public function get mipMapping() : Boolean
      {
         return false;
      }
      
      public function get premultipliedAlpha() : Boolean
      {
         return false;
      }
      
      public function get transformationMatrix() : Matrix
      {
         return null;
      }
      
      public function get transformationMatrixToRoot() : Matrix
      {
         return null;
      }
   }
}
