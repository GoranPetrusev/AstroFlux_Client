package starling.textures
{
   import flash.utils.ByteArray;
   
   public class AtfData
   {
       
      
      private var _format:String;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _numTextures:int;
      
      private var _isCubeMap:Boolean;
      
      private var _data:ByteArray;
      
      public function AtfData(param1:ByteArray)
      {
         var _loc4_:* = false;
         var _loc2_:* = 0;
         super();
         if(!isAtfData(param1))
         {
            throw new ArgumentError("Invalid ATF data");
         }
         if(param1[6] == 255)
         {
            param1.position = 12;
         }
         else
         {
            param1.position = 6;
         }
         var _loc3_:uint = param1.readUnsignedByte();
         switch(_loc3_ & 127)
         {
            case 0:
            case 1:
               _format = "bgra";
               break;
            case 2:
            case 3:
            case 12:
               _format = "compressed";
               break;
            case 4:
            case 5:
            case 13:
               _format = "compressedAlpha";
               break;
            default:
               throw new Error("Invalid ATF format");
         }
         _width = Math.pow(2,param1.readUnsignedByte());
         _height = Math.pow(2,param1.readUnsignedByte());
         _numTextures = param1.readUnsignedByte();
         _isCubeMap = (_loc3_ & 128) != 0;
         _data = param1;
         if(param1[5] != 0 && param1[6] == 255)
         {
            _loc4_ = (param1[5] & 1) == 1;
            _loc2_ = param1[5] >> 1 & 127;
            _numTextures = _loc4_ ? 1 : _loc2_;
         }
      }
      
      public static function isAtfData(param1:ByteArray) : Boolean
      {
         var _loc2_:String = null;
         if(param1.length < 3)
         {
            return false;
         }
         _loc2_ = String.fromCharCode(param1[0],param1[1],param1[2]);
         return _loc2_ == "ATF";
      }
      
      public function get format() : String
      {
         return _format;
      }
      
      public function get width() : int
      {
         return _width;
      }
      
      public function get height() : int
      {
         return _height;
      }
      
      public function get numTextures() : int
      {
         return _numTextures;
      }
      
      public function get isCubeMap() : Boolean
      {
         return _isCubeMap;
      }
      
      public function get data() : ByteArray
      {
         return _data;
      }
   }
}
