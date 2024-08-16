package goki
{
   import core.hud.components.chat.MessageLog;
   import core.scene.Game;
   import core.ship.PlayerShip;
   
   public class AfkFarm
   {
      
      private static var callback:Function = null;

      public static var isRunning:Boolean = false;
      
      public function AfkFarm()
      {
         super();
      }
      
      public static function init(procedure:String) : void
      {
         if(AfkProcedures.functions.hasOwnProperty(procedure))
         {
            callback = AfkProcedures.functions[procedure];
            isRunning = true;
         }
         else
         {
            callback = null;
            isRunning = false;
         }
      }
      
      public static function run(game:Game) : void
      {
         if(callback == null)
         {
            return;
         }
         try
         {
            callback(game);
         }
         catch (e:Error)
         {
            g.showErrorDialog(e.getStackTrace());
            callback = null;
            isRunning = false;
         }
      }
   }
}
