package feathers.controls.supportClasses
{
   import feathers.controls.GroupedList;
   import feathers.controls.Scroller;
   import feathers.controls.renderers.IGroupedListFooterRenderer;
   import feathers.controls.renderers.IGroupedListHeaderRenderer;
   import feathers.controls.renderers.IGroupedListItemRenderer;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.data.HierarchicalCollection;
   import feathers.layout.IGroupedLayout;
   import feathers.layout.ILayout;
   import feathers.layout.IVariableVirtualLayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ViewPortBounds;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class GroupedListDataViewPort extends FeathersControl implements IViewPort
   {
      
      private static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";
      
      private static const FIRST_ITEM_RENDERER_FACTORY_ID:String = "GroupedListDataViewPort-first";
      
      private static const SINGLE_ITEM_RENDERER_FACTORY_ID:String = "GroupedListDataViewPort-single";
      
      private static const LAST_ITEM_RENDERER_FACTORY_ID:String = "GroupedListDataViewPort-last";
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const HELPER_VECTOR:Vector.<int> = new Vector.<int>(0);
       
      
      private var touchPointID:int = -1;
      
      private var _viewPortBounds:ViewPortBounds;
      
      private var _layoutResult:LayoutBoundsResult;
      
      private var _actualMinVisibleWidth:Number = 0;
      
      private var _explicitMinVisibleWidth:Number;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var _actualVisibleWidth:Number = NaN;
      
      private var _explicitVisibleWidth:Number = NaN;
      
      private var _actualMinVisibleHeight:Number = 0;
      
      private var _explicitMinVisibleHeight:Number;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var _actualVisibleHeight:Number;
      
      private var _explicitVisibleHeight:Number = NaN;
      
      protected var _contentX:Number = 0;
      
      protected var _contentY:Number = 0;
      
      private var _layoutItems:Vector.<DisplayObject>;
      
      private var _typicalItemIsInDataProvider:Boolean = false;
      
      private var _typicalItemRenderer:IGroupedListItemRenderer;
      
      private var _unrenderedItems:Vector.<int>;
      
      private var _defaultItemRendererStorage:ItemRendererFactoryStorage;
      
      private var _itemStorageMap:Object;
      
      private var _itemRendererMap:Dictionary;
      
      private var _unrenderedHeaders:Vector.<int>;
      
      private var _defaultHeaderRendererStorage:HeaderRendererFactoryStorage;
      
      private var _headerStorageMap:Object;
      
      private var _headerRendererMap:Dictionary;
      
      private var _unrenderedFooters:Vector.<int>;
      
      private var _defaultFooterRendererStorage:FooterRendererFactoryStorage;
      
      private var _footerStorageMap:Object;
      
      private var _footerRendererMap:Dictionary;
      
      private var _headerIndices:Vector.<int>;
      
      private var _footerIndices:Vector.<int>;
      
      private var _isScrolling:Boolean = false;
      
      private var _owner:GroupedList;
      
      private var _updateForDataReset:Boolean = false;
      
      private var _dataProvider:HierarchicalCollection;
      
      private var _isSelectable:Boolean = true;
      
      private var _selectedGroupIndex:int = -1;
      
      private var _selectedItemIndex:int = -1;
      
      private var _itemRendererType:Class;
      
      private var _itemRendererFactory:Function;
      
      private var _itemRendererFactories:Object;
      
      private var _factoryIDFunction:Function;
      
      private var _customItemRendererStyleName:String;
      
      private var _typicalItem:Object = null;
      
      private var _itemRendererProperties:PropertyProxy;
      
      private var _firstItemRendererType:Class;
      
      private var _firstItemRendererFactory:Function;
      
      private var _customFirstItemRendererStyleName:String;
      
      private var _lastItemRendererType:Class;
      
      private var _lastItemRendererFactory:Function;
      
      private var _customLastItemRendererStyleName:String;
      
      private var _singleItemRendererType:Class;
      
      private var _singleItemRendererFactory:Function;
      
      private var _customSingleItemRendererStyleName:String;
      
      private var _headerRendererType:Class;
      
      private var _headerRendererFactory:Function;
      
      private var _headerRendererFactories:Object;
      
      private var _headerFactoryIDFunction:Function;
      
      private var _customHeaderRendererStyleName:String;
      
      private var _headerRendererProperties:PropertyProxy;
      
      private var _footerRendererType:Class;
      
      private var _footerRendererFactory:Function;
      
      private var _footerRendererFactories:Object;
      
      private var _footerFactoryIDFunction:Function;
      
      private var _customFooterRendererStyleName:String;
      
      private var _footerRendererProperties:PropertyProxy;
      
      private var _ignoreLayoutChanges:Boolean = false;
      
      private var _ignoreRendererResizing:Boolean = false;
      
      private var _layout:ILayout;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      private var _minimumItemCount:int;
      
      private var _minimumHeaderCount:int;
      
      private var _minimumFooterCount:int;
      
      private var _minimumFirstAndLastItemCount:int;
      
      private var _minimumSingleItemCount:int;
      
      private var _ignoreSelectionChanges:Boolean = false;
      
      public function GroupedListDataViewPort()
      {
         _viewPortBounds = new ViewPortBounds();
         _layoutResult = new LayoutBoundsResult();
         _layoutItems = new Vector.<DisplayObject>(0);
         _unrenderedItems = new Vector.<int>(0);
         _defaultItemRendererStorage = new ItemRendererFactoryStorage();
         _itemStorageMap = {};
         _itemRendererMap = new Dictionary(true);
         _unrenderedHeaders = new Vector.<int>(0);
         _defaultHeaderRendererStorage = new HeaderRendererFactoryStorage();
         _headerRendererMap = new Dictionary(true);
         _unrenderedFooters = new Vector.<int>(0);
         _defaultFooterRendererStorage = new FooterRendererFactoryStorage();
         _footerRendererMap = new Dictionary(true);
         _headerIndices = new Vector.<int>(0);
         _footerIndices = new Vector.<int>(0);
         super();
         this.addEventListener("touch",touchHandler);
         this.addEventListener("removedFromStage",removedFromStageHandler);
      }
      
      public function get minVisibleWidth() : Number
      {
         if(this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return this._actualMinVisibleWidth;
         }
         return this._explicitMinVisibleWidth;
      }
      
      public function set minVisibleWidth(param1:Number) : void
      {
         if(this._explicitMinVisibleWidth == param1)
         {
            return;
         }
         var _loc2_:* = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleWidth;
         this._explicitMinVisibleWidth = param1;
         if(_loc2_)
         {
            this._actualMinVisibleWidth = 0;
            this.invalidate("size");
         }
         else
         {
            this._actualMinVisibleWidth = param1;
            if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth < param1 || this._actualVisibleWidth === _loc3_))
            {
               this.invalidate("size");
            }
         }
      }
      
      public function get maxVisibleWidth() : Number
      {
         return this._maxVisibleWidth;
      }
      
      public function set maxVisibleWidth(param1:Number) : void
      {
         if(this._maxVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleWidth cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleWidth;
         this._maxVisibleWidth = param1;
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth > param1 || this._actualVisibleWidth === _loc2_))
         {
            this.invalidate("size");
         }
      }
      
      public function get visibleWidth() : Number
      {
         return this._actualVisibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this._explicitVisibleWidth == param1 || param1 !== param1 && this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return;
         }
         this._explicitVisibleWidth = param1;
         if(this._actualVisibleWidth !== param1)
         {
            this.invalidate("size");
         }
      }
      
      public function get minVisibleHeight() : Number
      {
         if(this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return this._actualMinVisibleHeight;
         }
         return this._explicitMinVisibleHeight;
      }
      
      public function set minVisibleHeight(param1:Number) : void
      {
         if(this._explicitMinVisibleHeight == param1)
         {
            return;
         }
         var _loc2_:* = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleHeight;
         this._explicitMinVisibleHeight = param1;
         if(_loc2_)
         {
            this._actualMinVisibleHeight = 0;
            this.invalidate("size");
         }
         else
         {
            this._actualMinVisibleHeight = param1;
            if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight < param1 || this._actualVisibleHeight === _loc3_))
            {
               this.invalidate("size");
            }
         }
      }
      
      public function get maxVisibleHeight() : Number
      {
         return this._maxVisibleHeight;
      }
      
      public function set maxVisibleHeight(param1:Number) : void
      {
         if(this._maxVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleHeight cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleHeight;
         this._maxVisibleHeight = param1;
         if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight > param1 || this._actualVisibleHeight === _loc2_))
         {
            this.invalidate("size");
         }
      }
      
      public function get visibleHeight() : Number
      {
         return this._actualVisibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this._explicitVisibleHeight == param1 || param1 !== param1 && this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return;
         }
         this._explicitVisibleHeight = param1;
         if(this._actualVisibleHeight !== param1)
         {
            this.invalidate("size");
         }
      }
      
      public function get contentX() : Number
      {
         return this._contentX;
      }
      
      public function get contentY() : Number
      {
         return this._contentY;
      }
      
      public function get horizontalScrollStep() : Number
      {
         if(this._typicalItemRenderer === null)
         {
            return 0;
         }
         var _loc1_:Number = Number(this._typicalItemRenderer.width);
         var _loc2_:Number = Number(this._typicalItemRenderer.height);
         if(_loc1_ < _loc2_)
         {
            return _loc1_;
         }
         return _loc2_;
      }
      
      public function get verticalScrollStep() : Number
      {
         if(this._typicalItemRenderer === null)
         {
            return 0;
         }
         var _loc1_:Number = Number(this._typicalItemRenderer.width);
         var _loc2_:Number = Number(this._typicalItemRenderer.height);
         if(_loc1_ < _loc2_)
         {
            return _loc1_;
         }
         return _loc2_;
      }
      
      public function get owner() : GroupedList
      {
         return this._owner;
      }
      
      public function set owner(param1:GroupedList) : void
      {
         if(this._owner == param1)
         {
            return;
         }
         if(this._owner)
         {
            this._owner.removeEventListener("scrollStart",owner_scrollStartHandler);
         }
         this._owner = param1;
         if(this._owner)
         {
            this._owner.addEventListener("scrollStart",owner_scrollStartHandler);
         }
      }
      
      public function get dataProvider() : HierarchicalCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:HierarchicalCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener("change",dataProvider_changeHandler);
            this._dataProvider.removeEventListener("reset",dataProvider_resetHandler);
            this._dataProvider.removeEventListener("addItem",dataProvider_addItemHandler);
            this._dataProvider.removeEventListener("removeItem",dataProvider_removeItemHandler);
            this._dataProvider.removeEventListener("replaceItem",dataProvider_replaceItemHandler);
            this._dataProvider.removeEventListener("updateItem",dataProvider_updateItemHandler);
            this._dataProvider.removeEventListener("updateAll",dataProvider_updateAllHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener("change",dataProvider_changeHandler);
            this._dataProvider.addEventListener("reset",dataProvider_resetHandler);
            this._dataProvider.addEventListener("addItem",dataProvider_addItemHandler);
            this._dataProvider.addEventListener("removeItem",dataProvider_removeItemHandler);
            this._dataProvider.addEventListener("replaceItem",dataProvider_replaceItemHandler);
            this._dataProvider.addEventListener("updateItem",dataProvider_updateItemHandler);
            this._dataProvider.addEventListener("updateAll",dataProvider_updateAllHandler);
         }
         if(this._layout is IVariableVirtualLayout)
         {
            IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
         }
         this._updateForDataReset = true;
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
            this.setSelectedLocation(-1,-1);
         }
         this.invalidate("selected");
      }
      
      public function get selectedGroupIndex() : int
      {
         return this._selectedGroupIndex;
      }
      
      public function get selectedItemIndex() : int
      {
         return this._selectedItemIndex;
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
         this.invalidate("itemRendererFactory");
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
         this.invalidate("itemRendererFactory");
      }
      
      public function get itemRendererFactories() : Object
      {
         return this._itemRendererFactories;
      }
      
      public function set itemRendererFactories(param1:Object) : void
      {
         if(this._itemRendererFactories === param1)
         {
            return;
         }
         this._itemRendererFactories = param1;
         this.invalidate("itemRendererFactory");
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
         this.invalidate("itemRendererFactory");
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
         this.invalidate("itemRendererFactory");
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
      
      public function get itemRendererProperties() : PropertyProxy
      {
         return this._itemRendererProperties;
      }
      
      public function set itemRendererProperties(param1:PropertyProxy) : void
      {
         if(this._itemRendererProperties == param1)
         {
            return;
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
      
      public function get firstItemRendererType() : Class
      {
         return this._firstItemRendererType;
      }
      
      public function set firstItemRendererType(param1:Class) : void
      {
         if(this._firstItemRendererType == param1)
         {
            return;
         }
         this._firstItemRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get firstItemRendererFactory() : Function
      {
         return this._firstItemRendererFactory;
      }
      
      public function set firstItemRendererFactory(param1:Function) : void
      {
         if(this._firstItemRendererFactory === param1)
         {
            return;
         }
         this._firstItemRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get customFirstItemRendererStyleName() : String
      {
         return this._customFirstItemRendererStyleName;
      }
      
      public function set customFirstItemRendererStyleName(param1:String) : void
      {
         if(this._customFirstItemRendererStyleName == param1)
         {
            return;
         }
         this._customFirstItemRendererStyleName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get lastItemRendererType() : Class
      {
         return this._lastItemRendererType;
      }
      
      public function set lastItemRendererType(param1:Class) : void
      {
         if(this._lastItemRendererType == param1)
         {
            return;
         }
         this._lastItemRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get lastItemRendererFactory() : Function
      {
         return this._lastItemRendererFactory;
      }
      
      public function set lastItemRendererFactory(param1:Function) : void
      {
         if(this._lastItemRendererFactory === param1)
         {
            return;
         }
         this._lastItemRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get customLastItemRendererStyleName() : String
      {
         return this._customLastItemRendererStyleName;
      }
      
      public function set customLastItemRendererStyleName(param1:String) : void
      {
         if(this._customLastItemRendererStyleName == param1)
         {
            return;
         }
         this._customLastItemRendererStyleName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get singleItemRendererType() : Class
      {
         return this._singleItemRendererType;
      }
      
      public function set singleItemRendererType(param1:Class) : void
      {
         if(this._singleItemRendererType == param1)
         {
            return;
         }
         this._singleItemRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get singleItemRendererFactory() : Function
      {
         return this._singleItemRendererFactory;
      }
      
      public function set singleItemRendererFactory(param1:Function) : void
      {
         if(this._singleItemRendererFactory === param1)
         {
            return;
         }
         this._singleItemRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get customSingleItemRendererStyleName() : String
      {
         return this._customSingleItemRendererStyleName;
      }
      
      public function set customSingleItemRendererStyleName(param1:String) : void
      {
         if(this._customSingleItemRendererStyleName == param1)
         {
            return;
         }
         this._customSingleItemRendererStyleName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get headerRendererType() : Class
      {
         return this._headerRendererType;
      }
      
      public function set headerRendererType(param1:Class) : void
      {
         if(this._headerRendererType == param1)
         {
            return;
         }
         this._headerRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get headerRendererFactory() : Function
      {
         return this._headerRendererFactory;
      }
      
      public function set headerRendererFactory(param1:Function) : void
      {
         if(this._headerRendererFactory === param1)
         {
            return;
         }
         this._headerRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get headerRendererFactories() : Object
      {
         return this._headerRendererFactories;
      }
      
      public function set headerRendererFactories(param1:Object) : void
      {
         if(this._headerRendererFactories === param1)
         {
            return;
         }
         this._headerRendererFactories = param1;
         if(param1 !== null)
         {
            this._headerStorageMap = {};
         }
         this.invalidate("itemRendererFactory");
      }
      
      public function get headerFactoryIDFunction() : Function
      {
         return this._headerFactoryIDFunction;
      }
      
      public function set headerFactoryIDFunction(param1:Function) : void
      {
         if(this._headerFactoryIDFunction === param1)
         {
            return;
         }
         this._headerFactoryIDFunction = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get customHeaderRendererStyleName() : String
      {
         return this._customHeaderRendererStyleName;
      }
      
      public function set customHeaderRendererStyleName(param1:String) : void
      {
         if(this._customHeaderRendererStyleName == param1)
         {
            return;
         }
         this._customHeaderRendererStyleName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get headerRendererProperties() : PropertyProxy
      {
         return this._headerRendererProperties;
      }
      
      public function set headerRendererProperties(param1:PropertyProxy) : void
      {
         if(this._headerRendererProperties == param1)
         {
            return;
         }
         if(this._headerRendererProperties)
         {
            this._headerRendererProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._headerRendererProperties = PropertyProxy(param1);
         if(this._headerRendererProperties)
         {
            this._headerRendererProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get footerRendererType() : Class
      {
         return this._footerRendererType;
      }
      
      public function set footerRendererType(param1:Class) : void
      {
         if(this._footerRendererType == param1)
         {
            return;
         }
         this._footerRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get footerRendererFactory() : Function
      {
         return this._footerRendererFactory;
      }
      
      public function set footerRendererFactory(param1:Function) : void
      {
         if(this._footerRendererFactory === param1)
         {
            return;
         }
         this._footerRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get footerRendererFactories() : Object
      {
         return this._footerRendererFactories;
      }
      
      public function set footerRendererFactories(param1:Object) : void
      {
         if(this._footerRendererFactories === param1)
         {
            return;
         }
         this._footerRendererFactories = param1;
         if(param1 !== null)
         {
            this._footerStorageMap = {};
         }
         this.invalidate("itemRendererFactory");
      }
      
      public function get footerFactoryIDFunction() : Function
      {
         return this._footerFactoryIDFunction;
      }
      
      public function set footerFactoryIDFunction(param1:Function) : void
      {
         if(this._footerFactoryIDFunction === param1)
         {
            return;
         }
         this._footerFactoryIDFunction = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get customFooterRendererStyleName() : String
      {
         return this._customFooterRendererStyleName;
      }
      
      public function set customFooterRendererStyleName(param1:String) : void
      {
         if(this._customFooterRendererStyleName == param1)
         {
            return;
         }
         this._customFooterRendererStyleName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get footerRendererProperties() : PropertyProxy
      {
         return this._footerRendererProperties;
      }
      
      public function set footerRendererProperties(param1:PropertyProxy) : void
      {
         if(this._footerRendererProperties == param1)
         {
            return;
         }
         if(this._footerRendererProperties)
         {
            this._footerRendererProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._footerRendererProperties = PropertyProxy(param1);
         if(this._footerRendererProperties)
         {
            this._footerRendererProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         var _loc2_:IVariableVirtualLayout = null;
         if(this._layout == param1)
         {
            return;
         }
         if(this._layout)
         {
            this._layout.removeEventListener("change",layout_changeHandler);
         }
         this._layout = param1;
         if(this._layout)
         {
            if(this._layout is IVariableVirtualLayout)
            {
               _loc2_ = IVariableVirtualLayout(this._layout);
               _loc2_.hasVariableItemDimensions = true;
               _loc2_.resetVariableVirtualCache();
            }
            this._layout.addEventListener("change",layout_changeHandler);
         }
         this.invalidate("layout");
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         this._horizontalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         this._verticalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get requiresMeasurementOnScroll() : Boolean
      {
         return this._layout.requiresLayoutOnScroll && (this._explicitVisibleWidth !== this._explicitVisibleWidth || this._explicitVisibleHeight !== this._explicitVisibleHeight);
      }
      
      public function setSelectedLocation(param1:int, param2:int) : void
      {
         if(this._selectedGroupIndex == param1 && this._selectedItemIndex == param2)
         {
            return;
         }
         if(param1 < 0 && param2 >= 0 || param1 >= 0 && param2 < 0)
         {
            throw new ArgumentError("To deselect items, group index and item index must both be < 0.");
         }
         this._selectedGroupIndex = param1;
         this._selectedItemIndex = param2;
         this.invalidate("selected");
         this.dispatchEventWith("change");
      }
      
      public function getScrollPositionForIndex(param1:int, param2:int, param3:Point = null) : Point
      {
         if(!param3)
         {
            param3 = new Point();
         }
         var _loc4_:int = this.locationToDisplayIndex(param1,param2);
         return this._layout.getScrollPositionForIndex(_loc4_,this._layoutItems,0,0,this._actualVisibleWidth,this._actualVisibleHeight,param3);
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:int, param3:Point = null) : Point
      {
         if(!param3)
         {
            param3 = new Point();
         }
         var _loc4_:int = this.locationToDisplayIndex(param1,param2);
         return this._layout.getNearestScrollPositionForIndex(_loc4_,this._horizontalScrollPosition,this._verticalScrollPosition,this._layoutItems,0,0,this._actualVisibleWidth,this._actualVisibleHeight,param3);
      }
      
      public function itemToItemRenderer(param1:Object) : IGroupedListItemRenderer
      {
         return IGroupedListItemRenderer(this._itemRendererMap[param1]);
      }
      
      public function headerDataToHeaderRenderer(param1:Object) : IGroupedListHeaderRenderer
      {
         return IGroupedListHeaderRenderer(this._headerRendererMap[param1]);
      }
      
      public function footerDataToFooterRenderer(param1:Object) : IGroupedListFooterRenderer
      {
         return IGroupedListFooterRenderer(this._footerRendererMap[param1]);
      }
      
      override public function dispose() : void
      {
         this.refreshInactiveRenderers(true);
         this.owner = null;
         this.dataProvider = null;
         this.layout = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc12_:Boolean = false;
         var _loc7_:Boolean = this.isInvalid("data");
         var _loc10_:Boolean = this.isInvalid("scroll");
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc5_:Boolean = this.isInvalid("selected");
         var _loc2_:Boolean = this.isInvalid("itemRendererFactory");
         var _loc8_:Boolean = this.isInvalid("styles");
         var _loc4_:Boolean = this.isInvalid("state");
         var _loc3_:Boolean = this.isInvalid("layout");
         if(!_loc3_ && _loc10_ && this._layout && this._layout.requiresLayoutOnScroll)
         {
            _loc3_ = true;
         }
         var _loc6_:Boolean = _loc1_ || _loc7_ || _loc3_ || _loc2_;
         var _loc9_:Boolean = this._ignoreRendererResizing;
         this._ignoreRendererResizing = true;
         var _loc11_:Boolean = this._ignoreLayoutChanges;
         this._ignoreLayoutChanges = true;
         if(_loc10_ || _loc1_)
         {
            this.refreshViewPortBounds();
         }
         if(_loc6_)
         {
            this.refreshInactiveRenderers(_loc2_);
         }
         if(_loc7_ || _loc3_ || _loc2_)
         {
            this.refreshLayoutTypicalItem();
         }
         if(_loc6_)
         {
            this.refreshRenderers();
         }
         if(_loc8_ || _loc6_)
         {
            this.refreshHeaderRendererStyles();
            this.refreshFooterRendererStyles();
            this.refreshItemRendererStyles();
         }
         if(_loc5_ || _loc6_)
         {
            _loc12_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.refreshSelection();
            this._ignoreSelectionChanges = _loc12_;
         }
         if(_loc4_ || _loc6_)
         {
            this.refreshEnabled();
         }
         this._ignoreLayoutChanges = _loc11_;
         if(_loc4_ || _loc5_ || _loc8_ || _loc6_)
         {
            this._layout.layout(this._layoutItems,this._viewPortBounds,this._layoutResult);
         }
         this._ignoreRendererResizing = _loc9_;
         this._contentX = this._layoutResult.contentX;
         this._contentY = this._layoutResult.contentY;
         this.saveMeasurements(this._layoutResult.contentWidth,this._layoutResult.contentHeight,this._layoutResult.contentWidth,this._layoutResult.contentHeight);
         this._actualVisibleWidth = this._layoutResult.viewPortWidth;
         this._actualVisibleHeight = this._layoutResult.viewPortHeight;
         this._actualMinVisibleWidth = this._layoutResult.viewPortWidth;
         this._actualMinVisibleHeight = this._layoutResult.viewPortHeight;
         this.validateRenderers();
      }
      
      private function validateRenderers() : void
      {
         var _loc2_:int = 0;
         var _loc1_:IValidating = null;
         var _loc3_:int = int(this._layoutItems.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._layoutItems[_loc2_] as IValidating;
            if(_loc1_)
            {
               _loc1_.validate();
            }
            _loc2_++;
         }
      }
      
      private function refreshEnabled() : void
      {
         var _loc2_:IFeathersControl = null;
         for each(var _loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as IFeathersControl;
            if(_loc2_)
            {
               _loc2_.isEnabled = this._isEnabled;
            }
         }
      }
      
      private function invalidateParent(param1:String = "all") : void
      {
         Scroller(this.parent).invalidate(param1);
      }
      
      private function refreshLayoutTypicalItem() : void
      {
         var _loc8_:int = 0;
         var _loc11_:IGroupedListItemRenderer = null;
         var _loc9_:* = false;
         var _loc6_:String = null;
         var _loc10_:IVirtualLayout;
         if(!(_loc10_ = this._layout as IVirtualLayout) || !_loc10_.useVirtualLayout)
         {
            if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
            {
               this.destroyItemRenderer(this._typicalItemRenderer);
               this._typicalItemRenderer = null;
            }
            return;
         }
         var _loc7_:Boolean = false;
         var _loc3_:Object = this._typicalItem;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc5_:* = 0;
         var _loc2_:int = 0;
         if(this._dataProvider)
         {
            if(_loc3_ !== null)
            {
               this._dataProvider.getItemLocation(_loc3_,HELPER_VECTOR);
               if(HELPER_VECTOR.length > 1)
               {
                  _loc7_ = true;
                  _loc5_ = HELPER_VECTOR[0];
                  _loc2_ = HELPER_VECTOR[1];
               }
            }
            else if((_loc4_ = this._dataProvider.getLength()) > 0)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc4_)
               {
                  _loc1_ = this._dataProvider.getLength(_loc8_);
                  if(_loc1_ > 0)
                  {
                     _loc7_ = true;
                     _loc5_ = _loc8_;
                     _loc3_ = this._dataProvider.getItemAt(_loc8_,0);
                     break;
                  }
                  _loc8_++;
               }
            }
         }
         if(_loc3_ !== null)
         {
            if(_loc11_ = IGroupedListItemRenderer(this._itemRendererMap[_loc3_]))
            {
               _loc11_.groupIndex = _loc5_;
               _loc11_.itemIndex = _loc2_;
            }
            if(!_loc11_ && this._typicalItemRenderer)
            {
               if(_loc9_ = !this._typicalItemIsInDataProvider)
               {
                  _loc6_ = this.getFactoryID(_loc3_,_loc5_,_loc2_);
                  if(this._typicalItemRenderer.factoryID !== _loc6_)
                  {
                     _loc9_ = false;
                  }
               }
               if(_loc9_)
               {
                  (_loc11_ = this._typicalItemRenderer).data = _loc3_;
                  _loc11_.groupIndex = _loc5_;
                  _loc11_.itemIndex = _loc2_;
               }
            }
            if(!_loc11_)
            {
               _loc11_ = this.createItemRenderer(_loc3_,0,0,0,false,!_loc7_);
               if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
               {
                  this.destroyItemRenderer(this._typicalItemRenderer);
                  this._typicalItemRenderer = null;
               }
            }
         }
         _loc10_.typicalItem = DisplayObject(_loc11_);
         this._typicalItemRenderer = _loc11_;
         this._typicalItemIsInDataProvider = _loc7_;
         if(this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
         {
            this._typicalItemRenderer.addEventListener("resize",itemRenderer_resizeHandler);
         }
      }
      
      private function refreshItemRendererStyles() : void
      {
         var _loc1_:IGroupedListItemRenderer = null;
         for each(var _loc2_ in this._layoutItems)
         {
            _loc1_ = _loc2_ as IGroupedListItemRenderer;
            if(_loc1_)
            {
               this.refreshOneItemRendererStyles(_loc1_);
            }
         }
      }
      
      private function refreshHeaderRendererStyles() : void
      {
         var _loc2_:IGroupedListHeaderRenderer = null;
         for each(var _loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as IGroupedListHeaderRenderer;
            if(_loc2_)
            {
               this.refreshOneHeaderRendererStyles(_loc2_);
            }
         }
      }
      
      private function refreshFooterRendererStyles() : void
      {
         var _loc2_:IGroupedListFooterRenderer = null;
         for each(var _loc1_ in this._layoutItems)
         {
            _loc2_ = _loc1_ as IGroupedListFooterRenderer;
            if(_loc2_)
            {
               this.refreshOneFooterRendererStyles(_loc2_);
            }
         }
      }
      
      private function refreshOneItemRendererStyles(param1:IGroupedListItemRenderer) : void
      {
         var _loc4_:Object = null;
         var _loc2_:DisplayObject = DisplayObject(param1);
         for(var _loc3_ in this._itemRendererProperties)
         {
            _loc4_ = this._itemRendererProperties[_loc3_];
            _loc2_[_loc3_] = _loc4_;
         }
      }
      
      private function refreshOneHeaderRendererStyles(param1:IGroupedListHeaderRenderer) : void
      {
         var _loc4_:Object = null;
         var _loc2_:DisplayObject = DisplayObject(param1);
         for(var _loc3_ in this._headerRendererProperties)
         {
            _loc4_ = this._headerRendererProperties[_loc3_];
            _loc2_[_loc3_] = _loc4_;
         }
      }
      
      private function refreshOneFooterRendererStyles(param1:IGroupedListFooterRenderer) : void
      {
         var _loc4_:Object = null;
         var _loc2_:DisplayObject = DisplayObject(param1);
         for(var _loc3_ in this._footerRendererProperties)
         {
            _loc4_ = this._footerRendererProperties[_loc3_];
            _loc2_[_loc3_] = _loc4_;
         }
      }
      
      private function refreshSelection() : void
      {
         var _loc1_:IGroupedListItemRenderer = null;
         for each(var _loc2_ in this._layoutItems)
         {
            _loc1_ = _loc2_ as IGroupedListItemRenderer;
            if(_loc1_)
            {
               _loc1_.isSelected = _loc1_.groupIndex == this._selectedGroupIndex && _loc1_.itemIndex == this._selectedItemIndex;
            }
         }
      }
      
      private function refreshViewPortBounds() : void
      {
         var _loc1_:* = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth;
         var _loc2_:* = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight;
         this._viewPortBounds.x = 0;
         this._viewPortBounds.y = 0;
         this._viewPortBounds.scrollX = this._horizontalScrollPosition;
         this._viewPortBounds.scrollY = this._verticalScrollPosition;
         this._viewPortBounds.explicitWidth = this._explicitVisibleWidth;
         this._viewPortBounds.explicitHeight = this._explicitVisibleHeight;
         if(_loc1_)
         {
            this._viewPortBounds.minWidth = 0;
         }
         else
         {
            this._viewPortBounds.minWidth = this._explicitMinVisibleWidth;
         }
         if(_loc2_)
         {
            this._viewPortBounds.minHeight = 0;
         }
         else
         {
            this._viewPortBounds.minHeight = this._explicitMinVisibleHeight;
         }
         this._viewPortBounds.maxWidth = this._maxVisibleWidth;
         this._viewPortBounds.maxHeight = this._maxVisibleHeight;
      }
      
      private function refreshInactiveRenderers(param1:Boolean) : void
      {
         var _loc2_:ItemRendererFactoryStorage = null;
         var _loc4_:HeaderRendererFactoryStorage = null;
         var _loc5_:FooterRendererFactoryStorage = null;
         this.refreshInactiveItemRenderers(this._defaultItemRendererStorage,param1);
         for(var _loc3_ in this._itemStorageMap)
         {
            _loc2_ = ItemRendererFactoryStorage(this._itemStorageMap[_loc3_]);
            this.refreshInactiveItemRenderers(_loc2_,param1);
         }
         this.refreshInactiveHeaderRenderers(this._defaultHeaderRendererStorage,param1);
         for(_loc3_ in this._headerStorageMap)
         {
            _loc4_ = HeaderRendererFactoryStorage(this._headerStorageMap[_loc3_]);
            this.refreshInactiveHeaderRenderers(_loc4_,param1);
         }
         this.refreshInactiveFooterRenderers(this._defaultFooterRendererStorage,param1);
         for(_loc3_ in this._footerStorageMap)
         {
            _loc5_ = FooterRendererFactoryStorage(this._footerStorageMap[_loc3_]);
            this.refreshInactiveFooterRenderers(_loc5_,param1);
         }
         if(param1 && this._typicalItemRenderer)
         {
            if(this._typicalItemIsInDataProvider)
            {
               delete this._itemRendererMap[this._typicalItemRenderer.data];
            }
            this.destroyItemRenderer(this._typicalItemRenderer);
            this._typicalItemRenderer = null;
            this._typicalItemIsInDataProvider = false;
         }
         this._headerIndices.length = 0;
         this._footerIndices.length = 0;
      }
      
      private function refreshInactiveItemRenderers(param1:ItemRendererFactoryStorage, param2:Boolean) : void
      {
         var _loc3_:Vector.<IGroupedListItemRenderer> = param1.inactiveItemRenderers;
         param1.inactiveItemRenderers = param1.activeItemRenderers;
         param1.activeItemRenderers = _loc3_;
         if(param1.activeItemRenderers.length > 0)
         {
            throw new IllegalOperationError("GroupedListDataViewPort: active item renderers should be empty.");
         }
         if(param2)
         {
            this.recoverInactiveItemRenderers(param1);
            this.freeInactiveItemRenderers(param1,0);
         }
      }
      
      private function refreshInactiveHeaderRenderers(param1:HeaderRendererFactoryStorage, param2:Boolean) : void
      {
         var _loc3_:Vector.<IGroupedListHeaderRenderer> = param1.inactiveHeaderRenderers;
         param1.inactiveHeaderRenderers = param1.activeHeaderRenderers;
         param1.activeHeaderRenderers = _loc3_;
         if(param1.activeHeaderRenderers.length > 0)
         {
            throw new IllegalOperationError("GroupedListDataViewPort: active header renderers should be empty.");
         }
         if(param2)
         {
            this.recoverInactiveHeaderRenderers(param1);
            this.freeInactiveHeaderRenderers(param1,0);
         }
      }
      
      private function refreshInactiveFooterRenderers(param1:FooterRendererFactoryStorage, param2:Boolean) : void
      {
         var _loc3_:Vector.<IGroupedListFooterRenderer> = param1.inactiveFooterRenderers;
         param1.inactiveFooterRenderers = param1.activeFooterRenderers;
         param1.activeFooterRenderers = _loc3_;
         if(param1.activeFooterRenderers.length > 0)
         {
            throw new IllegalOperationError("GroupedListDataViewPort: active footer renderers should be empty.");
         }
         if(param2)
         {
            this.recoverInactiveFooterRenderers(param1);
            this.freeInactiveFooterRenderers(param1,0);
         }
      }
      
      private function refreshRenderers() : void
      {
         var _loc1_:ItemRendererFactoryStorage = null;
         var _loc2_:* = undefined;
         var _loc6_:* = undefined;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:HeaderRendererFactoryStorage = null;
         var _loc8_:FooterRendererFactoryStorage = null;
         if(this._typicalItemRenderer)
         {
            if(this._typicalItemIsInDataProvider)
            {
               _loc1_ = this.factoryIDToStorage(this._typicalItemRenderer.factoryID,this._typicalItemRenderer.groupIndex,this._typicalItemRenderer.itemIndex);
               _loc2_ = _loc1_.inactiveItemRenderers;
               _loc6_ = _loc1_.activeItemRenderers;
               if((_loc5_ = _loc2_.indexOf(this._typicalItemRenderer)) >= 0)
               {
                  _loc2_.removeAt(_loc5_);
               }
               if((_loc4_ = int(_loc6_.length)) == 0)
               {
                  _loc6_[_loc4_] = this._typicalItemRenderer;
               }
            }
            this.refreshOneItemRendererStyles(this._typicalItemRenderer);
         }
         this.findUnrenderedData();
         this.recoverInactiveItemRenderers(this._defaultItemRendererStorage);
         if(this._itemStorageMap)
         {
            for(var _loc3_ in this._itemStorageMap)
            {
               _loc1_ = ItemRendererFactoryStorage(this._itemStorageMap[_loc3_]);
               this.recoverInactiveItemRenderers(_loc1_);
            }
         }
         this.recoverInactiveHeaderRenderers(this._defaultHeaderRendererStorage);
         if(this._headerStorageMap)
         {
            for(_loc3_ in this._headerStorageMap)
            {
               _loc7_ = HeaderRendererFactoryStorage(this._headerStorageMap[_loc3_]);
               this.recoverInactiveHeaderRenderers(_loc7_);
            }
         }
         this.recoverInactiveFooterRenderers(this._defaultFooterRendererStorage);
         if(this._footerStorageMap)
         {
            for(_loc3_ in this._footerStorageMap)
            {
               _loc8_ = FooterRendererFactoryStorage(this._footerStorageMap[_loc3_]);
               this.recoverInactiveFooterRenderers(_loc8_);
            }
         }
         this.renderUnrenderedData();
         this.freeInactiveItemRenderers(this._defaultItemRendererStorage,this._minimumItemCount);
         if(this._itemStorageMap)
         {
            for(_loc3_ in this._itemStorageMap)
            {
               _loc1_ = ItemRendererFactoryStorage(this._itemStorageMap[_loc3_]);
               this.freeInactiveItemRenderers(_loc1_,1);
            }
         }
         this.freeInactiveHeaderRenderers(this._defaultHeaderRendererStorage,this._minimumHeaderCount);
         if(this._headerStorageMap)
         {
            for(_loc3_ in this._headerStorageMap)
            {
               _loc7_ = HeaderRendererFactoryStorage(this._headerStorageMap[_loc3_]);
               this.freeInactiveHeaderRenderers(_loc7_,1);
            }
         }
         this.freeInactiveFooterRenderers(this._defaultFooterRendererStorage,this._minimumFooterCount);
         if(this._footerStorageMap)
         {
            for(_loc3_ in this._footerStorageMap)
            {
               _loc8_ = FooterRendererFactoryStorage(this._footerStorageMap[_loc3_]);
               this.freeInactiveFooterRenderers(_loc8_,1);
            }
         }
         this._updateForDataReset = false;
      }
      
      private function findUnrenderedData() : void
      {
         var _loc4_:int = 0;
         var _loc21_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc15_:* = NaN;
         var _loc17_:Object = null;
         var _loc6_:int = 0;
         var _loc1_:Object = null;
         var _loc3_:Object = null;
         var _loc5_:int = 0;
         var _loc11_:int = int(!!this._dataProvider ? this._dataProvider.getLength() : 0);
         var _loc12_:int = 0;
         var _loc19_:int = 0;
         var _loc16_:int = 0;
         var _loc2_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc11_)
         {
            _loc21_ = this._dataProvider.getItemAt(_loc4_);
            if(this._owner.groupToHeaderData(_loc21_) !== null)
            {
               this._headerIndices[_loc19_] = _loc12_;
               _loc12_++;
               _loc19_++;
            }
            _loc13_ = this._dataProvider.getLength(_loc4_);
            _loc12_ += _loc13_;
            _loc7_ += _loc13_;
            if(_loc13_ == 0)
            {
               _loc2_++;
            }
            if(this._owner.groupToFooterData(_loc21_) !== null)
            {
               this._footerIndices[_loc16_] = _loc12_;
               _loc12_++;
               _loc16_++;
            }
            _loc4_++;
         }
         this._layoutItems.length = _loc12_;
         if(this._layout is IGroupedLayout)
         {
            IGroupedLayout(this._layout).headerIndices = this._headerIndices;
         }
         var _loc18_:Boolean;
         var _loc10_:IVirtualLayout;
         if(_loc18_ = (_loc10_ = this._layout as IVirtualLayout) && _loc10_.useVirtualLayout)
         {
            _loc10_.measureViewPort(_loc12_,this._viewPortBounds,HELPER_POINT);
            _loc14_ = HELPER_POINT.x;
            _loc20_ = HELPER_POINT.y;
            _loc10_.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition,this._verticalScrollPosition,_loc14_,_loc20_,_loc12_,HELPER_VECTOR);
            _loc7_ /= _loc11_;
            if(this._typicalItemRenderer)
            {
               _loc8_ = Number(this._typicalItemRenderer.height);
               if(this._typicalItemRenderer.width < _loc8_)
               {
                  _loc8_ = Number(this._typicalItemRenderer.width);
               }
               _loc15_ = _loc14_;
               if(_loc20_ > _loc14_)
               {
                  _loc15_ = _loc20_;
               }
               this._minimumFirstAndLastItemCount = this._minimumSingleItemCount = this._minimumHeaderCount = this._minimumFooterCount = Math.ceil(_loc15_ / (_loc8_ * _loc7_));
               this._minimumHeaderCount = Math.min(this._minimumHeaderCount,_loc19_);
               this._minimumFooterCount = Math.min(this._minimumFooterCount,_loc16_);
               this._minimumSingleItemCount = Math.min(this._minimumSingleItemCount,_loc2_);
               this._minimumItemCount = Math.ceil(_loc15_ / _loc8_) + 1;
            }
            else
            {
               this._minimumFirstAndLastItemCount = 1;
               this._minimumHeaderCount = 1;
               this._minimumFooterCount = 1;
               this._minimumSingleItemCount = 1;
               this._minimumItemCount = 1;
            }
         }
         var _loc9_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc11_)
         {
            _loc21_ = this._dataProvider.getItemAt(_loc4_);
            if((_loc17_ = this._owner.groupToHeaderData(_loc21_)) !== null)
            {
               if(_loc18_ && HELPER_VECTOR.indexOf(_loc9_) < 0)
               {
                  this._layoutItems[_loc9_] = null;
               }
               else
               {
                  this.findRendererForHeader(_loc17_,_loc4_,_loc9_);
               }
               _loc9_++;
            }
            _loc13_ = this._dataProvider.getLength(_loc4_);
            _loc6_ = 0;
            while(_loc6_ < _loc13_)
            {
               if(_loc18_ && HELPER_VECTOR.indexOf(_loc9_) < 0)
               {
                  if(this._typicalItemRenderer && this._typicalItemIsInDataProvider && this._typicalItemRenderer.groupIndex === _loc4_ && this._typicalItemRenderer.itemIndex === _loc6_)
                  {
                     this._typicalItemRenderer.layoutIndex = _loc9_;
                  }
                  this._layoutItems[_loc9_] = null;
               }
               else
               {
                  _loc1_ = this._dataProvider.getItemAt(_loc4_,_loc6_);
                  this.findRendererForItem(_loc1_,_loc4_,_loc6_,_loc9_);
               }
               _loc9_++;
               _loc6_++;
            }
            _loc3_ = this._owner.groupToFooterData(_loc21_);
            if(_loc3_ !== null)
            {
               if(_loc18_ && HELPER_VECTOR.indexOf(_loc9_) < 0)
               {
                  this._layoutItems[_loc9_] = null;
               }
               else
               {
                  this.findRendererForFooter(_loc3_,_loc4_,_loc9_);
               }
               _loc9_++;
            }
            _loc4_++;
         }
         if(this._typicalItemRenderer)
         {
            if(_loc18_ && this._typicalItemIsInDataProvider)
            {
               if((_loc5_ = HELPER_VECTOR.indexOf(this._typicalItemRenderer.layoutIndex)) >= 0)
               {
                  this._typicalItemRenderer.visible = true;
               }
               else
               {
                  this._typicalItemRenderer.visible = false;
               }
            }
            else
            {
               this._typicalItemRenderer.visible = this._typicalItemIsInDataProvider;
            }
         }
         HELPER_VECTOR.length = 0;
      }
      
      private function findRendererForItem(param1:Object, param2:int, param3:int, param4:int) : void
      {
         var _loc9_:ItemRendererFactoryStorage = null;
         var _loc8_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc10_:int = 0;
         var _loc5_:IGroupedListItemRenderer;
         if(_loc5_ = IGroupedListItemRenderer(this._itemRendererMap[param1]))
         {
            _loc5_.groupIndex = param2;
            _loc5_.itemIndex = param3;
            _loc5_.layoutIndex = param4;
            if(this._updateForDataReset)
            {
               _loc5_.data = null;
               _loc5_.data = param1;
            }
            if(this._typicalItemRenderer != _loc5_)
            {
               _loc8_ = (_loc9_ = this.factoryIDToStorage(_loc5_.factoryID,_loc5_.groupIndex,_loc5_.itemIndex)).activeItemRenderers;
               _loc6_ = _loc9_.inactiveItemRenderers;
               _loc8_[_loc8_.length] = _loc5_;
               if((_loc7_ = _loc6_.indexOf(_loc5_)) < 0)
               {
                  throw new IllegalOperationError("GroupedListDataViewPort: renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
               }
               _loc6_.removeAt(_loc7_);
            }
            _loc5_.visible = true;
            this._layoutItems[param4] = DisplayObject(_loc5_);
         }
         else
         {
            _loc10_ = int(this._unrenderedItems.length);
            this._unrenderedItems[_loc10_] = param2;
            _loc10_++;
            this._unrenderedItems[_loc10_] = param3;
            _loc10_++;
            this._unrenderedItems[_loc10_] = param4;
         }
      }
      
      private function findRendererForHeader(param1:Object, param2:int, param3:int) : void
      {
         var _loc4_:HeaderRendererFactoryStorage = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:IGroupedListHeaderRenderer;
         if(_loc8_ = IGroupedListHeaderRenderer(this._headerRendererMap[param1]))
         {
            _loc8_.groupIndex = param2;
            _loc8_.layoutIndex = param3;
            if(this._updateForDataReset)
            {
               _loc8_.data = null;
               _loc8_.data = param1;
            }
            _loc5_ = (_loc4_ = this.headerFactoryIDToStorage(_loc8_.factoryID)).activeHeaderRenderers;
            _loc6_ = _loc4_.inactiveHeaderRenderers;
            _loc5_[_loc5_.length] = _loc8_;
            _loc6_.removeAt(_loc6_.indexOf(_loc8_));
            _loc8_.visible = true;
            this._layoutItems[param3] = DisplayObject(_loc8_);
         }
         else
         {
            _loc7_ = int(this._unrenderedHeaders.length);
            this._unrenderedHeaders[_loc7_] = param2;
            _loc7_++;
            this._unrenderedHeaders[_loc7_] = param3;
         }
      }
      
      private function findRendererForFooter(param1:Object, param2:int, param3:int) : void
      {
         var _loc7_:FooterRendererFactoryStorage = null;
         var _loc5_:* = undefined;
         var _loc4_:* = undefined;
         var _loc8_:int = 0;
         var _loc6_:IGroupedListFooterRenderer;
         if(_loc6_ = IGroupedListFooterRenderer(this._footerRendererMap[param1]))
         {
            _loc6_.groupIndex = param2;
            _loc6_.layoutIndex = param3;
            if(this._updateForDataReset)
            {
               _loc6_.data = null;
               _loc6_.data = param1;
            }
            _loc5_ = (_loc7_ = this.footerFactoryIDToStorage(_loc6_.factoryID)).activeFooterRenderers;
            _loc4_ = _loc7_.inactiveFooterRenderers;
            _loc5_[_loc5_.length] = _loc6_;
            _loc4_.removeAt(_loc4_.indexOf(_loc6_));
            _loc6_.visible = true;
            this._layoutItems[param3] = DisplayObject(_loc6_);
         }
         else
         {
            _loc8_ = int(this._unrenderedFooters.length);
            this._unrenderedFooters[_loc8_] = param2;
            _loc8_++;
            this._unrenderedFooters[_loc8_] = param3;
         }
      }
      
      private function renderUnrenderedData() : void
      {
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:Object = null;
         var _loc2_:IGroupedListItemRenderer = null;
         var _loc9_:IGroupedListHeaderRenderer = null;
         var _loc7_:IGroupedListFooterRenderer = null;
         var _loc1_:int = int(this._unrenderedItems.length);
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc8_ = this._unrenderedItems.shift();
            _loc5_ = this._unrenderedItems.shift();
            _loc4_ = this._unrenderedItems.shift();
            _loc3_ = this._dataProvider.getItemAt(_loc8_,_loc5_);
            _loc2_ = this.createItemRenderer(_loc3_,_loc8_,_loc5_,_loc4_,true,false);
            this._layoutItems[_loc4_] = DisplayObject(_loc2_);
            _loc6_ += 3;
         }
         _loc1_ = int(this._unrenderedHeaders.length);
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc8_ = this._unrenderedHeaders.shift();
            _loc4_ = this._unrenderedHeaders.shift();
            _loc3_ = this._dataProvider.getItemAt(_loc8_);
            _loc3_ = this._owner.groupToHeaderData(_loc3_);
            _loc9_ = this.createHeaderRenderer(_loc3_,_loc8_,_loc4_,false);
            this._layoutItems[_loc4_] = DisplayObject(_loc9_);
            _loc6_ += 2;
         }
         _loc1_ = int(this._unrenderedFooters.length);
         _loc6_ = 0;
         while(_loc6_ < _loc1_)
         {
            _loc8_ = this._unrenderedFooters.shift();
            _loc4_ = this._unrenderedFooters.shift();
            _loc3_ = this._dataProvider.getItemAt(_loc8_);
            _loc3_ = this._owner.groupToFooterData(_loc3_);
            _loc7_ = this.createFooterRenderer(_loc3_,_loc8_,_loc4_,false);
            this._layoutItems[_loc4_] = DisplayObject(_loc7_);
            _loc6_ += 2;
         }
      }
      
      private function recoverInactiveItemRenderers(param1:ItemRendererFactoryStorage) : void
      {
         var _loc5_:int = 0;
         var _loc3_:IGroupedListItemRenderer = null;
         var _loc4_:Vector.<IGroupedListItemRenderer>;
         var _loc2_:int = int((_loc4_ = param1.inactiveItemRenderers).length);
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = _loc4_[_loc5_];
            if(!(!_loc3_ || _loc3_.groupIndex < 0))
            {
               this._owner.dispatchEventWith("rendererRemove",false,_loc3_);
               delete this._itemRendererMap[_loc3_.data];
            }
            _loc5_++;
         }
      }
      
      private function recoverInactiveHeaderRenderers(param1:HeaderRendererFactoryStorage) : void
      {
         var _loc3_:int = 0;
         var _loc5_:IGroupedListHeaderRenderer = null;
         var _loc4_:Vector.<IGroupedListHeaderRenderer>;
         var _loc2_:int = int((_loc4_ = param1.inactiveHeaderRenderers).length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc5_ = _loc4_[_loc3_])
            {
               this._owner.dispatchEventWith("rendererRemove",false,_loc5_);
               delete this._headerRendererMap[_loc5_.data];
            }
            _loc3_++;
         }
      }
      
      private function recoverInactiveFooterRenderers(param1:FooterRendererFactoryStorage) : void
      {
         var _loc4_:int = 0;
         var _loc5_:IGroupedListFooterRenderer = null;
         var _loc2_:Vector.<IGroupedListFooterRenderer> = param1.inactiveFooterRenderers;
         var _loc3_:int = int(_loc2_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc5_ = _loc2_[_loc4_])
            {
               this._owner.dispatchEventWith("rendererRemove",false,_loc5_);
               delete this._footerRendererMap[_loc5_.data];
            }
            _loc4_++;
         }
      }
      
      private function freeInactiveItemRenderers(param1:ItemRendererFactoryStorage, param2:int) : void
      {
         var _loc9_:int = 0;
         var _loc3_:IGroupedListItemRenderer = null;
         var _loc6_:Vector.<IGroupedListItemRenderer> = param1.inactiveItemRenderers;
         var _loc8_:Vector.<IGroupedListItemRenderer>;
         var _loc7_:int = int((_loc8_ = param1.activeItemRenderers).length);
         var _loc5_:int;
         if((_loc5_ = param2 - _loc7_) > _loc6_.length)
         {
            _loc5_ = int(_loc6_.length);
         }
         _loc9_ = 0;
         while(_loc9_ < _loc5_)
         {
            _loc3_ = _loc6_.shift();
            _loc3_.data = null;
            _loc3_.groupIndex = -1;
            _loc3_.itemIndex = -1;
            _loc3_.layoutIndex = -1;
            _loc3_.visible = false;
            _loc8_[_loc7_] = _loc3_;
            _loc7_++;
            _loc9_++;
         }
         var _loc4_:int = int(_loc6_.length);
         _loc9_ = 0;
         while(_loc9_ < _loc4_)
         {
            _loc3_ = _loc6_.shift();
            if(_loc3_)
            {
               this.destroyItemRenderer(_loc3_);
            }
            _loc9_++;
         }
      }
      
      private function freeInactiveHeaderRenderers(param1:HeaderRendererFactoryStorage, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc9_:IGroupedListHeaderRenderer = null;
         var _loc7_:Vector.<IGroupedListHeaderRenderer> = param1.inactiveHeaderRenderers;
         var _loc6_:Vector.<IGroupedListHeaderRenderer>;
         var _loc5_:int = int((_loc6_ = param1.activeHeaderRenderers).length);
         var _loc3_:int = param2 - _loc5_;
         if(_loc3_ > _loc7_.length)
         {
            _loc3_ = int(_loc7_.length);
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            (_loc9_ = _loc7_.shift()).visible = false;
            _loc9_.data = null;
            _loc9_.groupIndex = -1;
            _loc9_.layoutIndex = -1;
            _loc6_[_loc5_] = _loc9_;
            _loc5_++;
            _loc4_++;
         }
         var _loc8_:int = int(_loc7_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            if(_loc9_ = _loc7_.shift())
            {
               this.destroyHeaderRenderer(_loc9_);
            }
            _loc4_++;
         }
      }
      
      private function freeInactiveFooterRenderers(param1:FooterRendererFactoryStorage, param2:int) : void
      {
         var _loc8_:int = 0;
         var _loc9_:IGroupedListFooterRenderer = null;
         var _loc3_:Vector.<IGroupedListFooterRenderer> = param1.inactiveFooterRenderers;
         var _loc4_:Vector.<IGroupedListFooterRenderer>;
         var _loc6_:int = int((_loc4_ = param1.activeFooterRenderers).length);
         var _loc5_:int;
         if((_loc5_ = param2 - _loc6_) > _loc3_.length)
         {
            _loc5_ = int(_loc3_.length);
         }
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            (_loc9_ = _loc3_.shift()).visible = false;
            _loc9_.data = null;
            _loc9_.groupIndex = -1;
            _loc9_.layoutIndex = -1;
            _loc4_[_loc6_] = _loc9_;
            _loc6_++;
            _loc8_++;
         }
         var _loc7_:int = int(_loc3_.length);
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            if(_loc9_ = _loc3_.shift())
            {
               this.destroyFooterRenderer(_loc9_);
            }
            _loc8_++;
         }
      }
      
      private function createItemRenderer(param1:Object, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean) : IGroupedListItemRenderer
      {
         var _loc7_:IGroupedListItemRenderer = null;
         var _loc13_:Class = null;
         var _loc11_:IFeathersControl = null;
         var _loc9_:String = this.getFactoryID(param1,param2,param3);
         var _loc15_:Function = this.factoryIDToFactory(_loc9_,param2,param3);
         var _loc12_:ItemRendererFactoryStorage = this.factoryIDToStorage(_loc9_,param2,param3);
         var _loc8_:String = this.indexToCustomStyleName(param2,param3);
         var _loc14_:Vector.<IGroupedListItemRenderer> = _loc12_.inactiveItemRenderers;
         var _loc10_:Vector.<IGroupedListItemRenderer> = _loc12_.activeItemRenderers;
         if(!param5 || param6 || _loc14_.length === 0)
         {
            if(_loc15_ !== null)
            {
               _loc7_ = IGroupedListItemRenderer(_loc15_());
            }
            else
            {
               _loc13_ = this.indexToItemRendererType(param2,param3);
               _loc7_ = IGroupedListItemRenderer(new _loc13_());
            }
            _loc11_ = IFeathersControl(_loc7_);
            if(_loc8_ && _loc8_.length > 0)
            {
               _loc11_.styleNameList.add(_loc8_);
            }
            this.addChild(DisplayObject(_loc7_));
         }
         else
         {
            _loc7_ = _loc14_.shift();
         }
         _loc7_.data = param1;
         _loc7_.groupIndex = param2;
         _loc7_.itemIndex = param3;
         _loc7_.layoutIndex = param4;
         _loc7_.owner = this._owner;
         _loc7_.factoryID = _loc9_;
         _loc7_.visible = true;
         if(!param6)
         {
            this._itemRendererMap[param1] = _loc7_;
            _loc10_.push(_loc7_);
            _loc7_.addEventListener("triggered",renderer_triggeredHandler);
            _loc7_.addEventListener("change",renderer_changeHandler);
            _loc7_.addEventListener("resize",itemRenderer_resizeHandler);
            this._owner.dispatchEventWith("rendererAdd",false,_loc7_);
         }
         return _loc7_;
      }
      
      private function createHeaderRenderer(param1:Object, param2:int, param3:int, param4:Boolean = false) : IGroupedListHeaderRenderer
      {
         var _loc11_:IGroupedListHeaderRenderer = null;
         var _loc6_:IFeathersControl = null;
         var _loc5_:String = null;
         if(this._headerFactoryIDFunction !== null)
         {
            if(this._headerFactoryIDFunction.length === 1)
            {
               _loc5_ = this._headerFactoryIDFunction(param1);
            }
            else
            {
               _loc5_ = this._headerFactoryIDFunction(param1,param2);
            }
         }
         var _loc10_:Function = this.headerFactoryIDToFactory(_loc5_);
         var _loc7_:HeaderRendererFactoryStorage;
         var _loc9_:Vector.<IGroupedListHeaderRenderer> = (_loc7_ = this.headerFactoryIDToStorage(_loc5_)).inactiveHeaderRenderers;
         var _loc8_:Vector.<IGroupedListHeaderRenderer> = _loc7_.activeHeaderRenderers;
         if(param4 || _loc9_.length === 0)
         {
            if(_loc10_ !== null)
            {
               _loc11_ = IGroupedListHeaderRenderer(_loc10_());
            }
            else
            {
               _loc11_ = IGroupedListHeaderRenderer(new this._headerRendererType());
            }
            _loc6_ = IFeathersControl(_loc11_);
            if(this._customHeaderRendererStyleName && this._customHeaderRendererStyleName.length > 0)
            {
               _loc6_.styleNameList.add(this._customHeaderRendererStyleName);
            }
            this.addChild(DisplayObject(_loc11_));
         }
         else
         {
            _loc11_ = _loc9_.shift();
         }
         _loc11_.data = param1;
         _loc11_.groupIndex = param2;
         _loc11_.layoutIndex = param3;
         _loc11_.owner = this._owner;
         _loc11_.factoryID = _loc5_;
         _loc11_.visible = true;
         if(!param4)
         {
            this._headerRendererMap[param1] = _loc11_;
            _loc8_.push(_loc11_);
            _loc11_.addEventListener("resize",headerRenderer_resizeHandler);
            this._owner.dispatchEventWith("rendererAdd",false,_loc11_);
         }
         return _loc11_;
      }
      
      private function createFooterRenderer(param1:Object, param2:int, param3:int, param4:Boolean = false) : IGroupedListFooterRenderer
      {
         var _loc9_:IGroupedListFooterRenderer = null;
         var _loc10_:IFeathersControl = null;
         var _loc7_:String = null;
         if(this._footerFactoryIDFunction !== null)
         {
            if(this._footerFactoryIDFunction.length === 1)
            {
               _loc7_ = this._footerFactoryIDFunction(param1);
            }
            else
            {
               _loc7_ = this._footerFactoryIDFunction(param1,param2);
            }
         }
         var _loc8_:Function = this.footerFactoryIDToFactory(_loc7_);
         var _loc11_:FooterRendererFactoryStorage;
         var _loc5_:Vector.<IGroupedListFooterRenderer> = (_loc11_ = this.footerFactoryIDToStorage(_loc7_)).inactiveFooterRenderers;
         var _loc6_:Vector.<IGroupedListFooterRenderer> = _loc11_.activeFooterRenderers;
         if(param4 || _loc5_.length === 0)
         {
            if(_loc8_ !== null)
            {
               _loc9_ = IGroupedListFooterRenderer(_loc8_());
            }
            else
            {
               _loc9_ = IGroupedListFooterRenderer(new this._footerRendererType());
            }
            _loc10_ = IFeathersControl(_loc9_);
            if(this._customFooterRendererStyleName && this._customFooterRendererStyleName.length > 0)
            {
               _loc10_.styleNameList.add(this._customFooterRendererStyleName);
            }
            this.addChild(DisplayObject(_loc9_));
         }
         else
         {
            _loc9_ = _loc5_.shift();
         }
         _loc9_.data = param1;
         _loc9_.groupIndex = param2;
         _loc9_.layoutIndex = param3;
         _loc9_.owner = this._owner;
         _loc9_.factoryID = _loc7_;
         _loc9_.visible = true;
         if(!param4)
         {
            this._footerRendererMap[param1] = _loc9_;
            _loc6_[_loc6_.length] = _loc9_;
            _loc9_.addEventListener("resize",footerRenderer_resizeHandler);
            this._owner.dispatchEventWith("rendererAdd",false,_loc9_);
         }
         return _loc9_;
      }
      
      private function destroyItemRenderer(param1:IGroupedListItemRenderer) : void
      {
         param1.removeEventListener("triggered",renderer_triggeredHandler);
         param1.removeEventListener("change",renderer_changeHandler);
         param1.removeEventListener("resize",itemRenderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function destroyHeaderRenderer(param1:IGroupedListHeaderRenderer) : void
      {
         param1.removeEventListener("resize",headerRenderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function destroyFooterRenderer(param1:IGroupedListFooterRenderer) : void
      {
         param1.removeEventListener("resize",footerRenderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function groupToHeaderDisplayIndex(param1:int) : int
      {
         var _loc5_:int = 0;
         var _loc8_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         var _loc9_:Object = this._dataProvider.getItemAt(param1);
         var _loc4_:Object;
         if(!(_loc4_ = this._owner.groupToHeaderData(_loc9_)))
         {
            return -1;
         }
         var _loc7_:int = 0;
         var _loc2_:int = this._dataProvider.getLength();
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc9_ = this._dataProvider.getItemAt(_loc5_);
            if(_loc4_ = this._owner.groupToHeaderData(_loc9_))
            {
               if(param1 == _loc5_)
               {
                  return _loc7_;
               }
               _loc7_++;
            }
            _loc8_ = this._dataProvider.getLength(_loc5_);
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               _loc7_++;
               _loc6_++;
            }
            _loc3_ = this._owner.groupToFooterData(_loc9_);
            if(_loc3_)
            {
               _loc7_++;
            }
            _loc5_++;
         }
         return -1;
      }
      
      private function groupToFooterDisplayIndex(param1:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc8_:int = 0;
         var _loc6_:int = 0;
         var _loc9_:Object = this._dataProvider.getItemAt(param1);
         var _loc3_:Object = this._owner.groupToFooterData(_loc9_);
         if(!_loc3_)
         {
            return -1;
         }
         var _loc7_:int = 0;
         var _loc2_:int = this._dataProvider.getLength();
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc9_ = this._dataProvider.getItemAt(_loc4_);
            if(_loc5_ = this._owner.groupToHeaderData(_loc9_))
            {
               _loc7_++;
            }
            _loc8_ = this._dataProvider.getLength(_loc4_);
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               _loc7_++;
               _loc6_++;
            }
            _loc3_ = this._owner.groupToFooterData(_loc9_);
            if(_loc3_)
            {
               if(param1 == _loc4_)
               {
                  return _loc7_;
               }
               _loc7_++;
            }
            _loc4_++;
         }
         return -1;
      }
      
      private function locationToDisplayIndex(param1:int, param2:int) : int
      {
         var _loc5_:int = 0;
         var _loc10_:Object = null;
         var _loc6_:Object = null;
         var _loc9_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:Object = null;
         var _loc8_:int = 0;
         var _loc3_:int = this._dataProvider.getLength();
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            if(param2 < 0 && param1 == _loc5_)
            {
               return _loc8_;
            }
            _loc10_ = this._dataProvider.getItemAt(_loc5_);
            if(_loc6_ = this._owner.groupToHeaderData(_loc10_))
            {
               _loc8_++;
            }
            _loc9_ = this._dataProvider.getLength(_loc5_);
            _loc7_ = 0;
            while(_loc7_ < _loc9_)
            {
               if(param1 == _loc5_ && param2 == _loc7_)
               {
                  return _loc8_;
               }
               _loc8_++;
               _loc7_++;
            }
            if(_loc4_ = this._owner.groupToFooterData(_loc10_))
            {
               _loc8_++;
            }
            _loc5_++;
         }
         return -1;
      }
      
      private function indexToItemRendererType(param1:int, param2:int) : Class
      {
         var _loc3_:int = 0;
         if(this._dataProvider !== null && this._dataProvider.getLength() > 0)
         {
            _loc3_ = this._dataProvider.getLength(param1);
         }
         if(param2 === 0)
         {
            if(this._singleItemRendererType !== null && _loc3_ === 1)
            {
               return this._singleItemRendererType;
            }
            if(this._firstItemRendererType !== null)
            {
               return this._firstItemRendererType;
            }
         }
         if(this._lastItemRendererType !== null && param2 === _loc3_ - 1)
         {
            return this._lastItemRendererType;
         }
         return this._itemRendererType;
      }
      
      private function indexToCustomStyleName(param1:int, param2:int) : String
      {
         var _loc3_:int = 0;
         if(this._dataProvider !== null && this._dataProvider.getLength() > 0)
         {
            _loc3_ = this._dataProvider.getLength(param1);
         }
         if(param2 === 0)
         {
            if(this._customSingleItemRendererStyleName !== null && _loc3_ === 1)
            {
               return this._customSingleItemRendererStyleName;
            }
            if(this._customFirstItemRendererStyleName !== null)
            {
               return this._customFirstItemRendererStyleName;
            }
         }
         if(this._customLastItemRendererStyleName !== null && param2 === _loc3_ - 1)
         {
            return this._customLastItemRendererStyleName;
         }
         return this._customItemRendererStyleName;
      }
      
      private function getFactoryID(param1:Object, param2:int, param3:int) : String
      {
         var _loc4_:int = 0;
         if(this._factoryIDFunction === null)
         {
            _loc4_ = 0;
            if(this._dataProvider !== null && this._dataProvider.getLength() > 0)
            {
               _loc4_ = this._dataProvider.getLength(param2);
            }
            if(param3 === 0)
            {
               if((this._singleItemRendererType !== null || this._singleItemRendererFactory !== null || this._customSingleItemRendererStyleName !== null) && _loc4_ === 1)
               {
                  return "GroupedListDataViewPort-single";
               }
               if(this._firstItemRendererType !== null || this._firstItemRendererFactory !== null || this._customFirstItemRendererStyleName !== null)
               {
                  return "GroupedListDataViewPort-first";
               }
            }
            if((this._lastItemRendererType !== null || this._lastItemRendererFactory !== null || this._customLastItemRendererStyleName !== null) && param3 === _loc4_ - 1)
            {
               return "GroupedListDataViewPort-last";
            }
            return null;
         }
         if(this._factoryIDFunction.length === 1)
         {
            return this._factoryIDFunction(param1);
         }
         return this._factoryIDFunction(param1,param2,param3);
      }
      
      private function factoryIDToFactory(param1:String, param2:int, param3:int) : Function
      {
         if(param1 !== null)
         {
            if(param1 === "GroupedListDataViewPort-first")
            {
               if(this._firstItemRendererFactory !== null)
               {
                  return this._firstItemRendererFactory;
               }
               return this._itemRendererFactory;
            }
            if(param1 === "GroupedListDataViewPort-last")
            {
               if(this._lastItemRendererFactory !== null)
               {
                  return this._lastItemRendererFactory;
               }
               return this._itemRendererFactory;
            }
            if(param1 === "GroupedListDataViewPort-single")
            {
               if(this._singleItemRendererFactory !== null)
               {
                  return this._singleItemRendererFactory;
               }
               return this._itemRendererFactory;
            }
            if(param1 in this._itemRendererFactories)
            {
               return this._itemRendererFactories[param1] as Function;
            }
            throw new ReferenceError("Cannot find item renderer factory for ID \"" + param1 + "\".");
         }
         return this._itemRendererFactory;
      }
      
      private function factoryIDToStorage(param1:String, param2:int, param3:int) : ItemRendererFactoryStorage
      {
         var _loc4_:ItemRendererFactoryStorage = null;
         if(param1 !== null)
         {
            if(param1 in this._itemStorageMap)
            {
               return ItemRendererFactoryStorage(this._itemStorageMap[param1]);
            }
            _loc4_ = new ItemRendererFactoryStorage();
            this._itemStorageMap[param1] = _loc4_;
            return _loc4_;
         }
         return this._defaultItemRendererStorage;
      }
      
      private function headerFactoryIDToFactory(param1:String) : Function
      {
         if(param1 !== null)
         {
            if(param1 in this._headerRendererFactories)
            {
               return this._headerRendererFactories[param1] as Function;
            }
            throw new ReferenceError("Cannot find header renderer factory for ID \"" + param1 + "\".");
         }
         return this._headerRendererFactory;
      }
      
      private function headerFactoryIDToStorage(param1:String) : HeaderRendererFactoryStorage
      {
         var _loc2_:HeaderRendererFactoryStorage = null;
         if(param1 !== null)
         {
            if(param1 in this._headerStorageMap)
            {
               return HeaderRendererFactoryStorage(this._headerStorageMap[param1]);
            }
            _loc2_ = new HeaderRendererFactoryStorage();
            this._headerStorageMap[param1] = _loc2_;
            return _loc2_;
         }
         return this._defaultHeaderRendererStorage;
      }
      
      private function footerFactoryIDToFactory(param1:String) : Function
      {
         if(param1 !== null)
         {
            if(param1 in this._footerRendererFactories)
            {
               return this._footerRendererFactories[param1] as Function;
            }
            throw new ReferenceError("Cannot find footer renderer factory for ID \"" + param1 + "\".");
         }
         return this._footerRendererFactory;
      }
      
      private function footerFactoryIDToStorage(param1:String) : FooterRendererFactoryStorage
      {
         var _loc2_:FooterRendererFactoryStorage = null;
         if(param1 !== null)
         {
            if(param1 in this._footerStorageMap)
            {
               return FooterRendererFactoryStorage(this._footerStorageMap[param1]);
            }
            _loc2_ = new FooterRendererFactoryStorage();
            this._footerStorageMap[param1] = _loc2_;
            return _loc2_;
         }
         return this._defaultFooterRendererStorage;
      }
      
      private function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      private function owner_scrollStartHandler(param1:Event) : void
      {
         this._isScrolling = true;
      }
      
      private function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate("data");
      }
      
      private function dataProvider_addItemHandler(param1:Event, param2:Array) : void
      {
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:* = 0;
         var _loc6_:* = 0;
         var _loc11_:int = 0;
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc7_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc5_ = param2[1] as int;
            _loc4_ = this.locationToDisplayIndex(_loc7_,_loc5_);
            _loc3_.addToVariableVirtualCacheAtIndex(_loc4_);
         }
         else
         {
            if((_loc8_ = this.groupToHeaderDisplayIndex(_loc7_)) >= 0)
            {
               _loc3_.addToVariableVirtualCacheAtIndex(_loc8_);
            }
            if((_loc9_ = this._dataProvider.getLength(_loc7_)) > 0)
            {
               if((_loc10_ = _loc8_) < 0)
               {
                  _loc10_ = this.locationToDisplayIndex(_loc7_,0);
               }
               _loc9_ += _loc10_;
               _loc6_ = _loc10_;
               while(_loc6_ < _loc9_)
               {
                  _loc3_.addToVariableVirtualCacheAtIndex(_loc10_);
                  _loc6_++;
               }
            }
            if((_loc11_ = this.groupToFooterDisplayIndex(_loc7_)) >= 0)
            {
               _loc3_.addToVariableVirtualCacheAtIndex(_loc11_);
            }
         }
      }
      
      private function dataProvider_removeItemHandler(param1:Event, param2:Array) : void
      {
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc5_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc4_ = param2[1] as int;
            _loc6_ = this.locationToDisplayIndex(_loc5_,_loc4_);
            _loc3_.removeFromVariableVirtualCacheAtIndex(_loc6_);
         }
         else
         {
            _loc3_.resetVariableVirtualCache();
         }
      }
      
      private function dataProvider_replaceItemHandler(param1:Event, param2:Array) : void
      {
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc5_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc4_ = param2[1] as int;
            _loc6_ = this.locationToDisplayIndex(_loc5_,_loc4_);
            _loc3_.resetVariableVirtualCacheAtIndex(_loc6_);
         }
         else
         {
            _loc3_.resetVariableVirtualCache();
         }
      }
      
      private function dataProvider_resetHandler(param1:Event) : void
      {
         this._updateForDataReset = true;
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCache();
      }
      
      private function dataProvider_updateItemHandler(param1:Event, param2:Array) : void
      {
         var _loc6_:int = 0;
         var _loc5_:Object = null;
         var _loc3_:IGroupedListItemRenderer = null;
         var _loc10_:int = 0;
         var _loc7_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:IGroupedListHeaderRenderer = null;
         var _loc8_:IGroupedListFooterRenderer = null;
         var _loc4_:IVariableVirtualLayout = null;
         var _loc9_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc6_ = param2[1] as int;
            _loc5_ = this._dataProvider.getItemAt(_loc9_,_loc6_);
            _loc3_ = IGroupedListItemRenderer(this._itemRendererMap[_loc5_]);
            if(_loc3_)
            {
               _loc3_.data = null;
               _loc3_.data = _loc5_;
            }
         }
         else
         {
            _loc10_ = this._dataProvider.getLength(_loc9_);
            _loc7_ = 0;
            while(_loc7_ < _loc10_)
            {
               if(_loc5_ = this._dataProvider.getItemAt(_loc9_,_loc7_))
               {
                  _loc3_ = IGroupedListItemRenderer(this._itemRendererMap[_loc5_]);
                  if(_loc3_)
                  {
                     _loc3_.data = null;
                     _loc3_.data = _loc5_;
                  }
               }
               _loc7_++;
            }
            _loc11_ = this._dataProvider.getItemAt(_loc9_);
            if(_loc5_ = this._owner.groupToHeaderData(_loc11_))
            {
               if(_loc12_ = IGroupedListHeaderRenderer(this._headerRendererMap[_loc5_]))
               {
                  _loc12_.data = null;
                  _loc12_.data = _loc5_;
               }
            }
            if(_loc5_ = this._owner.groupToFooterData(_loc11_))
            {
               if(_loc8_ = IGroupedListFooterRenderer(this._footerRendererMap[_loc5_]))
               {
                  _loc8_.data = null;
                  _loc8_.data = _loc5_;
               }
            }
            this.invalidate("data");
            if(!(_loc4_ = this._layout as IVariableVirtualLayout) || !_loc4_.hasVariableItemDimensions)
            {
               return;
            }
            _loc4_.resetVariableVirtualCache();
         }
      }
      
      private function dataProvider_updateAllHandler(param1:Event) : void
      {
         var _loc2_:IGroupedListItemRenderer = null;
         var _loc7_:IGroupedListHeaderRenderer = null;
         var _loc6_:IGroupedListFooterRenderer = null;
         for(var _loc3_ in this._itemRendererMap)
         {
            _loc2_ = IGroupedListItemRenderer(this._itemRendererMap[_loc3_]);
            if(!_loc2_)
            {
               return;
            }
            _loc2_.data = null;
            _loc2_.data = _loc3_;
         }
         for(var _loc5_ in this._headerRendererMap)
         {
            if(!(_loc7_ = IGroupedListHeaderRenderer(this._headerRendererMap[_loc5_])))
            {
               return;
            }
            _loc7_.data = null;
            _loc7_.data = _loc5_;
         }
         for(var _loc4_ in this._footerRendererMap)
         {
            if(!(_loc6_ = IGroupedListFooterRenderer(this._footerRendererMap[_loc4_])))
            {
               return;
            }
            _loc6_.data = null;
            _loc6_.data = _loc4_;
         }
      }
      
      private function layout_changeHandler(param1:Event) : void
      {
         if(this._ignoreLayoutChanges)
         {
            return;
         }
         this.invalidate("layout");
         this.invalidateParent("layout");
      }
      
      private function itemRenderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         if(param1.currentTarget === this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
         {
            return;
         }
         var _loc3_:IGroupedListItemRenderer = IGroupedListItemRenderer(param1.currentTarget);
         if(_loc3_.layoutIndex < 0)
         {
            return;
         }
         this.invalidate("layout");
         this.invalidateParent("layout");
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCacheAtIndex(_loc3_.layoutIndex,DisplayObject(_loc3_));
      }
      
      private function headerRenderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         var _loc3_:IGroupedListHeaderRenderer = IGroupedListHeaderRenderer(param1.currentTarget);
         if(_loc3_.layoutIndex < 0)
         {
            return;
         }
         this.invalidate("layout");
         this.invalidateParent("layout");
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCacheAtIndex(_loc3_.layoutIndex,DisplayObject(_loc3_));
      }
      
      private function footerRenderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         var _loc3_:IGroupedListFooterRenderer = IGroupedListFooterRenderer(param1.currentTarget);
         if(_loc3_.layoutIndex < 0)
         {
            return;
         }
         this.invalidate("layout");
         this.invalidateParent("layout");
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCacheAtIndex(_loc3_.layoutIndex,DisplayObject(_loc3_));
      }
      
      private function renderer_triggeredHandler(param1:Event) : void
      {
         var _loc2_:IGroupedListItemRenderer = IGroupedListItemRenderer(param1.currentTarget);
         this.parent.dispatchEventWith("triggered",false,_loc2_.data);
      }
      
      private function renderer_changeHandler(param1:Event) : void
      {
         if(this._ignoreSelectionChanges)
         {
            return;
         }
         var _loc2_:IGroupedListItemRenderer = IGroupedListItemRenderer(param1.currentTarget);
         if(!this._isSelectable || this._isScrolling)
         {
            _loc2_.isSelected = false;
            return;
         }
         if(_loc2_.isSelected)
         {
            this.setSelectedLocation(_loc2_.groupIndex,_loc2_.itemIndex);
         }
         else
         {
            this.setSelectedLocation(-1,-1);
         }
      }
      
      private function removedFromStageHandler(param1:Event) : void
      {
         this.touchPointID = -1;
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this,"ended",this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = -1;
         }
         else
         {
            _loc2_ = param1.getTouch(this,"began");
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = _loc2_.id;
            this._isScrolling = false;
         }
      }
   }
}

import feathers.controls.renderers.IGroupedListItemRenderer;

class ItemRendererFactoryStorage
{
    
   
   public var activeItemRenderers:Vector.<IGroupedListItemRenderer>;
   
   public var inactiveItemRenderers:Vector.<IGroupedListItemRenderer>;
   
   public function ItemRendererFactoryStorage()
   {
      activeItemRenderers = new Vector.<IGroupedListItemRenderer>(0);
      inactiveItemRenderers = new Vector.<IGroupedListItemRenderer>(0);
      super();
   }
}

import feathers.controls.renderers.IGroupedListHeaderRenderer;

class HeaderRendererFactoryStorage
{
    
   
   public var activeHeaderRenderers:Vector.<IGroupedListHeaderRenderer>;
   
   public var inactiveHeaderRenderers:Vector.<IGroupedListHeaderRenderer>;
   
   public function HeaderRendererFactoryStorage()
   {
      activeHeaderRenderers = new Vector.<IGroupedListHeaderRenderer>(0);
      inactiveHeaderRenderers = new Vector.<IGroupedListHeaderRenderer>(0);
      super();
   }
}

import feathers.controls.renderers.IGroupedListFooterRenderer;

class FooterRendererFactoryStorage
{
    
   
   public var activeFooterRenderers:Vector.<IGroupedListFooterRenderer>;
   
   public var inactiveFooterRenderers:Vector.<IGroupedListFooterRenderer>;
   
   public function FooterRendererFactoryStorage()
   {
      activeFooterRenderers = new Vector.<IGroupedListFooterRenderer>(0);
      inactiveFooterRenderers = new Vector.<IGroupedListFooterRenderer>(0);
      super();
   }
}
