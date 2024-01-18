package feathers.controls
{
   import feathers.controls.supportClasses.LayoutViewPort;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusContainer;
   import feathers.layout.ILayout;
   import feathers.layout.ILayoutDisplayObject;
   import feathers.layout.IVirtualLayout;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.stageToStarling;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   
   public class ScrollContainer extends Scroller implements IScrollContainer, IFocusContainer
   {
      
      public static const ALTERNATE_STYLE_NAME_TOOLBAR:String = "feathers-toolbar-scroll-container";
      
      public static const SCROLL_POLICY_AUTO:String = "auto";
      
      public static const SCROLL_POLICY_ON:String = "on";
      
      public static const SCROLL_POLICY_OFF:String = "off";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT:String = "fixedFloat";
      
      public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";
      
      public static const VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";
      
      public static const VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";
      
      public static const INTERACTION_MODE_TOUCH:String = "touch";
      
      public static const INTERACTION_MODE_MOUSE:String = "mouse";
      
      public static const INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";
      
      public static const MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";
      
      public static const MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DECELERATION_RATE_NORMAL:Number = 0.998;
      
      public static const DECELERATION_RATE_FAST:Number = 0.99;
      
      public static const AUTO_SIZE_MODE_STAGE:String = "stage";
      
      public static const AUTO_SIZE_MODE_CONTENT:String = "content";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var displayListBypassEnabled:Boolean = true;
      
      protected var layoutViewPort:LayoutViewPort;
      
      protected var _isChildFocusEnabled:Boolean = true;
      
      protected var _layout:ILayout;
      
      protected var _autoSizeMode:String = "content";
      
      protected var _ignoreChildChanges:Boolean = false;
      
      public function ScrollContainer()
      {
         super();
         this.layoutViewPort = new LayoutViewPort();
         this.viewPort = this.layoutViewPort;
         this.addEventListener("addedToStage",scrollContainer_addedToStageHandler);
         this.addEventListener("removedFromStage",scrollContainer_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ScrollContainer.globalStyleProvider;
      }
      
      public function get isChildFocusEnabled() : Boolean
      {
         return this._isEnabled && this._isChildFocusEnabled;
      }
      
      public function set isChildFocusEnabled(param1:Boolean) : void
      {
         this._isChildFocusEnabled = param1;
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         if(this._layout == param1)
         {
            return;
         }
         this._layout = param1;
         this.invalidate("layout");
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
         this._measureViewPort = this._autoSizeMode != "stage";
         if(this.stage)
         {
            if(this._autoSizeMode == "stage")
            {
               this.stage.addEventListener("resize",stage_resizeHandler);
            }
            else
            {
               this.stage.removeEventListener("resize",stage_resizeHandler);
            }
         }
         this.invalidate("size");
      }
      
      override public function get numChildren() : int
      {
         if(!this.displayListBypassEnabled)
         {
            return super.numChildren;
         }
         return DisplayObjectContainer(this.viewPort).numChildren;
      }
      
      public function get numRawChildren() : int
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc1_:int = super.numChildren;
         this.displayListBypassEnabled = _loc2_;
         return _loc1_;
      }
      
      override public function getChildByName(param1:String) : DisplayObject
      {
         if(!this.displayListBypassEnabled)
         {
            return super.getChildByName(param1);
         }
         return DisplayObjectContainer(this.viewPort).getChildByName(param1);
      }
      
      public function getRawChildByName(param1:String) : DisplayObject
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc3_:DisplayObject = super.getChildByName(param1);
         this.displayListBypassEnabled = _loc2_;
         return _loc3_;
      }
      
      override public function getChildAt(param1:int) : DisplayObject
      {
         if(!this.displayListBypassEnabled)
         {
            return super.getChildAt(param1);
         }
         return DisplayObjectContainer(this.viewPort).getChildAt(param1);
      }
      
      public function getRawChildAt(param1:int) : DisplayObject
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc3_:DisplayObject = super.getChildAt(param1);
         this.displayListBypassEnabled = _loc2_;
         return _loc3_;
      }
      
      public function addRawChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         if(param1.parent == this)
         {
            super.setChildIndex(param1,super.numChildren);
         }
         else
         {
            param1 = super.addChildAt(param1,super.numChildren);
         }
         this.displayListBypassEnabled = _loc2_;
         return param1;
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         return this.addChildAt(param1,this.numChildren);
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(!this.displayListBypassEnabled)
         {
            return super.addChildAt(param1,param2);
         }
         var _loc3_:DisplayObject = DisplayObjectContainer(this.viewPort).addChildAt(param1,param2);
         if(_loc3_ is IFeathersControl)
         {
            _loc3_.addEventListener("resize",child_resizeHandler);
         }
         if(_loc3_ is ILayoutDisplayObject)
         {
            _loc3_.addEventListener("layoutDataChange",child_layoutDataChangeHandler);
         }
         this.invalidate("size");
         return _loc3_;
      }
      
      public function addRawChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         param1 = super.addChildAt(param1,param2);
         this.displayListBypassEnabled = _loc3_;
         return param1;
      }
      
      public function removeRawChild(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc4_:int;
         if((_loc4_ = super.getChildIndex(param1)) >= 0)
         {
            super.removeChildAt(_loc4_,param2);
         }
         this.displayListBypassEnabled = _loc3_;
         return param1;
      }
      
      override public function removeChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         if(!this.displayListBypassEnabled)
         {
            return super.removeChildAt(param1,param2);
         }
         var _loc3_:DisplayObject = DisplayObjectContainer(this.viewPort).removeChildAt(param1,param2);
         if(_loc3_ is IFeathersControl)
         {
            _loc3_.removeEventListener("resize",child_resizeHandler);
         }
         if(_loc3_ is ILayoutDisplayObject)
         {
            _loc3_.removeEventListener("layoutDataChange",child_layoutDataChangeHandler);
         }
         this.invalidate("size");
         return _loc3_;
      }
      
      public function removeRawChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc4_:DisplayObject = super.removeChildAt(param1,param2);
         this.displayListBypassEnabled = _loc3_;
         return _loc4_;
      }
      
      override public function getChildIndex(param1:DisplayObject) : int
      {
         if(!this.displayListBypassEnabled)
         {
            return super.getChildIndex(param1);
         }
         return DisplayObjectContainer(this.viewPort).getChildIndex(param1);
      }
      
      public function getRawChildIndex(param1:DisplayObject) : int
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         var _loc3_:int = super.getChildIndex(param1);
         this.displayListBypassEnabled = _loc2_;
         return _loc3_;
      }
      
      override public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         if(!this.displayListBypassEnabled)
         {
            super.setChildIndex(param1,param2);
            return;
         }
         DisplayObjectContainer(this.viewPort).setChildIndex(param1,param2);
      }
      
      public function setRawChildIndex(param1:DisplayObject, param2:int) : void
      {
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         super.setChildIndex(param1,param2);
         this.displayListBypassEnabled = _loc3_;
      }
      
      public function swapRawChildren(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:int = this.getRawChildIndex(param1);
         var _loc5_:int = this.getRawChildIndex(param2);
         if(_loc3_ < 0 || _loc5_ < 0)
         {
            throw new ArgumentError("Not a child of this container");
         }
         var _loc4_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         this.swapRawChildrenAt(_loc3_,_loc5_);
         this.displayListBypassEnabled = _loc4_;
      }
      
      override public function swapChildrenAt(param1:int, param2:int) : void
      {
         if(!this.displayListBypassEnabled)
         {
            super.swapChildrenAt(param1,param2);
            return;
         }
         DisplayObjectContainer(this.viewPort).swapChildrenAt(param1,param2);
      }
      
      public function swapRawChildrenAt(param1:int, param2:int) : void
      {
         var _loc3_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         super.swapChildrenAt(param1,param2);
         this.displayListBypassEnabled = _loc3_;
      }
      
      override public function sortChildren(param1:Function) : void
      {
         if(!this.displayListBypassEnabled)
         {
            super.sortChildren(param1);
            return;
         }
         DisplayObjectContainer(this.viewPort).sortChildren(param1);
      }
      
      public function sortRawChildren(param1:Function) : void
      {
         var _loc2_:Boolean = this.displayListBypassEnabled;
         this.displayListBypassEnabled = false;
         super.sortChildren(param1);
         this.displayListBypassEnabled = _loc2_;
      }
      
      public function readjustLayout() : void
      {
         this.layoutViewPort.readjustLayout();
         this.invalidate("size");
      }
      
      override protected function initialize() : void
      {
         var _loc1_:Starling = null;
         if(this.stage !== null)
         {
            _loc1_ = stageToStarling(this.stage);
            if(_loc1_.root === this)
            {
               this.autoSizeMode = "stage";
            }
         }
         super.initialize();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("layout");
         if(_loc1_)
         {
            if(this._layout is IVirtualLayout)
            {
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            this.layoutViewPort.layout = this._layout;
         }
         var _loc2_:Boolean = this._ignoreChildChanges;
         this._ignoreChildChanges = true;
         super.draw();
         this._ignoreChildChanges = _loc2_;
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:* = this._explicitWidth !== this._explicitWidth;
         var _loc5_:* = this._explicitHeight !== this._explicitHeight;
         var _loc3_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc6_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc2_ && !_loc5_ && !_loc3_ && !_loc6_)
         {
            return false;
         }
         if(this._autoSizeMode === "stage")
         {
            _loc1_ = this.stage.stageWidth;
            _loc4_ = this.stage.stageHeight;
            return this.saveMeasurements(_loc1_,_loc4_,_loc1_,_loc4_);
         }
         return super.autoSizeIfNeeded();
      }
      
      protected function scrollContainer_addedToStageHandler(param1:Event) : void
      {
         if(this._autoSizeMode == "stage")
         {
            this.stage.addEventListener("resize",stage_resizeHandler);
         }
      }
      
      protected function scrollContainer_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener("resize",stage_resizeHandler);
      }
      
      protected function child_resizeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         this.invalidate("size");
      }
      
      protected function child_layoutDataChangeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         this.invalidate("size");
      }
      
      protected function stage_resizeHandler(param1:Event) : void
      {
         this.invalidate("size");
      }
   }
}
