package feathers.controls.renderers
{
   import feathers.controls.ImageLoader;
   import feathers.controls.Scroller;
   import feathers.controls.ToggleButton;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusContainer;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IStateObserver;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class BaseDefaultItemRenderer extends ToggleButton implements IFocusContainer
   {
      
      public static const ALTERNATE_STYLE_NAME_DRILL_DOWN:String = "feathers-drill-down-item-renderer";
      
      public static const ALTERNATE_STYLE_NAME_CHECK:String = "feathers-check-item-renderer";
      
      public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-item-renderer-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ICON_LABEL:String = "feathers-item-renderer-icon-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ACCESSORY_LABEL:String = "feathers-item-renderer-accessory-label";
      
      public static const STATE_UP:String = "up";
      
      public static const STATE_DOWN:String = "down";
      
      public static const STATE_HOVER:String = "hover";
      
      public static const STATE_DISABLED:String = "disabled";
      
      public static const STATE_UP_AND_SELECTED:String = "upAndSelected";
      
      public static const STATE_DOWN_AND_SELECTED:String = "downAndSelected";
      
      public static const STATE_HOVER_AND_SELECTED:String = "hoverAndSelected";
      
      public static const STATE_DISABLED_AND_SELECTED:String = "disabledAndSelected";
      
      public static const ICON_POSITION_TOP:String = "top";
      
      public static const ICON_POSITION_RIGHT:String = "right";
      
      public static const ICON_POSITION_BOTTOM:String = "bottom";
      
      public static const ICON_POSITION_LEFT:String = "left";
      
      public static const ICON_POSITION_MANUAL:String = "manual";
      
      public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";
      
      public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const ACCESSORY_POSITION_TOP:String = "top";
      
      public static const ACCESSORY_POSITION_RIGHT:String = "right";
      
      public static const ACCESSORY_POSITION_BOTTOM:String = "bottom";
      
      public static const ACCESSORY_POSITION_LEFT:String = "left";
      
      public static const ACCESSORY_POSITION_MANUAL:String = "manual";
      
      public static const LAYOUT_ORDER_LABEL_ACCESSORY_ICON:String = "labelAccessoryIcon";
      
      public static const LAYOUT_ORDER_LABEL_ICON_ACCESSORY:String = "labelIconAccessory";
      
      private static const HELPER_POINT:Point = new Point();
      
      protected static var DOWN_STATE_DELAY_MS:int = 250;
       
      
      protected var iconLabelStyleName:String = "feathers-item-renderer-icon-label";
      
      protected var accessoryLabelStyleName:String = "feathers-item-renderer-accessory-label";
      
      protected var _isChildFocusEnabled:Boolean = true;
      
      protected var skinLoader:ImageLoader;
      
      protected var iconLoader:ImageLoader;
      
      protected var iconLabel:ITextRenderer;
      
      protected var accessoryLoader:ImageLoader;
      
      protected var accessoryLabel:ITextRenderer;
      
      protected var currentAccessory:DisplayObject;
      
      protected var _skinIsFromItem:Boolean = false;
      
      protected var _iconIsFromItem:Boolean = false;
      
      protected var _accessoryIsFromItem:Boolean = false;
      
      protected var _data:Object;
      
      protected var _owner:Scroller;
      
      protected var _factoryID:String;
      
      protected var _delayedCurrentState:String;
      
      protected var _stateDelayTimer:Timer;
      
      protected var _useStateDelayTimer:Boolean = true;
      
      protected var isSelectableWithoutToggle:Boolean = true;
      
      protected var _itemHasLabel:Boolean = true;
      
      protected var _itemHasIcon:Boolean = true;
      
      protected var _itemHasAccessory:Boolean = true;
      
      protected var _itemHasSkin:Boolean = false;
      
      protected var _itemHasSelectable:Boolean = false;
      
      protected var _itemHasEnabled:Boolean = false;
      
      protected var _accessoryPosition:String = "right";
      
      protected var _layoutOrder:String = "labelIconAccessory";
      
      protected var _accessoryOffsetX:Number = 0;
      
      protected var _accessoryOffsetY:Number = 0;
      
      protected var _accessoryGap:Number = NaN;
      
      protected var _minAccessoryGap:Number = NaN;
      
      protected var _defaultAccessory:DisplayObject;
      
      protected var _stateToAccessory:Object;
      
      protected var _stateToAccessoryFunction:Function;
      
      protected var accessoryTouchPointID:int = -1;
      
      protected var _stopScrollingOnAccessoryTouch:Boolean = true;
      
      protected var _isSelectableOnAccessoryTouch:Boolean = false;
      
      protected var _delayTextureCreationOnScroll:Boolean = false;
      
      protected var _labelField:String = "label";
      
      protected var _labelFunction:Function;
      
      protected var _iconField:String = "icon";
      
      protected var _iconFunction:Function;
      
      protected var _iconSourceField:String = "iconSource";
      
      protected var _iconSourceFunction:Function;
      
      protected var _iconLabelField:String = "iconLabel";
      
      protected var _iconLabelFunction:Function;
      
      protected var _customIconLabelStyleName:String;
      
      protected var _accessoryField:String = "accessory";
      
      protected var _accessoryFunction:Function;
      
      protected var _accessorySourceField:String = "accessorySource";
      
      protected var _accessorySourceFunction:Function;
      
      protected var _accessoryLabelField:String = "accessoryLabel";
      
      protected var _accessoryLabelFunction:Function;
      
      protected var _customAccessoryLabelStyleName:String;
      
      protected var _skinField:String = "skin";
      
      protected var _skinFunction:Function;
      
      protected var _skinSourceField:String = "skinSource";
      
      protected var _skinSourceFunction:Function;
      
      protected var _selectableField:String = "selectable";
      
      protected var _selectableFunction:Function;
      
      protected var _enabledField:String = "enabled";
      
      protected var _enabledFunction:Function;
      
      protected var _explicitIsToggle:Boolean = false;
      
      protected var _explicitIsEnabled:Boolean;
      
      protected var _iconLoaderFactory:Function;
      
      protected var _iconLabelFactory:Function;
      
      protected var _iconLabelProperties:PropertyProxy;
      
      protected var _accessoryLoaderFactory:Function;
      
      protected var _accessoryLabelFactory:Function;
      
      protected var _accessoryLabelProperties:PropertyProxy;
      
      protected var _skinLoaderFactory:Function;
      
      protected var _ignoreAccessoryResizes:Boolean = false;
      
      public function BaseDefaultItemRenderer()
      {
         _stateToAccessory = {};
         _iconLoaderFactory = defaultLoaderFactory;
         _accessoryLoaderFactory = defaultLoaderFactory;
         _skinLoaderFactory = defaultLoaderFactory;
         super();
         this._explicitIsEnabled = this._isEnabled;
         this.labelStyleName = "feathers-item-renderer-label";
         this.isFocusEnabled = false;
         this.isQuickHitAreaEnabled = false;
         this.addEventListener("removedFromStage",itemRenderer_removedFromStageHandler);
      }
      
      protected static function defaultLoaderFactory() : ImageLoader
      {
         return new ImageLoader();
      }
      
      public function get isChildFocusEnabled() : Boolean
      {
         return this._isEnabled && this._isChildFocusEnabled;
      }
      
      public function set isChildFocusEnabled(param1:Boolean) : void
      {
         this._isChildFocusEnabled = param1;
      }
      
      override public function set defaultIcon(param1:DisplayObject) : void
      {
         if(this._defaultIcon === param1)
         {
            return;
         }
         this.replaceIcon(null);
         this._iconIsFromItem = false;
         super.defaultIcon = param1;
      }
      
      override public function set defaultSkin(param1:DisplayObject) : void
      {
         if(this._defaultSkin === param1)
         {
            return;
         }
         this.replaceSkin(null);
         this._skinIsFromItem = false;
         super.defaultSkin = param1;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data === param1)
         {
            return;
         }
         this._data = param1;
         this.invalidate("data");
      }
      
      public function get factoryID() : String
      {
         return this._factoryID;
      }
      
      public function set factoryID(param1:String) : void
      {
         this._factoryID = param1;
      }
      
      public function get useStateDelayTimer() : Boolean
      {
         return this._useStateDelayTimer;
      }
      
      public function set useStateDelayTimer(param1:Boolean) : void
      {
         this._useStateDelayTimer = param1;
      }
      
      public function get itemHasLabel() : Boolean
      {
         return this._itemHasLabel;
      }
      
      public function set itemHasLabel(param1:Boolean) : void
      {
         if(this._itemHasLabel == param1)
         {
            return;
         }
         this._itemHasLabel = param1;
         this.invalidate("data");
      }
      
      public function get itemHasIcon() : Boolean
      {
         return this._itemHasIcon;
      }
      
      public function set itemHasIcon(param1:Boolean) : void
      {
         if(this._itemHasIcon == param1)
         {
            return;
         }
         this._itemHasIcon = param1;
         this.invalidate("data");
      }
      
      public function get itemHasAccessory() : Boolean
      {
         return this._itemHasAccessory;
      }
      
      public function set itemHasAccessory(param1:Boolean) : void
      {
         if(this._itemHasAccessory == param1)
         {
            return;
         }
         this._itemHasAccessory = param1;
         this.invalidate("data");
      }
      
      public function get itemHasSkin() : Boolean
      {
         return this._itemHasSkin;
      }
      
      public function set itemHasSkin(param1:Boolean) : void
      {
         if(this._itemHasSkin == param1)
         {
            return;
         }
         this._itemHasSkin = param1;
         this.invalidate("data");
      }
      
      public function get itemHasSelectable() : Boolean
      {
         return this._itemHasSelectable;
      }
      
      public function set itemHasSelectable(param1:Boolean) : void
      {
         if(this._itemHasSelectable == param1)
         {
            return;
         }
         this._itemHasSelectable = param1;
         this.invalidate("data");
      }
      
      public function get itemHasEnabled() : Boolean
      {
         return this._itemHasEnabled;
      }
      
      public function set itemHasEnabled(param1:Boolean) : void
      {
         if(this._itemHasEnabled == param1)
         {
            return;
         }
         this._itemHasEnabled = param1;
         this.invalidate("data");
      }
      
      public function get accessoryPosition() : String
      {
         return this._accessoryPosition;
      }
      
      public function set accessoryPosition(param1:String) : void
      {
         if(this._accessoryPosition == param1)
         {
            return;
         }
         this._accessoryPosition = param1;
         this.invalidate("styles");
      }
      
      public function get layoutOrder() : String
      {
         return this._layoutOrder;
      }
      
      public function set layoutOrder(param1:String) : void
      {
         if(this._layoutOrder == param1)
         {
            return;
         }
         this._layoutOrder = param1;
         this.invalidate("styles");
      }
      
      public function get accessoryOffsetX() : Number
      {
         return this._accessoryOffsetX;
      }
      
      public function set accessoryOffsetX(param1:Number) : void
      {
         if(this._accessoryOffsetX == param1)
         {
            return;
         }
         this._accessoryOffsetX = param1;
         this.invalidate("styles");
      }
      
      public function get accessoryOffsetY() : Number
      {
         return this._accessoryOffsetY;
      }
      
      public function set accessoryOffsetY(param1:Number) : void
      {
         if(this._accessoryOffsetY == param1)
         {
            return;
         }
         this._accessoryOffsetY = param1;
         this.invalidate("styles");
      }
      
      public function get accessoryGap() : Number
      {
         return this._accessoryGap;
      }
      
      public function set accessoryGap(param1:Number) : void
      {
         if(this._accessoryGap == param1)
         {
            return;
         }
         this._accessoryGap = param1;
         this.invalidate("styles");
      }
      
      public function get minAccessoryGap() : Number
      {
         return this._minAccessoryGap;
      }
      
      public function set minAccessoryGap(param1:Number) : void
      {
         if(this._minAccessoryGap == param1)
         {
            return;
         }
         this._minAccessoryGap = param1;
         this.invalidate("styles");
      }
      
      public function get defaultAccessory() : DisplayObject
      {
         return this._defaultAccessory;
      }
      
      public function set defaultAccessory(param1:DisplayObject) : void
      {
         if(this._defaultAccessory === param1)
         {
            return;
         }
         this.replaceAccessory(null);
         this._accessoryIsFromItem = false;
         this._defaultAccessory = param1;
         this.invalidate("styles");
      }
      
      public function get stateToAccessoryFunction() : Function
      {
         return this._stateToAccessoryFunction;
      }
      
      public function set stateToAccessoryFunction(param1:Function) : void
      {
         if(this._stateToAccessoryFunction == param1)
         {
            return;
         }
         this._stateToAccessoryFunction = param1;
         this.invalidate("styles");
      }
      
      public function get stopScrollingOnAccessoryTouch() : Boolean
      {
         return this._stopScrollingOnAccessoryTouch;
      }
      
      public function set stopScrollingOnAccessoryTouch(param1:Boolean) : void
      {
         this._stopScrollingOnAccessoryTouch = param1;
      }
      
      public function get isSelectableOnAccessoryTouch() : Boolean
      {
         return this._isSelectableOnAccessoryTouch;
      }
      
      public function set isSelectableOnAccessoryTouch(param1:Boolean) : void
      {
         this._isSelectableOnAccessoryTouch = param1;
      }
      
      public function get delayTextureCreationOnScroll() : Boolean
      {
         return this._delayTextureCreationOnScroll;
      }
      
      public function set delayTextureCreationOnScroll(param1:Boolean) : void
      {
         this._delayTextureCreationOnScroll = param1;
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
         if(this._labelFunction == param1)
         {
            return;
         }
         this._labelFunction = param1;
         this.invalidate("data");
      }
      
      public function get iconField() : String
      {
         return this._iconField;
      }
      
      public function set iconField(param1:String) : void
      {
         if(this._iconField == param1)
         {
            return;
         }
         this._iconField = param1;
         this.invalidate("data");
      }
      
      public function get iconFunction() : Function
      {
         return this._iconFunction;
      }
      
      public function set iconFunction(param1:Function) : void
      {
         if(this._iconFunction == param1)
         {
            return;
         }
         this._iconFunction = param1;
         this.invalidate("data");
      }
      
      public function get iconSourceField() : String
      {
         return this._iconSourceField;
      }
      
      public function set iconSourceField(param1:String) : void
      {
         if(this._iconSourceField == param1)
         {
            return;
         }
         this._iconSourceField = param1;
         this.invalidate("data");
      }
      
      public function get iconSourceFunction() : Function
      {
         return this._iconSourceFunction;
      }
      
      public function set iconSourceFunction(param1:Function) : void
      {
         if(this._iconSourceFunction == param1)
         {
            return;
         }
         this._iconSourceFunction = param1;
         this.invalidate("data");
      }
      
      public function get iconLabelField() : String
      {
         return this._iconLabelField;
      }
      
      public function set iconLabelField(param1:String) : void
      {
         if(this._iconLabelField == param1)
         {
            return;
         }
         this._iconLabelField = param1;
         this.invalidate("data");
      }
      
      public function get iconLabelFunction() : Function
      {
         return this._iconLabelFunction;
      }
      
      public function set iconLabelFunction(param1:Function) : void
      {
         if(this._iconLabelFunction == param1)
         {
            return;
         }
         this._iconLabelFunction = param1;
         this.invalidate("data");
      }
      
      public function get customIconLabelStyleName() : String
      {
         return this._customIconLabelStyleName;
      }
      
      public function set customIconLabelStyleName(param1:String) : void
      {
         if(this._customIconLabelStyleName == param1)
         {
            return;
         }
         this._customIconLabelStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      public function get accessoryField() : String
      {
         return this._accessoryField;
      }
      
      public function set accessoryField(param1:String) : void
      {
         if(this._accessoryField == param1)
         {
            return;
         }
         this._accessoryField = param1;
         this.invalidate("data");
      }
      
      public function get accessoryFunction() : Function
      {
         return this._accessoryFunction;
      }
      
      public function set accessoryFunction(param1:Function) : void
      {
         if(this._accessoryFunction == param1)
         {
            return;
         }
         this._accessoryFunction = param1;
         this.invalidate("data");
      }
      
      public function get accessorySourceField() : String
      {
         return this._accessorySourceField;
      }
      
      public function set accessorySourceField(param1:String) : void
      {
         if(this._accessorySourceField == param1)
         {
            return;
         }
         this._accessorySourceField = param1;
         this.invalidate("data");
      }
      
      public function get accessorySourceFunction() : Function
      {
         return this._accessorySourceFunction;
      }
      
      public function set accessorySourceFunction(param1:Function) : void
      {
         if(this._accessorySourceFunction == param1)
         {
            return;
         }
         this._accessorySourceFunction = param1;
         this.invalidate("data");
      }
      
      public function get accessoryLabelField() : String
      {
         return this._accessoryLabelField;
      }
      
      public function set accessoryLabelField(param1:String) : void
      {
         if(this._accessoryLabelField == param1)
         {
            return;
         }
         this._accessoryLabelField = param1;
         this.invalidate("data");
      }
      
      public function get accessoryLabelFunction() : Function
      {
         return this._accessoryLabelFunction;
      }
      
      public function set accessoryLabelFunction(param1:Function) : void
      {
         if(this._accessoryLabelFunction == param1)
         {
            return;
         }
         this._accessoryLabelFunction = param1;
         this.invalidate("data");
      }
      
      public function get customAccessoryLabelStyleName() : String
      {
         return this._customAccessoryLabelStyleName;
      }
      
      public function set customAccessoryLabelStyleName(param1:String) : void
      {
         if(this._customAccessoryLabelStyleName == param1)
         {
            return;
         }
         this._customAccessoryLabelStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      public function get skinField() : String
      {
         return this._skinField;
      }
      
      public function set skinField(param1:String) : void
      {
         if(this._skinField == param1)
         {
            return;
         }
         this._skinField = param1;
         this.invalidate("data");
      }
      
      public function get skinFunction() : Function
      {
         return this._skinFunction;
      }
      
      public function set skinFunction(param1:Function) : void
      {
         if(this._skinFunction == param1)
         {
            return;
         }
         this._skinFunction = param1;
         this.invalidate("data");
      }
      
      public function get skinSourceField() : String
      {
         return this._skinSourceField;
      }
      
      public function set skinSourceField(param1:String) : void
      {
         if(this._iconSourceField == param1)
         {
            return;
         }
         this._skinSourceField = param1;
         this.invalidate("data");
      }
      
      public function get skinSourceFunction() : Function
      {
         return this._skinSourceFunction;
      }
      
      public function set skinSourceFunction(param1:Function) : void
      {
         if(this._skinSourceFunction == param1)
         {
            return;
         }
         this._skinSourceFunction = param1;
         this.invalidate("data");
      }
      
      public function get selectableField() : String
      {
         return this._selectableField;
      }
      
      public function set selectableField(param1:String) : void
      {
         if(this._selectableField == param1)
         {
            return;
         }
         this._selectableField = param1;
         this.invalidate("data");
      }
      
      public function get selectableFunction() : Function
      {
         return this._selectableFunction;
      }
      
      public function set selectableFunction(param1:Function) : void
      {
         if(this._selectableFunction == param1)
         {
            return;
         }
         this._selectableFunction = param1;
         this.invalidate("data");
      }
      
      public function get enabledField() : String
      {
         return this._enabledField;
      }
      
      public function set enabledField(param1:String) : void
      {
         if(this._enabledField == param1)
         {
            return;
         }
         this._enabledField = param1;
         this.invalidate("data");
      }
      
      public function get enabledFunction() : Function
      {
         return this._enabledFunction;
      }
      
      public function set enabledFunction(param1:Function) : void
      {
         if(this._enabledFunction == param1)
         {
            return;
         }
         this._enabledFunction = param1;
         this.invalidate("data");
      }
      
      override public function set isToggle(param1:Boolean) : void
      {
         if(this._explicitIsToggle == param1)
         {
            return;
         }
         super.isToggle = param1;
         this._explicitIsToggle = param1;
         this.invalidate("data");
      }
      
      override public function set isEnabled(param1:Boolean) : void
      {
         if(this._explicitIsEnabled == param1)
         {
            return;
         }
         this._explicitIsEnabled = param1;
         super.isEnabled = param1;
         this.invalidate("data");
      }
      
      public function get iconLoaderFactory() : Function
      {
         return this._iconLoaderFactory;
      }
      
      public function set iconLoaderFactory(param1:Function) : void
      {
         if(this._iconLoaderFactory == param1)
         {
            return;
         }
         this._iconLoaderFactory = param1;
         this._iconIsFromItem = false;
         this.replaceIcon(null);
         this.invalidate("data");
      }
      
      public function get iconLabelFactory() : Function
      {
         return this._iconLabelFactory;
      }
      
      public function set iconLabelFactory(param1:Function) : void
      {
         if(this._iconLabelFactory == param1)
         {
            return;
         }
         this._iconLabelFactory = param1;
         this._iconIsFromItem = false;
         this.replaceIcon(null);
         this.invalidate("data");
      }
      
      public function get iconLabelProperties() : Object
      {
         if(!this._iconLabelProperties)
         {
            this._iconLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._iconLabelProperties;
      }
      
      public function set iconLabelProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._iconLabelProperties == param1)
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
         if(this._iconLabelProperties)
         {
            this._iconLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._iconLabelProperties = PropertyProxy(param1);
         if(this._iconLabelProperties)
         {
            this._iconLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get accessoryLoaderFactory() : Function
      {
         return this._accessoryLoaderFactory;
      }
      
      public function set accessoryLoaderFactory(param1:Function) : void
      {
         if(this._accessoryLoaderFactory == param1)
         {
            return;
         }
         this._accessoryLoaderFactory = param1;
         this._accessoryIsFromItem = false;
         this.replaceAccessory(null);
         this.invalidate("data");
      }
      
      public function get accessoryLabelFactory() : Function
      {
         return this._accessoryLabelFactory;
      }
      
      public function set accessoryLabelFactory(param1:Function) : void
      {
         if(this._accessoryLabelFactory == param1)
         {
            return;
         }
         this._accessoryLabelFactory = param1;
         this._accessoryIsFromItem = false;
         this.replaceAccessory(null);
         this.invalidate("data");
      }
      
      public function get accessoryLabelProperties() : Object
      {
         if(!this._accessoryLabelProperties)
         {
            this._accessoryLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._accessoryLabelProperties;
      }
      
      public function set accessoryLabelProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._accessoryLabelProperties == param1)
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
         if(this._accessoryLabelProperties)
         {
            this._accessoryLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._accessoryLabelProperties = PropertyProxy(param1);
         if(this._accessoryLabelProperties)
         {
            this._accessoryLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get skinLoaderFactory() : Function
      {
         return this._skinLoaderFactory;
      }
      
      public function set skinLoaderFactory(param1:Function) : void
      {
         if(this._skinLoaderFactory == param1)
         {
            return;
         }
         this._skinLoaderFactory = param1;
         this._skinIsFromItem = false;
         this.replaceSkin(null);
         this.invalidate("data");
      }
      
      override public function dispose() : void
      {
         if(this._iconIsFromItem)
         {
            this.replaceIcon(null);
         }
         if(this._accessoryIsFromItem)
         {
            this.replaceAccessory(null);
         }
         if(this._skinIsFromItem)
         {
            this.replaceSkin(null);
         }
         if(this._stateDelayTimer)
         {
            if(this._stateDelayTimer.running)
            {
               this._stateDelayTimer.stop();
            }
            this._stateDelayTimer.removeEventListener("timerComplete",stateDelayTimer_timerCompleteHandler);
            this._stateDelayTimer = null;
         }
         super.dispose();
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
      
      protected function itemToIcon(param1:Object) : DisplayObject
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(this._iconSourceFunction != null)
         {
            _loc2_ = this._iconSourceFunction(param1);
            this.refreshIconSource(_loc2_);
            return this.iconLoader;
         }
         if(this._iconSourceField != null && param1 && param1.hasOwnProperty(this._iconSourceField))
         {
            _loc2_ = param1[this._iconSourceField];
            this.refreshIconSource(_loc2_);
            return this.iconLoader;
         }
         if(this._iconLabelFunction != null)
         {
            _loc3_ = this._iconLabelFunction(param1);
            if(_loc3_ is String)
            {
               this.refreshIconLabel(_loc3_ as String);
            }
            else
            {
               this.refreshIconLabel(_loc3_.toString());
            }
            return DisplayObject(this.iconLabel);
         }
         if(this._iconLabelField != null && param1 && param1.hasOwnProperty(this._iconLabelField))
         {
            _loc3_ = param1[this._iconLabelField];
            if(_loc3_ is String)
            {
               this.refreshIconLabel(_loc3_ as String);
            }
            else
            {
               this.refreshIconLabel(_loc3_.toString());
            }
            return DisplayObject(this.iconLabel);
         }
         if(this._iconFunction != null)
         {
            return this._iconFunction(param1) as DisplayObject;
         }
         if(this._iconField != null && param1 && param1.hasOwnProperty(this._iconField))
         {
            return param1[this._iconField] as DisplayObject;
         }
         return null;
      }
      
      protected function itemToAccessory(param1:Object) : DisplayObject
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(this._accessorySourceFunction != null)
         {
            _loc2_ = this._accessorySourceFunction(param1);
            this.refreshAccessorySource(_loc2_);
            return this.accessoryLoader;
         }
         if(this._accessorySourceField != null && param1 && param1.hasOwnProperty(this._accessorySourceField))
         {
            _loc2_ = param1[this._accessorySourceField];
            this.refreshAccessorySource(_loc2_);
            return this.accessoryLoader;
         }
         if(this._accessoryLabelFunction != null)
         {
            _loc3_ = this._accessoryLabelFunction(param1);
            if(_loc3_ is String)
            {
               this.refreshAccessoryLabel(_loc3_ as String);
            }
            else
            {
               this.refreshAccessoryLabel(_loc3_.toString());
            }
            return DisplayObject(this.accessoryLabel);
         }
         if(this._accessoryLabelField != null && param1 && param1.hasOwnProperty(this._accessoryLabelField))
         {
            _loc3_ = param1[this._accessoryLabelField];
            if(_loc3_ is String)
            {
               this.refreshAccessoryLabel(_loc3_ as String);
            }
            else
            {
               this.refreshAccessoryLabel(_loc3_.toString());
            }
            return DisplayObject(this.accessoryLabel);
         }
         if(this._accessoryFunction != null)
         {
            return this._accessoryFunction(param1) as DisplayObject;
         }
         if(this._accessoryField != null && param1 && param1.hasOwnProperty(this._accessoryField))
         {
            return param1[this._accessoryField] as DisplayObject;
         }
         return null;
      }
      
      protected function itemToSkin(param1:Object) : DisplayObject
      {
         var _loc2_:Object = null;
         if(this._skinSourceFunction != null)
         {
            _loc2_ = this._skinSourceFunction(param1);
            this.refreshSkinSource(_loc2_);
            return this.skinLoader;
         }
         if(this._skinSourceField != null && param1 && param1.hasOwnProperty(this._skinSourceField))
         {
            _loc2_ = param1[this._skinSourceField];
            this.refreshSkinSource(_loc2_);
            return this.skinLoader;
         }
         if(this._skinFunction != null)
         {
            return this._skinFunction(param1) as DisplayObject;
         }
         if(this._skinField != null && param1 && param1.hasOwnProperty(this._skinField))
         {
            return param1[this._skinField] as DisplayObject;
         }
         return null;
      }
      
      protected function itemToSelectable(param1:Object) : Boolean
      {
         if(this._selectableFunction != null)
         {
            return this._selectableFunction(param1) as Boolean;
         }
         if(this._selectableField != null && param1 && param1.hasOwnProperty(this._selectableField))
         {
            return param1[this._selectableField] as Boolean;
         }
         return true;
      }
      
      protected function itemToEnabled(param1:Object) : Boolean
      {
         if(this._enabledFunction != null)
         {
            return this._enabledFunction(param1) as Boolean;
         }
         if(this._enabledField != null && param1 && param1.hasOwnProperty(this._enabledField))
         {
            return param1[this._enabledField] as Boolean;
         }
         return true;
      }
      
      public function getAccessoryForState(param1:String) : DisplayObject
      {
         return this._stateToAccessory[param1] as DisplayObject;
      }
      
      public function setAccessoryForState(param1:String, param2:DisplayObject) : void
      {
         if(param2 !== null)
         {
            this._stateToAccessory[param1] = param2;
         }
         else
         {
            delete this._stateToAccessory[param1];
         }
         this.invalidate("styles");
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("state");
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc3_:Boolean = this.isInvalid("styles");
         if(_loc2_)
         {
            this.commitData();
         }
         if(_loc1_ || _loc2_ || _loc3_)
         {
            this.refreshAccessory();
         }
         super.draw();
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc4_:* = this._explicitWidth !== this._explicitWidth;
         var _loc9_:* = this._explicitHeight !== this._explicitHeight;
         var _loc5_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc11_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc4_ && !_loc9_ && !_loc5_ && !_loc11_)
         {
            return false;
         }
         var _loc8_:Boolean = this._ignoreAccessoryResizes;
         this._ignoreAccessoryResizes = true;
         var _loc1_:ITextRenderer = null;
         if(this._label !== null && this.labelTextRenderer)
         {
            _loc1_ = this.labelTextRenderer;
            this.refreshMaxLabelSize(true);
            this.labelTextRenderer.measureText(HELPER_POINT);
         }
         resetFluidChildDimensionsForMeasurement(this.currentSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitSkinWidth,this._explicitSkinHeight,this._explicitSkinMinWidth,this._explicitSkinMinHeight,this._explicitSkinMaxWidth,this._explicitSkinMaxHeight);
         var _loc10_:IMeasureDisplayObject = this.currentSkin as IMeasureDisplayObject;
         var _loc3_:Number = this._explicitWidth;
         if(_loc4_)
         {
            if(_loc1_ !== null)
            {
               _loc3_ = HELPER_POINT.x;
            }
            else
            {
               _loc3_ = 0;
            }
            if(this._layoutOrder === "labelAccessoryIcon")
            {
               _loc3_ = this.addAccessoryWidth(_loc3_);
               _loc3_ = this.addIconWidth(_loc3_);
            }
            else
            {
               _loc3_ = this.addIconWidth(_loc3_);
               _loc3_ = this.addAccessoryWidth(_loc3_);
            }
            _loc3_ += this._paddingLeft + this._paddingRight;
            if(this.currentSkin !== null && this.currentSkin.width > _loc3_)
            {
               _loc3_ = this.currentSkin.width;
            }
         }
         var _loc6_:Number = this._explicitHeight;
         if(_loc9_)
         {
            if(_loc1_ !== null)
            {
               _loc6_ = HELPER_POINT.y;
            }
            else
            {
               _loc6_ = 0;
            }
            if(this._layoutOrder === "labelAccessoryIcon")
            {
               _loc6_ = this.addAccessoryHeight(_loc6_);
               _loc6_ = this.addIconHeight(_loc6_);
            }
            else
            {
               _loc6_ = this.addIconHeight(_loc6_);
               _loc6_ = this.addAccessoryHeight(_loc6_);
            }
            _loc6_ += this._paddingTop + this._paddingBottom;
            if(this.currentSkin !== null && this.currentSkin.height > _loc6_)
            {
               _loc6_ = this.currentSkin.height;
            }
         }
         var _loc2_:Number = this._explicitMinWidth;
         if(_loc5_)
         {
            if(_loc1_ !== null)
            {
               _loc2_ = HELPER_POINT.x;
            }
            else
            {
               _loc2_ = 0;
            }
            if(this._layoutOrder === "labelAccessoryIcon")
            {
               _loc2_ = this.addAccessoryWidth(_loc2_);
               _loc2_ = this.addIconWidth(_loc2_);
            }
            else
            {
               _loc2_ = this.addIconWidth(_loc2_);
               _loc2_ = this.addAccessoryWidth(_loc2_);
            }
            _loc2_ += this._paddingLeft + this._paddingRight;
            switch(_loc10_)
            {
               default:
                  if(_loc10_.minWidth > _loc2_)
                  {
                     _loc2_ = _loc10_.minWidth;
                  }
                  break;
               case null:
                  if(this._explicitSkinMinWidth > _loc2_)
                  {
                     _loc2_ = this._explicitSkinMinWidth;
                  }
                  break;
               case null:
            }
         }
         var _loc7_:Number = this._explicitMinHeight;
         if(_loc11_)
         {
            if(_loc1_ !== null)
            {
               _loc7_ = HELPER_POINT.y;
            }
            else
            {
               _loc7_ = 0;
            }
            if(this._layoutOrder === "labelAccessoryIcon")
            {
               _loc7_ = this.addAccessoryHeight(_loc7_);
               _loc7_ = this.addIconHeight(_loc7_);
            }
            else
            {
               _loc7_ = this.addIconHeight(_loc7_);
               _loc7_ = this.addAccessoryHeight(_loc7_);
            }
            _loc7_ += this._paddingTop + this._paddingBottom;
            switch(_loc10_)
            {
               default:
                  if(_loc10_.minHeight > _loc7_)
                  {
                     _loc7_ = _loc10_.minHeight;
                  }
                  break;
               case null:
                  if(this._explicitSkinMinHeight > _loc7_)
                  {
                     _loc7_ = this._explicitSkinMinHeight;
                  }
                  break;
               case null:
            }
         }
         this._ignoreAccessoryResizes = _loc8_;
         return this.saveMeasurements(_loc3_,_loc6_,_loc2_,_loc7_);
      }
      
      override protected function changeState(param1:String) : void
      {
         if(this._isEnabled && !this._isToggle && (!this.isSelectableWithoutToggle || this._itemHasSelectable && !this.itemToSelectable(this._data)))
         {
            param1 = "up";
         }
         if(this._useStateDelayTimer)
         {
            if(this._stateDelayTimer && this._stateDelayTimer.running)
            {
               this._delayedCurrentState = param1;
               return;
            }
            if(param1 == "down")
            {
               if(this._currentState === param1)
               {
                  return;
               }
               this._delayedCurrentState = param1;
               if(this._stateDelayTimer)
               {
                  this._stateDelayTimer.reset();
               }
               else
               {
                  this._stateDelayTimer = new Timer(DOWN_STATE_DELAY_MS,1);
                  this._stateDelayTimer.addEventListener("timerComplete",stateDelayTimer_timerCompleteHandler);
               }
               this._stateDelayTimer.start();
               return;
            }
         }
         super.changeState(param1);
      }
      
      protected function addIconWidth(param1:Number) : Number
      {
         var _loc4_:Number = NaN;
         if(!this.currentIcon)
         {
            return param1;
         }
         var _loc3_:Number = this.currentIcon.width;
         if(_loc3_ !== _loc3_)
         {
            return param1;
         }
         var _loc2_:* = param1 === param1;
         if(!_loc2_)
         {
            param1 = 0;
         }
         if(this._iconPosition == "left" || this._iconPosition == "leftBaseline" || this._iconPosition == "right" || this._iconPosition == "rightBaseline")
         {
            if(_loc2_)
            {
               _loc4_ = this._gap;
               if(this._gap == Infinity)
               {
                  _loc4_ = this._minGap;
               }
               param1 += _loc4_;
            }
            param1 += _loc3_;
         }
         else if(_loc3_ > param1)
         {
            param1 = _loc3_;
         }
         return param1;
      }
      
      protected function addAccessoryWidth(param1:Number) : Number
      {
         var _loc4_:Number = NaN;
         if(!this.currentAccessory)
         {
            return param1;
         }
         var _loc3_:Number = this.currentAccessory.width;
         if(_loc3_ !== _loc3_)
         {
            return param1;
         }
         var _loc2_:* = param1 === param1;
         if(!_loc2_)
         {
            param1 = 0;
         }
         if(this._accessoryPosition == "left" || this._accessoryPosition == "right")
         {
            if(_loc2_)
            {
               _loc4_ = this._accessoryGap;
               if(this._accessoryGap !== this._accessoryGap)
               {
                  _loc4_ = this._gap;
               }
               if(_loc4_ == Infinity)
               {
                  if(this._minAccessoryGap !== this._minAccessoryGap)
                  {
                     _loc4_ = this._minGap;
                  }
                  else
                  {
                     _loc4_ = this._minAccessoryGap;
                  }
               }
               param1 += _loc4_;
            }
            param1 += _loc3_;
         }
         else if(_loc3_ > param1)
         {
            param1 = _loc3_;
         }
         return param1;
      }
      
      protected function addIconHeight(param1:Number) : Number
      {
         var _loc4_:Number = NaN;
         if(this.currentIcon === null)
         {
            return param1;
         }
         var _loc3_:Number = this.currentIcon.height;
         if(_loc3_ !== _loc3_)
         {
            return param1;
         }
         var _loc2_:* = param1 === param1;
         if(!_loc2_)
         {
            param1 = 0;
         }
         if(this._iconPosition === "top" || this._iconPosition === "bottom")
         {
            if(_loc2_)
            {
               _loc4_ = this._gap;
               if(this._gap === Infinity)
               {
                  _loc4_ = this._minGap;
               }
               param1 += _loc4_;
            }
            param1 += _loc3_;
         }
         else if(_loc3_ > param1)
         {
            param1 = _loc3_;
         }
         return param1;
      }
      
      protected function addAccessoryHeight(param1:Number) : Number
      {
         var _loc3_:Number = NaN;
         if(this.currentAccessory === null)
         {
            return param1;
         }
         var _loc4_:Number = this.currentAccessory.height;
         if(_loc4_ !== _loc4_)
         {
            return param1;
         }
         var _loc2_:* = param1 === param1;
         if(!_loc2_)
         {
            param1 = 0;
         }
         if(this._accessoryPosition === "top" || this._accessoryPosition === "bottom")
         {
            if(_loc2_)
            {
               _loc3_ = this._accessoryGap;
               if(this._accessoryGap !== this._accessoryGap)
               {
                  _loc3_ = this._gap;
               }
               if(_loc3_ === Infinity)
               {
                  if(this._minAccessoryGap !== this._minAccessoryGap)
                  {
                     _loc3_ = this._minGap;
                  }
                  else
                  {
                     _loc3_ = this._minAccessoryGap;
                  }
               }
               param1 += _loc3_;
            }
            param1 += _loc4_;
         }
         else if(_loc4_ > param1)
         {
            param1 = _loc4_;
         }
         return param1;
      }
      
      protected function commitData() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc3_:DisplayObject = null;
         var _loc2_:DisplayObject = null;
         if(this._data !== null && this._owner)
         {
            if(this._itemHasLabel)
            {
               this._label = this.itemToLabel(this._data);
            }
            if(this._itemHasSkin)
            {
               _loc1_ = this.itemToSkin(this._data);
               this._skinIsFromItem = _loc1_ != null;
               this.replaceSkin(_loc1_);
            }
            else if(this._skinIsFromItem)
            {
               this._skinIsFromItem = false;
               this.replaceSkin(null);
            }
            if(this._itemHasIcon)
            {
               _loc3_ = this.itemToIcon(this._data);
               this._iconIsFromItem = _loc3_ != null;
               this.replaceIcon(_loc3_);
            }
            else if(this._iconIsFromItem)
            {
               this._iconIsFromItem = false;
               this.replaceIcon(null);
            }
            if(this._itemHasAccessory)
            {
               _loc2_ = this.itemToAccessory(this._data);
               this._accessoryIsFromItem = _loc2_ != null;
               this.replaceAccessory(_loc2_);
            }
            else if(this._accessoryIsFromItem)
            {
               this._accessoryIsFromItem = false;
               this.replaceAccessory(null);
            }
            if(this._itemHasSelectable)
            {
               this._isToggle = this._explicitIsToggle && this.itemToSelectable(this._data);
            }
            else
            {
               this._isToggle = this._explicitIsToggle;
            }
            if(this._itemHasEnabled)
            {
               this.refreshIsEnabled(this._explicitIsEnabled && this.itemToEnabled(this._data));
            }
            else
            {
               this.refreshIsEnabled(this._explicitIsEnabled);
            }
         }
         else
         {
            if(this._itemHasLabel)
            {
               this._label = "";
            }
            if(this._itemHasIcon || this._iconIsFromItem)
            {
               this._iconIsFromItem = false;
               this.replaceIcon(null);
            }
            if(this._itemHasSkin || this._skinIsFromItem)
            {
               this._skinIsFromItem = false;
               this.replaceSkin(null);
            }
            if(this._itemHasAccessory || this._accessoryIsFromItem)
            {
               this._accessoryIsFromItem = false;
               this.replaceAccessory(null);
            }
            if(this._itemHasSelectable)
            {
               this._isToggle = this._explicitIsToggle;
            }
            if(this._itemHasEnabled)
            {
               this.refreshIsEnabled(this._explicitIsEnabled);
            }
         }
      }
      
      protected function refreshIsEnabled(param1:Boolean) : void
      {
         if(this._isEnabled == param1)
         {
            return;
         }
         this._isEnabled = param1;
         if(!this._isEnabled)
         {
            this.touchable = false;
            this._currentState = "disabled";
            this.touchPointID = -1;
         }
         else
         {
            if(this._currentState == "disabled")
            {
               this._currentState = "up";
            }
            this.touchable = true;
         }
         this.setInvalidationFlag("state");
         this.dispatchEventWith("stageChange");
      }
      
      protected function replaceIcon(param1:DisplayObject) : void
      {
         if(this.iconLoader && this.iconLoader != param1)
         {
            this.iconLoader.removeEventListener("complete",loader_completeOrErrorHandler);
            this.iconLoader.removeEventListener("error",loader_completeOrErrorHandler);
            this.iconLoader.dispose();
            this.iconLoader = null;
         }
         if(this.iconLabel && this.iconLabel != param1)
         {
            this.iconLabel.dispose();
            this.iconLabel = null;
         }
         if(this._itemHasIcon && this.currentIcon && this.currentIcon != param1 && this.currentIcon.parent == this)
         {
            this.currentIcon.removeFromParent(false);
            this.currentIcon = null;
         }
         if(this._defaultIcon !== param1)
         {
            this._defaultIcon = param1;
            this._stateToIconFunction = null;
            this.setInvalidationFlag("styles");
         }
         if(this.iconLoader)
         {
            this.iconLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
         }
      }
      
      protected function replaceAccessory(param1:DisplayObject) : void
      {
         if(this.accessoryLoader && this.accessoryLoader != param1)
         {
            this.accessoryLoader.removeEventListener("complete",loader_completeOrErrorHandler);
            this.accessoryLoader.removeEventListener("error",loader_completeOrErrorHandler);
            this.accessoryLoader.dispose();
            this.accessoryLoader = null;
         }
         if(this.accessoryLabel && this.accessoryLabel != param1)
         {
            this.accessoryLabel.dispose();
            this.accessoryLabel = null;
         }
         if(this._itemHasAccessory && this.currentAccessory && this.currentAccessory != param1 && this.currentAccessory.parent == this)
         {
            this.currentAccessory.removeFromParent(false);
            this.currentAccessory = null;
         }
         if(this._defaultAccessory !== param1)
         {
            this._defaultAccessory = param1;
            this._stateToAccessoryFunction = null;
            this.setInvalidationFlag("styles");
         }
         if(this.accessoryLoader)
         {
            this.accessoryLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
         }
      }
      
      protected function replaceSkin(param1:DisplayObject) : void
      {
         if(this.skinLoader && this.skinLoader != param1)
         {
            this.skinLoader.removeEventListener("complete",loader_completeOrErrorHandler);
            this.skinLoader.removeEventListener("error",loader_completeOrErrorHandler);
            this.skinLoader.dispose();
            this.skinLoader = null;
         }
         if(this._itemHasSkin && this.currentSkin && this.currentSkin != param1 && this.currentSkin.parent == this)
         {
            this.currentSkin.removeFromParent(false);
            this.currentSkin = null;
         }
         if(this._defaultSkin !== param1)
         {
            this._defaultSkin = param1;
            this._stateToSkinFunction = null;
            this.setInvalidationFlag("styles");
         }
         if(this.skinLoader)
         {
            this.skinLoader.delayTextureCreation = this._delayTextureCreationOnScroll && this._owner.isScrolling;
         }
      }
      
      override protected function refreshIcon() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc3_:Object = null;
         super.refreshIcon();
         if(this.iconLabel)
         {
            _loc1_ = DisplayObject(this.iconLabel);
            for(var _loc2_ in this._iconLabelProperties)
            {
               _loc3_ = this._iconLabelProperties[_loc2_];
               _loc1_[_loc2_] = _loc3_;
            }
         }
      }
      
      protected function refreshAccessory() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc4_:Object = null;
         var _loc3_:DisplayObject = this.currentAccessory;
         this.currentAccessory = this.getCurrentAccessory();
         if(this.currentAccessory is IFeathersControl)
         {
            IFeathersControl(this.currentAccessory).isEnabled = this._isEnabled;
         }
         if(this.currentAccessory != _loc3_)
         {
            if(_loc3_)
            {
               if(_loc3_ is IStateObserver)
               {
                  IStateObserver(_loc3_).stateContext = null;
               }
               if(_loc3_ is IFeathersControl)
               {
                  IFeathersControl(_loc3_).removeEventListener("resize",accessory_resizeHandler);
                  IFeathersControl(_loc3_).removeEventListener("touch",accessory_touchHandler);
               }
               this.removeChild(_loc3_,false);
            }
            if(this.currentAccessory)
            {
               if(this.currentAccessory is IStateObserver)
               {
                  IStateObserver(this.currentAccessory).stateContext = this;
               }
               this.addChild(this.currentAccessory);
               if(this.currentAccessory is IFeathersControl)
               {
                  IFeathersControl(this.currentAccessory).addEventListener("resize",accessory_resizeHandler);
                  IFeathersControl(this.currentAccessory).addEventListener("touch",accessory_touchHandler);
               }
            }
         }
         if(this.accessoryLabel)
         {
            _loc1_ = DisplayObject(this.accessoryLabel);
            for(var _loc2_ in this._accessoryLabelProperties)
            {
               _loc4_ = this._accessoryLabelProperties[_loc2_];
               _loc1_[_loc2_] = _loc4_;
            }
         }
      }
      
      protected function getCurrentAccessory() : DisplayObject
      {
         if(this._stateToAccessoryFunction !== null)
         {
            return DisplayObject(this._stateToAccessoryFunction(this,this._currentState,this.currentAccessory));
         }
         var _loc1_:DisplayObject = this._stateToAccessory[this.currentState] as DisplayObject;
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         return this._defaultAccessory;
      }
      
      protected function refreshIconSource(param1:Object) : void
      {
         if(!this.iconLoader)
         {
            this.iconLoader = this._iconLoaderFactory();
            this.iconLoader.addEventListener("complete",loader_completeOrErrorHandler);
            this.iconLoader.addEventListener("error",loader_completeOrErrorHandler);
         }
         this.iconLoader.source = param1;
      }
      
      protected function refreshIconLabel(param1:String) : void
      {
         var _loc2_:Function = null;
         var _loc3_:String = null;
         if(!this.iconLabel)
         {
            _loc2_ = this._iconLabelFactory != null ? this._iconLabelFactory : FeathersControl.defaultTextRendererFactory;
            this.iconLabel = ITextRenderer(_loc2_());
            if(this.iconLabel is IStateObserver)
            {
               IStateObserver(this.iconLabel).stateContext = this;
            }
            _loc3_ = this._customIconLabelStyleName != null ? this._customIconLabelStyleName : this.iconLabelStyleName;
            this.iconLabel.styleNameList.add(_loc3_);
         }
         this.iconLabel.text = param1;
      }
      
      protected function refreshAccessorySource(param1:Object) : void
      {
         if(!this.accessoryLoader)
         {
            this.accessoryLoader = this._accessoryLoaderFactory();
            this.accessoryLoader.addEventListener("complete",loader_completeOrErrorHandler);
            this.accessoryLoader.addEventListener("error",loader_completeOrErrorHandler);
         }
         this.accessoryLoader.source = param1;
      }
      
      protected function refreshAccessoryLabel(param1:String) : void
      {
         var _loc2_:Function = null;
         var _loc3_:String = null;
         if(!this.accessoryLabel)
         {
            _loc2_ = this._accessoryLabelFactory != null ? this._accessoryLabelFactory : FeathersControl.defaultTextRendererFactory;
            this.accessoryLabel = ITextRenderer(_loc2_());
            if(this.accessoryLabel is IStateObserver)
            {
               IStateObserver(this.accessoryLabel).stateContext = this;
            }
            _loc3_ = this._customAccessoryLabelStyleName != null ? this._customAccessoryLabelStyleName : this.accessoryLabelStyleName;
            this.accessoryLabel.styleNameList.add(_loc3_);
         }
         this.accessoryLabel.text = param1;
      }
      
      protected function refreshSkinSource(param1:Object) : void
      {
         if(!this.skinLoader)
         {
            this.skinLoader = this._skinLoaderFactory();
            this.skinLoader.addEventListener("complete",loader_completeOrErrorHandler);
            this.skinLoader.addEventListener("error",loader_completeOrErrorHandler);
         }
         this.skinLoader.source = param1;
      }
      
      override protected function layoutContent() : void
      {
         var _loc7_:String = null;
         var _loc5_:Boolean = this._ignoreAccessoryResizes;
         this._ignoreAccessoryResizes = true;
         var _loc6_:Boolean = this._ignoreIconResizes;
         this._ignoreIconResizes = true;
         this.refreshMaxLabelSize(false);
         var _loc1_:DisplayObject = null;
         if(this._label !== null && this.labelTextRenderer)
         {
            this.labelTextRenderer.validate();
            _loc1_ = DisplayObject(this.labelTextRenderer);
         }
         var _loc2_:Boolean = this.currentIcon && this._iconPosition != "manual";
         var _loc3_:Boolean = this.currentAccessory && this._accessoryPosition != "manual";
         var _loc4_:Number = this._accessoryGap;
         if(_loc4_ !== _loc4_)
         {
            _loc4_ = this._gap;
         }
         if(_loc1_ && _loc2_ && _loc3_)
         {
            this.positionSingleChild(_loc1_);
            if(this._layoutOrder == "labelAccessoryIcon")
            {
               this.positionRelativeToOthers(this.currentAccessory,_loc1_,null,this._accessoryPosition,_loc4_,null,0);
               if((_loc7_ = this._iconPosition) == "leftBaseline")
               {
                  _loc7_ = "left";
               }
               else if(_loc7_ == "rightBaseline")
               {
                  _loc7_ = "right";
               }
               this.positionRelativeToOthers(this.currentIcon,_loc1_,this.currentAccessory,_loc7_,this._gap,this._accessoryPosition,_loc4_);
            }
            else
            {
               this.positionLabelAndIcon();
               this.positionRelativeToOthers(this.currentAccessory,_loc1_,this.currentIcon,this._accessoryPosition,_loc4_,this._iconPosition,this._gap);
            }
         }
         else if(_loc1_)
         {
            this.positionSingleChild(_loc1_);
            if(_loc2_)
            {
               this.positionLabelAndIcon();
            }
            else if(_loc3_)
            {
               this.positionRelativeToOthers(this.currentAccessory,_loc1_,null,this._accessoryPosition,_loc4_,null,0);
            }
         }
         else if(_loc2_)
         {
            this.positionSingleChild(this.currentIcon);
            if(_loc3_)
            {
               this.positionRelativeToOthers(this.currentAccessory,this.currentIcon,null,this._accessoryPosition,_loc4_,null,0);
            }
         }
         else if(_loc3_)
         {
            this.positionSingleChild(this.currentAccessory);
         }
         if(this.currentAccessory)
         {
            if(!_loc3_)
            {
               this.currentAccessory.x = this._paddingLeft;
               this.currentAccessory.y = this._paddingTop;
            }
            this.currentAccessory.x += this._accessoryOffsetX;
            this.currentAccessory.y += this._accessoryOffsetY;
         }
         if(this.currentIcon)
         {
            if(!_loc2_)
            {
               this.currentIcon.x = this._paddingLeft;
               this.currentIcon.y = this._paddingTop;
            }
            this.currentIcon.x += this._iconOffsetX;
            this.currentIcon.y += this._iconOffsetY;
         }
         if(_loc1_)
         {
            this.labelTextRenderer.x += this._labelOffsetX;
            this.labelTextRenderer.y += this._labelOffsetY;
         }
         this._ignoreIconResizes = _loc6_;
         this._ignoreAccessoryResizes = _loc5_;
      }
      
      override protected function refreshMaxLabelSize(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc3_:Number = this.actualWidth;
         if(param1)
         {
            _loc3_ = this._explicitWidth;
            if(_loc3_ !== _loc3_)
            {
               _loc3_ = this._explicitMaxWidth;
            }
         }
         _loc3_ -= this._paddingLeft + this._paddingRight;
         var _loc7_:Number = this.actualHeight;
         if(param1)
         {
            _loc7_ = this._explicitHeight;
            if(_loc7_ !== _loc7_)
            {
               _loc7_ = this._explicitMaxHeight;
            }
         }
         _loc7_ -= this._paddingTop + this._paddingBottom;
         var _loc8_:Number;
         if((_loc8_ = this._gap) == Infinity)
         {
            _loc8_ = this._minGap;
         }
         var _loc6_:Number = this._accessoryGap;
         if(_loc6_ !== _loc6_)
         {
            _loc6_ = this._gap;
         }
         if(_loc6_ == Infinity)
         {
            _loc6_ = this._minAccessoryGap;
            if(_loc6_ !== _loc6_)
            {
               _loc6_ = this._minGap;
            }
         }
         var _loc9_:Boolean = this.currentIcon && (this._iconPosition == "left" || this._iconPosition == "leftBaseline" || this._iconPosition == "right" || this._iconPosition == "rightBaseline");
         var _loc5_:Boolean = this.currentIcon && (this._iconPosition == "top" || this._iconPosition == "bottom");
         var _loc10_:Boolean = this.currentAccessory && (this._accessoryPosition == "left" || this._accessoryPosition == "right");
         var _loc4_:Boolean = this.currentAccessory && (this._accessoryPosition == "top" || this._accessoryPosition == "bottom");
         if(this.accessoryLabel)
         {
            _loc2_ = _loc9_ && (_loc10_ || this._layoutOrder === "labelAccessoryIcon");
            if(this.iconLabel)
            {
               this.iconLabel.maxWidth = _loc3_ - _loc8_;
               if(this.iconLabel.maxWidth < 0)
               {
                  this.iconLabel.maxWidth = 0;
               }
            }
            if(this.currentIcon is IValidating)
            {
               IValidating(this.currentIcon).validate();
            }
            if(_loc2_)
            {
               _loc3_ -= this.currentIcon.width + _loc8_;
            }
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            this.accessoryLabel.maxWidth = _loc3_;
            this.accessoryLabel.maxHeight = _loc7_;
            if(_loc9_ && this.currentIcon && !_loc2_)
            {
               _loc3_ -= this.currentIcon.width + _loc8_;
            }
            if(this.currentAccessory is IValidating)
            {
               IValidating(this.currentAccessory).validate();
            }
            if(_loc10_)
            {
               _loc3_ -= this.currentAccessory.width + _loc6_;
            }
            if(_loc4_)
            {
               _loc7_ -= this.currentAccessory.height + _loc6_;
            }
         }
         else if(this.iconLabel)
         {
            _loc11_ = _loc10_ && (_loc9_ || this._layoutOrder === "labelIconAccessory");
            if(this.currentAccessory is IValidating)
            {
               IValidating(this.currentAccessory).validate();
            }
            if(_loc11_)
            {
               _loc3_ -= _loc6_ + this.currentAccessory.width;
            }
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            this.iconLabel.maxWidth = _loc3_;
            this.iconLabel.maxHeight = _loc7_;
            if(_loc10_ && this.currentAccessory && !_loc11_)
            {
               _loc3_ -= _loc6_ + this.currentAccessory.width;
            }
            if(this.currentIcon is IValidating)
            {
               IValidating(this.currentIcon).validate();
            }
            if(_loc9_)
            {
               _loc3_ -= this.currentIcon.width + _loc8_;
            }
            if(_loc5_)
            {
               _loc7_ -= this.currentIcon.height + _loc8_;
            }
         }
         else
         {
            if(this.currentIcon is IValidating)
            {
               IValidating(this.currentIcon).validate();
            }
            if(_loc9_)
            {
               _loc3_ -= _loc8_ + this.currentIcon.width;
            }
            if(_loc5_)
            {
               _loc7_ -= _loc8_ + this.currentIcon.height;
            }
            if(this.currentAccessory is IValidating)
            {
               IValidating(this.currentAccessory).validate();
            }
            if(_loc10_)
            {
               _loc3_ -= _loc6_ + this.currentAccessory.width;
            }
            if(_loc4_)
            {
               _loc7_ -= _loc6_ + this.currentAccessory.height;
            }
         }
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
         }
         if(this.labelTextRenderer)
         {
            this.labelTextRenderer.maxWidth = _loc3_;
            this.labelTextRenderer.maxHeight = _loc7_;
         }
      }
      
      protected function positionRelativeToOthers(param1:DisplayObject, param2:DisplayObject, param3:DisplayObject, param4:String, param5:Number, param6:String, param7:Number) : void
      {
         var _loc15_:Number = !!param3 ? Math.min(param2.x,param3.x) : param2.x;
         var _loc14_:Number = !!param3 ? Math.min(param2.y,param3.y) : param2.y;
         var _loc8_:Number = !!param3 ? Math.max(param2.x + param2.width,param3.x + param3.width) - _loc15_ : param2.width;
         var _loc11_:Number = !!param3 ? Math.max(param2.y + param2.height,param3.y + param3.height) - _loc14_ : param2.height;
         var _loc13_:* = _loc15_;
         var _loc12_:* = _loc14_;
         if(param4 == "top")
         {
            if(param5 == Infinity)
            {
               param1.y = this._paddingTop;
               _loc12_ = this.actualHeight - this._paddingBottom - _loc11_;
            }
            else
            {
               if(this._verticalAlign == "top")
               {
                  _loc12_ += param1.height + param5;
               }
               else if(this._verticalAlign == "middle")
               {
                  _loc12_ += Math.round((param1.height + param5) / 2);
               }
               if(param3)
               {
                  _loc12_ = Math.max(_loc12_,this._paddingTop + param1.height + param5);
               }
               param1.y = _loc12_ - param1.height - param5;
            }
         }
         else if(param4 == "right")
         {
            if(param5 == Infinity)
            {
               _loc13_ = this._paddingLeft;
               param1.x = this.actualWidth - this._paddingRight - param1.width;
            }
            else
            {
               if(this._horizontalAlign == "right")
               {
                  _loc13_ -= param1.width + param5;
               }
               else if(this._horizontalAlign == "center")
               {
                  _loc13_ -= Math.round((param1.width + param5) / 2);
               }
               if(param3)
               {
                  _loc13_ = Math.min(_loc13_,this.actualWidth - this._paddingRight - param1.width - _loc8_ - param5);
               }
               param1.x = _loc13_ + _loc8_ + param5;
            }
         }
         else if(param4 == "bottom")
         {
            if(param5 == Infinity)
            {
               _loc12_ = this._paddingTop;
               param1.y = this.actualHeight - this._paddingBottom - param1.height;
            }
            else
            {
               if(this._verticalAlign == "bottom")
               {
                  _loc12_ -= param1.height + param5;
               }
               else if(this._verticalAlign == "middle")
               {
                  _loc12_ -= Math.round((param1.height + param5) / 2);
               }
               if(param3)
               {
                  _loc12_ = Math.min(_loc12_,this.actualHeight - this._paddingBottom - param1.height - _loc11_ - param5);
               }
               param1.y = _loc12_ + _loc11_ + param5;
            }
         }
         else if(param4 == "left")
         {
            if(param5 == Infinity)
            {
               param1.x = this._paddingLeft;
               _loc13_ = this.actualWidth - this._paddingRight - _loc8_;
            }
            else
            {
               if(this._horizontalAlign == "left")
               {
                  _loc13_ += param5 + param1.width;
               }
               else if(this._horizontalAlign == "center")
               {
                  _loc13_ += Math.round((param5 + param1.width) / 2);
               }
               if(param3)
               {
                  _loc13_ = Math.max(_loc13_,this._paddingLeft + param1.width + param5);
               }
               param1.x = _loc13_ - param5 - param1.width;
            }
         }
         var _loc9_:Number = _loc13_ - _loc15_;
         var _loc10_:Number = _loc12_ - _loc14_;
         if(!param3 || param7 != Infinity || !(param4 == "top" && param6 == "top" || param4 == "right" && param6 == "right" || param4 == "bottom" && param6 == "bottom" || param4 == "left" && param6 == "left"))
         {
            param2.x += _loc9_;
            param2.y += _loc10_;
         }
         if(param3)
         {
            if(param7 != Infinity || !(param4 == "left" && param6 == "right" || param4 == "right" && param6 == "left" || param4 == "top" && param6 == "bottom" || param4 == "bottom" && param6 == "top"))
            {
               param3.x += _loc9_;
               param3.y += _loc10_;
            }
            if(param5 == Infinity && param7 == Infinity)
            {
               if(param4 == "right" && param6 == "left")
               {
                  param2.x = param3.x + Math.round((param1.x - param3.x + param3.width - param2.width) / 2);
               }
               else if(param4 == "left" && param6 == "right")
               {
                  param2.x = param1.x + Math.round((param3.x - param1.x + param1.width - param2.width) / 2);
               }
               else if(param4 == "right" && param6 == "right")
               {
                  param3.x = param2.x + Math.round((param1.x - param2.x + param2.width - param3.width) / 2);
               }
               else if(param4 == "left" && param6 == "left")
               {
                  param3.x = param1.x + Math.round((param2.x - param1.x + param1.width - param3.width) / 2);
               }
               else if(param4 == "bottom" && param6 == "top")
               {
                  param2.y = param3.y + Math.round((param1.y - param3.y + param3.height - param2.height) / 2);
               }
               else if(param4 == "top" && param6 == "bottom")
               {
                  param2.y = param1.y + Math.round((param3.y - param1.y + param1.height - param2.height) / 2);
               }
               else if(param4 == "bottom" && param6 == "bottom")
               {
                  param3.y = param2.y + Math.round((param1.y - param2.y + param2.height - param3.height) / 2);
               }
               else if(param4 == "top" && param6 == "top")
               {
                  param3.y = param1.y + Math.round((param2.y - param1.y + param1.height - param3.height) / 2);
               }
            }
         }
         if(param4 == "left" || param4 == "right")
         {
            if(this._verticalAlign == "top")
            {
               param1.y = this._paddingTop;
            }
            else if(this._verticalAlign == "bottom")
            {
               param1.y = this.actualHeight - this._paddingBottom - param1.height;
            }
            else
            {
               param1.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - param1.height) / 2);
            }
         }
         else if(param4 == "top" || param4 == "bottom")
         {
            if(this._horizontalAlign == "left")
            {
               param1.x = this._paddingLeft;
            }
            else if(this._horizontalAlign == "right")
            {
               param1.x = this.actualWidth - this._paddingRight - param1.width;
            }
            else
            {
               param1.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - param1.width) / 2);
            }
         }
      }
      
      override protected function refreshSelectionEvents() : void
      {
         var _loc1_:* = this._isEnabled && (this._isToggle || this.isSelectableWithoutToggle);
         if(this._itemHasSelectable)
         {
            if(_loc1_)
            {
               _loc1_ = this.itemToSelectable(this._data);
            }
         }
         if(this.accessoryTouchPointID >= 0)
         {
            if(_loc1_)
            {
               _loc1_ = this._isSelectableOnAccessoryTouch;
            }
         }
         this.tapToSelect.isEnabled = _loc1_;
         this.tapToSelect.tapToDeselect = this._isToggle;
         this.keyToSelect.isEnabled = false;
      }
      
      protected function owner_scrollStartHandler(param1:Event) : void
      {
         if(this._delayTextureCreationOnScroll)
         {
            if(this.accessoryLoader)
            {
               this.accessoryLoader.delayTextureCreation = true;
            }
            if(this.iconLoader)
            {
               this.iconLoader.delayTextureCreation = true;
            }
         }
         if(this.touchPointID < 0 && this.accessoryTouchPointID < 0)
         {
            return;
         }
         this.resetTouchState();
         if(this._stateDelayTimer && this._stateDelayTimer.running)
         {
            this._stateDelayTimer.stop();
         }
         this._delayedCurrentState = null;
         if(this.accessoryTouchPointID >= 0)
         {
            this._owner.stopScrolling();
         }
      }
      
      protected function owner_scrollCompleteHandler(param1:Event) : void
      {
         if(this._delayTextureCreationOnScroll)
         {
            if(this.accessoryLoader)
            {
               this.accessoryLoader.delayTextureCreation = false;
            }
            if(this.iconLoader)
            {
               this.iconLoader.delayTextureCreation = false;
            }
         }
      }
      
      protected function itemRenderer_removedFromStageHandler(param1:Event) : void
      {
         this.accessoryTouchPointID = -1;
      }
      
      protected function stateDelayTimer_timerCompleteHandler(param1:TimerEvent) : void
      {
         super.changeState(this._delayedCurrentState);
         this._delayedCurrentState = null;
      }
      
      override protected function basicButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(this.currentAccessory && !this._isSelectableOnAccessoryTouch && this.currentAccessory != this.accessoryLabel && this.currentAccessory != this.accessoryLoader && this.touchPointID < 0)
         {
            _loc2_ = param1.getTouch(this.currentAccessory);
            if(_loc2_)
            {
               this.changeState("up");
               return;
            }
         }
         super.basicButton_touchHandler(param1);
      }
      
      protected function accessory_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
         {
            this.accessoryTouchPointID = -1;
            return;
         }
         if(!this._stopScrollingOnAccessoryTouch || this.currentAccessory === this.accessoryLabel || this.currentAccessory === this.accessoryLoader)
         {
            return;
         }
         if(this.accessoryTouchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.currentAccessory,"ended",this.accessoryTouchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.accessoryTouchPointID = -1;
            this.refreshSelectionEvents();
         }
         else
         {
            _loc2_ = param1.getTouch(this.currentAccessory,"began");
            if(!_loc2_)
            {
               return;
            }
            this.accessoryTouchPointID = _loc2_.id;
            this.refreshSelectionEvents();
         }
      }
      
      protected function accessory_resizeHandler(param1:Event) : void
      {
         if(this._ignoreAccessoryResizes)
         {
            return;
         }
         this.invalidate("size");
      }
      
      protected function loader_completeOrErrorHandler(param1:Event) : void
      {
         this.invalidate("size");
      }
   }
}
