package mx.resources
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Locale
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var currentLocale:Locale;
       
      
      private var localeString:String;
      
      private var _language:String;
      
      private var _country:String;
      
      private var _variant:String;
      
      public function Locale(param1:String)
      {
         super();
         this.localeString = param1;
         var _loc2_:Array = param1.split("_");
         if(_loc2_.length > 0)
         {
            this._language = _loc2_[0];
         }
         if(_loc2_.length > 1)
         {
            this._country = _loc2_[1];
         }
         if(_loc2_.length > 2)
         {
            this._variant = _loc2_.slice(2).join("_");
         }
      }
      
      public function get language() : String
      {
         return this._language;
      }
      
      public function get country() : String
      {
         return this._country;
      }
      
      public function get variant() : String
      {
         return this._variant;
      }
      
      public function toString() : String
      {
         return this.localeString;
      }
   }
}
