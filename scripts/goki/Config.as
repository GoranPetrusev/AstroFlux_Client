package goki
{
   public class Config
   {
       
      
      public function Config()
      {
         super();
      }
      
      protected static function save(dest:String, currentConfig:Object) : void
      {
         FileManager.saveToFile(dest,JSON.stringify(currentConfig));
      }
      
      protected static function load(dest:String, currentConfig:Object) : void
      {
         var data:String = FileManager.readFromFile(dest);
         if(data == "")
         {
            save(dest,currentConfig);
            return;
         }
         var localConfig:Object = JSON.parse(data);
         for(var key in localConfig)
         {
            currentConfig[key] = localConfig[key];
         }
      }
   }
}
