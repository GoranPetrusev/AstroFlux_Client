package core.artifact
{
   import core.hud.components.ToolTip;
   import core.player.CrewMember;
   import core.player.Player;
   import core.scene.Game;
   import generics.Util;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.TouchEvent;
   import textures.ITextureManager;
   import textures.TextureLocator;
   
   public class ArtifactCargoBox extends Sprite
   {
      
      private static const COLOR_ACTIVE:uint = 16777215;
      
      private static const COLOR_SELECTED_RECYCLE:uint = 12203572;
      
      private static const COLOR_SELECTED_UPGRADE:uint = 8978312;
       
      
      private var p:Player;
      
      private var g:Game;
      
      public var hint:Boolean = false;
      
      public var a:Artifact;
      
      private var recycleMode:Boolean;
      
      private var upgradeMode:Boolean;
      
      private var isInSetup:Boolean;
      
      private var textureManager:ITextureManager;
      
      private var frame:Image;
      
      private var toolTip:ToolTip;
      
      private var COLOR_NORMAL:uint = 6513507;
      
      protected var hintNewContainer:Image;
      
      private var lock:Image;
      
      private var artifactImage:Image;
      
      private var upgradingImage:Image;
      
      private var colors:Array;
      
      public function ArtifactCargoBox(param1:Game, param2:Artifact)
      {
         super();
         this.g = param1;
         this.p = param1.me;
         this.a = param2;
         colors = [9013641,3632844,3653175,13383628,13409563];
         toolTip = new ToolTip(param1,this,"",null,"artifactBox");
         textureManager = TextureLocator.getService();
         update();
      }
      
      public function update() : void
      {
         removeChildren();
         drawFrame();
         toolTip.text = "";
         useHandCursor = false;
         removeEventListener("touch",onTouch);
         if(a != null)
         {
            addImages();
            addTouch();
            addToolTip();
            addUpgradeIcon();
            addHint();
         }
      }
      
      private function addImages() : void
      {
         if(!a.revealed)
         {
            lock = new Image(textureManager.getTextureGUIByTextureName("new_artifact"));
            lock.x = Math.round(frame.width / 2 - lock.width / 2);
            lock.y = Math.round(frame.height / 2 - lock.width / 2);
            addChild(lock);
         }
         else
         {
            artifactImage = new Image(textureManager.getTextureGUIByKey(a.bitmap));
            artifactImage.scaleX = artifactImage.scaleY = 0.25;
            artifactImage.x = Math.round(frame.width / 2 - artifactImage.width / 2);
            artifactImage.y = Math.round(frame.height / 2 - artifactImage.width / 2);
            addChild(artifactImage);
         }
      }
      
      private function addHint() : void
      {
         if(hint)
         {
            hintNewContainer = new Image(textureManager.getTextureGUIByTextureName("notification.png"));
            hintNewContainer.x = 0;
            hintNewContainer.y = -4;
            hintNewContainer.touchable = false;
            addChild(hintNewContainer);
         }
      }
      
      private function addUpgradeIcon() : void
      {
         if(a.upgrading)
         {
            upgradingImage = new Image(textureManager.getTextureGUIByTextureName("upgrading"));
         }
         else if(a.upgraded >= 10)
         {
            upgradingImage = new Image(textureManager.getTextureGUIByTextureName("upgraded_max"));
         }
         else if(a.upgraded > 6)
         {
            upgradingImage = new Image(textureManager.getTextureGUIByTextureName("upgraded3"));
         }
         else if(a.upgraded > 3)
         {
            upgradingImage = new Image(textureManager.getTextureGUIByTextureName("upgraded2"));
         }
         else if(a.upgraded > 0)
         {
            upgradingImage = new Image(textureManager.getTextureGUIByTextureName("upgraded"));
         }
         if(upgradingImage != null)
         {
            upgradingImage.x = 20;
            addChild(upgradingImage);
         }
      }
      
      public function showHint() : void
      {
         hint = true;
         update();
      }
      
      public function hideHint() : void
      {
         hint = false;
         update();
      }
      
      private function drawFrame() : void
      {
         frame = new Image(textureManager.getTextureGUIByTextureName("artifact_box_small"));
         frame.color = COLOR_NORMAL;
         addChild(frame);
         if(a == null)
         {
            return;
         }
         setFrameColor(colors[a.stats.length - 1]);
         var _loc1_:Boolean = p.isActiveArtifact(a);
         if(_loc1_)
         {
            setFrameColor(16777215);
         }
      }
      
      private function addToolTip() : void
      {
         var _loc4_:int = 0;
         var _loc3_:CrewMember = null;
         if(!a.revealed)
         {
            toolTip.text = "<font color=\'#ffaa44\'>" + a.name + "</font>";
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < p.crewMembers.length)
         {
            _loc3_ = p.crewMembers[_loc4_];
            if(_loc3_.artifact == a.id)
            {
               a.upgradeTime = _loc3_.artifactEnd;
            }
            _loc4_++;
         }
         var _loc2_:String = "<font color=\'#ffaa44\'>" + a.name + "</font><br>";
         if(a.revealed && a.isRestricted)
         {
            _loc2_ += "<font color=\'#ff0000\'>Requires level [level]</font><br><br>".replace("[level]",a.requiredPlayerLevel);
         }
         _loc2_ += "Level [potential]  Strength [level]<br>".replace("[level]",a.level).replace("[potential]",a.levelPotential);
         if(a.upgraded >= 10)
         {
            _loc2_ += "Max Upgraded<br>";
         }
         else if(a.upgraded > 0)
         {
            _loc2_ += "[nr] upgrades<br>".replace("[nr]",a.upgraded);
         }
         if(a.upgrading)
         {
            _loc2_ += "Upgrading: " + Util.getFormattedTime(a.upgradeTime - g.time) + "<br>";
         }
         _loc2_ = _loc2_ + "Fitness " + a.fitness + "<br>";
         var lineNumber:int = 0;
         for each(var _loc1_ in a.stats)
         {
            var distribution:Number = Number(ArtifactStat.statDistribution(_loc1_.type,_loc1_.value,a.stats.length,lineNumber,a.level).toFixed(2));
            var sign:String = distribution >= 0 ? "+" : "";
            _loc2_ += ArtifactStat.parseTextFromStatType(_loc1_.type,_loc1_.value) + "  " + sign + distribution + " str<br>";
            lineNumber++;
         }
         toolTip.text = _loc2_;
         toolTip.color = a.getColor();
      }
      
      private function addTouch() : void
      {
         if(a.revealed && a.isRestricted && !recycleMode && !upgradeMode)
         {
            if(artifactImage != null)
            {
               artifactImage.alpha = 0.5;
            }
            if(lock != null)
            {
               lock.alpha = 0.5;
            }
            if(hintNewContainer != null)
            {
               hintNewContainer.alpha = 0.5;
            }
            return;
         }
         useHandCursor = true;
         addEventListener("touch",onTouch);
      }
      
      private function removeTouch() : void
      {
         if(hasEventListener("touch",onTouch))
         {
            removeEventListener("touch",onTouch);
            useHandCursor = false;
         }
         if(artifactImage != null)
         {
            artifactImage.alpha = 1;
         }
         if(lock != null)
         {
            lock.alpha = 1;
         }
         if(hintNewContainer != null)
         {
            hintNewContainer.alpha = 1;
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         if(param1.getTouch(this,"ended"))
         {
            onClick(param1);
         }
         else if(param1.interactsWith(this))
         {
            addToolTip();
            if(hint)
            {
               hideHint();
            }
         }
      }
      
      private function onClick(param1:TouchEvent) : void
      {
         if(!a.revealed && !recycleMode)
         {
            a.revealed = true;
            g.send("revealArtifact",a.id);
            update();
            return;
         }
         if(!recycleMode && !upgradeMode)
         {
            dispatchEventWith("artifactSelected",true);
            return;
         }
         if(upgradeMode)
         {
            if(a.upgrading)
            {
               return;
            }
            if(a.upgraded >= 10)
            {
               g.showMessageDialog("This artifact has already been upgraded 10 times.");
               return;
            }
            toggleUpgrade();
            dispatchEventWith("artifactUpgradeSelected",true);
            return;
         }
         if(a.upgrading || isInSetup)
         {
            return;
         }
         toggleRecycle();
         dispatchEventWith("artifactRecycleSelected",true);
      }
      
      public function isUsedInSetup() : Boolean
      {
         return isInSetup;
      }
      
      public function setSelectedForRecycle() : void
      {
         if(a == null)
         {
            return;
         }
         setFrameColor(12203572);
      }
      
      public function setNotSelected() : void
      {
         if(a == null)
         {
            return;
         }
         if(isInSetup)
         {
            setFrameColor(16777215);
         }
         else
         {
            setFrameColor(colors[a.stats.length - 1]);
         }
      }
      
      public function toggleUpgrade() : void
      {
         if(a == null)
         {
            return;
         }
         if(frame.color != 8978312)
         {
            setFrameColor(8978312);
         }
         else if(isInSetup)
         {
            setFrameColor(16777215);
         }
         else
         {
            setFrameColor(colors[a.stats.length - 1]);
         }
      }
      
      public function toggleRecycle() : void
      {
         if(a == null)
         {
            return;
         }
         if(frame.color != 12203572)
         {
            setFrameColor(12203572);
         }
         else
         {
            setFrameColor(colors[a.stats.length - 1]);
         }
      }
      
      public function setUpgradeState() : void
      {
         upgradeMode = true;
         if(a == null)
         {
            return;
         }
         isInSetup = p.isArtifactInSetup(a);
         if(isInSetup)
         {
            setFrameColor(16777215);
         }
         else
         {
            setFrameColor(colors[a.stats.length - 1]);
         }
         removeTouch();
         addTouch();
         update();
      }
      
      public function removeUpgradeState() : void
      {
         upgradeMode = false;
         if(a == null)
         {
            setFrameColor(colors[a.stats.length - 1]);
            return;
         }
         var _loc1_:Boolean = p.isActiveArtifact(a);
         if(_loc1_)
         {
            setFrameColor(16777215);
         }
         else
         {
            setFrameColor(colors[a.stats.length - 1]);
         }
         removeTouch();
         addTouch();
         update();
      }
      
      public function setRecycleState() : void
      {
         recycleMode = true;
         if(a == null)
         {
            return;
         }
         isInSetup = p.isArtifactInSetup(a);
         if(isInSetup)
         {
            setFrameColor(16777215);
         }
         else
         {
            setFrameColor(colors[a.stats.length - 1]);
         }
         removeTouch();
         addTouch();
         update();
      }
      
      public function removeRecycleState() : void
      {
         recycleMode = false;
         if(a == null)
         {
            setFrameColor(colors[a.stats.length - 1]);
            return;
         }
         var _loc1_:Boolean = p.isActiveArtifact(a);
         if(_loc1_)
         {
            setFrameColor(16777215);
         }
         else
         {
            setFrameColor(colors[a.stats.length - 1]);
         }
         removeTouch();
         addTouch();
         update();
      }
      
      public function stateNormal() : void
      {
         setFrameColor(colors[a.stats.length - 1]);
      }
      
      public function updateSetupChange() : void
      {
         frame.color = COLOR_NORMAL;
         if(a == null)
         {
            return;
         }
         setFrameColor(colors[a.stats.length - 1]);
         var _loc1_:Boolean = p.isActiveArtifact(a);
         if(_loc1_)
         {
            setFrameColor(16777215);
         }
      }
      
      private function setFrameColor(param1:uint) : void
      {
         if(frame.color === param1)
         {
            return;
         }
         frame.color = param1;
      }
      
      public function setEmpty() : void
      {
         a = null;
         update();
      }
   }
}
