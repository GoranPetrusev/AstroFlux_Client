package goki
{
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.events.Event;
    import flash.display.Bitmap;
    import starling.textures.Texture;
    import flash.display.Loader;
    import flash.utils.Dictionary;

    public class TextureLoader
    {
        public static var localTextures:Dictionary = new Dictionary();

        private static var currTextureName:String;
        
        public function TextureLoader()
        {
            super();
        }

        public static function loadTextureFromPath(path:String) : void
        {
            var ldr:Loader = new Loader();
            var ldrCont:LoaderContext = null;

            var str:Array = path.split("/");
            currTextureName = str[str.length - 1];

            ldr.contentLoaderInfo.addEventListener("complete",onLocalComplete);
            ldrCont = new LoaderContext(true);
            ldrCont.imageDecodingPolicy = "onLoad";
            ldr.load(new URLRequest(path),ldrCont);
        }

        private static function onLocalComplete(e:flash.events.Event) : void
        {
            var bm:Bitmap = e.target.content as Bitmap;
            var tx:Texture = Texture.fromBitmap(bm);
            localTextures[currTextureName] = tx;
        }
    }
}




