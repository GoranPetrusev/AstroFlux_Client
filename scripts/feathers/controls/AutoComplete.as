package feathers.controls
{
   import feathers.controls.popups.DropDownPopUpContentManager;
   import feathers.controls.popups.IPopUpContentManager;
   import feathers.core.PropertyProxy;
   import feathers.data.IAutoCompleteSource;
   import feathers.data.ListCollection;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.stageToStarling;
   import flash.events.KeyboardEvent;
   import flash.utils.getTimer;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class AutoComplete extends TextInput
   {
      
      protected static const INVALIDATION_FLAG_LIST_FACTORY:String = "listFactory";
      
      public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-auto-complete-list";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var listStyleName:String = "feathers-auto-complete-list";
      
      protected var list:List;
      
      protected var _listCollection:ListCollection;
      
      protected var _originalText:String;
      
      protected var _source:IAutoCompleteSource;
      
      protected var _autoCompleteDelay:Number = 0.5;
      
      protected var _minimumAutoCompleteLength:int = 2;
      
      protected var _popUpContentManager:IPopUpContentManager;
      
      protected var _listFactory:Function;
      
      protected var _customListStyleName:String;
      
      protected var _listProperties:PropertyProxy;
      
      protected var _ignoreAutoCompleteChanges:Boolean = false;
      
      protected var _lastChangeTime:int = 0;
      
      protected var _listHasFocus:Boolean = false;
      
      protected var _triggered:Boolean = false;
      
      protected var _isOpenListPending:Boolean = false;
      
      protected var _isCloseListPending:Boolean = false;
      
      public function AutoComplete()
      {
         super();
         this.addEventListener("change",autoComplete_changeHandler);
      }
      
      protected static function defaultListFactory() : List
      {
         return new List();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         if(AutoComplete.globalStyleProvider)
         {
            return AutoComplete.globalStyleProvider;
         }
         return TextInput.globalStyleProvider;
      }
      
      public function get source() : IAutoCompleteSource
      {
         return this._source;
      }
      
      public function set source(param1:IAutoCompleteSource) : void
      {
         if(this._source == param1)
         {
            return;
         }
         if(this._source)
         {
            this._source.removeEventListener("complete",dataProvider_completeHandler);
         }
         this._source = param1;
         if(this._source)
         {
            this._source.addEventListener("complete",dataProvider_completeHandler);
         }
      }
      
      public function get autoCompleteDelay() : Number
      {
         return this._autoCompleteDelay;
      }
      
      public function set autoCompleteDelay(param1:Number) : void
      {
         this._autoCompleteDelay = param1;
      }
      
      public function get minimumAutoCompleteLength() : Number
      {
         return this._minimumAutoCompleteLength;
      }
      
      public function set minimumAutoCompleteLength(param1:Number) : void
      {
         this._minimumAutoCompleteLength = param1;
      }
      
      public function get popUpContentManager() : IPopUpContentManager
      {
         return this._popUpContentManager;
      }
      
      public function set popUpContentManager(param1:IPopUpContentManager) : void
      {
         var _loc2_:EventDispatcher = null;
         if(this._popUpContentManager == param1)
         {
            return;
         }
         if(this._popUpContentManager is EventDispatcher)
         {
            _loc2_ = EventDispatcher(this._popUpContentManager);
            _loc2_.removeEventListener("open",popUpContentManager_openHandler);
            _loc2_.removeEventListener("close",popUpContentManager_closeHandler);
         }
         this._popUpContentManager = param1;
         if(this._popUpContentManager is EventDispatcher)
         {
            _loc2_ = EventDispatcher(this._popUpContentManager);
            _loc2_.addEventListener("open",popUpContentManager_openHandler);
            _loc2_.addEventListener("close",popUpContentManager_closeHandler);
         }
         this.invalidate("styles");
      }
      
      public function get listFactory() : Function
      {
         return this._listFactory;
      }
      
      public function set listFactory(param1:Function) : void
      {
         if(this._listFactory == param1)
         {
            return;
         }
         this._listFactory = param1;
         this.invalidate("listFactory");
      }
      
      public function get customListStyleName() : String
      {
         return this._customListStyleName;
      }
      
      public function set customListStyleName(param1:String) : void
      {
         if(this._customListStyleName == param1)
         {
            return;
         }
         this._customListStyleName = param1;
         this.invalidate("listFactory");
      }
      
      public function get listProperties() : Object
      {
         if(!this._listProperties)
         {
            this._listProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._listProperties;
      }
      
      public function set listProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._listProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            param1 = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc2_ = new PropertyProxy();
            for(var _loc3_ in param1)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
            param1 = _loc2_;
         }
         if(this._listProperties)
         {
            this._listProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._listProperties = PropertyProxy(param1);
         if(this._listProperties)
         {
            this._listProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function openList() : void
      {
         this._isCloseListPending = false;
         if(this._popUpContentManager.isOpen)
         {
            return;
         }
         if(!this._isValidating && this.isInvalid())
         {
            this._isOpenListPending = true;
            return;
         }
         this._isOpenListPending = false;
         this._popUpContentManager.open(this.list,this);
         this.list.validate();
         if(this._focusManager)
         {
            this.stage.addEventListener("keyUp",stage_keyUpHandler);
         }
      }
      
      public function closeList() : void
      {
         this._isOpenListPending = false;
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(!this._isValidating && this.isInvalid())
         {
            this._isCloseListPending = true;
            return;
         }
         if(this._listHasFocus)
         {
            this.list.dispatchEventWith("focusOut");
         }
         this._isCloseListPending = false;
         this.list.validate();
         this._popUpContentManager.close();
      }
      
      override public function dispose() : void
      {
         this.source = null;
         if(this.list)
         {
            this.closeList();
            this.list.dispose();
            this.list = null;
         }
         if(this._popUpContentManager)
         {
            this._popUpContentManager.dispose();
            this._popUpContentManager = null;
         }
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this._listCollection = new ListCollection();
         if(!this._popUpContentManager)
         {
            this.popUpContentManager = new DropDownPopUpContentManager();
         }
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("listFactory");
         super.draw();
         if(_loc1_)
         {
            this.createList();
         }
         if(_loc1_ || _loc2_)
         {
            this.refreshListProperties();
         }
         this.handlePendingActions();
      }
      
      protected function createList() : void
      {
         if(this.list)
         {
            this.list.removeFromParent(false);
            this.list.dispose();
            this.list = null;
         }
         var _loc1_:Function = this._listFactory != null ? this._listFactory : defaultListFactory;
         var _loc2_:String = this._customListStyleName != null ? this._customListStyleName : this.listStyleName;
         this.list = List(_loc1_());
         this.list.focusOwner = this;
         this.list.isFocusEnabled = false;
         this.list.isChildFocusEnabled = false;
         this.list.styleNameList.add(_loc2_);
         this.list.addEventListener("change",list_changeHandler);
         this.list.addEventListener("triggered",list_triggeredHandler);
         this.list.addEventListener("touch",list_touchHandler);
         this.list.addEventListener("removedFromStage",list_removedFromStageHandler);
      }
      
      protected function refreshListProperties() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._listProperties)
         {
            _loc2_ = this._listProperties[_loc1_];
            this.list[_loc1_] = _loc2_;
         }
      }
      
      protected function handlePendingActions() : void
      {
         if(this._isOpenListPending)
         {
            this.openList();
         }
         if(this._isCloseListPending)
         {
            this.closeList();
         }
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         var _loc2_:Starling = stageToStarling(this.stage);
         _loc2_.nativeStage.addEventListener("keyDown",nativeStage_keyDownHandler,false,1,true);
         super.focusInHandler(param1);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         var _loc2_:Starling = stageToStarling(this.stage);
         _loc2_.nativeStage.removeEventListener("keyDown",nativeStage_keyDownHandler);
         super.focusOutHandler(param1);
      }
      
      protected function nativeStage_keyDownHandler(param1:flash.events.KeyboardEvent) : void
      {
         var _loc3_:Boolean = false;
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         var _loc6_:* = param1.keyCode == 40;
         var _loc2_:* = param1.keyCode == 38;
         if(!_loc6_ && !_loc2_)
         {
            return;
         }
         var _loc4_:int = this.list.selectedIndex;
         var _loc5_:int = this.list.dataProvider.length - 1;
         if(_loc4_ < 0)
         {
            param1.stopImmediatePropagation();
            this._originalText = this._text;
            if(_loc6_)
            {
               this.list.selectedIndex = 0;
            }
            else
            {
               this.list.selectedIndex = _loc5_;
            }
            this.list.scrollToDisplayIndex(this.list.selectedIndex,this.list.keyScrollDuration);
            this._listHasFocus = true;
            this.list.dispatchEventWith("focusIn");
         }
         else if(_loc6_ && _loc4_ == _loc5_ || _loc2_ && _loc4_ == 0)
         {
            param1.stopImmediatePropagation();
            _loc3_ = this._ignoreAutoCompleteChanges;
            this._ignoreAutoCompleteChanges = true;
            this.text = this._originalText;
            this._ignoreAutoCompleteChanges = _loc3_;
            this.list.selectedIndex = -1;
            this.selectRange(this.text.length,this.text.length);
            this._listHasFocus = false;
            this.list.dispatchEventWith("focusOut");
         }
      }
      
      protected function autoComplete_changeHandler(param1:Event) : void
      {
         if(this._ignoreAutoCompleteChanges || !this._source || !this.hasFocus)
         {
            return;
         }
         if(this.text.length < this._minimumAutoCompleteLength)
         {
            this.removeEventListener("enterFrame",autoComplete_enterFrameHandler);
            this.closeList();
            return;
         }
         if(this._autoCompleteDelay == 0)
         {
            this.removeEventListener("enterFrame",autoComplete_enterFrameHandler);
            this._source.load(this.text,this._listCollection);
         }
         else
         {
            this._lastChangeTime = getTimer();
            this.addEventListener("enterFrame",autoComplete_enterFrameHandler);
         }
      }
      
      protected function autoComplete_enterFrameHandler() : void
      {
         var _loc1_:int = getTimer();
         var _loc2_:Number = (_loc1_ - this._lastChangeTime) / 1000;
         if(_loc2_ < this._autoCompleteDelay)
         {
            return;
         }
         this.removeEventListener("enterFrame",autoComplete_enterFrameHandler);
         this._source.load(this.text,this._listCollection);
      }
      
      protected function dataProvider_completeHandler(param1:Event, param2:ListCollection) : void
      {
         this.list.dataProvider = param2;
         if(param2.length == 0)
         {
            if(this._popUpContentManager.isOpen)
            {
               this.closeList();
            }
            return;
         }
         this.openList();
      }
      
      protected function list_changeHandler(param1:Event) : void
      {
         if(!this.list.selectedItem)
         {
            return;
         }
         var _loc2_:Boolean = this._ignoreAutoCompleteChanges;
         this._ignoreAutoCompleteChanges = true;
         this.text = this.list.selectedItem.toString();
         this.selectRange(this.text.length,this.text.length);
         this._ignoreAutoCompleteChanges = _loc2_;
      }
      
      protected function popUpContentManager_openHandler(param1:Event) : void
      {
         this.dispatchEventWith("open");
      }
      
      protected function popUpContentManager_closeHandler(param1:Event) : void
      {
         this.dispatchEventWith("close");
      }
      
      protected function list_removedFromStageHandler(param1:Event) : void
      {
         if(this._focusManager)
         {
            this.list.stage.removeEventListener("keyUp",stage_keyUpHandler);
         }
      }
      
      protected function list_triggeredHandler(param1:Event) : void
      {
         if(!this._isEnabled)
         {
            return;
         }
         this._triggered = true;
      }
      
      protected function list_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.list);
         if(_loc2_ === null)
         {
            return;
         }
         if(_loc2_.phase === "began")
         {
            this._triggered = false;
         }
         if(_loc2_.phase === "ended" && this._triggered)
         {
            this.closeList();
            this.selectRange(this.text.length,this.text.length);
         }
      }
      
      protected function stage_keyUpHandler(param1:starling.events.KeyboardEvent) : void
      {
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(param1.keyCode == 13)
         {
            this.closeList();
            this.selectRange(this.text.length,this.text.length);
         }
      }
   }
}
