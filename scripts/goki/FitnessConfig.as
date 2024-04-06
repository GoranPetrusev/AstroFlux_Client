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
      
      public static var statDistribution:Object = {
         "allMulti":[0.57,2.25,1.35],
         "allResist":[0.74,3,1],
         "armorMulti":[2.8,21,1],
         "cooldown":[0.1,-1.5,0.1],
         "cooldown3":[0.06666666667,5.7,0.1],
         "cooldown2":[0.06666666667,3.666666667,0.1],
         "corrosiveMulti":[0.92,4.5,1],
         "corrosiveResist":[1.1,5.5,1],
         "energyMulti":[0.9,5.5,1],
         "energyResist":[1.1,5.5,1],
         "healthMulti":[1.888888889,8,1.35],
         "convHp":[2,-25,0.1],
         "kineticMulti":[0.9,5.5,1],
         "kineticResist":[1.1,5.5,1],
         "powerMax":[2,-24,1],
         "powerReg":[0.15,-2.15,0.1],
         "powerReg3":[0.15,6,0.1],
         "powerReg2":[0.15,3,0.1],
         "refire2":[0.4,-5,0.30000000000000004],
         "refire3":[0.5,20,0.30000000000000004],
         "refire":[0.5,5,0.30000000000000004],
         "shieldMulti":[1.888888889,8,1.35],
         "shieldRegen":[1.7,16,1],
         "convShield":[2,-23.5,0.1],
         "speed":[0.2,-0.25,0.2],
         "speed3":[0.2,4,0.2],
         "speed2":[0.2,0,0.2],
         "allAdd":[0.72,2,1.5],
         "allAdd3":[5,-66,1.5],
         "allAdd2":[3.5,-70,1.5],
         "armorAdd":[11.85,15.5,7.5],
         "armorAdd3":[47.5,-420,7.5],
         "armorAdd2":[30,-110,7.5],
         "corrosiveAdd":[2.72,5.333333333,4],
         "corrosiveAdd3":[14,-275,4],
         "corrosiveAdd2":[9.333333333,-185,4],
         "energyAdd":[2.4,21,4],
         "energyAdd3":[14,-265,4],
         "energyAdd2":[9.333333333,-185,4],
         "healthAdd":[98,160,2],
         "healthAdd3":[186.6666667,3800,2],
         "healthAdd2":[133.3333333,1475,2],
         "kineticAdd":[2.72,5.3,4],
         "kineticAdd3":[14,-277.77777778,4],
         "kineticAdd2":[9.333333333,-180,4],
         "shieldAdd":[139.125,100,2],
         "shieldAdd3":[350,4750,2],
         "shieldAdd2":[233.3333333,2333.333,2]
      };
      
      public static var lineDistribution:Object = {
         "1":[1,0,0,0,0],
         "2":[0.75,0.5,0,0,0],
         "3":[0.7,0.45,0.35,0,0],
         "4":[0.68,0.42,0.32,0.28,0],
         "5":[0.6,0.4,0.3,0.25,0.2]
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
