package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.ITextBaselineControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IToggle;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import flash.geom.Point;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.utils.SystemUtil;
   
   public class ToggleSwitch extends FeathersControl implements IToggle, IFocusDisplayObject, ITextBaselineControl
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;
      
      protected static const INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";
      
      protected static const INVALIDATION_FLAG_ON_TRACK_FACTORY:String = "onTrackFactory";
      
      protected static const INVALIDATION_FLAG_OFF_TRACK_FACTORY:String = "offTrackFactory";
      
      public static const LABEL_ALIGN_MIDDLE:String = "middle";
      
      public static const LABEL_ALIGN_BASELINE:String = "baseline";
      
      public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";
      
      public static const TRACK_LAYOUT_MODE_ON_OFF:String = "onOff";
      
      public static const DEFAULT_CHILD_STYLE_NAME_OFF_LABEL:String = "feathers-toggle-switch-off-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ON_LABEL:String = "feathers-toggle-switch-on-label";
      
      public static const DEFAULT_CHILD_STYLE_NAME_OFF_TRACK:String = "feathers-toggle-switch-off-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ON_TRACK:String = "feathers-toggle-switch-on-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-toggle-switch-thumb";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var onLabelStyleName:String = "feathers-toggle-switch-on-label";
      
      protected var offLabelStyleName:String = "feathers-toggle-switch-off-label";
      
      protected var onTrackStyleName:String = "feathers-toggle-switch-on-track";
      
      protected var offTrackStyleName:String = "feathers-toggle-switch-off-track";
      
      protected var thumbStyleName:String = "feathers-toggle-switch-thumb";
      
      protected var thumb:DisplayObject;
      
      protected var onTextRenderer:ITextRenderer;
      
      protected var offTextRenderer:ITextRenderer;
      
      protected var onTrack:DisplayObject;
      
      protected var offTrack:DisplayObject;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _showLabels:Boolean = true;
      
      protected var _showThumb:Boolean = true;
      
      protected var _trackLayoutMode:String = "single";
      
      protected var _trackScaleMode:String = "directional";
      
      protected var _defaultLabelProperties:PropertyProxy;
      
      protected var _disabledLabelProperties:PropertyProxy;
      
      protected var _onLabelProperties:PropertyProxy;
      
      protected var _offLabelProperties:PropertyProxy;
      
      protected var _labelAlign:String = "middle";
      
      protected var _labelFactory:Function;
      
      protected var _onLabelFactory:Function;
      
      protected var _customOnLabelStyleName:String;
      
      protected var _offLabelFactory:Function;
      
      protected var _customOffLabelStyleName:String;
      
      protected var _onTrackSkinExplicitWidth:Number;
      
      protected var _onTrackSkinExplicitHeight:Number;
      
      protected var _onTrackSkinExplicitMinWidth:Number;
      
      protected var _onTrackSkinExplicitMinHeight:Number;
      
      protected var _offTrackSkinExplicitWidth:Number;
      
      protected var _offTrackSkinExplicitHeight:Number;
      
      protected var _offTrackSkinExplicitMinWidth:Number;
      
      protected var _offTrackSkinExplicitMinHeight:Number;
      
      protected var _isSelected:Boolean = false;
      
      protected var _toggleThumbSelection:Boolean = false;
      
      protected var _toggleDuration:Number = 0.15;
      
      protected var _toggleEase:Object = "easeOut";
      
      protected var _onText:String = "ON";
      
      protected var _offText:String = "OFF";
      
      protected var _toggleTween:Tween;
      
      protected var _ignoreTapHandler:Boolean = false;
      
      protected var _touchPointID:int = -1;
      
      protected var _thumbStartX:Number;
      
      protected var _touchStartX:Number;
      
      protected var _animateSelectionChange:Boolean = false;
      
      protected var _onTrackFactory:Function;
      
      protected var _customOnTrackStyleName:String;
      
      protected var _onTrackProperties:PropertyProxy;
      
      protected var _offTrackFactory:Function;
      
      protected var _customOffTrackStyleName:String;
      
      protected var _offTrackProperties:PropertyProxy;
      
      protected var _thumbFactory:Function;
      
      protected var _customThumbStyleName:String;
      
      protected var _thumbProperties:PropertyProxy;
      
      public function ToggleSwitch()
      {
         super();
         this.addEventListener("touch",toggleSwitch_touchHandler);
         this.addEventListener("removedFromStage",toggleSwitch_removedFromStageHandler);
      }
      
      protected static function defaultThumbFactory() : BasicButton
      {
         return new Button();
      }
      
      protected static function defaultOnTrackFactory() : BasicButton
      {
         return new Button();
      }
      
      protected static function defaultOffTrackFactory() : BasicButton
      {
         return new Button();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ToggleSwitch.globalStyleProvider;
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
      
      public function get showLabels() : Boolean
      {
         return _showLabels;
      }
      
      public function set showLabels(param1:Boolean) : void
      {
         if(this._showLabels == param1)
         {
            return;
         }
         this._showLabels = param1;
         this.invalidate("styles");
      }
      
      public function get showThumb() : Boolean
      {
         return this._showThumb;
      }
      
      public function set showThumb(param1:Boolean) : void
      {
         if(this._showThumb == param1)
         {
            return;
         }
         this._showThumb = param1;
         this.invalidate("styles");
      }
      
      public function get trackLayoutMode() : String
      {
         return this._trackLayoutMode;
      }
      
      public function set trackLayoutMode(param1:String) : void
      {
         if(param1 === "onOff")
         {
            param1 = "split";
         }
         if(this._trackLayoutMode == param1)
         {
            return;
         }
         this._trackLayoutMode = param1;
         this.invalidate("layout");
      }
      
      public function get trackScaleMode() : String
      {
         return this._trackScaleMode;
      }
      
      public function set trackScaleMode(param1:String) : void
      {
         if(this._trackScaleMode == param1)
         {
            return;
         }
         this._trackScaleMode = param1;
         this.invalidate("styles");
      }
      
      public function get defaultLabelProperties() : Object
      {
         if(!this._defaultLabelProperties)
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
         if(this._defaultLabelProperties)
         {
            this._defaultLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._defaultLabelProperties = PropertyProxy(param1);
         if(this._defaultLabelProperties)
         {
            this._defaultLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get disabledLabelProperties() : Object
      {
         if(!this._disabledLabelProperties)
         {
            this._disabledLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._disabledLabelProperties;
      }
      
      public function set disabledLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._disabledLabelProperties)
         {
            this._disabledLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._disabledLabelProperties = PropertyProxy(param1);
         if(this._disabledLabelProperties)
         {
            this._disabledLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get onLabelProperties() : Object
      {
         if(!this._onLabelProperties)
         {
            this._onLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._onLabelProperties;
      }
      
      public function set onLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._onLabelProperties)
         {
            this._onLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._onLabelProperties = PropertyProxy(param1);
         if(this._onLabelProperties)
         {
            this._onLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get offLabelProperties() : Object
      {
         if(!this._offLabelProperties)
         {
            this._offLabelProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._offLabelProperties;
      }
      
      public function set offLabelProperties(param1:Object) : void
      {
         if(!(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._offLabelProperties)
         {
            this._offLabelProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._offLabelProperties = PropertyProxy(param1);
         if(this._offLabelProperties)
         {
            this._offLabelProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get labelAlign() : String
      {
         return this._labelAlign;
      }
      
      public function set labelAlign(param1:String) : void
      {
         if(this._labelAlign == param1)
         {
            return;
         }
         this._labelAlign = param1;
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
      
      public function get onLabelFactory() : Function
      {
         return this._onLabelFactory;
      }
      
      public function set onLabelFactory(param1:Function) : void
      {
         if(this._onLabelFactory == param1)
         {
            return;
         }
         this._onLabelFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get customOnLabelStyleName() : String
      {
         return this._customOnLabelStyleName;
      }
      
      public function set customOnLabelStyleName(param1:String) : void
      {
         if(this._customOnLabelStyleName == param1)
         {
            return;
         }
         this._customOnLabelStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      public function get offLabelFactory() : Function
      {
         return this._offLabelFactory;
      }
      
      public function set offLabelFactory(param1:Function) : void
      {
         if(this._offLabelFactory == param1)
         {
            return;
         }
         this._offLabelFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get customOffLabelStyleName() : String
      {
         return this._customOffLabelStyleName;
      }
      
      public function set customOffLabelStyleName(param1:String) : void
      {
         if(this._customOffLabelStyleName == param1)
         {
            return;
         }
         this._customOffLabelStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         this._animateSelectionChange = false;
         if(this._isSelected == param1)
         {
            return;
         }
         this._isSelected = param1;
         this.invalidate("selected");
         this.dispatchEventWith("change");
      }
      
      public function get toggleThumbSelection() : Boolean
      {
         return this._toggleThumbSelection;
      }
      
      public function set toggleThumbSelection(param1:Boolean) : void
      {
         if(this._toggleThumbSelection == param1)
         {
            return;
         }
         this._toggleThumbSelection = param1;
         this.invalidate("selected");
      }
      
      public function get toggleDuration() : Number
      {
         return this._toggleDuration;
      }
      
      public function set toggleDuration(param1:Number) : void
      {
         this._toggleDuration = param1;
      }
      
      public function get toggleEase() : Object
      {
         return this._toggleEase;
      }
      
      public function set toggleEase(param1:Object) : void
      {
         this._toggleEase = param1;
      }
      
      public function get onText() : String
      {
         return this._onText;
      }
      
      public function set onText(param1:String) : void
      {
         if(param1 === null)
         {
            param1 = "";
         }
         if(this._onText == param1)
         {
            return;
         }
         this._onText = param1;
         this.invalidate("styles");
      }
      
      public function get offText() : String
      {
         return this._offText;
      }
      
      public function set offText(param1:String) : void
      {
         if(param1 === null)
         {
            param1 = "";
         }
         if(this._offText == param1)
         {
            return;
         }
         this._offText = param1;
         this.invalidate("styles");
      }
      
      public function get onTrackFactory() : Function
      {
         return this._onTrackFactory;
      }
      
      public function set onTrackFactory(param1:Function) : void
      {
         if(this._onTrackFactory == param1)
         {
            return;
         }
         this._onTrackFactory = param1;
         this.invalidate("onTrackFactory");
      }
      
      public function get customOnTrackStyleName() : String
      {
         return this._customOnTrackStyleName;
      }
      
      public function set customOnTrackStyleName(param1:String) : void
      {
         if(this._customOnTrackStyleName == param1)
         {
            return;
         }
         this._customOnTrackStyleName = param1;
         this.invalidate("onTrackFactory");
      }
      
      public function get onTrackProperties() : Object
      {
         if(!this._onTrackProperties)
         {
            this._onTrackProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._onTrackProperties;
      }
      
      public function set onTrackProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._onTrackProperties == param1)
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
         if(this._onTrackProperties)
         {
            this._onTrackProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._onTrackProperties = PropertyProxy(param1);
         if(this._onTrackProperties)
         {
            this._onTrackProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get offTrackFactory() : Function
      {
         return this._offTrackFactory;
      }
      
      public function set offTrackFactory(param1:Function) : void
      {
         if(this._offTrackFactory == param1)
         {
            return;
         }
         this._offTrackFactory = param1;
         this.invalidate("offTrackFactory");
      }
      
      public function get customOffTrackStyleName() : String
      {
         return this._customOffTrackStyleName;
      }
      
      public function set customOffTrackStyleName(param1:String) : void
      {
         if(this._customOffTrackStyleName == param1)
         {
            return;
         }
         this._customOffTrackStyleName = param1;
         this.invalidate("offTrackFactory");
      }
      
      public function get offTrackProperties() : Object
      {
         if(!this._offTrackProperties)
         {
            this._offTrackProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._offTrackProperties;
      }
      
      public function set offTrackProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._offTrackProperties == param1)
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
         if(this._offTrackProperties)
         {
            this._offTrackProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._offTrackProperties = PropertyProxy(param1);
         if(this._offTrackProperties)
         {
            this._offTrackProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get thumbFactory() : Function
      {
         return this._thumbFactory;
      }
      
      public function set thumbFactory(param1:Function) : void
      {
         if(this._thumbFactory == param1)
         {
            return;
         }
         this._thumbFactory = param1;
         this.invalidate("thumbFactory");
      }
      
      public function get customThumbStyleName() : String
      {
         return this._customThumbStyleName;
      }
      
      public function set customThumbStyleName(param1:String) : void
      {
         if(this._customThumbStyleName == param1)
         {
            return;
         }
         this._customThumbStyleName = param1;
         this.invalidate("thumbFactory");
      }
      
      public function get thumbProperties() : Object
      {
         if(!this._thumbProperties)
         {
            this._thumbProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._thumbProperties;
      }
      
      public function set thumbProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._thumbProperties == param1)
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
         if(this._thumbProperties)
         {
            this._thumbProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._thumbProperties = PropertyProxy(param1);
         if(this._thumbProperties)
         {
            this._thumbProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get baseline() : Number
      {
         if(!this.onTextRenderer)
         {
            return this.scaledActualHeight;
         }
         return this.scaleY * (this.onTextRenderer.y + this.onTextRenderer.baseline);
      }
      
      public function setSelectionWithAnimation(param1:Boolean) : void
      {
         if(this._isSelected == param1)
         {
            return;
         }
         this.isSelected = param1;
         this._animateSelectionChange = true;
      }
      
      override protected function draw() : void
      {
         var _loc8_:Boolean = this.isInvalid("selected");
         var _loc10_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc6_:Boolean = this.isInvalid("state");
         var _loc2_:Boolean = this.isInvalid("focus");
         var _loc3_:Boolean = this.isInvalid("layout");
         var _loc7_:Boolean = this.isInvalid("textRenderer");
         var _loc9_:Boolean = this.isInvalid("thumbFactory");
         var _loc5_:Boolean = this.isInvalid("onTrackFactory");
         var _loc4_:Boolean = this.isInvalid("offTrackFactory");
         if(_loc9_)
         {
            this.createThumb();
         }
         if(_loc5_)
         {
            this.createOnTrack();
         }
         if(_loc4_ || _loc3_)
         {
            this.createOffTrack();
         }
         if(_loc7_)
         {
            this.createLabels();
         }
         if(_loc7_ || _loc10_ || _loc6_)
         {
            this.refreshOnLabelStyles();
            this.refreshOffLabelStyles();
         }
         if(_loc9_ || _loc10_)
         {
            this.refreshThumbStyles();
         }
         if(_loc5_ || _loc10_)
         {
            this.refreshOnTrackStyles();
         }
         if((_loc4_ || _loc3_ || _loc10_) && this.offTrack)
         {
            this.refreshOffTrackStyles();
         }
         if(_loc6_ || _loc3_ || _loc9_ || _loc5_ || _loc5_ || _loc7_)
         {
            this.refreshEnabled();
         }
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         if(_loc1_ || _loc10_ || _loc8_)
         {
            this.updateSelection();
         }
         this.layoutChildren();
         if(_loc1_ || _loc2_)
         {
            this.refreshFocusIndicator();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc4_:IMeasureDisplayObject = null;
         var _loc5_:Number = NaN;
         var _loc6_:IMeasureDisplayObject = null;
         var _loc7_:IMeasureDisplayObject = null;
         var _loc2_:* = this._explicitWidth !== this._explicitWidth;
         var _loc12_:* = this._explicitHeight !== this._explicitHeight;
         var _loc9_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc13_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc2_ && !_loc12_ && !_loc9_ && !_loc13_)
         {
            return false;
         }
         var _loc10_:* = this._trackLayoutMode === "single";
         if(_loc2_)
         {
            this.onTrack.width = this._onTrackSkinExplicitWidth;
         }
         else if(_loc10_)
         {
            this.onTrack.width = this._explicitWidth;
         }
         if(this.onTrack is IMeasureDisplayObject)
         {
            _loc4_ = IMeasureDisplayObject(this.onTrack);
            if(_loc9_)
            {
               _loc4_.minWidth = this._onTrackSkinExplicitMinWidth;
            }
            else if(_loc10_)
            {
               _loc5_ = this._explicitMinWidth;
               if(this._onTrackSkinExplicitMinWidth > _loc5_)
               {
                  _loc5_ = this._onTrackSkinExplicitMinWidth;
               }
               _loc4_.minWidth = _loc5_;
            }
         }
         if(!_loc10_)
         {
            if(_loc2_)
            {
               this.offTrack.width = this._offTrackSkinExplicitWidth;
            }
            if(this.offTrack is IMeasureDisplayObject)
            {
               _loc6_ = IMeasureDisplayObject(this.offTrack);
               if(_loc9_)
               {
                  _loc6_.minWidth = this._offTrackSkinExplicitMinWidth;
               }
            }
         }
         if(this.onTrack is IValidating)
         {
            IValidating(this.onTrack).validate();
         }
         if(this.offTrack is IValidating)
         {
            IValidating(this.offTrack).validate();
         }
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         var _loc1_:Number = this._explicitWidth;
         var _loc3_:Number = this._explicitHeight;
         var _loc8_:Number = this._explicitMinWidth;
         var _loc11_:Number = this._explicitMinHeight;
         if(_loc2_)
         {
            _loc1_ = this.onTrack.width;
            if(!_loc10_)
            {
               if(this.offTrack.width > _loc1_)
               {
                  _loc1_ = this.offTrack.width;
               }
               _loc1_ += this.thumb.width / 2;
            }
         }
         if(_loc12_)
         {
            _loc3_ = this.onTrack.height;
            if(!_loc10_ && this.offTrack.height > _loc3_)
            {
               _loc3_ = this.offTrack.height;
            }
            if(this.thumb.height > _loc3_)
            {
               _loc3_ = this.thumb.height;
            }
         }
         if(_loc9_)
         {
            if(_loc4_ !== null)
            {
               _loc8_ = _loc4_.minWidth;
            }
            else
            {
               _loc8_ = this.onTrack.width;
            }
            if(!_loc10_)
            {
               if(_loc6_ !== null)
               {
                  if(_loc6_.minWidth > _loc8_)
                  {
                     _loc8_ = _loc6_.minWidth;
                  }
               }
               else if(this.offTrack.width > _loc8_)
               {
                  _loc8_ = this.offTrack.width;
               }
               if(this.thumb is IMeasureDisplayObject)
               {
                  _loc8_ += IMeasureDisplayObject(this.thumb).minWidth / 2;
               }
               else
               {
                  _loc8_ += this.thumb.width / 2;
               }
            }
         }
         if(_loc13_)
         {
            if(_loc4_ !== null)
            {
               _loc11_ = _loc4_.minHeight;
            }
            else
            {
               _loc11_ = this.onTrack.height;
            }
            if(!_loc10_)
            {
               if(_loc6_ !== null)
               {
                  if(_loc6_.minHeight > _loc11_)
                  {
                     _loc11_ = _loc6_.minHeight;
                  }
               }
               else if(this.offTrack.height > _loc11_)
               {
                  _loc11_ = this.offTrack.height;
               }
            }
            if(this.thumb is IMeasureDisplayObject)
            {
               if((_loc7_ = IMeasureDisplayObject(this.thumb)).minHeight > _loc11_)
               {
                  _loc11_ = _loc7_.minHeight;
               }
            }
            else if(this.thumb.height > _loc11_)
            {
               _loc11_ = this.thumb.height;
            }
         }
         return this.saveMeasurements(_loc1_,_loc3_,_loc8_,_loc11_);
      }
      
      protected function createThumb() : void
      {
         if(this.thumb !== null)
         {
            this.thumb.removeFromParent(true);
            this.thumb = null;
         }
         var _loc1_:Function = this._thumbFactory != null ? this._thumbFactory : defaultThumbFactory;
         var _loc3_:String = this._customThumbStyleName != null ? this._customThumbStyleName : this.thumbStyleName;
         var _loc2_:BasicButton = BasicButton(_loc1_());
         _loc2_.styleNameList.add(_loc3_);
         _loc2_.keepDownStateOnRollOut = true;
         _loc2_.addEventListener("touch",thumb_touchHandler);
         this.addChild(_loc2_);
         this.thumb = _loc2_;
      }
      
      protected function createOnTrack() : void
      {
         var _loc4_:IMeasureDisplayObject = null;
         if(this.onTrack !== null)
         {
            this.onTrack.removeFromParent(true);
            this.onTrack = null;
         }
         var _loc1_:Function = this._onTrackFactory != null ? this._onTrackFactory : defaultOnTrackFactory;
         var _loc3_:String = this._customOnTrackStyleName != null ? this._customOnTrackStyleName : this.onTrackStyleName;
         var _loc2_:BasicButton = BasicButton(_loc1_());
         _loc2_.styleNameList.add(_loc3_);
         _loc2_.keepDownStateOnRollOut = true;
         this.addChildAt(_loc2_,0);
         this.onTrack = _loc2_;
         if(this.onTrack is IFeathersControl)
         {
            IFeathersControl(this.onTrack).initializeNow();
         }
         if(this.onTrack is IMeasureDisplayObject)
         {
            _loc4_ = IMeasureDisplayObject(this.onTrack);
            this._onTrackSkinExplicitWidth = _loc4_.explicitWidth;
            this._onTrackSkinExplicitHeight = _loc4_.explicitHeight;
            this._onTrackSkinExplicitMinWidth = _loc4_.explicitMinWidth;
            this._onTrackSkinExplicitMinHeight = _loc4_.explicitMinHeight;
         }
         else
         {
            this._onTrackSkinExplicitWidth = this.onTrack.width;
            this._onTrackSkinExplicitHeight = this.onTrack.height;
            this._onTrackSkinExplicitMinWidth = this._onTrackSkinExplicitWidth;
            this._onTrackSkinExplicitMinHeight = this._onTrackSkinExplicitHeight;
         }
      }
      
      protected function createOffTrack() : void
      {
         var _loc4_:IMeasureDisplayObject = null;
         if(this.offTrack !== null)
         {
            this.offTrack.removeFromParent(true);
            this.offTrack = null;
         }
         if(this._trackLayoutMode === "single")
         {
            return;
         }
         var _loc1_:Function = this._offTrackFactory != null ? this._offTrackFactory : defaultOffTrackFactory;
         var _loc3_:String = this._customOffTrackStyleName != null ? this._customOffTrackStyleName : this.offTrackStyleName;
         var _loc2_:BasicButton = BasicButton(_loc1_());
         _loc2_.styleNameList.add(_loc3_);
         _loc2_.keepDownStateOnRollOut = true;
         this.addChildAt(_loc2_,1);
         this.offTrack = _loc2_;
         if(this.offTrack is IFeathersControl)
         {
            IFeathersControl(this.offTrack).initializeNow();
         }
         if(this.offTrack is IMeasureDisplayObject)
         {
            _loc4_ = IMeasureDisplayObject(this.offTrack);
            this._offTrackSkinExplicitWidth = _loc4_.explicitWidth;
            this._offTrackSkinExplicitHeight = _loc4_.explicitHeight;
            this._offTrackSkinExplicitMinWidth = _loc4_.explicitMinWidth;
            this._offTrackSkinExplicitMinHeight = _loc4_.explicitMinHeight;
         }
         else
         {
            this._offTrackSkinExplicitWidth = this.offTrack.width;
            this._offTrackSkinExplicitHeight = this.offTrack.height;
            this._offTrackSkinExplicitMinWidth = this._offTrackSkinExplicitWidth;
            this._offTrackSkinExplicitMinHeight = this._offTrackSkinExplicitHeight;
         }
      }
      
      protected function createLabels() : void
      {
         if(this.offTextRenderer)
         {
            this.removeChild(DisplayObject(this.offTextRenderer),true);
            this.offTextRenderer = null;
         }
         if(this.onTextRenderer)
         {
            this.removeChild(DisplayObject(this.onTextRenderer),true);
            this.onTextRenderer = null;
         }
         var _loc3_:int = this.getChildIndex(this.thumb);
         var _loc5_:Function;
         if((_loc5_ = this._offLabelFactory) == null)
         {
            _loc5_ = this._labelFactory;
         }
         if(_loc5_ == null)
         {
            _loc5_ = FeathersControl.defaultTextRendererFactory;
         }
         this.offTextRenderer = ITextRenderer(_loc5_());
         var _loc2_:String = this._customOffLabelStyleName != null ? this._customOffLabelStyleName : this.offLabelStyleName;
         this.offTextRenderer.styleNameList.add(_loc2_);
         var _loc6_:Quad;
         (_loc6_ = new Quad(1,1,16711935)).width = 0;
         _loc6_.height = 0;
         this.offTextRenderer.mask = _loc6_;
         this.addChildAt(DisplayObject(this.offTextRenderer),_loc3_);
         var _loc4_:Function;
         if((_loc4_ = this._onLabelFactory) == null)
         {
            _loc4_ = this._labelFactory;
         }
         if(_loc4_ == null)
         {
            _loc4_ = FeathersControl.defaultTextRendererFactory;
         }
         this.onTextRenderer = ITextRenderer(_loc4_());
         var _loc1_:String = this._customOnLabelStyleName != null ? this._customOnLabelStyleName : this.onLabelStyleName;
         this.onTextRenderer.styleNameList.add(_loc1_);
         (_loc6_ = new Quad(1,1,16711935)).width = 0;
         _loc6_.height = 0;
         this.onTextRenderer.mask = _loc6_;
         this.addChildAt(DisplayObject(this.onTextRenderer),_loc3_);
      }
      
      protected function layoutChildren() : void
      {
         var _loc2_:* = NaN;
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         this.thumb.y = (this.actualHeight - this.thumb.height) / 2;
         var _loc3_:Number = Math.max(0,this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
         var _loc1_:Number = Math.max(this.onTextRenderer.height,this.offTextRenderer.height);
         if(this._labelAlign == "middle")
         {
            _loc2_ = _loc1_;
         }
         else
         {
            _loc2_ = Math.max(this.onTextRenderer.baseline,this.offTextRenderer.baseline);
         }
         var _loc4_:DisplayObject;
         (_loc4_ = this.onTextRenderer.mask).width = _loc3_;
         _loc4_.height = _loc1_;
         this.onTextRenderer.y = (this.actualHeight - _loc2_) / 2;
         (_loc4_ = this.offTextRenderer.mask).width = _loc3_;
         _loc4_.height = _loc1_;
         this.offTextRenderer.y = (this.actualHeight - _loc2_) / 2;
         this.layoutTracks();
      }
      
      protected function layoutTracks() : void
      {
         var _loc5_:Number = Math.max(0,this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
         var _loc3_:Number = this.thumb.x - this._paddingLeft;
         var _loc1_:Number = _loc5_ - _loc3_ - (_loc5_ - this.onTextRenderer.width) / 2;
         var _loc4_:DisplayObject;
         (_loc4_ = this.onTextRenderer.mask).x = _loc1_;
         this.onTextRenderer.x = this._paddingLeft - _loc1_;
         var _loc2_:Number = -_loc3_ - (_loc5_ - this.offTextRenderer.width) / 2;
         (_loc4_ = this.offTextRenderer.mask).x = _loc2_;
         this.offTextRenderer.x = this.actualWidth - this._paddingRight - _loc5_ - _loc2_;
         if(this._trackLayoutMode == "split")
         {
            this.layoutTrackWithOnOff();
         }
         else
         {
            this.layoutTrackWithSingle();
         }
      }
      
      protected function updateSelection() : void
      {
         var _loc2_:IToggle = null;
         if(this.thumb is IToggle)
         {
            _loc2_ = IToggle(this.thumb);
            if(this._toggleThumbSelection)
            {
               _loc2_.isSelected = this._isSelected;
            }
            else
            {
               _loc2_.isSelected = false;
            }
         }
         if(this.thumb is IValidating)
         {
            IValidating(this.thumb).validate();
         }
         var _loc1_:Number = this._paddingLeft;
         if(this._isSelected)
         {
            _loc1_ = this.actualWidth - this.thumb.width - this._paddingRight;
         }
         if(this._toggleTween)
         {
            Starling.juggler.remove(this._toggleTween);
            this._toggleTween = null;
         }
         if(this._animateSelectionChange)
         {
            this._toggleTween = new Tween(this.thumb,this._toggleDuration,this._toggleEase);
            this._toggleTween.animate("x",_loc1_);
            this._toggleTween.onUpdate = selectionTween_onUpdate;
            this._toggleTween.onComplete = selectionTween_onComplete;
            Starling.juggler.add(this._toggleTween);
         }
         else
         {
            this.thumb.x = _loc1_;
         }
         this._animateSelectionChange = false;
      }
      
      protected function refreshOnLabelStyles() : void
      {
         var _loc4_:PropertyProxy = null;
         var _loc1_:DisplayObject = null;
         var _loc3_:Object = null;
         if(!this._showLabels || !this._showThumb)
         {
            this.onTextRenderer.visible = false;
            return;
         }
         if(!this._isEnabled)
         {
            _loc4_ = this._disabledLabelProperties;
         }
         if(!_loc4_ && this._onLabelProperties)
         {
            _loc4_ = this._onLabelProperties;
         }
         if(!_loc4_)
         {
            _loc4_ = this._defaultLabelProperties;
         }
         this.onTextRenderer.text = this._onText;
         if(_loc4_)
         {
            _loc1_ = DisplayObject(this.onTextRenderer);
            for(var _loc2_ in _loc4_)
            {
               _loc3_ = _loc4_[_loc2_];
               _loc1_[_loc2_] = _loc3_;
            }
         }
         this.onTextRenderer.validate();
         this.onTextRenderer.visible = true;
      }
      
      protected function refreshOffLabelStyles() : void
      {
         var _loc4_:PropertyProxy = null;
         var _loc1_:DisplayObject = null;
         var _loc3_:Object = null;
         if(!this._showLabels || !this._showThumb)
         {
            this.offTextRenderer.visible = false;
            return;
         }
         if(!this._isEnabled)
         {
            _loc4_ = this._disabledLabelProperties;
         }
         if(!_loc4_ && this._offLabelProperties)
         {
            _loc4_ = this._offLabelProperties;
         }
         if(!_loc4_)
         {
            _loc4_ = this._defaultLabelProperties;
         }
         this.offTextRenderer.text = this._offText;
         if(_loc4_)
         {
            _loc1_ = DisplayObject(this.offTextRenderer);
            for(var _loc2_ in _loc4_)
            {
               _loc3_ = _loc4_[_loc2_];
               _loc1_[_loc2_] = _loc3_;
            }
         }
         this.offTextRenderer.validate();
         this.offTextRenderer.visible = true;
      }
      
      protected function refreshThumbStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._thumbProperties)
         {
            _loc2_ = this._thumbProperties[_loc1_];
            this.thumb[_loc1_] = _loc2_;
         }
         this.thumb.visible = this._showThumb;
      }
      
      protected function refreshOnTrackStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._onTrackProperties)
         {
            _loc2_ = this._onTrackProperties[_loc1_];
            this.onTrack[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshOffTrackStyles() : void
      {
         var _loc2_:Object = null;
         if(!this.offTrack)
         {
            return;
         }
         for(var _loc1_ in this._offTrackProperties)
         {
            _loc2_ = this._offTrackProperties[_loc1_];
            this.offTrack[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshEnabled() : void
      {
         if(this.thumb is IFeathersControl)
         {
            IFeathersControl(this.thumb).isEnabled = this._isEnabled;
         }
         if(this.onTrack is IFeathersControl)
         {
            IFeathersControl(this.onTrack).isEnabled = this._isEnabled;
         }
         if(this.offTrack is IFeathersControl)
         {
            IFeathersControl(this.offTrack).isEnabled = this._isEnabled;
         }
         this.onTextRenderer.isEnabled = this._isEnabled;
         this.offTextRenderer.isEnabled = this._isEnabled;
      }
      
      protected function layoutTrackWithOnOff() : void
      {
         var _loc1_:Number = Math.round(this.thumb.x + this.thumb.width / 2);
         this.onTrack.x = 0;
         this.onTrack.width = _loc1_;
         this.offTrack.x = _loc1_;
         this.offTrack.width = this.actualWidth - _loc1_;
         if(this._trackScaleMode === "exactFit")
         {
            this.onTrack.y = 0;
            this.onTrack.height = this.actualHeight;
            this.offTrack.y = 0;
            this.offTrack.height = this.actualHeight;
         }
         if(this.onTrack is IValidating)
         {
            IValidating(this.onTrack).validate();
         }
         if(this.offTrack is IValidating)
         {
            IValidating(this.offTrack).validate();
         }
         if(this._trackScaleMode === "directional")
         {
            this.onTrack.y = Math.round((this.actualHeight - this.onTrack.height) / 2);
            this.offTrack.y = Math.round((this.actualHeight - this.offTrack.height) / 2);
         }
      }
      
      protected function layoutTrackWithSingle() : void
      {
         this.onTrack.x = 0;
         this.onTrack.width = this.actualWidth;
         if(this._trackScaleMode === "exactFit")
         {
            this.onTrack.y = 0;
            this.onTrack.height = this.actualHeight;
         }
         else
         {
            this.onTrack.height = this._onTrackSkinExplicitHeight;
         }
         if(this.onTrack is IValidating)
         {
            IValidating(this.onTrack).validate();
         }
         if(this._trackScaleMode === "directional")
         {
            this.onTrack.y = Math.round((this.actualHeight - this.onTrack.height) / 2);
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function toggleSwitch_removedFromStageHandler(param1:Event) : void
      {
         this._touchPointID = -1;
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
      }
      
      protected function toggleSwitch_touchHandler(param1:TouchEvent) : void
      {
         if(this._ignoreTapHandler)
         {
            this._ignoreTapHandler = false;
            return;
         }
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         var _loc3_:Touch = param1.getTouch(this,"ended");
         if(!_loc3_)
         {
            return;
         }
         this._touchPointID = -1;
         _loc3_.getLocation(this.stage,HELPER_POINT);
         var _loc2_:Boolean = this.contains(this.stage.hitTest(HELPER_POINT));
         if(_loc2_)
         {
            this.setSelectionWithAnimation(!this._isSelected);
         }
      }
      
      protected function thumb_touchHandler(param1:TouchEvent) : void
      {
         var _loc5_:Touch = null;
         var _loc7_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            if(!(_loc5_ = param1.getTouch(this.thumb,null,this._touchPointID)))
            {
               return;
            }
            _loc5_.getLocation(this,HELPER_POINT);
            _loc7_ = this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width;
            if(_loc5_.phase == "moved")
            {
               _loc4_ = HELPER_POINT.x - this._touchStartX;
               _loc2_ = Math.min(Math.max(this._paddingLeft,this._thumbStartX + _loc4_),this._paddingLeft + _loc7_);
               this.thumb.x = _loc2_;
               this.layoutTracks();
            }
            else if(_loc5_.phase == "ended")
            {
               _loc3_ = Math.abs(HELPER_POINT.x - this._touchStartX);
               if((_loc6_ = _loc3_ / DeviceCapabilities.dpi) > 0.04 || SystemUtil.isDesktop && _loc3_ >= 1)
               {
                  this._touchPointID = -1;
                  this._ignoreTapHandler = true;
                  this.setSelectionWithAnimation(this.thumb.x > this._paddingLeft + _loc7_ / 2);
                  this.invalidate("selected");
               }
            }
         }
         else
         {
            if(!(_loc5_ = param1.getTouch(this.thumb,"began")))
            {
               return;
            }
            _loc5_.getLocation(this,HELPER_POINT);
            this._touchPointID = _loc5_.id;
            this._thumbStartX = this.thumb.x;
            this._touchStartX = HELPER_POINT.x;
         }
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 27)
         {
            this._touchPointID = -1;
         }
         if(this._touchPointID >= 0 || param1.keyCode != 32)
         {
            return;
         }
         this._touchPointID = 2147483647;
      }
      
      protected function stage_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(this._touchPointID != 2147483647 || param1.keyCode != 32)
         {
            return;
         }
         this._touchPointID = -1;
         this.setSelectionWithAnimation(!this._isSelected);
      }
      
      protected function selectionTween_onUpdate() : void
      {
         this.layoutTracks();
      }
      
      protected function selectionTween_onComplete() : void
      {
         this._toggleTween = null;
      }
   }
}
