package feathers.controls.popups
{
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import flash.errors.IllegalOperationError;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.ResizeEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class VerticalCenteredPopUpContentManager extends EventDispatcher implements IPopUpContentManager
   {
      
      private static const HELPER_POINT:Point = new Point();
       
      
      public var marginTop:Number = 0;
      
      public var marginRight:Number = 0;
      
      public var marginBottom:Number = 0;
      
      public var marginLeft:Number = 0;
      
      protected var _overlayFactory:Function = null;
      
      protected var content:DisplayObject;
      
      protected var touchPointID:int = -1;
      
      public function VerticalCenteredPopUpContentManager()
      {
         super();
      }
      
      public function get margin() : Number
      {
         return this.marginTop;
      }
      
      public function set margin(param1:Number) : void
      {
         this.marginTop = 0;
         this.marginRight = 0;
         this.marginBottom = 0;
         this.marginLeft = 0;
      }
      
      public function get overlayFactory() : Function
      {
         return this._overlayFactory;
      }
      
      public function set overlayFactory(param1:Function) : void
      {
         this._overlayFactory = param1;
      }
      
      public function get isOpen() : Boolean
      {
         return this.content !== null;
      }
      
      public function open(param1:DisplayObject, param2:DisplayObject) : void
      {
         if(this.isOpen)
         {
            throw new IllegalOperationError("Pop-up content is already open. Close the previous content before opening new content.");
         }
         this.content = param1;
         PopUpManager.addPopUp(this.content,true,false,this._overlayFactory);
         if(this.content is IFeathersControl)
         {
            this.content.addEventListener("resize",content_resizeHandler);
         }
         this.content.addEventListener("removedFromStage",content_removedFromStageHandler);
         this.layout();
         var _loc3_:Stage = Starling.current.stage;
         _loc3_.addEventListener("touch",stage_touchHandler);
         _loc3_.addEventListener("resize",stage_resizeHandler);
         var _loc4_:int = -getDisplayObjectDepthFromStage(this.content);
         Starling.current.nativeStage.addEventListener("keyDown",nativeStage_keyDownHandler,false,_loc4_,true);
         this.dispatchEventWith("open");
      }
      
      public function close() : void
      {
         if(!this.isOpen)
         {
            return;
         }
         var _loc2_:DisplayObject = this.content;
         this.content = null;
         var _loc1_:Stage = Starling.current.stage;
         _loc1_.removeEventListener("touch",stage_touchHandler);
         _loc1_.removeEventListener("resize",stage_resizeHandler);
         Starling.current.nativeStage.removeEventListener("keyDown",nativeStage_keyDownHandler);
         if(_loc2_ is IFeathersControl)
         {
            _loc2_.removeEventListener("resize",content_resizeHandler);
         }
         _loc2_.removeEventListener("removedFromStage",content_removedFromStageHandler);
         if(_loc2_.parent)
         {
            _loc2_.removeFromParent(false);
         }
         this.dispatchEventWith("close");
      }
      
      public function dispose() : void
      {
         this.close();
      }
      
      protected function layout() : void
      {
         var _loc3_:IFeathersControl = null;
         var _loc2_:Stage = Starling.current.stage;
         var _loc5_:Number;
         if((_loc5_ = _loc2_.stageWidth) > _loc2_.stageHeight)
         {
            _loc5_ = _loc2_.stageHeight;
         }
         _loc5_ -= this.marginLeft + this.marginRight;
         var _loc4_:Number = _loc2_.stageHeight - this.marginTop - this.marginBottom;
         var _loc1_:Boolean = false;
         if(this.content is IFeathersControl)
         {
            _loc3_ = IFeathersControl(this.content);
            _loc3_.minWidth = _loc5_;
            _loc3_.maxWidth = _loc5_;
            _loc3_.maxHeight = _loc4_;
            _loc1_ = true;
         }
         if(this.content is IValidating)
         {
            IValidating(this.content).validate();
         }
         if(!_loc1_)
         {
            if(this.content.width > _loc5_)
            {
               this.content.width = _loc5_;
            }
            if(this.content.height > _loc4_)
            {
               this.content.height = _loc4_;
            }
         }
         this.content.x = Math.round((_loc2_.stageWidth - this.content.width) / 2);
         this.content.y = Math.round((_loc2_.stageHeight - this.content.height) / 2);
      }
      
      protected function content_resizeHandler(param1:Event) : void
      {
         this.layout();
      }
      
      protected function content_removedFromStageHandler(param1:Event) : void
      {
         this.close();
      }
      
      protected function nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(param1.keyCode != 16777238 && param1.keyCode != 27)
         {
            return;
         }
         param1.preventDefault();
         this.close();
      }
      
      protected function stage_resizeHandler(param1:ResizeEvent) : void
      {
         this.layout();
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc4_:Touch = null;
         var _loc5_:DisplayObject = null;
         var _loc3_:* = false;
         if(!PopUpManager.isTopLevelPopUp(this.content))
         {
            return;
         }
         var _loc2_:Stage = Starling.current.stage;
         if(this.touchPointID >= 0)
         {
            if(!(_loc4_ = param1.getTouch(_loc2_,"ended",this.touchPointID)))
            {
               return;
            }
            _loc4_.getLocation(_loc2_,HELPER_POINT);
            _loc5_ = _loc2_.hitTest(HELPER_POINT);
            _loc3_ = false;
            if(this.content is DisplayObjectContainer)
            {
               _loc3_ = Boolean(DisplayObjectContainer(this.content).contains(_loc5_));
            }
            else
            {
               _loc3_ = this.content == _loc5_;
            }
            if(!_loc3_)
            {
               this.touchPointID = -1;
               this.close();
            }
         }
         else
         {
            if(!(_loc4_ = param1.getTouch(_loc2_,"began")))
            {
               return;
            }
            _loc4_.getLocation(_loc2_,HELPER_POINT);
            _loc5_ = _loc2_.hitTest(HELPER_POINT);
            _loc3_ = false;
            if(this.content is DisplayObjectContainer)
            {
               _loc3_ = Boolean(DisplayObjectContainer(this.content).contains(_loc5_));
            }
            else
            {
               _loc3_ = this.content == _loc5_;
            }
            if(_loc3_)
            {
               return;
            }
            this.touchPointID = _loc4_.id;
         }
      }
   }
}
