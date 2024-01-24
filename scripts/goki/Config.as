package goki
{
   public class Config
   {
       
      
      public function Config()
      {
         super();
      }
      
      protected static function saveConfig(dest:String, obj:Object) : void
      {
         FileManager.saveToFile(dest,JSON.stringify(obj));
      }
      
      protected static function loadConfig(dest:String, obj:Object) : void
      {
         var data:String = FileManager.readFromFile(dest);
         if(data == "")
         {
            saveConfig(dest,obj);
         }
         else
         {
            obj = JSON.parse(data);
         }
      }
   }
}
