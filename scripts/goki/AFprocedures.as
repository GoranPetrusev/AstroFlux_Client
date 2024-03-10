package goki
{
   import core.hud.components.chat.MessageLog;
   import core.scene.Game;
   import core.ship.ShipManger;
   import core.ship.Ship;
   import core.ship.EnemyShip;
   import generics.Util;
   import flash.geom.Point;

   public class AFprocedures
   {
      public static var functions:Object = {
         "buglegs":buglegs
      };

      public function AFprocedures()
      {
         super();
      }

      public static function buglegs(g:Game) : void
      {
         var closestEnemy:EnemyShip = g.shipManager.enemies[0];
         for each (var currEnemy in g.shipManager.enemies)
         {
            if(currEnemy.bodyName != "Enemy Moth Alpha lvl 13")
            {
               continue;
            }

            if(AFutil.distanceSquaredToShip(g, currEnemy) < AFutil.distanceSquaredToShip(g, closestEnemy))
            {
               closestEnemy = currEnemy;
            }
         }

         AFutil.lookAtShip(g, closestEnemy);
         AFutil.accelerate(g, true);
         AFutil.fire(g, true);
      }      
   }
}
