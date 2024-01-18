package feathers.controls.supportClasses
{
   import feathers.controls.List;
   import feathers.controls.Scroller;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.data.ListCollection;
   import feathers.layout.ILayout;
   import feathers.layout.ITrimmedVirtualLayout;
   import feathers.layout.IVariableVirtualLayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ViewPortBounds;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class ListDataViewPort extends FeathersControl implements IViewPort
   {
      
      private static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const HELPER_VECTOR:Vector.<int> = new Vector.<int>(0);
       
      
      private var touchPointID:int = -1;
      
      private var _viewPortBounds:ViewPortBounds;
      
      private var _layoutResult:LayoutBoundsResult;
      
      private var _actualMinVisibleWidth:Number = 0;
      
      private var _explicitMinVisibleWidth:Number;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var actualVisibleWidth:Number = 0;
      
      private var explicitVisibleWidth:Number = NaN;
      
      private var _actualMinVisibleHeight:Number = 0;
      
      private var _explicitMinVisibleHeight:Number;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var actualVisibleHeight:Number = 0;
      
      private var explicitVisibleHeight:Number = NaN;
      
      protected var _contentX:Number = 0;
      
      protected var _contentY:Number = 0;
      
      private var _typicalItemIsInDataProvider:Boolean = false;
      
      private var _typicalItemRenderer:IListItemRenderer;
      
      private var _unrenderedData:Array;
      
      private var _layoutItems:Vector.<DisplayObject>;
      
      private var _defaultStorage:ItemRendererFactoryStorage;
      
      private var _storageMap:Object;
      
      private var _rendererMap:Dictionary;
      
      private var _minimumItemCount:int;
      
      private var _layoutIndexOffset:int = 0;
      
      private var _isScrolling:Boolean = false;
      
      private var _owner:List;
      
      private var _updateForDataReset:Boolean = false;
      
      private var _dataProvider:ListCollection;
      
      private var _itemRendererType:Class;
      
      private var _itemRendererFactory:Function;
      
      private var _itemRendererFactories:Object;
      
      private var _factoryIDFunction:Function;
      
      private var _customItemRendererStyleName:String;
      
      private var _typicalItem:Object = null;
      
      private var _itemRendererProperties:PropertyProxy;
      
      private var _ignoreLayoutChanges:Boolean = false;
      
      private var _ignoreRendererResizing:Boolean = false;
      
      private var _layout:ILayout;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      private var _ignoreSelectionChanges:Boolean = false;
      
      private var _isSelectable:Boolean = true;
      
      private var _allowMultipleSelection:Boolean = false;
      
      private var _selectedIndices:ListCollection;
      
      public function ListDataViewPort()
      {
         _viewPortBounds = new ViewPortBounds();
         _layoutResult = new LayoutBoundsResult();
         _unrenderedData = [];
         _layoutItems = new Vector.<DisplayObject>(0);
         _defaultStorage = new ItemRendererFactoryStorage();
         _rendererMap = new Dictionary(true);
         super();
         this.addEventListener("removedFromStage",removedFromStageHandler);
         this.addEventListener("touch",touchHandler);
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
            if(this.explicitVisibleWidth !== this.explicitVisibleWidth && (this.actualVisibleWidth < param1 || this.actualVisibleWidth === _loc3_))
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
         if(this.explicitVisibleWidth !== this.explicitVisibleWidth && (this.actualVisibleWidth > param1 || this.actualVisibleWidth === _loc2_))
         {
            this.invalidate("size");
         }
      }
      
      public function get visibleWidth() : Number
      {
         return this.actualVisibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this.explicitVisibleWidth == param1 || param1 !== param1 && this.explicitVisibleWidth !== this.explicitVisibleWidth)
         {
            return;
         }
         this.explicitVisibleWidth = param1;
         if(this.actualVisibleWidth !== param1)
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
            if(this.explicitVisibleHeight !== this.explicitVisibleHeight && (this.actualVisibleHeight < param1 || this.actualVisibleHeight === _loc3_))
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
         if(this.explicitVisibleHeight !== this.explicitVisibleHeight && (this.actualVisibleHeight > param1 || this.actualVisibleHeight === _loc2_))
         {
            this.invalidate("size");
         }
      }
      
      public function get visibleHeight() : Number
      {
         return this.actualVisibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this.explicitVisibleHeight == param1 || param1 !== param1 && this.explicitVisibleHeight !== this.explicitVisibleHeight)
         {
            return;
         }
         this.explicitVisibleHeight = param1;
         if(this.actualVisibleHeight !== param1)
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
      
      public function get owner() : List
      {
         return this._owner;
      }
      
      public function set owner(param1:List) : void
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
         if(param1 !== null)
         {
            this._storageMap = {};
         }
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
         if(this._layout)
         {
            EventDispatcher(this._layout).removeEventListener("change",layout_changeHandler);
         }
         this._layout = param1;
         if(this._layout)
         {
            if(this._layout is IVariableVirtualLayout)
            {
               IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
            }
            EventDispatcher(this._layout).addEventListener("change",layout_changeHandler);
         }
         this.invalidate("layout");
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
         if(!param1)
         {
            this.selectedIndices = null;
         }
      }
      
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(param1:Boolean) : void
      {
         this._allowMultipleSelection = param1;
      }
      
      public function get selectedIndices() : ListCollection
      {
         return this._selectedIndices;
      }
      
      public function set selectedIndices(param1:ListCollection) : void
      {
         if(this._selectedIndices == param1)
         {
            return;
         }
         if(this._selectedIndices)
         {
            this._selectedIndices.removeEventListener("change",selectedIndices_changeHandler);
         }
         this._selectedIndices = param1;
         if(this._selectedIndices)
         {
            this._selectedIndices.addEventListener("change",selectedIndices_changeHandler);
         }
         this.invalidate("selected");
      }
      
      public function get requiresMeasurementOnScroll() : Boolean
      {
         return this._layout.requiresLayoutOnScroll && (this.explicitVisibleWidth !== this.explicitVisibleWidth || this.explicitVisibleHeight !== this.explicitVisibleHeight);
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Point = null) : Point
      {
         if(!param2)
         {
            param2 = new Point();
         }
         return this._layout.getScrollPositionForIndex(param1,this._layoutItems,0,0,this.actualVisibleWidth,this.actualVisibleHeight,param2);
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Point = null) : Point
      {
         if(!param2)
         {
            param2 = new Point();
         }
         return this._layout.getNearestScrollPositionForIndex(param1,this._horizontalScrollPosition,this._verticalScrollPosition,this._layoutItems,0,0,this.actualVisibleWidth,this.actualVisibleHeight,param2);
      }
      
      public function itemToItemRenderer(param1:Object) : IListItemRenderer
      {
         return IListItemRenderer(this._rendererMap[param1]);
      }
      
      override public function dispose() : void
      {
         this.refreshInactiveRenderers(null,true);
         if(this._storageMap)
         {
            for(var _loc1_ in this._storageMap)
            {
               this.refreshInactiveRenderers(_loc1_,true);
            }
         }
         this.owner = null;
         this.layout = null;
         this.dataProvider = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc13_:Boolean = false;
         var _loc6_:Boolean = this.isInvalid("data");
         var _loc9_:Boolean = this.isInvalid("scroll");
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc4_:Boolean = this.isInvalid("selected");
         var _loc11_:Boolean = this.isInvalid("itemRendererFactory");
         var _loc7_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("state");
         var _loc12_:Boolean;
         if(!(_loc12_ = this.isInvalid("layout")) && _loc9_ && this._layout && this._layout.requiresLayoutOnScroll)
         {
            _loc12_ = true;
         }
         var _loc5_:Boolean = _loc1_ || _loc6_ || _loc12_ || _loc11_;
         var _loc8_:Boolean = this._ignoreRendererResizing;
         this._ignoreRendererResizing = true;
         var _loc10_:Boolean = this._ignoreLayoutChanges;
         this._ignoreLayoutChanges = true;
         if(_loc9_ || _loc1_)
         {
            this.refreshViewPortBounds();
         }
         if(_loc5_)
         {
            this.refreshInactiveRenderers(null,_loc11_);
            if(this._storageMap)
            {
               for(var _loc3_ in this._storageMap)
               {
                  this.refreshInactiveRenderers(_loc3_,_loc11_);
               }
            }
         }
         if(_loc6_ || _loc12_ || _loc11_)
         {
            this.refreshLayoutTypicalItem();
         }
         if(_loc5_)
         {
            this.refreshRenderers();
         }
         if(_loc7_ || _loc5_)
         {
            this.refreshItemRendererStyles();
         }
         if(_loc4_ || _loc5_)
         {
            _loc13_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.refreshSelection();
            this._ignoreSelectionChanges = _loc13_;
         }
         if(_loc2_ || _loc5_)
         {
            this.refreshEnabled();
         }
         this._ignoreLayoutChanges = _loc10_;
         if(_loc2_ || _loc4_ || _loc7_ || _loc5_)
         {
            this._layout.layout(this._layoutItems,this._viewPortBounds,this._layoutResult);
         }
         this._ignoreRendererResizing = _loc8_;
         this._contentX = this._layoutResult.contentX;
         this._contentY = this._layoutResult.contentY;
         this.saveMeasurements(this._layoutResult.contentWidth,this._layoutResult.contentHeight,this._layoutResult.contentWidth,this._layoutResult.contentHeight);
         this.actualVisibleWidth = this._layoutResult.viewPortWidth;
         this.actualVisibleHeight = this._layoutResult.viewPortHeight;
         this._actualMinVisibleWidth = this._layoutResult.viewPortWidth;
         this._actualMinVisibleHeight = this._layoutResult.viewPortHeight;
         this.validateItemRenderers();
      }
      
      private function invalidateParent(param1:String = "all") : void
      {
         Scroller(this.parent).invalidate(param1);
      }
      
      private function validateItemRenderers() : void
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
      
      private function refreshLayoutTypicalItem() : void
      {
         var _loc6_:IListItemRenderer = null;
         var _loc7_:* = false;
         var _loc1_:Boolean = false;
         var _loc3_:String = null;
         var _loc8_:IVirtualLayout;
         if(!(_loc8_ = this._layout as IVirtualLayout) || !_loc8_.useVirtualLayout)
         {
            if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
            {
               this.destroyRenderer(this._typicalItemRenderer);
               this._typicalItemRenderer = null;
            }
            return;
         }
         var _loc5_:int = 0;
         var _loc4_:* = false;
         var _loc2_:Object = this._typicalItem;
         if(_loc2_ !== null)
         {
            if(this._dataProvider)
            {
               _loc4_ = (_loc5_ = this._dataProvider.getItemIndex(_loc2_)) >= 0;
            }
            if(_loc5_ < 0)
            {
               _loc5_ = 0;
            }
         }
         else
         {
            _loc4_ = true;
            if(this._dataProvider && this._dataProvider.length > 0)
            {
               _loc2_ = this._dataProvider.getItemAt(0);
            }
         }
         if(_loc2_ !== null)
         {
            if(_loc6_ = IListItemRenderer(this._rendererMap[_loc2_]))
            {
               _loc6_.index = _loc5_;
            }
            if(!_loc6_ && this._typicalItemRenderer)
            {
               _loc7_ = !this._typicalItemIsInDataProvider;
               _loc1_ = this._typicalItemIsInDataProvider && this._dataProvider && this._dataProvider.getItemIndex(this._typicalItemRenderer.data) < 0;
               if(!_loc7_ && _loc1_)
               {
                  _loc7_ = true;
               }
               if(_loc7_)
               {
                  _loc3_ = null;
                  if(this._factoryIDFunction !== null)
                  {
                     _loc3_ = this.getFactoryID(_loc2_,_loc5_);
                  }
                  if(this._typicalItemRenderer.factoryID !== _loc3_)
                  {
                     _loc7_ = false;
                  }
               }
               if(_loc7_)
               {
                  if(this._typicalItemIsInDataProvider)
                  {
                     delete this._rendererMap[this._typicalItemRenderer.data];
                  }
                  (_loc6_ = this._typicalItemRenderer).data = _loc2_;
                  _loc6_.index = _loc5_;
                  if(_loc4_)
                  {
                     this._rendererMap[_loc2_] = _loc6_;
                  }
               }
            }
            if(!_loc6_)
            {
               _loc6_ = this.createRenderer(_loc2_,_loc5_,false,!_loc4_);
               if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
               {
                  this.destroyRenderer(this._typicalItemRenderer);
                  this._typicalItemRenderer = null;
               }
            }
         }
         _loc8_.typicalItem = DisplayObject(_loc6_);
         this._typicalItemRenderer = _loc6_;
         this._typicalItemIsInDataProvider = _loc4_;
         if(this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
         {
            this._typicalItemRenderer.addEventListener("resize",renderer_resizeHandler);
         }
      }
      
      private function refreshItemRendererStyles() : void
      {
         var _loc1_:IListItemRenderer = null;
         for each(var _loc2_ in this._layoutItems)
         {
            _loc1_ = _loc2_ as IListItemRenderer;
            if(_loc1_)
            {
               this.refreshOneItemRendererStyles(_loc1_);
            }
         }
      }
      
      private function refreshOneItemRendererStyles(param1:IListItemRenderer) : void
      {
         var _loc4_:Object = null;
         var _loc2_:DisplayObject = DisplayObject(param1);
         for(var _loc3_ in this._itemRendererProperties)
         {
            _loc4_ = this._itemRendererProperties[_loc3_];
            _loc2_[_loc3_] = _loc4_;
         }
      }
      
      private function refreshSelection() : void
      {
         var _loc1_:IListItemRenderer = null;
         for each(var _loc2_ in this._layoutItems)
         {
            _loc1_ = _loc2_ as IListItemRenderer;
            if(_loc1_)
            {
               _loc1_.isSelected = this._selectedIndices.getItemIndex(_loc1_.index) >= 0;
            }
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
      
      private function refreshViewPortBounds() : void
      {
         var _loc1_:* = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth;
         var _loc2_:* = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight;
         this._viewPortBounds.x = 0;
         this._viewPortBounds.y = 0;
         this._viewPortBounds.scrollX = this._horizontalScrollPosition;
         this._viewPortBounds.scrollY = this._verticalScrollPosition;
         this._viewPortBounds.explicitWidth = this.explicitVisibleWidth;
         this._viewPortBounds.explicitHeight = this.explicitVisibleHeight;
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
      
      private function refreshInactiveRenderers(param1:String, param2:Boolean) : void
      {
         var _loc4_:ItemRendererFactoryStorage = null;
         if(param1 !== null)
         {
            _loc4_ = ItemRendererFactoryStorage(this._storageMap[param1]);
         }
         else
         {
            _loc4_ = this._defaultStorage;
         }
         var _loc3_:Vector.<IListItemRenderer> = _loc4_.inactiveItemRenderers;
         _loc4_.inactiveItemRenderers = _loc4_.activeItemRenderers;
         _loc4_.activeItemRenderers = _loc3_;
         if(_loc4_.activeItemRenderers.length > 0)
         {
            throw new IllegalOperationError("ListDataViewPort: active renderers should be empty.");
         }
         if(param2)
         {
            this.recoverInactiveRenderers(_loc4_);
            this.freeInactiveRenderers(_loc4_,0);
            if(this._typicalItemRenderer && this._typicalItemRenderer.factoryID === param1)
            {
               if(this._typicalItemIsInDataProvider)
               {
                  delete this._rendererMap[this._typicalItemRenderer.data];
               }
               this.destroyRenderer(this._typicalItemRenderer);
               this._typicalItemRenderer = null;
               this._typicalItemIsInDataProvider = false;
            }
         }
         this._layoutItems.length = 0;
      }
      
      private function refreshRenderers() : void
      {
         var _loc6_:ItemRendererFactoryStorage = null;
         var _loc2_:* = undefined;
         var _loc5_:* = undefined;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         if(this._typicalItemRenderer)
         {
            if(this._typicalItemIsInDataProvider)
            {
               _loc2_ = (_loc6_ = this.factoryIDToStorage(this._typicalItemRenderer.factoryID)).inactiveItemRenderers;
               _loc5_ = _loc6_.activeItemRenderers;
               if((_loc4_ = _loc2_.indexOf(this._typicalItemRenderer)) >= 0)
               {
                  _loc2_[_loc4_] = null;
               }
               _loc1_ = int(_loc5_.length);
               if(_loc1_ === 0)
               {
                  _loc5_[_loc1_] = this._typicalItemRenderer;
               }
            }
            this.refreshOneItemRendererStyles(this._typicalItemRenderer);
         }
         this.findUnrenderedData();
         this.recoverInactiveRenderers(this._defaultStorage);
         if(this._storageMap)
         {
            for(var _loc3_ in this._storageMap)
            {
               _loc6_ = ItemRendererFactoryStorage(this._storageMap[_loc3_]);
               this.recoverInactiveRenderers(_loc6_);
            }
         }
         this.renderUnrenderedData();
         this.freeInactiveRenderers(this._defaultStorage,this._minimumItemCount);
         if(this._storageMap)
         {
            for(_loc3_ in this._storageMap)
            {
               _loc6_ = ItemRendererFactoryStorage(this._storageMap[_loc3_]);
               this.freeInactiveRenderers(_loc6_,1);
            }
         }
         this._updateForDataReset = false;
      }
      
      private function findUnrenderedData() : void
      {
         var _loc19_:* = 0;
         var _loc16_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc11_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:ITrimmedVirtualLayout = null;
         var _loc3_:Object = null;
         var _loc1_:IListItemRenderer = null;
         var _loc10_:ItemRendererFactoryStorage = null;
         var _loc9_:* = undefined;
         var _loc17_:* = undefined;
         var _loc5_:int = 0;
         var _loc12_:int = int(!!this._dataProvider ? this._dataProvider.length : 0);
         var _loc18_:Boolean;
         var _loc13_:IVirtualLayout;
         if(_loc18_ = (_loc13_ = this._layout as IVirtualLayout) && _loc13_.useVirtualLayout)
         {
            _loc13_.measureViewPort(_loc12_,this._viewPortBounds,HELPER_POINT);
            _loc13_.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition,this._verticalScrollPosition,HELPER_POINT.x,HELPER_POINT.y,_loc12_,HELPER_VECTOR);
         }
         var _loc6_:int = int(_loc18_ ? HELPER_VECTOR.length : _loc12_);
         if(_loc18_ && this._typicalItemIsInDataProvider && this._typicalItemRenderer && HELPER_VECTOR.indexOf(this._typicalItemRenderer.index) >= 0)
         {
            this._minimumItemCount = _loc6_ + 1;
         }
         else
         {
            this._minimumItemCount = _loc6_;
         }
         var _loc2_:Boolean = this._layout is ITrimmedVirtualLayout && _loc18_ && (!(this._layout is IVariableVirtualLayout) || !IVariableVirtualLayout(this._layout).hasVariableItemDimensions) && _loc6_ > 0;
         if(_loc2_)
         {
            _loc16_ = _loc19_ = HELPER_VECTOR[0];
            _loc7_ = 1;
            while(_loc7_ < _loc6_)
            {
               if((_loc8_ = HELPER_VECTOR[_loc7_]) < _loc19_)
               {
                  _loc19_ = _loc8_;
               }
               if(_loc8_ > _loc16_)
               {
                  _loc16_ = _loc8_;
               }
               _loc7_++;
            }
            if((_loc11_ = _loc19_ - 1) < 0)
            {
               _loc11_ = 0;
            }
            _loc14_ = _loc12_ - 1 - _loc16_;
            (_loc15_ = ITrimmedVirtualLayout(this._layout)).beforeVirtualizedItemCount = _loc11_;
            _loc15_.afterVirtualizedItemCount = _loc14_;
            this._layoutItems.length = _loc12_ - _loc11_ - _loc14_;
            this._layoutIndexOffset = -_loc11_;
         }
         else
         {
            this._layoutIndexOffset = 0;
            this._layoutItems.length = _loc12_;
         }
         var _loc4_:int = int(this._unrenderedData.length);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            if(!((_loc8_ = _loc18_ ? HELPER_VECTOR[_loc7_] : _loc7_) < 0 || _loc8_ >= _loc12_))
            {
               _loc3_ = this._dataProvider.getItemAt(_loc8_);
               _loc1_ = IListItemRenderer(this._rendererMap[_loc3_]);
               if(_loc1_)
               {
                  _loc1_.index = _loc8_;
                  _loc1_.visible = true;
                  if(this._updateForDataReset)
                  {
                     _loc1_.data = null;
                     _loc1_.data = _loc3_;
                  }
                  if(this._typicalItemRenderer != _loc1_)
                  {
                     _loc9_ = (_loc10_ = this.factoryIDToStorage(_loc1_.factoryID)).activeItemRenderers;
                     _loc17_ = _loc10_.inactiveItemRenderers;
                     _loc9_[_loc9_.length] = _loc1_;
                     if((_loc5_ = _loc17_.indexOf(_loc1_)) < 0)
                     {
                        throw new IllegalOperationError("ListDataViewPort: renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
                     }
                     _loc17_[_loc5_] = null;
                  }
                  this._layoutItems[_loc8_ + this._layoutIndexOffset] = DisplayObject(_loc1_);
               }
               else
               {
                  this._unrenderedData[_loc4_] = _loc3_;
                  _loc4_++;
               }
            }
            _loc7_++;
         }
         if(this._typicalItemRenderer)
         {
            if(_loc18_ && this._typicalItemIsInDataProvider)
            {
               if((_loc8_ = HELPER_VECTOR.indexOf(this._typicalItemRenderer.index)) >= 0)
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
      
      private function renderUnrenderedData() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Object = null;
         var _loc4_:int = 0;
         var _loc2_:IListItemRenderer = null;
         var _loc5_:int = int(this._unrenderedData.length);
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc1_ = this._unrenderedData.shift();
            _loc4_ = this._dataProvider.getItemIndex(_loc1_);
            _loc2_ = this.createRenderer(_loc1_,_loc4_,true,false);
            _loc2_.visible = true;
            this._layoutItems[_loc4_ + this._layoutIndexOffset] = DisplayObject(_loc2_);
            _loc3_++;
         }
      }
      
      private function recoverInactiveRenderers(param1:ItemRendererFactoryStorage) : void
      {
         var _loc4_:int = 0;
         var _loc2_:IListItemRenderer = null;
         var _loc3_:Vector.<IListItemRenderer> = param1.inactiveItemRenderers;
         var _loc5_:int = int(_loc3_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = _loc3_[_loc4_];
            if(!(!_loc2_ || _loc2_.index < 0))
            {
               this._owner.dispatchEventWith("rendererRemove",false,_loc2_);
               delete this._rendererMap[_loc2_.data];
            }
            _loc4_++;
         }
      }
      
      private function freeInactiveRenderers(param1:ItemRendererFactoryStorage, param2:int) : void
      {
         var _loc8_:int = 0;
         var _loc3_:IListItemRenderer = null;
         var _loc5_:Vector.<IListItemRenderer> = param1.inactiveItemRenderers;
         var _loc7_:Vector.<IListItemRenderer>;
         var _loc6_:int = int((_loc7_ = param1.activeItemRenderers).length);
         var _loc9_:int = int(_loc5_.length);
         var _loc4_:*;
         if((_loc4_ = param2 - _loc6_) > _loc9_)
         {
            _loc4_ = _loc9_;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc4_)
         {
            _loc3_ = _loc5_.shift();
            if(!_loc3_)
            {
               _loc4_++;
               if(_loc9_ < _loc4_)
               {
                  _loc4_ = _loc9_;
               }
            }
            else
            {
               _loc3_.data = null;
               _loc3_.index = -1;
               _loc3_.visible = false;
               _loc7_[_loc6_] = _loc3_;
               _loc6_++;
            }
            _loc8_++;
         }
         _loc9_ -= _loc4_;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc3_ = _loc5_.shift();
            if(_loc3_)
            {
               this.destroyRenderer(_loc3_);
            }
            _loc8_++;
         }
      }
      
      private function createRenderer(param1:Object, param2:int, param3:Boolean, param4:Boolean) : IListItemRenderer
      {
         var _loc5_:IListItemRenderer = null;
         var _loc6_:String = null;
         if(this._factoryIDFunction !== null)
         {
            _loc6_ = this.getFactoryID(param1,param2);
         }
         var _loc9_:Function = this.factoryIDToFactory(_loc6_);
         var _loc10_:ItemRendererFactoryStorage;
         var _loc7_:Vector.<IListItemRenderer> = (_loc10_ = this.factoryIDToStorage(_loc6_)).inactiveItemRenderers;
         var _loc8_:Vector.<IListItemRenderer> = _loc10_.activeItemRenderers;
         do
         {
            if(!param3 || param4 || _loc7_.length === 0)
            {
               if(_loc9_ !== null)
               {
                  _loc5_ = IListItemRenderer(_loc9_());
               }
               else
               {
                  _loc5_ = IListItemRenderer(new this._itemRendererType());
               }
               if(this._customItemRendererStyleName && this._customItemRendererStyleName.length > 0)
               {
                  _loc5_.styleNameList.add(this._customItemRendererStyleName);
               }
               this.addChild(DisplayObject(_loc5_));
            }
            else
            {
               _loc5_ = _loc7_.shift();
            }
         }
         while(!_loc5_);
         
         _loc5_.data = param1;
         _loc5_.index = param2;
         _loc5_.owner = this._owner;
         _loc5_.factoryID = _loc6_;
         if(!param4)
         {
            this._rendererMap[param1] = _loc5_;
            _loc8_[_loc8_.length] = _loc5_;
            _loc5_.addEventListener("triggered",renderer_triggeredHandler);
            _loc5_.addEventListener("change",renderer_changeHandler);
            _loc5_.addEventListener("resize",renderer_resizeHandler);
            this._owner.dispatchEventWith("rendererAdd",false,_loc5_);
         }
         return _loc5_;
      }
      
      private function destroyRenderer(param1:IListItemRenderer) : void
      {
         param1.removeEventListener("triggered",renderer_triggeredHandler);
         param1.removeEventListener("change",renderer_changeHandler);
         param1.removeEventListener("resize",renderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         param1.factoryID = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function getFactoryID(param1:Object, param2:int) : String
      {
         if(this._factoryIDFunction === null)
         {
            return null;
         }
         if(this._factoryIDFunction.length === 1)
         {
            return this._factoryIDFunction(param1);
         }
         return this._factoryIDFunction(param1,param2);
      }
      
      private function factoryIDToFactory(param1:String) : Function
      {
         if(param1 !== null)
         {
            if(param1 in this._itemRendererFactories)
            {
               return this._itemRendererFactories[param1] as Function;
            }
            throw new ReferenceError("Cannot find item renderer factory for ID \"" + param1 + "\".");
         }
         return this._itemRendererFactory;
      }
      
      private function factoryIDToStorage(param1:String) : ItemRendererFactoryStorage
      {
         var _loc2_:ItemRendererFactoryStorage = null;
         if(param1 !== null)
         {
            if(param1 in this._storageMap)
            {
               return ItemRendererFactoryStorage(this._storageMap[param1]);
            }
            _loc2_ = new ItemRendererFactoryStorage();
            this._storageMap[param1] = _loc2_;
            return _loc2_;
         }
         return this._defaultStorage;
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
      
      private function dataProvider_addItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.addToVariableVirtualCacheAtIndex(param2);
      }
      
      private function dataProvider_removeItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.removeFromVariableVirtualCacheAtIndex(param2);
      }
      
      private function dataProvider_replaceItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc3_ || !_loc3_.hasVariableItemDimensions)
         {
            return;
         }
         _loc3_.resetVariableVirtualCacheAtIndex(param2);
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
      
      private function dataProvider_updateItemHandler(param1:Event, param2:int) : void
      {
         var _loc3_:Object = this._dataProvider.getItemAt(param2);
         var _loc4_:IListItemRenderer;
         if(!(_loc4_ = IListItemRenderer(this._rendererMap[_loc3_])))
         {
            return;
         }
         _loc4_.data = null;
         _loc4_.data = _loc3_;
      }
      
      private function dataProvider_updateAllHandler(param1:Event) : void
      {
         var _loc3_:IListItemRenderer = null;
         for(var _loc2_ in this._rendererMap)
         {
            _loc3_ = IListItemRenderer(this._rendererMap[_loc2_]);
            if(!_loc3_)
            {
               return;
            }
            _loc3_.data = null;
            _loc3_.data = _loc2_;
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
      
      private function renderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         this.invalidate("layout");
         this.invalidateParent("layout");
         if(param1.currentTarget === this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
         {
            return;
         }
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc3_:IListItemRenderer = IListItemRenderer(param1.currentTarget);
         _loc2_.resetVariableVirtualCacheAtIndex(_loc3_.index,DisplayObject(_loc3_));
      }
      
      private function renderer_triggeredHandler(param1:Event) : void
      {
         var _loc2_:IListItemRenderer = IListItemRenderer(param1.currentTarget);
         this.parent.dispatchEventWith("triggered",false,_loc2_.data);
      }
      
      private function renderer_changeHandler(param1:Event) : void
      {
         var _loc4_:int = 0;
         if(this._ignoreSelectionChanges)
         {
            return;
         }
         var _loc2_:IListItemRenderer = IListItemRenderer(param1.currentTarget);
         if(!this._isSelectable || this._isScrolling)
         {
            _loc2_.isSelected = false;
            return;
         }
         var _loc3_:Boolean = Boolean(_loc2_.isSelected);
         var _loc5_:int = _loc2_.index;
         if(this._allowMultipleSelection)
         {
            _loc4_ = this._selectedIndices.getItemIndex(_loc5_);
            if(_loc3_ && _loc4_ < 0)
            {
               this._selectedIndices.addItem(_loc5_);
            }
            else if(!_loc3_ && _loc4_ >= 0)
            {
               this._selectedIndices.removeItemAt(_loc4_);
            }
         }
         else if(_loc3_)
         {
            this._selectedIndices.data = new <int>[_loc5_];
         }
         else
         {
            this._selectedIndices.removeAll();
         }
      }
      
      private function selectedIndices_changeHandler(param1:Event) : void
      {
         this.invalidate("selected");
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

import feathers.controls.renderers.IListItemRenderer;

class ItemRendererFactoryStorage
{
    
   
   public var activeItemRenderers:Vector.<IListItemRenderer>;
   
   public var inactiveItemRenderers:Vector.<IListItemRenderer>;
   
   public function ItemRendererFactoryStorage()
   {
      activeItemRenderers = new Vector.<IListItemRenderer>(0);
      inactiveItemRenderers = new Vector.<IListItemRenderer>(0);
      super();
   }
}
