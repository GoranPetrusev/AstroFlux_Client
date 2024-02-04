package goki
{
   public class QuickloginAccounts extends Config
   {
      
      private static const _filePath:String = "QuickloginAccounts.txt";
      
      public static var accounts:Object = {
         "Pancake":["youthought@lmao.com","cmontryit:P"],
         "Example":["example123@somethis.com","pass"]
      };
       
      
      public function QuickloginAccounts()
      {
         super();
      }
      
      public static function addAccount(key:String, user:String, pass:String) : void
      {
         accounts[key] = [user,pass];
      }
      
      public static function removeAccount(key:String)
      {
         delete accounts[key];
      }
      
      public static function saveConfig() : void
      {
         save(_filePath,accounts);
      }
      
      public static function loadConfig() : void
      {
         load(_filePath,accounts);
      }
   }
}
