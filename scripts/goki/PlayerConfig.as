package goki
{
   public class PlayerConfig extends Config
   {
      
      private static const _filePath:String = "PlayerConfig.txt";
      
      public static var values:Object = {
         "zoomFactor":"1.0",
         "zoomInKey":"75",
         "zoomOutKey":"74",
         "showAllEncounters":true,
         "dmgTextSize":"1.0",
         "barSize":"1.0",
         "barAlwaysShow":false
      };
       
      
      public function PlayerConfig()
      {
         super();
      }
      
      public static function saveConfig() : void
      {
         saveConfig(_filePath,values);
      }
      
      public static function loadConfig() : void
      {
         loadConfig(_filePath,values);
      }
   }
}
