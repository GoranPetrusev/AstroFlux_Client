package core.hud.components.map
{
   import core.scene.Game;
   import core.solarSystem.Body;
   import starling.display.Image;
   import starling.display.Sprite;
   
   public class MapStation extends MapBodyBase
   {
       
      
      public function MapStation(param1:Game, param2:Sprite, param3:Body)
      {
         super(param1,param2,param3);
         layer.useHandCursor = true;
         param2.addChild(core.hud.components.§map:MapBodyBase§.text);
         addImage();
         addText();
         init();
      }
      
      private function addImage() : void
      {
         var _loc1_:String = body.type.toLowerCase().replace(" ","");
         var _loc2_:Image = new Image(textureManager.getTextureGUIByTextureName("map_" + _loc1_));
         _loc2_.color = body.typeColor;
         imgSelected = new Image(textureManager.getTextureGUIByTextureName("map_" + _loc1_ + "_selected"));
         imgSelected.color = body.selectedTypeColor;
         imgHover = new Image(textureManager.getTextureGUIByTextureName("map_" + _loc1_ + "_hover"));
         imgHover.color = body.selectedTypeColor;
         radius = _loc2_.width / 2;
         layer.addChild(_loc2_);
      }
      
      private function addText() : void
      {
         core.hud.components.§map:MapBodyBase§.text.size = 11;
         core.hud.components.§map:MapBodyBase§.text.format.color = body.color;
         core.hud.components.§map:MapBodyBase§.text.text = body.name;
      }
   }
}
