package core.hud.components.chat
{
   import core.scene.Game;
   import feathers.controls.List;
   import feathers.layout.VerticalLayout;
   import feathers.layout.HorizontalAlign;
   import feathers.data.ListCollection;
   import starling.core.Starling;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class ChatAdvanced extends Sprite
   {
      
      private var g:Game;
            
      private var listData:ListCollection;

      private var listScroll:List;

      private var isMaxScrollPosition:Boolean = false;
      
      public function ChatAdvanced(game:Game)
      {
         super();
         this.g = game;

         listData = new ListCollection();
         listScroll = new List();

         var layout:VerticalLayout = new VerticalLayout();
         layout.hasVariableItemDimensions = true;
         layout.horizontalAlign = HorizontalAlign.JUSTIFY;
         layout.paddingBottom = 1;
         listScroll.layout = layout;
         listScroll.layout.useVirtualLayout = true;
 
         listScroll.x = 10;
         listScroll.y = 10;
         listScroll.width = 400;
         listScroll.height = 300;

         listScroll.dataProvider = listData;
         listScroll.styleName = "chat";
         listScroll.itemRendererType = ChatItemRenderer;

         addChild(listScroll);

         listScroll.addEventListener("scrollStart", onScrollStart);
         listScroll.addEventListener("scrollComplete", onScrollComplete);
         listScroll.addEventListener("scroll", onNewMessage);
      }

      private function onScrollStart(event:Event) : void
      {
         isMaxScrollPosition = false;
      }
      
      private function onScrollComplete(event:Event) : void
      {
         isMaxScrollPosition = (event.currentTarget.verticalScrollPosition == event.currentTarget.maxVerticalScrollPosition);
      }

      private function onNewMessage(event:Event) : void
      {
         if(isMaxScrollPosition)
         {
            event.currentTarget.scrollToPosition(0, event.currentTarget.maxVerticalScrollPosition, 0.15);
         }
      }

      private function load(event:Event) : void
      {
         var obj:Object;
         var textQueue:Vector.<Object> = g.messageLog.getQueue();
         for each(obj in textQueue)
         {
            if(listData.length > MessageLog.extendedMaxLines)
            {
               break;
            }
            listData.addItem({contents: obj.text});
         }
         Starling.juggler.delayCall((function():*
         {
            var later:Function;
            return later = function():void
            {
               listScroll.scrollToPosition(0, listScroll.maxVerticalScrollPosition, 0.05);
            };
         })(),0.05);
      }
      
      private function unload(param1:Event) : void
      {
         listData.removeAll();
      }

      public function reload() : void
      {
         unload(null);
         load(null);
      }
      
      public function updateText(param1:Object) : void
      {
         var obj:Object = param1;
         var textQueue:Vector.<Object> = g.messageLog.getQueue();
         if(textQueue.length == 0 || textQueue.indexOf(obj) === -1)
         {
            return;
         }
         if(listData.length > MessageLog.extendedMaxLines)
         {
            listData.removeItemAt(0);
         }
         listData.addItem({contents: obj.text});
      }
            
      override public function dispose() : void
      {
         removeEventListeners();
         listData.removeAll();
         super.dispose();
      }
   }
}
