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
         "icemoth":icemoth,
         "blob":blob,
         "z":zhersis
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
      private static var buffer:Number = 0;
      public static function exefarm(g:Game) : void
      {
         if(g.me.stacksNumber == 0)
         {
            g.me.stack(100);
            return;
         }

         // Keep pushing the looting window forward by 50sec until the exe dies
         // 2sec buffer stops loot from getting picked up while exe is getting killed
         if(g.bossManager.bosses.length == 1)
         {
            lootingWindow = g.time + 50000;
            buffer = g.time + 2000;
         }

         // Until game time exceeds the looting window, pick up gold crates and arts
         if(g.time > buffer && g.time < lootingWindow)
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
               AfkUtils.deaccelerate(g,false);
               AfkUtils.accelerate(g,true);
            }
            else  // If you're not pointing towards the spawn point, just deaccelerate
            {
               AfkUtils.accelerate(g,false);
               AfkUtils.deaccelerate(g,true);
            }
         }
         else  // If far, accelerate towards it
         {
            AfkUtils.deaccelerate(g,false);
            AfkUtils.accelerate(g,true);
         }
         AfkUtils.lookAtPoint(g, -425, -100);
      }
      
      private static var lureTimer:Number = 0;
      private static var blobCnt:int = 0;
      public static function blob(g:Game) : void
      {
         // Looting
         if(AfkUtils.isPickingUpDropInZone(g, "Artifact", -775, 0, 15))
         {
            lureTimer = 0;
            return;
         }

         // Killing
         var dst:Number;
         if(lureTimer != 0 && g.time > lureTimer)
         {
            blobCnt = 0;
            AfkUtils.accelerateNonOrbitToPoint(g, -775, 0);

            dst = AfkUtils.distanceSquaredToPoint(g, -775, 0);
            if(dst < 100*100)
            {
               AfkUtils.fire(g, true);
            }
            return;
         }

         // Luring
         blobCnt = 0;
         dst = AfkUtils.distanceSquaredToPoint(g, -785, 0);
         for each(var enemy in g.shipManager.enemies)
         {
            blobCnt += (enemy.name.indexOf("???") != -1);
         }
         if(dst < 75*75)
         {
            if(lureTimer == 0 && blobCnt == 8)
            {
               lureTimer = g.time + 5000;
            }
            if(Math.abs(AfkUtils.angleDifferencePoint(g, -785, 0)) > 3.05)
            {
               AfkUtils.deaccelerate(g,false);
               AfkUtils.accelerate(g,true);
            }
            else
            {
               AfkUtils.accelerate(g,false);
               AfkUtils.deaccelerate(g,true);
            }
         }
         else
         {
            AfkUtils.deaccelerate(g,false);
            AfkUtils.accelerate(g,true);
         }
         AfkUtils.lookAtPoint(g, -785, 0);
         AfkUtils.fire(g, false);
      }

      public static function zhersis(g:Game) : void
      {
         if(AfkUtils.isPickingUpDropInZone(g, "Artifact", 40, 80, 10))
         {
            return;
         }

         var dst:Number = AfkUtils.distanceSquaredToPoint(g, 40, 80);
         if(dst < 50*50)
         {
            AfkUtils.accelerate(g, false);
            AfkUtils.deaccelerate(g,true);
         }
         else
         {
            AfkUtils.lookAtPoint(g, 40, 80);
            AfkUtils.accelerateNonOrbitToPoint(g, 40, 80);
         }
         AfkUtils.fire(g, true);
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
