package feathers.utils.keyboard
{
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IToggle;
   import starling.display.Stage;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   
   public class KeyToSelect
   {
       
      
      protected var _target:IToggle;
      
      protected var _keyCode:uint = 32;
      
      protected var _cancelKeyCode:uint = 27;
      
      protected var _keyToDeselect:Boolean = false;
      
      protected var _isEnabled:Boolean = true;
      
      public function KeyToSelect(param1:IToggle = null)
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
         if(this._target === param1)
         {
            return;
         }
         if(!(param1 is IFocusDisplayObject))
         {
            throw new ArgumentError("Target of KeyToSelect must implement IFocusDisplayObject");
         }
         if(this._target)
         {
            this._target.removeEventListener("focusIn",target_focusInHandler);
            this._target.removeEventListener("focusOut",target_focusOutHandler);
            this._target.removeEventListener("removedFromStage",target_removedFromStageHandler);
         }
         this._target = param1;
         if(this._target)
         {
            this._target.addEventListener("focusIn",target_focusInHandler);
            this._target.addEventListener("focusOut",target_focusOutHandler);
            this._target.addEventListener("removedFromStage",target_removedFromStageHandler);
         }
      }
      
      public function get keyCode() : uint
      {
         return this._keyCode;
      }
      
      public function set keyCode(param1:uint) : void
      {
         this._keyCode = param1;
      }
      
      public function get cancelKeyCode() : uint
      {
         return this._cancelKeyCode;
      }
      
      public function set cancelKeyCode(param1:uint) : void
      {
         this._cancelKeyCode = param1;
      }
      
      public function get keyToDeselect() : Boolean
      {
         return this._keyToDeselect;
      }
      
      public function set keyToDeselect(param1:Boolean) : void
      {
         this._keyToDeselect = param1;
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         this._isEnabled = param1;
      }
      
      protected function target_focusInHandler(param1:Event) : void
      {
         this._target.stage.addEventListener("keyDown",stage_keyDownHandler);
      }
      
      protected function target_focusOutHandler(param1:Event) : void
      {
         this._target.stage.removeEventListener("keyDown",stage_keyDownHandler);
         this._target.stage.removeEventListener("keyUp",stage_keyUpHandler);
      }
      
      protected function target_removedFromStageHandler(param1:Event) : void
      {
         this._target.stage.removeEventListener("keyDown",stage_keyDownHandler);
         this._target.stage.removeEventListener("keyUp",stage_keyUpHandler);
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this._isEnabled)
         {
            return;
         }
         if(param1.keyCode === this._cancelKeyCode)
         {
            this._target.stage.removeEventListener("keyUp",stage_keyUpHandler);
         }
         else if(param1.keyCode === this._keyCode)
         {
            this._target.stage.addEventListener("keyUp",stage_keyUpHandler);
         }
      }
      
      protected function stage_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!this._isEnabled)
         {
            return;
         }
         if(param1.keyCode !== this._keyCode)
         {
            return;
         }
         var _loc2_:Stage = Stage(param1.currentTarget);
         _loc2_.removeEventListener("keyUp",stage_keyUpHandler);
         if(this._target.stage !== _loc2_)
         {
            return;
         }
         if(this._keyToDeselect)
         {
            this._target.isSelected = !this._target.isSelected;
         }
         else
         {
            this._target.isSelected = true;
         }
      }
   }
}
