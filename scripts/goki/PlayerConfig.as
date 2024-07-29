package goki
{
   public class PlayerConfig extends Config
   {
      
      private static const _filePath:String = "PlayerConfig.txt";

      public static var autorec:Boolean = false;
      
      public static var values:Object = {
         "zoomFactor":"1.0",
         "zoomInKey":"75",
         "zoomOutKey":"74",
         "showAllEncounters":true,
         "dmgTextSize":"1.0",
         "barSize":"1.0",
         "barAlwaysShow":false,
         "maxChatMessages":"100",
         "censorChat":false,
         "dontKick":false,
         "disableScreenShake":true,
         "autoReload":false
      };

      public static var setupNames:Object = {};
       
      
      public function PlayerConfig()
      {
         super();
      }
      
      public static function saveConfig() : void
      {
         save(_filePath,values);
         save("SetupNames.txt",setupNames);
      }
      
      public static function loadConfig() : void
      {
         load(_filePath,values);
         load("SetupNames.txt",setupNames);
      }
   }
}
