package generics
{
   import com.adobe.serialization.json.JSONDecoder;
   import flash.utils.ByteArray;
   import mx.resources.Locale;
   
   public class Localize
   {
      
      private static var LanguageFile:Class = §lang_json$a96c32d35987e511add5ff79f4dafcea-680055981§;
      
      private static var langObj:Object;
      
      public static var language:String = "en";
      
      private static var r:RegExp = new RegExp(/(\W+)/g);
      
      public static var activateLanguageSelection:Boolean = false;
       
      
      public function Localize()
      {
         super();
      }
      
      public static function setLocale(param1:String = "en_US") : void
      {
         var _loc2_:Locale = new Locale(param1 || "en_US");
      }
      
      public static function t(param1:String) : String
      {
         if(!activateLanguageSelection)
         {
            return param1;
         }
         var _loc3_:String = param1.replace(r,"").toLowerCase();
         if(langObj[language] == null)
         {
            return param1;
         }
         var _loc2_:String = String(langObj[language][_loc3_]);
         if(_loc2_ == null)
         {
            return param1;
         }
         if(_loc2_ == "")
         {
            return param1;
         }
         return langObj[language][_loc3_].replace(/\\n/g,"\n");
      }
      
      public static function cacheLanguageData() : void
      {
         var _loc2_:ByteArray = new LanguageFile() as ByteArray;
         var _loc1_:JSONDecoder = new JSONDecoder(_loc2_.readUTFBytes(_loc2_.length),true);
         langObj = _loc1_.getValue();
      }
      
      public static function newData(param1:String) : void
      {
         langObj = JSON.parse(param1);
      }
   }
}
