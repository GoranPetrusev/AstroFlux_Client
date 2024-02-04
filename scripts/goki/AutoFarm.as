package goki
{
   import core.hud.components.chat.MessageLog;
   import core.scene.Game;
   import core.ship.PlayerShip;
   
   public class AutoFarm
   {
      
      private static var callback:Function = null;
       
      
      private var g:Game;
      
      private var player:PlayerShip;
      
      public function AutoFarm(instance:Game)
      {
         super();
         g = instance;
         player = g.me;
      }
      
      public function init(procedure:String) : void
      {
         try
         {
            if(AutoFarmProcedures.functions.hasOwnProperty(procedure))
            {
               callback = AutoFarmProcedures.functions[procedure];
               MessageLog.write("function set");
            }
            else
            {
               callback = null;
               MessageLog.write("function null");
            }
         }
         catch(e:Error)
         {
            g.showErrorDialog(e.getStackTrace());
         }
      }
      
      public function run() : void
      {
         if(callback == null)
         {
            return;
         }
         callback();
      }
   }
}
