package goki
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   
   public class FileManager
   {
       
      
      public function FileManager()
      {
         super();
      }
      
      public static function saveToFile(fileName:String, data:String) : void
      {
         var fileStream:*;
         var file:*;
         try
         {
            fileStream = new FileStream();
            file = File.applicationStorageDirectory.resolvePath(fileName);
            fileStream.open(file,FileMode.WRITE);
            fileStream.writeUTFBytes(data);
            fileStream.close();
         }
         catch(e:Error)
         {
            return;
         }
      }

      public static function appendToFile(fileName:String, data:String) : void
      {
         var fileStream:*;
         var file:*;
         try
         {
            fileStream = new FileStream();
            file = File.applicationStorageDirectory.resolvePath(fileName);
            fileStream.open(file,FileMode.APPEND);
            fileStream.writeUTFBytes(data);
            fileStream.close();
         }
         catch(e:Error)
         {
            return;
         }
      }

      public static function readFromFile(fileName:String) : String
      {
         var str:String;
         var fileStream:*;
         var file:*;
         try
         {
            fileStream = new FileStream();
            file = File.applicationStorageDirectory.resolvePath(fileName);
            fileStream.open(file,FileMode.READ);
            str = String(fileStream.readUTFBytes(fileStream.bytesAvailable));
            fileStream.close();
            return str;
         }
         catch(e:Error)
         {
            return "";
         }
      }
   }
}
