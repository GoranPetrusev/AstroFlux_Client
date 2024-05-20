package core.states.gameStates
{
   import com.greensock.TweenMax;
   import core.hud.components.Button;
   import core.hud.components.ButtonCargo;
   import core.hud.components.ImageButton;
   import core.hud.components.Text;
   import core.hud.components.cargo.Cargo;
   import core.hud.components.cargo.CargoItem;
   import core.scene.Game;
   import core.solarSystem.Body;
   import feathers.controls.ScrollContainer;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import playerio.Message;
   import sound.ISound;
   import sound.SoundLocator;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.filters.ColorMatrixFilter;
   import textures.TextureManager;
   
   public class LandedRecycle extends LandedState
   {
       
      
      private var junkTextItems:Array;
      
      private var mineralTextItems:Array;
      
      private var recycleButton:ImageButton;
      
      private var myCargo:Cargo;
      
      private var recycling:Boolean = false;
      
      private var recycledItems:int = 0;
      
      private var takeButton:Button;
      
      private var selectAllButton:Button;
      
      private var scrollContainer:ScrollContainer;
      
      private var scrollContainer2:ScrollContainer;
      
      private var onboardRecycle:Boolean;
      
      public function LandedRecycle(param1:Game, param2:Body)
      {
         scrollContainer = new ScrollContainer();
         scrollContainer2 = new ScrollContainer();
         super(param1,param2,param2.name);
         myCargo = param1.myCargo;
         junkTextItems = [];
         mineralTextItems = [];
         onboardRecycle = param2.name == "On-Board Recycling Facility";
      }
      
      override public function enter() : void
      {
         super.enter();
         var _loc5_:Text = new Text(80,60);
         _loc5_.text = body.name;
         _loc5_.size = 26;
         addChild(_loc5_);
         var _loc3_:Text = new Text(80,100);
         _loc3_.text = "Select space junk";
         _loc3_.color = 6710886;
         addChild(_loc3_);
         var _loc2_:Text = new Text(440,100);
         _loc2_.text = "Your Refined minerals";
         _loc2_.color = 6710886;
         addChild(_loc2_);
         var _loc4_:Vector.<int> = new Vector.<int>();
         _loc4_.push(1,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,1,2,2,2,2,1,2,2,2,2,1,2,2,2,2);
         var _loc1_:Vector.<Number> = new Vector.<Number>();
         _loc1_.push(0,0,260,0,260,40,340,40,340,0,600,0,600,400,340,400,340,360,260,360,260,380,0,380,0,0,260,50,340,50,340,90,260,90,260,50,260,100,340,100,340,300,260,300,260,100,260,350,260,310,340,310,340,350,260,350);
         var _loc9_:flash.display.Sprite = new flash.display.Sprite();
         _loc9_.graphics.lineStyle(1,6356795,1);
         _loc9_.graphics.beginFill(0,1);
         _loc9_.graphics.drawPath(_loc4_,_loc1_);
         _loc9_.graphics.endFill();
         _loc9_.filters = [new GlowFilter(6356795,0.4,15,15,2,2)];
         var _loc12_:Image;
         (_loc12_ = TextureManager.imageFromSprite(_loc9_,"recycleLines")).x = 80;
         _loc12_.y = 130;
         addChild(_loc12_);
         takeButton = new Button(removeMinerals,"Take Minerals","positive");
         takeButton.x = 475;
         takeButton.y = 490;
         takeButton.enabled = false;
         addChild(takeButton);
         selectAllButton = new Button(selectAllJunk,"Select All","normal");
         selectAllButton.x = 125;
         selectAllButton.y = 525;
         selectAllButton.enabled = false;
         selectAllButton.autoEnableAfterClick = true;
         addChild(selectAllButton);
         g.tutorial.showRecycleAdvice();
         recycleButton = new ImageButton(recycle,textureManager.getTextureGUIByTextureName("recycle_button.png"),textureManager.getTextureGUIByTextureName("recycle_button_hover.png"),textureManager.getTextureGUIByTextureName("recycle_button_disabled.png"));
         recycleButton.y = 320;
         recycleButton.x = 380;
         recycleButton.pivotX = recycleButton.width / 2;
         recycleButton.pivotY = recycleButton.height / 2;
         scrollContainer.x = 95;
         scrollContainer.y = 145;
         scrollContainer.height = 345;
         scrollContainer.width = 245;
         scrollContainer2.x = 435;
         scrollContainer2.y = 145;
         scrollContainer2.height = 345;
         scrollContainer2.width = 245;
         addChild(scrollContainer);
         addChild(scrollContainer2);
         junkReceived();
         if(onboardRecycle)
         {
            selectAllJunk();
            recycle(null);
         }
      }
      
      override public function execute() : void
      {
         if(recycling)
         {
            recycleButton.rotation += 0.017453292519943295;
         }
         super.execute();
      }
      
      private function junkReceived() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Vector.<CargoItem> = myCargo.spaceJunk;
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         for each(var _loc1_ in _loc4_)
         {
            if(_loc1_.amount != 0)
            {
               _loc2_ += _loc1_.amount;
               _loc3_ = dataManager.loadKey(_loc1_.table,_loc1_.item);
               scrollContainer.addChild(createItem(_loc3_,"spaceJunk",_loc1_.amount,_loc5_));
               _loc5_++;
            }
         }
         recycleButton.enabled = false;
         if(_loc2_ > 0)
         {
            selectAllButton.enabled = true;
         }
         loadCompleted();
         addChild(recycleButton);
      }
      
      private function createItem(param1:Object, param2:String, param3:int, param4:int, param5:Boolean = false) : starling.display.Sprite
      {
         var bgr:Quad;
         var textName:Text;
         var textQuantity:Text;
         var obj2:Object;
         var itemBmp:Image;
         var obj:Object = param1;
         var type:String = param2;
         var quantity:int = param3;
         var i:int = param4;
         var useTween:Boolean = param5;
         var itemContainer:starling.display.Sprite = new starling.display.Sprite();
         itemContainer.y = i * 40;
         bgr = new Quad(230,32,1450513);
         bgr.x = 0;
         bgr.y = 0;
         textName = new Text(35,8);
         textName.text = obj.name;
         textName.color = 6710886;
         textName.size = 12;
         textQuantity = new Text(0,5);
         textQuantity.text = quantity.toString();
         textQuantity.color = 16777215;
         textQuantity.size = 16;
         textQuantity.alignRight();
         textQuantity.x = 220;
         obj2 = {};
         obj2 = {
            "obj":obj,
            "itemContainer":itemContainer,
            "bgr":bgr,
            "textName":textName,
            "textQuantity":textQuantity,
            "quantity":quantity,
            "selected":false
         };
         if(useTween)
         {
            obj2.quantity = 0;
            TweenMax.to(obj2,1 + 8 * (1 - 1000 / (1000 + quantity)),{
               "quantity":quantity,
               "onUpdate":function():void
               {
                  textQuantity.text = int(obj2.quantity).toString();
               },
               "onComplete":function():void
               {
                  recycledItems++;
                  if(recycledItems == mineralTextItems.length)
                  {
                     recycling = false;
                     takeButton.enabled = true;
                     if(myCargo.spaceJunkCount > 0)
                     {
                        selectAllButton.enabled = true;
                     }
                  }
               }
            });
         }
         if(type == "mineral")
         {
            mineralTextItems.push(obj2);
         }
         else
         {
            junkTextItems.push(obj2);
            if(quantity > 0)
            {
               itemContainer.useHandCursor = true;
               itemContainer.addEventListener("touch",createTouch(obj2));
            }
            else
            {
               textName.color = 4473924;
               textQuantity.color = 4473924;
            }
         }
         itemBmp = new Image(textureManager.getTextureGUIByKey(obj.bitmap));
         itemBmp.x = 10;
         itemBmp.y = 15 - itemBmp.height / 2;
         itemContainer.addChild(bgr);
         itemContainer.addChild(itemBmp);
         itemContainer.addChild(textName);
         itemContainer.addChild(textQuantity);
         return itemContainer;
      }
      
      private function playRecycleLoop() : void
      {
         if(!recycling)
         {
            return;
         }
         soundManager.play("akOV-VmtrUK-k5pYruy76g",null,function():void
         {
            playRecycleLoop();
         });
      }
      
      private function createTouch(param1:Object) : Function
      {
         var obj2:Object = param1;
         return function(param1:TouchEvent):void
         {
            var _loc3_:ColorMatrixFilter = null;
            var _loc2_:ColorMatrixFilter = null;
            if(recycling)
            {
               return;
            }
            if(param1.getTouch(obj2.itemContainer,"ended"))
            {
               obj2.selected = !!obj2.selected ? false : true;
               if(obj2.selected)
               {
                  recycleButton.enabled = true;
                  _loc3_ = new ColorMatrixFilter();
                  _loc3_.adjustBrightness(0.2);
                  obj2.itemContainer.filter = _loc3_;
               }
               else
               {
                  recycleButton.enabled = false;
                  for each(var _loc4_ in junkTextItems)
                  {
                     if(_loc4_.selected)
                     {
                        recycleButton.enabled = true;
                     }
                  }
                  if(obj2.itemContainer.filter)
                  {
                     obj2.itemContainer.filter.dispose();
                     obj2.itemContainer.filter = null;
                  }
               }
            }
            else if(param1.interactsWith(obj2.itemContainer))
            {
               if(obj2.itemContainer.filter == null)
               {
                  _loc2_ = new ColorMatrixFilter();
                  _loc2_.adjustBrightness(0.1);
                  obj2.itemContainer.filter = _loc2_;
               }
            }
            else if(!obj2.selected && obj2.itemContainer.filter)
            {
               obj2.itemContainer.filter.dispose();
               obj2.itemContainer.filter = null;
            }
         };
      }
      
      private function recycle(param1:ImageButton) : void
      {
         var _loc4_:ISound;
         (_loc4_ = SoundLocator.getService()).play("BWHiEHVtwkC56EUUiGainw");
         recycling = true;
         recycledItems = 0;
         playRecycleLoop();
         selectAllButton.enabled = false;
         recycleButton.enabled = false;
         removeMinerals();
         var _loc3_:Message = g.createMessage("recycleJunk");
         for each(var _loc2_ in junkTextItems)
         {
            if(_loc2_.selected)
            {
               _loc3_.add(_loc2_.obj.key);
            }
         }
         ButtonCargo.serverSaysCargoIsFull = false;
         g.rpcMessage(_loc3_,junkRecycled);
      }
      
      private function junkRecycled(param1:Message) : void
      {
         var _loc2_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:String = null;
         var _loc5_:int = 0;
         var _loc4_:Object = null;
         for each(var _loc6_ in junkTextItems)
         {
            if(_loc6_.selected)
            {
               tweenReduceJunk(_loc6_);
               myCargo.removeJunk(_loc6_.obj.key,_loc6_.quantity);
            }
         }
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            _loc3_ = param1.getString(_loc7_);
            _loc5_ = param1.getInt(_loc7_ + 1);
            _loc4_ = dataManager.loadKey("Commodities",_loc3_);
            scrollContainer2.addChild(createItem(_loc4_,"mineral",_loc5_,_loc2_,true));
            myCargo.addItem("Commodities",_loc3_,_loc5_);
            _loc7_ += 2;
            _loc2_++;
         }
         if(onboardRecycle)
         {
            g.me.fakeRoaming();
            g.hud.cargoButton.update();
         }
      }
      
      private function tweenReduceJunk(param1:Object) : void
      {
         var obj:Object = param1;
         var textName:Text = obj.textName;
         var textQuantity:Text = obj.textQuantity;
         var itemObj:Object = obj.obj;
         TweenMax.to(obj,1 + 8 * (1 - 1000 / (1000 + obj.quantity)),{
            "quantity":0,
            "onUpdate":function():void
            {
               textQuantity.text = int(obj.quantity).toString();
            }
         });
         textName.color = 4473924;
         textQuantity.color = 4473924;
         obj.selected = false;
         if(obj.itemContainer.filter)
         {
            obj.itemContainer.filter.dispose();
            obj.itemContainer.filter = null;
         }
         obj.itemContainer.useHandCursor = false;
         obj.itemContainer.removeEventListeners();
      }
      
      private function removeMinerals(param1:Event = null) : void
      {
         var mineralObj:Object;
         var e:Event = param1;
         for each(mineralObj in mineralTextItems)
         {
            TweenMax.fromTo(mineralObj.itemContainer,1,{
               "alpha":1,
               "y":mineralObj.itemContainer.y
            },{
               "alpha":0,
               "y":mineralObj.itemContainer.y + 200,
               "onComplete":function():void
               {
                  removeChild(mineralObj.itemContainer);
               }
            });
         }
         if(mineralTextItems.length > 0)
         {
            SoundLocator.getService().play("7zeIcPFb-UWzgtR_3nrZ8Q");
         }
         mineralTextItems.splice(0,mineralTextItems.length);
      }
      
      private function selectAllJunk(param1:Event = null) : void
      {
         var _loc2_:ColorMatrixFilter = null;
         for each(var _loc3_ in junkTextItems)
         {
            if(_loc3_.quantity > 0)
            {
               soundManager.play("BWHiEHVtwkC56EUUiGainw");
               _loc3_.selected = true;
               _loc2_ = new ColorMatrixFilter();
               _loc2_.adjustBrightness(0.2);
               _loc3_.itemContainer.filter = _loc2_;
               recycleButton.enabled = true;
            }
         }
      }
   }
}
