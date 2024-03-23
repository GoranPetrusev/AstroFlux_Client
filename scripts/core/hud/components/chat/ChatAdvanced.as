package core.hud.components.chat
{
   import core.scene.Game;
   import feathers.controls.Label;
   import feathers.controls.ScrollContainer;
   import feathers.controls.List;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.controls.renderers.DefaultListItemRenderer;
   import feathers.controls.text.BitmapFontTextRenderer;
   import feathers.controls.text.TextFieldTextRenderer;
   import feathers.text.BitmapFontTextFormat;
   import feathers.core.ITextRenderer;
   import feathers.layout.VerticalLayout;
   import feathers.data.ListCollection;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.text.TextFormat;
   
   public class ChatAdvanced extends Sprite
   {
       
      
      private var g:Game;
      
      private var scrollView:Sprite;
      
      private var scroll:ScrollContainer;

      public var listScroll:List;
      
      private var playerChatOptions:PlayerChatOptions;
      
      public function ChatAdvanced(param1:Game)
      {
         super();
         this.g = param1;
         var _loc6_:int = 300;
         var _loc2_:int = 300;
         var _loc5_:int = 10;
         scrollView = new Sprite();
         var _loc3_:Quad = new Quad(_loc6_,_loc2_,0);
         _loc3_.alpha = 0.6;
         scrollView.addChild(_loc3_);
         var _loc4_:VerticalLayout = new VerticalLayout(); 
         scroll = new ScrollContainer();
         scroll.layout = _loc4_;
         scroll.x = _loc5_;
         scroll.y = _loc5_;
         scroll.width = _loc6_ - _loc5_;
         scroll.height = _loc2_ - scroll.y;
         scrollView.addChild(scroll);
         addChild(scrollView);

         listScroll = new List();
         listScroll.x = _loc5_;
         listScroll.y = _loc5_;
         listScroll.width = _loc6_ - _loc5_;
         listScroll.height = _loc2_ - scroll.y;

         listScroll.itemRendererFactory = function():IListItemRenderer
         {
            var itemRederer:DefaultListItemRenderer = new DefaultListItemRenderer();
            itemRederer.labelField = "text";
            itemRederer.labelFactory = function():ITextRenderer
            {
               var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
               textRenderer.isHTML = true;
               textRenderer.textFormat = new TextFormat("Verdana", 12, 0x000000);
               return textRenderer;
            }
            return itemRederer;
         }

         scrollView.addChild(listScroll);

         addEventListener("addedToStage",load);
         addEventListener("removedFromStage",unload);
      }
      
      private function load(param1:Event) : void
      {
         var obj:Object;
         var e:Event = param1;
         var textQueue:Vector.<Object> = g.messageLog.getQueue();
         for each(obj in textQueue)
         {
            addText(obj);
         }
         Starling.juggler.delayCall((function():*
         {
            var later:Function;
            return later = function():void
            {
               scroll.scrollToPosition(0,scroll.maxVerticalScrollPosition,0);
            };
         })(),0.2);
      }
      
      private function unload(param1:Event) : void
      {
         scroll.removeChildren(0,-1,true);
      }
      
      public function updateText(param1:Object) : void
      {
         var obj:Object = param1;
         var textQueue:Vector.<Object> = g.messageLog.getQueue();
         listScroll.dataProvider = new ListCollection(textQueue);
         if(textQueue.length == 0)
         {
            return;
         }
         if(textQueue.indexOf(obj) === -1)
         {
            return;
         }
         addText(obj);
         if(scroll.verticalScrollPosition == scroll.maxVerticalScrollPosition)
         {
            Starling.juggler.delayCall((function():*
            {
               var later:Function;
               return later = function():void
               {
                  scroll.scrollToPosition(0,scroll.maxVerticalScrollPosition,0);
               };
            })(),0.2);
         }
      }
      
      private function addText(param1:Object) : void
      {
         var tf:Label;
         var obj:Object = param1;
         var text:String = obj.text as String;
         if(text == null || text.length == 0 || text.charAt(0) == "/")
         {
            return;
         }
         tf = new Label();
         tf.styleName = "chat";
         tf.text = text;
         tf.width = scroll.width - 10;
         if(scroll.numChildren > MessageLog.extendedMaxLines)
         {
            scroll.removeChildAt(0,true);
         }
         scroll.addChild(tf);
         if(obj.playerKey && obj.playerKey != g.me.id)
         {
            tf.useHandCursor = true;
            tf.touchable = true;
            tf.addEventListener("touch",function(param1:TouchEvent):void
            {
               var _loc2_:int = 0;
               if(param1.getTouch(tf,"ended"))
               {
                  if(playerChatOptions)
                  {
                     scroll.removeChild(playerChatOptions,true);
                  }
                  _loc2_ = scroll.getChildIndex(tf);
                  playerChatOptions = new PlayerChatOptions(g,obj);
                  scroll.addChildAt(playerChatOptions,_loc2_ + 1);
               }
            });
         }
      }
      
      override public function dispose() : void
      {
         removeEventListeners();
         scroll.removeChildren(0,-1,true);
         super.dispose();
      }
   }
}
