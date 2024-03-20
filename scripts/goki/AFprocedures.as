package goki
{
   import core.hud.components.chat.MessageLog;
   import core.drops.Drop;
   import core.scene.Game;
   import core.ship.ShipManger;
   import core.ship.Ship;
   import core.ship.EnemyShip;
   import core.solarSystem.Body;
   import generics.Util;
   import flash.geom.Point;

   public class AFprocedures
   {
      public static var functions:Object = {
         "buglegs":buglegs,
         "exe":exefarm
      };

      public function AFprocedures()
      {
         super();
      }

      public static function buglegs(g:Game) : void
      {
         if(!AFutil.isPickingUpDrop(g, "Bug Leg"))
         {
            var targetMoth:EnemyShip = AFutil.closestEnemyByName(g, "Moth Alpha");

            if(AFutil.distanceSquaredToObject(g, targetMoth) > 1000*1000 && Math.abs(AFutil.angleDifferenceObject(g, targetMoth)) > 3)
            {
               AFutil.boost(g);
            }
            AFutil.lookAtObject(g, targetMoth);
            AFutil.accelerate(g, true);
         }

         AFutil.recycleCargoIfFull(g);
         AFutil.fire(g, true);
      }

      public static function exefarm(g:Game) : void
      {
         if(!AFutil.isPickingUpDropInZone(g, "Crate", -425, -100, 75))
         {
            AFutil.lookAtPoint(g, -425, -100);
            AFutil.accelerate(g, true);
         }
         AFutil.fire(g,true);
      }
   }
}
