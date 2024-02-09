package core.artifact
{
   import generics.Localize;
   import goki.FitnessConfig;
   import core.hud.components.chat.MessageLog;
   
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
         modifier += param1.indexOf("2") != -1 && param1 != "refier2" ? " (s)" : "";
         modifier += param1.indexOf("3") != -1 ? " (e)" : "";
         switch(param1)
         {
            case "healthAdd":
            case "healthAdd2":
            case "healthAdd3":
               return _loc3_ + "+" + (2 * param2).toFixed(1) + _loc4_ + " " + Localize.t("health") + modifier;
            case "healthMulti":
               return _loc3_ + "+" + (1.35 * param2).toFixed(1) + "%" + _loc4_ + " " + Localize.t("health");
            case "armorAdd":
            case "armorAdd2":
            case "armorAdd3":
               return _loc3_ + "+" + (7.5 * param2).toFixed(1) + _loc4_ + " " + Localize.t("armor") + modifier;
            case "armorMulti":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " " + Localize.t("armor");
            case "corrosiveAdd":
            case "corrosiveAdd2":
            case "corrosiveAdd3":
               return _loc3_ + "+" + (4 * param2).toFixed(1) + _loc4_ + " " + Localize.t("corrosive dmg") + modifier;
            case "corrosiveMulti":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " " + Localize.t("corrosive dmg");
            case "energyAdd":
            case "energyAdd2":
            case "energyAdd3":
               return _loc3_ + "+" + (4 * param2).toFixed(1) + _loc4_ + " " + Localize.t("energy dmg") + modifier;
            case "energyMulti":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " " + Localize.t("energy dmg");
            case "kineticAdd":
            case "kineticAdd2":
            case "kineticAdd3":
               return _loc3_ + "+" + (4 * param2).toFixed(1) + _loc4_ + " " + Localize.t("kinetic dmg") + modifier;
            case "kineticMulti":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " " + Localize.t("kinetic dmg");
            case "shieldAdd":
            case "shieldAdd2":
            case "shieldAdd3":
               return _loc3_ + "+" + (1.75 * param2).toFixed(1) + _loc4_ + " " + Localize.t("shield") + modifier;
            case "shieldMulti":
               return _loc3_ + "+" + (1.35 * param2).toFixed(1) + "%" + _loc4_ + " " + Localize.t("shield");
            case "shieldRegen":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " " + Localize.t("shield regen");
            case "corrosiveResist":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " " + Localize.t("corrosive resist");
            case "energyResist":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " " + Localize.t("energy resist");
            case "kineticResist":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " " + Localize.t("kinetic resist");
            case "allResist":
               return _loc3_ + "+" + param2.toFixed(1) + "%" + _loc4_ + " " + Localize.t("all resist");
            case "allAdd":
            case "allAdd2":
            case "allAdd3":
               return _loc3_ + "+" + (1.5 * param2).toFixed(1) + _loc4_ + " " + Localize.t("to all dmg") + modifier;
            case "allMulti":
               return _loc3_ + "+" + (1.5 * param2).toFixed(1) + "%" + _loc4_ + " " + Localize.t("to all dmg");
            case "speed":
            case "speed2":
            case "speed3":
               return _loc3_ + "+" + (0.2 * param2).toFixed(2) + "%" + _loc4_ + " " + Localize.t("inc speed") + modifier;
            case "refire":
            case "refire2":
            case "refire3":
               return _loc3_ + "+" + (0.3 * param2).toFixed(1) + "%" + _loc4_ + " " + Localize.t("inc attack speed") + modifier;
            case "convHp":
               return _loc3_ + "-" + (0.1 * param2).toFixed(1) + "%" + _loc4_ + " " + Localize.t("hp to 150% shield");
            case "convShield":
               return _loc3_ + "-" + (0.1 * param2).toFixed(1) + "%" + _loc4_ + " " + Localize.t("shield to 150% hp");
            case "powerReg":
            case "powerReg2":
            case "powerReg3":
               return _loc3_ + "+" + (0.15 * param2).toFixed(1) + "%" + _loc4_ + " " + Localize.t("inc power regen") + modifier;
            case "powerMax":
               return _loc3_ + "+" + (1.5 * param2).toFixed(1) + "%" + _loc4_ + " " + Localize.t("inc maximum power");
            case "cooldown":
            case "cooldown2":
            case "cooldown3":
               return _loc3_ + "+" + (0.1 * param2).toFixed(1) + "%" + _loc4_ + " " + Localize.t("reduced cooldown") + modifier;
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
               return _loc3_ + (2 * param2).toFixed(0) + " " + Localize.t("health");
            case "healthMulti":
               return _loc3_ + (1.35 * param2).toFixed(1) + "% " + Localize.t("health");
            case "armorAdd":
            case "armorAdd2":
            case "armorAdd3":
               return _loc3_ + (7.5 * param2).toFixed(0) + " " + Localize.t("armor");
            case "armorMulti":
               return _loc3_ + param2.toFixed(1) + "% " + Localize.t("armor");
            case "corrosiveAdd":
            case "corrosiveAdd2":
            case "corrosiveAdd3":
               return _loc3_ + (4 * param2).toFixed(0) + " " + Localize.t("corrosive dmg");
            case "corrosiveMulti":
               return _loc3_ + param2.toFixed(1) + "% " + Localize.t("corrosive dmg");
            case "energyAdd":
            case "energyAdd2":
            case "energyAdd3":
               return _loc3_ + (4 * param2).toFixed(0) + " " + Localize.t("energy dmg");
            case "energyMulti":
               return _loc3_ + param2.toFixed(1) + "% " + Localize.t("energy dmg");
            case "kineticAdd":
            case "kineticAdd2":
            case "kineticAdd3":
               return _loc3_ + (4 * param2).toFixed(0) + " " + Localize.t("kinetic dmg");
            case "kineticMulti":
               return _loc3_ + param2.toFixed(1) + "% " + Localize.t("kinetic dmg");
            case "shieldAdd":
            case "shieldAdd2":
            case "shieldAdd3":
               return _loc3_ + (2 * param2).toFixed(0) + " " + Localize.t("shield");
            case "shieldMulti":
               return _loc3_ + (1.35 * param2).toFixed(1) + "% " + Localize.t("shield");
            case "shieldRegen":
               return _loc3_ + param2.toFixed(0) + "% " + Localize.t("shield regen");
            case "corrosiveResist":
               return _loc3_ + param2.toFixed(1) + "% " + Localize.t("corrosive resist");
            case "energyResist":
               return _loc3_ + param2.toFixed(1) + "% " + Localize.t("energy resist");
            case "kineticResist":
               return _loc3_ + param2.toFixed(1) + "% " + Localize.t("kinetic resist");
            case "allResist":
               return _loc3_ + param2.toFixed(1) + "% " + Localize.t("all resist");
            case "allAdd":
            case "allAdd2":
            case "allAdd3":
               return _loc3_ + (1.5 * param2).toFixed(1) + " " + Localize.t("to all dmg");
            case "allMulti":
               return _loc3_ + (1.35 * param2).toFixed(1) + "% " + Localize.t("to all dmg");
            case "speed":
            case "speed2":
            case "speed3":
               return _loc3_ + (0.1 * param2).toFixed(2) + "% " + Localize.t("speed");
            case "refire":
            case "refire2":
            case "refire3":
               return _loc3_ + (0.30000000000000004 * param2).toFixed(1) + "% " + Localize.t("attack speed");
            case "convHp":
               return _loc3_ + (0.1 * param2).toFixed(1) + "% " + Localize.t("hp to 150% shield");
            case "convShield":
               return _loc3_ + (0.1 * param2).toFixed(1) + "% " + Localize.t("shield to 150% hp");
            case "powerReg":
            case "powerReg2":
            case "powerReg3":
               return _loc3_ + (0.1 * (1 * param2)).toFixed(1) + "% " + Localize.t("power regen");
            case "powerMax":
               return _loc3_ + (1 * param2).toFixed(1) + "% " + Localize.t("max power");
            case "cooldown":
            case "cooldown2":
            case "cooldown3":
               return "-" + (0.1 * param2).toFixed(1) + "% " + Localize.t("cooldown");
            default:
               return "ERROR - artifact not found";
         }
      }

      public static function statDistribution(statType:String, statValue:Number, lines:int, lineNumber:int, str:int) : Number
      {
         return str - (statValue * FitnessConfig.statDistribution[statType][2] - FitnessConfig.statDistribution[statType][1] * FitnessConfig.lineDistribution[lines.toString()][lineNumber]) / FitnessConfig.statDistribution[statType][0] / FitnessConfig.lineDistribution[lines.toString()][lineNumber];
      }
      
      public function get statFitness() : Number
      {
         switch(this.type)
         {
            case "healthAdd":
            case "healthAdd2":
            case "healthAdd3":
               return 2 * 0.0022 * FitnessConfig.values.healthAdd * this.value;
            case "healthMulti":
               return 1.35 * 0.27 * FitnessConfig.values.healthMulti * this.value;
            case "armorAdd":
            case "armorAdd2":
            case "armorAdd3":
               return 7.5 * 0.025 * FitnessConfig.values.armorAdd * this.value;
            case "armorMulti":
               return 1 * 0.333 * FitnessConfig.values.armorMulti * this.value;
            case "corrosiveAdd":
            case "corrosiveAdd2":
            case "corrosiveAdd3":
               return 4 * 0.077 * FitnessConfig.values.corrosiveAdd * this.value;
            case "corrosiveMulti":
               return 1 * 0.6666 * FitnessConfig.values.corrosiveMulti * this.value;
            case "energyAdd":
            case "energyAdd2":
            case "energyAdd3":
               return 4 * 0.09 * FitnessConfig.values.energyAdd * this.value;
            case "energyMulti":
               return 1 * 0.6666 * FitnessConfig.values.energyMulti * this.value;
            case "kineticAdd":
            case "kineticAdd2":
            case "kineticAdd3":
               return 4 * 0.087 * FitnessConfig.values.kineticAdd * this.value;
            case "kineticMulti":
               return 1 * 0.6666 * FitnessConfig.values.kineticMulti * this.value;
            case "shieldAdd":
            case "shieldAdd2":
            case "shieldAdd3":
               return 1.75 * 0.0022 * FitnessConfig.values.shieldAdd * this.value;
            case "shieldMulti":
               return 1.35 * 0.27 * FitnessConfig.values.shieldMulti * this.value;
            case "shieldRegen":
               return 1 * 0.6 * FitnessConfig.values.shieldRegen * this.value;
            case "corrosiveResist":
               return 1 * 0.5 * FitnessConfig.values.corrosiveResist * this.value;
            case "kineticResist":
            case "energyResist":
               return 1 * 0.5 * FitnessConfig.values.kineticResist * this.value;
            case "allResist":
               return 1 * 1 * FitnessConfig.values.allResist * this.value;
            case "allAdd":
            case "allAdd2":
            case "allAdd3":
               return 1.6 * 0.166 * FitnessConfig.values.allAdd * this.value;
            case "allMulti":
               return 1.35 * 1.3 * FitnessConfig.values.allMulti * this.value;
            case "speed":
            case "speed2":
            case "speed3":
               return 0.1 * 4 * FitnessConfig.values.speed * this.value;
            case "refire":
            case "refire2":
            case "refire3":
               return 0.3 * 1.298 * FitnessConfig.values.refire * this.value;
            case "convHp":
            case "convShield":
               return 0.1 * 0.5 * FitnessConfig.values.convHp * this.value;
            case "powerReg":
            case "powerReg2":
            case "powerReg3":
               return 0.1 * 4 * FitnessConfig.values.powerReg * this.value;
            case "powerMax":
               return 1 * 0.3333 * FitnessConfig.values.powerMax * this.value;
            case "cooldown":
            case "cooldown2":
            case "cooldown3":
               return 0.1 * 6.666 * FitnessConfig.values.cooldown * this.value;
            default:
               return 0;
         }
      }
   }
}
