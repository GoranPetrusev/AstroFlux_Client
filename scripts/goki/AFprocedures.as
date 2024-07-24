package goki
{
   import core.scene.Game;
   import core.ship.EnemyShip;
   
   public class AFprocedures
   {
      
      public static var functions:Object = {
         "buglegs":buglegs,
         "exe":exefarm,
         "mb":mbfarm,
         "icemoth":icemoth
      };
       
      
      public function AFprocedures()
      {
         super();
      }
      
      public static function buglegs(g:Game) : void
      {
         if(AFutil.isPickingUpDrop(g,"Bug Leg"))
         {
            return;
         }
         var targetMoth:EnemyShip = AFutil.closestEnemyByName(g,"Moth Alpha");
         if(targetMoth != null)
         {
            if(AFutil.distanceSquaredToObject(g,targetMoth) > 1000 * 1000 && Math.abs(AFutil.angleDifferenceObject(g,targetMoth)) > 3)
            {
               AFutil.boost(g);
            }
            AFutil.lookAtObject(g,targetMoth);
         }
         AFutil.accelerate(g,true);
         AFutil.fire(g,true);
      }
      
      public static function exefarm(g:Game) : void
      {
         if(AFutil.isPickingUpDropInZone(g,"Crate",-425,-100,75))
         {
            return;
         }
         AFutil.lookAtPoint(g,-425,-100);
         AFutil.accelerate(g,true);
         AFutil.fire(g,true);
      }
      
      public static function mbfarm(g:Game) : void
      {
         if(AFutil.isPickingUpDropInZone(g,"Crate",116.5,0,75))
         {
            return;
         }
         AFutil.lookAtPoint(g,116.5,0);
         AFutil.accelerate(g,true);
         AFutil.fire(g,true);
      }
      
      public static function icemoth(g:Game) : void
      {
         var targetMoth:EnemyShip = AFutil.closestEnemyByName(g,"Ice");
         if(targetMoth != null)
         {
            if(AFutil.distanceSquaredToObject(g,targetMoth) > 1000 * 1000 && Math.abs(AFutil.angleDifferenceObject(g,targetMoth)) > 3)
            {
               AFutil.boost(g);
            }
            AFutil.lookAtObject(g,targetMoth);
         }
         AFutil.accelerate(g,true);
         AFutil.fire(g,true);
      }
   }
}
