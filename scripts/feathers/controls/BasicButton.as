package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IStateContext;
   import feathers.core.IStateObserver;
   import feathers.core.IValidating;
   import feathers.skins.IStyleProvider;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import feathers.utils.touch.TapToTrigger;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class BasicButton extends FeathersControl implements IStateContext
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var tapToTrigger:TapToTrigger;
      
      protected var touchPointID:int = -1;
      
      protected var _currentState:String = "up";
      
      protected var currentSkin:DisplayObject;
      
      protected var _keepDownStateOnRollOut:Boolean = false;
      
      protected var _defaultSkin:DisplayObject;
      
      protected var _stateToSkin:Object;
      
      protected var _explicitSkinWidth:Number;
      
      protected var _explicitSkinHeight:Number;
      
      protected var _explicitSkinMinWidth:Number;
      
      protected var _explicitSkinMinHeight:Number;
      
      protected var _explicitSkinMaxWidth:Number;
      
      protected var _explicitSkinMaxHeight:Number;
      
      public function BasicButton()
      {
         _stateToSkin = {};
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("removedFromStage",basicButton_removedFromStageHandler);
         this.addEventListener("touch",basicButton_touchHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return BasicButton.globalStyleProvider;
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      override public function set isEnabled(param1:Boolean) : void
      {
         if(this._isEnabled === param1)
         {
            return;
         }
         super.isEnabled = param1;
         if(this._isEnabled)
         {
            if(this._currentState === "disabled")
            {
               this.changeState("up");
            }
         }
         else
         {
            this.resetTouchState();
         }
      }
      
      public function get keepDownStateOnRollOut() : Boolean
      {
         return this._keepDownStateOnRollOut;
      }
      
      public function set keepDownStateOnRollOut(param1:Boolean) : void
      {
         this._keepDownStateOnRollOut = param1;
      }
      
      public function get defaultSkin() : DisplayObject
      {
         return this._defaultSkin;
      }
      
      public function set defaultSkin(param1:DisplayObject) : void
      {
         if(this._defaultSkin === param1)
         {
            return;
         }
         if(this._defaultSkin !== null && this.currentSkin === this._defaultSkin)
         {
            this.removeCurrentSkin(this._defaultSkin);
            this.currentSkin = null;
         }
         this._defaultSkin = param1;
         this.invalidate("styles");
      }
      
      public function getSkinForState(param1:String) : DisplayObject
      {
         return this._stateToSkin[param1] as DisplayObject;
      }
      
      public function setSkinForState(param1:String, param2:DisplayObject) : void
      {
         var _loc3_:DisplayObject = this._stateToSkin[param1] as DisplayObject;
         if(_loc3_ !== null && this.currentSkin === _loc3_)
         {
            this.removeCurrentSkin(_loc3_);
            this.currentSkin = null;
         }
         if(param2 !== null)
         {
            this._stateToSkin[param1] = param2;
         }
         else
         {
            delete this._stateToSkin[param1];
         }
         this.invalidate("styles");
      }
      
      override public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         if(this._defaultSkin !== null && this._defaultSkin.parent !== this)
         {
            this._defaultSkin.dispose();
         }
         for(var _loc2_ in this._stateToSkin)
         {
            _loc1_ = this._stateToSkin[_loc2_] as DisplayObject;
            if(_loc1_ !== null && _loc1_.parent !== this)
            {
               _loc1_.dispose();
            }
         }
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(!this.tapToTrigger)
         {
            this.tapToTrigger = new TapToTrigger(this);
         }
      }
      
      override protected function draw() : void
      {
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("state");
         var _loc1_:Boolean = this.isInvalid("size");
         if(_loc3_ || _loc2_)
         {
            this.refreshTriggeredEvents();
            this.refreshSkin();
         }
         this.autoSizeIfNeeded();
         this.scaleSkin();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc7_:* = this._explicitHeight !== this._explicitHeight;
         var _loc4_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc9_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc3_ && !_loc7_ && !_loc4_ && !_loc9_)
         {
            return false;
         }
         resetFluidChildDimensionsForMeasurement(this.currentSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitSkinWidth,this._explicitSkinHeight,this._explicitSkinMinWidth,this._explicitSkinMinHeight,this._explicitSkinMaxWidth,this._explicitSkinMaxHeight);
         var _loc8_:IMeasureDisplayObject = this.currentSkin as IMeasureDisplayObject;
         if(this.currentSkin is IValidating)
         {
            IValidating(this.currentSkin).validate();
         }
         var _loc1_:Number = this._explicitMinWidth;
         if(_loc4_)
         {
            if(_loc8_ !== null)
            {
               _loc1_ = _loc8_.minWidth;
            }
            else if(this.currentSkin !== null)
            {
               _loc1_ = this._explicitSkinMinWidth;
            }
            else
            {
               _loc1_ = 0;
            }
         }
         var _loc6_:Number = this._explicitMinHeight;
         if(_loc9_)
         {
            if(_loc8_ !== null)
            {
               _loc6_ = _loc8_.minHeight;
            }
            else if(this.currentSkin !== null)
            {
               _loc6_ = this._explicitSkinMinHeight;
            }
            else
            {
               _loc6_ = 0;
            }
         }
         var _loc2_:Number = this._explicitWidth;
         if(_loc3_)
         {
            if(this.currentSkin !== null)
            {
               _loc2_ = this.currentSkin.width;
            }
            else
            {
               _loc2_ = 0;
            }
         }
         var _loc5_:Number = this._explicitHeight;
         if(_loc7_)
         {
            if(this.currentSkin !== null)
            {
               _loc5_ = this.currentSkin.height;
            }
            else
            {
               _loc5_ = 0;
            }
         }
         return this.saveMeasurements(_loc2_,_loc5_,_loc1_,_loc6_);
      }
      
      protected function refreshSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentSkin;
         this.currentSkin = this.getCurrentSkin();
         switch(_loc1_)
         {
            default:
               if(this.currentSkin is IFeathersControl)
               {
                  IFeathersControl(this.currentSkin).initializeNow();
               }
               if(this.currentSkin is IMeasureDisplayObject)
               {
                  _loc2_ = IMeasureDisplayObject(this.currentSkin);
                  this._explicitSkinWidth = _loc2_.explicitWidth;
                  this._explicitSkinHeight = _loc2_.explicitHeight;
                  this._explicitSkinMinWidth = _loc2_.explicitMinWidth;
                  this._explicitSkinMinHeight = _loc2_.explicitMinHeight;
                  this._explicitSkinMaxWidth = _loc2_.explicitMaxWidth;
                  this._explicitSkinMaxHeight = _loc2_.explicitMaxHeight;
               }
               else
               {
                  this._explicitSkinWidth = this.currentSkin.width;
                  this._explicitSkinHeight = this.currentSkin.height;
                  this._explicitSkinMinWidth = this._explicitSkinWidth;
                  this._explicitSkinMinHeight = this._explicitSkinHeight;
                  this._explicitSkinMaxWidth = this._explicitSkinWidth;
                  this._explicitSkinMaxHeight = this._explicitSkinHeight;
               }
               if(this.currentSkin is IStateObserver)
               {
                  IStateObserver(this.currentSkin).stateContext = this;
               }
               this.addChildAt(this.currentSkin,0);
               break;
            case this.currentSkin:
            case this.currentSkin:
         }
      }
      
      protected function getCurrentSkin() : DisplayObject
      {
         var _loc1_:DisplayObject = this._stateToSkin[this._currentState] as DisplayObject;
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         return this._defaultSkin;
      }
      
      protected function scaleSkin() : void
      {
         if(!this.currentSkin)
         {
            return;
         }
         this.currentSkin.x = 0;
         this.currentSkin.y = 0;
         if(this.currentSkin.width !== this.actualWidth)
         {
            this.currentSkin.width = this.actualWidth;
         }
         if(this.currentSkin.height !== this.actualHeight)
         {
            this.currentSkin.height = this.actualHeight;
         }
         if(this.currentSkin is IValidating)
         {
            IValidating(this.currentSkin).validate();
         }
      }
      
      protected function removeCurrentSkin(param1:DisplayObject) : void
      {
         if(param1 === null)
         {
            return;
         }
         if(param1 is IStateObserver)
         {
            IStateObserver(param1).stateContext = null;
         }
         if(param1.parent === this)
         {
            this.removeChild(param1,false);
         }
      }
      
      protected function refreshTriggeredEvents() : void
      {
         this.tapToTrigger.isEnabled = this._isEnabled;
      }
      
      protected function changeState(param1:String) : void
      {
         if(this._currentState === param1)
         {
            return;
         }
         this._currentState = param1;
         this.invalidate("state");
         this.dispatchEventWith("stageChange");
      }
      
      protected function resetTouchState(param1:Touch = null) : void
      {
         this.touchPointID = -1;
         if(this._isEnabled)
         {
            this.changeState("up");
         }
         else
         {
            this.changeState("disabled");
         }
      }
      
      protected function basicButton_removedFromStageHandler(param1:Event) : void
      {
         this.resetTouchState();
      }
      
      protected function basicButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc2_:Boolean = false;
         if(!this._isEnabled)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc3_ = param1.getTouch(this,null,this.touchPointID);
            if(!_loc3_)
            {
               return;
            }
            _loc3_.getLocation(this.stage,HELPER_POINT);
            _loc2_ = this.contains(this.stage.hitTest(HELPER_POINT));
            if(_loc3_.phase === "moved")
            {
               if(_loc2_ || this._keepDownStateOnRollOut)
               {
                  this.changeState("down");
               }
               else
               {
                  this.changeState("up");
               }
            }
            else if(_loc3_.phase === "ended")
            {
               this.resetTouchState(_loc3_);
            }
            return;
         }
         _loc3_ = param1.getTouch(this,"began");
         if(_loc3_)
         {
            this.changeState("down");
            this.touchPointID = _loc3_.id;
            return;
         }
         _loc3_ = param1.getTouch(this,"hover");
         if(_loc3_)
         {
            this.changeState("hover");
            return;
         }
         this.changeState("up");
      }
   }
}
