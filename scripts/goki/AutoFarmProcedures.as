package goki
{
   import core.hud.components.chat.MessageLog;
   
   public class AutoFarmProcedures
   {
      
      public static var functions:Object = {
         "test":test,
         "buglegs":buglegs
      };
       
      
      public function AutoFarmProcedures()
      {
         super();
      }
      
      public static function test() : void
      {
         MessageLog.write("test");
      }
      
      public static function buglegs() : void
      {
         MessageLog.write("buglegs");
      }
   }
}
