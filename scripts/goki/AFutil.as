package goki
{
   import core.scene.Game;
   import core.ship.Ship;
   import generics.Util;
   import core.hud.components.chat.MessageLog;
   
   public class AFutil
   {  
      public function AFutil()
      {
         super();
      }
      
      public static function distanceSquaredToShip(g:Game, target:Ship) : Number
      {
         return (g.me.ship.x - target.x) * (g.me.ship.x - target.x) + (g.me.ship.y - target.y) * (g.me.ship.y - target.y);
      }
      
      public static function directionToShip(g:Game, target:Ship) : Number
      {
         return Math.atan2(g.me.ship.y - target.y,g.me.ship.x - target.x);
      }
      
      public static function lookAtShip(g:Game, target:Ship) : void
      {
         if(Math.abs(Util.angleDifference(g.me.ship.course.rotation,directionToShip(g,target))) < 3)
         {
            if(Util.angleDifference(g.me.ship.course.rotation,directionToShip(g,target)) < 0)
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
      
      public static function accelerate(g:Game, active:Boolean) : void
      {
        if(g.me.ship.accelerate != active)
        {
            sendCommand(g,0,active);
        }
      }
      
      public static function deaccelerate(g:Game, active:Boolean) : void
      {
        if(g.me.ship.deaccelerate != active)
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
      
      public static function boost(g:Game) : void
      {
         g.commandManager.addHardenedShieldCommand();
      }
      
      private static function sendCommand(g:Game, command:int, active:Boolean) : void
      {
         g.commandManager.addCommand(command,active);
      }
   }
}
