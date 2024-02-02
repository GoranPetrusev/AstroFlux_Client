package goki
{
   import core.hud.components.chat.MessageLog;
   import core.scene.Game;
   import core.ship.PlayerShip;
   
   public class AutoFarm
   {
       
      
      private var g:Game;
      
      private var callback:Function = null;
      
      private var player:PlayerShip;
      
      public function AutoFarm(instance:Game)
      {
         g = instance;
         player = g.me;
         super();
      }
      
      public function init(procedure:String) : void
      {
         try
         {
            switch(procedure)
            {
               case "buglegs":
                  callback = buglegs;
                  MessageLog.write("starting farm");
            }
         }
         catch(e:Error)
         {
            g.showErrorDialog(e.message);
         }
      }
      
      public function run() : void
      {
         try
         {
            if(callback != null)
            {
               callback("test");
            }
         }
         catch(e:Error)
         {
            g.showErrorDialog(e.getStackTrace());
         }
      }
      
      private function buglegs(p1:String) : void
      {
         MessageLog.write("farming " + p1);
      }
   }
}
