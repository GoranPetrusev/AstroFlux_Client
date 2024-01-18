package facebook
{
   public class Action
   {
      
      private static var ogBaseUrl:String = "http://astroboken.appspot.com/";
       
      
      public function Action()
      {
         super();
      }
      
      public static function discover(param1:String) : void
      {
         send("discover","planet",param1);
      }
      
      public static function encounter(param1:String) : void
      {
         send("encounter","enemy",param1);
      }
      
      public static function hire(param1:String, param2:String) : void
      {
         send("hire","crew_member",param1,param2);
      }
      
      public static function levelUp(param1:int) : void
      {
         send("reach","level",param1.toString());
      }
      
      public static function unlockSystem(param1:String) : void
      {
         send("unlock","star_system",param1);
      }
      
      public static function unlockWeapon(param1:String) : void
      {
         send("unlock","weapon",param1);
      }
      
      public static function unlockShip(param1:String) : void
      {
         send("unlock","ship",param1);
      }
      
      public static function join(param1:String) : void
      {
         send("join","clan",param1);
      }
      
      private static function send(param1:String, param2:String, param3:String = "", param4:String = "") : void
      {
         var objectUrl:String;
         var apiCall:String;
         var action:String = param1;
         var object:String = param2;
         param1 = param3;
         param2 = param4;
         if(Login.currentState != "facebook")
         {
            return;
         }
         objectUrl = ogBaseUrl + object;
         if(param1 != "")
         {
            objectUrl += "/" + param1;
         }
         if(param2 != "")
         {
            objectUrl += "/" + param2;
         }
         objectUrl = encodeURIComponent(objectUrl);
         apiCall = "/me/astroflux:" + action + "?" + object + "=" + objectUrl;
         try
         {
            FB.api(apiCall,"post",function(param1:Object):void
            {
            });
         }
         catch(e:*)
         {
         }
      }
   }
}
