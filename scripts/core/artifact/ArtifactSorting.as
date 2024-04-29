package core.artifact
{
   import core.hud.components.Button;
   import core.hud.components.ToolTip;
   import core.scene.Game;
   import feathers.controls.ScrollContainer;
   import generics.ObjUtils;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   import textures.ITextureManager;
   import textures.TextureLocator;
   
   public class ArtifactSorting extends Sprite
   {
       
      
      private var nextX:int = 20;
      
      private var nextY:int = 0;
      
      private var padding:int = 10;
      
      private var g:Game;
      
      private var types:Vector.<Object>;
      
      private var callback:Function;
      
      private var drawCount:int = 0;
      
      private var scrollArea:ScrollContainer;
      
      private var mainBody:Sprite;
      
      public function ArtifactSorting(param1:Game, param2:Function)
      {
         var q:Quad;
         var headline:TextField;
         var tmp:Object;
         var sortButton:Button;
         var g:Game = param1;
         var callback:Function = param2;
         super();
         this.g = g;
         this.callback = callback;
         q = new Quad(665,520,0);
         q.x = -10;
         q.y = -10;
         q.alpha = 0.9;
         addChild(q);
         headline = new TextField(375,100);
         headline.x = 280;
         headline.y = 1;
         headline.format.font = "DAIDRR";
         headline.format.size = 40;
         headline.format.color = 16777215;
         headline.format.horizontalAlign = "right";
         headline.format.verticalAlign = "top";
         headline.text = "Choose sorting";
         addChild(headline);
         scrollArea = new ScrollContainer();
         mainBody = new Sprite();
         scrollArea.width = 660;
         scrollArea.height = 450;
         tmp = g.dataManager.loadTable("ArtifactTypes");
         types = ObjUtils.ToVector(tmp,true,"name");
         drawOfSubset("health");
         drawOfSubset("convShield");
         newRow();
         drawOfSubset("armor");
         newRow();
         drawOfSubset("shield");
         drawOfSubset("convHp");
         newRow();
         drawOfSubset("power");
         drawOfSubset("all");
         newRow();
         drawOfSubset("kineticAdd");
         drawOfSubset("kineticMulti");
         drawOfSubset("kineticResist");
         newRow();
         drawOfSubset("energy");
         newRow();
         drawOfSubset("corrosiveAdd");
         drawOfSubset("corrosiveMulti");
         drawOfSubset("corrosiveResist");
         drawOfSubset("speed");
         drawOfSubset("refire");
         drawOfSubset("cooldown");
         newRow();
         scrollArea.addChild(mainBody);
         addChild(scrollArea);
         sortButton = new Button(function():void
         {
            closeAndSort("levelhigh");
         },"Strength high");
         sortButton.x = 20;
         sortButton.y = 440;
         addChild(sortButton);
         sortButton = new Button(function():void
         {
            closeAndSort("levellow");
         },"Strength low");
         sortButton.x = 20;
         sortButton.y = 480;
         addChild(sortButton);
         sortButton = new Button(function():void
         {
            closeAndSort("statcountdesc");
         },"Lines high");
         sortButton.x = 152;
         sortButton.y = 440;
         addChild(sortButton);
         sortButton = new Button(function():void
         {
            closeAndSort("statcountasc");
         },"Lines low");
         sortButton.x = 152;
         sortButton.y = 480;
         addChild(sortButton);
         sortButton = new Button(function():void
         {
            closeAndSort("fitnesshigh");
         },"Fitness high");
         sortButton.x = 260;
         sortButton.y = 440;
         addChild(sortButton);
         sortButton = new Button(function():void
         {
            closeAndSort("fitnesslow");
         },"Fitness low");
         sortButton.x = 260;
         sortButton.y = 480;
         addChild(sortButton);
         sortButton = new Button(function():void
         {
            closeAndSort("upgradeshigh");
         },"Upgrades high");
         sortButton.x = 382;
         sortButton.y = 440;
         addChild(sortButton);
         sortButton = new Button(function():void
         {
            closeAndSort("upgradeslow");
         },"Upgrades low");
         sortButton.x = 382;
         sortButton.y = 480;
         addChild(sortButton);
      }
      
      private function newRow() : void
      {
         nextX = 20;
         nextY += 60;
      }
      
      private function drawOfSubset(param1:String) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Object = null;
         var _loc2_:String = null;
         _loc4_ = 0;
         while(_loc4_ < types.length)
         {
            _loc3_ = types[_loc4_];
            _loc2_ = String(_loc3_.type);
            if(!(_loc2_.indexOf(param1) == -1 || _loc2_.indexOf("2") != -1 || _loc2_.indexOf("3") != -1))
            {
               addButton(_loc3_);
            }
            _loc4_++;
         }
      }
      
      private function addButton(param1:Object) : void
      {
         var _loc2_:ITextureManager = TextureLocator.getService();
         var _loc4_:Image = new Image(_loc2_.getTextureGUIByKey(param1.bitmap));
         _loc4_.scaleX = _loc4_.scaleY = 0.7;
         _loc4_.x = nextX;
         _loc4_.y = nextY;
         _loc4_.name = param1.type;
         mainBody.addChild(_loc4_);
         nextX += _loc4_.width + padding;
         var _loc3_:ToolTip = new ToolTip(g,_loc4_,param1.name,null,"artifactBox");
         _loc4_.addEventListener("touch",onTouch);
         _loc4_.addEventListener("touch",onTouch);
         _loc4_.useHandCursor = true;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Image = param1.currentTarget as Image;
         if(param1.getTouch(_loc2_,"ended"))
         {
            _loc2_.filter = null;
            closeAndSort(_loc2_.name);
         }
         else if(param1.interactsWith(_loc2_))
         {
            _loc2_.alpha = 0.5;
         }
         else if(!param1.interactsWith(_loc2_))
         {
            _loc2_.alpha = 1;
         }
      }
      
      private function closeAndSort(param1:String) : void
      {
         callback(param1);
         parent.removeChild(this,true);
      }
   }
}
