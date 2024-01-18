package feathers.media
{
   import feathers.controls.LayoutGroup;
   import feathers.layout.AnchorLayout;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.errors.AbstractClassError;
   import starling.events.Event;
   
   public class BaseMediaPlayer extends LayoutGroup implements IMediaPlayer
   {
       
      
      public function BaseMediaPlayer()
      {
         super();
         if(Object(this).constructor === BaseMediaPlayer)
         {
            throw new AbstractClassError();
         }
         this.addEventListener("added",mediaPlayer_addedHandler);
         this.addEventListener("removed",mediaPlayer_removedHandler);
      }
      
      override protected function initialize() : void
      {
         if(!this._layout)
         {
            this.layout = new AnchorLayout();
         }
         super.initialize();
      }
      
      protected function handleAddedChild(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         if(param1 is IMediaPlayerControl)
         {
            IMediaPlayerControl(param1).mediaPlayer = this;
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc2_ = DisplayObjectContainer(param1);
            _loc4_ = _loc2_.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               param1 = _loc2_.getChildAt(_loc3_);
               this.handleAddedChild(param1);
               _loc3_++;
            }
         }
      }
      
      protected function handleRemovedChild(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         if(param1 is IMediaPlayerControl)
         {
            IMediaPlayerControl(param1).mediaPlayer = null;
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc2_ = DisplayObjectContainer(param1);
            _loc4_ = _loc2_.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               param1 = _loc2_.getChildAt(_loc3_);
               this.handleRemovedChild(param1);
               _loc3_++;
            }
         }
      }
      
      protected function mediaPlayer_addedHandler(param1:Event) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         this.handleAddedChild(_loc2_);
      }
      
      protected function mediaPlayer_removedHandler(param1:Event) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         this.handleRemovedChild(_loc2_);
      }
   }
}
