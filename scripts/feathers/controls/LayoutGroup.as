package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.layout.ILayout;
   import feathers.layout.ILayoutDisplayObject;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ViewPortBounds;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.stageToStarling;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.core.starling_internal;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.filters.FragmentFilter;
   import starling.rendering.Painter;
   
   use namespace starling_internal;
   
   public class LayoutGroup extends FeathersControl
   {
      
      protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
      
      public static const AUTO_SIZE_MODE_STAGE:String = "stage";
      
      public static const AUTO_SIZE_MODE_CONTENT:String = "content";
      
      public static const ALTERNATE_STYLE_NAME_TOOLBAR:String = "feathers-toolbar-layout-group";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var items:Vector.<DisplayObject>;
      
      protected var viewPortBounds:ViewPortBounds;
      
      protected var _layoutResult:LayoutBoundsResult;
      
      protected var _layout:ILayout;
      
      protected var _clipContent:Boolean = false;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _autoSizeMode:String = "content";
      
      protected var _ignoreChildChanges:Boolean = false;
      
      public function LayoutGroup()
      {
         items = new Vector.<DisplayObject>(0);
         viewPortBounds = new ViewPortBounds();
         _layoutResult = new LayoutBoundsResult();
         super();
         this.addEventListener("addedToStage",layoutGroup_addedToStageHandler);
         this.addEventListener("removedFromStage",layoutGroup_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return LayoutGroup.globalStyleProvider;
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
            this._layout.removeEventListener("change",layout_changeHandler);
         }
         this._layout = param1;
         if(this._layout)
         {
            if(this._layout is IVirtualLayout)
            {
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            this._layout.addEventListener("change",layout_changeHandler);
            this.invalidate("layout");
         }
         this.invalidate("layout");
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
         this.invalidate("clipping");
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this._backgroundSkin == param1)
         {
            return;
         }
         if(param1 && param1.parent)
         {
            param1.removeFromParent();
         }
         this._backgroundSkin = param1;
         this.invalidate("skin");
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this._backgroundDisabledSkin;
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this._backgroundDisabledSkin == param1)
         {
            return;
         }
         if(param1 && param1.parent)
         {
            param1.removeFromParent();
         }
         this._backgroundDisabledSkin = param1;
         this.invalidate("skin");
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
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(param1 is IFeathersControl)
         {
            param1.addEventListener("resize",child_resizeHandler);
         }
         if(param1 is ILayoutDisplayObject)
         {
            param1.addEventListener("layoutDataChange",child_layoutDataChangeHandler);
         }
         var _loc3_:int = this.items.indexOf(param1);
         if(_loc3_ == param2)
         {
            return param1;
         }
         if(_loc3_ >= 0)
         {
            this.items.removeAt(_loc3_);
         }
         this.items.insertAt(param2,param1);
         this.invalidate("layout");
         return super.addChildAt(param1,param2);
      }
      
      override public function removeChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         if(param1 >= 0 && param1 < this.items.length)
         {
            this.items.removeAt(param1);
         }
         var _loc3_:DisplayObject = super.removeChildAt(param1,param2);
         if(_loc3_ is IFeathersControl)
         {
            _loc3_.removeEventListener("resize",child_resizeHandler);
         }
         if(_loc3_ is ILayoutDisplayObject)
         {
            _loc3_.removeEventListener("layoutDataChange",child_layoutDataChangeHandler);
         }
         this.invalidate("layout");
         return _loc3_;
      }
      
      override public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         super.setChildIndex(param1,param2);
         var _loc3_:int = this.items.indexOf(param1);
         if(_loc3_ === param2)
         {
            return;
         }
         this.items.removeAt(_loc3_);
         this.items.insertAt(param2,param1);
         this.invalidate("layout");
      }
      
      override public function swapChildrenAt(param1:int, param2:int) : void
      {
         super.swapChildrenAt(param1,param2);
         var _loc4_:DisplayObject = this.items[param1];
         var _loc3_:DisplayObject = this.items[param2];
         this.items[param1] = _loc3_;
         this.items[param2] = _loc4_;
         this.invalidate("layout");
      }
      
      override public function sortChildren(param1:Function) : void
      {
         super.sortChildren(param1);
         this.items.sort(param1);
         this.invalidate("layout");
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc4_:Number = param1.x;
         var _loc3_:Number = param1.y;
         var _loc2_:DisplayObject = super.hitTest(param1);
         if(_loc2_)
         {
            if(!this._isEnabled)
            {
               return this;
            }
            return _loc2_;
         }
         if(!this.visible || !this.touchable)
         {
            return null;
         }
         if(this.currentBackgroundSkin && this._hitArea.contains(_loc4_,_loc3_))
         {
            return this;
         }
         return null;
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:FragmentFilter = null;
         if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.visible && this.currentBackgroundSkin.alpha > 0)
         {
            this.currentBackgroundSkin.setRequiresRedraw();
            _loc3_ = this.currentBackgroundSkin.mask;
            _loc2_ = this.currentBackgroundSkin.filter;
            param1.pushState();
            param1.setStateTo(this.currentBackgroundSkin.transformationMatrix,this.currentBackgroundSkin.alpha,this.currentBackgroundSkin.blendMode);
            if(_loc3_ !== null)
            {
               param1.drawMask(_loc3_);
            }
            if(_loc2_ !== null)
            {
               _loc2_.render(param1);
            }
            else
            {
               this.currentBackgroundSkin.render(param1);
            }
            if(_loc3_ !== null)
            {
               param1.eraseMask(_loc3_);
            }
            param1.popState();
         }
         super.render(param1);
      }
      
      override public function dispose() : void
      {
         if(this.currentBackgroundSkin !== null)
         {
            this.currentBackgroundSkin.starling_internal::setParent(null);
         }
         if(this._backgroundSkin && this._backgroundSkin.parent !== this)
         {
            this._backgroundSkin.dispose();
         }
         if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent !== this)
         {
            this._backgroundDisabledSkin.dispose();
         }
         this.layout = null;
         super.dispose();
      }
      
      public function readjustLayout() : void
      {
         this.invalidate("layout");
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
         var _loc6_:Boolean = false;
         var _loc2_:Boolean = this.isInvalid("layout");
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc5_:Boolean = this.isInvalid("clipping");
         var _loc7_:Boolean = this.isInvalid("scroll");
         var _loc3_:Boolean = this.isInvalid("skin");
         var _loc4_:Boolean = this.isInvalid("state");
         if(!_loc2_ && _loc7_ && this._layout && this._layout.requiresLayoutOnScroll)
         {
            _loc2_ = true;
         }
         if(_loc3_ || _loc4_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc1_ || _loc2_ || _loc3_ || _loc4_)
         {
            this.refreshViewPortBounds();
            if(this._layout)
            {
               _loc6_ = this._ignoreChildChanges;
               this._ignoreChildChanges = true;
               this._layout.layout(this.items,this.viewPortBounds,this._layoutResult);
               this._ignoreChildChanges = _loc6_;
            }
            else
            {
               this.handleManualLayout();
            }
            this.handleLayoutResult();
            this.refreshBackgroundLayout();
            this.validateChildren();
         }
         if(_loc1_ || _loc5_)
         {
            this.refreshClipRect();
         }
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentBackgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin !== null)
         {
            this.currentBackgroundSkin = this._backgroundDisabledSkin;
         }
         else
         {
            this.currentBackgroundSkin = this._backgroundSkin;
         }
         switch(_loc1_)
         {
            default:
               _loc1_.starling_internal::setParent(null);
            case null:
               if(this.currentBackgroundSkin !== null)
               {
                  this.currentBackgroundSkin.starling_internal::setParent(this);
                  if(this.currentBackgroundSkin is IFeathersControl)
                  {
                     IFeathersControl(this.currentBackgroundSkin).initializeNow();
                  }
                  if(this.currentBackgroundSkin is IMeasureDisplayObject)
                  {
                     _loc2_ = IMeasureDisplayObject(this.currentBackgroundSkin);
                     this._explicitBackgroundWidth = _loc2_.explicitWidth;
                     this._explicitBackgroundHeight = _loc2_.explicitHeight;
                     this._explicitBackgroundMinWidth = _loc2_.explicitMinWidth;
                     this._explicitBackgroundMinHeight = _loc2_.explicitMinHeight;
                     this._explicitBackgroundMaxWidth = _loc2_.explicitMaxWidth;
                     this._explicitBackgroundMaxHeight = _loc2_.explicitMaxHeight;
                     break;
                  }
                  this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
                  this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
                  this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
                  this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
               }
               break;
            case _loc1_:
         }
      }
      
      protected function refreshBackgroundLayout() : void
      {
         if(this.currentBackgroundSkin === null)
         {
            return;
         }
         if(this.currentBackgroundSkin.width !== this.actualWidth || this.currentBackgroundSkin.height !== this.actualHeight)
         {
            this.currentBackgroundSkin.width = this.actualWidth;
            this.currentBackgroundSkin.height = this.actualHeight;
         }
      }
      
      protected function refreshViewPortBounds() : void
      {
         var _loc1_:* = this._explicitWidth !== this._explicitWidth;
         var _loc3_:* = this._explicitHeight !== this._explicitHeight;
         var _loc2_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc6_:* = this._explicitMinHeight !== this._explicitMinHeight;
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         this.viewPortBounds.x = 0;
         this.viewPortBounds.y = 0;
         this.viewPortBounds.scrollX = 0;
         this.viewPortBounds.scrollY = 0;
         if(_loc1_ && this._autoSizeMode === "stage")
         {
            this.viewPortBounds.explicitWidth = this.stage.stageWidth;
         }
         else
         {
            this.viewPortBounds.explicitWidth = this._explicitWidth;
         }
         if(_loc3_ && this._autoSizeMode === "stage")
         {
            this.viewPortBounds.explicitHeight = this.stage.stageHeight;
         }
         else
         {
            this.viewPortBounds.explicitHeight = this._explicitHeight;
         }
         var _loc4_:Number = this._explicitMinWidth;
         if(_loc2_)
         {
            _loc4_ = 0;
         }
         var _loc5_:Number = this._explicitMinHeight;
         if(_loc6_)
         {
            _loc5_ = 0;
         }
         if(this.currentBackgroundSkin !== null)
         {
            if(this.currentBackgroundSkin.width > _loc4_)
            {
               _loc4_ = this.currentBackgroundSkin.width;
            }
            if(this.currentBackgroundSkin.height > _loc5_)
            {
               _loc5_ = this.currentBackgroundSkin.height;
            }
         }
         this.viewPortBounds.minWidth = _loc4_;
         this.viewPortBounds.minHeight = _loc5_;
         this.viewPortBounds.maxWidth = this._explicitMaxWidth;
         this.viewPortBounds.maxHeight = this._explicitMaxHeight;
      }
      
      protected function handleLayoutResult() : void
      {
         var _loc1_:Number = this._layoutResult.viewPortWidth;
         var _loc2_:Number = this._layoutResult.viewPortHeight;
         this.saveMeasurements(_loc1_,_loc2_,_loc1_,_loc2_);
      }
      
      protected function handleManualLayout() : void
      {
         var _loc7_:int = 0;
         var _loc1_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc4_:* = this.viewPortBounds.explicitWidth;
         if(_loc4_ !== _loc4_)
         {
            _loc4_ = 0;
         }
         var _loc3_:* = this.viewPortBounds.explicitHeight;
         if(_loc3_ !== _loc3_)
         {
            _loc3_ = 0;
         }
         var _loc10_:Boolean = this._ignoreChildChanges;
         this._ignoreChildChanges = true;
         var _loc12_:int = int(this.items.length);
         _loc7_ = 0;
         while(_loc7_ < _loc12_)
         {
            _loc1_ = this.items[_loc7_];
            if(!(_loc1_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc1_).includeInLayout))
            {
               if(_loc1_ is IValidating)
               {
                  IValidating(_loc1_).validate();
               }
               _loc9_ = _loc1_.x + _loc1_.width;
               _loc2_ = _loc1_.y + _loc1_.height;
               if(_loc9_ === _loc9_ && _loc9_ > _loc4_)
               {
                  _loc4_ = _loc9_;
               }
               if(_loc2_ === _loc2_ && _loc2_ > _loc3_)
               {
                  _loc3_ = _loc2_;
               }
            }
            _loc7_++;
         }
         this._ignoreChildChanges = _loc10_;
         this._layoutResult.contentX = 0;
         this._layoutResult.contentY = 0;
         this._layoutResult.contentWidth = _loc4_;
         this._layoutResult.contentHeight = _loc3_;
         var _loc8_:Number = this.viewPortBounds.minWidth;
         var _loc11_:Number = this.viewPortBounds.minHeight;
         if(_loc4_ < _loc8_)
         {
            _loc4_ = _loc8_;
         }
         if(_loc3_ < _loc11_)
         {
            _loc3_ = _loc11_;
         }
         var _loc5_:Number = this.viewPortBounds.maxWidth;
         var _loc6_:Number = this.viewPortBounds.maxHeight;
         if(_loc4_ > _loc5_)
         {
            _loc4_ = _loc5_;
         }
         if(_loc3_ > _loc6_)
         {
            _loc3_ = _loc6_;
         }
         this._layoutResult.viewPortWidth = _loc4_;
         this._layoutResult.viewPortHeight = _loc3_;
      }
      
      protected function validateChildren() : void
      {
         var _loc2_:int = 0;
         var _loc1_:DisplayObject = null;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc3_:int = int(this.items.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.items[_loc2_];
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
            _loc2_++;
         }
      }
      
      protected function refreshClipRect() : void
      {
         if(!this._clipContent)
         {
            return;
         }
         var _loc1_:Quad = this.mask as Quad;
         if(_loc1_)
         {
            _loc1_.x = 0;
            _loc1_.y = 0;
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
      
      protected function layoutGroup_addedToStageHandler(param1:Event) : void
      {
         if(this._autoSizeMode == "stage")
         {
            this.stage.addEventListener("resize",stage_resizeHandler);
         }
      }
      
      protected function layoutGroup_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener("resize",stage_resizeHandler);
      }
      
      protected function layout_changeHandler(param1:Event) : void
      {
         this.invalidate("layout");
      }
      
      protected function child_resizeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         this.invalidate("layout");
      }
      
      protected function child_layoutDataChangeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         this.invalidate("layout");
      }
      
      protected function stage_resizeHandler(param1:Event) : void
      {
         this.invalidate("layout");
      }
   }
}
