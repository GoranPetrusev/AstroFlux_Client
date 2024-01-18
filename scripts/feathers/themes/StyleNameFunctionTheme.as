package feathers.themes
{
   import feathers.skins.StyleNameFunctionStyleProvider;
   import feathers.skins.StyleProviderRegistry;
   import starling.events.EventDispatcher;
   
   public class StyleNameFunctionTheme extends EventDispatcher
   {
       
      
      protected var _registry:StyleProviderRegistry;
      
      public function StyleNameFunctionTheme()
      {
         super();
         this.createRegistry();
      }
      
      public function dispose() : void
      {
         if(this._registry)
         {
            this._registry.dispose();
            this._registry = null;
         }
      }
      
      public function getStyleProviderForClass(param1:Class) : StyleNameFunctionStyleProvider
      {
         return StyleNameFunctionStyleProvider(this._registry.getStyleProvider(param1));
      }
      
      protected function createRegistry() : void
      {
         this._registry = new StyleProviderRegistry();
      }
   }
}
