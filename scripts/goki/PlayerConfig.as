package goki
{
   public class PlayerConfig
   {
      
      public static var values:Object = {
         "zoomFactor":"1.0",
         "zoomInKey":"75",
         "zoomOutKey":"74"
      };
       
      
      public function PlayerConfig()
      {
         super();
      }
      
      public static function saveConfig() : void
      {
         FileManager.saveToFile("PlayerConfig.txt",JSON.stringify(values));
      }
      
      public static function loadConfig() : void
      {
         values = JSON.parse(FileManager.readFromFile("PlayerConfig.txt"));
      }
   }
}
