package core.artifact
{
   import goki.FitnessConfig;
   
   public class ArtifactStat
   {
       
      
      public var type:String;
      
      public var value:Number;
      
      public function ArtifactStat(param1:String, param2:Number)
      {
         super();
         this.type = param1;
         this.value = param2;
      }
      
      public static function parseTextFromStatType(param1:String, param2:Number) : String
      {
         var _loc3_:String = "<FONT COLOR=\'#ffffff\'>";
         var _loc4_:String = "</FONT>";
         var modifier:String = param1 == "refire" ? " (s)" : "";
         modifier += param1.indexOf("2") != -1 && param1 != "refire2" ? " (s)" : "";
         modifier += param1.indexOf("3") != -1 ? " (e)" : "";
         switch(param1)
         {
            case "healthAdd":
            case "healthAdd2":
            case "healthAdd3":
               return _loc3_ + "+" + (2 * param2).toFixed(1) + _loc4_ + " health" + modifier;
            case "healthMulti":
               return _loc3_ + "+" + (1.35 * param2).toFixed(1) + "%" + _loc4_ + " health";
            case "armorAdd":
            case "armorAdd2":
            case "armorAdd3":
               return _loc3_ + "+" + (7.5 * param2).toFixed(1) + _loc4_ + " armor" + modifier;
            case "armorMulti":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " armor";
            case "corrosiveAdd":
            case "corrosiveAdd2":
            case "corrosiveAdd3":
               return _loc3_ + "+" + (4 * param2).toFixed(1) + _loc4_ + " corrosive dmg" + modifier;
            case "corrosiveMulti":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " corrosive dmg";
            case "energyAdd":
            case "energyAdd2":
            case "energyAdd3":
               return _loc3_ + "+" + (4 * param2).toFixed(1) + _loc4_ + " energy dmg" + modifier;
            case "energyMulti":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " energy dmg";
            case "kineticAdd":
            case "kineticAdd2":
            case "kineticAdd3":
               return _loc3_ + "+" + (4 * param2).toFixed(1) + _loc4_ + " kinetic dmg" + modifier;
            case "kineticMulti":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " kinetic dmg";
            case "shieldAdd":
            case "shieldAdd2":
            case "shieldAdd3":
               return _loc3_ + "+" + (1.75 * param2).toFixed(1) + _loc4_ + " shield" + modifier;
            case "shieldMulti":
               return _loc3_ + "+" + (1.35 * param2).toFixed(1) + "%" + _loc4_ + " shield";
            case "shieldRegen":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " shield regen";
            case "corrosiveResist":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " corrosive resist";
            case "energyResist":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " energy resist";
            case "kineticResist":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " kinetic resist";
            case "allResist":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " all resist";
            case "allAdd":
            case "allAdd2":
            case "allAdd3":
               return _loc3_ + "+" + (1.5 * param2).toFixed(1) + _loc4_ + " to all dmg" + modifier;
            case "allMulti":
               return _loc3_ + "+" + (1.5 * param2).toFixed(1) + "%" + _loc4_ + " to all dmg";
            case "speed":
            case "speed2":
            case "speed3":
               return _loc3_ + "+" + (0.2 * param2).toFixed(2) + "%" + _loc4_ + " inc speed" + modifier;
            case "refire":
            case "refire2":
            case "refire3":
               return _loc3_ + "+" + (0.3 * param2).toFixed(1) + "%" + _loc4_ + " inc attack speed" + modifier;
            case "convHp":
               return _loc3_ + "-" + (0.1 * param2).toFixed(1) + "%" + _loc4_ + " hp to 150% shield";
            case "convShield":
               return _loc3_ + "-" + (0.1 * param2).toFixed(1) + "%" + _loc4_ + " shield to 150% hp";
            case "powerReg":
            case "powerReg2":
            case "powerReg3":
               return _loc3_ + "+" + (0.15 * param2).toFixed(1) + "%" + _loc4_ + " inc power regen" + modifier;
            case "powerMax":
               return _loc3_ + "+" + (1.5 * param2).toFixed(1) + "%" + _loc4_ + " inc maximum power";
            case "cooldown":
            case "cooldown2":
            case "cooldown3":
               return _loc3_ + "+" + (0.1 * param2).toFixed(1) + "%" + _loc4_ + " reduced cooldown" + modifier;
            default:
               return "undefined";
         }
      }
      
      public static function parseTextFromStatTypeShort(param1:String, param2:Number) : String
      {
         var _loc3_:String = param2 < 0 ? "" : "+";
         switch(param1)
         {
            case "healthAdd":
            case "healthAdd2":
            case "healthAdd3":
               return _loc3_ + (2 * param2).toFixed(0) + " health";
            case "healthMulti":
               return _loc3_ + (1.35 * param2).toFixed(1) + "% health";
            case "armorAdd":
            case "armorAdd2":
            case "armorAdd3":
               return _loc3_ + (7.5 * param2).toFixed(0) + " armor";
            case "armorMulti":
               return _loc3_ + param2.toFixed(1) + "% armor";
            case "corrosiveAdd":
            case "corrosiveAdd2":
            case "corrosiveAdd3":
               return _loc3_ + (4 * param2).toFixed(0) + " corrosive dmg";
            case "corrosiveMulti":
               return _loc3_ + param2.toFixed(1) + "% corrosive dmg";
            case "energyAdd":
            case "energyAdd2":
            case "energyAdd3":
               return _loc3_ + (4 * param2).toFixed(0) + " energy dmg";
            case "energyMulti":
               return _loc3_ + param2.toFixed(1) + "% energy dmg";
            case "kineticAdd":
            case "kineticAdd2":
            case "kineticAdd3":
               return _loc3_ + (4 * param2).toFixed(0) + " kinetic dmg";
            case "kineticMulti":
               return _loc3_ + param2.toFixed(1) + "% kinetic dmg";
            case "shieldAdd":
            case "shieldAdd2":
            case "shieldAdd3":
               return _loc3_ + (2 * param2).toFixed(0) + " shield";
            case "shieldMulti":
               return _loc3_ + (1.35 * param2).toFixed(1) + "% shield";
            case "shieldRegen":
               return _loc3_ + param2.toFixed(0) + "% shield regen";
            case "corrosiveResist":
               return _loc3_ + param2.toFixed(1) + "% corrosive resist";
            case "energyResist":
               return _loc3_ + param2.toFixed(1) + "% energy resist";
            case "kineticResist":
               return _loc3_ + param2.toFixed(1) + "% kinetic resist";
            case "allResist":
               return _loc3_ + param2.toFixed(1) + "% all resist";
            case "allAdd":
            case "allAdd2":
            case "allAdd3":
               return _loc3_ + (1.5 * param2).toFixed(1) + " to all dmg";
            case "allMulti":
               return _loc3_ + (1.35 * param2).toFixed(1) + "% to all dmg";
            case "speed":
            case "speed2":
            case "speed3":
               return _loc3_ + (0.1 * param2).toFixed(2) + "% speed";
            case "refire":
            case "refire2":
            case "refire3":
               return _loc3_ + (0.30000000000000004 * param2).toFixed(1) + "% attack speed";
            case "convHp":
               return _loc3_ + (0.1 * param2).toFixed(1) + "% hp to 150% shield";
            case "convShield":
               return _loc3_ + (0.1 * param2).toFixed(1) + "% shield to 150% hp";
            case "powerReg":
            case "powerReg2":
            case "powerReg3":
               return _loc3_ + (0.1 * (1 * param2)).toFixed(1) + "% power regen";
            case "powerMax":
               return _loc3_ + (1 * param2).toFixed(1) + "% max power";
            case "cooldown":
            case "cooldown2":
            case "cooldown3":
               return "-" + (0.1 * param2).toFixed(1) + "% cooldown";
            default:
               return "ERROR - artifact not found";
         }
      }
      
      public static function statDistribution(statType:String, statValue:Number, lines:int, lineNumber:int, str:int) : Number
      {
         return (statValue * FitnessConfig.statDistribution[statType][2] - FitnessConfig.statDistribution[statType][1] * FitnessConfig.lineDistribution[lines.toString()][lineNumber]) / FitnessConfig.statDistribution[statType][0] / FitnessConfig.lineDistribution[lines.toString()][lineNumber] - str;
      }
      
      public function get statFitness() : Number
      {
         switch(this.type)
         {
            case "healthAdd":
            case "healthAdd2":
            case "healthAdd3":
               return FitnessConfig.values.healthAdd < 0 ? FitnessConfig.values.healthAdd : 0.0044 * FitnessConfig.values.healthAdd * this.value;
            case "healthMulti":
               return FitnessConfig.values.healthMulti < 0 ? FitnessConfig.values.healthMulti : 0.3645 * FitnessConfig.values.healthMulti * this.value;
            case "armorAdd":
            case "armorAdd2":
            case "armorAdd3":
               return FitnessConfig.values.armorAdd < 0 ? FitnessConfig.values.armorAdd : 0.1875 * FitnessConfig.values.armorAdd * this.value;
            case "armorMulti":
               return FitnessConfig.values.armorMulti < 0 ? FitnessConfig.values.armorMulti : 0.333 * FitnessConfig.values.armorMulti * this.value;
            case "corrosiveAdd":
            case "corrosiveAdd2":
            case "corrosiveAdd3":
               return FitnessConfig.values.corrosiveAdd < 0 ? FitnessConfig.values.corrosiveAdd : 0.3 * FitnessConfig.values.corrosiveAdd * this.value;
            case "corrosiveMulti":
               return FitnessConfig.values.corrosiveMulti < 0 ? FitnessConfig.values.corrosiveMulti : 0.6666 * FitnessConfig.values.corrosiveMulti * this.value;
            case "energyAdd":
            case "energyAdd2":
            case "energyAdd3":
               return FitnessConfig.values.energyAdd < 0 ? FitnessConfig.values.energyAdd : 0.36 * FitnessConfig.values.energyAdd * this.value;
            case "energyMulti":
               return FitnessConfig.values.energyMulti < 0 ? FitnessConfig.values.energyMulti : 0.6666 * FitnessConfig.values.energyMulti * this.value;
            case "kineticAdd":
            case "kineticAdd2":
            case "kineticAdd3":
               return FitnessConfig.values.kineticAdd < 0 ? FitnessConfig.values.kineticAdd : 0.35 * FitnessConfig.values.kineticAdd * this.value;
            case "kineticMulti":
               return FitnessConfig.values.kineticMulti < 0 ? FitnessConfig.values.kineticMulti : 0.6666 * FitnessConfig.values.kineticMulti * this.value;
            case "shieldAdd":
            case "shieldAdd2":
            case "shieldAdd3":
               return FitnessConfig.values.shieldAdd < 0 ? FitnessConfig.values.shieldAdd : 0.00385 * FitnessConfig.values.shieldAdd * this.value;
            case "shieldMulti":
               return FitnessConfig.values.shieldMulti < 0 ? FitnessConfig.values.shieldMulti : 0.3645 * FitnessConfig.values.shieldMulti * this.value;
            case "shieldRegen":
               return FitnessConfig.values.shieldRegen < 0 ? FitnessConfig.values.shieldRegen : 0.6 * FitnessConfig.values.shieldRegen * this.value;
            case "corrosiveResist":
               return FitnessConfig.values.corrosiveResist < 0 ? FitnessConfig.values.corrosiveResist : 0.5 * FitnessConfig.values.corrosiveResist * this.value;
            case "kineticResist":
               return FitnessConfig.values.kineticResist < 0 ? FitnessConfig.values.kineticResist : 0.5 * FitnessConfig.values.kineticResist * this.value;
            case "energyResist":
               return FitnessConfig.values.energyResist < 0 ? FitnessConfig.values.energyResist : 0.5 * FitnessConfig.values.energyResist * this.value;
            case "allResist":
               return FitnessConfig.values.allResist < 0 ? FitnessConfig.values.allResist : FitnessConfig.values.allResist * this.value;
            case "allAdd":
            case "allAdd2":
            case "allAdd3":
               return FitnessConfig.values.allAdd < 0 ? FitnessConfig.values.allAdd : 0.2656 * FitnessConfig.values.allAdd * this.value;
            case "allMulti":
               return FitnessConfig.values.allMulti < 0 ? FitnessConfig.values.allMulti : 1.755 * FitnessConfig.values.allMulti * this.value;
            case "speed":
            case "speed2":
            case "speed3":
               return FitnessConfig.values.speed < 0 ? FitnessConfig.values.speed : 0.4 * FitnessConfig.values.speed * this.value;
            case "refire":
            case "refire2":
            case "refire3":
               return FitnessConfig.values.refire < 0 ? FitnessConfig.values.refire : 0.39 * FitnessConfig.values.refire * this.value;
            case "convHp":
               return FitnessConfig.values.convHp < 0 ? FitnessConfig.values.convHp : 0.05 * FitnessConfig.values.convHp * clamp(this.value,0,990);
            case "convShield":
               return FitnessConfig.values.convShield < 0 ? FitnessConfig.values.convShield : 0.05 * FitnessConfig.values.convShield * clamp(this.value,0,990);
            case "powerReg":
            case "powerReg2":
            case "powerReg3":
               return FitnessConfig.values.powerReg < 0 ? FitnessConfig.values.powerReg : 0.4 * FitnessConfig.values.powerReg * this.value;
            case "powerMax":
               return FitnessConfig.values.powerMax < 0 ? FitnessConfig.values.powerMax : 0.3333 * FitnessConfig.values.powerMax * this.value;
            case "cooldown":
            case "cooldown2":
            case "cooldown3":
               return FitnessConfig.values.cooldown < 0 ? FitnessConfig.values.cooldown : 0.6666 * FitnessConfig.values.cooldown * this.value;
            default:
               return 0;
         }
      }
      
      private function clamp(val:Number, min:Number, max:Number) : Number
      {
         return Math.max(Math.min(val,max),min);
      }
   }
}
