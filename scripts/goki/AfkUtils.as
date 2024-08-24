package goki
{
   import core.scene.Game;
   import core.ship.Ship;
   import core.ship.EnemyShip;
   import core.drops.Drop;
   import core.GameObject;
   import generics.Util;
   import core.hud.components.chat.MessageLog;
   
   public class AfkUtils
   {  
      public function AfkUtils()
      {
         super();
      }

      private static var lastTurnReset:Number = 0;

      public static function isPickingUpDropInZone(g:Game, name:String, x:int, y:int, r:int) : Boolean
      {
         var target:GameObject = findDropByName(g, name);

         if(target == null || distanceSquaredToPoint(g, x, y) > r*r*scale(g,1)*scale(g,1))
         {
            return false;
         }

         lookAtObject(g, target);
         accelerateNonOrbitToObject(g, target);

         return true;
      }

      public static function isPickingUpDrop(g:Game, name:String) : Boolean
      {
         var target:GameObject = findDropByName(g, name);

         if(target == null)
         {
            return false;
         }

         lookAtObject(g, target);
         accelerateNonOrbitToObject(g, target);

         return true;
      }

      public static function findDropByName(g:Game, name:String) : Drop
      {
         for each (var drop in g.dropManager.drops)
         {
            if(drop.name.indexOf(name) != -1)
            {
               return drop;
            }
         }

         return null;
      }

      public static function closestEnemyByName(g:Game, ...names) : EnemyShip
      {
         var closestEnemy:EnemyShip = g.shipManager.enemies[0];
         for each (var currEnemy in g.shipManager.enemies)
         {
            for each (var name in names)
            {
               if(currEnemy.name.indexOf(name) != -1 && distanceSquaredToObject(g, currEnemy) < distanceSquaredToObject(g, closestEnemy))
               {
                  closestEnemy = currEnemy;
               }
            }
         }

         return closestEnemy;
      }

      public static function lookAtPoint(g:Game, x:int, y:int) : void
      {
         if(Math.abs(angleDifferencePoint(g, x, y)) < 3.05)
         {
            if(angleDifferencePoint(g, x, y) < 0)
            {
               turnLeft(g,true);
               turnRight(g,false);
            }
            else
            {
               turnRight(g,true);
               turnLeft(g,false);
            }
         }
         else
         {
            turnLeft(g,false);
            turnRight(g,false);
         }
      }

      public static function lookAtObject(g:Game, target:GameObject) : void
      {
         if(Math.abs(angleDifferenceObject(g, target)) < 3.05)
         {
            if(angleDifferenceObject(g, target) < 0)
            {
               turnLeft(g,true);
               turnRight(g,false);
            }
            else
            {
               turnRight(g,true);
               turnLeft(g,false);
            }
         }
         else
         {
            turnLeft(g,false);
            turnRight(g,false);
         }
      }

      public static function accelerateNonOrbitToPoint(g:Game, x:int, y:int) : void
      {
         if(Math.abs(angleDifferencePoint(g, x, y)) < 3)
         {
            accelerate(g, false);
            deaccelerate(g, true);
         }
         else
         {
            accelerate(g, true);
            deaccelerate(g, false);
         }

      }

      public static function accelerateNonOrbitToObject(g:Game, target:GameObject) : void
      {
         if(Math.abs(angleDifferenceObject(g, target)) < 3)
         {
            accelerate(g, false);
            deaccelerate(g, true);
         }
         else
         {
            accelerate(g, true);
            deaccelerate(g, false);
         }
      }

      public static function scale(g:Game, value:Number) : Number 
      {
         switch (g.solarSystem.name) {
            case "Hyperion":
            case "Fulzar":
                  return value * 40;
            case "Venturi":
            case "Neurona":
            case "Cynapsian":
                  return value * 10;
            case "Kapello":
                  return value * 30;
            case "Durian":
                  return value * 44.44444444444444;
            case "Arrenius":
                  return value * 80;
            case "Kritillian":
                  return value * 69.44444444444444;
            case "Hozar":
                  return value * 35;
            case "Zergilin":
            case "Vorsran":
                  return value * 125;
            case "Mitrilion":
                  return value * 24;
            case "Vibrilian":
                  return value * 12;
            case "Sarkinon":
                  return value * 110;
         }
      }


      public static function distanceSquaredToObject(g:Game, target:GameObject) : Number
      {
         return (g.me.ship.x - target.x) * (g.me.ship.x - target.x) + (g.me.ship.y - target.y) * (g.me.ship.y - target.y);
      }
      
      public static function directionToObject(g:Game, target:GameObject) : Number
      {
         return Math.atan2(g.me.ship.y - target.y, g.me.ship.x - target.x);
      }

      public static function distanceSquaredToPoint(g:Game, x:int, y:int) : Number
      {
         return (g.me.ship.x - scale(g, x)) * (g.me.ship.x - scale(g, x)) + (g.me.ship.y - scale(g, y)) * (g.me.ship.y - scale(g, y));
      }
      
      public static function directionToPoint(g:Game, x:int, y:int) : Number
      {
         return Math.atan2(g.me.ship.y - scale(g, y), g.me.ship.x - scale(g, x));
      }

      public static function angleDifferenceObject(g:Game, target:GameObject) : Number
      {
         return Util.angleDifference(g.me.ship.course.rotation,directionToObject(g,target));
      }

      public static function angleDifferencePoint(g:Game, x:int, y:int) : Number
      {
         return Util.angleDifference(g.me.ship.course.rotation,directionToPoint(g,x,y));
      }

      // Commands
      
      public static function accelerate(g:Game, active:Boolean) : void
      {
         if(!g.me.ship.usingBoost && g.me.ship.course.accelerate != active)
         {
            sendCommand(g,0,active);
         }
      }
      
      public static function deaccelerate(g:Game, active:Boolean) : void
      {
         if(!g.me.ship.usingBoost && g.me.ship.course.deaccelerate != active)
         {
            sendCommand(g,8,active);
         }
      }
      
      public static function turnLeft(g:Game, active:Boolean) : void
      {
         if(g.time - lastTurnReset > 5000)
         {
            lastTurnReset = g.time;
            sendCommand(g,1,false);
            sendCommand(g,2,true);
            sendCommand(g,2,false);
            sendCommand(g,1,true);
         }
         if(!g.me.ship.usingBoost && g.me.ship.course.rotateLeft != active)
         {
            sendCommand(g,1,active);
         }
      }
      
      public static function turnRight(g:Game, active:Boolean) : void
      {
         if(g.time - lastTurnReset > 5000)
         {
            lastTurnReset = g.time;
            sendCommand(g,2,false);
            sendCommand(g,1,true);
            sendCommand(g,1,false);
            sendCommand(g,2,true);
         }
         if(!g.me.ship.usingBoost && g.me.ship.course.rotateRight != active)
         {
            sendCommand(g,2,active);
         }
      }
      
      public static function fire(g:Game, active:Boolean) : void
      {
         if(g.me.ship.isShooting != active)
         {
            sendCommand(g,3,active);
         }
      }
      
      public static function boost(g:Game) : void
      {
         g.commandManager.addBoostCommand();
      }
      
      public static function damageBoost(g:Game) : void
      {
         g.commandManager.addDmgBoostCommand();
      }
      
      public static function convertShield(g:Game) : void
      {
         g.commandManager.addShieldConvertCommand();
      }
      
      public static function hardenShield(g:Game) : void
      {
         g.commandManager.addHardenedShieldCommand();
      }
      
      private static function sendCommand(g:Game, command:int, active:Boolean) : void
      {
         g.commandManager.addCommand(command,active);
      }
   }
}
