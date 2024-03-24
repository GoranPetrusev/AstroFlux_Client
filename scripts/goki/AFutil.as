package goki
{
   import core.scene.Game;
   import core.ship.Ship;
   import core.ship.EnemyShip;
   import core.drops.Drop;
   import core.GameObject;
   import generics.Util;
   import core.hud.components.chat.MessageLog;
   
   public class AFutil
   {  
      private static var isRecycling:Boolean = false;

      public function AFutil()
      {
         super();
      }

      public static function isPickingUpDropInZone(g:Game, str:String, x:int, y:int, r:int) : Boolean
      {
         var target:GameObject = null;
         for each (var drop in g.dropManager.drops)
         {
            if(drop.name.indexOf(str) != -1)
            {
               target = drop;
               break;
            }
         }

         if(target == null && distanceSquaredToPoint(g, x, y) > r*r*1600)
         {
            return false;
         }

         if(Math.abs(angleDifferencePoint(g, target)) < 3.05)
         {
            if(angleDifferencePoint(g, target) < 0)
            {
               turnLeft(g,true);
               turnRight(g,false);
            }
            else
            {
               turnRight(g,true);
               turnLeft(g,false);
            }
            accelerate(g, false);
            deaccelerate(g, true);
         }
         else
         {
            turnLeft(g,false);
            turnRight(g,false);
            accelerate(g, true);
            deaccelerate(g, false);
         }

         return true;
      }

      public static function isPickingUpDrop(g:Game, str:String) : Boolean
      {
         var target:Drop = null;
         for each (var drop in g.dropManager.drops)
         {
            if(drop.name.indexOf(str) != -1)
            {
               target = drop;
               break;
            }
         }

         if(target == null)
         {
            return false;
         }

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
            accelerate(g, false);
            deaccelerate(g, true);
         }
         else
         {
            turnLeft(g,false);
            turnRight(g,false);
            accelerate(g, true);
            deaccelerate(g, false);
         }

         return true;
      }

      public static function closestEnemyByName(g:Game, name:String) : EnemyShip
      {
         var closestEnemy:EnemyShip = null;
         for each (var currEnemy in g.shipManager.enemies)
         {
            if(currEnemy.bodyName.indexOf(name) != -1 && AFutil.distanceSquaredToObject(g, currEnemy) < AFutil.distanceSquaredToObject(g, closestEnemy))
            {
               closestEnemy = currEnemy;
            }
         }
         return closestEnemy;
      }

      public static function lookAtPoint(g:Game, x:int, y:int) : void
      {
         if(g.me.ship.usingBoost)
         {
            return;
         }

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
         if(g.me.ship.usingBoost)
         {
            return;
         }

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
         return (g.me.ship.x - x*40) * (g.me.ship.x - x*40) + (g.me.ship.y - y*40) * (g.me.ship.y - y*40);
      }
      
      public static function directionToPoint(g:Game, x:int, y:int) : Number
      {
         return Math.atan2(g.me.ship.y - y*40, g.me.ship.x - x*40);
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
        if(g.me.ship.course.accelerate != active)
        {
            sendCommand(g,0,active);
        }
      }
      
      public static function deaccelerate(g:Game, active:Boolean) : void
      {
        if(g.me.ship.course.deaccelerate != active)
        {
            sendCommand(g,8,active);
        }
      }
      
      public static function turnLeft(g:Game, active:Boolean) : void
      {
        if(g.me.ship.course.rotateLeft != active)
        {
            sendCommand(g,1,active);
        }
      }
      
      public static function turnRight(g:Game, active:Boolean) : void
      {
        if(g.me.ship.course.rotateRight != active)
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
