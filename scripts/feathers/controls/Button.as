package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IStateObserver;
   import feathers.core.ITextBaselineControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.skins.IStyleProvider;
   import feathers.utils.keyboard.KeyToTrigger;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import feathers.utils.touch.LongPress;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   import starling.rendering.Painter;
   
   public class Button extends BasicButton implements IFocusDisplayObject, ITextBaselineControl
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-button-label";
      
      public static const ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON:String = "feathers-call-to-action-button";
      
      public static const ALTERNATE_STYLE_NAME_QUIET_BUTTON:String = "feathers-quiet-button";
      
      public static const ALTERNATE_STYLE_NAME_DANGER_BUTTON:String = "feathers-danger-button";
      
      public static const ALTERNATE_STYLE_NAME_BACK_BUTTON:String = "feathers-back-button";
      
      public static const ALTERNATE_STYLE_NAME_FORWARD_BUTTON:String = "feathers-forward-button";
      
      public static const STATE_UP:String = "up";
      
      public static const STATE_DOWN:String = "down";
      
      public static const STATE_HOVER:String = "hover";
      
      public static const STATE_DISABLED:String = "disabled";
      
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
       
      
      protected var labelStyleName:String = "feathers-button-label";
      
      protected var labelTextRenderer:ITextRenderer;
      
      protected var currentIcon:DisplayObject;
      
      protected var keyToTrigger:KeyToTrigger;
      
      protected var longPress:LongPress;
      
      protected var _scaleMatrix:Matrix;
      
      protected var _label:String = null;
      
      protected var _hasLabelTextRenderer:Boolean = true;
      
      protected var _iconPosition:String = "left";
      
      protected var _gap:Number = 0;
      
      protected var _minGap:Number = 0;
      
      protected var _horizontalAlign:String = "center";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _labelOffsetX:Number = 0;
      
      protected var _labelOffsetY:Number = 0;
      
      protected var _iconOffsetX:Number = 0;
      
      protected var _iconOffsetY:Number = 0;
      
      protected var _stateToIconFunction:Function;
      
      protected var _stateToLabelPropertiesFunction:Function;
      
      protected var _stateToSkinFunction:Function;
      
      protected var _labelFactory:Function;
      
      protected var _customLabelStyleName:String;
      
      protected var _defaultLabelProperties:PropertyProxy;
      
      protected var _stateToLabelProperties:Object;
      
      protected var _defaultIcon:DisplayObject;
      
      protected var _stateToIcon:Object;
      
      protected var _longPressDuration:Number = 0.5;
      
      protected var _isLongPressEnabled:Boolean = false;
      
      protected var _scaleWhenDown:Number = 1;
      
      protected var _scaleWhenHovering:Number = 1;
      
      protected var _ignoreIconResizes:Boolean = false;
      
      public function Button()
      {
         _stateToLabelProperties = {};
         _stateToIcon = {};
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Button.globalStyleProvider;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         if(this._label == param1)
         {
            return;
         }
         this._label = param1;
         this.invalidate("data");
      }
      
      public function get hasLabelTextRenderer() : Boolean
      {
         return this._hasLabelTextRenderer;
      }
      
      public function set hasLabelTextRenderer(param1:Boolean) : void
      {
         if(this._hasLabelTextRenderer == param1)
         {
            return;
         }
         this._hasLabelTextRenderer = param1;
         this.invalidate("textRenderer");
      }
      
      public function get iconPosition() : String
      {
         return this._iconPosition;
      }
      
      public function set iconPosition(param1:String) : void
      {
         if(this._iconPosition == param1)
         {
            return;
         }
         this._iconPosition = param1;
         this.invalidate("styles");
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         if(this._gap == param1)
         {
            return;
         }
         this._gap = param1;
         this.invalidate("styles");
      }
      
      public function get minGap() : Number
      {
         return this._minGap;
      }
      
      public function set minGap(param1:Number) : void
      {
         if(this._minGap == param1)
         {
            return;
         }
         this._minGap = param1;
         this.invalidate("styles");
      }
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this._horizontalAlign == param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this.invalidate("styles");
      }
      
      public function get verticalAlign() : String
      {
         return _verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign == param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this.invalidate("styles");
      }
      
      public function get padding() : Number
      {
         return this._paddingTop;
      }
      
      public function set padding(param1:Number) : void
      {
         this.paddingTop = param1;
         this.paddingRight = param1;
         this.paddingBottom = param1;
         this.paddingLeft = param1;
      }
      
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(param1:Number) : void
      {
         if(this._paddingTop == param1)
         {
            return;
         }
         this._paddingTop = param1;
         this.invalidate("styles");
      }
      
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:Number) : void
      {
         if(this._paddingRight == param1)
         {
            return;
         }
         this._paddingRight = param1;
         this.invalidate("styles");
      }
      
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:Number) : void
      {
         if(this._paddingBottom == param1)
         {
            return;
         }
         this._paddingBottom = param1;
         this.invalidate("styles");
      }
      
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:Number) : void
      {
         if(this._paddingLeft == param1)
         {
            return;
         }
         this._paddingLeft = param1;
         this.invalidate("styles");
      }
      
      public function get labelOffsetX() : Number
      {
         return this._labelOffsetX;
      }
      
      public function set labelOffsetX(param1:Number) : void
      {
         if(this._labelOffsetX == param1)
         {
            return;
         }
         this._labelOffsetX = param1;
         this.invalidate("styles");
      }
      
      public function get labelOffsetY() : Number
      {
         return this._labelOffsetY;
      }
      
      public function set labelOffsetY(param1:Number) : void
      {
         if(this._labelOffsetY == param1)
         {
            return;
         }
         this._labelOffsetY = param1;
         this.invalidate("styles");
      }
      
      public function get iconOffsetX() : Number
      {
         return this._iconOffsetX;
      }
      
      public function set iconOffsetX(param1:Number) : void
      {
         if(this._iconOffsetX == param1)
         {
            return;
         }
         this._iconOffsetX = param1;
         this.invalidate("styles");
      }
      
      public function get iconOffsetY() : Number
      {
         return this._iconOffsetY;
      }
      
      public function set iconOffsetY(param1:Number) : void
      {
         if(this._iconOffsetY == param1)
         {
            return;
         }
         this._iconOffsetY = param1;
         this.invalidate("styles");
      }
      
      public function get stateToIconFunction() : Function
      {
         return this._stateToIconFunction;
      }
      
      public function set stateToIconFunction(param1:Function) : void
      {
         if(this._stateToIconFunction == param1)
         {
            return;
         }
         this._stateToIconFunction = param1;
         this.invalidate("styles");
      }
      
      public function get stateToLabelPropertiesFunction() : Function
      {
         return this._stateToLabelPropertiesFunction;
      }
      
      public function set stateToLabelPropertiesFunction(param1:Function) : void
      {
         if(this._stateToLabelPropertiesFunction == param1)
         {
            return;
         }
         this._stateToLabelPropertiesFunction = param1;
         this.invalidate("styles");
      }
      
      public function get upSkin() : DisplayObject
      {
         return this.getSkinForState("up");
      }
      
      public function set upSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("up",param1);
      }
      
      public function get downSkin() : DisplayObject
      {
         return this.getSkinForState("down");
      }
      
      public function set downSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("down",param1);
      }
      
      public function get hoverSkin() : DisplayObject
      {
         return this.getSkinForState("hover");
      }
      
      public function set hoverSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("hover",param1);
      }
      
      public function get disabledSkin() : DisplayObject
      {
         return this.getSkinForState("disabled");
      }
      
      public function set disabledSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("disabled",param1);
      }
      
      public function get stateToSkinFunction() : Function
      {
         return this._stateToSkinFunction;
      }
      
      public function set stateToSkinFunction(param1:Function) : void
      {
         if(this._stateToSkinFunction == param1)
         {
            return;
         }
         this._stateToSkinFunction = param1;
         this.invalidate("styles");
      }
      
      public function get labelFactory() : Function
      {
         return this._labelFactory;
      }
      
      public function set labelFactory(param1:Function) : void
      {
         if(this._labelFactory == param1)
         {
            return;
         }
         this._labelFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get customLabelStyleName() : String
      {
         return this._customLabelStyleName;
      }
      
      public function set customLabelStyleName(param1:String) : void
      {
         if(this._customLabelStyleName == param1)
         {
            return;
         }
         this._customLabelStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      public function get defaultLabelProperties() : Object
      {
         if(this._defaultLabelProperties === null)
         {
            this._defaultLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._defaultLabelProperties;
      }
      
      public function set defaultLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._defaultLabelProperties !== null)
         {
            this._defaultLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._defaultLabelProperties = PropertyProxy(param1);
         if(this._defaultLabelProperties !== null)
         {
            this._defaultLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get upLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["up"]);
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._stateToLabelProperties["up"] = _loc1_;
         }
         return _loc1_;
      }
      
      public function set upLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["up"]);
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._stateToLabelProperties["up"] = param1;
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get downLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["down"]);
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._stateToLabelProperties["down"] = _loc1_;
         }
         return _loc1_;
      }
      
      public function set downLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["down"]);
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._stateToLabelProperties["down"] = param1;
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get hoverLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["hover"]);
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._stateToLabelProperties["hover"] = _loc1_;
         }
         return _loc1_;
      }
      
      public function set hoverLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["hover"]);
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._stateToLabelProperties["hover"] = param1;
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get disabledLabelProperties() : Object
      {
         var _loc1_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["disabled"]);
         if(!_loc1_)
         {
            _loc1_ = new PropertyProxy(childProperties_onChange);
            this._stateToLabelProperties["disabled"] = _loc1_;
         }
         return _loc1_;
      }
      
      public function set disabledLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         var _loc2_:PropertyProxy = PropertyProxy(this._stateToLabelProperties["disabled"]);
         if(_loc2_)
         {
            _loc2_.removeOnChangeCallback(childProperties_onChange);
         }
         this._stateToLabelProperties["disabled"] = param1;
         if(param1)
         {
            PropertyProxy(param1).addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get defaultIcon() : DisplayObject
      {
         return this._defaultIcon;
      }
      
      public function set defaultIcon(param1:DisplayObject) : void
      {
         if(this._defaultIcon === param1)
         {
            return;
         }
         if(this._defaultIcon !== null && this.currentIcon === this._defaultIcon)
         {
            this.removeCurrentIcon(this._defaultIcon);
            this.currentIcon = null;
         }
         this._defaultIcon = param1;
         this.invalidate("styles");
      }
      
      public function get upIcon() : DisplayObject
      {
         return this.getIconForState("up");
      }
      
      public function set upIcon(param1:DisplayObject) : void
      {
         return this.setIconForState("up",param1);
      }
      
      public function get downIcon() : DisplayObject
      {
         return this.getIconForState("down");
      }
      
      public function set downIcon(param1:DisplayObject) : void
      {
         return this.setIconForState("down",param1);
      }
      
      public function get hoverIcon() : DisplayObject
      {
         return this.getIconForState("hover");
      }
      
      public function set hoverIcon(param1:DisplayObject) : void
      {
         return this.setIconForState("hover",param1);
      }
      
      public function get disabledIcon() : DisplayObject
      {
         return this.getIconForState("disabled");
      }
      
      public function set disabledIcon(param1:DisplayObject) : void
      {
         return this.setIconForState("disabled",param1);
      }
      
      public function get longPressDuration() : Number
      {
         return this._longPressDuration;
      }
      
      public function set longPressDuration(param1:Number) : void
      {
         if(this._longPressDuration === param1)
         {
            return;
         }
         this._longPressDuration = param1;
         this.invalidate("styles");
      }
      
      public function get isLongPressEnabled() : Boolean
      {
         return this._isLongPressEnabled;
      }
      
      public function set isLongPressEnabled(param1:Boolean) : void
      {
         if(this._isLongPressEnabled === param1)
         {
            return;
         }
         this._isLongPressEnabled = param1;
         this.invalidate("styles");
      }
      
      public function get scaleWhenDown() : Number
      {
         return this._scaleWhenDown;
      }
      
      public function set scaleWhenDown(param1:Number) : void
      {
         this._scaleWhenDown = param1;
      }
      
      public function get scaleWhenHovering() : Number
      {
         return this._scaleWhenHovering;
      }
      
      public function set scaleWhenHovering(param1:Number) : void
      {
         this._scaleWhenHovering = param1;
      }
      
      public function get baseline() : Number
      {
         if(!this.labelTextRenderer)
         {
            return this.scaledActualHeight;
         }
         return this.scaleY * (this.labelTextRenderer.y + this.labelTextRenderer.baseline);
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc2_:Number = 1;
         if(this._currentState === "down")
         {
            _loc2_ = this._scaleWhenDown;
         }
         else if(this._currentState === "hover")
         {
            _loc2_ = this._scaleWhenHovering;
         }
         if(_loc2_ !== 1)
         {
            if(this._scaleMatrix === null)
            {
               this._scaleMatrix = new Matrix();
            }
            else
            {
               this._scaleMatrix.identity();
            }
            this._scaleMatrix.translate(Math.round((1 - _loc2_) / 2 * this.actualWidth),Math.round((1 - _loc2_) / 2 * this.actualHeight));
            this._scaleMatrix.scale(_loc2_,_loc2_);
            param1.state.transformModelviewMatrix(this._scaleMatrix);
         }
         super.render(param1);
      }
      
      override public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         if(this._defaultIcon !== null && this._defaultIcon.parent !== this)
         {
            this._defaultIcon.dispose();
         }
         for(var _loc2_ in this._stateToIcon)
         {
            _loc1_ = this._stateToIcon[_loc2_] as DisplayObject;
            if(_loc1_ !== null && _loc1_.parent !== this)
            {
               _loc1_.dispose();
            }
         }
         super.dispose();
      }
      
      public function getIconForState(param1:String) : DisplayObject
      {
         return this._stateToIcon[param1] as DisplayObject;
      }
      
      public function setIconForState(param1:String, param2:DisplayObject) : void
      {
         var _loc3_:DisplayObject = this._stateToIcon[param1] as DisplayObject;
         if(_loc3_ !== null && this.currentIcon === _loc3_)
         {
            this.removeCurrentIcon(_loc3_);
            this.currentIcon = null;
         }
         if(param2 !== null)
         {
            this._stateToIcon[param1] = param2;
         }
         else
         {
            delete this._stateToIcon[param1];
         }
         this.invalidate("styles");
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(!this.keyToTrigger)
         {
            this.keyToTrigger = new KeyToTrigger(this);
         }
         if(!this.longPress)
         {
            this.longPress = new LongPress(this);
            this.longPress.tapToTrigger = this.tapToTrigger;
         }
      }
      
      override protected function draw() : void
      {
         var _loc5_:Boolean = this.isInvalid("data");
         var _loc6_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc3_:Boolean = this.isInvalid("state");
         var _loc4_:Boolean = this.isInvalid("textRenderer");
         var _loc2_:Boolean = this.isInvalid("focus");
         if(_loc4_)
         {
            this.createLabel();
         }
         if(_loc4_ || _loc3_ || _loc5_)
         {
            this.refreshLabel();
         }
         if(_loc6_ || _loc3_)
         {
            this.refreshLongPressEvents();
            this.refreshIcon();
         }
         if(_loc4_ || _loc6_ || _loc3_)
         {
            this.refreshLabelStyles();
         }
         super.draw();
         if(_loc4_ || _loc6_ || _loc3_ || _loc5_ || _loc1_)
         {
            this.layoutContent();
         }
         if(_loc1_ || _loc2_)
         {
            this.refreshFocusIndicator();
         }
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc6_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc4_:* = this._explicitWidth !== this._explicitWidth;
         var _loc10_:* = this._explicitHeight !== this._explicitHeight;
         var _loc8_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc13_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc4_ && !_loc10_ && !_loc8_ && !_loc13_)
         {
            return false;
         }
         var _loc1_:ITextRenderer = null;
         if(this._label !== null && this.labelTextRenderer)
         {
            _loc1_ = this.labelTextRenderer;
            this.refreshMaxLabelSize(true);
            this.labelTextRenderer.measureText(HELPER_POINT);
         }
         var _loc11_:Number;
         if((_loc11_ = this._gap) === Infinity)
         {
            _loc11_ = this._minGap;
         }
         resetFluidChildDimensionsForMeasurement(this.currentSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitSkinWidth,this._explicitSkinHeight,this._explicitSkinMinWidth,this._explicitSkinMinHeight,this._explicitSkinMaxWidth,this._explicitSkinMaxHeight);
         var _loc12_:IMeasureDisplayObject = this.currentSkin as IMeasureDisplayObject;
         if(this.currentIcon is IValidating)
         {
            IValidating(this.currentIcon).validate();
         }
         if(this.currentSkin is IValidating)
         {
            IValidating(this.currentSkin).validate();
         }
         var _loc7_:* = this._explicitMinWidth;
         if(_loc8_)
         {
            if(_loc1_ !== null)
            {
               _loc7_ = HELPER_POINT.x;
            }
            else
            {
               _loc7_ = 0;
            }
            switch(_loc1_)
            {
               default:
                  if(this._iconPosition !== "top" && this._iconPosition !== "bottom" && this._iconPosition !== "manual")
                  {
                     _loc7_ += _loc11_;
                     if(this.currentIcon is IFeathersControl)
                     {
                        _loc7_ += IFeathersControl(this.currentIcon).minWidth;
                     }
                     else
                     {
                        _loc7_ += this.currentIcon.width;
                     }
                  }
                  else if(this.currentIcon is IFeathersControl)
                  {
                     if((_loc6_ = Number(IFeathersControl(this.currentIcon).minWidth)) > _loc7_)
                     {
                        _loc7_ = _loc6_;
                     }
                  }
                  else if(this.currentIcon.width > _loc7_)
                  {
                     _loc7_ = this.currentIcon.width;
                  }
                  break;
               case null:
                  if(this.currentIcon is IFeathersControl)
                  {
                     _loc7_ = Number(IFeathersControl(this.currentIcon).minWidth);
                     break;
                  }
                  _loc7_ = this.currentIcon.width;
                  break;
               case null:
            }
            _loc7_ += this._paddingLeft + this._paddingRight;
            switch(_loc12_)
            {
               default:
                  if(_loc12_.minWidth > _loc7_)
                  {
                     _loc7_ = _loc12_.minWidth;
                  }
                  break;
               case null:
                  if(this._explicitSkinMinWidth > _loc7_)
                  {
                     _loc7_ = this._explicitSkinMinWidth;
                  }
                  break;
               case null:
            }
         }
         var _loc9_:* = this._explicitMinHeight;
         if(_loc13_)
         {
            if(_loc1_ !== null)
            {
               _loc9_ = HELPER_POINT.y;
            }
            else
            {
               _loc9_ = 0;
            }
            switch(_loc1_)
            {
               default:
                  if(this._iconPosition === "top" || this._iconPosition === "bottom")
                  {
                     _loc9_ += _loc11_;
                     if(this.currentIcon is IFeathersControl)
                     {
                        _loc9_ += IFeathersControl(this.currentIcon).minHeight;
                     }
                     else
                     {
                        _loc9_ += this.currentIcon.height;
                     }
                  }
                  else if(this.currentIcon is IFeathersControl)
                  {
                     _loc2_ = Number(IFeathersControl(this.currentIcon).minHeight);
                     if(_loc2_ > _loc9_)
                     {
                        _loc9_ = _loc2_;
                     }
                  }
                  else if(this.currentIcon.height > _loc9_)
                  {
                     _loc9_ = this.currentIcon.height;
                  }
                  break;
               case null:
                  if(this.currentIcon is IFeathersControl)
                  {
                     _loc9_ = Number(IFeathersControl(this.currentIcon).minHeight);
                     break;
                  }
                  _loc9_ = this.currentIcon.height;
                  break;
               case null:
            }
            _loc9_ += this._paddingTop + this._paddingBottom;
            switch(_loc12_)
            {
               default:
                  if(_loc12_.minHeight > _loc9_)
                  {
                     _loc9_ = _loc12_.minHeight;
                  }
                  break;
               case null:
                  if(this._explicitSkinMinHeight > _loc9_)
                  {
                     _loc9_ = this._explicitSkinMinHeight;
                  }
                  break;
               case null:
            }
         }
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
            switch(_loc1_)
            {
               default:
                  if(this._iconPosition !== "top" && this._iconPosition !== "bottom" && this._iconPosition !== "manual")
                  {
                     _loc3_ += _loc11_ + this.currentIcon.width;
                  }
                  else if(this.currentIcon.width > _loc3_)
                  {
                     _loc3_ = this.currentIcon.width;
                  }
                  break;
               case null:
                  _loc3_ = this.currentIcon.width;
                  break;
               case null:
            }
            _loc3_ += this._paddingLeft + this._paddingRight;
            if(this.currentSkin !== null && this.currentSkin.width > _loc3_)
            {
               _loc3_ = this.currentSkin.width;
            }
         }
         var _loc5_:Number = this._explicitHeight;
         if(_loc10_)
         {
            if(_loc1_ !== null)
            {
               _loc5_ = HELPER_POINT.y;
            }
            else
            {
               _loc5_ = 0;
            }
            switch(_loc1_)
            {
               default:
                  if(this._iconPosition === "top" || this._iconPosition === "bottom")
                  {
                     _loc5_ += _loc11_ + this.currentIcon.height;
                  }
                  else if(this.currentIcon.height > _loc5_)
                  {
                     _loc5_ = this.currentIcon.height;
                  }
                  break;
               case null:
                  _loc5_ = this.currentIcon.height;
                  break;
               case null:
            }
            _loc5_ += this._paddingTop + this._paddingBottom;
            if(this.currentSkin !== null && this.currentSkin.height > _loc5_)
            {
               _loc5_ = this.currentSkin.height;
            }
         }
         return this.saveMeasurements(_loc3_,_loc5_,_loc7_,_loc9_);
      }
      
      override protected function changeState(param1:String) : void
      {
         var _loc2_:String = this._currentState;
         if(_loc2_ === param1)
         {
            return;
         }
         super.changeState(param1);
         if(this._scaleWhenHovering !== 1 && (param1 === "hover" || _loc2_ === "hover"))
         {
            this.setRequiresRedraw();
         }
         else if(this._scaleWhenDown !== 1 && (param1 === "down" || _loc2_ === "down"))
         {
            this.setRequiresRedraw();
         }
      }
      
      protected function createLabel() : void
      {
         var _loc1_:Function = null;
         var _loc2_:String = null;
         if(this.labelTextRenderer)
         {
            this.removeChild(DisplayObject(this.labelTextRenderer),true);
            this.labelTextRenderer = null;
         }
         if(this._hasLabelTextRenderer)
         {
            _loc1_ = this._labelFactory != null ? this._labelFactory : FeathersControl.defaultTextRendererFactory;
            this.labelTextRenderer = ITextRenderer(_loc1_());
            _loc2_ = this._customLabelStyleName != null ? this._customLabelStyleName : this.labelStyleName;
            this.labelTextRenderer.styleNameList.add(_loc2_);
            if(this.labelTextRenderer is IStateObserver)
            {
               IStateObserver(this.labelTextRenderer).stateContext = this;
            }
            this.addChild(DisplayObject(this.labelTextRenderer));
         }
      }
      
      protected function refreshLabel() : void
      {
         if(!this.labelTextRenderer)
         {
            return;
         }
         this.labelTextRenderer.text = this._label;
         this.labelTextRenderer.visible = this._label !== null && this._label.length > 0;
         this.labelTextRenderer.isEnabled = this._isEnabled;
      }
      
      protected function refreshIcon() : void
      {
         var _loc2_:int = 0;
         var _loc1_:DisplayObject = this.currentIcon;
         this.currentIcon = this.getCurrentIcon();
         if(this.currentIcon is IFeathersControl)
         {
            IFeathersControl(this.currentIcon).isEnabled = this._isEnabled;
         }
         switch(_loc1_)
         {
            default:
               this.removeCurrentIcon(_loc1_);
            case null:
               if(this.currentIcon !== null)
               {
                  if(this.currentIcon is IStateObserver)
                  {
                     IStateObserver(this.currentIcon).stateContext = this;
                  }
                  _loc2_ = this.numChildren;
                  if(this.labelTextRenderer)
                  {
                     _loc2_ = this.getChildIndex(DisplayObject(this.labelTextRenderer));
                  }
                  this.addChildAt(this.currentIcon,_loc2_);
                  if(this.currentIcon is IFeathersControl)
                  {
                     IFeathersControl(this.currentIcon).addEventListener("resize",currentIcon_resizeHandler);
                  }
               }
               break;
            case _loc1_:
         }
      }
      
      protected function removeCurrentIcon(param1:DisplayObject) : void
      {
         if(param1 === null)
         {
            return;
         }
         if(param1 is IFeathersControl)
         {
            IFeathersControl(param1).removeEventListener("resize",currentIcon_resizeHandler);
         }
         if(param1 is IStateObserver)
         {
            IStateObserver(param1).stateContext = null;
         }
         if(param1.parent === this)
         {
            this.removeChild(param1,false);
         }
      }
      
      override protected function getCurrentSkin() : DisplayObject
      {
         if(this._stateToSkinFunction !== null)
         {
            return DisplayObject(this._stateToSkinFunction(this,this._currentState,this.currentSkin));
         }
         return super.getCurrentSkin();
      }
      
      protected function getCurrentIcon() : DisplayObject
      {
         if(this._stateToIconFunction !== null)
         {
            return DisplayObject(this._stateToIconFunction(this,this._currentState,this.currentIcon));
         }
         var _loc1_:DisplayObject = this._stateToIcon[this._currentState] as DisplayObject;
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         return this._defaultIcon;
      }
      
      protected function refreshLabelStyles() : void
      {
         var _loc2_:Object = null;
         if(!this.labelTextRenderer)
         {
            return;
         }
         var _loc3_:Object = this.getCurrentLabelProperties();
         for(var _loc1_ in _loc3_)
         {
            _loc2_ = _loc3_[_loc1_];
            this.labelTextRenderer[_loc1_] = _loc2_;
         }
      }
      
      protected function getCurrentLabelProperties() : Object
      {
         if(this._stateToLabelPropertiesFunction !== null)
         {
            return this._stateToLabelPropertiesFunction(this,this._currentState);
         }
         var _loc1_:Object = this._stateToLabelProperties[this._currentState];
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         return this._defaultLabelProperties;
      }
      
      override protected function refreshTriggeredEvents() : void
      {
         super.refreshTriggeredEvents();
         this.keyToTrigger.isEnabled = this._isEnabled;
      }
      
      protected function refreshLongPressEvents() : void
      {
         this.longPress.isEnabled = this._isEnabled && this._isLongPressEnabled;
         this.longPress.longPressDuration = this._longPressDuration;
      }
      
      protected function layoutContent() : void
      {
         var _loc3_:Boolean = this._ignoreIconResizes;
         this._ignoreIconResizes = true;
         this.refreshMaxLabelSize(false);
         var _loc1_:DisplayObject = null;
         if(this._label !== null && this.labelTextRenderer)
         {
            this.labelTextRenderer.validate();
            _loc1_ = DisplayObject(this.labelTextRenderer);
         }
         var _loc2_:Boolean = this.currentIcon && this._iconPosition != "manual";
         if(_loc1_ && _loc2_)
         {
            this.positionSingleChild(_loc1_);
            this.positionLabelAndIcon();
         }
         else if(_loc1_)
         {
            this.positionSingleChild(_loc1_);
         }
         else if(_loc2_)
         {
            this.positionSingleChild(this.currentIcon);
         }
         if(this.currentIcon)
         {
            if(this._iconPosition == "manual")
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
         this._ignoreIconResizes = _loc3_;
      }
      
      protected function refreshMaxLabelSize(param1:Boolean) : void
      {
         var _loc4_:Number = NaN;
         if(this.currentIcon is IValidating)
         {
            IValidating(this.currentIcon).validate();
         }
         var _loc2_:Number = this.actualWidth;
         var _loc3_:Number = this.actualHeight;
         if(param1)
         {
            _loc2_ = this._explicitWidth;
            if(_loc2_ !== _loc2_)
            {
               _loc2_ = this._explicitMaxWidth;
            }
            _loc3_ = this._explicitHeight;
            if(_loc3_ !== _loc3_)
            {
               _loc3_ = this._explicitMaxHeight;
            }
         }
         if(this._label != null && this.labelTextRenderer)
         {
            this.labelTextRenderer.maxWidth = _loc2_ - this._paddingLeft - this._paddingRight;
            this.labelTextRenderer.maxHeight = _loc3_ - this._paddingTop - this._paddingBottom;
            if(this.currentIcon)
            {
               if((_loc4_ = this._gap) == Infinity)
               {
                  _loc4_ = this._minGap;
               }
               if(this._iconPosition == "left" || this._iconPosition == "leftBaseline" || this._iconPosition == "right" || this._iconPosition == "rightBaseline")
               {
                  this.labelTextRenderer.maxWidth -= this.currentIcon.width + _loc4_;
               }
               if(this._iconPosition == "top" || this._iconPosition == "bottom")
               {
                  this.labelTextRenderer.maxHeight -= this.currentIcon.height + _loc4_;
               }
            }
         }
      }
      
      protected function positionSingleChild(param1:DisplayObject) : void
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
      
      protected function positionLabelAndIcon() : void
      {
         if(this._iconPosition == "top")
         {
            if(this._gap == Infinity)
            {
               this.currentIcon.y = this._paddingTop;
               this.labelTextRenderer.y = this.actualHeight - this._paddingBottom - this.labelTextRenderer.height;
            }
            else
            {
               if(this._verticalAlign == "top")
               {
                  this.labelTextRenderer.y += this.currentIcon.height + this._gap;
               }
               else if(this._verticalAlign == "middle")
               {
                  this.labelTextRenderer.y += Math.round((this.currentIcon.height + this._gap) / 2);
               }
               this.currentIcon.y = this.labelTextRenderer.y - this.currentIcon.height - this._gap;
            }
         }
         else if(this._iconPosition == "right" || this._iconPosition == "rightBaseline")
         {
            if(this._gap == Infinity)
            {
               this.labelTextRenderer.x = this._paddingLeft;
               this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
            }
            else
            {
               if(this._horizontalAlign == "right")
               {
                  this.labelTextRenderer.x -= this.currentIcon.width + this._gap;
               }
               else if(this._horizontalAlign == "center")
               {
                  this.labelTextRenderer.x -= Math.round((this.currentIcon.width + this._gap) / 2);
               }
               this.currentIcon.x = this.labelTextRenderer.x + this.labelTextRenderer.width + this._gap;
            }
         }
         else if(this._iconPosition == "bottom")
         {
            if(this._gap == Infinity)
            {
               this.labelTextRenderer.y = this._paddingTop;
               this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
            }
            else
            {
               if(this._verticalAlign == "bottom")
               {
                  this.labelTextRenderer.y -= this.currentIcon.height + this._gap;
               }
               else if(this._verticalAlign == "middle")
               {
                  this.labelTextRenderer.y -= Math.round((this.currentIcon.height + this._gap) / 2);
               }
               this.currentIcon.y = this.labelTextRenderer.y + this.labelTextRenderer.height + this._gap;
            }
         }
         else if(this._iconPosition == "left" || this._iconPosition == "leftBaseline")
         {
            if(this._gap == Infinity)
            {
               this.currentIcon.x = this._paddingLeft;
               this.labelTextRenderer.x = this.actualWidth - this._paddingRight - this.labelTextRenderer.width;
            }
            else
            {
               if(this._horizontalAlign == "left")
               {
                  this.labelTextRenderer.x += this._gap + this.currentIcon.width;
               }
               else if(this._horizontalAlign == "center")
               {
                  this.labelTextRenderer.x += Math.round((this._gap + this.currentIcon.width) / 2);
               }
               this.currentIcon.x = this.labelTextRenderer.x - this._gap - this.currentIcon.width;
            }
         }
         if(this._iconPosition == "left" || this._iconPosition == "right")
         {
            if(this._verticalAlign == "top")
            {
               this.currentIcon.y = this._paddingTop;
            }
            else if(this._verticalAlign == "bottom")
            {
               this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
            }
            else
            {
               this.currentIcon.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - this.currentIcon.height) / 2);
            }
         }
         else if(this._iconPosition == "leftBaseline" || this._iconPosition == "rightBaseline")
         {
            this.currentIcon.y = this.labelTextRenderer.y + this.labelTextRenderer.baseline - this.currentIcon.height;
         }
         else if(this._horizontalAlign == "left")
         {
            this.currentIcon.x = this._paddingLeft;
         }
         else if(this._horizontalAlign == "right")
         {
            this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
         }
         else
         {
            this.currentIcon.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - this.currentIcon.width) / 2);
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         this.stage.addEventListener("keyDown",stage_keyDownHandler);
         this.stage.addEventListener("keyUp",stage_keyUpHandler);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         super.focusOutHandler(param1);
         this.stage.removeEventListener("keyDown",stage_keyDownHandler);
         this.stage.removeEventListener("keyUp",stage_keyUpHandler);
         if(this.touchPointID >= 0)
         {
            this.touchPointID = -1;
            if(this._isEnabled)
            {
               this.changeState("up");
            }
            else
            {
               this.changeState("disabled");
            }
         }
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode === 27)
         {
            this.touchPointID = -1;
            this.changeState("up");
         }
         if(this.touchPointID >= 0 || param1.keyCode !== 32)
         {
            return;
         }
         this.touchPointID = 2147483647;
         this.changeState("down");
      }
      
      protected function stage_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(this.touchPointID !== 2147483647 || param1.keyCode !== 32)
         {
            return;
         }
         this.resetTouchState();
      }
      
      protected function currentIcon_resizeHandler() : void
      {
         if(this._ignoreIconResizes)
         {
            return;
         }
         this.invalidate("size");
      }
   }
}
