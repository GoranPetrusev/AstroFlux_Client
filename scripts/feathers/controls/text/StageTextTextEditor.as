package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.FocusManager;
   import feathers.core.IMultilineTextEditor;
   import feathers.core.INativeFocusOwner;
   import feathers.skins.IStyleProvider;
   import feathers.text.StageTextField;
   import feathers.utils.display.stageToStarling;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getDefinitionByName;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.utils.MatrixUtil;
   import starling.utils.SystemUtil;
   
   public class StageTextTextEditor extends FeathersControl implements IMultilineTextEditor, INativeFocusOwner
   {
      
      private static var HELPER_MATRIX3D:Matrix3D;
      
      private static var HELPER_POINT3D:Vector3D;
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var stageText:Object;
      
      protected var textSnapshot:Image;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _ignoreStageTextChanges:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _measureTextField:TextField;
      
      protected var _stageTextIsTextField:Boolean = false;
      
      protected var _stageTextHasFocus:Boolean = false;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionBeginIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var _stageTextIsComplete:Boolean = false;
      
      protected var _autoCapitalize:String = "none";
      
      protected var _autoCorrect:Boolean = false;
      
      protected var _color:uint = 0;
      
      protected var _disabledColor:uint = 10066329;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _isEditable:Boolean = true;
      
      protected var _isSelectable:Boolean = true;
      
      protected var _fontFamily:String = null;
      
      protected var _fontPosture:String = "normal";
      
      protected var _fontSize:int = 12;
      
      protected var _fontWeight:String = "normal";
      
      protected var _locale:String = "en";
      
      protected var _maxChars:int = 0;
      
      protected var _multiline:Boolean = false;
      
      protected var _restrict:String;
      
      protected var _returnKeyLabel:String = "default";
      
      protected var _softKeyboardType:String = "default";
      
      protected var _textAlign:String = "start";
      
      protected var _lastGlobalScaleX:Number = 0;
      
      protected var _lastGlobalScaleY:Number = 0;
      
      protected var _updateSnapshotOnScaleChange:Boolean = false;
      
      public function StageTextTextEditor()
      {
         super();
         this._stageTextIsTextField = /^(Windows|Mac OS|Linux) .*/.exec(Capabilities.os) || Capabilities.playerType === "Desktop" && Capabilities.isDebugger;
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("removedFromStage",textEditor_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return globalStyleProvider;
      }
      
      public function get nativeFocus() : Object
      {
         if(!this._isEditable)
         {
            return null;
         }
         return this.stageText;
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
      
      public function get selectionBeginIndex() : int
      {
         if(this._pendingSelectionBeginIndex >= 0)
         {
            return this._pendingSelectionBeginIndex;
         }
         if(this.stageText)
         {
            return this.stageText.selectionAnchorIndex;
         }
         return 0;
      }
      
      public function get selectionEndIndex() : int
      {
         if(this._pendingSelectionEndIndex >= 0)
         {
            return this._pendingSelectionEndIndex;
         }
         if(this.stageText)
         {
            return this.stageText.selectionActiveIndex;
         }
         return 0;
      }
      
      public function get baseline() : Number
      {
         if(!this._measureTextField)
         {
            return 0;
         }
         return this._measureTextField.getLineMetrics(0).ascent;
      }
      
      public function get autoCapitalize() : String
      {
         return this._autoCapitalize;
      }
      
      public function set autoCapitalize(param1:String) : void
      {
         if(this._autoCapitalize == param1)
         {
            return;
         }
         this._autoCapitalize = param1;
         this.invalidate("styles");
      }
      
      public function get autoCorrect() : Boolean
      {
         return this._autoCorrect;
      }
      
      public function set autoCorrect(param1:Boolean) : void
      {
         if(this._autoCorrect == param1)
         {
            return;
         }
         this._autoCorrect = param1;
         this.invalidate("styles");
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color == param1)
         {
            return;
         }
         this._color = param1;
         this.invalidate("styles");
      }
      
      public function get disabledColor() : uint
      {
         return this._disabledColor;
      }
      
      public function set disabledColor(param1:uint) : void
      {
         if(this._disabledColor == param1)
         {
            return;
         }
         this._disabledColor = param1;
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
      
      public function get setTouchFocusOnEndedPhase() : Boolean
      {
         return true;
      }
      
      public function get fontFamily() : String
      {
         return this._fontFamily;
      }
      
      public function set fontFamily(param1:String) : void
      {
         if(this._fontFamily == param1)
         {
            return;
         }
         this._fontFamily = param1;
         this.invalidate("styles");
      }
      
      public function get fontPosture() : String
      {
         return this._fontPosture;
      }
      
      public function set fontPosture(param1:String) : void
      {
         if(this._fontPosture == param1)
         {
            return;
         }
         this._fontPosture = param1;
         this.invalidate("styles");
      }
      
      public function get fontSize() : int
      {
         return this._fontSize;
      }
      
      public function set fontSize(param1:int) : void
      {
         if(this._fontSize == param1)
         {
            return;
         }
         this._fontSize = param1;
         this.invalidate("styles");
      }
      
      public function get fontWeight() : String
      {
         return this._fontWeight;
      }
      
      public function set fontWeight(param1:String) : void
      {
         if(this._fontWeight == param1)
         {
            return;
         }
         this._fontWeight = param1;
         this.invalidate("styles");
      }
      
      public function get locale() : String
      {
         return this._locale;
      }
      
      public function set locale(param1:String) : void
      {
         if(this._locale == param1)
         {
            return;
         }
         this._locale = param1;
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
      
      public function get returnKeyLabel() : String
      {
         return this._returnKeyLabel;
      }
      
      public function set returnKeyLabel(param1:String) : void
      {
         if(this._returnKeyLabel == param1)
         {
            return;
         }
         this._returnKeyLabel = param1;
         this.invalidate("styles");
      }
      
      public function get softKeyboardType() : String
      {
         return this._softKeyboardType;
      }
      
      public function set softKeyboardType(param1:String) : void
      {
         if(this._softKeyboardType == param1)
         {
            return;
         }
         this._softKeyboardType = param1;
         this.invalidate("styles");
      }
      
      public function get textAlign() : String
      {
         return this._textAlign;
      }
      
      public function set textAlign(param1:String) : void
      {
         if(this._textAlign == param1)
         {
            return;
         }
         this._textAlign = param1;
         this.invalidate("styles");
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
      
      override public function dispose() : void
      {
         if(this._measureTextField)
         {
            Starling.current.nativeStage.removeChild(this._measureTextField);
            this._measureTextField = null;
         }
         if(this.stageText)
         {
            this.disposeStageText();
         }
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         if(this._stageTextHasFocus)
         {
            param1.excludeFromCache(this);
         }
         if(this.textSnapshot && this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            if(matrixToScaleX(HELPER_MATRIX) != this._lastGlobalScaleX || matrixToScaleY(HELPER_MATRIX) != this._lastGlobalScaleY)
            {
               this.invalidate("size");
               this.validate();
            }
         }
         if(this.stageText && this.stageText.visible)
         {
            this.refreshViewPortAndFontSize();
         }
         if(this.textSnapshot)
         {
            this.positionSnapshot();
         }
         super.render(param1);
      }
      
      public function setFocus(param1:Point = null) : void
      {
         var _loc6_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Rectangle = null;
         var _loc3_:Number = NaN;
         if(!this._isEditable && SystemUtil.platform === "AND")
         {
            return;
         }
         if(!this._isEditable && !this._isSelectable)
         {
            return;
         }
         if(this.stage && !this.stageText.stage)
         {
            this.stageText.stage = Starling.current.nativeStage;
         }
         if(this.stageText && this._stageTextIsComplete)
         {
            if(param1)
            {
               _loc6_ = param1.x + 2;
               _loc2_ = param1.y + 2;
               if(_loc6_ < 0)
               {
                  this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = 0;
               }
               else
               {
                  this._pendingSelectionBeginIndex = this._measureTextField.getCharIndexAtPoint(_loc6_,_loc2_);
                  if(this._pendingSelectionBeginIndex < 0)
                  {
                     if(this._multiline)
                     {
                        _loc4_ = _loc2_ / this._measureTextField.getLineMetrics(0).height;
                        try
                        {
                           this._pendingSelectionBeginIndex = this._measureTextField.getLineOffset(_loc4_) + this._measureTextField.getLineLength(_loc4_);
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
                        this._pendingSelectionBeginIndex = this._measureTextField.getCharIndexAtPoint(_loc6_,this._measureTextField.getLineMetrics(0).ascent / 2);
                        if(this._pendingSelectionBeginIndex < 0)
                        {
                           this._pendingSelectionBeginIndex = this._text.length;
                        }
                     }
                  }
                  else
                  {
                     _loc3_ = (_loc5_ = this._measureTextField.getCharBoundaries(this._pendingSelectionBeginIndex)).x;
                     if(_loc5_ && _loc3_ + _loc5_.width - _loc6_ < _loc6_ - _loc3_)
                     {
                        this._pendingSelectionBeginIndex++;
                     }
                  }
                  this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
               }
            }
            else
            {
               this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
            }
            this.stageText.visible = true;
            if(this._isEditable)
            {
               this.stageText.assignFocus();
            }
         }
         else
         {
            this._isWaitingToSetFocus = true;
         }
      }
      
      public function clearFocus() : void
      {
         if(!this._stageTextHasFocus)
         {
            return;
         }
         Starling.current.nativeStage.focus = null;
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         if(this._stageTextIsComplete && this.stageText)
         {
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.stageText.selectRange(param1,param2);
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
         var _loc4_:Boolean = this.isInvalid("styles");
         var _loc5_:Boolean = this.isInvalid("data");
         if(_loc4_ || _loc5_)
         {
            this.refreshMeasureProperties();
         }
         return this.measure(param1);
      }
      
      override protected function initialize() : void
      {
         if(this._measureTextField && !this._measureTextField.parent)
         {
            Starling.current.nativeStage.addChild(this._measureTextField);
         }
         else if(!this._measureTextField)
         {
            this._measureTextField = new TextField();
            this._measureTextField.visible = false;
            this._measureTextField.mouseEnabled = this._measureTextField.mouseWheelEnabled = false;
            this._measureTextField.autoSize = "left";
            this._measureTextField.multiline = false;
            this._measureTextField.wordWrap = false;
            this._measureTextField.embedFonts = false;
            this._measureTextField.defaultTextFormat = new TextFormat(null,11,0,false,false,false);
            Starling.current.nativeStage.addChild(this._measureTextField);
         }
         this.createStageText();
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
         var _loc1_:Boolean = this.isInvalid("state");
         var _loc2_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("data");
         if(_loc2_ || _loc3_)
         {
            this.refreshMeasureProperties();
         }
         var _loc4_:Boolean = this._ignoreStageTextChanges;
         this._ignoreStageTextChanges = true;
         if(_loc1_ || _loc2_)
         {
            this.refreshStageTextProperties();
         }
         if(_loc3_)
         {
            if(this.stageText.text != this._text)
            {
               if(this._pendingSelectionBeginIndex < 0)
               {
                  this._pendingSelectionBeginIndex = this.stageText.selectionActiveIndex;
                  this._pendingSelectionEndIndex = this.stageText.selectionAnchorIndex;
               }
               this.stageText.text = this._text;
            }
         }
         this._ignoreStageTextChanges = _loc4_;
         if(_loc2_ || _loc1_)
         {
            this.stageText.editable = this._isEditable && this._isEnabled;
         }
      }
      
      protected function measure(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc5_:* = this._explicitHeight !== this._explicitHeight;
         this._measureTextField.autoSize = "left";
         var _loc2_:Number = this._explicitWidth;
         if(_loc3_)
         {
            _loc2_ = this._measureTextField.textWidth;
            if(_loc2_ < this._explicitMinWidth)
            {
               _loc2_ = this._explicitMinWidth;
            }
            else if(_loc2_ > this._explicitMaxWidth)
            {
               _loc2_ = this._explicitMaxWidth;
            }
         }
         this._measureTextField.width = _loc2_ + 4;
         var _loc4_:Number = this._explicitHeight;
         if(_loc5_)
         {
            if(this._stageTextIsTextField)
            {
               _loc4_ = this._measureTextField.textHeight;
            }
            else
            {
               _loc4_ = this._measureTextField.height;
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
         this._measureTextField.autoSize = "none";
         this._measureTextField.width = this.actualWidth + 4;
         this._measureTextField.height = this.actualHeight;
         param1.x = _loc2_;
         param1.y = _loc4_;
         return param1;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:ConcreteTexture = null;
         var _loc8_:* = false;
         var _loc5_:Boolean = this.isInvalid("state");
         var _loc6_:Boolean = this.isInvalid("styles");
         var _loc7_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("skin");
         if(param1 || _loc6_ || _loc2_ || _loc5_)
         {
            this.refreshViewPortAndFontSize();
            this.refreshMeasureTextFieldDimensions();
            _loc3_ = this.stageText.viewPort;
            _loc4_ = !!this.textSnapshot ? this.textSnapshot.texture.root : null;
            this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || _loc4_.scale != Starling.contentScaleFactor || _loc3_.width != _loc4_.width || _loc3_.height != _loc4_.height;
         }
         if(!this._stageTextHasFocus && (_loc5_ || _loc6_ || _loc7_ || param1 || this._needsNewTexture))
         {
            if(_loc8_ = this._text.length > 0)
            {
               this.refreshSnapshot();
            }
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = !this._stageTextHasFocus;
               this.textSnapshot.alpha = _loc8_ ? 1 : 0;
            }
            this.stageText.visible = false;
         }
         this.doPendingActions();
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
      
      protected function refreshMeasureProperties() : void
      {
         this._measureTextField.displayAsPassword = this._displayAsPassword;
         this._measureTextField.maxChars = this._maxChars;
         this._measureTextField.restrict = this._restrict;
         this._measureTextField.multiline = this._measureTextField.wordWrap = this._multiline;
         var _loc2_:TextFormat = this._measureTextField.defaultTextFormat;
         _loc2_.color = this._color;
         _loc2_.font = this._fontFamily;
         _loc2_.italic = this._fontPosture == "italic";
         _loc2_.size = this._fontSize;
         _loc2_.bold = this._fontWeight == "bold";
         var _loc1_:String = this._textAlign;
         if(_loc1_ == "start")
         {
            _loc1_ = "left";
         }
         else if(_loc1_ == "end")
         {
            _loc1_ = "right";
         }
         _loc2_.align = _loc1_;
         this._measureTextField.defaultTextFormat = _loc2_;
         this._measureTextField.setTextFormat(_loc2_);
         if(this._text.length == 0)
         {
            this._measureTextField.text = " ";
         }
         else
         {
            this._measureTextField.text = this._text;
         }
      }
      
      protected function refreshStageTextProperties() : void
      {
         if(this.stageText.multiline != this._multiline)
         {
            if(this.stageText)
            {
               this.disposeStageText();
            }
            this.createStageText();
         }
         this.stageText.autoCapitalize = this._autoCapitalize;
         this.stageText.autoCorrect = this._autoCorrect;
         if(this._isEnabled)
         {
            this.stageText.color = this._color;
         }
         else
         {
            this.stageText.color = this._disabledColor;
         }
         this.stageText.displayAsPassword = this._displayAsPassword;
         this.stageText.fontFamily = this._fontFamily;
         this.stageText.fontPosture = this._fontPosture;
         this.stageText.fontWeight = this._fontWeight;
         this.stageText.locale = this._locale;
         this.stageText.maxChars = this._maxChars;
         this.stageText.restrict = this._restrict;
         this.stageText.returnKeyLabel = this._returnKeyLabel;
         this.stageText.softKeyboardType = this._softKeyboardType;
         this.stageText.textAlign = this._textAlign;
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
            _loc2_ = this._pendingSelectionEndIndex < 0 ? this._pendingSelectionBeginIndex : this._pendingSelectionEndIndex;
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            if(this.stageText.selectionAnchorIndex != _loc1_ || this.stageText.selectionActiveIndex != _loc2_)
            {
               this.selectRange(_loc1_,_loc2_);
            }
         }
      }
      
      protected function texture_onRestore() : void
      {
         if(this.textSnapshot.texture.scale != Starling.contentScaleFactor)
         {
            this.invalidate("size");
         }
         else
         {
            this.refreshSnapshot();
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = !this._stageTextHasFocus;
               this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
            }
            if(!this._stageTextHasFocus)
            {
               this.stageText.visible = false;
            }
         }
      }
      
      protected function refreshSnapshot() : void
      {
         var _loc3_:BitmapData = null;
         var _loc8_:Texture = null;
         var _loc4_:Number = NaN;
         var _loc6_:Texture = null;
         if(this.stage && !this.stageText.stage)
         {
            this.stageText.stage = Starling.current.nativeStage;
         }
         if(!this.stageText.stage)
         {
            this.invalidate("data");
            return;
         }
         var _loc1_:Rectangle = this.stageText.viewPort;
         if(_loc1_.width == 0 || _loc1_.height == 0)
         {
            return;
         }
         var _loc7_:Number = 1;
         if(Starling.current.supportHighResolutions)
         {
            _loc7_ = Starling.current.nativeStage.contentsScaleFactor;
         }
         try
         {
            _loc3_ = new BitmapData(_loc1_.width * _loc7_,_loc1_.height * _loc7_,true,16711935);
            this.stageText.drawViewPortToBitmapData(_loc3_);
         }
         catch(error:Error)
         {
            _loc3_.dispose();
            _loc3_ = new BitmapData(_loc1_.width,_loc1_.height,true,16711935);
            this.stageText.drawViewPortToBitmapData(_loc3_);
         }
         if(!this.textSnapshot || this._needsNewTexture)
         {
            _loc4_ = Starling.contentScaleFactor;
            (_loc8_ = Texture.empty(_loc3_.width / _loc4_,_loc3_.height / _loc4_,true,false,false,_loc4_)).root.uploadBitmapData(_loc3_);
            _loc8_.root.onRestore = texture_onRestore;
         }
         if(!this.textSnapshot)
         {
            this.textSnapshot = new Image(_loc8_);
            this.textSnapshot.pixelSnapping = true;
            this.addChild(this.textSnapshot);
         }
         else if(this._needsNewTexture)
         {
            this.textSnapshot.texture.dispose();
            this.textSnapshot.texture = _loc8_;
            this.textSnapshot.readjustSize();
         }
         else
         {
            (_loc6_ = this.textSnapshot.texture).root.uploadBitmapData(_loc3_);
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         var _loc2_:Number = matrixToScaleX(HELPER_MATRIX);
         var _loc5_:Number = matrixToScaleY(HELPER_MATRIX);
         if(this._updateSnapshotOnScaleChange)
         {
            this.textSnapshot.scaleX = 1 / _loc2_;
            this.textSnapshot.scaleY = 1 / _loc5_;
            this._lastGlobalScaleX = _loc2_;
            this._lastGlobalScaleY = _loc5_;
         }
         else
         {
            this.textSnapshot.scaleX = 1;
            this.textSnapshot.scaleY = 1;
         }
         if(_loc7_ > 1 && _loc3_.width == _loc1_.width)
         {
            this.textSnapshot.scaleX *= _loc7_;
            this.textSnapshot.scaleY *= _loc7_;
         }
         _loc3_.dispose();
         this._needsNewTexture = false;
      }
      
      protected function refreshViewPortAndFontSize() : void
      {
         var _loc2_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc10_:* = NaN;
         HELPER_POINT.x = HELPER_POINT.y = 0;
         var _loc3_:Number = 0;
         var _loc5_:Number = 0;
         if(this._stageTextIsTextField)
         {
            _loc3_ = 2;
            _loc5_ = 4;
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         if(this._stageTextHasFocus || this._updateSnapshotOnScaleChange)
         {
            _loc2_ = matrixToScaleX(HELPER_MATRIX);
            _loc6_ = matrixToScaleY(HELPER_MATRIX);
            _loc10_ = _loc2_;
            if(_loc6_ < _loc10_)
            {
               _loc10_ = _loc6_;
            }
         }
         else
         {
            _loc2_ = 1;
            _loc6_ = 1;
            _loc10_ = 1;
         }
         if(this.is3D)
         {
            HELPER_MATRIX3D = this.getTransformationMatrix3D(this.stage,HELPER_MATRIX3D);
            HELPER_POINT3D = MatrixUtil.transformCoords3D(HELPER_MATRIX3D,-_loc3_,-_loc3_,0,HELPER_POINT3D);
            HELPER_POINT.setTo(HELPER_POINT3D.x,HELPER_POINT3D.y);
         }
         else
         {
            MatrixUtil.transformCoords(HELPER_MATRIX,-_loc3_,-_loc3_,HELPER_POINT);
         }
         var _loc9_:Starling;
         if((_loc9_ = stageToStarling(this.stage)) === null)
         {
            _loc9_ = Starling.current;
         }
         var _loc8_:Number = 1;
         if(_loc9_.supportHighResolutions)
         {
            _loc8_ = _loc9_.nativeStage.contentsScaleFactor;
         }
         var _loc7_:Number = _loc9_.contentScaleFactor / _loc8_;
         var _loc4_:Rectangle = _loc9_.viewPort;
         var _loc12_:Rectangle;
         if(!(_loc12_ = this.stageText.viewPort))
         {
            _loc12_ = new Rectangle();
         }
         _loc12_.x = Math.round(_loc4_.x + HELPER_POINT.x * _loc7_);
         _loc12_.y = Math.round(_loc4_.y + HELPER_POINT.y * _loc7_);
         var _loc11_:Number;
         if((_loc11_ = Math.round((this.actualWidth + _loc5_) * _loc7_ * _loc2_)) < 1 || _loc11_ !== _loc11_)
         {
            _loc11_ = 1;
         }
         var _loc13_:Number;
         if((_loc13_ = Math.round((this.actualHeight + _loc5_) * _loc7_ * _loc6_)) < 1 || _loc13_ !== _loc13_)
         {
            _loc13_ = 1;
         }
         _loc12_.width = _loc11_;
         _loc12_.height = _loc13_;
         this.stageText.viewPort = _loc12_;
         var _loc1_:int = this._fontSize * _loc7_ * _loc10_;
         if(this.stageText.fontSize != _loc1_)
         {
            this.stageText.fontSize = _loc1_;
         }
      }
      
      protected function refreshMeasureTextFieldDimensions() : void
      {
         this._measureTextField.width = this.actualWidth + 4;
         this._measureTextField.height = this.actualHeight;
      }
      
      protected function positionSnapshot() : void
      {
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         var _loc1_:Number = 0;
         if(this._stageTextIsTextField)
         {
            _loc1_ = 2;
         }
         this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx - _loc1_;
         this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty - _loc1_;
      }
      
      protected function disposeStageText() : void
      {
         if(!this.stageText)
         {
            return;
         }
         this.stageText.removeEventListener("change",stageText_changeHandler);
         this.stageText.removeEventListener("keyDown",stageText_keyDownHandler);
         this.stageText.removeEventListener("keyUp",stageText_keyUpHandler);
         this.stageText.removeEventListener("focusIn",stageText_focusInHandler);
         this.stageText.removeEventListener("focusOut",stageText_focusOutHandler);
         this.stageText.removeEventListener("complete",stageText_completeHandler);
         this.stageText.removeEventListener("softKeyboardActivate",stageText_softKeyboardActivateHandler);
         this.stageText.removeEventListener("softKeyboardDeactivate",stageText_softKeyboardDeactivateHandler);
         this.stageText.stage = null;
         this.stageText.dispose();
         this.stageText = null;
      }
      
      protected function createStageText() : void
      {
         var _loc1_:Class = null;
         var _loc3_:Object = null;
         var _loc2_:Class = null;
         this._stageTextIsComplete = false;
         try
         {
            _loc1_ = Class(getDefinitionByName("flash.text.StageText"));
            _loc2_ = Class(getDefinitionByName("flash.text.StageTextInitOptions"));
            _loc3_ = new _loc2_(this._multiline);
         }
         catch(error:Error)
         {
            _loc1_ = StageTextField;
            _loc3_ = {"multiline":this._multiline};
         }
         this.stageText = new _loc1_(_loc3_);
         this.stageText.visible = false;
         this.stageText.addEventListener("change",stageText_changeHandler);
         this.stageText.addEventListener("keyDown",stageText_keyDownHandler);
         this.stageText.addEventListener("keyUp",stageText_keyUpHandler);
         this.stageText.addEventListener("focusIn",stageText_focusInHandler);
         this.stageText.addEventListener("focusOut",stageText_focusOutHandler);
         this.stageText.addEventListener("softKeyboardActivate",stageText_softKeyboardActivateHandler);
         this.stageText.addEventListener("softKeyboardDeactivate",stageText_softKeyboardDeactivateHandler);
         this.stageText.addEventListener("complete",stageText_completeHandler);
         this.invalidate();
      }
      
      protected function dispatchKeyFocusChangeEvent(param1:KeyboardEvent) : void
      {
         var _loc2_:Starling = stageToStarling(this.stage);
         var _loc3_:FocusEvent = new FocusEvent("keyFocusChange",true,false,null,param1.shiftKey,param1.keyCode);
         _loc2_.nativeStage.dispatchEvent(_loc3_);
      }
      
      protected function textEditor_removedFromStageHandler(param1:starling.events.Event) : void
      {
         this.stageText.stage = null;
      }
      
      protected function stageText_changeHandler(param1:flash.events.Event) : void
      {
         if(this._ignoreStageTextChanges)
         {
            return;
         }
         this.text = this.stageText.text;
      }
      
      protected function stageText_completeHandler(param1:flash.events.Event) : void
      {
         this.stageText.removeEventListener("complete",stageText_completeHandler);
         this.invalidate();
         this._stageTextIsComplete = true;
      }
      
      protected function stageText_focusInHandler(param1:FocusEvent) : void
      {
         this._stageTextHasFocus = true;
         this.addEventListener("enterFrame",hasFocus_enterFrameHandler);
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = false;
         }
         this.invalidate("skin");
         this.dispatchEventWith("focusIn");
      }
      
      protected function stageText_focusOutHandler(param1:FocusEvent) : void
      {
         this._stageTextHasFocus = false;
         this.stageText.selectRange(1,1);
         this.invalidate("data");
         this.invalidate("skin");
         this.dispatchEventWith("focusOut");
      }
      
      protected function hasFocus_enterFrameHandler(param1:starling.events.Event) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._stageTextHasFocus)
         {
            _loc2_ = this;
            do
            {
               if(!_loc2_.visible)
               {
                  this.stageText.stage.focus = null;
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
      
      protected function stageText_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this._multiline && (param1.keyCode == 13 || param1.keyCode == 16777230))
         {
            param1.preventDefault();
            this.dispatchEventWith("enter");
         }
         else if(param1.keyCode == 16777238)
         {
            param1.preventDefault();
            Starling.current.nativeStage.focus = Starling.current.nativeStage;
         }
         if(param1.keyCode === 9 && FocusManager.isEnabledForStage(this.stage))
         {
            param1.preventDefault();
            this.dispatchKeyFocusChangeEvent(param1);
         }
      }
      
      protected function stageText_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!this._multiline && (param1.keyCode == 13 || param1.keyCode == 16777230))
         {
            param1.preventDefault();
         }
         if(param1.keyCode === 9 && FocusManager.isEnabledForStage(this.stage))
         {
            param1.preventDefault();
         }
      }
      
      protected function stageText_softKeyboardActivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith("softKeyboardActivate",true);
      }
      
      protected function stageText_softKeyboardDeactivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith("softKeyboardDeactivate",true);
      }
   }
}
