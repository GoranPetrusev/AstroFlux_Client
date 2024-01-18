package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.IStateContext;
   import feathers.core.IStateObserver;
   import feathers.core.ITextRenderer;
   import feathers.core.IToggle;
   import feathers.skins.IStyleProvider;
   import feathers.text.BitmapFontTextFormat;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.display.MeshBatch;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.text.BitmapChar;
   import starling.text.BitmapFont;
   import starling.text.TextField;
   import starling.textures.Texture;
   import starling.utils.MathUtil;
   
   public class BitmapFontTextRenderer extends FeathersControl implements ITextRenderer, IStateObserver
   {
      
      private static var HELPER_IMAGE:Image;
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const HELPER_RESULT:MeasureTextResult = new MeasureTextResult();
      
      private static const CHARACTER_ID_SPACE:int = 32;
      
      private static const CHARACTER_ID_TAB:int = 9;
      
      private static const CHARACTER_ID_LINE_FEED:int = 10;
      
      private static const CHARACTER_ID_CARRIAGE_RETURN:int = 13;
      
      private static var CHARACTER_BUFFER:Vector.<CharLocation>;
      
      private static var CHAR_LOCATION_POOL:Vector.<CharLocation>;
      
      private static const FUZZY_MAX_WIDTH_PADDING:Number = 0.000001;
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var _characterBatch:MeshBatch;
      
      protected var _batchX:Number = 0;
      
      protected var _textFormatChanged:Boolean = true;
      
      protected var currentTextFormat:BitmapFontTextFormat;
      
      protected var _textFormatForState:Object;
      
      protected var _textFormat:BitmapFontTextFormat;
      
      protected var _disabledTextFormat:BitmapFontTextFormat;
      
      protected var _selectedTextFormat:BitmapFontTextFormat;
      
      protected var _text:String = null;
      
      protected var _textureSmoothing:String = "bilinear";
      
      protected var _pixelSnapping:Boolean = true;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _truncateToFit:Boolean = true;
      
      protected var _truncationText:String = "...";
      
      protected var _useSeparateBatch:Boolean = true;
      
      protected var _stateContext:IStateContext;
      
      private var _compilerWorkaround:Object;
      
      protected var _lastLayoutWidth:Number = 0;
      
      protected var _lastLayoutHeight:Number = 0;
      
      protected var _lastLayoutIsTruncated:Boolean = false;
      
      public function BitmapFontTextRenderer()
      {
         super();
         if(!CHAR_LOCATION_POOL)
         {
            CHAR_LOCATION_POOL = new Vector.<CharLocation>(0);
         }
         if(!CHARACTER_BUFFER)
         {
            CHARACTER_BUFFER = new Vector.<CharLocation>(0);
         }
         this.isQuickHitAreaEnabled = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return BitmapFontTextRenderer.globalStyleProvider;
      }
      
      override public function set maxWidth(param1:Number) : void
      {
         var _loc2_:Boolean = param1 > this._explicitMaxWidth && this._lastLayoutIsTruncated;
         super.maxWidth = param1;
         if(_loc2_)
         {
            this.invalidate("size");
         }
      }
      
      public function get textFormat() : BitmapFontTextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this.invalidate("styles");
      }
      
      public function get disabledTextFormat() : BitmapFontTextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate("styles");
      }
      
      public function get selectedTextFormat() : BitmapFontTextFormat
      {
         return this._selectedTextFormat;
      }
      
      public function set selectedTextFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._selectedTextFormat == param1)
         {
            return;
         }
         this._selectedTextFormat = param1;
         this.invalidate("styles");
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate("data");
      }
      
      public function get textureSmoothing() : String
      {
         return this._textureSmoothing;
      }
      
      public function set textureSmoothing(param1:String) : void
      {
         if(this._textureSmoothing == param1)
         {
            return;
         }
         this._textureSmoothing = param1;
         this.invalidate("styles");
      }
      
      public function get pixelSnapping() : Boolean
      {
         return _pixelSnapping;
      }
      
      public function set pixelSnapping(param1:Boolean) : void
      {
         if(this._pixelSnapping === param1)
         {
            return;
         }
         this._pixelSnapping = param1;
         this.invalidate("styles");
      }
      
      public function get wordWrap() : Boolean
      {
         return _wordWrap;
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
      
      public function get truncateToFit() : Boolean
      {
         return _truncateToFit;
      }
      
      public function set truncateToFit(param1:Boolean) : void
      {
         if(this._truncateToFit == param1)
         {
            return;
         }
         this._truncateToFit = param1;
         this.invalidate("data");
      }
      
      public function get truncationText() : String
      {
         return _truncationText;
      }
      
      public function set truncationText(param1:String) : void
      {
         if(this._truncationText == param1)
         {
            return;
         }
         this._truncationText = param1;
         this.invalidate("data");
      }
      
      public function get useSeparateBatch() : Boolean
      {
         return this._useSeparateBatch;
      }
      
      public function set useSeparateBatch(param1:Boolean) : void
      {
         if(this._useSeparateBatch == param1)
         {
            return;
         }
         this._useSeparateBatch = param1;
         this.invalidate("styles");
      }
      
      public function get baseline() : Number
      {
         if(!this._textFormat)
         {
            return 0;
         }
         var _loc4_:BitmapFont = this._textFormat.font;
         var _loc1_:Number = this._textFormat.size;
         var _loc3_:Number = _loc1_ / _loc4_.size;
         if(_loc3_ !== _loc3_)
         {
            _loc3_ = 1;
         }
         var _loc2_:Number = _loc4_.baseline;
         this._compilerWorkaround = _loc2_;
         if(_loc2_ !== _loc2_)
         {
            return _loc4_.lineHeight * _loc3_;
         }
         return _loc2_ * _loc3_;
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
      
      override public function dispose() : void
      {
         this.stateContext = null;
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         this._characterBatch.x = this._batchX;
         super.render(param1);
      }
      
      public function measureText(param1:Point = null) : Point
      {
         var _loc15_:int = 0;
         var _loc14_:int = 0;
         var _loc16_:BitmapChar = null;
         var _loc22_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc24_:Boolean = false;
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc13_:* = this._explicitWidth !== this._explicitWidth;
         var _loc10_:* = this._explicitHeight !== this._explicitHeight;
         if(!_loc13_ && !_loc10_)
         {
            param1.x = this._explicitWidth;
            param1.y = this._explicitHeight;
            return param1;
         }
         if(this.isInvalid("styles") || this.isInvalid("state"))
         {
            this.refreshTextFormat();
         }
         if(!this.currentTextFormat || this._text === null)
         {
            param1.setTo(0,0);
            return param1;
         }
         var _loc26_:BitmapFont = this.currentTextFormat.font;
         var _loc17_:Number = this.currentTextFormat.size;
         var _loc19_:Number = this.currentTextFormat.letterSpacing;
         var _loc3_:Boolean = this.currentTextFormat.isKerningEnabled;
         var _loc7_:Number = _loc17_ / _loc26_.size;
         if(_loc7_ !== _loc7_)
         {
            _loc7_ = 1;
         }
         var _loc23_:Number = _loc26_.lineHeight * _loc7_ + this.currentTextFormat.leading;
         var _loc6_:Number = this._explicitWidth;
         if(_loc6_ !== _loc6_)
         {
            _loc6_ = this._explicitMaxWidth;
         }
         var _loc5_:* = 0;
         var _loc20_:Number = 0;
         var _loc8_:Number = 0;
         var _loc21_:Number = NaN;
         var _loc2_:int = this._text.length;
         var _loc12_:* = 0;
         var _loc11_:Number = 0;
         var _loc18_:int = 0;
         var _loc4_:String = "";
         var _loc25_:String = "";
         _loc15_ = 0;
         while(_loc15_ < _loc2_)
         {
            if((_loc14_ = this._text.charCodeAt(_loc15_)) == 10 || _loc14_ == 13)
            {
               if((_loc20_ -= _loc19_) < 0)
               {
                  _loc20_ = 0;
               }
               if(_loc5_ < _loc20_)
               {
                  _loc5_ = _loc20_;
               }
               _loc21_ = NaN;
               _loc20_ = 0;
               _loc8_ += _loc23_;
               _loc12_ = 0;
               _loc18_ = 0;
               _loc11_ = 0;
            }
            else if(!(_loc16_ = _loc26_.getChar(_loc14_)))
            {
               trace("Missing character " + String.fromCharCode(_loc14_) + " in font " + _loc26_.name + ".");
            }
            else
            {
               if(_loc3_ && _loc21_ === _loc21_)
               {
                  _loc20_ += _loc16_.getKerning(_loc21_) * _loc7_;
               }
               _loc22_ = _loc16_.xAdvance * _loc7_;
               if(this._wordWrap)
               {
                  _loc9_ = _loc14_ == 32 || _loc14_ == 9;
                  _loc24_ = _loc21_ == 32 || _loc21_ == 9;
                  if(_loc9_)
                  {
                     if(!_loc24_)
                     {
                        _loc11_ = 0;
                     }
                     _loc11_ += _loc22_;
                  }
                  else if(_loc24_)
                  {
                     _loc12_ = _loc20_;
                     _loc18_++;
                     _loc4_ += _loc25_;
                     _loc25_ = "";
                  }
                  if(!_loc9_ && _loc18_ > 0 && _loc20_ + _loc22_ > _loc6_)
                  {
                     _loc11_ = _loc12_ - _loc11_;
                     if(_loc5_ < _loc11_)
                     {
                        _loc5_ = _loc11_;
                     }
                     _loc21_ = NaN;
                     _loc20_ -= _loc12_;
                     _loc8_ += _loc23_;
                     _loc12_ = 0;
                     _loc11_ = 0;
                     _loc18_ = 0;
                     _loc4_ = "";
                  }
               }
               _loc20_ += _loc22_ + _loc19_;
               _loc21_ = _loc14_;
               _loc25_ += String.fromCharCode(_loc14_);
            }
            _loc15_++;
         }
         if((_loc20_ -= _loc19_) < 0)
         {
            _loc20_ = 0;
         }
         if(this._wordWrap)
         {
            while(_loc20_ > _loc6_ && !MathUtil.isEquivalent(_loc20_,_loc6_))
            {
               _loc20_ -= _loc6_;
               _loc8_ += _loc23_;
            }
         }
         if(_loc5_ < _loc20_)
         {
            _loc5_ = _loc20_;
         }
         if(_loc13_)
         {
            param1.x = _loc5_;
         }
         else
         {
            param1.x = this._explicitWidth;
         }
         if(_loc10_)
         {
            param1.y = _loc8_ + _loc23_ - this.currentTextFormat.leading;
         }
         else
         {
            param1.y = this._explicitHeight;
         }
         return param1;
      }
      
      public function setTextFormatForState(param1:String, param2:BitmapFontTextFormat) : void
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
         if(!this._characterBatch)
         {
            this._characterBatch = new MeshBatch();
            this._characterBatch.touchable = false;
            this.addChild(this._characterBatch);
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:* = false;
         var _loc4_:Boolean = this.isInvalid("data");
         var _loc5_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("state");
         if(_loc5_ || _loc3_)
         {
            this.refreshTextFormat();
         }
         if(_loc5_)
         {
            this._characterBatch.pixelSnapping = this._pixelSnapping;
            this._characterBatch.batchable = !this._useSeparateBatch;
         }
         var _loc2_:Number = this._explicitWidth;
         if(_loc2_ !== _loc2_)
         {
            _loc2_ = this._explicitMaxWidth;
         }
         if(this._wordWrap)
         {
            _loc1_ = _loc2_ !== this._lastLayoutWidth;
         }
         else
         {
            _loc1_ = _loc2_ < this._lastLayoutWidth;
            if(!_loc1_)
            {
               _loc1_ = this._lastLayoutIsTruncated && _loc2_ !== this._lastLayoutWidth;
            }
         }
         if(_loc4_ || _loc1_ || this._textFormatChanged)
         {
            this._textFormatChanged = false;
            this._characterBatch.clear();
            if(!this.currentTextFormat || this._text === null)
            {
               this.saveMeasurements(0,0,0,0);
               return;
            }
            this.layoutCharacters(HELPER_RESULT);
            this._lastLayoutWidth = HELPER_RESULT.width;
            this._lastLayoutHeight = HELPER_RESULT.height;
            this._lastLayoutIsTruncated = HELPER_RESULT.isTruncated;
         }
         this.saveMeasurements(this._lastLayoutWidth,this._lastLayoutHeight,this._lastLayoutWidth,this._lastLayoutHeight);
      }
      
      protected function layoutCharacters(param1:MeasureTextResult = null) : MeasureTextResult
      {
         var _loc17_:String = null;
         var _loc20_:int = 0;
         var _loc18_:int = 0;
         var _loc21_:BitmapChar = null;
         var _loc28_:Number = NaN;
         var _loc13_:Boolean = false;
         var _loc31_:Boolean = false;
         var _loc29_:CharLocation = null;
         var _loc9_:String = null;
         if(!param1)
         {
            param1 = new MeasureTextResult();
         }
         var _loc32_:BitmapFont = this.currentTextFormat.font;
         var _loc22_:Number = this.currentTextFormat.size;
         var _loc25_:Number = this.currentTextFormat.letterSpacing;
         var _loc3_:Boolean = this.currentTextFormat.isKerningEnabled;
         var _loc7_:Number = _loc22_ / _loc32_.size;
         if(_loc7_ !== _loc7_)
         {
            _loc7_ = 1;
         }
         var _loc30_:Number = _loc32_.lineHeight * _loc7_ + this.currentTextFormat.leading;
         var _loc10_:Number = _loc32_.offsetX * _loc7_;
         var _loc12_:Number = _loc32_.offsetY * _loc7_;
         var _loc11_:* = this._explicitWidth === this._explicitWidth;
         var _loc23_:* = this.currentTextFormat.align != "left";
         var _loc6_:Number = _loc11_ ? this._explicitWidth : this._explicitMaxWidth;
         if(_loc23_ && _loc6_ == Infinity)
         {
            this.measureText(HELPER_POINT);
            _loc6_ = HELPER_POINT.x;
         }
         var _loc14_:* = this._text;
         if(this._truncateToFit)
         {
            _loc17_ = this.getTruncatedText(_loc6_);
            param1.isTruncated = _loc17_ !== _loc14_;
            _loc14_ = _loc17_;
         }
         else
         {
            param1.isTruncated = false;
         }
         CHARACTER_BUFFER.length = 0;
         var _loc5_:* = 0;
         var _loc26_:Number = 0;
         var _loc8_:Number = 0;
         var _loc27_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc16_:* = 0;
         var _loc15_:Number = 0;
         var _loc19_:int = 0;
         var _loc24_:int = 0;
         var _loc2_:int = int(!!_loc14_ ? _loc14_.length : 0);
         _loc20_ = 0;
         while(_loc20_ < _loc2_)
         {
            _loc4_ = false;
            if((_loc18_ = _loc14_.charCodeAt(_loc20_)) == 10 || _loc18_ == 13)
            {
               if((_loc26_ -= _loc25_) < 0)
               {
                  _loc26_ = 0;
               }
               if(this._wordWrap || _loc23_)
               {
                  this.alignBuffer(_loc6_,_loc26_,0);
                  this.addBufferToBatch(0);
               }
               if(_loc5_ < _loc26_)
               {
                  _loc5_ = _loc26_;
               }
               _loc27_ = NaN;
               _loc26_ = 0;
               _loc8_ += _loc30_;
               _loc16_ = 0;
               _loc15_ = 0;
               _loc19_ = 0;
               _loc24_ = 0;
            }
            else if(!(_loc21_ = _loc32_.getChar(_loc18_)))
            {
               trace("Missing character " + String.fromCharCode(_loc18_) + " in font " + _loc32_.name + ".");
            }
            else
            {
               if(_loc3_ && _loc27_ === _loc27_)
               {
                  _loc26_ += _loc21_.getKerning(_loc27_) * _loc7_;
               }
               _loc28_ = _loc21_.xAdvance * _loc7_;
               if(this._wordWrap)
               {
                  _loc13_ = _loc18_ == 32 || _loc18_ == 9;
                  _loc31_ = _loc27_ == 32 || _loc27_ == 9;
                  if(_loc13_)
                  {
                     if(!_loc31_)
                     {
                        _loc15_ = 0;
                     }
                     _loc15_ += _loc28_;
                  }
                  else if(_loc31_)
                  {
                     _loc16_ = _loc26_;
                     _loc19_ = 0;
                     _loc24_++;
                     _loc4_ = true;
                  }
                  if(_loc4_ && !_loc23_)
                  {
                     this.addBufferToBatch(0);
                  }
                  if(!_loc13_ && _loc24_ > 0 && _loc26_ + _loc28_ - _loc6_ > 0.000001)
                  {
                     if(_loc23_)
                     {
                        this.trimBuffer(_loc19_);
                        this.alignBuffer(_loc6_,_loc16_ - _loc15_,_loc19_);
                        this.addBufferToBatch(_loc19_);
                     }
                     this.moveBufferedCharacters(-_loc16_,_loc30_,0);
                     _loc15_ = _loc16_ - _loc15_;
                     if(_loc5_ < _loc15_)
                     {
                        _loc5_ = _loc15_;
                     }
                     _loc27_ = NaN;
                     _loc26_ -= _loc16_;
                     _loc8_ += _loc30_;
                     _loc16_ = 0;
                     _loc15_ = 0;
                     _loc19_ = 0;
                     _loc4_ = false;
                     _loc24_ = 0;
                  }
               }
               if(this._wordWrap || _loc23_)
               {
                  (_loc29_ = CHAR_LOCATION_POOL.length > 0 ? CHAR_LOCATION_POOL.shift() : new CharLocation()).char = _loc21_;
                  _loc29_.x = _loc26_ + _loc10_ + _loc21_.xOffset * _loc7_;
                  _loc29_.y = _loc8_ + _loc12_ + _loc21_.yOffset * _loc7_;
                  _loc29_.scale = _loc7_;
                  CHARACTER_BUFFER[CHARACTER_BUFFER.length] = _loc29_;
                  _loc19_++;
               }
               else
               {
                  this.addCharacterToBatch(_loc21_,_loc26_ + _loc10_ + _loc21_.xOffset * _loc7_,_loc8_ + _loc12_ + _loc21_.yOffset * _loc7_,_loc7_);
               }
               _loc26_ += _loc28_ + _loc25_;
               _loc27_ = _loc18_;
            }
            _loc20_++;
         }
         if((_loc26_ -= _loc25_) < 0)
         {
            _loc26_ = 0;
         }
         if(this._wordWrap || _loc23_)
         {
            this.alignBuffer(_loc6_,_loc26_,0);
            this.addBufferToBatch(0);
         }
         if(this._wordWrap)
         {
            while(_loc26_ > _loc6_ && !MathUtil.isEquivalent(_loc26_,_loc6_))
            {
               _loc26_ -= _loc6_;
               _loc8_ += _loc30_;
            }
         }
         if(_loc5_ < _loc26_)
         {
            _loc5_ = _loc26_;
         }
         if(_loc23_ && !_loc11_)
         {
            if((_loc9_ = this._textFormat.align) == "center")
            {
               this._batchX = (_loc5_ - _loc6_) / 2;
            }
            else if(_loc9_ == "right")
            {
               this._batchX = _loc5_ - _loc6_;
            }
         }
         else
         {
            this._batchX = 0;
         }
         this._characterBatch.x = this._batchX;
         param1.width = _loc5_;
         param1.height = _loc8_ + _loc30_ - this.currentTextFormat.leading;
         return param1;
      }
      
      protected function trimBuffer(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:CharLocation = null;
         var _loc7_:BitmapChar = null;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = CHARACTER_BUFFER.length - param1;
         _loc5_ = _loc3_ - 1;
         while(_loc5_ >= 0)
         {
            if(!((_loc4_ = (_loc7_ = (_loc6_ = CHARACTER_BUFFER[_loc5_]).char).charID) == 32 || _loc4_ == 9))
            {
               break;
            }
            _loc2_++;
            _loc5_--;
         }
         if(_loc2_ > 0)
         {
            CHARACTER_BUFFER.splice(_loc5_ + 1,_loc2_);
         }
      }
      
      protected function alignBuffer(param1:Number, param2:Number, param3:int) : void
      {
         var _loc4_:String;
         if((_loc4_ = this.currentTextFormat.align) == "center")
         {
            this.moveBufferedCharacters(Math.round((param1 - param2) / 2),0,param3);
         }
         else if(_loc4_ == "right")
         {
            this.moveBufferedCharacters(param1 - param2,0,param3);
         }
      }
      
      protected function addBufferToBatch(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:CharLocation = null;
         var _loc2_:int = CHARACTER_BUFFER.length - param1;
         var _loc5_:int = int(CHAR_LOCATION_POOL.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = CHARACTER_BUFFER.shift();
            this.addCharacterToBatch(_loc4_.char,_loc4_.x,_loc4_.y,_loc4_.scale);
            _loc4_.char = null;
            CHAR_LOCATION_POOL[_loc5_] = _loc4_;
            _loc5_++;
            _loc3_++;
         }
      }
      
      protected function moveBufferedCharacters(param1:Number, param2:Number, param3:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:CharLocation = null;
         var _loc4_:int = CHARACTER_BUFFER.length - param3;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = CHARACTER_BUFFER[_loc5_];
            _loc6_.x = _loc6_.x + param1;
            _loc6_.y += param2;
            _loc5_++;
         }
      }
      
      protected function addCharacterToBatch(param1:BitmapChar, param2:Number, param3:Number, param4:Number, param5:Painter = null) : void
      {
         var _loc7_:Rectangle;
         var _loc6_:Texture;
         if(_loc7_ = (_loc6_ = param1.texture).frame)
         {
            if(_loc7_.width === 0 || _loc7_.height === 0)
            {
               return;
            }
         }
         else if(_loc6_.width === 0 || _loc6_.height === 0)
         {
            return;
         }
         if(!HELPER_IMAGE)
         {
            HELPER_IMAGE = new Image(_loc6_);
         }
         else
         {
            HELPER_IMAGE.texture = _loc6_;
            HELPER_IMAGE.readjustSize();
         }
         HELPER_IMAGE.scaleX = HELPER_IMAGE.scaleY = param4;
         HELPER_IMAGE.x = param2;
         HELPER_IMAGE.y = param3;
         HELPER_IMAGE.color = this.currentTextFormat.color;
         HELPER_IMAGE.textureSmoothing = this._textureSmoothing;
         HELPER_IMAGE.pixelSnapping = this._pixelSnapping;
         if(param5 !== null)
         {
            param5.pushState();
            param5.setStateTo(HELPER_IMAGE.transformationMatrix);
            param5.batchMesh(HELPER_IMAGE);
            param5.popState();
         }
         else
         {
            this._characterBatch.addMesh(HELPER_IMAGE);
         }
      }
      
      protected function refreshTextFormat() : void
      {
         var _loc2_:BitmapFontTextFormat = null;
         var _loc1_:String = null;
         if(this._stateContext && this._textFormatForState)
         {
            _loc1_ = this._stateContext.currentState;
            if(_loc1_ in this._textFormatForState)
            {
               _loc2_ = BitmapFontTextFormat(this._textFormatForState[_loc1_]);
            }
         }
         if(!_loc2_ && !this._isEnabled && this._disabledTextFormat)
         {
            _loc2_ = this._disabledTextFormat;
         }
         if(!_loc2_ && this._selectedTextFormat && this._stateContext is IToggle && IToggle(this._stateContext).isSelected)
         {
            _loc2_ = this._selectedTextFormat;
         }
         if(!_loc2_)
         {
            if(!this._textFormat)
            {
               if(!TextField.getBitmapFont("mini"))
               {
                  TextField.registerBitmapFont(new BitmapFont());
               }
               this._textFormat = new BitmapFontTextFormat("mini",NaN,0);
            }
            _loc2_ = this._textFormat;
         }
         if(this.currentTextFormat !== _loc2_)
         {
            this.currentTextFormat = _loc2_;
            this._textFormatChanged = true;
         }
      }
      
      protected function getTruncatedText(param1:Number) : String
      {
         var _loc7_:* = 0;
         var _loc5_:int = 0;
         var _loc8_:BitmapChar = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(!this._text)
         {
            return "";
         }
         if(param1 == Infinity || this._wordWrap || this._text.indexOf(String.fromCharCode(10)) >= 0 || this._text.indexOf(String.fromCharCode(13)) >= 0)
         {
            return this._text;
         }
         var _loc15_:BitmapFont = this.currentTextFormat.font;
         var _loc9_:Number = this.currentTextFormat.size;
         var _loc10_:Number = this.currentTextFormat.letterSpacing;
         var _loc4_:Boolean = this.currentTextFormat.isKerningEnabled;
         var _loc6_:Number = _loc9_ / _loc15_.size;
         if(_loc6_ !== _loc6_)
         {
            _loc6_ = 1;
         }
         var _loc11_:Number = 0;
         var _loc12_:Number = NaN;
         var _loc2_:int = this._text.length;
         var _loc3_:* = -1;
         _loc7_ = 0;
         while(_loc7_ < _loc2_)
         {
            _loc5_ = this._text.charCodeAt(_loc7_);
            if(_loc8_ = _loc15_.getChar(_loc5_))
            {
               _loc13_ = 0;
               if(_loc4_ && _loc12_ === _loc12_)
               {
                  _loc13_ = _loc8_.getKerning(_loc12_) * _loc6_;
               }
               if((_loc11_ += _loc13_ + _loc8_.xAdvance * _loc6_) > param1)
               {
                  if((_loc14_ = Math.abs(_loc11_ - param1)) > 0.000001)
                  {
                     _loc3_ = _loc7_;
                     break;
                  }
               }
               _loc11_ += _loc10_;
               _loc12_ = _loc5_;
            }
            _loc7_++;
         }
         if(_loc3_ >= 0)
         {
            _loc2_ = this._truncationText.length;
            _loc7_ = 0;
            while(_loc7_ < _loc2_)
            {
               _loc5_ = this._truncationText.charCodeAt(_loc7_);
               if(_loc8_ = _loc15_.getChar(_loc5_))
               {
                  _loc13_ = 0;
                  if(_loc4_ && _loc12_ === _loc12_)
                  {
                     _loc13_ = _loc8_.getKerning(_loc12_) * _loc6_;
                  }
                  _loc11_ += _loc13_ + _loc8_.xAdvance * _loc6_ + _loc10_;
                  _loc12_ = _loc5_;
               }
               _loc7_++;
            }
            _loc11_ -= _loc10_;
            _loc7_ = _loc3_;
            while(_loc7_ >= 0)
            {
               _loc5_ = this._text.charCodeAt(_loc7_);
               _loc12_ = _loc7_ > 0 ? this._text.charCodeAt(_loc7_ - 1) : NaN;
               if(_loc8_ = _loc15_.getChar(_loc5_))
               {
                  _loc13_ = 0;
                  if(_loc4_ && _loc12_ === _loc12_)
                  {
                     _loc13_ = _loc8_.getKerning(_loc12_) * _loc6_;
                  }
                  if((_loc11_ -= _loc13_ + _loc8_.xAdvance * _loc6_ + _loc10_) <= param1)
                  {
                     return this._text.substr(0,_loc7_) + this._truncationText;
                  }
               }
               _loc7_--;
            }
            return this._truncationText;
         }
         return this._text;
      }
      
      protected function stateContext_stateChangeHandler(param1:Event) : void
      {
         this.invalidate("state");
      }
   }
}

import starling.text.BitmapChar;

class CharLocation
{
    
   
   public var char:BitmapChar;
   
   public var scale:Number;
   
   public var x:Number;
   
   public var y:Number;
   
   public function CharLocation()
   {
      super();
   }
}
