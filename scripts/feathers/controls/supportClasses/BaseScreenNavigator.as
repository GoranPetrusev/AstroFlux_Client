package feathers.controls.supportClasses
{
   import feathers.controls.IScreen;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.errors.IllegalOperationError;
   import flash.utils.getDefinitionByName;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.errors.AbstractMethodError;
   import starling.events.Event;
   
   public class BaseScreenNavigator extends FeathersControl
   {
      
      protected static var SIGNAL_TYPE:Class;
      
      public static const AUTO_SIZE_MODE_STAGE:String = "stage";
      
      public static const AUTO_SIZE_MODE_CONTENT:String = "content";
       
      
      protected var _activeScreenID:String;
      
      protected var _activeScreen:DisplayObject;
      
      protected var _activeScreenExplicitWidth:Number;
      
      protected var _activeScreenExplicitHeight:Number;
      
      protected var _activeScreenExplicitMinWidth:Number;
      
      protected var _activeScreenExplicitMinHeight:Number;
      
      protected var _activeScreenExplicitMaxWidth:Number;
      
      protected var _activeScreenExplicitMaxHeight:Number;
      
      protected var _screens:Object;
      
      protected var _previousScreenInTransitionID:String;
      
      protected var _previousScreenInTransition:DisplayObject;
      
      protected var _nextScreenID:String = null;
      
      protected var _nextScreenTransition:Function = null;
      
      protected var _clearAfterTransition:Boolean = false;
      
      protected var _clipContent:Boolean = false;
      
      protected var _autoSizeMode:String = "stage";
      
      protected var _waitingTransition:Function;
      
      private var _waitingForTransitionFrameCount:int = 1;
      
      protected var _isTransitionActive:Boolean = false;
      
      public function BaseScreenNavigator()
      {
         _screens = {};
         super();
         if(Object(this).constructor == BaseScreenNavigator)
         {
            throw new Error("FeathersControl is an abstract class. For a lightweight Feathers wrapper, use feathers.controls.LayoutGroup.");
         }
         if(!SIGNAL_TYPE)
         {
            try
            {
               SIGNAL_TYPE = Class(getDefinitionByName("org.osflash.signals.ISignal"));
            }
            catch(error:Error)
            {
            }
         }
         this.addEventListener("addedToStage",screenNavigator_addedToStageHandler);
         this.addEventListener("removedFromStage",screenNavigator_removedFromStageHandler);
      }
      
      protected static function defaultTransition(param1:DisplayObject, param2:DisplayObject, param3:Function) : void
      {
         param3();
      }
      
      public function get activeScreenID() : String
      {
         return this._activeScreenID;
      }
      
      public function get activeScreen() : DisplayObject
      {
         return this._activeScreen;
      }
      
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(param1:Boolean) : void
      {
         if(this._clipContent == param1)
         {
            return;
         }
         this._clipContent = param1;
         if(!param1)
         {
            this.mask = null;
         }
         this.invalidate("styles");
      }
      
      public function get autoSizeMode() : String
      {
         return this._autoSizeMode;
      }
      
      public function set autoSizeMode(param1:String) : void
      {
         if(this._autoSizeMode == param1)
         {
            return;
         }
         this._autoSizeMode = param1;
         if(this._activeScreen)
         {
            if(this._autoSizeMode == "content")
            {
               this._activeScreen.addEventListener("resize",activeScreen_resizeHandler);
            }
            else
            {
               this._activeScreen.removeEventListener("resize",activeScreen_resizeHandler);
            }
         }
         this.invalidate("size");
      }
      
      public function get isTransitionActive() : Boolean
      {
         return this._isTransitionActive;
      }
      
      override public function dispose() : void
      {
         if(this._activeScreen)
         {
            this.cleanupActiveScreen();
            this._activeScreen = null;
            this._activeScreenID = null;
         }
         super.dispose();
      }
      
      public function removeAllScreens() : void
      {
         if(this._isTransitionActive)
         {
            throw new IllegalOperationError("Cannot remove all screens while a transition is active.");
         }
         if(this._activeScreen)
         {
            this.clearScreenInternal(null);
            this.dispatchEventWith("clear");
         }
         for(var _loc1_ in this._screens)
         {
            delete this._screens[_loc1_];
         }
      }
      
      public function hasScreen(param1:String) : Boolean
      {
         return this._screens.hasOwnProperty(param1);
      }
      
      public function getScreenIDs(param1:Vector.<String> = null) : Vector.<String>
      {
         if(param1)
         {
            param1.length = 0;
         }
         else
         {
            param1 = new Vector.<String>(0);
         }
         var _loc3_:int = 0;
         for(var _loc2_ in this._screens)
         {
            param1[_loc3_] = _loc2_;
            _loc3_++;
         }
         return param1;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc2_:Boolean = this.isInvalid("selected");
         var _loc3_:Boolean = this.isInvalid("styles");
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         if(_loc1_ || _loc2_)
         {
            if(this._activeScreen)
            {
               if(this._activeScreen.width != this.actualWidth)
               {
                  this._activeScreen.width = this.actualWidth;
               }
               if(this._activeScreen.height != this.actualHeight)
               {
                  this._activeScreen.height = this.actualHeight;
               }
            }
         }
         if(_loc3_ || _loc1_)
         {
            this.refreshMask();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc8_:* = this._explicitHeight !== this._explicitHeight;
         var _loc4_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc10_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc3_ && !_loc8_ && !_loc4_ && !_loc10_)
         {
            return false;
         }
         var _loc9_:Boolean = this._autoSizeMode === "content" || this.stage === null;
         var _loc7_:IMeasureDisplayObject = this._activeScreen as IMeasureDisplayObject;
         if(_loc9_)
         {
            if(this._activeScreen !== null)
            {
               resetFluidChildDimensionsForMeasurement(this._activeScreen,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._activeScreenExplicitWidth,this._activeScreenExplicitHeight,this._activeScreenExplicitMinWidth,this._activeScreenExplicitMinHeight,this._activeScreenExplicitMaxWidth,this._activeScreenExplicitMaxHeight);
               if(this._activeScreen is IValidating)
               {
                  IValidating(this._activeScreen).validate();
               }
            }
         }
         var _loc2_:Number = this._explicitWidth;
         if(_loc3_)
         {
            if(_loc9_)
            {
               if(this._activeScreen !== null)
               {
                  _loc2_ = this._activeScreen.width;
               }
               else
               {
                  _loc2_ = 0;
               }
            }
            else
            {
               _loc2_ = this.stage.stageWidth;
            }
         }
         var _loc5_:Number = this._explicitHeight;
         if(_loc8_)
         {
            if(_loc9_)
            {
               if(this._activeScreen !== null)
               {
                  _loc5_ = this._activeScreen.height;
               }
               else
               {
                  _loc5_ = 0;
               }
            }
            else
            {
               _loc5_ = this.stage.stageHeight;
            }
         }
         var _loc1_:Number = this._explicitMinWidth;
         if(_loc4_)
         {
            if(_loc9_)
            {
               if(_loc7_ !== null)
               {
                  _loc1_ = _loc7_.minWidth;
               }
               else if(this._activeScreen !== null)
               {
                  _loc1_ = this._activeScreen.width;
               }
               else
               {
                  _loc1_ = 0;
               }
            }
            else
            {
               _loc1_ = this.stage.stageWidth;
            }
         }
         var _loc6_:Number = this._explicitMinHeight;
         if(_loc10_)
         {
            if(_loc9_)
            {
               if(_loc7_ !== null)
               {
                  _loc6_ = _loc7_.minHeight;
               }
               else if(this._activeScreen !== null)
               {
                  _loc6_ = this._activeScreen.height;
               }
               else
               {
                  _loc6_ = 0;
               }
            }
            else
            {
               _loc6_ = this.stage.stageHeight;
            }
         }
         return this.saveMeasurements(_loc2_,_loc5_,_loc1_,_loc6_);
      }
      
      protected function addScreenInternal(param1:String, param2:IScreenNavigatorItem) : void
      {
         if(this._screens.hasOwnProperty(param1))
         {
            throw new ArgumentError("Screen with id \'" + param1 + "\' already defined. Cannot add two screens with the same id.");
         }
         this._screens[param1] = param2;
      }
      
      protected function refreshMask() : void
      {
         if(!this._clipContent)
         {
            return;
         }
         var _loc1_:DisplayObject = this.mask as Quad;
         if(_loc1_)
         {
            _loc1_.width = this.actualWidth;
            _loc1_.height = this.actualHeight;
         }
         else
         {
            _loc1_ = new Quad(1,1,16711935);
            _loc1_.width = this.actualWidth;
            _loc1_.height = this.actualHeight;
            this.mask = _loc1_;
         }
      }
      
      protected function removeScreenInternal(param1:String) : IScreenNavigatorItem
      {
         if(!this._screens.hasOwnProperty(param1))
         {
            throw new ArgumentError("Screen \'" + param1 + "\' cannot be removed because it has not been added.");
         }
         if(this._isTransitionActive && (param1 == this._previousScreenInTransitionID || param1 == this._activeScreenID))
         {
            throw new IllegalOperationError("Cannot remove a screen while it is transitioning in or out.");
         }
         if(this._activeScreenID == param1)
         {
            this.clearScreenInternal(null);
            this.dispatchEventWith("clear");
         }
         var _loc2_:IScreenNavigatorItem = IScreenNavigatorItem(this._screens[param1]);
         delete this._screens[param1];
         return _loc2_;
      }
      
      protected function showScreenInternal(param1:String, param2:Function, param3:Object = null) : DisplayObject
      {
         var _loc7_:IScreen = null;
         if(!this.hasScreen(param1))
         {
            throw new ArgumentError("Screen with id \'" + param1 + "\' cannot be shown because it has not been defined.");
         }
         if(this._isTransitionActive)
         {
            this._nextScreenID = param1;
            this._nextScreenTransition = param2;
            this._clearAfterTransition = false;
            return null;
         }
         this._previousScreenInTransition = this._activeScreen;
         this._previousScreenInTransitionID = this._activeScreenID;
         if(this._activeScreen !== null)
         {
            this.cleanupActiveScreen();
         }
         this._isTransitionActive = true;
         var _loc4_:IScreenNavigatorItem = IScreenNavigatorItem(this._screens[param1]);
         this._activeScreen = _loc4_.getScreen();
         this._activeScreenID = param1;
         for(var _loc5_ in param3)
         {
            this._activeScreen[_loc5_] = param3[_loc5_];
         }
         if(this._activeScreen is IScreen)
         {
            (_loc7_ = IScreen(this._activeScreen)).screenID = this._activeScreenID;
            _loc7_.owner = this;
         }
         if(this._autoSizeMode === "content" || !this.stage)
         {
            this._activeScreen.addEventListener("resize",activeScreen_resizeHandler);
         }
         this.prepareActiveScreen();
         var _loc8_:* = this._previousScreenInTransition === this._activeScreen;
         this.addChild(this._activeScreen);
         if(this._activeScreen is IFeathersControl)
         {
            IFeathersControl(this._activeScreen).initializeNow();
         }
         var _loc6_:IMeasureDisplayObject;
         if((_loc6_ = this._activeScreen as IMeasureDisplayObject) !== null)
         {
            this._activeScreenExplicitWidth = _loc6_.explicitWidth;
            this._activeScreenExplicitHeight = _loc6_.explicitHeight;
            this._activeScreenExplicitMinWidth = _loc6_.explicitMinWidth;
            this._activeScreenExplicitMinHeight = _loc6_.explicitMinHeight;
            this._activeScreenExplicitMaxWidth = _loc6_.explicitMaxWidth;
            this._activeScreenExplicitMaxHeight = _loc6_.explicitMaxHeight;
         }
         else
         {
            this._activeScreenExplicitWidth = this._activeScreen.width;
            this._activeScreenExplicitHeight = this._activeScreen.height;
            this._activeScreenExplicitMinWidth = this._activeScreenExplicitWidth;
            this._activeScreenExplicitMinHeight = this._activeScreenExplicitHeight;
            this._activeScreenExplicitMaxWidth = this._activeScreenExplicitWidth;
            this._activeScreenExplicitMaxHeight = this._activeScreenExplicitHeight;
         }
         this.invalidate("selected");
         if(this._validationQueue && !this._validationQueue.isValidating)
         {
            this._validationQueue.advanceTime(0);
         }
         else if(!this._isValidating)
         {
            this.validate();
         }
         if(_loc8_)
         {
            this._previousScreenInTransition = null;
            this._previousScreenInTransitionID = null;
            this._isTransitionActive = false;
         }
         else
         {
            this.dispatchEventWith("transitionStart");
            this._activeScreen.dispatchEventWith("transitionInStart");
            if(this._previousScreenInTransition !== null)
            {
               this._previousScreenInTransition.dispatchEventWith("transitionOutStart");
            }
            if(param2 !== null)
            {
               this._activeScreen.visible = false;
               this._waitingForTransitionFrameCount = 0;
               this._waitingTransition = param2;
               this.addEventListener("enterFrame",waitingForTransition_enterFrameHandler);
            }
            else
            {
               defaultTransition(this._previousScreenInTransition,this._activeScreen,transitionComplete);
            }
         }
         this.dispatchEventWith("change");
         return this._activeScreen;
      }
      
      protected function clearScreenInternal(param1:Function = null) : void
      {
         if(this._activeScreen === null)
         {
            return;
         }
         if(this._isTransitionActive)
         {
            this._nextScreenID = null;
            this._clearAfterTransition = true;
            this._nextScreenTransition = param1;
            return;
         }
         this.cleanupActiveScreen();
         this._isTransitionActive = true;
         this._previousScreenInTransition = this._activeScreen;
         this._previousScreenInTransitionID = this._activeScreenID;
         this._activeScreen = null;
         this._activeScreenID = null;
         this.dispatchEventWith("transitionStart");
         this._previousScreenInTransition.dispatchEventWith("transitionOutStart");
         if(param1 !== null)
         {
            this._waitingForTransitionFrameCount = 0;
            this._waitingTransition = param1;
            this.addEventListener("enterFrame",waitingForTransition_enterFrameHandler);
         }
         else
         {
            defaultTransition(this._previousScreenInTransition,this._activeScreen,transitionComplete);
         }
         this.invalidate("selected");
      }
      
      protected function prepareActiveScreen() : void
      {
         throw new AbstractMethodError();
      }
      
      protected function cleanupActiveScreen() : void
      {
         throw new AbstractMethodError();
      }
      
      protected function transitionComplete(param1:Boolean = false) : void
      {
         var _loc2_:IScreenNavigatorItem = null;
         var _loc4_:IMeasureDisplayObject = null;
         var _loc3_:DisplayObject = null;
         var _loc7_:DisplayObject = null;
         var _loc6_:String = null;
         var _loc5_:IScreen = null;
         this._isTransitionActive = this._clearAfterTransition || this._nextScreenID;
         if(param1)
         {
            if(this._activeScreen !== null)
            {
               _loc2_ = IScreenNavigatorItem(this._screens[this._activeScreenID]);
               this.cleanupActiveScreen();
               this.removeChild(this._activeScreen,_loc2_.canDispose);
               if(!_loc2_.canDispose)
               {
                  this._activeScreen.width = this._activeScreenExplicitWidth;
                  this._activeScreen.height = this._activeScreenExplicitHeight;
                  if((_loc4_ = this._activeScreen as IMeasureDisplayObject) !== null)
                  {
                     _loc4_.minWidth = this._activeScreenExplicitMinWidth;
                     _loc4_.minHeight = this._activeScreenExplicitMinHeight;
                  }
               }
            }
            this._activeScreen = this._previousScreenInTransition;
            this._activeScreenID = this._previousScreenInTransitionID;
            this._previousScreenInTransition = null;
            this._previousScreenInTransitionID = null;
            this.prepareActiveScreen();
            this.dispatchEventWith("transitionCancel");
         }
         else
         {
            _loc3_ = this._activeScreen;
            _loc7_ = this._previousScreenInTransition;
            _loc6_ = this._previousScreenInTransitionID;
            _loc2_ = IScreenNavigatorItem(this._screens[_loc6_]);
            this._previousScreenInTransition = null;
            this._previousScreenInTransitionID = null;
            if(_loc7_ !== null)
            {
               _loc7_.dispatchEventWith("transitionOutComplete");
            }
            if(_loc3_ !== null)
            {
               _loc3_.dispatchEventWith("transitionInComplete");
            }
            this.dispatchEventWith("transitionComplete");
            if(_loc7_ !== null)
            {
               if(_loc7_ is IScreen)
               {
                  (_loc5_ = IScreen(_loc7_)).screenID = null;
                  _loc5_.owner = null;
               }
               _loc7_.removeEventListener("resize",activeScreen_resizeHandler);
               this.removeChild(_loc7_,_loc2_.canDispose);
            }
         }
         this._isTransitionActive = false;
         if(this._clearAfterTransition)
         {
            this.clearScreenInternal(this._nextScreenTransition);
         }
         else if(this._nextScreenID !== null)
         {
            this.showScreenInternal(this._nextScreenID,this._nextScreenTransition);
         }
         this._nextScreenID = null;
         this._nextScreenTransition = null;
         this._clearAfterTransition = false;
      }
      
      protected function screenNavigator_addedToStageHandler(param1:Event) : void
      {
         this.stage.addEventListener("resize",stage_resizeHandler);
      }
      
      protected function screenNavigator_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener("resize",stage_resizeHandler);
      }
      
      protected function activeScreen_resizeHandler(param1:Event) : void
      {
         if(this._isValidating || this._autoSizeMode != "content")
         {
            return;
         }
         this.invalidate("size");
      }
      
      protected function stage_resizeHandler(param1:Event) : void
      {
         this.invalidate("size");
      }
      
      private function waitingForTransition_enterFrameHandler(param1:Event) : void
      {
         if(this._waitingForTransitionFrameCount < 2)
         {
            this._waitingForTransitionFrameCount++;
            return;
         }
         this.removeEventListener("enterFrame",waitingForTransition_enterFrameHandler);
         if(this._activeScreen)
         {
            this._activeScreen.visible = true;
         }
         var _loc2_:Function = this._waitingTransition;
         this._waitingTransition = null;
         _loc2_(this._previousScreenInTransition,this._activeScreen,transitionComplete);
      }
   }
}
