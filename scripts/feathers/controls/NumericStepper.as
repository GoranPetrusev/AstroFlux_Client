package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IAdvancedNativeFocusOwner;
   import feathers.core.ITextBaselineControl;
   import feathers.core.PropertyProxy;
   import feathers.events.ExclusiveTouch;
   import feathers.skins.IStyleProvider;
   import feathers.utils.math.clamp;
   import feathers.utils.math.roundToNearest;
   import feathers.utils.math.roundToPrecision;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class NumericStepper extends FeathersControl implements IRange, IAdvancedNativeFocusOwner, ITextBaselineControl
   {
      
      protected static const INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY:String = "decrementButtonFactory";
      
      protected static const INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY:String = "incrementButtonFactory";
      
      protected static const INVALIDATION_FLAG_TEXT_INPUT_FACTORY:String = "textInputFactory";
      
      public static const DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON:String = "feathers-numeric-stepper-decrement-button";
      
      public static const DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON:String = "feathers-numeric-stepper-increment-button";
      
      public static const DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT:String = "feathers-numeric-stepper-text-input";
      
      public static const BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL:String = "splitHorizontal";
      
      public static const BUTTON_LAYOUT_MODE_SPLIT_VERTICAL:String = "splitVertical";
      
      public static const BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL:String = "rightSideVertical";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var decrementButtonStyleName:String = "feathers-numeric-stepper-decrement-button";
      
      protected var incrementButtonStyleName:String = "feathers-numeric-stepper-increment-button";
      
      protected var textInputStyleName:String = "feathers-numeric-stepper-text-input";
      
      protected var decrementButton:Button;
      
      protected var incrementButton:Button;
      
      protected var textInput:TextInput;
      
      protected var textInputExplicitWidth:Number;
      
      protected var textInputExplicitHeight:Number;
      
      protected var textInputExplicitMinWidth:Number;
      
      protected var textInputExplicitMinHeight:Number;
      
      protected var touchPointID:int = -1;
      
      protected var _textInputHasFocus:Boolean = false;
      
      protected var _value:Number = 0;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 0;
      
      protected var _step:Number = 0;
      
      protected var _valueFormatFunction:Function;
      
      protected var _valueParseFunction:Function;
      
      protected var currentRepeatAction:Function;
      
      protected var _repeatTimer:Timer;
      
      protected var _repeatDelay:Number = 0.05;
      
      protected var _buttonLayoutMode:String = "splitHorizontal";
      
      protected var _buttonGap:Number = 0;
      
      protected var _textInputGap:Number = 0;
      
      protected var _decrementButtonFactory:Function;
      
      protected var _customDecrementButtonStyleName:String;
      
      protected var _decrementButtonProperties:PropertyProxy;
      
      protected var _decrementButtonLabel:String = null;
      
      protected var _incrementButtonFactory:Function;
      
      protected var _customIncrementButtonStyleName:String;
      
      protected var _incrementButtonProperties:PropertyProxy;
      
      protected var _incrementButtonLabel:String = null;
      
      protected var _textInputFactory:Function;
      
      protected var _customTextInputStyleName:String;
      
      protected var _textInputProperties:PropertyProxy;
      
      public function NumericStepper()
      {
         super();
         this.addEventListener("removedFromStage",numericStepper_removedFromStageHandler);
      }
      
      protected static function defaultDecrementButtonFactory() : Button
      {
         return new Button();
      }
      
      protected static function defaultIncrementButtonFactory() : Button
      {
         return new Button();
      }
      
      protected static function defaultTextInputFactory() : TextInput
      {
         return new TextInput();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return NumericStepper.globalStyleProvider;
      }
      
      public function get nativeFocus() : Object
      {
         if(this.textInput !== null)
         {
            return this.textInput.nativeFocus;
         }
         return null;
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         if(this._step != 0 && param1 != this._maximum && param1 != this._minimum)
         {
            param1 = roundToPrecision(roundToNearest(param1 - this._minimum,this._step) + this._minimum,10);
         }
         param1 = clamp(param1,this._minimum,this._maximum);
         if(this._value == param1)
         {
            return;
         }
         this._value = param1;
         this.invalidate("data");
         this.dispatchEventWith("change");
      }
      
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set minimum(param1:Number) : void
      {
         if(this._minimum == param1)
         {
            return;
         }
         this._minimum = param1;
         this.invalidate("data");
      }
      
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(param1:Number) : void
      {
         if(this._maximum == param1)
         {
            return;
         }
         this._maximum = param1;
         this.invalidate("data");
      }
      
      public function get step() : Number
      {
         return this._step;
      }
      
      public function set step(param1:Number) : void
      {
         if(this._step == param1)
         {
            return;
         }
         this._step = param1;
      }
      
      public function get valueFormatFunction() : Function
      {
         return this._valueFormatFunction;
      }
      
      public function set valueFormatFunction(param1:Function) : void
      {
         if(this._valueFormatFunction == param1)
         {
            return;
         }
         this._valueFormatFunction = param1;
         this.invalidate("styles");
      }
      
      public function get valueParseFunction() : Function
      {
         return this._valueParseFunction;
      }
      
      public function set valueParseFunction(param1:Function) : void
      {
         this._valueParseFunction = param1;
      }
      
      public function get repeatDelay() : Number
      {
         return this._repeatDelay;
      }
      
      public function set repeatDelay(param1:Number) : void
      {
         if(this._repeatDelay == param1)
         {
            return;
         }
         this._repeatDelay = param1;
         this.invalidate("styles");
      }
      
      public function get buttonLayoutMode() : String
      {
         return this._buttonLayoutMode;
      }
      
      public function set buttonLayoutMode(param1:String) : void
      {
         if(this._buttonLayoutMode == param1)
         {
            return;
         }
         this._buttonLayoutMode = param1;
         this.invalidate("styles");
      }
      
      public function get buttonGap() : Number
      {
         return this._buttonGap;
      }
      
      public function set buttonGap(param1:Number) : void
      {
         if(this._buttonGap == param1)
         {
            return;
         }
         this._buttonGap = param1;
         this.invalidate("styles");
      }
      
      public function get textInputGap() : Number
      {
         return this._textInputGap;
      }
      
      public function set textInputGap(param1:Number) : void
      {
         if(this._textInputGap == param1)
         {
            return;
         }
         this._textInputGap = param1;
         this.invalidate("styles");
      }
      
      public function get decrementButtonFactory() : Function
      {
         return this._decrementButtonFactory;
      }
      
      public function set decrementButtonFactory(param1:Function) : void
      {
         if(this._decrementButtonFactory == param1)
         {
            return;
         }
         this._decrementButtonFactory = param1;
         this.invalidate("decrementButtonFactory");
      }
      
      public function get customDecrementButtonStyleName() : String
      {
         return this._customDecrementButtonStyleName;
      }
      
      public function set customDecrementButtonStyleName(param1:String) : void
      {
         if(this._customDecrementButtonStyleName == param1)
         {
            return;
         }
         this._customDecrementButtonStyleName = param1;
         this.invalidate("decrementButtonFactory");
      }
      
      public function get decrementButtonProperties() : Object
      {
         if(!this._decrementButtonProperties)
         {
            this._decrementButtonProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._decrementButtonProperties;
      }
      
      public function set decrementButtonProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._decrementButtonProperties == param1)
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
         if(this._decrementButtonProperties)
         {
            this._decrementButtonProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._decrementButtonProperties = PropertyProxy(param1);
         if(this._decrementButtonProperties)
         {
            this._decrementButtonProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get decrementButtonLabel() : String
      {
         return this._decrementButtonLabel;
      }
      
      public function set decrementButtonLabel(param1:String) : void
      {
         if(this._decrementButtonLabel == param1)
         {
            return;
         }
         this._decrementButtonLabel = param1;
         this.invalidate("styles");
      }
      
      public function get incrementButtonFactory() : Function
      {
         return this._incrementButtonFactory;
      }
      
      public function set incrementButtonFactory(param1:Function) : void
      {
         if(this._incrementButtonFactory == param1)
         {
            return;
         }
         this._incrementButtonFactory = param1;
         this.invalidate("incrementButtonFactory");
      }
      
      public function get customIncrementButtonStyleName() : String
      {
         return this._customIncrementButtonStyleName;
      }
      
      public function set customIncrementButtonStyleName(param1:String) : void
      {
         if(this._customIncrementButtonStyleName == param1)
         {
            return;
         }
         this._customIncrementButtonStyleName = param1;
         this.invalidate("incrementButtonFactory");
      }
      
      public function get incrementButtonProperties() : Object
      {
         if(!this._incrementButtonProperties)
         {
            this._incrementButtonProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._incrementButtonProperties;
      }
      
      public function set incrementButtonProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._incrementButtonProperties == param1)
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
         if(this._incrementButtonProperties)
         {
            this._incrementButtonProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._incrementButtonProperties = PropertyProxy(param1);
         if(this._incrementButtonProperties)
         {
            this._incrementButtonProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get incrementButtonLabel() : String
      {
         return this._incrementButtonLabel;
      }
      
      public function set incrementButtonLabel(param1:String) : void
      {
         if(this._incrementButtonLabel == param1)
         {
            return;
         }
         this._incrementButtonLabel = param1;
         this.invalidate("styles");
      }
      
      public function get textInputFactory() : Function
      {
         return this._textInputFactory;
      }
      
      public function set textInputFactory(param1:Function) : void
      {
         if(this._textInputFactory == param1)
         {
            return;
         }
         this._textInputFactory = param1;
         this.invalidate("textInputFactory");
      }
      
      public function get customTextInputStyleName() : String
      {
         return this._customTextInputStyleName;
      }
      
      public function set customTextInputStyleName(param1:String) : void
      {
         if(this._customTextInputStyleName == param1)
         {
            return;
         }
         this._customTextInputStyleName = param1;
         this.invalidate("textInputFactory");
      }
      
      public function get textInputProperties() : Object
      {
         if(!this._textInputProperties)
         {
            this._textInputProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._textInputProperties;
      }
      
      public function set textInputProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._textInputProperties == param1)
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
         if(this._textInputProperties)
         {
            this._textInputProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._textInputProperties = PropertyProxy(param1);
         if(this._textInputProperties)
         {
            this._textInputProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get baseline() : Number
      {
         if(!this.textInput)
         {
            return this.scaledActualHeight;
         }
         return this.scaleY * (this.textInput.y + this.textInput.baseline);
      }
      
      public function get hasFocus() : Boolean
      {
         return this._hasFocus;
      }
      
      public function setFocus() : void
      {
         if(this.textInput === null)
         {
            return;
         }
         this.textInput.setFocus();
      }
      
      override protected function draw() : void
      {
         var _loc6_:Boolean = this.isInvalid("data");
         var _loc7_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc4_:Boolean = this.isInvalid("state");
         var _loc5_:Boolean = this.isInvalid("decrementButtonFactory");
         var _loc1_:Boolean = this.isInvalid("incrementButtonFactory");
         var _loc8_:Boolean = this.isInvalid("textInputFactory");
         var _loc3_:Boolean = this.isInvalid("focus");
         if(_loc5_)
         {
            this.createDecrementButton();
         }
         if(_loc1_)
         {
            this.createIncrementButton();
         }
         if(_loc8_)
         {
            this.createTextInput();
         }
         if(_loc5_ || _loc7_)
         {
            this.refreshDecrementButtonStyles();
         }
         if(_loc1_ || _loc7_)
         {
            this.refreshIncrementButtonStyles();
         }
         if(_loc8_ || _loc7_)
         {
            this.refreshTextInputStyles();
         }
         if(_loc8_ || _loc6_)
         {
            this.refreshTypicalText();
            this.refreshDisplayedText();
         }
         if(_loc5_ || _loc4_)
         {
            this.decrementButton.isEnabled = this._isEnabled;
         }
         if(_loc1_ || _loc4_)
         {
            this.incrementButton.isEnabled = this._isEnabled;
         }
         if(_loc8_ || _loc4_)
         {
            this.textInput.isEnabled = this._isEnabled;
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         this.layoutChildren();
         if(_loc2_ || _loc3_)
         {
            this.refreshFocusIndicator();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc24_:* = NaN;
         var _loc11_:* = NaN;
         var _loc4_:* = this._explicitWidth !== this._explicitWidth;
         var _loc19_:* = this._explicitHeight !== this._explicitHeight;
         var _loc14_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc22_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc4_ && !_loc19_ && !_loc14_ && !_loc22_)
         {
            return false;
         }
         var _loc3_:* = this._explicitWidth;
         var _loc6_:* = this._explicitHeight;
         var _loc12_:* = this._explicitMinWidth;
         var _loc18_:* = this._explicitMinHeight;
         this.decrementButton.validate();
         this.incrementButton.validate();
         var _loc20_:Number = this.decrementButton.width;
         var _loc15_:Number = this.decrementButton.height;
         var _loc9_:Number = this.decrementButton.minWidth;
         var _loc23_:Number = this.decrementButton.minHeight;
         var _loc5_:Number = this.incrementButton.width;
         var _loc10_:Number = this.incrementButton.height;
         var _loc16_:Number = this.incrementButton.minWidth;
         var _loc7_:Number = this.incrementButton.minHeight;
         var _loc13_:Number = this.textInputExplicitWidth;
         var _loc1_:Number = this.textInputExplicitHeight;
         var _loc21_:Number = this.textInputExplicitMinWidth;
         var _loc8_:Number = this.textInputExplicitMinHeight;
         var _loc17_:Number = Infinity;
         var _loc2_:Number = Infinity;
         if(this._buttonLayoutMode === "rightSideVertical")
         {
            _loc24_ = _loc20_;
            if(_loc5_ > _loc24_)
            {
               _loc24_ = _loc5_;
            }
            _loc11_ = _loc9_;
            if(_loc16_ > _loc11_)
            {
               _loc11_ = _loc16_;
            }
            if(!_loc4_)
            {
               _loc13_ = this._explicitWidth - _loc24_ - this._textInputGap;
            }
            if(!_loc19_)
            {
               _loc1_ = this._explicitHeight;
            }
            if(!_loc14_)
            {
               _loc21_ = this._explicitMinWidth - _loc11_ - this._textInputGap;
               if(this.textInputExplicitMinWidth > _loc21_)
               {
                  _loc21_ = this.textInputExplicitMinWidth;
               }
            }
            if(!_loc22_)
            {
               _loc8_ = this._explicitMinHeight;
               if(this.textInputExplicitMinHeight > _loc8_)
               {
                  _loc8_ = this.textInputExplicitMinHeight;
               }
            }
            _loc17_ = this._explicitMaxWidth - _loc24_ - this._textInputGap;
         }
         else if(this._buttonLayoutMode === "splitVertical")
         {
            if(!_loc4_)
            {
               _loc13_ = this._explicitWidth;
            }
            if(!_loc19_)
            {
               _loc1_ = this._explicitHeight - _loc15_ - _loc10_;
            }
            if(!_loc14_)
            {
               _loc21_ = this._explicitMinWidth;
               if(this.textInputExplicitMinWidth > _loc21_)
               {
                  _loc21_ = this.textInputExplicitMinWidth;
               }
            }
            if(!_loc22_)
            {
               _loc8_ = this._explicitMinHeight - _loc23_ - _loc7_;
               if(this.textInputExplicitMinHeight > _loc8_)
               {
                  _loc8_ = this.textInputExplicitMinHeight;
               }
            }
            _loc2_ = this._explicitMaxHeight - _loc15_ - _loc10_;
         }
         else
         {
            if(!_loc4_)
            {
               _loc13_ = this._explicitWidth - _loc20_ - _loc5_;
            }
            if(!_loc19_)
            {
               _loc1_ = this._explicitHeight;
            }
            if(!_loc14_)
            {
               if((_loc21_ = this._explicitMinWidth - _loc9_ - _loc16_) < this.textInputExplicitMinWidth)
               {
                  _loc21_ = this.textInputExplicitMinWidth;
               }
            }
            if(!_loc22_)
            {
               _loc8_ = this._explicitMinHeight;
               if(this.textInputExplicitMinHeight > _loc8_)
               {
                  _loc8_ = this.textInputExplicitMinHeight;
               }
            }
            _loc17_ = this._explicitMaxWidth - _loc20_ - _loc5_;
         }
         if(_loc13_ < 0)
         {
            _loc13_ = 0;
         }
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         if(_loc21_ < 0)
         {
            _loc21_ = 0;
         }
         if(_loc8_ < 0)
         {
            _loc8_ = 0;
         }
         this.textInput.width = _loc13_;
         this.textInput.height = _loc1_;
         this.textInput.minWidth = _loc21_;
         this.textInput.minHeight = _loc8_;
         this.textInput.maxWidth = _loc17_;
         this.textInput.maxHeight = _loc2_;
         this.textInput.validate();
         if(this._buttonLayoutMode === "rightSideVertical")
         {
            if(_loc4_)
            {
               _loc3_ = this.textInput.width + _loc24_ + this._textInputGap;
            }
            if(_loc19_)
            {
               _loc6_ = _loc15_ + this._buttonGap + _loc10_;
               if(this.textInput.height > _loc6_)
               {
                  _loc6_ = this.textInput.height;
               }
            }
            if(_loc14_)
            {
               _loc12_ = this.textInput.minWidth + _loc11_ + this._textInputGap;
            }
            if(_loc22_)
            {
               _loc18_ = _loc23_ + this._buttonGap + _loc7_;
               if(this.textInput.minHeight > _loc18_)
               {
                  _loc18_ = this.textInput.minHeight;
               }
            }
         }
         else if(this._buttonLayoutMode === "splitVertical")
         {
            if(_loc4_)
            {
               _loc3_ = this.textInput.width;
               if(_loc20_ > _loc3_)
               {
                  _loc3_ = _loc20_;
               }
               if(_loc5_ > _loc3_)
               {
                  _loc3_ = _loc5_;
               }
            }
            if(_loc19_)
            {
               _loc6_ = _loc15_ + this.textInput.height + _loc10_ + 2 * this._textInputGap;
            }
            if(_loc14_)
            {
               _loc12_ = this.textInput.minWidth;
               if(_loc9_ > _loc12_)
               {
                  _loc12_ = _loc9_;
               }
               if(_loc16_ > _loc12_)
               {
                  _loc12_ = _loc16_;
               }
            }
            if(_loc22_)
            {
               _loc18_ = _loc23_ + this.textInput.minHeight + _loc7_ + 2 * this._textInputGap;
            }
         }
         else
         {
            if(_loc4_)
            {
               _loc3_ = _loc20_ + this.textInput.width + _loc5_ + 2 * this._textInputGap;
            }
            if(_loc19_)
            {
               _loc6_ = this.textInput.height;
               if(_loc15_ > _loc6_)
               {
                  _loc6_ = _loc15_;
               }
               if(_loc10_ > _loc6_)
               {
                  _loc6_ = _loc10_;
               }
            }
            if(_loc14_)
            {
               _loc12_ = _loc9_ + this.textInput.minWidth + _loc16_ + 2 * this._textInputGap;
            }
            if(_loc22_)
            {
               _loc18_ = this.textInput.minHeight;
               if(_loc23_ > _loc18_)
               {
                  _loc18_ = _loc23_;
               }
               if(_loc7_ > _loc18_)
               {
                  _loc18_ = _loc7_;
               }
            }
         }
         return this.saveMeasurements(_loc3_,_loc6_,_loc12_,_loc18_);
      }
      
      protected function decrement() : void
      {
         this.value = this._value - this._step;
         this.validate();
         this.textInput.selectRange(0,this.textInput.text.length);
      }
      
      protected function increment() : void
      {
         this.value = this._value + this._step;
         this.validate();
         this.textInput.selectRange(0,this.textInput.text.length);
      }
      
      protected function toMinimum() : void
      {
         this.value = this._minimum;
         this.validate();
         this.textInput.selectRange(0,this.textInput.text.length);
      }
      
      protected function toMaximum() : void
      {
         this.value = this._maximum;
         this.validate();
         this.textInput.selectRange(0,this.textInput.text.length);
      }
      
      protected function createDecrementButton() : void
      {
         if(this.decrementButton)
         {
            this.decrementButton.removeFromParent(true);
            this.decrementButton = null;
         }
         var _loc1_:Function = this._decrementButtonFactory != null ? this._decrementButtonFactory : defaultDecrementButtonFactory;
         var _loc2_:String = this._customDecrementButtonStyleName != null ? this._customDecrementButtonStyleName : this.decrementButtonStyleName;
         this.decrementButton = Button(_loc1_());
         this.decrementButton.styleNameList.add(_loc2_);
         this.decrementButton.addEventListener("touch",decrementButton_touchHandler);
         this.addChild(this.decrementButton);
      }
      
      protected function createIncrementButton() : void
      {
         if(this.incrementButton)
         {
            this.incrementButton.removeFromParent(true);
            this.incrementButton = null;
         }
         var _loc1_:Function = this._incrementButtonFactory != null ? this._incrementButtonFactory : defaultIncrementButtonFactory;
         var _loc2_:String = this._customIncrementButtonStyleName != null ? this._customIncrementButtonStyleName : this.incrementButtonStyleName;
         this.incrementButton = Button(_loc1_());
         this.incrementButton.styleNameList.add(_loc2_);
         this.incrementButton.addEventListener("touch",incrementButton_touchHandler);
         this.addChild(this.incrementButton);
      }
      
      protected function createTextInput() : void
      {
         if(this.textInput)
         {
            this.textInput.removeFromParent(true);
            this.textInput = null;
         }
         var _loc1_:Function = this._textInputFactory != null ? this._textInputFactory : defaultTextInputFactory;
         var _loc2_:String = this._customTextInputStyleName != null ? this._customTextInputStyleName : this.textInputStyleName;
         this.textInput = TextInput(_loc1_());
         this.textInput.styleNameList.add(_loc2_);
         this.textInput.addEventListener("enter",textInput_enterHandler);
         this.textInput.addEventListener("focusIn",textInput_focusInHandler);
         this.textInput.addEventListener("focusOut",textInput_focusOutHandler);
         this.textInput.isFocusEnabled = !this._focusManager;
         this.addChild(this.textInput);
         this.textInput.initializeNow();
         this.textInputExplicitWidth = this.textInput.explicitWidth;
         this.textInputExplicitHeight = this.textInput.explicitHeight;
         this.textInputExplicitMinWidth = this.textInput.explicitMinWidth;
         this.textInputExplicitMinHeight = this.textInput.explicitMinHeight;
      }
      
      protected function refreshDecrementButtonStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._decrementButtonProperties)
         {
            _loc2_ = this._decrementButtonProperties[_loc1_];
            this.decrementButton[_loc1_] = _loc2_;
         }
         this.decrementButton.label = this._decrementButtonLabel;
      }
      
      protected function refreshIncrementButtonStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._incrementButtonProperties)
         {
            _loc2_ = this._incrementButtonProperties[_loc1_];
            this.incrementButton[_loc1_] = _loc2_;
         }
         this.incrementButton.label = this._incrementButtonLabel;
      }
      
      protected function refreshTextInputStyles() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._textInputProperties)
         {
            _loc2_ = this._textInputProperties[_loc1_];
            this.textInput[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshDisplayedText() : void
      {
         if(this._valueFormatFunction != null)
         {
            this.textInput.text = this._valueFormatFunction(this._value);
         }
         else
         {
            this.textInput.text = this._value.toString();
         }
      }
      
      protected function refreshTypicalText() : void
      {
         var _loc4_:int = 0;
         var _loc1_:String = "";
         var _loc2_:Number = Math.max(int(this._minimum).toString().length,int(this._maximum).toString().length,int(this._step).toString().length);
         var _loc3_:Number = Math.max(roundToPrecision(this._minimum - int(this._minimum),10).toString().length,roundToPrecision(this._maximum - int(this._maximum),10).toString().length,roundToPrecision(this._step - int(this._step),10).toString().length) - 2;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         var _loc5_:int = _loc2_ + _loc3_;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc1_ += "0";
            _loc4_++;
         }
         if(_loc3_ > 0)
         {
            _loc1_ += ".";
         }
         this.textInput.typicalText = _loc1_;
      }
      
      protected function layoutChildren() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this._buttonLayoutMode === "rightSideVertical")
         {
            _loc1_ = (this.actualHeight - this._buttonGap) / 2;
            this.incrementButton.y = 0;
            this.incrementButton.height = _loc1_;
            this.incrementButton.validate();
            this.decrementButton.y = _loc1_ + this._buttonGap;
            this.decrementButton.height = _loc1_;
            this.decrementButton.validate();
            _loc3_ = Math.max(this.decrementButton.width,this.incrementButton.width);
            _loc2_ = this.actualWidth - _loc3_;
            this.decrementButton.x = _loc2_;
            this.incrementButton.x = _loc2_;
            this.textInput.x = 0;
            this.textInput.y = 0;
            this.textInput.width = _loc2_ - this._textInputGap;
            this.textInput.height = this.actualHeight;
         }
         else if(this._buttonLayoutMode === "splitVertical")
         {
            this.incrementButton.x = 0;
            this.incrementButton.y = 0;
            this.incrementButton.width = this.actualWidth;
            this.incrementButton.validate();
            this.decrementButton.x = 0;
            this.decrementButton.width = this.actualWidth;
            this.decrementButton.validate();
            this.decrementButton.y = this.actualHeight - this.decrementButton.height;
            this.textInput.x = 0;
            this.textInput.y = this.incrementButton.height + this._textInputGap;
            this.textInput.width = this.actualWidth;
            this.textInput.height = Math.max(0,this.actualHeight - this.decrementButton.height - this.incrementButton.height - 2 * this._textInputGap);
         }
         else
         {
            this.decrementButton.x = 0;
            this.decrementButton.y = 0;
            this.decrementButton.height = this.actualHeight;
            this.decrementButton.validate();
            this.incrementButton.y = 0;
            this.incrementButton.height = this.actualHeight;
            this.incrementButton.validate();
            this.incrementButton.x = this.actualWidth - this.incrementButton.width;
            this.textInput.x = this.decrementButton.width + this._textInputGap;
            this.textInput.width = this.actualWidth - this.decrementButton.width - this.incrementButton.width - 2 * this._textInputGap;
            this.textInput.height = this.actualHeight;
         }
         this.textInput.validate();
      }
      
      protected function startRepeatTimer(param1:Function) : void
      {
         var _loc2_:ExclusiveTouch = null;
         var _loc3_:DisplayObject = null;
         if(this.touchPointID >= 0)
         {
            _loc2_ = ExclusiveTouch.forStage(this.stage);
            _loc3_ = _loc2_.getClaim(this.touchPointID);
            if(_loc3_ != this)
            {
               if(_loc3_)
               {
                  return;
               }
               _loc2_.claimTouch(this.touchPointID,this);
            }
         }
         this.currentRepeatAction = param1;
         if(this._repeatDelay > 0)
         {
            if(!this._repeatTimer)
            {
               this._repeatTimer = new Timer(this._repeatDelay * 1000);
               this._repeatTimer.addEventListener("timer",repeatTimer_timerHandler);
            }
            else
            {
               this._repeatTimer.reset();
               this._repeatTimer.delay = this._repeatDelay * 1000;
            }
            this._repeatTimer.start();
         }
      }
      
      protected function parseTextInputValue() : void
      {
         var _loc1_:Number = NaN;
         if(this._valueParseFunction != null)
         {
            _loc1_ = this._valueParseFunction(this.textInput.text);
         }
         else
         {
            _loc1_ = parseFloat(this.textInput.text);
         }
         if(_loc1_ === _loc1_)
         {
            this.value = _loc1_;
         }
         this.invalidate("data");
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:Object) : void
      {
         this.invalidate("styles");
      }
      
      protected function numericStepper_removedFromStageHandler(param1:Event) : void
      {
         this.touchPointID = -1;
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         this.textInput.setFocus();
         this.textInput.selectRange(0,this.textInput.text.length);
         this.stage.addEventListener("keyDown",stage_keyDownHandler);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         super.focusOutHandler(param1);
         this.textInput.clearFocus();
         this.stage.removeEventListener("keyDown",stage_keyDownHandler);
      }
      
      protected function textInput_enterHandler(param1:Event) : void
      {
         this.parseTextInputValue();
      }
      
      protected function textInput_focusInHandler(param1:Event) : void
      {
         this._textInputHasFocus = true;
      }
      
      protected function textInput_focusOutHandler(param1:Event) : void
      {
         this._textInputHasFocus = false;
         this.parseTextInputValue();
      }
      
      protected function decrementButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.decrementButton,"ended",this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = -1;
            this._repeatTimer.stop();
            this.dispatchEventWith("endInteraction");
         }
         else
         {
            _loc2_ = param1.getTouch(this.decrementButton,"began");
            if(!_loc2_)
            {
               return;
            }
            if(this._textInputHasFocus)
            {
               this.parseTextInputValue();
            }
            this.touchPointID = _loc2_.id;
            this.dispatchEventWith("beginInteraction");
            this.decrement();
            this.startRepeatTimer(this.decrement);
         }
      }
      
      protected function incrementButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.incrementButton,"ended",this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = -1;
            this._repeatTimer.stop();
            this.dispatchEventWith("endInteraction");
         }
         else
         {
            _loc2_ = param1.getTouch(this.incrementButton,"began");
            if(!_loc2_)
            {
               return;
            }
            if(this._textInputHasFocus)
            {
               this.parseTextInputValue();
            }
            this.touchPointID = _loc2_.id;
            this.dispatchEventWith("beginInteraction");
            this.increment();
            this.startRepeatTimer(this.increment);
         }
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 36)
         {
            param1.preventDefault();
            this.toMinimum();
         }
         else if(param1.keyCode == 35)
         {
            param1.preventDefault();
            this.toMaximum();
         }
         else if(param1.keyCode == 38)
         {
            param1.preventDefault();
            this.increment();
         }
         else if(param1.keyCode == 40)
         {
            param1.preventDefault();
            this.decrement();
         }
      }
      
      protected function repeatTimer_timerHandler(param1:TimerEvent) : void
      {
         if(this._repeatTimer.currentCount < 5)
         {
            return;
         }
         this.currentRepeatAction();
      }
   }
}
