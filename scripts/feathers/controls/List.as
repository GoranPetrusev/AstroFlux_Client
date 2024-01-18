package feathers.controls
{
   import feathers.controls.renderers.DefaultListItemRenderer;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.controls.supportClasses.ListDataViewPort;
   import feathers.core.IFocusContainer;
   import feathers.core.PropertyProxy;
   import feathers.data.ListCollection;
   import feathers.layout.ILayout;
   import feathers.layout.ISpinnerLayout;
   import feathers.layout.IVariableVirtualLayout;
   import feathers.layout.VerticalLayout;
   import feathers.skins.IStyleProvider;
   import flash.geom.Point;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   
   public class List extends Scroller implements IFocusContainer
   {
      
      private static const HELPER_POINT:Point = new Point();
      
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
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var dataViewPort:ListDataViewPort;
      
      protected var _isChildFocusEnabled:Boolean = true;
      
      protected var _layout:ILayout;
      
      protected var _dataProvider:ListCollection;
      
      protected var _isSelectable:Boolean = true;
      
      protected var _selectedIndex:int = -1;
      
      protected var _allowMultipleSelection:Boolean = false;
      
      protected var _selectedIndices:ListCollection;
      
      protected var _itemRendererType:Class;
      
      protected var _itemRendererFactories:Object;
      
      protected var _itemRendererFactory:Function;
      
      protected var _factoryIDFunction:Function;
      
      protected var _typicalItem:Object = null;
      
      protected var _customItemRendererStyleName:String;
      
      protected var _itemRendererProperties:PropertyProxy;
      
      protected var _keyScrollDuration:Number = 0.25;
      
      protected var pendingItemIndex:int = -1;
      
      public function List()
      {
         _selectedIndices = new ListCollection(new Vector.<int>(0));
         _itemRendererType = DefaultListItemRenderer;
         super();
         this._selectedIndices.addEventListener("change",selectedIndices_changeHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return List.globalStyleProvider;
      }
      
      override public function get isFocusEnabled() : Boolean
      {
         return (this._isSelectable || this._minHorizontalScrollPosition != this._maxHorizontalScrollPosition || this._minVerticalScrollPosition != this._maxVerticalScrollPosition) && this._isEnabled && this._isFocusEnabled;
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
         if(!(this is SpinnerList) && param1 is ISpinnerLayout)
         {
            throw new ArgumentError("Layouts that implement the ISpinnerLayout interface should be used with the SpinnerList component.");
         }
         if(this._layout)
         {
            this._layout.removeEventListener("scroll",layout_scrollHandler);
         }
         this._layout = param1;
         if(this._layout is IVariableVirtualLayout)
         {
            this._layout.addEventListener("scroll",layout_scrollHandler);
         }
         this.invalidate("layout");
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
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener("addItem",dataProvider_addItemHandler);
            this._dataProvider.removeEventListener("removeItem",dataProvider_removeItemHandler);
            this._dataProvider.removeEventListener("replaceItem",dataProvider_replaceItemHandler);
            this._dataProvider.removeEventListener("reset",dataProvider_resetHandler);
            this._dataProvider.removeEventListener("change",dataProvider_changeHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener("addItem",dataProvider_addItemHandler);
            this._dataProvider.addEventListener("removeItem",dataProvider_removeItemHandler);
            this._dataProvider.addEventListener("replaceItem",dataProvider_replaceItemHandler);
            this._dataProvider.addEventListener("reset",dataProvider_resetHandler);
            this._dataProvider.addEventListener("change",dataProvider_changeHandler);
         }
         this.horizontalScrollPosition = 0;
         this.verticalScrollPosition = 0;
         this.selectedIndex = -1;
         this.invalidate("data");
      }
      
      public function get isSelectable() : Boolean
      {
         return this._isSelectable;
      }
      
      public function set isSelectable(param1:Boolean) : void
      {
         if(this._isSelectable == param1)
         {
            return;
         }
         this._isSelectable = param1;
         if(!this._isSelectable)
         {
            this.selectedIndex = -1;
         }
         this.invalidate("selected");
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
         if(param1 >= 0)
         {
            this._selectedIndices.data = new <int>[param1];
         }
         else
         {
            this._selectedIndices.removeAll();
         }
         this.invalidate("selected");
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
      
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(param1:Boolean) : void
      {
         if(this._allowMultipleSelection == param1)
         {
            return;
         }
         this._allowMultipleSelection = param1;
         this.invalidate("selected");
      }
      
      public function get selectedIndices() : Vector.<int>
      {
         return this._selectedIndices.data as Vector.<int>;
      }
      
      public function set selectedIndices(param1:Vector.<int>) : void
      {
         var _loc2_:Vector.<int> = this._selectedIndices.data as Vector.<int>;
         if(_loc2_ == param1)
         {
            return;
         }
         if(!param1)
         {
            if(this._selectedIndices.length == 0)
            {
               return;
            }
            this._selectedIndices.removeAll();
         }
         else
         {
            if(!this._allowMultipleSelection && param1.length > 0)
            {
               param1.length = 1;
            }
            this._selectedIndices.data = param1;
         }
         this.invalidate("selected");
      }
      
      public function get selectedItems() : Vector.<Object>
      {
         return this.getSelectedItems(new Vector.<Object>(0));
      }
      
      public function set selectedItems(param1:Vector.<Object>) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Object = null;
         var _loc5_:int = 0;
         if(!param1 || !this._dataProvider)
         {
            this.selectedIndex = -1;
            return;
         }
         var _loc2_:Vector.<int> = new Vector.<int>(0);
         var _loc6_:int = int(param1.length);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc3_ = param1[_loc4_];
            if((_loc5_ = this._dataProvider.getItemIndex(_loc3_)) >= 0)
            {
               _loc2_.push(_loc5_);
            }
            _loc4_++;
         }
         this.selectedIndices = _loc2_;
      }
      
      public function getSelectedItems(param1:Vector.<Object> = null) : Vector.<Object>
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Object = null;
         if(param1)
         {
            param1.length = 0;
         }
         else
         {
            param1 = new Vector.<Object>(0);
         }
         if(!this._dataProvider)
         {
            return param1;
         }
         var _loc3_:int = this._selectedIndices.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._selectedIndices.getItemAt(_loc4_) as int;
            _loc2_ = this._dataProvider.getItemAt(_loc5_);
            param1[_loc4_] = _loc2_;
            _loc4_++;
         }
         return param1;
      }
      
      public function get itemRendererType() : Class
      {
         return this._itemRendererType;
      }
      
      public function set itemRendererType(param1:Class) : void
      {
         if(this._itemRendererType == param1)
         {
            return;
         }
         this._itemRendererType = param1;
         this.invalidate("styles");
      }
      
      public function get itemRendererFactory() : Function
      {
         return this._itemRendererFactory;
      }
      
      public function set itemRendererFactory(param1:Function) : void
      {
         if(this._itemRendererFactory === param1)
         {
            return;
         }
         this._itemRendererFactory = param1;
         this.invalidate("styles");
      }
      
      public function get factoryIDFunction() : Function
      {
         return this._factoryIDFunction;
      }
      
      public function set factoryIDFunction(param1:Function) : void
      {
         if(this._factoryIDFunction === param1)
         {
            return;
         }
         this._factoryIDFunction = param1;
         if(param1 !== null && this._itemRendererFactories === null)
         {
            this._itemRendererFactories = {};
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
         this.invalidate("data");
      }
      
      public function get customItemRendererStyleName() : String
      {
         return this._customItemRendererStyleName;
      }
      
      public function set customItemRendererStyleName(param1:String) : void
      {
         if(this._customItemRendererStyleName == param1)
         {
            return;
         }
         this._customItemRendererStyleName = param1;
         this.invalidate("styles");
      }
      
      public function get itemRendererProperties() : Object
      {
         if(!this._itemRendererProperties)
         {
            this._itemRendererProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._itemRendererProperties;
      }
      
      public function set itemRendererProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._itemRendererProperties == param1)
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
         if(this._itemRendererProperties)
         {
            this._itemRendererProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._itemRendererProperties = PropertyProxy(param1);
         if(this._itemRendererProperties)
         {
            this._itemRendererProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get keyScrollDuration() : Number
      {
         return this._keyScrollDuration;
      }
      
      public function set keyScrollDuration(param1:Number) : void
      {
         this._keyScrollDuration = param1;
      }
      
      override public function scrollToPosition(param1:Number, param2:Number, param3:Number = NaN) : void
      {
         this.pendingItemIndex = -1;
         super.scrollToPosition(param1,param2,param3);
      }
      
      override public function scrollToPageIndex(param1:int, param2:int, param3:Number = NaN) : void
      {
         this.pendingItemIndex = -1;
         super.scrollToPageIndex(param1,param2,param3);
      }
      
      public function scrollToDisplayIndex(param1:int, param2:Number = 0) : void
      {
         this.hasPendingHorizontalPageIndex = false;
         this.hasPendingVerticalPageIndex = false;
         this.pendingHorizontalScrollPosition = NaN;
         this.pendingVerticalScrollPosition = NaN;
         if(this.pendingItemIndex == param1 && this.pendingScrollDuration == param2)
         {
            return;
         }
         this.pendingItemIndex = param1;
         this.pendingScrollDuration = param2;
         this.invalidate("pendingScroll");
      }
      
      public function getItemRendererFactoryWithID(param1:String) : Function
      {
         if(this._itemRendererFactories && param1 in this._itemRendererFactories)
         {
            return this._itemRendererFactories[param1] as Function;
         }
         return null;
      }
      
      public function setItemRendererFactoryWithID(param1:String, param2:Function) : void
      {
         if(param1 === null)
         {
            this.itemRendererFactory = param2;
            return;
         }
         if(this._itemRendererFactories === null)
         {
            this._itemRendererFactories = {};
         }
         if(param2 !== null)
         {
            this._itemRendererFactories[param1] = param2;
         }
         else
         {
            delete this._itemRendererFactories[param1];
         }
      }
      
      public function itemToItemRenderer(param1:Object) : IListItemRenderer
      {
         return this.dataViewPort.itemToItemRenderer(param1);
      }
      
      override public function dispose() : void
      {
         this._selectedIndices.removeEventListeners();
         this._selectedIndex = -1;
         this.dataProvider = null;
         this.layout = null;
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         var _loc1_:VerticalLayout = null;
         var _loc2_:* = this._layout != null;
         super.initialize();
         if(!this.dataViewPort)
         {
            this.viewPort = this.dataViewPort = new ListDataViewPort();
            this.dataViewPort.owner = this;
            this.viewPort = this.dataViewPort;
         }
         if(!_loc2_)
         {
            if(this._hasElasticEdges && this._verticalScrollPolicy === "auto" && this._scrollBarDisplayMode !== "fixed")
            {
               this.verticalScrollPolicy = "on";
            }
            _loc1_ = new VerticalLayout();
            _loc1_.useVirtualLayout = true;
            _loc1_.padding = 0;
            _loc1_.gap = 0;
            _loc1_.horizontalAlign = "justify";
            _loc1_.verticalAlign = "top";
            this.layout = _loc1_;
         }
      }
      
      override protected function draw() : void
      {
         this.refreshDataViewPortProperties();
         super.draw();
      }
      
      protected function refreshDataViewPortProperties() : void
      {
         this.dataViewPort.isSelectable = this._isSelectable;
         this.dataViewPort.allowMultipleSelection = this._allowMultipleSelection;
         this.dataViewPort.selectedIndices = this._selectedIndices;
         this.dataViewPort.dataProvider = this._dataProvider;
         this.dataViewPort.itemRendererType = this._itemRendererType;
         this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
         this.dataViewPort.itemRendererFactories = this._itemRendererFactories;
         this.dataViewPort.factoryIDFunction = this._factoryIDFunction;
         this.dataViewPort.itemRendererProperties = this._itemRendererProperties;
         this.dataViewPort.customItemRendererStyleName = this._customItemRendererStyleName;
         this.dataViewPort.typicalItem = this._typicalItem;
         this.dataViewPort.layout = this._layout;
      }
      
      override protected function handlePendingScroll() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.pendingItemIndex >= 0)
         {
            _loc1_ = this._dataProvider.getItemAt(this.pendingItemIndex);
            if(_loc1_ is Object)
            {
               this.dataViewPort.getScrollPositionForIndex(this.pendingItemIndex,HELPER_POINT);
               this.pendingItemIndex = -1;
               _loc2_ = HELPER_POINT.x;
               if(_loc2_ < this._minHorizontalScrollPosition)
               {
                  _loc2_ = this._minHorizontalScrollPosition;
               }
               else if(_loc2_ > this._maxHorizontalScrollPosition)
               {
                  _loc2_ = this._maxHorizontalScrollPosition;
               }
               _loc3_ = HELPER_POINT.y;
               if(_loc3_ < this._minVerticalScrollPosition)
               {
                  _loc3_ = this._minVerticalScrollPosition;
               }
               else if(_loc3_ > this._maxVerticalScrollPosition)
               {
                  _loc3_ = this._maxVerticalScrollPosition;
               }
               this.throwTo(_loc2_,_loc3_,this.pendingScrollDuration);
            }
         }
         super.handlePendingScroll();
      }
      
      override protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this._dataProvider)
         {
            return;
         }
         var _loc2_:Boolean = false;
         if(param1.keyCode == 36)
         {
            if(this._dataProvider.length > 0)
            {
               this.selectedIndex = 0;
               _loc2_ = true;
            }
         }
         else if(param1.keyCode == 35)
         {
            this.selectedIndex = this._dataProvider.length - 1;
            _loc2_ = true;
         }
         else if(param1.keyCode == 38)
         {
            this.selectedIndex = Math.max(0,this._selectedIndex - 1);
            _loc2_ = true;
         }
         else if(param1.keyCode == 40)
         {
            this.selectedIndex = Math.min(this._dataProvider.length - 1,this._selectedIndex + 1);
            _loc2_ = true;
         }
         if(_loc2_)
         {
            this.dataViewPort.getNearestScrollPositionForIndex(this.selectedIndex,HELPER_POINT);
            this.scrollToPosition(HELPER_POINT.x,HELPER_POINT.y,this._keyScrollDuration);
         }
      }
      
      protected function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate("data");
      }
      
      protected function dataProvider_resetHandler(param1:Event) : void
      {
         this.horizontalScrollPosition = 0;
         this.verticalScrollPosition = 0;
         this._selectedIndices.removeAll();
      }
      
      protected function dataProvider_addItemHandler(param1:Event, param2:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this._selectedIndex == -1)
         {
            return;
         }
         var _loc3_:Boolean = false;
         var _loc7_:Vector.<int> = new Vector.<int>(0);
         var _loc4_:int = this._selectedIndices.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if((_loc6_ = this._selectedIndices.getItemAt(_loc5_) as int) >= param2)
            {
               _loc6_++;
               _loc3_ = true;
            }
            _loc7_.push(_loc6_);
            _loc5_++;
         }
         if(_loc3_)
         {
            this._selectedIndices.data = _loc7_;
         }
      }
      
      protected function dataProvider_removeItemHandler(param1:Event, param2:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this._selectedIndex == -1)
         {
            return;
         }
         var _loc3_:Boolean = false;
         var _loc7_:Vector.<int> = new Vector.<int>(0);
         var _loc4_:int = this._selectedIndices.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if((_loc6_ = this._selectedIndices.getItemAt(_loc5_) as int) == param2)
            {
               _loc3_ = true;
            }
            else
            {
               if(_loc6_ > param2)
               {
                  _loc6_--;
                  _loc3_ = true;
               }
               _loc7_.push(_loc6_);
            }
            _loc5_++;
         }
         if(_loc3_)
         {
            this._selectedIndices.data = _loc7_;
         }
      }
      
      protected function dataProvider_replaceItemHandler(param1:Event, param2:int) : void
      {
         if(this._selectedIndex == -1)
         {
            return;
         }
         var _loc3_:int = this._selectedIndices.getItemIndex(param2);
         if(_loc3_ >= 0)
         {
            this._selectedIndices.removeItemAt(_loc3_);
         }
      }
      
      protected function selectedIndices_changeHandler(param1:Event) : void
      {
         if(this._selectedIndices.length > 0)
         {
            this._selectedIndex = this._selectedIndices.getItemAt(0) as int;
         }
         else
         {
            if(this._selectedIndex < 0)
            {
               return;
            }
            this._selectedIndex = -1;
         }
         this.dispatchEventWith("change");
      }
      
      private function layout_scrollHandler(param1:Event, param2:Point) : void
      {
         var _loc3_:IVariableVirtualLayout = IVariableVirtualLayout(this._layout);
         if(!this.isScrolling || !_loc3_.useVirtualLayout || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc4_:Number = param2.x;
         this._startHorizontalScrollPosition += _loc4_;
         this._horizontalScrollPosition += _loc4_;
         if(this._horizontalAutoScrollTween)
         {
            this._targetHorizontalScrollPosition += _loc4_;
            this.throwTo(this._targetHorizontalScrollPosition,NaN,this._horizontalAutoScrollTween.totalTime - this._horizontalAutoScrollTween.currentTime);
         }
         var _loc5_:Number = param2.y;
         this._startVerticalScrollPosition += _loc5_;
         this._verticalScrollPosition += _loc5_;
         if(this._verticalAutoScrollTween)
         {
            this._targetVerticalScrollPosition += _loc5_;
            this.throwTo(NaN,this._targetVerticalScrollPosition,this._verticalAutoScrollTween.totalTime - this._verticalAutoScrollTween.currentTime);
         }
      }
   }
}
