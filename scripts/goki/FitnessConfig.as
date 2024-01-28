package goki
{
   public class FitnessConfig extends Config
   {
      
      private static const _filePath:String = "FitnessConfig.txt";
      
      public static var values:Object = {
         "fitness":"120",
         "lines":"0",
         "strength":"40",
         "healthAdd":"0.6",
         "healthMulti":"1.6",
         "armorAdd":"0.85",
         "armorMulti":"1.0",
         "corrosiveAdd":"1.1",
         "corrosiveMulti":"1.25",
         "energyAdd":"0.9",
         "energyMulti":"1.25",
         "kineticAdd":"0.9",
         "kineticMulti":"1.2",
         "shieldAdd":"0.5",
         "shieldMulti":"1.5",
         "shieldRegen":"0.8",
         "corrosiveResist":"0.85",
         "energyResist":"0.85",
         "kineticResist":"0.85",
         "allResist":"1.1",
         "allAdd":"0.9",
         "allMulti":"1.35",
         "speed":"2.2",
         "refire":"1.36",
         "convHp":"0.85",
         "convShield":"0.85",
         "powerReg":"0.6",
         "powerMax":"1.0",
         "cooldown":"1.0"
      };
       
      
      public function FitnessConfig()
      {
         super();
      }
      
      public static function saveConfig() : void
      {
         save(_filePath,values);
      }
      
      public static function loadConfig() : void
      {
         load(_filePath,values);
      }
   }
}
