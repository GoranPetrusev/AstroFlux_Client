package starling.textures
{
   import starling.core.Starling;
   
   public class TextureOptions
   {
       
      
      private var _scale:Number;
      
      private var _format:String;
      
      private var _mipMapping:Boolean;
      
      private var _optimizeForRenderToTexture:Boolean = false;
      
      private var _premultipliedAlpha:Boolean;
      
      private var _forcePotTexture:Boolean;
      
      private var _onReady:Function = null;
      
      public function TextureOptions(param1:Number = 1, param2:Boolean = false, param3:String = "bgra", param4:Boolean = true, param5:Boolean = false)
      {
         super();
         _scale = param1;
         _format = param3;
         _mipMapping = param2;
         _forcePotTexture = param5;
         _premultipliedAlpha = param4;
      }
      
      public function clone() : TextureOptions
      {
         var _loc1_:TextureOptions = new TextureOptions(_scale,_mipMapping,_format);
         _loc1_._optimizeForRenderToTexture = _optimizeForRenderToTexture;
         _loc1_._premultipliedAlpha = _premultipliedAlpha;
         _loc1_._forcePotTexture = _forcePotTexture;
         _loc1_._onReady = _onReady;
         return _loc1_;
      }
      
      public function get scale() : Number
      {
         return _scale;
      }
      
      public function set scale(param1:Number) : void
      {
         _scale = param1 > 0 ? param1 : Starling.contentScaleFactor;
      }
      
      public function get format() : String
      {
         return _format;
      }
      
      public function set format(param1:String) : void
      {
         _format = param1;
      }
      
      public function get mipMapping() : Boolean
      {
         return _mipMapping;
      }
      
      public function set mipMapping(param1:Boolean) : void
      {
         _mipMapping = param1;
      }
      
      public function get optimizeForRenderToTexture() : Boolean
      {
         return _optimizeForRenderToTexture;
      }
      
      public function set optimizeForRenderToTexture(param1:Boolean) : void
      {
         _optimizeForRenderToTexture = param1;
      }
      
      public function get forcePotTexture() : Boolean
      {
         return _forcePotTexture;
      }
      
      public function set forcePotTexture(param1:Boolean) : void
      {
         _forcePotTexture = param1;
      }
      
      public function get onReady() : Function
      {
         return _onReady;
      }
      
      public function set onReady(param1:Function) : void
      {
         _onReady = param1;
      }
      
      public function get premultipliedAlpha() : Boolean
      {
         return _premultipliedAlpha;
      }
      
      public function set premultipliedAlpha(param1:Boolean) : void
      {
         _premultipliedAlpha = param1;
      }
   }
}
