package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IAdvancedNativeFocusOwner;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IMultilineTextEditor;
   import feathers.core.INativeFocusOwner;
   import feathers.core.IStateContext;
   import feathers.core.IStateObserver;
   import feathers.core.ITextBaselineControl;
   import feathers.core.ITextEditor;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.core.PropertyProxy;
   import feathers.skins.IStyleProvider;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class TextInput extends FeathersControl implements ITextBaselineControl, IAdvancedNativeFocusOwner, IStateContext
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      protected static const INVALIDATION_FLAG_PROMPT_FACTORY:String = "promptFactory";
      
      protected static const INVALIDATION_FLAG_ERROR_CALLOUT_FACTORY:String = "errorCalloutFactory";
      
      public static const STATE_ENABLED:String = "enabled";
      
      public static const STATE_DISABLED:String = "disabled";
      
      public static const STATE_FOCUSED:String = "focused";
      
      public static const DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR:String = "feathers-text-input-text-editor";
      
      public static const DEFAULT_CHILD_STYLE_NAME_PROMPT:String = "feathers-text-input-prompt";
      
      public static const DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT:String = "feathers-text-input-error-callout";
      
      public static const ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT:String = "feathers-search-text-input";
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var textEditor:ITextEditor;
      
      protected var promptTextRenderer:ITextRenderer;
      
      protected var currentBackground:DisplayObject;
      
      protected var currentIcon:DisplayObject;
      
      protected var callout:TextCallout;
      
      protected var textEditorStyleName:String = "feathers-text-input-text-editor";
      
      protected var promptStyleName:String = "feathers-text-input-prompt";
      
      protected var errorCalloutStyleName:String = "feathers-text-input-error-callout";
      
      protected var _textEditorHasFocus:Boolean = false;
      
      protected var _ignoreTextChanges:Boolean = false;
      
      protected var _touchPointID:int = -1;
      
      protected var _currentState:String = "enabled";
      
      protected var _text:String = "";
      
      protected var _prompt:String = null;
      
      protected var _typicalText:String = null;
      
      protected var _maxChars:int = 0;
      
      protected var _restrict:String;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _isEditable:Boolean = true;
      
      protected var _isSelectable:Boolean = true;
      
      protected var _errorString:String = null;
      
      protected var _textEditorFactory:Function;
      
      protected var _customTextEditorStyleName:String;
      
      protected var _promptFactory:Function;
      
      protected var _customPromptStyleName:String;
      
      protected var _promptProperties:PropertyProxy;
      
      protected var _customErrorCalloutStyleName:String;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _stateToSkin:Object;
      
      protected var _stateToSkinFunction:Function;
      
      protected var _originalIconWidth:Number = NaN;
      
      protected var _originalIconHeight:Number = NaN;
      
      protected var _defaultIcon:DisplayObject;
      
      protected var _stateToIcon:Object;
      
      protected var _stateToIconFunction:Function;
      
      protected var _gap:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _verticalAlign:String = "middle";
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionBeginIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var _oldMouseCursor:String = null;
      
      protected var _textEditorProperties:PropertyProxy;
      
      public function TextInput()
      {
         _stateToSkin = {};
         _stateToIcon = {};
         super();
         this.addEventListener("touch",textInput_touchHandler);
         this.addEventListener("removedFromStage",textInput_removedFromStageHandler);
      }
      
      public function get nativeFocus() : Object
      {
         if(this.textEditor is INativeFocusOwner)
         {
            return INativeFocusOwner(this.textEditor).nativeFocus;
         }
         return null;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return TextInput.globalStyleProvider;
      }
      
      public function get hasFocus() : Boolean
      {
         return this._textEditorHasFocus;
      }
      
      override public function set isEnabled(param1:Boolean) : void
      {
         super.isEnabled = param1;
         this.refreshState();
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(!param1)
         {
            param1 = "";
         }
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate("data");
         this.dispatchEventWith("change");
      }
      
      public function get baseline() : Number
      {
         if(!this.textEditor)
         {
            return 0;
         }
         return this.textEditor.y + this.textEditor.baseline;
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
         this.invalidate("styles");
      }
      
      public function get typicalText() : String
      {
         return this._typicalText;
      }
      
      public function set typicalText(param1:String) : void
      {
         if(this._typicalText === param1)
         {
            return;
         }
         this._typicalText = param1;
         this.invalidate("data");
      }
      
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         if(this._maxChars == param1)
         {
            return;
         }
         this._maxChars = param1;
         this.invalidate("styles");
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         if(this._restrict == param1)
         {
            return;
         }
         this._restrict = param1;
         this.invalidate("styles");
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this._displayAsPassword == param1)
         {
            return;
         }
         this._displayAsPassword = param1;
         this.invalidate("styles");
      }
      
      public function get isEditable() : Boolean
      {
         return this._isEditable;
      }
      
      public function set isEditable(param1:Boolean) : void
      {
         if(this._isEditable == param1)
         {
            return;
         }
         this._isEditable = param1;
         this.invalidate("styles");
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
         this.invalidate("styles");
      }
      
      public function get errorString() : String
      {
         return this._errorString;
      }
      
      public function set errorString(param1:String) : void
      {
         if(this._errorString === param1)
         {
            return;
         }
         this._errorString = param1;
         this.refreshState();
         this.invalidate("styles");
      }
      
      public function get textEditorFactory() : Function
      {
         return this._textEditorFactory;
      }
      
      public function set textEditorFactory(param1:Function) : void
      {
         if(this._textEditorFactory == param1)
         {
            return;
         }
         this._textEditorFactory = param1;
         this.invalidate("textEditor");
      }
      
      public function get customTextEditorStyleName() : String
      {
         return this._customTextEditorStyleName;
      }
      
      public function set customTextEditorStyleName(param1:String) : void
      {
         if(this._customTextEditorStyleName == param1)
         {
            return;
         }
         this._customTextEditorStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      public function get promptFactory() : Function
      {
         return this._promptFactory;
      }
      
      public function set promptFactory(param1:Function) : void
      {
         if(this._promptFactory == param1)
         {
            return;
         }
         this._promptFactory = param1;
         this.invalidate("promptFactory");
      }
      
      public function get customPromptStyleName() : String
      {
         return this._customPromptStyleName;
      }
      
      public function set customPromptStyleName(param1:String) : void
      {
         if(this._customPromptStyleName == param1)
         {
            return;
         }
         this._customPromptStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      public function get promptProperties() : Object
      {
         if(!this._promptProperties)
         {
            this._promptProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._promptProperties;
      }
      
      public function set promptProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._promptProperties == param1)
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
         if(this._promptProperties)
         {
            this._promptProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._promptProperties = PropertyProxy(param1);
         if(this._promptProperties)
         {
            this._promptProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get customErrorCalloutStyleName() : String
      {
         return this._customErrorCalloutStyleName;
      }
      
      public function set customErrorCalloutStyleName(param1:String) : void
      {
         if(this._customErrorCalloutStyleName == param1)
         {
            return;
         }
         this._customErrorCalloutStyleName = param1;
         this.invalidate("errorCalloutFactory");
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this._backgroundSkin === param1)
         {
            return;
         }
         this._backgroundSkin = param1;
         this.invalidate("skin");
      }
      
      public function get backgroundEnabledSkin() : DisplayObject
      {
         return this.getSkinForState("enabled");
      }
      
      public function set backgroundEnabledSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("enabled",param1);
      }
      
      public function get backgroundFocusedSkin() : DisplayObject
      {
         return this.getSkinForState("focused");
      }
      
      public function set backgroundFocusedSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("focused",param1);
      }
      
      public function get backgroundErrorSkin() : DisplayObject
      {
         return this.getSkinForState("error");
      }
      
      public function set backgroundErrorSkin(param1:DisplayObject) : void
      {
         this.setSkinForState("error",param1);
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this.getSkinForState("disabled");
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
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
         this.invalidate("skin");
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
         this._defaultIcon = param1;
         this.invalidate("styles");
      }
      
      public function get enabledIcon() : DisplayObject
      {
         return this.getIconForState("enabled");
      }
      
      public function set enabledIcon(param1:DisplayObject) : void
      {
         this.setIconForState("enabled",param1);
      }
      
      public function get disabledIcon() : DisplayObject
      {
         return this.getIconForState("disabled");
      }
      
      public function set disabledIcon(param1:DisplayObject) : void
      {
         this.setIconForState("disabled",param1);
      }
      
      public function get focusedIcon() : DisplayObject
      {
         return this.getIconForState("focused");
      }
      
      public function set focusedIcon(param1:DisplayObject) : void
      {
         this.setIconForState("focused",param1);
      }
      
      public function get errorIcon() : DisplayObject
      {
         return this.getIconForState("error");
      }
      
      public function set errorIcon(param1:DisplayObject) : void
      {
         this.setIconForState("error",param1);
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
      
      public function get textEditorProperties() : Object
      {
         if(!this._textEditorProperties)
         {
            this._textEditorProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._textEditorProperties;
      }
      
      public function set textEditorProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._textEditorProperties == param1)
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
         if(this._textEditorProperties)
         {
            this._textEditorProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._textEditorProperties = PropertyProxy(param1);
         if(this._textEditorProperties)
         {
            this._textEditorProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get selectionBeginIndex() : int
      {
         if(this._pendingSelectionBeginIndex >= 0)
         {
            return this._pendingSelectionBeginIndex;
         }
         if(this.textEditor)
         {
            return this.textEditor.selectionBeginIndex;
         }
         return 0;
      }
      
      public function get selectionEndIndex() : int
      {
         if(this._pendingSelectionEndIndex >= 0)
         {
            return this._pendingSelectionEndIndex;
         }
         if(this.textEditor)
         {
            return this.textEditor.selectionEndIndex;
         }
         return 0;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(!param1)
         {
            this._isWaitingToSetFocus = false;
            if(this._textEditorHasFocus)
            {
               this.textEditor.clearFocus();
            }
         }
         super.visible = param1;
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         if(!this.visible || !this.touchable)
         {
            return null;
         }
         if(this.mask && !this.hitTestMask(param1))
         {
            return null;
         }
         return this._hitArea.containsPoint(param1) ? DisplayObject(this.textEditor) : null;
      }
      
      override public function showFocus() : void
      {
         if(!this._focusManager || this._focusManager.focus != this)
         {
            return;
         }
         this.selectRange(0,this._text.length);
         super.showFocus();
      }
      
      public function setFocus() : void
      {
         if(this._textEditorHasFocus || !this.visible || this._touchPointID >= 0)
         {
            return;
         }
         if(this.textEditor)
         {
            this._isWaitingToSetFocus = false;
            this.textEditor.setFocus();
         }
         else
         {
            this._isWaitingToSetFocus = true;
            this.invalidate("selected");
         }
      }
      
      public function clearFocus() : void
      {
         this._isWaitingToSetFocus = false;
         if(!this.textEditor || !this._textEditorHasFocus)
         {
            return;
         }
         this.textEditor.clearFocus();
      }
      
      public function selectRange(param1:int, param2:int = -1) : void
      {
         if(param2 < 0)
         {
            param2 = param1;
         }
         if(param1 < 0)
         {
            throw new RangeError("Expected start index >= 0. Received " + param1 + ".");
         }
         if(param2 > this._text.length)
         {
            throw new RangeError("Expected end index <= " + this._text.length + ". Received " + param2 + ".");
         }
         if(this.textEditor && (this._isValidating || !this.isInvalid()))
         {
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.textEditor.selectRange(param1,param2);
         }
         else
         {
            this._pendingSelectionBeginIndex = param1;
            this._pendingSelectionEndIndex = param2;
            this.invalidate("selected");
         }
      }
      
      public function getSkinForState(param1:String) : DisplayObject
      {
         return this._stateToSkin[param1] as DisplayObject;
      }
      
      public function setSkinForState(param1:String, param2:DisplayObject) : void
      {
         if(param2 !== null)
         {
            this._stateToSkin[param1] = param2;
         }
         else
         {
            delete this._stateToSkin[param1];
         }
         this.invalidate("styles");
      }
      
      public function getIconForState(param1:String) : DisplayObject
      {
         return this._stateToIcon[param1] as DisplayObject;
      }
      
      public function setIconForState(param1:String, param2:DisplayObject) : void
      {
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
      
      override public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:DisplayObject = null;
         if(this._backgroundSkin !== null && this._backgroundSkin.parent !== this)
         {
            this._backgroundSkin.dispose();
         }
         for(var _loc3_ in this._stateToSkin)
         {
            _loc1_ = this._stateToSkin[_loc3_] as DisplayObject;
            if(_loc1_ !== null && _loc1_.parent !== this)
            {
               _loc1_.dispose();
            }
         }
         if(this._defaultIcon !== null && this._defaultIcon.parent !== this)
         {
            this._defaultIcon.dispose();
         }
         for(_loc3_ in this._stateToIcon)
         {
            _loc2_ = this._stateToIcon[_loc3_] as DisplayObject;
            if(_loc2_ !== null && _loc2_.parent !== this)
            {
               _loc2_.dispose();
            }
         }
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc3_:Boolean = false;
         var _loc6_:Boolean = this.isInvalid("state");
         var _loc7_:Boolean = this.isInvalid("styles");
         var _loc8_:Boolean = this.isInvalid("data");
         var _loc4_:Boolean = this.isInvalid("skin");
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc9_:Boolean = this.isInvalid("textEditor");
         var _loc5_:Boolean = this.isInvalid("promptFactory");
         var _loc2_:Boolean = this.isInvalid("focus");
         if(_loc9_)
         {
            this.createTextEditor();
         }
         if(_loc5_ || this._prompt !== null && !this.promptTextRenderer)
         {
            this.createPrompt();
         }
         if(_loc9_ || _loc7_)
         {
            this.refreshTextEditorProperties();
         }
         if(_loc5_ || _loc7_)
         {
            this.refreshPromptProperties();
         }
         if(_loc9_ || _loc8_)
         {
            _loc3_ = this._ignoreTextChanges;
            this._ignoreTextChanges = true;
            this.textEditor.text = this._text;
            this._ignoreTextChanges = _loc3_;
         }
         if(this.promptTextRenderer)
         {
            if(_loc5_ || _loc8_ || _loc7_)
            {
               this.promptTextRenderer.visible = this._prompt && this._text.length == 0;
            }
            if(_loc5_ || _loc6_)
            {
               this.promptTextRenderer.isEnabled = this._isEnabled;
            }
         }
         if(_loc9_ || _loc6_)
         {
            this.textEditor.isEnabled = this._isEnabled;
            if(!this._isEnabled && Mouse.supportsNativeCursor && this._oldMouseCursor)
            {
               Mouse.cursor = this._oldMouseCursor;
               this._oldMouseCursor = null;
            }
         }
         if(_loc6_ || _loc4_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc6_ || _loc7_)
         {
            this.refreshIcon();
         }
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layoutChildren();
         if(_loc1_ || _loc2_)
         {
            this.refreshFocusIndicator();
         }
         this.doPendingActions();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc9_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc10_:Boolean = false;
         var _loc16_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc4_:* = this._explicitWidth !== this._explicitWidth;
         var _loc15_:* = this._explicitHeight !== this._explicitHeight;
         var _loc13_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc18_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc4_ && !_loc15_ && !_loc13_ && !_loc18_)
         {
            return false;
         }
         var _loc6_:IMeasureDisplayObject = this.currentBackground as IMeasureDisplayObject;
         resetFluidChildDimensionsForMeasurement(this.currentBackground,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         if(this.currentBackground is IValidating)
         {
            IValidating(this.currentBackground).validate();
         }
         if(this.currentIcon is IValidating)
         {
            IValidating(this.currentIcon).validate();
         }
         var _loc17_:Number = 0;
         var _loc8_:Number = 0;
         if(this._typicalText !== null)
         {
            _loc9_ = Number(this.textEditor.width);
            _loc1_ = Number(this.textEditor.height);
            _loc10_ = this._ignoreTextChanges;
            this._ignoreTextChanges = true;
            this.textEditor.setSize(NaN,NaN);
            this.textEditor.text = this._typicalText;
            this.textEditor.measureText(HELPER_POINT);
            this.textEditor.text = this._text;
            this._ignoreTextChanges = _loc10_;
            _loc17_ = HELPER_POINT.x;
            _loc8_ = HELPER_POINT.y;
         }
         if(this._prompt !== null)
         {
            this.promptTextRenderer.setSize(NaN,NaN);
            this.promptTextRenderer.measureText(HELPER_POINT);
            if(HELPER_POINT.x > _loc17_)
            {
               _loc17_ = HELPER_POINT.x;
            }
            if(HELPER_POINT.y > _loc8_)
            {
               _loc8_ = HELPER_POINT.y;
            }
         }
         var _loc2_:* = this._explicitWidth;
         if(_loc4_)
         {
            _loc2_ = _loc17_;
            if(this._originalIconWidth === this._originalIconWidth)
            {
               _loc2_ += this._originalIconWidth + this._gap;
            }
            _loc2_ += this._paddingLeft + this._paddingRight;
            if(this.currentBackground !== null && this.currentBackground.width > _loc2_)
            {
               _loc2_ = this.currentBackground.width;
            }
         }
         var _loc5_:* = this._explicitHeight;
         if(_loc15_)
         {
            _loc5_ = _loc8_;
            if(this._originalIconHeight === this._originalIconHeight && this._originalIconHeight > _loc5_)
            {
               _loc5_ = this._originalIconHeight;
            }
            _loc5_ += this._paddingTop + this._paddingBottom;
            if(this.currentBackground !== null && this.currentBackground.height > _loc5_)
            {
               _loc5_ = this.currentBackground.height;
            }
         }
         var _loc11_:* = this._explicitMinWidth;
         if(_loc13_)
         {
            _loc11_ = _loc17_;
            if(this.currentIcon is IFeathersControl)
            {
               _loc11_ += IFeathersControl(this.currentIcon).minWidth + this._gap;
            }
            else if(this._originalIconWidth === this._originalIconWidth)
            {
               _loc11_ += this._originalIconWidth + this._gap;
            }
            _loc11_ += this._paddingLeft + this._paddingRight;
            _loc16_ = 0;
            if(_loc6_ !== null)
            {
               _loc16_ = _loc6_.minWidth;
            }
            else if(this.currentBackground !== null)
            {
               _loc16_ = this._explicitBackgroundMinWidth;
            }
            if(_loc16_ > _loc11_)
            {
               _loc11_ = _loc16_;
            }
         }
         var _loc14_:* = this._explicitMinHeight;
         if(_loc18_)
         {
            _loc14_ = _loc8_;
            if(this.currentIcon is IFeathersControl)
            {
               _loc3_ = Number(IFeathersControl(this.currentIcon).minHeight);
               if(_loc3_ > _loc14_)
               {
                  _loc14_ = _loc3_;
               }
            }
            else if(this._originalIconHeight === this._originalIconHeight && this._originalIconHeight > _loc14_)
            {
               _loc14_ = this._originalIconHeight;
            }
            _loc14_ += this._paddingTop + this._paddingBottom;
            _loc7_ = 0;
            if(_loc6_ !== null)
            {
               _loc7_ = _loc6_.minHeight;
            }
            else if(this.currentBackground !== null)
            {
               _loc7_ = this._explicitBackgroundMinHeight;
            }
            if(_loc7_ > _loc14_)
            {
               _loc14_ = _loc7_;
            }
         }
         var _loc12_:Boolean = this.textEditor is IMultilineTextEditor && Boolean(IMultilineTextEditor(this.textEditor).multiline);
         if(this._typicalText !== null && (this._verticalAlign == "justify" || _loc12_))
         {
            this.textEditor.width = _loc9_;
            this.textEditor.height = _loc1_;
         }
         return this.saveMeasurements(_loc2_,_loc5_,_loc11_,_loc14_);
      }
      
      protected function createTextEditor() : void
      {
         if(this.textEditor)
         {
            this.removeChild(DisplayObject(this.textEditor),true);
            this.textEditor.removeEventListener("change",textEditor_changeHandler);
            this.textEditor.removeEventListener("enter",textEditor_enterHandler);
            this.textEditor.removeEventListener("focusIn",textEditor_focusInHandler);
            this.textEditor.removeEventListener("focusOut",textEditor_focusOutHandler);
            this.textEditor = null;
         }
         var _loc1_:Function = this._textEditorFactory != null ? this._textEditorFactory : FeathersControl.defaultTextEditorFactory;
         this.textEditor = ITextEditor(_loc1_());
         var _loc2_:String = this._customTextEditorStyleName != null ? this._customTextEditorStyleName : this.textEditorStyleName;
         this.textEditor.styleNameList.add(_loc2_);
         if(this.textEditor is IStateObserver)
         {
            IStateObserver(this.textEditor).stateContext = this;
         }
         this.textEditor.addEventListener("change",textEditor_changeHandler);
         this.textEditor.addEventListener("enter",textEditor_enterHandler);
         this.textEditor.addEventListener("focusIn",textEditor_focusInHandler);
         this.textEditor.addEventListener("focusOut",textEditor_focusOutHandler);
         this.addChild(DisplayObject(this.textEditor));
      }
      
      protected function createPrompt() : void
      {
         if(this.promptTextRenderer)
         {
            this.removeChild(DisplayObject(this.promptTextRenderer),true);
            this.promptTextRenderer = null;
         }
         if(this._prompt === null)
         {
            return;
         }
         var _loc1_:Function = this._promptFactory != null ? this._promptFactory : FeathersControl.defaultTextRendererFactory;
         this.promptTextRenderer = ITextRenderer(_loc1_());
         var _loc2_:String = this._customPromptStyleName != null ? this._customPromptStyleName : this.promptStyleName;
         this.promptTextRenderer.styleNameList.add(_loc2_);
         this.addChild(DisplayObject(this.promptTextRenderer));
      }
      
      protected function createErrorCallout() : void
      {
         if(this.callout)
         {
            this.callout.removeFromParent(true);
            this.callout = null;
         }
         if(this._errorString === null)
         {
            return;
         }
         this.callout = new TextCallout();
         var _loc1_:String = this._customErrorCalloutStyleName != null ? this._customErrorCalloutStyleName : this.errorCalloutStyleName;
         this.callout.styleNameList.add(_loc1_);
         this.callout.closeOnKeys = null;
         this.callout.closeOnTouchBeganOutside = false;
         this.callout.closeOnTouchEndedOutside = false;
         this.callout.touchable = false;
         this.callout.text = this._errorString;
         this.callout.origin = this;
         PopUpManager.addPopUp(this.callout,false,false);
      }
      
      protected function changeState(param1:String) : void
      {
         if(this._currentState === param1)
         {
            return;
         }
         this._currentState = param1;
         this.invalidate("state");
         this.dispatchEventWith("stageChange");
      }
      
      protected function doPendingActions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         if(this._isWaitingToSetFocus)
         {
            this._isWaitingToSetFocus = false;
            if(!this._textEditorHasFocus)
            {
               this.textEditor.setFocus();
            }
         }
         if(this._pendingSelectionBeginIndex >= 0)
         {
            _loc1_ = this._pendingSelectionBeginIndex;
            _loc2_ = this._pendingSelectionEndIndex;
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            if(_loc2_ >= 0)
            {
               _loc3_ = this._text.length;
               if(_loc2_ > _loc3_)
               {
                  _loc2_ = _loc3_;
               }
            }
            this.selectRange(_loc1_,_loc2_);
         }
      }
      
      protected function refreshTextEditorProperties() : void
      {
         var _loc2_:Object = null;
         this.textEditor.displayAsPassword = this._displayAsPassword;
         this.textEditor.maxChars = this._maxChars;
         this.textEditor.restrict = this._restrict;
         this.textEditor.isEditable = this._isEditable;
         this.textEditor.isSelectable = this._isSelectable;
         for(var _loc1_ in this._textEditorProperties)
         {
            _loc2_ = this._textEditorProperties[_loc1_];
            this.textEditor[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshPromptProperties() : void
      {
         var _loc2_:Object = null;
         if(!this.promptTextRenderer)
         {
            return;
         }
         this.promptTextRenderer.text = this._prompt;
         var _loc3_:DisplayObject = DisplayObject(this.promptTextRenderer);
         for(var _loc1_ in this._promptProperties)
         {
            _loc2_ = this._promptProperties[_loc1_];
            this.promptTextRenderer[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentBackground;
         this.currentBackground = this.getCurrentSkin();
         if(this.currentBackground !== _loc1_)
         {
            if(_loc1_)
            {
               if(_loc1_ is IStateObserver)
               {
                  IStateObserver(_loc1_).stateContext = null;
               }
               this.removeChild(_loc1_,false);
            }
            if(this.currentBackground)
            {
               if(this.currentBackground is IStateObserver)
               {
                  IStateObserver(this.currentBackground).stateContext = this;
               }
               this.addChildAt(this.currentBackground,0);
               if(this.currentBackground is IFeathersControl)
               {
                  IFeathersControl(this.currentBackground).initializeNow();
               }
               if(this.currentBackground is IMeasureDisplayObject)
               {
                  _loc2_ = IMeasureDisplayObject(this.currentBackground);
                  this._explicitBackgroundWidth = _loc2_.explicitWidth;
                  this._explicitBackgroundHeight = _loc2_.explicitHeight;
                  this._explicitBackgroundMinWidth = _loc2_.explicitMinWidth;
                  this._explicitBackgroundMinHeight = _loc2_.explicitMinHeight;
                  this._explicitBackgroundMaxWidth = _loc2_.explicitMaxWidth;
                  this._explicitBackgroundMaxHeight = _loc2_.explicitMaxHeight;
               }
               else
               {
                  this._explicitBackgroundWidth = this.currentBackground.width;
                  this._explicitBackgroundHeight = this.currentBackground.height;
                  this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
                  this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
               }
            }
         }
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
         if(this.currentIcon !== _loc1_)
         {
            if(_loc1_)
            {
               if(_loc1_ is IStateObserver)
               {
                  IStateObserver(_loc1_).stateContext = null;
               }
               this.removeChild(_loc1_,false);
            }
            if(this.currentIcon)
            {
               if(this.currentIcon is IStateObserver)
               {
                  IStateObserver(this.currentIcon).stateContext = this;
               }
               _loc2_ = this.getChildIndex(DisplayObject(this.textEditor));
               this.addChildAt(this.currentIcon,_loc2_);
            }
         }
         if(this.currentIcon && (this._originalIconWidth !== this._originalIconWidth || this._originalIconHeight !== this._originalIconHeight))
         {
            if(this.currentIcon is IValidating)
            {
               IValidating(this.currentIcon).validate();
            }
            this._originalIconWidth = this.currentIcon.width;
            this._originalIconHeight = this.currentIcon.height;
         }
      }
      
      protected function getCurrentSkin() : DisplayObject
      {
         if(this._stateToSkinFunction !== null)
         {
            return DisplayObject(this._stateToSkinFunction(this,this._currentState,this.currentBackground));
         }
         var _loc1_:DisplayObject = this._stateToSkin[this._currentState] as DisplayObject;
         if(_loc1_ !== null)
         {
            return _loc1_;
         }
         return this._backgroundSkin;
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
      
      protected function layoutChildren() : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this.currentBackground !== null)
         {
            this.currentBackground.visible = true;
            this.currentBackground.touchable = true;
            this.currentBackground.width = this.actualWidth;
            this.currentBackground.height = this.actualHeight;
         }
         if(this.currentIcon is IValidating)
         {
            IValidating(this.currentIcon).validate();
         }
         if(this.currentIcon !== null)
         {
            this.currentIcon.x = this._paddingLeft;
            this.textEditor.x = this.currentIcon.x + this.currentIcon.width + this._gap;
            if(this.promptTextRenderer !== null)
            {
               this.promptTextRenderer.x = this.currentIcon.x + this.currentIcon.width + this._gap;
            }
         }
         else
         {
            this.textEditor.x = this._paddingLeft;
            if(this.promptTextRenderer !== null)
            {
               this.promptTextRenderer.x = this._paddingLeft;
            }
         }
         this.textEditor.width = this.actualWidth - this._paddingRight - this.textEditor.x;
         if(this.promptTextRenderer !== null)
         {
            this.promptTextRenderer.width = this.actualWidth - this._paddingRight - this.promptTextRenderer.x;
         }
         var _loc1_:Boolean = this.textEditor is IMultilineTextEditor && Boolean(IMultilineTextEditor(this.textEditor).multiline);
         if(_loc1_ || this._verticalAlign === "justify")
         {
            this.textEditor.height = this.actualHeight - this._paddingTop - this._paddingBottom;
         }
         else
         {
            this.textEditor.height = NaN;
         }
         this.textEditor.validate();
         if(this.promptTextRenderer !== null)
         {
            this.promptTextRenderer.validate();
         }
         var _loc3_:* = Number(this.textEditor.height);
         var _loc4_:* = Number(this.textEditor.baseline);
         if(this.promptTextRenderer !== null)
         {
            _loc5_ = Number(this.promptTextRenderer.baseline);
            _loc2_ = Number(this.promptTextRenderer.height);
            if(_loc5_ > _loc4_)
            {
               _loc4_ = _loc5_;
            }
            if(_loc2_ > _loc3_)
            {
               _loc3_ = _loc2_;
            }
         }
         if(_loc1_)
         {
            this.textEditor.y = this._paddingTop + _loc4_ - this.textEditor.baseline;
            if(this.promptTextRenderer !== null)
            {
               this.promptTextRenderer.y = this._paddingTop + _loc4_ - _loc5_;
               this.promptTextRenderer.height = this.actualHeight - this.promptTextRenderer.y - this._paddingBottom;
            }
            if(this.currentIcon !== null)
            {
               this.currentIcon.y = this._paddingTop;
            }
         }
         else
         {
            switch(this._verticalAlign)
            {
               case "justify":
                  this.textEditor.y = this._paddingTop + _loc4_ - this.textEditor.baseline;
                  if(this.promptTextRenderer)
                  {
                     this.promptTextRenderer.y = this._paddingTop + _loc4_ - _loc5_;
                     this.promptTextRenderer.height = this.actualHeight - this.promptTextRenderer.y - this._paddingBottom;
                  }
                  if(this.currentIcon)
                  {
                     this.currentIcon.y = this._paddingTop;
                  }
                  break;
               case "top":
                  this.textEditor.y = this._paddingTop + _loc4_ - this.textEditor.baseline;
                  if(this.promptTextRenderer)
                  {
                     this.promptTextRenderer.y = this._paddingTop + _loc4_ - _loc5_;
                  }
                  if(this.currentIcon)
                  {
                     this.currentIcon.y = this._paddingTop;
                  }
                  break;
               case "bottom":
                  this.textEditor.y = this.actualHeight - this._paddingBottom - _loc3_ + _loc4_ - this.textEditor.baseline;
                  if(this.promptTextRenderer)
                  {
                     this.promptTextRenderer.y = this.actualHeight - this._paddingBottom - _loc3_ + _loc4_ - _loc5_;
                  }
                  if(this.currentIcon)
                  {
                     this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
                  }
                  break;
               default:
                  this.textEditor.y = _loc4_ - this.textEditor.baseline + this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - _loc3_) / 2);
                  if(this.promptTextRenderer)
                  {
                     this.promptTextRenderer.y = _loc4_ - _loc5_ + this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - _loc3_) / 2);
                  }
                  if(this.currentIcon)
                  {
                     this.currentIcon.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - this.currentIcon.height) / 2);
                  }
            }
         }
      }
      
      protected function setFocusOnTextEditorWithTouch(param1:Touch) : void
      {
         if(!this.isFocusEnabled)
         {
            return;
         }
         param1.getLocation(this.stage,HELPER_POINT);
         var _loc2_:Boolean = this.contains(this.stage.hitTest(HELPER_POINT));
         if(_loc2_ && !this._textEditorHasFocus)
         {
            this.textEditor.globalToLocal(HELPER_POINT,HELPER_POINT);
            this._isWaitingToSetFocus = false;
            this.textEditor.setFocus(HELPER_POINT);
         }
      }
      
      protected function refreshState() : void
      {
         if(this._isEnabled)
         {
            if(this._textEditorHasFocus || this._hasFocus)
            {
               this.changeState("focused");
            }
            else if(this._errorString !== null)
            {
               this.changeState("error");
            }
            else
            {
               this.changeState("enabled");
            }
         }
         else
         {
            this.changeState("disabled");
         }
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function textInput_removedFromStageHandler(param1:Event) : void
      {
         if(!this._focusManager && this._textEditorHasFocus)
         {
            this.clearFocus();
         }
         this._textEditorHasFocus = false;
         this._isWaitingToSetFocus = false;
         this._touchPointID = -1;
         if(Mouse.supportsNativeCursor && this._oldMouseCursor)
         {
            Mouse.cursor = this._oldMouseCursor;
            this._oldMouseCursor = null;
         }
      }
      
      protected function textInput_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc2_:Boolean = false;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc3_ = param1.getTouch(this,"ended",this._touchPointID);
            if(!_loc3_)
            {
               return;
            }
            _loc3_.getLocation(this.stage,HELPER_POINT);
            _loc2_ = this.contains(this.stage.hitTest(HELPER_POINT));
            if(!_loc2_)
            {
               if(Mouse.supportsNativeCursor && this._oldMouseCursor)
               {
                  Mouse.cursor = this._oldMouseCursor;
                  this._oldMouseCursor = null;
               }
            }
            this._touchPointID = -1;
            if(this.textEditor.setTouchFocusOnEndedPhase)
            {
               this.setFocusOnTextEditorWithTouch(_loc3_);
            }
         }
         else
         {
            _loc3_ = param1.getTouch(this,"began");
            if(_loc3_)
            {
               this._touchPointID = _loc3_.id;
               if(!this.textEditor.setTouchFocusOnEndedPhase)
               {
                  this.setFocusOnTextEditorWithTouch(_loc3_);
               }
               return;
            }
            _loc3_ = param1.getTouch(this,"hover");
            if(_loc3_)
            {
               if(Mouse.supportsNativeCursor && !this._oldMouseCursor)
               {
                  this._oldMouseCursor = Mouse.cursor;
                  Mouse.cursor = "ibeam";
               }
               return;
            }
            if(Mouse.supportsNativeCursor && this._oldMouseCursor)
            {
               Mouse.cursor = this._oldMouseCursor;
               this._oldMouseCursor = null;
            }
         }
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         if(!this._focusManager)
         {
            return;
         }
         super.focusInHandler(param1);
         this.refreshState();
         this.setFocus();
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         if(!this._focusManager)
         {
            return;
         }
         super.focusOutHandler(param1);
         this.refreshState();
         this.textEditor.clearFocus();
      }
      
      protected function textEditor_changeHandler(param1:Event) : void
      {
         if(this._ignoreTextChanges)
         {
            return;
         }
         this.text = this.textEditor.text;
      }
      
      protected function textEditor_enterHandler(param1:Event) : void
      {
         this.dispatchEventWith("enter");
      }
      
      protected function textEditor_focusInHandler(param1:Event) : void
      {
         if(!this.visible)
         {
            this.textEditor.clearFocus();
            return;
         }
         this._textEditorHasFocus = true;
         this.refreshState();
         if(this._errorString !== null && this._errorString.length > 0)
         {
            this.createErrorCallout();
         }
         if(this._focusManager !== null && this.isFocusEnabled)
         {
            if(this._focusManager.focus !== this)
            {
               this._focusManager.focus = this;
            }
         }
         else
         {
            this.dispatchEventWith("focusIn");
         }
      }
      
      protected function textEditor_focusOutHandler(param1:Event) : void
      {
         this._textEditorHasFocus = false;
         this.refreshState();
         if(this.callout)
         {
            this.callout.removeFromParent(true);
            this.callout = null;
         }
         if(this._focusManager !== null && this.isFocusEnabled)
         {
            if(this._focusManager.focus === this)
            {
               this._focusManager.focus = null;
            }
         }
         else
         {
            this.dispatchEventWith("focusOut");
         }
      }
   }
}
