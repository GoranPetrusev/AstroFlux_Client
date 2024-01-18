package feathers.utils.touch
{
   import feathers.core.IToggle;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class TapToSelect
   {
      
      private static const HELPER_POINT:Point = new Point();
       
      
      protected var _target:IToggle;
      
      protected var _touchPointID:int = -1;
      
      protected var _isEnabled:Boolean = true;
      
      protected var _tapToDeselect:Boolean = false;
      
      public function TapToSelect(param1:IToggle = null)
      {
         super();
         this.target = param1;
      }
      
      public function get target() : IToggle
      {
         return this._target;
      }
      
      public function set target(param1:IToggle) : void
      {
         if(this._target == param1)
         {
            return;
         }
         if(this._target)
         {
            this._target.removeEventListener("touch",target_touchHandler);
         }
         this._target = param1;
         if(this._target)
         {
            this._touchPointID = -1;
            this._target.addEventListener("touch",target_touchHandler);
         }
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         if(this._isEnabled === param1)
         {
            return;
         }
         this._isEnabled = param1;
         if(!param1)
         {
            this._touchPointID = -1;
         }
      }
      
      public function get tapToDeselect() : Boolean
      {
         return this._tapToDeselect;
      }
      
      public function set tapToDeselect(param1:Boolean) : void
      {
         this._tapToDeselect = param1;
      }
      
      protected function target_touchHandler(param1:TouchEvent) : void
      {
         var _loc4_:Touch = null;
         var _loc2_:Stage = null;
         var _loc3_:* = false;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            if(!(_loc4_ = param1.getTouch(DisplayObject(this._target),null,this._touchPointID)))
            {
               return;
            }
            if(_loc4_.phase == "ended")
            {
               _loc2_ = this._target.stage;
               if(_loc2_ !== null)
               {
                  _loc4_.getLocation(_loc2_,HELPER_POINT);
                  if(this._target is DisplayObjectContainer)
                  {
                     _loc3_ = Boolean(DisplayObjectContainer(this._target).contains(_loc2_.hitTest(HELPER_POINT)));
                  }
                  else
                  {
                     _loc3_ = this._target === _loc2_.hitTest(HELPER_POINT);
                  }
                  if(_loc3_)
                  {
                     if(this._tapToDeselect)
                     {
                        this._target.isSelected = !this._target.isSelected;
                     }
                     else
                     {
                        this._target.isSelected = true;
                     }
                  }
               }
               this._touchPointID = -1;
            }
            return;
         }
         if(!(_loc4_ = param1.getTouch(DisplayObject(this._target),"began")))
         {
            return;
         }
         this._touchPointID = _loc4_.id;
      }
   }
}
