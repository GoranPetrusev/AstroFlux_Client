package starling.text
{
   import flash.utils.Dictionary;
   import starling.display.Image;
   import starling.textures.Texture;
   
   public class BitmapChar
   {
       
      
      private var _texture:Texture;
      
      private var _charID:int;
      
      private var _xOffset:Number;
      
      private var _yOffset:Number;
      
      private var _xAdvance:Number;
      
      private var _kernings:Dictionary;
      
      public function BitmapChar(param1:int, param2:Texture, param3:Number, param4:Number, param5:Number)
      {
         super();
         _charID = param1;
         _texture = param2;
         _xOffset = param3;
         _yOffset = param4;
         _xAdvance = param5;
         _kernings = null;
      }
      
      public function addKerning(param1:int, param2:Number) : void
      {
         if(_kernings == null)
         {
            _kernings = new Dictionary();
         }
         _kernings[param1] = param2;
      }
      
      public function getKerning(param1:int) : Number
      {
         if(_kernings == null || _kernings[param1] == undefined)
         {
            return 0;
         }
         return _kernings[param1];
      }
      
      public function createImage() : Image
      {
         return new Image(_texture);
      }
      
      public function get charID() : int
      {
         return _charID;
      }
      
      public function get xOffset() : Number
      {
         return _xOffset;
      }
      
      public function get yOffset() : Number
      {
         return _yOffset;
      }
      
      public function get xAdvance() : Number
      {
         return _xAdvance;
      }
      
      public function get texture() : Texture
      {
         return _texture;
      }
      
      public function get width() : Number
      {
         return _texture.width;
      }
      
      public function get height() : Number
      {
         return _texture.height;
      }
   }
}
