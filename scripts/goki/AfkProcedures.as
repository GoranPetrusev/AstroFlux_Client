package goki
{
   import core.scene.Game;
   import core.ship.EnemyShip;
   import core.hud.components.chat.MessageLog;
   
   public class AfkProcedures
   {
      
      public static var functions:Object = {
         "buglegs":buglegs,
         "exe":exefarm,
         "mb":mbfarm,
         "icemoth":icemoth
      };
       
      
      public function AfkProcedures()
      {
         super();
      }
      
      public static function buglegs(g:Game) : void
      {
         if(AfkUtils.isPickingUpDrop(g,"Bug Leg"))
         {
            return;
         }
         var targetMoth:EnemyShip = AfkUtils.closestEnemyByName(g,"Moth Alpha");
         if(targetMoth != null)
         {
            if(AfkUtils.distanceSquaredToObject(g,targetMoth) > 1000 * 1000 && Math.abs(AfkUtils.angleDifferenceObject(g,targetMoth)) > 3)
            {
               AfkUtils.boost(g);
            }
            AfkUtils.lookAtObject(g,targetMoth);
         }
         AfkUtils.accelerate(g,true);
         AfkUtils.fire(g,true);
      }
      
      private static var lootingWindow:Number = 0;
      public static function exefarm(g:Game) : void
      {
         // Keep pushing the looting window forward by 50 seconds until the exe dies
         if(g.bossManager.bosses.length == 1)
         {
            lootingWindow = g.time + 50000;
         }

         // Until game time exceeds the looting window, pick up gold crates and arts
         if(g.time < lootingWindow)
         {
            if(AfkUtils.isPickingUpDropInZone(g,"Crate",-425,-100,75))
            {
               return;
            }
            if(AfkUtils.isPickingUpDropInZone(g,"Artifact",-425,-100,75))
            {
               return;
            }
         }         

         AfkUtils.fire(g,true);  // Just shoot all the time :P
         var dst:Number = AfkUtils.distanceSquaredToPoint(g, -425, -100);
         if(dst < 25*25)   // When within 25 units of the spawn point, start turning and deaccelerating
         {
            AfkUtils.turnRight(g,true);
            AfkUtils.accelerate(g,false);
            AfkUtils.deaccelerate(g,true);
            return;  // This returns so the final lookAtPoint instruction is skipped
         }
         else if(dst < 75*75) // When within 75 units of the spawn point, start centering
         {
            if(Math.abs(AfkUtils.angleDifferencePoint(g, -425, -100)) > 3.05)  // If you're pointed roughly towards the spawn point, accelerate
            {
               AfkUtils.accelerate(g,true);
               AfkUtils.deaccelerate(g,false);
            }
            else  // If you're not pointing towards the spawn point, just deaccelerate
            {
               AfkUtils.accelerate(g,false);
               AfkUtils.deaccelerate(g,true);
            }
         }
         else  // If far, accelerate towards it
         {
            AfkUtils.accelerate(g,true);
            AfkUtils.deaccelerate(g,false);
         }
         AfkUtils.lookAtPoint(g, -425, -100);
      }
      
      public static function mbfarm(g:Game) : void
      {
         if(AfkUtils.isPickingUpDropInZone(g,"Crate",116.5,0,75))
         {
            return;
         }
         AfkUtils.lookAtPoint(g,116.5,0);
         AfkUtils.accelerate(g,true);
         AfkUtils.fire(g,true);
      }
      
      public static function icemoth(g:Game) : void
      {
         var targetMoth:EnemyShip = AfkUtils.closestEnemyByName(g,"Ice");
         if(targetMoth != null)
         {
            if(AfkUtils.distanceSquaredToObject(g,targetMoth) > 1000 * 1000 && Math.abs(AfkUtils.angleDifferenceObject(g,targetMoth)) > 3)
            {
               AfkUtils.boost(g);
            }
            AfkUtils.lookAtObject(g,targetMoth);
         }
         AfkUtils.accelerate(g,true);
         AfkUtils.fire(g,true);
      }
   }
}
