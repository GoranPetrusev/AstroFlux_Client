package feathers.controls
{
   import feathers.core.IGroupedToggle;
   import feathers.core.PropertyProxy;
   import feathers.core.ToggleGroup;
   import feathers.skins.IStyleProvider;
   import feathers.utils.keyboard.KeyToSelect;
   import feathers.utils.touch.TapToSelect;
   import starling.display.DisplayObject;
   
   public class ToggleButton extends Button implements IGroupedToggle
   {
      
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
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var tapToSelect:TapToSelect;
      
      protected var keyToSelect:KeyToSelect;
      
      protected var _isToggle:Boolean = true;
      
      protected var _isSelected:Boolean = false;
      
      protected var _toggleGroup:ToggleGroup;
      
      protected var _defaultSelectedSkin:DisplayObject;
      
      protected var _defaultSelectedLabelProperties:PropertyProxy;
      
      protected var _defaultSelectedIcon:DisplayObject;
      
      public function ToggleButton()
      {
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         if(ToggleButton.globalStyleProvider)
         {
            return ToggleButton.globalStyleProvider;
         }
         return Button.globalStyleProvider;
      }
      
      override public function get currentState() : String
      {
         if(this._isSelected)
         {
            return super.currentState + "AndSelected";
         }
         return super.currentState;
      }
      
      public function get isToggle() : Boolean
      {
         return this._isToggle;
      }
      
      public function set isToggle(param1:Boolean) : void
      {
         if(this._isToggle === param1)
         {
            return;
         }
         this._isToggle = param1;
         this.invalidate("styles");
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         if(this._isSelected === param1)
         {
            return;
         }
         this._isSelected = param1;
         this.invalidate("selected");
         this.invalidate("state");
         this.dispatchEventWith("change");
         this.dispatchEventWith("stageChange");
      }
      
      public function get toggleGroup() : ToggleGroup
      {
         return this._toggleGroup;
      }
      
      public function set toggleGroup(param1:ToggleGroup) : void
      {
         if(this._toggleGroup == param1)
         {
            return;
         }
         if(this._toggleGroup && this._toggleGroup.hasItem(this))
         {
            this._toggleGroup.removeItem(this);
         }
         this._toggleGroup = param1;
         if(this._toggleGroup && !this._toggleGroup.hasItem(this))
         {
            this._toggleGroup.addItem(this);
         }
      }
      
      public function get defaultSelectedSkin() : DisplayObject
      {
         return this._defaultSelectedSkin;
      }
      
      public function set defaultSelectedSkin(param1:DisplayObject) : void
      {
         if(this._defaultSelectedSkin === param1)
         {
            return;
         }
         if(this._defaultSelectedSkin !== null && this.currentSkin === this._defaultSelectedSkin)
         {
            this.removeCurrentSkin(this._defaultSelectedSkin);
            this.currentSkin = null;
         }
         this._defaultSelectedSkin = param1;
         this.invalidate("styles");
      }
      
      public function get selectedUpSkin() : DisplayObject
      {
         return this.getSkinForState("upAndSelected");
      }
      
      public function set selectedUpSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("upAndSelected",param1);
      }
      
      public function get selectedDownSkin() : DisplayObject
      {
         return this.getSkinForState("downAndSelected");
      }
      
      public function set selectedDownSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("downAndSelected",param1);
      }
      
      public function get selectedHoverSkin() : DisplayObject
      {
         return this.getSkinForState("hoverAndSelected");
      }
      
      public function set selectedHoverSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("hoverAndSelected",param1);
      }
      
      public function get selectedDisabledSkin() : DisplayObject
      {
         return this.getSkinForState("disabledAndSelected");
      }
      
      public function set selectedDisabledSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("disabledAndSelected",param1);
      }
      
      public function get defaultSelectedLabelProperties() : Object
      {
         if(this._defaultSelectedLabelProperties === null)
         {
            this._defaultSelectedLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._defaultSelectedLabelProperties;
      }
      
      public function set defaultSelectedLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._defaultSelectedLabelProperties !== null)
         {
            this._defaultSelectedLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._defaultSelectedLabelProperties.defaultSelectedValue = param1;
         if(this._defaultSelectedLabelProperties !== null)
         {
            this._defaultSelectedLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get selectedUpLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["upAndSelected"]);
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._stateToLabelProperties["upAndSelected"] = _loc1_;
         }
         return _loc1_;
      }
      
      public function set selectedUpLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["upAndSelected"]);
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._stateToLabelProperties["upAndSelected"] = param1;
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get selectedDownLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["downAndSelected"]);
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._stateToLabelProperties["downAndSelected"] = _loc1_;
         }
         return _loc1_;
      }
      
      public function set selectedDownLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["downAndSelected"]);
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._stateToLabelProperties["downAndSelected"] = param1;
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get selectedHoverLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["hoverAndSelected"]);
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._stateToLabelProperties["hoverAndSelected"] = _loc1_;
         }
         return _loc1_;
      }
      
      public function set selectedHoverLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["hoverAndSelected"]);
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._stateToLabelProperties["hoverAndSelected"] = param1;
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get selectedDisabledLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["disabledAndSelected"]);
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._stateToLabelProperties["disabledAndSelected"] = _loc1_;
         }
         return _loc1_;
      }
      
      public function set selectedDisabledLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["disabledAndSelected"]);
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._stateToLabelProperties["disabledAndSelected"] = param1;
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get defaultSelectedIcon() : DisplayObject
      {
         return this._defaultSelectedIcon;
      }
      
      public function set defaultSelectedIcon(param1:DisplayObject) : void
      {
         if(this._defaultSelectedIcon === param1)
         {
            return;
         }
         if(this._defaultSelectedIcon !== null && this.currentIcon === this._defaultSelectedIcon)
         {
            this.removeCurrentIcon(this._defaultSelectedIcon);
            this.currentIcon = null;
         }
         this._defaultSelectedIcon = param1;
         this.invalidate("styles");
      }
      
      public function get selectedUpIcon() : DisplayObject
      {
         return this.getIconForState("upAndSelected");
      }
      
      public function set selectedUpIcon(param1:DisplayObject) : void
      {
         this.setIconForState("upAndSelected",param1);
      }
      
      public function get selectedDownIcon() : DisplayObject
      {
         return this.getIconForState("downAndSelected");
      }
      
      public function set selectedDownIcon(param1:DisplayObject) : void
      {
         this.setIconForState("downAndSelected",param1);
      }
      
      public function get selectedHoverIcon() : DisplayObject
      {
         return this.getIconForState("hoverAndSelected");
      }
      
      public function set selectedHoverIcon(param1:DisplayObject) : void
      {
         this.setIconForState("hoverAndSelected",param1);
      }
      
      public function get selectedDisabledIcon() : DisplayObject
      {
         return this.getIconForState("disabledAndSelected");
      }
      
      public function set selectedDisabledIcon(param1:DisplayObject) : void
      {
         this.setIconForState("disabledAndSelected",param1);
      }
      
      override public function dispose() : void
      {
         if(this._defaultSelectedSkin && this._defaultSelectedSkin.parent !== this)
         {
            this._defaultSelectedSkin.dispose();
         }
         if(this._defaultSelectedIcon && this._defaultSelectedIcon.parent !== this)
         {
            this._defaultSelectedIcon.dispose();
         }
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(!this.tapToSelect)
         {
            this.tapToSelect = new TapToSelect(this);
            this.longPress.tapToSelect = this.tapToSelect;
         }
         if(!this.keyToSelect)
         {
            this.keyToSelect = new KeyToSelect(this);
         }
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("state");
         if(_loc2_ || _loc1_)
         {
            this.refreshSelectionEvents();
         }
         super.draw();
      }
      
      override protected function getCurrentSkin() : DisplayObject
      {
         var _loc1_:DisplayObject = null;
         if(this._stateToSkinFunction === null)
         {
            _loc1_ = this._stateToSkin[this.currentState] as DisplayObject;
            if(_loc1_ !== null)
            {
               return _loc1_;
            }
            if(this._isSelected && this._defaultSelectedSkin !== null)
            {
               return this._defaultSelectedSkin;
            }
            return this._defaultSkin;
         }
         return super.getCurrentSkin();
      }
      
      override protected function getCurrentIcon() : DisplayObject
      {
         var _loc1_:DisplayObject = null;
         if(this._stateToIconFunction === null)
         {
            _loc1_ = this._stateToIcon[this.currentState] as DisplayObject;
            if(_loc1_ !== null)
            {
               return _loc1_;
            }
            if(this._isSelected && this._defaultSelectedIcon !== null)
            {
               return this._defaultSelectedIcon;
            }
            return this._defaultIcon;
         }
         return super.getCurrentIcon();
      }
      
      protected function refreshSelectionEvents() : void
      {
         this.tapToSelect.isEnabled = this._isEnabled && this._isToggle;
         this.tapToSelect.tapToDeselect = this._isToggle;
         this.keyToSelect.isEnabled = this._isEnabled && this._isToggle;
         this.keyToSelect.keyToDeselect = this._isToggle;
      }
   }
}
