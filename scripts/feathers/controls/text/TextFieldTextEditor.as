package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.FocusManager;
   import feathers.core.INativeFocusOwner;
   import feathers.core.IStateContext;
   import feathers.core.IStateObserver;
   import feathers.core.ITextEditor;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.stageToStarling;
   import feathers.utils.geom.matrixToRotation;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.rendering.Painter;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.utils.MathUtil;
   import starling.utils.MatrixUtil;
   
   public class TextFieldTextEditor extends FeathersControl implements ITextEditor, INativeFocusOwner, IStateObserver
   {
      
      private static var HELPER_MATRIX3D:Matrix3D;
      
      private static var HELPER_POINT3D:Vector3D;
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var textField:TextField;
      
      protected var textSnapshot:Image;
      
      protected var measureTextField:TextField;
      
      protected var _snapshotWidth:int = 0;
      
      protected var _snapshotHeight:int = 0;
      
      protected var _textFieldSnapshotClipRect:Rectangle;
      
      protected var _textFieldOffsetX:Number = 0;
      
      protected var _textFieldOffsetY:Number = 0;
      
      protected var _lastGlobalScaleX:Number = 0;
      
      protected var _lastGlobalScaleY:Number = 0;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _previousTextFormat:TextFormat;
      
      protected var currentTextFormat:TextFormat;
      
      protected var _textFormatForState:Object;
      
      protected var _textFormat:TextFormat;
      
      protected var _disabledTextFormat:TextFormat;
      
      protected var _embedFonts:Boolean = false;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _multiline:Boolean = false;
      
      protected var _isHTML:Boolean = false;
      
      protected var _alwaysShowSelection:Boolean = false;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _maxChars:int = 0;
      
      protected var _restrict:String;
      
      protected var _isEditable:Boolean = true;
      
      protected var _isSelectable:Boolean = true;
      
      private var _antiAliasType:String = "advanced";
      
      private var _gridFitType:String = "pixel";
      
      private var _sharpness:Number = 0;
      
      private var _thickness:Number = 0;
      
      private var _background:Boolean = false;
      
      private var _backgroundColor:uint = 16777215;
      
      private var _border:Boolean = false;
      
      private var _borderColor:uint = 0;
      
      protected var _useGutter:Boolean = false;
      
      protected var _textFieldHasFocus:Boolean = false;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionBeginIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var _stateContext:IStateContext;
      
      protected var _updateSnapshotOnScaleChange:Boolean = false;
      
      protected var _useSnapshotDelayWorkaround:Boolean = false;
      
      protected var resetScrollOnFocusOut:Boolean = true;
      
      public function TextFieldTextEditor()
      {
         _textFieldSnapshotClipRect = new Rectangle();
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("addedToStage",textEditor_addedToStageHandler);
         this.addEventListener("removedFromStage",textEditor_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return globalStyleProvider;
      }
      
      public function get nativeFocus() : Object
      {
         return this.textField;
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
         if(!this.textField)
         {
            return 0;
         }
         var _loc1_:Number = 0;
         if(this._useGutter)
         {
            _loc1_ = 2;
         }
         return _loc1_ + this.textField.getLineMetrics(0).ascent;
      }
      
      public function get textFormat() : TextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this._previousTextFormat = null;
         this.invalidate("styles");
      }
      
      public function get disabledTextFormat() : TextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:TextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate("styles");
      }
      
      public function get embedFonts() : Boolean
      {
         return this._embedFonts;
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         if(this._embedFonts == param1)
         {
            return;
         }
         this._embedFonts = param1;
         this.invalidate("styles");
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this._wordWrap == param1)
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate("styles");
      }
      
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         if(this._multiline == param1)
         {
            return;
         }
         this._multiline = param1;
         this.invalidate("styles");
      }
      
      public function get isHTML() : Boolean
      {
         return this._isHTML;
      }
      
      public function set isHTML(param1:Boolean) : void
      {
         if(this._isHTML == param1)
         {
            return;
         }
         this._isHTML = param1;
         this.invalidate("data");
      }
      
      public function get alwaysShowSelection() : Boolean
      {
         return this._alwaysShowSelection;
      }
      
      public function set alwaysShowSelection(param1:Boolean) : void
      {
         if(this._alwaysShowSelection == param1)
         {
            return;
         }
         this._alwaysShowSelection = param1;
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
      
      public function get antiAliasType() : String
      {
         return this._antiAliasType;
      }
      
      public function set antiAliasType(param1:String) : void
      {
         if(this._antiAliasType == param1)
         {
            return;
         }
         this._antiAliasType = param1;
         this.invalidate("styles");
      }
      
      public function get gridFitType() : String
      {
         return this._gridFitType;
      }
      
      public function set gridFitType(param1:String) : void
      {
         if(this._gridFitType == param1)
         {
            return;
         }
         this._gridFitType = param1;
         this.invalidate("styles");
      }
      
      public function get sharpness() : Number
      {
         return this._sharpness;
      }
      
      public function set sharpness(param1:Number) : void
      {
         if(this._sharpness == param1)
         {
            return;
         }
         this._sharpness = param1;
         this.invalidate("data");
      }
      
      public function get thickness() : Number
      {
         return this._thickness;
      }
      
      public function set thickness(param1:Number) : void
      {
         if(this._thickness == param1)
         {
            return;
         }
         this._thickness = param1;
         this.invalidate("data");
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function set background(param1:Boolean) : void
      {
         if(this._background == param1)
         {
            return;
         }
         this._background = param1;
         this.invalidate("styles");
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         if(this._backgroundColor == param1)
         {
            return;
         }
         this._backgroundColor = param1;
         this.invalidate("styles");
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set border(param1:Boolean) : void
      {
         if(this._border == param1)
         {
            return;
         }
         this._border = param1;
         this.invalidate("styles");
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function set borderColor(param1:uint) : void
      {
         if(this._borderColor == param1)
         {
            return;
         }
         this._borderColor = param1;
         this.invalidate("styles");
      }
      
      public function get useGutter() : Boolean
      {
         return this._useGutter;
      }
      
      public function set useGutter(param1:Boolean) : void
      {
         if(this._useGutter == param1)
         {
            return;
         }
         this._useGutter = param1;
         this.invalidate("styles");
      }
      
      public function get setTouchFocusOnEndedPhase() : Boolean
      {
         return false;
      }
      
      public function get selectionBeginIndex() : int
      {
         if(this._pendingSelectionBeginIndex >= 0)
         {
            return this._pendingSelectionBeginIndex;
         }
         if(this.textField)
         {
            return this.textField.selectionBeginIndex;
         }
         return 0;
      }
      
      public function get selectionEndIndex() : int
      {
         if(this._pendingSelectionEndIndex >= 0)
         {
            return this._pendingSelectionEndIndex;
         }
         if(this.textField)
         {
            return this.textField.selectionEndIndex;
         }
         return 0;
      }
      
      public function get stateContext() : IStateContext
      {
         return this._stateContext;
      }
      
      public function set stateContext(param1:IStateContext) : void
      {
         if(this._stateContext === param1)
         {
            return;
         }
         if(this._stateContext)
         {
            this._stateContext.removeEventListener("stageChange",stateContext_stateChangeHandler);
         }
         this._stateContext = param1;
         if(this._stateContext)
         {
            this._stateContext.addEventListener("stageChange",stateContext_stateChangeHandler);
         }
         this.invalidate("state");
      }
      
      public function get updateSnapshotOnScaleChange() : Boolean
      {
         return this._updateSnapshotOnScaleChange;
      }
      
      public function set updateSnapshotOnScaleChange(param1:Boolean) : void
      {
         if(this._updateSnapshotOnScaleChange == param1)
         {
            return;
         }
         this._updateSnapshotOnScaleChange = param1;
         this.invalidate("data");
      }
      
      public function get useSnapshotDelayWorkaround() : Boolean
      {
         return this._useSnapshotDelayWorkaround;
      }
      
      public function set useSnapshotDelayWorkaround(param1:Boolean) : void
      {
         if(this._useSnapshotDelayWorkaround == param1)
         {
            return;
         }
         this._useSnapshotDelayWorkaround = param1;
         this.invalidate("data");
      }
      
      override public function dispose() : void
      {
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         if(this.textField)
         {
            if(this.textField.parent)
            {
               this.textField.parent.removeChild(this.textField);
            }
            this.textField.removeEventListener("change",textField_changeHandler);
            this.textField.removeEventListener("focusIn",textField_focusInHandler);
            this.textField.removeEventListener("focusOut",textField_focusOutHandler);
            this.textField.removeEventListener("keyDown",textField_keyDownHandler);
            this.textField.removeEventListener("softKeyboardActivate",textField_softKeyboardActivateHandler);
            this.textField.removeEventListener("softKeyboardDeactivate",textField_softKeyboardDeactivateHandler);
         }
         this.textField = null;
         this.measureTextField = null;
         this.stateContext = null;
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         if(this.textSnapshot)
         {
            if(this._updateSnapshotOnScaleChange)
            {
               this.getTransformationMatrix(this.stage,HELPER_MATRIX);
               if(matrixToScaleX(HELPER_MATRIX) != this._lastGlobalScaleX || matrixToScaleY(HELPER_MATRIX) != this._lastGlobalScaleY)
               {
                  this.invalidate("size");
                  this.validate();
               }
            }
            this.positionSnapshot();
         }
         if(this.textField && this.textField.visible)
         {
            this.transformTextField();
         }
         super.render(param1);
      }
      
      public function setFocus(param1:Point = null) : void
      {
         var _loc6_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc7_:* = NaN;
         var _loc9_:* = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc5_:int = 0;
         var _loc13_:Rectangle = null;
         var _loc11_:Number = NaN;
         if(this.textField)
         {
            if(!this.textField.parent)
            {
               Starling.current.nativeStage.addChild(this.textField);
            }
            if(param1 !== null)
            {
               _loc6_ = 1;
               if(Starling.current.supportHighResolutions)
               {
                  _loc6_ = Starling.current.nativeStage.contentsScaleFactor;
               }
               _loc4_ = Starling.contentScaleFactor / _loc6_;
               _loc8_ = this.textField.scaleX;
               _loc10_ = this.textField.scaleY;
               _loc12_ = 2;
               if(this._useGutter)
               {
                  _loc12_ = 0;
               }
               _loc7_ = param1.x + _loc12_;
               _loc9_ = param1.y + _loc12_;
               if(_loc7_ < _loc12_)
               {
                  _loc7_ = _loc12_;
               }
               else
               {
                  _loc2_ = this.textField.width / _loc8_ - _loc12_;
                  if(_loc7_ > _loc2_)
                  {
                     _loc7_ = _loc2_;
                  }
               }
               if(_loc9_ < _loc12_)
               {
                  _loc9_ = _loc12_;
               }
               else
               {
                  _loc3_ = this.textField.height / _loc10_ - _loc12_;
                  if(_loc9_ > _loc3_)
                  {
                     _loc9_ = _loc3_;
                  }
               }
               this._pendingSelectionBeginIndex = this.getSelectionIndexAtPoint(_loc7_,_loc9_);
               if(this._pendingSelectionBeginIndex < 0)
               {
                  if(this._multiline)
                  {
                     _loc5_ = this.textField.getLineIndexAtPoint(this.textField.width / 2 / _loc8_,_loc9_);
                     try
                     {
                        this._pendingSelectionBeginIndex = this.textField.getLineOffset(_loc5_) + this.textField.getLineLength(_loc5_);
                        if(this._pendingSelectionBeginIndex != this._text.length)
                        {
                           this._pendingSelectionBeginIndex--;
                        }
                     }
                     catch(error:Error)
                     {
                        this._pendingSelectionBeginIndex = this._text.length;
                     }
                  }
                  else
                  {
                     this._pendingSelectionBeginIndex = this.getSelectionIndexAtPoint(_loc7_,this.textField.getLineMetrics(0).ascent / 2);
                     if(this._pendingSelectionBeginIndex < 0)
                     {
                        this._pendingSelectionBeginIndex = this._text.length;
                     }
                  }
               }
               else if(_loc13_ = this.textField.getCharBoundaries(this._pendingSelectionBeginIndex))
               {
                  _loc11_ = _loc13_.x;
                  if(_loc13_ && _loc11_ + _loc13_.width - _loc7_ < _loc7_ - _loc11_)
                  {
                     this._pendingSelectionBeginIndex++;
                  }
               }
               this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
            }
            else
            {
               this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
            }
            if(!FocusManager.isEnabledForStage(this.stage))
            {
               Starling.current.nativeStage.focus = this.textField;
            }
            this.textField.requestSoftKeyboard();
            if(this._textFieldHasFocus)
            {
               this.invalidate("selected");
            }
         }
         else
         {
            this._isWaitingToSetFocus = true;
         }
      }
      
      public function clearFocus() : void
      {
         if(!this._textFieldHasFocus)
         {
            return;
         }
         var _loc1_:Stage = Starling.current.nativeStage;
         if(_loc1_.focus === this.textField)
         {
            _loc1_.focus = null;
         }
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         if(!this._isEditable && !this._isSelectable)
         {
            return;
         }
         if(this.textField)
         {
            if(!this._isValidating)
            {
               this.validate();
            }
            this.textField.setSelection(param1,param2);
         }
         else
         {
            this._pendingSelectionBeginIndex = param1;
            this._pendingSelectionEndIndex = param2;
         }
      }
      
      public function measureText(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:* = this._explicitWidth !== this._explicitWidth;
         var _loc3_:* = this._explicitHeight !== this._explicitHeight;
         if(!_loc2_ && !_loc3_)
         {
            param1.x = this._explicitWidth;
            param1.y = this._explicitHeight;
            return param1;
         }
         if(!this._isInitialized)
         {
            this.initializeNow();
         }
         this.commit();
         return this.measure(param1);
      }
      
      public function setTextFormatForState(param1:String, param2:TextFormat) : void
      {
         if(param2)
         {
            if(!this._textFormatForState)
            {
               this._textFormatForState = {};
            }
            this._textFormatForState[param1] = param2;
         }
         else
         {
            delete this._textFormatForState[param1];
         }
         if(this._stateContext && this._stateContext.currentState === param1)
         {
            this.invalidate("state");
         }
      }
      
      override protected function initialize() : void
      {
         this.textField = new TextField();
         this.textField.tabEnabled = false;
         this.textField.visible = false;
         this.textField.needsSoftKeyboard = true;
         this.textField.addEventListener("change",textField_changeHandler);
         this.textField.addEventListener("focusIn",textField_focusInHandler);
         this.textField.addEventListener("focusOut",textField_focusOutHandler);
         this.textField.addEventListener("keyDown",textField_keyDownHandler);
         this.textField.addEventListener("softKeyboardActivate",textField_softKeyboardActivateHandler);
         this.textField.addEventListener("softKeyboardDeactivate",textField_softKeyboardDeactivateHandler);
         this.measureTextField = new TextField();
         this.measureTextField.autoSize = "left";
         this.measureTextField.selectable = false;
         this.measureTextField.tabEnabled = false;
         this.measureTextField.mouseWheelEnabled = false;
         this.measureTextField.mouseEnabled = false;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         this.commit();
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layout(_loc1_);
      }
      
      protected function commit() : void
      {
         var _loc2_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc1_:Boolean = this.isInvalid("state");
         if(_loc3_ || _loc2_ || _loc1_)
         {
            this.refreshTextFormat();
            this.commitStylesAndData(this.textField);
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:* = this._explicitWidth !== this._explicitWidth;
         var _loc3_:* = this._explicitHeight !== this._explicitHeight;
         var _loc2_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc3_ && !_loc2_ && !_loc4_)
         {
            return false;
         }
         this.measure(HELPER_POINT);
         return this.saveMeasurements(HELPER_POINT.x,HELPER_POINT.y,HELPER_POINT.x,HELPER_POINT.y);
      }
      
      protected function measure(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc5_:* = this._explicitHeight !== this._explicitHeight;
         if(!_loc3_ && !_loc5_)
         {
            param1.x = this._explicitWidth;
            param1.y = this._explicitHeight;
            return param1;
         }
         this.commitStylesAndData(this.measureTextField);
         var _loc6_:Number = 4;
         if(this._useGutter)
         {
            _loc6_ = 0;
         }
         var _loc2_:Number = this._explicitWidth;
         if(_loc3_)
         {
            this.measureTextField.wordWrap = false;
            _loc2_ = this.measureTextField.width - _loc6_;
            if(_loc2_ < this._explicitMinWidth)
            {
               _loc2_ = this._explicitMinWidth;
            }
            else if(_loc2_ > this._explicitMaxWidth)
            {
               _loc2_ = this._explicitMaxWidth;
            }
         }
         var _loc4_:Number = this._explicitHeight;
         if(_loc5_)
         {
            this.measureTextField.wordWrap = this._wordWrap;
            this.measureTextField.width = _loc2_ + _loc6_;
            _loc4_ = this.measureTextField.height - _loc6_;
            if(this._useGutter)
            {
               _loc4_ += 4;
            }
            if(_loc4_ < this._explicitMinHeight)
            {
               _loc4_ = this._explicitMinHeight;
            }
            else if(_loc4_ > this._explicitMaxHeight)
            {
               _loc4_ = this._explicitMaxHeight;
            }
         }
         param1.x = _loc2_;
         param1.y = _loc4_;
         return param1;
      }
      
      protected function commitStylesAndData(param1:TextField) : void
      {
         var _loc2_:* = false;
         param1.antiAliasType = this._antiAliasType;
         param1.background = this._background;
         param1.backgroundColor = this._backgroundColor;
         param1.border = this._border;
         param1.borderColor = this._borderColor;
         param1.gridFitType = this._gridFitType;
         param1.sharpness = this._sharpness;
         param1.thickness = this._thickness;
         param1.maxChars = this._maxChars;
         param1.restrict = this._restrict;
         param1.alwaysShowSelection = this._alwaysShowSelection;
         param1.displayAsPassword = this._displayAsPassword;
         param1.wordWrap = this._wordWrap;
         param1.multiline = this._multiline;
         param1.embedFonts = this._embedFonts;
         param1.type = this._isEditable ? "input" : "dynamic";
         param1.selectable = this._isEnabled && (this._isEditable || this._isSelectable);
         if(param1 === this.textField)
         {
            _loc2_ = this._previousTextFormat != this.currentTextFormat;
            this._previousTextFormat = this.currentTextFormat;
         }
         param1.defaultTextFormat = this.currentTextFormat;
         if(this._isHTML)
         {
            if(_loc2_ || param1.htmlText != this._text)
            {
               if(param1 == this.textField && this._pendingSelectionBeginIndex < 0)
               {
                  this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
                  this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
               }
               param1.htmlText = this._text;
            }
         }
         else if(_loc2_ || param1.text != this._text)
         {
            if(param1 == this.textField && this._pendingSelectionBeginIndex < 0)
            {
               this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
               this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
            }
            param1.text = this._text;
         }
      }
      
      protected function refreshTextFormat() : void
      {
         var _loc2_:TextFormat = null;
         var _loc1_:String = null;
         if(this._stateContext && this._textFormatForState)
         {
            _loc1_ = this._stateContext.currentState;
            if(_loc1_ in this._textFormatForState)
            {
               _loc2_ = TextFormat(this._textFormatForState[_loc1_]);
            }
         }
         if(!_loc2_ && !this._isEnabled && this._disabledTextFormat)
         {
            _loc2_ = this._disabledTextFormat;
         }
         if(!_loc2_)
         {
            if(!this._textFormat)
            {
               this._textFormat = new TextFormat();
            }
            _loc2_ = this._textFormat;
         }
         this.currentTextFormat = _loc2_;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc4_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("state");
         if(param1)
         {
            this.refreshSnapshotParameters();
            this.refreshTextFieldSize();
            this.transformTextField();
            this.positionSnapshot();
         }
         this.checkIfNewSnapshotIsNeeded();
         if(!this._textFieldHasFocus && (param1 || _loc3_ || _loc4_ || _loc2_ || this._needsNewTexture))
         {
            if(this._useSnapshotDelayWorkaround)
            {
               this.addEventListener("enterFrame",refreshSnapshot_enterFrameHandler);
            }
            else
            {
               this.refreshSnapshot();
            }
         }
         this.doPendingActions();
      }
      
      protected function getSelectionIndexAtPoint(param1:Number, param2:Number) : int
      {
         return this.textField.getCharIndexAtPoint(param1,param2);
      }
      
      protected function refreshTextFieldSize() : void
      {
         var _loc1_:Number = 4;
         if(this._useGutter)
         {
            _loc1_ = 0;
         }
         this.textField.width = this.actualWidth + _loc1_;
         this.textField.height = this.actualHeight + _loc1_;
      }
      
      protected function refreshSnapshotParameters() : void
      {
         this._textFieldOffsetX = 0;
         this._textFieldOffsetY = 0;
         this._textFieldSnapshotClipRect.x = 0;
         this._textFieldSnapshotClipRect.y = 0;
         var _loc1_:Number = Starling.contentScaleFactor;
         var _loc2_:Number = this.actualWidth * _loc1_;
         if(this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            _loc2_ *= matrixToScaleX(HELPER_MATRIX);
         }
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         var _loc3_:Number = this.actualHeight * _loc1_;
         if(this._updateSnapshotOnScaleChange)
         {
            _loc3_ *= matrixToScaleY(HELPER_MATRIX);
         }
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         this._textFieldSnapshotClipRect.width = _loc2_;
         this._textFieldSnapshotClipRect.height = _loc3_;
      }
      
      protected function transformTextField() : void
      {
         HELPER_POINT.x = HELPER_POINT.y = 0;
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         var _loc3_:Number = matrixToScaleX(HELPER_MATRIX);
         var _loc5_:Number = matrixToScaleY(HELPER_MATRIX);
         var _loc2_:* = _loc3_;
         if(_loc5_ < _loc2_)
         {
            _loc2_ = _loc5_;
         }
         var _loc1_:Starling = stageToStarling(this.stage);
         if(_loc1_ === null)
         {
            _loc1_ = Starling.current;
         }
         var _loc8_:Number = 1;
         if(_loc1_.supportHighResolutions)
         {
            _loc8_ = _loc1_.nativeStage.contentsScaleFactor;
         }
         var _loc6_:Number = _loc1_.contentScaleFactor / _loc8_;
         var _loc7_:Number = 0;
         if(!this._useGutter)
         {
            _loc7_ = 2 * _loc2_;
         }
         if(this.is3D)
         {
            HELPER_MATRIX3D = this.getTransformationMatrix3D(this.stage,HELPER_MATRIX3D);
            HELPER_POINT3D = MatrixUtil.transformCoords3D(HELPER_MATRIX3D,-_loc7_,-_loc7_,0,HELPER_POINT3D);
            HELPER_POINT.setTo(HELPER_POINT3D.x,HELPER_POINT3D.y);
         }
         else
         {
            MatrixUtil.transformCoords(HELPER_MATRIX,-_loc7_,-_loc7_,HELPER_POINT);
         }
         var _loc4_:Rectangle = _loc1_.viewPort;
         this.textField.x = Math.round(_loc4_.x + HELPER_POINT.x * _loc6_);
         this.textField.y = Math.round(_loc4_.y + HELPER_POINT.y * _loc6_);
         this.textField.rotation = matrixToRotation(HELPER_MATRIX) * 180 / 3.141592653589793;
         this.textField.scaleX = matrixToScaleX(HELPER_MATRIX) * _loc6_;
         this.textField.scaleY = matrixToScaleY(HELPER_MATRIX) * _loc6_;
      }
      
      protected function positionSnapshot() : void
      {
         if(!this.textSnapshot)
         {
            return;
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
         this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
      }
      
      protected function checkIfNewSnapshotIsNeeded() : void
      {
         var _loc1_:* = Starling.current.profile != "baselineConstrained";
         if(_loc1_)
         {
            this._snapshotWidth = this._textFieldSnapshotClipRect.width;
            this._snapshotHeight = this._textFieldSnapshotClipRect.height;
         }
         else
         {
            this._snapshotWidth = MathUtil.getNextPowerOfTwo(this._textFieldSnapshotClipRect.width);
            this._snapshotHeight = MathUtil.getNextPowerOfTwo(this._textFieldSnapshotClipRect.height);
         }
         var _loc2_:ConcreteTexture = !!this.textSnapshot ? this.textSnapshot.texture.root : null;
         this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || _loc2_.scale != Starling.contentScaleFactor || this._snapshotWidth != _loc2_.width || this._snapshotHeight != _loc2_.height;
      }
      
      protected function doPendingActions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._isWaitingToSetFocus)
         {
            this._isWaitingToSetFocus = false;
            this.setFocus();
         }
         if(this._pendingSelectionBeginIndex >= 0)
         {
            _loc1_ = this._pendingSelectionBeginIndex;
            _loc2_ = this._pendingSelectionEndIndex;
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.selectRange(_loc1_,_loc2_);
         }
      }
      
      protected function texture_onRestore() : void
      {
         if(this.textSnapshot && this.textSnapshot.texture && this.textSnapshot.texture.scale != Starling.contentScaleFactor)
         {
            this.invalidate("size");
         }
         else
         {
            this.refreshSnapshot();
         }
      }
      
      protected function refreshSnapshot() : void
      {
         var _loc1_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc7_:Texture = null;
         var _loc6_:Texture = null;
         if(this._snapshotWidth <= 0 || this._snapshotHeight <= 0)
         {
            return;
         }
         var _loc5_:Number = 2;
         if(this._useGutter)
         {
            _loc5_ = 0;
         }
         var _loc3_:Number = Starling.contentScaleFactor;
         if(this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            _loc1_ = matrixToScaleX(HELPER_MATRIX);
            _loc4_ = matrixToScaleY(HELPER_MATRIX);
         }
         HELPER_MATRIX.identity();
         HELPER_MATRIX.translate(this._textFieldOffsetX - _loc5_,this._textFieldOffsetY - _loc5_);
         HELPER_MATRIX.scale(_loc3_,_loc3_);
         if(this._updateSnapshotOnScaleChange)
         {
            HELPER_MATRIX.scale(_loc1_,_loc4_);
         }
         var _loc2_:BitmapData = new BitmapData(this._snapshotWidth,this._snapshotHeight,true,16711935);
         _loc2_.draw(this.textField,HELPER_MATRIX,null,null,this._textFieldSnapshotClipRect);
         if(!this.textSnapshot || this._needsNewTexture)
         {
            (_loc7_ = Texture.empty(_loc2_.width / _loc3_,_loc2_.height / _loc3_,true,false,false,_loc3_)).root.uploadBitmapData(_loc2_);
            _loc7_.root.onRestore = texture_onRestore;
         }
         if(!this.textSnapshot)
         {
            this.textSnapshot = new Image(_loc7_);
            this.textSnapshot.pixelSnapping = true;
            this.addChild(this.textSnapshot);
         }
         else if(this._needsNewTexture)
         {
            this.textSnapshot.texture.dispose();
            this.textSnapshot.texture = _loc7_;
            this.textSnapshot.readjustSize();
         }
         else
         {
            (_loc6_ = this.textSnapshot.texture).root.uploadBitmapData(_loc2_);
         }
         if(this._updateSnapshotOnScaleChange)
         {
            this.textSnapshot.scaleX = 1 / _loc1_;
            this.textSnapshot.scaleY = 1 / _loc4_;
            this._lastGlobalScaleX = _loc1_;
            this._lastGlobalScaleY = _loc4_;
         }
         this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
         _loc2_.dispose();
         this._needsNewTexture = false;
      }
      
      protected function textEditor_addedToStageHandler(param1:starling.events.Event) : void
      {
         if(!this.textField.parent)
         {
            Starling.current.nativeStage.addChild(this.textField);
         }
      }
      
      protected function textEditor_removedFromStageHandler(param1:starling.events.Event) : void
      {
         if(this.textField.parent)
         {
            this.textField.parent.removeChild(this.textField);
         }
      }
      
      protected function hasFocus_enterFrameHandler(param1:starling.events.Event) : void
      {
         var _loc2_:DisplayObject = null;
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = !this._textFieldHasFocus;
         }
         this.textField.visible = this._textFieldHasFocus;
         if(this._textFieldHasFocus)
         {
            _loc2_ = this;
            do
            {
               if(!_loc2_.visible)
               {
                  this.clearFocus();
                  break;
               }
               _loc2_ = _loc2_.parent;
            }
            while(_loc2_);
            
         }
         else
         {
            this.removeEventListener("enterFrame",hasFocus_enterFrameHandler);
         }
      }
      
      protected function refreshSnapshot_enterFrameHandler(param1:starling.events.Event) : void
      {
         this.removeEventListener("enterFrame",refreshSnapshot_enterFrameHandler);
         this.refreshSnapshot();
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = param1.getTouch(this.stage,"began");
         if(!_loc3_)
         {
            return;
         }
         _loc3_.getLocation(this.stage,HELPER_POINT);
         var _loc2_:Boolean = this.contains(this.stage.hitTest(HELPER_POINT));
         if(_loc2_)
         {
            return;
         }
         this.clearFocus();
      }
      
      protected function textField_changeHandler(param1:flash.events.Event) : void
      {
         if(this._isHTML)
         {
            this.text = this.textField.htmlText;
         }
         else
         {
            this.text = this.textField.text;
         }
      }
      
      protected function textField_focusInHandler(param1:FocusEvent) : void
      {
         this._textFieldHasFocus = true;
         this.stage.addEventListener("touch",stage_touchHandler);
         this.addEventListener("enterFrame",hasFocus_enterFrameHandler);
         this.dispatchEventWith("focusIn");
      }
      
      protected function textField_focusOutHandler(param1:FocusEvent) : void
      {
         this._textFieldHasFocus = false;
         this.stage.removeEventListener("touch",stage_touchHandler);
         if(this.resetScrollOnFocusOut)
         {
            this.textField.scrollH = this.textField.scrollV = 0;
         }
         this.invalidate("data");
         this.dispatchEventWith("focusOut");
      }
      
      protected function textField_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.dispatchEventWith("enter");
         }
         else if(!FocusManager.isEnabledForStage(this.stage) && param1.keyCode == 9)
         {
            this.clearFocus();
         }
      }
      
      protected function textField_softKeyboardActivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith("softKeyboardActivate",true);
      }
      
      protected function textField_softKeyboardDeactivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith("softKeyboardDeactivate",true);
      }
      
      protected function stateContext_stateChangeHandler(param1:starling.events.Event) : void
      {
         this.invalidate("state");
      }
   }
}
