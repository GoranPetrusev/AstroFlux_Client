package goki
{
   public class Config
   {
       
      
      public function Config()
      {
         super();
      }
      
      protected static function saveConfig(dest:String, currentConfig:Object) : void
      {
         FileManager.saveToFile(dest,JSON.stringify(currentConfig));
      }
      
      protected static function loadConfig(dest:String, currentConfig:Object) : void
      {
         var data:String = FileManager.readFromFile(dest);
         if(data == "")
         {
            saveConfig(dest,currentConfig);
            return;
         }
         var localConfig:Object = JSON.parse(data);
         for(var key in currentConfig)
         {
            if(localConfig.hasOwnProperty(key))
            {
               currentConfig[key] = localConfig[key];
            }
         }
      }
   }
}
