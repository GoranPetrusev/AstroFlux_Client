package feathers.core
{
   import feathers.controls.Label;
   import flash.utils.getTimer;
   import starling.animation.DelayedCall;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class DefaultToolTipManager implements IToolTipManager
   {
       
      
      protected var _touchPointID:int = -1;
      
      protected var _delayedCall:DelayedCall;
      
      protected var _toolTipX:Number = 0;
      
      protected var _toolTipY:Number = 0;
      
      protected var _hideTime:int = 0;
      
      protected var _root:DisplayObjectContainer;
      
      protected var _target:IFeathersControl;
      
      protected var _toolTip:IToolTip;
      
      protected var _toolTipFactory:Function;
      
      protected var _showDelay:Number = 0.5;
      
      protected var _resetDelay:Number = 0.1;
      
      protected var _offsetX:Number = 0;
      
      protected var _offsetY:Number = 0;
      
      public function DefaultToolTipManager(param1:DisplayObjectContainer)
      {
         super();
         this._root = param1;
         this._root.addEventListener("touch",root_touchHandler);
      }
      
      public static function defaultToolTipFactory() : IToolTip
      {
         var _loc1_:Label = new Label();
         _loc1_.styleNameList.add("feathers-tool-tip");
         return _loc1_;
      }
      
      public function get toolTipFactory() : Function
      {
         return this._toolTipFactory;
      }
      
      public function set toolTipFactory(param1:Function) : void
      {
         if(this._toolTipFactory === param1)
         {
            return;
         }
         this._toolTipFactory = param1;
         if(this._toolTip)
         {
            this._toolTip.removeFromParent(true);
            this._toolTip = null;
         }
      }
      
      public function get showDelay() : Number
      {
         return this._showDelay;
      }
      
      public function set showDelay(param1:Number) : void
      {
         this._showDelay = param1;
      }
      
      public function get resetDelay() : Number
      {
         return this._resetDelay;
      }
      
      public function set resetDelay(param1:Number) : void
      {
         this._resetDelay = param1;
      }
      
      public function get offsetX() : Number
      {
         return this._offsetX;
      }
      
      public function set offsetX(param1:Number) : void
      {
         this._offsetX = param1;
      }
      
      public function get offsetY() : Number
      {
         return this._offsetY;
      }
      
      public function set offsetY(param1:Number) : void
      {
         this._offsetY = param1;
      }
      
      public function dispose() : void
      {
         this._root.removeEventListener("touch",root_touchHandler);
         this._root = null;
         if(Starling.juggler.contains(this._delayedCall))
         {
            Starling.juggler.remove(this._delayedCall);
            this._delayedCall = null;
         }
         if(this._toolTip)
         {
            this._toolTip.removeFromParent(true);
            this._toolTip = null;
         }
      }
      
      protected function getTarget(param1:Touch) : IFeathersControl
      {
         var _loc2_:IFeathersControl = null;
         var _loc3_:DisplayObject = param1.target;
         while(_loc3_ !== null)
         {
            if(_loc3_ is IFeathersControl)
            {
               _loc2_ = IFeathersControl(_loc3_);
               if(_loc2_.toolTip)
               {
                  return _loc2_;
               }
            }
            _loc3_ = _loc3_.parent;
         }
         return null;
      }
      
      protected function hoverDelayCallback() : void
      {
         var _loc1_:Function = null;
         var _loc2_:Label = null;
         if(!this._toolTip)
         {
            _loc1_ = this._toolTipFactory !== null ? this._toolTipFactory : defaultToolTipFactory;
            _loc2_ = _loc1_();
            _loc2_.touchable = false;
            this._toolTip = _loc2_;
         }
         this._toolTip.text = this._target.toolTip;
         this._toolTip.validate();
         var _loc4_:Number;
         if((_loc4_ = this._toolTipX + this._offsetX) < 0)
         {
            _loc4_ = 0;
         }
         else if(_loc4_ + this._toolTip.width > this._target.stage.stageWidth)
         {
            _loc4_ = this._target.stage.stageWidth - this._toolTip.width;
         }
         var _loc3_:Number = this._toolTipY - this._toolTip.height + this._offsetY;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         else if(_loc3_ + this._toolTip.height > this._target.stage.stageHeight)
         {
            _loc3_ = this._target.stage.stageHeight - this._toolTip.height;
         }
         this._toolTip.x = _loc4_;
         this._toolTip.y = _loc3_;
         PopUpManager.addPopUp(DisplayObject(this._toolTip),false,false);
      }
      
      protected function root_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc2_:Number = NaN;
         if(this._toolTip !== null && this._toolTip.parent !== null)
         {
            _loc3_ = param1.getTouch(DisplayObject(this._target),null,this._touchPointID);
            if(!_loc3_ || _loc3_.phase !== "hover")
            {
               PopUpManager.removePopUp(DisplayObject(this._toolTip),false);
               this._touchPointID = -1;
               this._target = null;
               this._hideTime = getTimer();
            }
            return;
         }
         if(this._target !== null)
         {
            _loc3_ = param1.getTouch(DisplayObject(this._target),null,this._touchPointID);
            if(!_loc3_ || _loc3_.phase !== "hover")
            {
               Starling.juggler.remove(this._delayedCall);
               this._touchPointID = -1;
               this._target = null;
               return;
            }
            this._toolTipX = _loc3_.globalX;
            this._toolTipY = _loc3_.globalY;
            this._delayedCall.reset(hoverDelayCallback,this._showDelay);
         }
         else
         {
            _loc3_ = param1.getTouch(this._root,"hover");
            if(!_loc3_)
            {
               return;
            }
            this._target = this.getTarget(_loc3_);
            if(!this._target)
            {
               return;
            }
            this._touchPointID = _loc3_.id;
            this._toolTipX = _loc3_.globalX;
            this._toolTipY = _loc3_.globalY;
            _loc2_ = (getTimer() - this._hideTime) / 1000;
            if(_loc2_ < this._resetDelay)
            {
               this.hoverDelayCallback();
               return;
            }
            if(this._delayedCall)
            {
               this._delayedCall.reset(hoverDelayCallback,this._showDelay);
            }
            else
            {
               this._delayedCall = new DelayedCall(hoverDelayCallback,this._showDelay);
            }
            Starling.juggler.add(this._delayedCall);
         }
      }
   }
}
