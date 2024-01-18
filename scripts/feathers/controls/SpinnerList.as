package feathers.controls
{
   import feathers.core.IValidating;
   import feathers.data.ListCollection;
   import feathers.layout.ILayout;
   import feathers.layout.ISpinnerLayout;
   import feathers.layout.VerticalSpinnerLayout;
   import feathers.skins.IStyleProvider;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   
   public class SpinnerList extends List
   {
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var _selectionOverlaySkin:DisplayObject;
      
      public function SpinnerList()
      {
         super();
         this._scrollBarDisplayMode = "none";
         this._snapToPages = true;
         this._snapOnComplete = true;
         this.decelerationRate = 0.99;
         this.addEventListener("triggered",spinnerList_triggeredHandler);
         this.addEventListener("scrollComplete",spinnerList_scrollCompleteHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         if(SpinnerList.globalStyleProvider)
         {
            return SpinnerList.globalStyleProvider;
         }
         return List.globalStyleProvider;
      }
      
      override public function set snapToPages(param1:Boolean) : void
      {
         if(!param1)
         {
            throw new ArgumentError("SpinnerList requires snapToPages to be true.");
         }
         super.snapToPages = param1;
      }
      
      override public function set allowMultipleSelection(param1:Boolean) : void
      {
         if(param1)
         {
            throw new ArgumentError("SpinnerList requires allowMultipleSelection to be false.");
         }
         super.allowMultipleSelection = param1;
      }
      
      override public function set isSelectable(param1:Boolean) : void
      {
         if(!param1)
         {
            throw new ArgumentError("SpinnerList requires isSelectable to be true.");
         }
         super.snapToPages = param1;
      }
      
      override public function set layout(param1:ILayout) : void
      {
         if(param1 && !(param1 is ISpinnerLayout))
         {
            throw new ArgumentError("SpinnerList requires layouts to implement the ISpinnerLayout interface.");
         }
         super.layout = param1;
      }
      
      override public function set selectedIndex(param1:int) : void
      {
         if(param1 < 0 && this._dataProvider !== null && this._dataProvider.length > 0)
         {
            return;
         }
         if(this._selectedIndex !== param1)
         {
            this.scrollToDisplayIndex(param1,0);
         }
         super.selectedIndex = param1;
      }
      
      override public function set selectedItem(param1:Object) : void
      {
         if(this._dataProvider === null)
         {
            this.selectedIndex = -1;
            return;
         }
         var _loc2_:int = this._dataProvider.getItemIndex(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         this.selectedIndex = _loc2_;
      }
      
      override public function set dataProvider(param1:ListCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         super.dataProvider = param1;
         if(!this._dataProvider || this._dataProvider.length == 0)
         {
            this.selectedIndex = -1;
         }
         else
         {
            this.selectedIndex = 0;
         }
      }
      
      public function get selectionOverlaySkin() : DisplayObject
      {
         return this._selectionOverlaySkin;
      }
      
      public function set selectionOverlaySkin(param1:DisplayObject) : void
      {
         if(this._selectionOverlaySkin == param1)
         {
            return;
         }
         if(this._selectionOverlaySkin && this._selectionOverlaySkin.parent == this)
         {
            this.removeRawChildInternal(this._selectionOverlaySkin);
         }
         this._selectionOverlaySkin = param1;
         if(this._selectionOverlaySkin)
         {
            this.addRawChildInternal(this._selectionOverlaySkin);
         }
         this.invalidate("styles");
      }
      
      override protected function initialize() : void
      {
         var _loc1_:VerticalSpinnerLayout = null;
         if(this._layout == null)
         {
            if(this._hasElasticEdges && this._verticalScrollPolicy === "auto" && this._scrollBarDisplayMode !== "fixed")
            {
               this.verticalScrollPolicy = "on";
            }
            _loc1_ = new VerticalSpinnerLayout();
            _loc1_.useVirtualLayout = true;
            _loc1_.padding = 0;
            _loc1_.gap = 0;
            _loc1_.horizontalAlign = "justify";
            _loc1_.requestedRowCount = 4;
            this.layout = _loc1_;
         }
         super.initialize();
      }
      
      override protected function refreshMinAndMaxScrollPositions() : void
      {
         super.refreshMinAndMaxScrollPositions();
         if(this._maxVerticalScrollPosition != this._minVerticalScrollPosition)
         {
            this.actualPageHeight = ISpinnerLayout(this._layout).snapInterval;
         }
         else if(this._maxHorizontalScrollPosition != this._minHorizontalScrollPosition)
         {
            this.actualPageWidth = ISpinnerLayout(this._layout).snapInterval;
         }
      }
      
      override protected function handlePendingScroll() : void
      {
         var _loc1_:int = 0;
         if(this.pendingItemIndex >= 0)
         {
            _loc1_ = this.pendingItemIndex;
            this.pendingItemIndex = -1;
            if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
            {
               this.pendingVerticalPageIndex = this.calculateNearestPageIndexForItem(_loc1_,this._verticalPageIndex,this._maxVerticalPageIndex);
               this.hasPendingVerticalPageIndex = this.pendingVerticalPageIndex !== this._verticalPageIndex;
            }
            else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
            {
               this.pendingHorizontalPageIndex = this.calculateNearestPageIndexForItem(_loc1_,this._horizontalPageIndex,this._maxHorizontalPageIndex);
               this.hasPendingHorizontalPageIndex = this.pendingHorizontalPageIndex !== this._horizontalPageIndex;
            }
         }
         super.handlePendingScroll();
      }
      
      override protected function layoutChildren() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = NaN;
         super.layoutChildren();
         if(this._selectionOverlaySkin)
         {
            if(this._selectionOverlaySkin is IValidating)
            {
               IValidating(this._selectionOverlaySkin).validate();
            }
            if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
            {
               this._selectionOverlaySkin.width = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
               _loc2_ = this.actualPageHeight;
               if(_loc2_ > this.actualHeight)
               {
                  _loc2_ = this.actualHeight;
               }
               this._selectionOverlaySkin.height = _loc2_;
               this._selectionOverlaySkin.x = this._leftViewPortOffset;
               this._selectionOverlaySkin.y = Math.round(this._topViewPortOffset + (this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset - _loc2_) / 2);
            }
            else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
            {
               _loc1_ = this.actualPageWidth;
               if(_loc1_ > this.actualWidth)
               {
                  _loc1_ = this.actualWidth;
               }
               this._selectionOverlaySkin.width = _loc1_;
               this._selectionOverlaySkin.height = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
               this._selectionOverlaySkin.x = Math.round(this._leftViewPortOffset + (this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset - _loc1_) / 2);
               this._selectionOverlaySkin.y = this._topViewPortOffset;
            }
         }
      }
      
      protected function calculateNearestPageIndexForItem(param1:int, param2:int, param3:int) : int
      {
         var _loc6_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param3 != 2147483647)
         {
            return param1;
         }
         var _loc7_:int = this._dataProvider.length;
         var _loc5_:int = param2 / _loc7_;
         var _loc8_:int = param2 % _loc7_;
         if(param1 < _loc8_)
         {
            _loc6_ = _loc5_ * _loc7_ + param1;
            _loc4_ = (_loc5_ + 1) * _loc7_ + param1;
         }
         else
         {
            _loc6_ = (_loc5_ - 1) * _loc7_ + param1;
            _loc4_ = _loc5_ * _loc7_ + param1;
         }
         if(_loc4_ - param2 < param2 - _loc6_)
         {
            return _loc4_;
         }
         return _loc6_;
      }
      
      protected function spinnerList_scrollCompleteHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = this._dataProvider.length;
         if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
         {
            _loc2_ = this._verticalPageIndex % _loc3_;
         }
         else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
         {
            _loc2_ = this._horizontalPageIndex % _loc3_;
         }
         if(_loc2_ < 0)
         {
            _loc2_ = _loc3_ + _loc2_;
         }
         this.selectedIndex = _loc2_;
      }
      
      protected function spinnerList_triggeredHandler(param1:Event, param2:Object) : void
      {
         var _loc3_:int = this._dataProvider.getItemIndex(param2);
         if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
         {
            _loc3_ = this.calculateNearestPageIndexForItem(_loc3_,this._verticalPageIndex,this._maxVerticalPageIndex);
            this.throwToPage(this._horizontalPageIndex,_loc3_,this._pageThrowDuration);
         }
         else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
         {
            _loc3_ = this.calculateNearestPageIndexForItem(_loc3_,this._horizontalPageIndex,this._maxHorizontalPageIndex);
            this.throwToPage(_loc3_,this._verticalPageIndex);
         }
      }
      
      override protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         if(!this._dataProvider)
         {
            return;
         }
         var _loc3_:Boolean = false;
         if(param1.keyCode == 36)
         {
            if(this._dataProvider.length > 0)
            {
               this.selectedIndex = 0;
               _loc3_ = true;
            }
         }
         else if(param1.keyCode == 35)
         {
            this.selectedIndex = this._dataProvider.length - 1;
            _loc3_ = true;
         }
         else if(param1.keyCode == 38)
         {
            if((_loc4_ = this._selectedIndex - 1) < 0)
            {
               _loc4_ = this._dataProvider.length + _loc4_;
            }
            this.selectedIndex = _loc4_;
            _loc3_ = true;
         }
         else if(param1.keyCode == 40)
         {
            if((_loc4_ = this._selectedIndex + 1) >= this._dataProvider.length)
            {
               _loc4_ -= this._dataProvider.length;
            }
            this.selectedIndex = _loc4_;
            _loc3_ = true;
         }
         if(_loc3_)
         {
            if(this._maxVerticalPageIndex != this._minVerticalPageIndex)
            {
               _loc2_ = this.calculateNearestPageIndexForItem(this._selectedIndex,this._verticalPageIndex,this._maxVerticalPageIndex);
               this.throwToPage(this._horizontalPageIndex,_loc2_,this._pageThrowDuration);
            }
            else if(this._maxHorizontalPageIndex != this._minHorizontalPageIndex)
            {
               _loc2_ = this.calculateNearestPageIndexForItem(this._selectedIndex,this._horizontalPageIndex,this._maxHorizontalPageIndex);
               this.throwToPage(_loc2_,this._verticalPageIndex);
            }
         }
      }
   }
}
