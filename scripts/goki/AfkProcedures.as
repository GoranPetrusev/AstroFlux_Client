package goki
{
   import core.scene.Game;
   import core.ship.EnemyShip;
   
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
      
      public static function exefarm(g:Game) : void
      {
         if(AfkUtils.isPickingUpDropInZone(g,"Crate",-425,-100,75))
         {
            return;
         }
         AfkUtils.lookAtPoint(g,-425,-100);
         AfkUtils.accelerate(g,true);
         AfkUtils.fire(g,true);
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
