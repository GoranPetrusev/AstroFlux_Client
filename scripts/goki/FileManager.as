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
         var fileStream:FileStream = new FileStream();
         var file:File = File.applicationStorageDirectory.resolvePath(fileName);
         fileStream.open(file,FileMode.WRITE);
         fileStream.writeUTFBytes(data);
         fileStream.close();
      }
      
      public static function readFromFile(fileName:String) : String
      {
         var fileStream:FileStream = new FileStream();
         var file:File = File.applicationStorageDirectory.resolvePath(fileName);
         fileStream.open(file,FileMode.READ);
         var str:String = String(fileStream.readUTFBytes(fileStream.bytesAvailable));
         fileStream.close();
         return str;
      }
   }
}
