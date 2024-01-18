package feathers.themes
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   public class AeonDesktopTheme extends BaseAeonDesktopTheme
   {
      
      protected static const ATLAS_BITMAP:Class = aeon_desktop_png$fd30ebecc9de4259548b3eff677a9615811270930;
      
      protected static const ATLAS_XML:Class = §aeon_desktop_xml$f4014733193163bd14d38c617b03e4b9-1128860857§;
      
      protected static const ATLAS_SCALE_FACTOR:int = 2;
       
      
      public function AeonDesktopTheme()
      {
         super();
         this.initialize();
      }
      
      override protected function initialize() : void
      {
         this.initializeTextureAtlas();
         super.initialize();
      }
      
      protected function initializeTextureAtlas() : void
      {
         var _loc1_:BitmapData = Bitmap(new ATLAS_BITMAP()).bitmapData;
         var _loc2_:Texture = Texture.fromBitmapData(_loc1_,false,false,2);
         _loc2_.root.onRestore = this.atlasTexture_onRestore;
         _loc1_.dispose();
         this.atlas = new TextureAtlas(_loc2_,XML(new ATLAS_XML()));
      }
      
      protected function atlasTexture_onRestore() : void
      {
         var _loc1_:BitmapData = Bitmap(new ATLAS_BITMAP()).bitmapData;
         this.atlas.texture.root.uploadBitmapData(_loc1_);
         _loc1_.dispose();
      }
   }
}
