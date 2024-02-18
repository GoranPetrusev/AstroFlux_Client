package core.states.menuStates
{
   import core.hud.components.Button;
   import core.hud.components.InputText;
   import core.hud.components.Line;
   import core.hud.components.Text;
   import core.scene.Game;
   import core.states.DisplayState;
   import goki.FitnessConfig;
   import starling.display.Quad;
   import starling.events.TouchEvent;
   
   public class FitnessState extends DisplayState
   {
       
      
      private var g:Game;
      
      private var fitness:InputText;
      
      private var strength:InputText;
      
      private var lines:InputText;
      
      private var healthAdd:InputText;
      
      private var healthMulti:InputText;
      
      private var armorAdd:InputText;
      
      private var armorMulti:InputText;
      
      private var corrosiveAdd:InputText;
      
      private var corrosiveMulti:InputText;
      
      private var energyAdd:InputText;
      
      private var energyMulti:InputText;
      
      private var kineticAdd:InputText;
      
      private var kineticMulti:InputText;
      
      private var shieldAdd:InputText;
      
      private var shieldMulti:InputText;
      
      private var shieldRegen:InputText;
      
      private var corrosiveResist:InputText;
      
      private var energyResist:InputText;
      
      private var kineticResist:InputText;
      
      private var allResist:InputText;
      
      private var allAdd:InputText;
      
      private var allMulti:InputText;
      
      private var speed:InputText;
      
      private var refire:InputText;
      
      private var convHp:InputText;
      
      private var convShield:InputText;
      
      private var powerReg:InputText;
      
      private var powerMax:InputText;
      
      private var cooldown:InputText;
      
      private var currentX:int = 300;
      
      private var currentY:int = 50;
      
      private var saveButton:Button;
      
      public function FitnessState(param1:Game)
      {
         g = param1;
         super(param1,HomeState);
         fitness = new InputText(0,0,0,0);
         strength = new InputText(0,0,0,0);
         lines = new InputText(0,0,0,0);
         healthAdd = new InputText(0,0,0,0);
         healthMulti = new InputText(0,0,0,0);
         armorAdd = new InputText(0,0,0,0);
         armorMulti = new InputText(0,0,0,0);
         corrosiveAdd = new InputText(0,0,0,0);
         corrosiveMulti = new InputText(0,0,0,0);
         energyAdd = new InputText(0,0,0,0);
         energyMulti = new InputText(0,0,0,0);
         kineticAdd = new InputText(0,0,0,0);
         kineticMulti = new InputText(0,0,0,0);
         shieldAdd = new InputText(0,0,0,0);
         shieldMulti = new InputText(0,0,0,0);
         shieldRegen = new InputText(0,0,0,0);
         corrosiveResist = new InputText(0,0,0,0);
         energyResist = new InputText(0,0,0,0);
         kineticResist = new InputText(0,0,0,0);
         allResist = new InputText(0,0,0,0);
         allAdd = new InputText(0,0,0,0);
         allMulti = new InputText(0,0,0,0);
         speed = new InputText(0,0,0,0);
         refire = new InputText(0,0,0,0);
         convHp = new InputText(0,0,0,0);
         convShield = new InputText(0,0,0,0);
         powerReg = new InputText(0,0,0,0);
         powerMax = new InputText(0,0,0,0);
         cooldown = new InputText(0,0,0,0);
      }
      
      override public function enter() : void
      {
         super.enter();
         currentX = 52;
         currentY = 90;
         addHeader("Purify Values",17,220);
         addPurifyValue("Minimum Fitness",fitness,"fitness",3,"0-9");
         addPurifyValue("Minimum Strength",strength,"strength",3,"0-9");
         addPurifyValue("Minimum Lines",lines,"lines",3,"0-5");
         currentY += 15;
         var smallHeader:Text = new Text(currentX - 8,currentY);
         smallHeader.text = "How does it work?";
         smallHeader.size = 17;
         smallHeader.color = 16777215;
         smallHeader.width = 220;
         addChild(smallHeader);
         currentY += 30;
         var description:Text = new Text(currentX,currentY,true,"Verdana");
         description.color = 16777215;
         description.size = 10;
         description.width = 223;
         description.htmlText = "Don\'t worry, it\'s quite simple and it only works on <FONT COLOR=\'#fea943\'>unrevealed arts</FONT>. You see those 3 numbers above? Think of them as the minimum requirements for an art to pass. The fitness and strength of the art <FONT COLOR=\'#fea943\'>BOTH</FONT> need to be <FONT COLOR=\'#fea943\'>at least</FONT> the same as the numbers above for it to not be recycled. The lines are a bit different. It will recycle anything <FONT COLOR=\'#fea943\'>up to</FONT> the number, including it. Say if you put 1, then all one liners will be recycled. If you put a 0 <FONT COLOR=\'#fea943\'>anywhere</FONT>, it will ignore that stat.";
         addChild(description);
         currentX = 300;
         currentY = 45;
         var divider:Line = new Line();
         divider.x = currentX - 12;
         divider.y = currentY - 2;
         divider.lineTo(divider.x,currentY + 500);
         divider.thickness = 3;
         divider.color = 3684408;
         addChild(divider);
         addHeader("FitnessWeights",20,386);
         addFitnessWeight("Health Add",healthAdd,"healthAdd");
         addFitnessWeight("Health Multi",healthMulti,"healthMulti");
         addFitnessWeight("Armor Add",armorAdd,"armorAdd");
         addFitnessWeight("Armor Multi",armorMulti,"armorMulti");
         addFitnessWeight("Corrosive Add",corrosiveAdd,"corrosiveAdd");
         addFitnessWeight("Corrosive Multi",corrosiveMulti,"corrosiveMulti");
         addFitnessWeight("Energy Add",energyAdd,"energyAdd");
         addFitnessWeight("Energy Multi",energyMulti,"energyMulti");
         addFitnessWeight("Kinetic Add",kineticAdd,"kineticAdd");
         addFitnessWeight("Kinetic Multi",kineticMulti,"kineticMulti");
         addFitnessWeight("Shield Add",shieldAdd,"shieldAdd");
         addFitnessWeight("Shield Multi",shieldMulti,"shieldMulti");
         addFitnessWeight("Shield Regen",shieldRegen,"shieldRegen");
         currentX = 501;
         currentY = 85;
         addFitnessWeight("Corrosive Resist",corrosiveResist,"corrosiveResist");
         addFitnessWeight("Energy Resist",energyResist,"energyResist");
         addFitnessWeight("Kinetic Resist",kineticResist,"kineticResist");
         addFitnessWeight("All Resist",allResist,"allResist");
         addFitnessWeight("All Add",allAdd,"allAdd");
         addFitnessWeight("All Multi",allMulti,"allMulti");
         addFitnessWeight("Speed",speed,"speed");
         addFitnessWeight("Refire",refire,"refire");
         addFitnessWeight("Health to Shield",convHp,"convHp");
         addFitnessWeight("Shield to Health",convShield,"convShield");
         addFitnessWeight("Power Reg",powerReg,"powerReg");
         addFitnessWeight("Power Max",powerMax,"powerMax");
         addFitnessWeight("Cooldown",cooldown,"cooldown");
         saveButton = new Button(save,"Save","positive");
         saveButton.y = backButton.y;
         saveButton.x = backButton.x + backButton.width + 12;
         saveButton.width = 155;
         addChild(saveButton);
      }
      
      private function addFitnessWeight(str:String, field:InputText, property:String) : void
      {
         var desc:Text = new Text(currentX,currentY + 2);
         desc.text = str;
         desc.size = 13;
         desc.color = 9539985;
         field.x = currentX + 130;
         field.y = currentY;
         field.restrict = "-9-9";
         field.width = 45;
         field.height = 16;
         field.maxChars = 5;
         field.text = FitnessConfig.values[property];
         addFieldRim(field);
         addChild(desc);
         addChild(field);
         currentY += 35;
      }
      
      private function addPurifyValue(str:String, field:InputText, property:String, m:int, r:String) : void
      {
         var desc:Text = new Text(currentX,currentY + 2);
         desc.text = str;
         desc.size = 15;
         desc.color = 14408667;
         field.x = currentX + 170;
         field.y = currentY;
         field.width = 40;
         field.height = 20;
         field.restrict = r;
         field.maxChars = m;
         field.text = FitnessConfig.values[property];
         addFieldRim(field);
         addChild(desc);
         addChild(field);
         currentY += 35;
      }
      
      private function addFieldRim(field:InputText) : void
      {
         var topFill:Quad = new Quad(field.width + 2,field.height * 0.5 + 1,13948116);
         var botFill:Quad = new Quad(field.width + 2,field.height * 0.5 + 1,11053224);
         topFill.x = field.x - 1;
         topFill.y = field.y - 1;
         botFill.x = field.x - 1;
         botFill.y = field.y + field.height * 0.5;
         addChild(topFill);
         addChild(botFill);
      }
      
      private function addHeader(param1:String, txtSize:int, width:int) : void
      {
         var head:Text = new Text(currentX - 8,currentY);
         var line:Line = new Line();
         head.text = param1;
         head.size = txtSize;
         head.color = 16689475;
         line.x = head.x + head.width + 4;
         line.y = currentY + txtSize * 0.6;
         line.lineTo(currentX + width,currentY + txtSize * 0.6);
         line.thickness = 4;
         line.color = 7039851;
         addChild(head);
         addChild(line);
         currentY += 40;
      }
      
      override public function exit() : void
      {
         super.exit();
      }
      
      private function save(param1:TouchEvent = null) : void
      {
         FitnessConfig.values.fitness = fitness.text;
         FitnessConfig.values.strength = strength.text;
         FitnessConfig.values.lines = lines.text;
         FitnessConfig.values.healthAdd = healthAdd.text;
         FitnessConfig.values.healthMulti = healthMulti.text;
         FitnessConfig.values.armorAdd = armorAdd.text;
         FitnessConfig.values.armorMulti = armorMulti.text;
         FitnessConfig.values.corrosiveAdd = corrosiveAdd.text;
         FitnessConfig.values.corrosiveMulti = corrosiveMulti.text;
         FitnessConfig.values.energyAdd = energyAdd.text;
         FitnessConfig.values.energyMulti = energyMulti.text;
         FitnessConfig.values.kineticAdd = kineticAdd.text;
         FitnessConfig.values.kineticMulti = kineticMulti.text;
         FitnessConfig.values.shieldAdd = shieldAdd.text;
         FitnessConfig.values.shieldMulti = shieldMulti.text;
         FitnessConfig.values.shieldRegen = shieldRegen.text;
         FitnessConfig.values.corrosiveResist = corrosiveResist.text;
         FitnessConfig.values.energyResist = energyResist.text;
         FitnessConfig.values.kineticResist = kineticResist.text;
         FitnessConfig.values.allResist = allResist.text;
         FitnessConfig.values.allAdd = allAdd.text;
         FitnessConfig.values.allMulti = allMulti.text;
         FitnessConfig.values.speed = speed.text;
         FitnessConfig.values.refire = refire.text;
         FitnessConfig.values.convHp = convHp.text;
         FitnessConfig.values.convShield = convShield.text;
         FitnessConfig.values.powerReg = powerReg.text;
         FitnessConfig.values.powerMax = powerMax.text;
         FitnessConfig.values.cooldown = cooldown.text;
         FitnessConfig.saveConfig();
         saveButton.enabled = true;
      }
   }
}
