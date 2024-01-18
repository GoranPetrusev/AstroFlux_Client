package feathers.core
{
   import feathers.controls.supportClasses.LayoutViewPort;
   import feathers.utils.display.stageToStarling;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.events.FocusEvent;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class DefaultFocusManager implements IFocusManager
   {
      
      protected static var NATIVE_STAGE_TO_FOCUS_TARGET:Dictionary = new Dictionary(true);
       
      
      protected var _starling:Starling;
      
      protected var _nativeFocusTarget:NativeFocusTarget;
      
      protected var _root:DisplayObjectContainer;
      
      protected var _isEnabled:Boolean = false;
      
      protected var _savedFocus:IFocusDisplayObject;
      
      protected var _focus:IFocusDisplayObject;
      
      public function DefaultFocusManager(param1:DisplayObjectContainer)
      {
         super();
         if(!param1.stage)
         {
            throw new ArgumentError("Focus manager root must be added to the stage.");
         }
         this._root = param1;
         this._starling = stageToStarling(param1.stage);
      }
      
      public function get root() : DisplayObjectContainer
      {
         return this._root;
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         if(this._isEnabled == param1)
         {
            return;
         }
         this._isEnabled = param1;
         if(this._isEnabled)
         {
            this._nativeFocusTarget = NATIVE_STAGE_TO_FOCUS_TARGET[this._starling.nativeStage] as NativeFocusTarget;
            if(!this._nativeFocusTarget)
            {
               this._nativeFocusTarget = new NativeFocusTarget();
               this._starling.nativeStage.addChild(_nativeFocusTarget);
            }
            else
            {
               this._nativeFocusTarget.referenceCount++;
            }
            this.setFocusManager(this._root);
            this._root.addEventListener("added",topLevelContainer_addedHandler);
            this._root.addEventListener("removed",topLevelContainer_removedHandler);
            this._root.addEventListener("touch",topLevelContainer_touchHandler);
            this._starling.nativeStage.addEventListener("keyFocusChange",stage_keyFocusChangeHandler,false,0,true);
            this._starling.nativeStage.addEventListener("mouseFocusChange",stage_mouseFocusChangeHandler,false,0,true);
            if(this._savedFocus && !this._savedFocus.stage)
            {
               this._savedFocus = null;
            }
            this.focus = this._savedFocus;
            this._savedFocus = null;
         }
         else
         {
            this._nativeFocusTarget.referenceCount--;
            if(this._nativeFocusTarget.referenceCount <= 0)
            {
               this._nativeFocusTarget.parent.removeChild(this._nativeFocusTarget);
               delete NATIVE_STAGE_TO_FOCUS_TARGET[this._starling.nativeStage];
            }
            this._nativeFocusTarget = null;
            this._root.removeEventListener("added",topLevelContainer_addedHandler);
            this._root.removeEventListener("removed",topLevelContainer_removedHandler);
            this._root.removeEventListener("touch",topLevelContainer_touchHandler);
            this._starling.nativeStage.removeEventListener("keyFocusChange",stage_keyFocusChangeHandler);
            this._starling.nativeStage.addEventListener("mouseFocusChange",stage_mouseFocusChangeHandler);
            _loc2_ = this.focus;
            this.focus = null;
            this._savedFocus = _loc2_;
         }
      }
      
      public function get focus() : IFocusDisplayObject
      {
         return this._focus;
      }
      
      public function set focus(param1:IFocusDisplayObject) : void
      {
         var _loc6_:Object = null;
         var _loc5_:IAdvancedNativeFocusOwner = null;
         if(this._focus === param1)
         {
            return;
         }
         var _loc3_:Boolean = false;
         var _loc4_:IFeathersDisplayObject = this._focus;
         if(this._isEnabled && param1 !== null && param1.isFocusEnabled && param1.focusManager === this)
         {
            this._focus = param1;
            _loc3_ = true;
         }
         else
         {
            this._focus = null;
         }
         var _loc2_:Stage = this._starling.nativeStage;
         if(_loc4_ is INativeFocusOwner)
         {
            if((_loc6_ = INativeFocusOwner(_loc4_).nativeFocus) === null && _loc2_ !== null)
            {
               _loc6_ = _loc2_.focus;
            }
            if(_loc6_ is IEventDispatcher)
            {
               IEventDispatcher(_loc6_).removeEventListener("focusOut",nativeFocus_focusOutHandler);
            }
         }
         if(_loc4_ !== null)
         {
            _loc4_.dispatchEventWith("focusOut");
         }
         if(_loc3_ && this._focus !== param1)
         {
            return;
         }
         if(this._isEnabled)
         {
            if(this._focus !== null)
            {
               _loc6_ = null;
               if(this._focus is INativeFocusOwner)
               {
                  if((_loc6_ = INativeFocusOwner(this._focus).nativeFocus) is InteractiveObject)
                  {
                     _loc2_.focus = InteractiveObject(_loc6_);
                  }
                  else if(_loc6_ !== null)
                  {
                     if(!(this._focus is IAdvancedNativeFocusOwner))
                     {
                        throw new IllegalOperationError("If nativeFocus does not return an InteractiveObject, class must implement IAdvancedNativeFocusOwner interface");
                     }
                     if(!(_loc5_ = IAdvancedNativeFocusOwner(this._focus)).hasFocus)
                     {
                        _loc5_.setFocus();
                     }
                  }
               }
               if(_loc6_ === null)
               {
                  _loc6_ = this._nativeFocusTarget;
                  _loc2_.focus = this._nativeFocusTarget;
               }
               if(_loc6_ is IEventDispatcher)
               {
                  IEventDispatcher(_loc6_).addEventListener("focusOut",nativeFocus_focusOutHandler,false,0,true);
               }
               this._focus.dispatchEventWith("focusIn");
            }
            else
            {
               _loc2_.focus = null;
            }
         }
         else
         {
            this._savedFocus = param1;
         }
      }
      
      protected function setFocusManager(param1:DisplayObject) : void
      {
         var _loc3_:IFocusDisplayObject = null;
         var _loc2_:DisplayObjectContainer = null;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc7_:IFocusExtras = null;
         var _loc5_:* = undefined;
         if(param1 is IFocusDisplayObject)
         {
            _loc3_ = IFocusDisplayObject(param1);
            _loc3_.focusManager = this;
         }
         if(param1 is DisplayObjectContainer && !(param1 is IFocusDisplayObject) || param1 is IFocusContainer && Boolean(IFocusContainer(param1).isChildFocusEnabled))
         {
            _loc2_ = DisplayObjectContainer(param1);
            _loc6_ = _loc2_.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               _loc8_ = _loc2_.getChildAt(_loc4_);
               this.setFocusManager(_loc8_);
               _loc4_++;
            }
            if(_loc2_ is IFocusExtras)
            {
               if(_loc5_ = (_loc7_ = IFocusExtras(_loc2_)).focusExtrasBefore)
               {
                  _loc6_ = int(_loc5_.length);
                  _loc4_ = 0;
                  while(_loc4_ < _loc6_)
                  {
                     _loc8_ = _loc5_[_loc4_];
                     this.setFocusManager(_loc8_);
                     _loc4_++;
                  }
               }
               if(_loc5_ = _loc7_.focusExtrasAfter)
               {
                  _loc6_ = int(_loc5_.length);
                  _loc4_ = 0;
                  while(_loc4_ < _loc6_)
                  {
                     _loc8_ = _loc5_[_loc4_];
                     this.setFocusManager(_loc8_);
                     _loc4_++;
                  }
               }
            }
         }
      }
      
      protected function clearFocusManager(param1:DisplayObject) : void
      {
         var _loc3_:IFocusDisplayObject = null;
         var _loc2_:DisplayObjectContainer = null;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc7_:IFocusExtras = null;
         var _loc5_:* = undefined;
         if(param1 is IFocusDisplayObject)
         {
            _loc3_ = IFocusDisplayObject(param1);
            if(_loc3_.focusManager == this)
            {
               if(this._focus == _loc3_)
               {
                  this.focus = _loc3_.focusOwner;
               }
               _loc3_.focusManager = null;
            }
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc2_ = DisplayObjectContainer(param1);
            _loc6_ = _loc2_.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               _loc8_ = _loc2_.getChildAt(_loc4_);
               this.clearFocusManager(_loc8_);
               _loc4_++;
            }
            if(_loc2_ is IFocusExtras)
            {
               if(_loc5_ = (_loc7_ = IFocusExtras(_loc2_)).focusExtrasBefore)
               {
                  _loc6_ = int(_loc5_.length);
                  _loc4_ = 0;
                  while(_loc4_ < _loc6_)
                  {
                     _loc8_ = _loc5_[_loc4_];
                     this.clearFocusManager(_loc8_);
                     _loc4_++;
                  }
               }
               if(_loc5_ = _loc7_.focusExtrasAfter)
               {
                  _loc6_ = int(_loc5_.length);
                  _loc4_ = 0;
                  while(_loc4_ < _loc6_)
                  {
                     _loc8_ = _loc5_[_loc4_];
                     this.clearFocusManager(_loc8_);
                     _loc4_++;
                  }
               }
            }
         }
      }
      
      protected function findPreviousContainerFocus(param1:DisplayObjectContainer, param2:DisplayObject, param3:Boolean) : IFocusDisplayObject
      {
         var _loc8_:IFocusExtras = null;
         var _loc9_:* = undefined;
         var _loc11_:* = false;
         var _loc7_:int = 0;
         var _loc10_:* = 0;
         var _loc12_:DisplayObject = null;
         var _loc5_:IFocusDisplayObject = null;
         var _loc6_:IFocusDisplayObject = null;
         if(param1 is LayoutViewPort)
         {
            param1 = param1.parent;
         }
         var _loc4_:* = param2 == null;
         if(param1 is IFocusExtras)
         {
            if(_loc9_ = (_loc8_ = IFocusExtras(param1)).focusExtrasAfter)
            {
               _loc11_ = false;
               if(param2)
               {
                  _loc11_ = !(_loc4_ = (_loc7_ = _loc9_.indexOf(param2) - 1) >= -1);
               }
               else
               {
                  _loc7_ = _loc9_.length - 1;
               }
               if(!_loc11_)
               {
                  _loc10_ = _loc7_;
                  while(_loc10_ >= 0)
                  {
                     _loc12_ = _loc9_[_loc10_];
                     _loc5_ = this.findPreviousChildFocus(_loc12_);
                     if(this.isValidFocus(_loc5_))
                     {
                        return _loc5_;
                     }
                     _loc10_--;
                  }
               }
            }
         }
         if(param2 && !_loc4_)
         {
            _loc4_ = (_loc7_ = param1.getChildIndex(param2) - 1) >= -1;
         }
         else
         {
            _loc7_ = param1.numChildren - 1;
         }
         _loc10_ = _loc7_;
         while(_loc10_ >= 0)
         {
            _loc12_ = param1.getChildAt(_loc10_);
            _loc5_ = this.findPreviousChildFocus(_loc12_);
            if(this.isValidFocus(_loc5_))
            {
               return _loc5_;
            }
            _loc10_--;
         }
         if(param1 is IFocusExtras)
         {
            if(_loc9_ = _loc8_.focusExtrasBefore)
            {
               _loc11_ = false;
               if(param2 && !_loc4_)
               {
                  _loc11_ = !(_loc4_ = (_loc7_ = _loc9_.indexOf(param2) - 1) >= -1);
               }
               else
               {
                  _loc7_ = _loc9_.length - 1;
               }
               if(!_loc11_)
               {
                  _loc10_ = _loc7_;
                  while(_loc10_ >= 0)
                  {
                     _loc12_ = _loc9_[_loc10_];
                     _loc5_ = this.findPreviousChildFocus(_loc12_);
                     if(this.isValidFocus(_loc5_))
                     {
                        return _loc5_;
                     }
                     _loc10_--;
                  }
               }
            }
         }
         if(param3 && param1 != this._root)
         {
            if(param1 is IFocusDisplayObject)
            {
               _loc6_ = IFocusDisplayObject(param1);
               if(this.isValidFocus(_loc6_))
               {
                  return _loc6_;
               }
            }
            return this.findPreviousContainerFocus(param1.parent,param1,true);
         }
         return null;
      }
      
      protected function findNextContainerFocus(param1:DisplayObjectContainer, param2:DisplayObject, param3:Boolean) : IFocusDisplayObject
      {
         var _loc6_:IFocusExtras = null;
         var _loc8_:* = undefined;
         var _loc10_:* = false;
         var _loc5_:int = 0;
         var _loc11_:int = 0;
         var _loc9_:* = 0;
         var _loc12_:DisplayObject = null;
         var _loc4_:IFocusDisplayObject = null;
         if(param1 is LayoutViewPort)
         {
            param1 = param1.parent;
         }
         var _loc7_:* = param2 == null;
         if(param1 is IFocusExtras)
         {
            if(_loc8_ = (_loc6_ = IFocusExtras(param1)).focusExtrasBefore)
            {
               _loc10_ = false;
               if(param2)
               {
                  _loc10_ = !(_loc7_ = (_loc5_ = _loc8_.indexOf(param2) + 1) > 0);
               }
               else
               {
                  _loc5_ = 0;
               }
               if(!_loc10_)
               {
                  _loc11_ = int(_loc8_.length);
                  _loc9_ = _loc5_;
                  while(_loc9_ < _loc11_)
                  {
                     _loc12_ = _loc8_[_loc9_];
                     _loc4_ = this.findNextChildFocus(_loc12_);
                     if(this.isValidFocus(_loc4_))
                     {
                        return _loc4_;
                     }
                     _loc9_++;
                  }
               }
            }
         }
         if(param2 && !_loc7_)
         {
            _loc7_ = (_loc5_ = param1.getChildIndex(param2) + 1) > 0;
         }
         else
         {
            _loc5_ = 0;
         }
         _loc11_ = param1.numChildren;
         _loc9_ = _loc5_;
         while(_loc9_ < _loc11_)
         {
            _loc12_ = param1.getChildAt(_loc9_);
            _loc4_ = this.findNextChildFocus(_loc12_);
            if(this.isValidFocus(_loc4_))
            {
               return _loc4_;
            }
            _loc9_++;
         }
         if(param1 is IFocusExtras)
         {
            if(_loc8_ = _loc6_.focusExtrasAfter)
            {
               _loc10_ = false;
               if(param2 && !_loc7_)
               {
                  _loc10_ = !(_loc7_ = (_loc5_ = _loc8_.indexOf(param2) + 1) > 0);
               }
               else
               {
                  _loc5_ = 0;
               }
               if(!_loc10_)
               {
                  _loc11_ = int(_loc8_.length);
                  _loc9_ = _loc5_;
                  while(_loc9_ < _loc11_)
                  {
                     _loc12_ = _loc8_[_loc9_];
                     _loc4_ = this.findNextChildFocus(_loc12_);
                     if(this.isValidFocus(_loc4_))
                     {
                        return _loc4_;
                     }
                     _loc9_++;
                  }
               }
            }
         }
         if(param3 && param1 != this._root)
         {
            return this.findNextContainerFocus(param1.parent,param1,true);
         }
         return null;
      }
      
      protected function findPreviousChildFocus(param1:DisplayObject) : IFocusDisplayObject
      {
         var _loc4_:DisplayObjectContainer = null;
         var _loc2_:IFocusDisplayObject = null;
         var _loc3_:IFocusDisplayObject = null;
         if(param1 is DisplayObjectContainer && !(param1 is IFocusDisplayObject) || param1 is IFocusContainer && Boolean(IFocusContainer(param1).isChildFocusEnabled))
         {
            _loc4_ = DisplayObjectContainer(param1);
            _loc2_ = this.findPreviousContainerFocus(_loc4_,null,false);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         if(param1 is IFocusDisplayObject)
         {
            _loc3_ = IFocusDisplayObject(param1);
            if(this.isValidFocus(_loc3_))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      protected function findNextChildFocus(param1:DisplayObject) : IFocusDisplayObject
      {
         var _loc3_:IFocusDisplayObject = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc2_:IFocusDisplayObject = null;
         if(param1 is IFocusDisplayObject)
         {
            _loc3_ = IFocusDisplayObject(param1);
            if(this.isValidFocus(_loc3_))
            {
               return _loc3_;
            }
         }
         if(param1 is DisplayObjectContainer && !(param1 is IFocusDisplayObject) || param1 is IFocusContainer && Boolean(IFocusContainer(param1).isChildFocusEnabled))
         {
            _loc4_ = DisplayObjectContainer(param1);
            _loc2_ = this.findNextContainerFocus(_loc4_,null,false);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function isValidFocus(param1:IFocusDisplayObject) : Boolean
      {
         if(!param1 || !param1.isFocusEnabled || param1.focusManager != this)
         {
            return false;
         }
         var _loc2_:IFeathersControl = param1 as IFeathersControl;
         if(_loc2_ && !_loc2_.isEnabled)
         {
            return false;
         }
         return true;
      }
      
      protected function stage_mouseFocusChangeHandler(param1:FocusEvent) : void
      {
         if(param1.relatedObject)
         {
            this.focus = null;
            return;
         }
         param1.preventDefault();
      }
      
      protected function stage_keyFocusChangeHandler(param1:FocusEvent) : void
      {
         var _loc3_:IFocusDisplayObject = null;
         if(param1.keyCode != 9 && param1.keyCode != 0)
         {
            return;
         }
         var _loc2_:IFocusDisplayObject = this._focus;
         if(_loc2_ && _loc2_.focusOwner)
         {
            _loc3_ = _loc2_.focusOwner;
         }
         else if(param1.shiftKey)
         {
            if(_loc2_)
            {
               if(_loc2_.previousTabFocus)
               {
                  _loc3_ = _loc2_.previousTabFocus;
               }
               else
               {
                  _loc3_ = this.findPreviousContainerFocus(_loc2_.parent,DisplayObject(_loc2_),true);
               }
            }
            if(!_loc3_)
            {
               _loc3_ = this.findPreviousContainerFocus(this._root,null,false);
            }
         }
         else
         {
            if(_loc2_)
            {
               if(_loc2_.nextTabFocus)
               {
                  _loc3_ = _loc2_.nextTabFocus;
               }
               else if(_loc2_ is IFocusContainer && Boolean(IFocusContainer(_loc2_).isChildFocusEnabled))
               {
                  _loc3_ = this.findNextContainerFocus(DisplayObjectContainer(_loc2_),null,true);
               }
               else
               {
                  _loc3_ = this.findNextContainerFocus(_loc2_.parent,DisplayObject(_loc2_),true);
               }
            }
            if(!_loc3_)
            {
               _loc3_ = this.findNextContainerFocus(this._root,null,false);
            }
         }
         if(_loc3_)
         {
            param1.preventDefault();
         }
         this.focus = _loc3_;
         if(this._focus)
         {
            this._focus.showFocus();
         }
      }
      
      protected function topLevelContainer_addedHandler(param1:Event) : void
      {
         this.setFocusManager(DisplayObject(param1.target));
      }
      
      protected function topLevelContainer_removedHandler(param1:Event) : void
      {
         this.clearFocusManager(DisplayObject(param1.target));
      }
      
      protected function topLevelContainer_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         var _loc3_:Touch = param1.getTouch(this._root,"began");
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:* = null;
         var _loc5_:DisplayObject = _loc3_.target;
         do
         {
            if(_loc5_ is IFocusDisplayObject)
            {
               _loc2_ = IFocusDisplayObject(_loc5_);
               if(this.isValidFocus(_loc2_))
               {
                  if(!_loc4_ || !(_loc2_ is IFocusContainer) || !IFocusContainer(_loc2_).isChildFocusEnabled)
                  {
                     _loc4_ = _loc2_;
                  }
               }
            }
         }
         while(_loc5_ = _loc5_.parent);
         
         this.focus = _loc4_;
      }
      
      protected function nativeFocus_focusOutHandler(param1:FocusEvent) : void
      {
         var _loc3_:Object = param1.currentTarget;
         var _loc2_:Stage = this._starling.nativeStage;
         if(_loc2_.focus !== null && _loc2_.focus !== _loc3_)
         {
            if(_loc3_ is IEventDispatcher)
            {
               IEventDispatcher(_loc3_).removeEventListener("focusOut",nativeFocus_focusOutHandler);
            }
         }
         else if(this._focus !== null)
         {
            if(this._focus is INativeFocusOwner && INativeFocusOwner(this._focus).nativeFocus !== _loc3_)
            {
               return;
            }
            if(_loc3_ is InteractiveObject)
            {
               _loc2_.focus = InteractiveObject(_loc3_);
            }
            else
            {
               IAdvancedNativeFocusOwner(this._focus).setFocus();
            }
         }
      }
   }
}

import flash.display.Sprite;

class NativeFocusTarget extends Sprite
{
    
   
   public var referenceCount:int = 1;
   
   public function NativeFocusTarget()
   {
      super();
      this.tabEnabled = true;
      this.mouseEnabled = false;
      this.mouseChildren = false;
      this.alpha = 0;
   }
}
