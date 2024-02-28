package goki
{
   import core.hud.components.chat.MessageLog;
   import core.scene.Game;
   import core.ship.PlayerShip;
   
   public class AutoFarm
   {
      
      private static var callback:Function = null;

      
      public function AutoFarm()
      {
         super();
      }
      
      public static function init(procedure:String) : void
      {
         try
         {
            if(AFprocedures.functions.hasOwnProperty(procedure))
            {
               callback = AFprocedures.functions[procedure];
            }
            else
            {
               callback = null;
            }
         }
         catch(e:Error)
         {
            g.showErrorDialog(e.getStackTrace());
         }
      }
      
      public static function run(game:Game) : void
      {
         if(callback == null)
         {
            return;
         }
         callback(game);
      }
   }
}
