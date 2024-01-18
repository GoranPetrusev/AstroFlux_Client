package starling.filters
{
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.textures.Texture;
   
   public interface IFilterHelper
   {
       
      
      function getTexture(param1:Number = 1) : Texture;
      
      function putTexture(param1:Texture) : void;
      
      function get targetBounds() : Rectangle;
      
      function get target() : DisplayObject;
   }
}
