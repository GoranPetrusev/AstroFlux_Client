package feathers.controls
{
   import feathers.controls.popups.CalloutPopUpContentManager;
   import feathers.controls.popups.DropDownPopUpContentManager;
   import feathers.controls.popups.IPersistentPopUpContentManager;
   import feathers.controls.popups.IPopUpContentManager;
   import feathers.controls.popups.IPopUpContentManagerWithPrompt;
   import feathers.controls.popups.VerticalCenteredPopUpContentManager;
   import feathers.core.FeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IToggle;
   import feathers.core.PropertyProxy;
   import feathers.data.ListCollection;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.utils.SystemUtil;
   
   public class PickerList extends FeathersControl implements IFocusDisplayObject
   {
      
      protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";
      
      protected static const INVALIDATION_FLAG_LIST_FACTORY:String = "listFactory";
      
      public static const DEFAULT_CHILD_STYLE_NAME_BUTTON:String = "feathers-picker-list-button";
      
      public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-picker-list-list";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var buttonStyleName:String = "feathers-picker-list-button";
      
      protected var listStyleName:String = "feathers-picker-list-list";
      
      protected var button:Button;
      
      protected var list:List;
      
      protected var buttonExplicitWidth:Number;
      
      protected var buttonExplicitHeight:Number;
      
      protected var buttonExplicitMinWidth:Number;
      
      protected var buttonExplicitMinHeight:Number;
      
      protected var _dataProvider:ListCollection;
      
      protected var _ignoreSelectionChanges:Boolean = false;
      
      protected var _selectedIndex:int = -1;
      
      protected var _prompt:String;
      
      protected var _labelField:String = "label";
      
      protected var _labelFunction:Function;
      
      protected var _popUpContentManager:IPopUpContentManager;
      
      protected var _typicalItem:Object = null;
      
      protected var _buttonFactory:Function;
      
      protected var _customButtonStyleName:String;
      
      protected var _buttonProperties:PropertyProxy;
      
      protected var _listFactory:Function;
      
      protected var _customListStyleName:String;
      
      protected var _listProperties:PropertyProxy;
      
      protected var _toggleButtonOnOpenAndClose:Boolean = false;
      
      protected var _triggered:Boolean = false;
      
      protected var _isOpenListPending:Boolean = false;
      
      protected var _isCloseListPending:Boolean = false;
      
      protected var _buttonHasFocus:Boolean = false;
      
      protected var _buttonTouchPointID:int = -1;
      
      protected var _listIsOpenOnTouchBegan:Boolean = false;
      
      public function PickerList()
      {
         super();
      }
      
      protected static function defaultButtonFactory() : Button
      {
         return new Button();
      }
      
      protected static function defaultListFactory() : List
      {
         return new List();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return PickerList.globalStyleProvider;
      }
      
      public function get dataProvider() : ListCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:ListCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         var _loc3_:int = this.selectedIndex;
         var _loc2_:Object = this.selectedItem;
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener("reset",dataProvider_multipleEventHandler);
            this._dataProvider.removeEventListener("addItem",dataProvider_multipleEventHandler);
            this._dataProvider.removeEventListener("removeItem",dataProvider_multipleEventHandler);
            this._dataProvider.removeEventListener("replaceItem",dataProvider_multipleEventHandler);
            this._dataProvider.removeEventListener("updateItem",dataProvider_updateItemHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener("reset",dataProvider_multipleEventHandler);
            this._dataProvider.addEventListener("addItem",dataProvider_multipleEventHandler);
            this._dataProvider.addEventListener("removeItem",dataProvider_multipleEventHandler);
            this._dataProvider.addEventListener("replaceItem",dataProvider_multipleEventHandler);
            this._dataProvider.addEventListener("updateItem",dataProvider_updateItemHandler);
         }
         if(!this._dataProvider || this._dataProvider.length == 0)
         {
            this.selectedIndex = -1;
         }
         else
         {
            this.selectedIndex = 0;
         }
         if(this.selectedIndex == _loc3_ && this.selectedItem != _loc2_)
         {
            this.dispatchEventWith("change");
         }
         this.invalidate("data");
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
         this.invalidate("selected");
         this.dispatchEventWith("change");
      }
      
      public function get selectedItem() : Object
      {
         if(!this._dataProvider || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length)
         {
            return null;
         }
         return this._dataProvider.getItemAt(this._selectedIndex);
      }
      
      public function set selectedItem(param1:Object) : void
      {
         if(!this._dataProvider)
         {
            this.selectedIndex = -1;
            return;
         }
         this.selectedIndex = this._dataProvider.getItemIndex(param1);
      }
      
      public function get prompt() : String
      {
         return this._prompt;
      }
      
      public function set prompt(param1:String) : void
      {
         if(this._prompt == param1)
         {
            return;
         }
         this._prompt = param1;
         this.invalidate("selected");
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(param1:String) : void
      {
         if(this._labelField == param1)
         {
            return;
         }
         this._labelField = param1;
         this.invalidate("data");
      }
      
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         this._labelFunction = param1;
         this.invalidate("data");
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
      
      public function get typicalItem() : Object
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(param1:Object) : void
      {
         if(this._typicalItem == param1)
         {
            return;
         }
         this._typicalItem = param1;
         this.invalidate("styles");
      }
      
      public function get buttonFactory() : Function
      {
         return this._buttonFactory;
      }
      
      public function set buttonFactory(param1:Function) : void
      {
         if(this._buttonFactory == param1)
         {
            return;
         }
         this._buttonFactory = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get customButtonStyleName() : String
      {
         return this._customButtonStyleName;
      }
      
      public function set customButtonStyleName(param1:String) : void
      {
         if(this._customButtonStyleName == param1)
         {
            return;
         }
         this._customButtonStyleName = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get buttonProperties() : Object
      {
         if(!this._buttonProperties)
         {
            this._buttonProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._buttonProperties;
      }
      
      public function set buttonProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._buttonProperties == param1)
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
         if(this._buttonProperties)
         {
            this._buttonProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._buttonProperties = PropertyProxy(param1);
         if(this._buttonProperties)
         {
            this._buttonProperties.addOnChangeCallback(childProperties_onChange);
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
      
      public function get toggleButtonOnOpenAndClose() : Boolean
      {
         return this._toggleButtonOnOpenAndClose;
      }
      
      public function set toggleButtonOnOpenAndClose(param1:Boolean) : void
      {
         if(this._toggleButtonOnOpenAndClose == param1)
         {
            return;
         }
         this._toggleButtonOnOpenAndClose = param1;
         if(this.button is IToggle)
         {
            if(this._toggleButtonOnOpenAndClose && this._popUpContentManager.isOpen)
            {
               IToggle(this.button).isSelected = true;
            }
            else
            {
               IToggle(this.button).isSelected = false;
            }
         }
      }
      
      public function get baseline() : Number
      {
         if(!this.button)
         {
            return this.scaledActualHeight;
         }
         return this.scaleY * (this.button.y + this.button.baseline);
      }
      
      public function itemToLabel(param1:Object) : String
      {
         var _loc2_:Object = null;
         if(this._labelFunction !== null)
         {
            _loc2_ = this._labelFunction(param1);
            if(_loc2_ is String)
            {
               return _loc2_ as String;
            }
            if(_loc2_ !== null)
            {
               return _loc2_.toString();
            }
         }
         else if(this._labelField !== null && param1 !== null && param1.hasOwnProperty(this._labelField))
         {
            _loc2_ = param1[this._labelField];
            if(_loc2_ is String)
            {
               return _loc2_ as String;
            }
            if(_loc2_ !== null)
            {
               return _loc2_.toString();
            }
         }
         else
         {
            if(param1 is String)
            {
               return param1 as String;
            }
            if(param1 !== null)
            {
               return param1.toString();
            }
         }
         return null;
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
         if(this._popUpContentManager is IPopUpContentManagerWithPrompt)
         {
            IPopUpContentManagerWithPrompt(this._popUpContentManager).prompt = this._prompt;
         }
         this._popUpContentManager.open(this.list,this);
         this.list.scrollToDisplayIndex(this._selectedIndex);
         this.list.validate();
         if(this._focusManager)
         {
            this._focusManager.focus = this.list;
            this.stage.addEventListener("keyUp",stage_keyUpHandler);
            this.list.addEventListener("focusOut",list_focusOutHandler);
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
         this._isCloseListPending = false;
         this.list.validate();
         this._popUpContentManager.close();
      }
      
      override public function dispose() : void
      {
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
         this._selectedIndex = -1;
         this.dataProvider = null;
         super.dispose();
      }
      
      override public function showFocus() : void
      {
         if(!this.button)
         {
            return;
         }
         this.button.showFocus();
      }
      
      override public function hideFocus() : void
      {
         if(!this.button)
         {
            return;
         }
         this.button.hideFocus();
      }
      
      override protected function initialize() : void
      {
         if(!this._popUpContentManager)
         {
            if(SystemUtil.isDesktop)
            {
               this.popUpContentManager = new DropDownPopUpContentManager();
            }
            else if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
            {
               this.popUpContentManager = new CalloutPopUpContentManager();
            }
            else
            {
               this.popUpContentManager = new VerticalCenteredPopUpContentManager();
            }
         }
      }
      
      override protected function draw() : void
      {
         var _loc8_:Boolean = false;
         var _loc5_:Boolean = this.isInvalid("data");
         var _loc6_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("state");
         var _loc3_:Boolean = this.isInvalid("selected");
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc7_:Boolean = this.isInvalid("buttonFactory");
         var _loc4_:Boolean = this.isInvalid("listFactory");
         if(_loc7_)
         {
            this.createButton();
         }
         if(_loc4_)
         {
            this.createList();
         }
         if(_loc7_ || _loc6_ || _loc3_)
         {
            if(this._explicitWidth !== this._explicitWidth)
            {
               this.button.width = NaN;
            }
            if(this._explicitHeight !== this._explicitHeight)
            {
               this.button.height = NaN;
            }
         }
         if(_loc7_ || _loc6_)
         {
            this.refreshButtonProperties();
         }
         if(_loc4_ || _loc6_)
         {
            this.refreshListProperties();
         }
         if(_loc4_ || _loc5_)
         {
            _loc8_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.list.dataProvider = this._dataProvider;
            this._ignoreSelectionChanges = _loc8_;
         }
         if(_loc7_ || _loc4_ || _loc2_)
         {
            this.button.isEnabled = this._isEnabled;
            this.list.isEnabled = this._isEnabled;
         }
         if(_loc7_ || _loc5_ || _loc3_)
         {
            this.refreshButtonLabel();
         }
         if(_loc4_ || _loc5_ || _loc3_)
         {
            _loc8_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.list.selectedIndex = this._selectedIndex;
            this._ignoreSelectionChanges = _loc8_;
         }
         this.autoSizeIfNeeded();
         this.layout();
         if(this.list.stage)
         {
            this.list.validate();
         }
         this.handlePendingActions();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc4_:* = this._explicitWidth !== this._explicitWidth;
         var _loc9_:* = this._explicitHeight !== this._explicitHeight;
         var _loc5_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc11_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc4_ && !_loc9_ && !_loc5_ && !_loc11_)
         {
            return false;
         }
         var _loc12_:Number = this._explicitWidth;
         if(_loc12_ !== _loc12_)
         {
            _loc12_ = this.buttonExplicitWidth;
         }
         var _loc2_:Number = this._explicitHeight;
         if(_loc2_ !== _loc2_)
         {
            _loc2_ = this.buttonExplicitHeight;
         }
         var _loc7_:Number = this._explicitMinWidth;
         if(_loc7_ !== _loc7_)
         {
            _loc7_ = this.buttonExplicitMinWidth;
         }
         var _loc10_:Number = this._explicitMinHeight;
         if(_loc10_ !== _loc10_)
         {
            _loc10_ = this.buttonExplicitMinHeight;
         }
         if(this._typicalItem !== null)
         {
            this.button.label = this.itemToLabel(this._typicalItem);
         }
         this.button.width = _loc12_;
         this.button.height = _loc2_;
         this.button.minWidth = _loc7_;
         this.button.minHeight = _loc10_;
         this.button.validate();
         if(this._typicalItem !== null)
         {
            this.refreshButtonLabel();
         }
         var _loc3_:Number = this._explicitWidth;
         var _loc6_:Number = this._explicitHeight;
         var _loc1_:Number = this._explicitMinWidth;
         var _loc8_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            _loc3_ = this.button.width;
         }
         if(_loc9_)
         {
            _loc6_ = this.button.height;
         }
         if(_loc5_)
         {
            _loc1_ = this.button.minWidth;
         }
         if(_loc11_)
         {
            _loc8_ = this.button.minHeight;
         }
         return this.saveMeasurements(_loc3_,_loc6_,_loc1_,_loc8_);
      }
      
      protected function createButton() : void
      {
         if(this.button)
         {
            this.button.removeFromParent(true);
            this.button = null;
         }
         var _loc1_:Function = this._buttonFactory != null ? this._buttonFactory : defaultButtonFactory;
         var _loc2_:String = this._customButtonStyleName != null ? this._customButtonStyleName : this.buttonStyleName;
         this.button = Button(_loc1_());
         if(this.button is ToggleButton)
         {
            ToggleButton(this.button).isToggle = false;
         }
         this.button.styleNameList.add(_loc2_);
         this.button.addEventListener("touch",button_touchHandler);
         this.button.addEventListener("triggered",button_triggeredHandler);
         this.addChild(this.button);
         this.button.initializeNow();
         this.buttonExplicitWidth = this.button.explicitWidth;
         this.buttonExplicitHeight = this.button.explicitHeight;
         this.buttonExplicitMinWidth = this.button.explicitMinWidth;
         this.buttonExplicitMinHeight = this.button.explicitMinHeight;
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
         this.list.styleNameList.add(_loc2_);
         this.list.addEventListener("change",list_changeHandler);
         this.list.addEventListener("triggered",list_triggeredHandler);
         this.list.addEventListener("touch",list_touchHandler);
         this.list.addEventListener("removedFromStage",list_removedFromStageHandler);
      }
      
      protected function refreshButtonLabel() : void
      {
         if(this._selectedIndex >= 0)
         {
            this.button.label = this.itemToLabel(this.selectedItem);
         }
         else
         {
            this.button.label = this._prompt;
         }
      }
      
      protected function refreshButtonProperties() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._buttonProperties)
         {
            _loc2_ = this._buttonProperties[_loc1_];
            this.button[_loc1_] = _loc2_;
         }
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
      
      protected function layout() : void
      {
         this.button.width = this.actualWidth;
         this.button.height = this.actualHeight;
         this.button.validate();
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
         super.focusInHandler(param1);
         this._buttonHasFocus = true;
         this.button.dispatchEventWith("focusIn");
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         if(this._buttonHasFocus)
         {
            this.button.dispatchEventWith("focusOut");
            this._buttonHasFocus = false;
         }
         super.focusOutHandler(param1);
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      protected function button_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(this._buttonTouchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.button,"ended",this._buttonTouchPointID);
            if(!_loc2_)
            {
               return;
            }
            this._buttonTouchPointID = -1;
            this._listIsOpenOnTouchBegan = false;
         }
         else
         {
            _loc2_ = param1.getTouch(this.button,"began");
            if(!_loc2_)
            {
               return;
            }
            this._buttonTouchPointID = _loc2_.id;
            this._listIsOpenOnTouchBegan = this._popUpContentManager.isOpen;
         }
      }
      
      protected function button_triggeredHandler(param1:Event) : void
      {
         if(this._focusManager && this._listIsOpenOnTouchBegan)
         {
            return;
         }
         if(this._popUpContentManager.isOpen)
         {
            this.closeList();
            return;
         }
         this.openList();
      }
      
      protected function list_changeHandler(param1:Event) : void
      {
         if(this._ignoreSelectionChanges || this._popUpContentManager is IPersistentPopUpContentManager)
         {
            return;
         }
         this.selectedIndex = this.list.selectedIndex;
      }
      
      protected function popUpContentManager_openHandler(param1:Event) : void
      {
         if(this._toggleButtonOnOpenAndClose && this.button is IToggle)
         {
            IToggle(this.button).isSelected = true;
         }
         this.dispatchEventWith("open");
      }
      
      protected function popUpContentManager_closeHandler(param1:Event) : void
      {
         if(this._popUpContentManager is IPersistentPopUpContentManager)
         {
            this.selectedIndex = this.list.selectedIndex;
         }
         if(this._toggleButtonOnOpenAndClose && this.button is IToggle)
         {
            IToggle(this.button).isSelected = false;
         }
         this.dispatchEventWith("close");
      }
      
      protected function list_removedFromStageHandler(param1:Event) : void
      {
         if(this._focusManager)
         {
            this.list.stage.removeEventListener("keyUp",stage_keyUpHandler);
            this.list.removeEventListener("focusOut",list_focusOutHandler);
         }
      }
      
      protected function list_focusOutHandler(param1:Event) : void
      {
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         this.closeList();
      }
      
      protected function list_triggeredHandler(param1:Event) : void
      {
         if(!this._isEnabled || this._popUpContentManager is IPersistentPopUpContentManager)
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
         }
      }
      
      protected function dataProvider_multipleEventHandler(param1:Event) : void
      {
         this.validate();
      }
      
      protected function dataProvider_updateItemHandler(param1:Event, param2:int) : void
      {
         if(param2 === this._selectedIndex)
         {
            this.invalidate("selected");
         }
      }
      
      protected function stage_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(param1.keyCode == 13)
         {
            this.closeList();
         }
      }
   }
}
