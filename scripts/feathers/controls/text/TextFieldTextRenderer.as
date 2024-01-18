package feathers.controls.text
{
   import feathers.core.FeathersControl;
   import feathers.core.IStateContext;
   import feathers.core.IStateObserver;
   import feathers.core.ITextRenderer;
   import feathers.core.IToggle;
   import feathers.skins.IStyleProvider;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import feathers.utils.math.roundUpToNearest;
   import flash.display.BitmapData;
   import flash.filters.BitmapFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.utils.MathUtil;
   
   public class TextFieldTextRenderer extends FeathersControl implements ITextRenderer, IStateObserver
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_RECTANGLE:Rectangle = new Rectangle();
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var textField:TextField;
      
      protected var textSnapshot:Image;
      
      protected var textSnapshots:Vector.<Image>;
      
      protected var _textSnapshotOffsetX:Number = 0;
      
      protected var _textSnapshotOffsetY:Number = 0;
      
      protected var _previousActualWidth:Number = NaN;
      
      protected var _previousActualHeight:Number = NaN;
      
      protected var _snapshotWidth:int = 0;
      
      protected var _snapshotHeight:int = 0;
      
      protected var _snapshotVisibleWidth:int = 0;
      
      protected var _snapshotVisibleHeight:int = 0;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _hasMeasured:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _isHTML:Boolean = false;
      
      protected var currentTextFormat:TextFormat;
      
      protected var _textFormatForState:Object;
      
      protected var _textFormat:TextFormat;
      
      protected var _disabledTextFormat:TextFormat;
      
      protected var _selectedTextFormat:TextFormat;
      
      protected var _styleSheet:StyleSheet;
      
      protected var _embedFonts:Boolean = false;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _pixelSnapping:Boolean = true;
      
      private var _antiAliasType:String = "advanced";
      
      private var _background:Boolean = false;
      
      private var _backgroundColor:uint = 16777215;
      
      private var _border:Boolean = false;
      
      private var _borderColor:uint = 0;
      
      private var _condenseWhite:Boolean = false;
      
      private var _displayAsPassword:Boolean = false;
      
      private var _gridFitType:String = "pixel";
      
      private var _sharpness:Number = 0;
      
      private var _thickness:Number = 0;
      
      protected var _maxTextureDimensions:int = 2048;
      
      protected var _nativeFilters:Array;
      
      protected var _useGutter:Boolean = false;
      
      protected var _stateContext:IStateContext;
      
      protected var _lastGlobalScaleX:Number = 0;
      
      protected var _lastGlobalScaleY:Number = 0;
      
      protected var _lastContentScaleFactor:Number = 0;
      
      protected var _updateSnapshotOnScaleChange:Boolean = false;
      
      protected var _useSnapshotDelayWorkaround:Boolean = false;
      
      public function TextFieldTextRenderer()
      {
         super();
         this.isQuickHitAreaEnabled = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return TextFieldTextRenderer.globalStyleProvider;
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
         if(param1 === null)
         {
            param1 = "";
         }
         this._text = param1;
         this.invalidate("data");
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
      
      public function get selectedTextFormat() : TextFormat
      {
         return this._selectedTextFormat;
      }
      
      public function set selectedTextFormat(param1:TextFormat) : void
      {
         if(this._selectedTextFormat == param1)
         {
            return;
         }
         this._selectedTextFormat = param1;
         this.invalidate("styles");
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
      
      public function set styleSheet(param1:StyleSheet) : void
      {
         if(this._styleSheet == param1)
         {
            return;
         }
         this._styleSheet = param1;
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
      
      public function get pixelSnapping() : Boolean
      {
         return this._pixelSnapping;
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
      
      public function get condenseWhite() : Boolean
      {
         return this._condenseWhite;
      }
      
      public function set condenseWhite(param1:Boolean) : void
      {
         if(this._condenseWhite == param1)
         {
            return;
         }
         this._condenseWhite = param1;
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
      
      public function get maxTextureDimensions() : int
      {
         return this._maxTextureDimensions;
      }
      
      public function set maxTextureDimensions(param1:int) : void
      {
         if(Starling.current.profile == "baselineConstrained")
         {
            param1 = MathUtil.getNextPowerOfTwo(param1);
         }
         if(this._maxTextureDimensions == param1)
         {
            return;
         }
         this._maxTextureDimensions = param1;
         this._needsNewTexture = true;
         this.invalidate("size");
      }
      
      public function get nativeFilters() : Array
      {
         return this._nativeFilters;
      }
      
      public function set nativeFilters(param1:Array) : void
      {
         if(this._nativeFilters == param1)
         {
            return;
         }
         this._nativeFilters = param1;
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
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Image = null;
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         if(this.textSnapshots)
         {
            _loc1_ = int(this.textSnapshots.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this.textSnapshots[_loc2_];
               _loc3_.texture.dispose();
               this.removeChild(_loc3_,true);
               _loc2_++;
            }
            this.textSnapshots = null;
         }
         this.textField = null;
         this.stateContext = null;
         this._previousActualWidth = NaN;
         this._previousActualHeight = NaN;
         this._needsNewTexture = false;
         this._snapshotWidth = 0;
         this._snapshotHeight = 0;
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc13_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc2_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc12_:* = NaN;
         var _loc14_:Image = null;
         if(this.textSnapshot)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            if(this._updateSnapshotOnScaleChange)
            {
               _loc3_ = matrixToScaleX(HELPER_MATRIX);
               _loc4_ = matrixToScaleY(HELPER_MATRIX);
               if(_loc3_ != this._lastGlobalScaleX || _loc4_ != this._lastGlobalScaleY || Starling.contentScaleFactor != this._lastContentScaleFactor)
               {
                  this.invalidate("size");
                  this.validate();
               }
            }
            _loc5_ = Starling.current.contentScaleFactor;
            if(!this._nativeFilters || this._nativeFilters.length === 0)
            {
               _loc8_ = 0;
               _loc9_ = 0;
            }
            else
            {
               _loc8_ = this._textSnapshotOffsetX / _loc5_;
               _loc9_ = this._textSnapshotOffsetY / _loc5_;
            }
            _loc13_ = -1;
            _loc10_ = this._snapshotWidth;
            _loc11_ = this._snapshotHeight;
            _loc2_ = _loc8_;
            _loc6_ = _loc9_;
            do
            {
               if((_loc7_ = _loc10_) > this._maxTextureDimensions)
               {
                  _loc7_ = this._maxTextureDimensions;
               }
               do
               {
                  if((_loc12_ = _loc11_) > this._maxTextureDimensions)
                  {
                     _loc12_ = this._maxTextureDimensions;
                  }
                  if(_loc13_ < 0)
                  {
                     _loc14_ = this.textSnapshot;
                  }
                  else
                  {
                     _loc14_ = this.textSnapshots[_loc13_];
                  }
                  _loc14_.x = _loc2_ / _loc5_;
                  _loc14_.y = _loc6_ / _loc5_;
                  if(this._updateSnapshotOnScaleChange)
                  {
                     _loc14_.x /= this._lastGlobalScaleX;
                     _loc14_.y /= this._lastGlobalScaleX;
                  }
                  _loc13_++;
                  _loc6_ += _loc12_;
               }
               while((_loc11_ -= _loc12_) > 0);
               
               _loc2_ += _loc7_;
               _loc10_ -= _loc7_;
               _loc6_ = _loc9_;
               _loc11_ = this._snapshotHeight;
            }
            while(_loc10_ > 0);
            
         }
         super.render(param1);
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
         var _loc1_:Number = NaN;
         if(!this.textField)
         {
            this.textField = new TextField();
            _loc1_ = Starling.contentScaleFactor;
            this.textField.scaleX = _loc1_;
            this.textField.scaleY = _loc1_;
            this.textField.mouseEnabled = this.textField.mouseWheelEnabled = false;
            this.textField.selectable = false;
            this.textField.multiline = true;
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid("size");
         this.commit();
         this._hasMeasured = false;
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layout(_loc1_);
      }
      
      protected function commit() : void
      {
         var _loc2_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc1_:Boolean = this.isInvalid("state");
         if(_loc2_ || _loc1_)
         {
            this.refreshTextFormat();
         }
         if(_loc2_)
         {
            this.textField.antiAliasType = this._antiAliasType;
            this.textField.background = this._background;
            this.textField.backgroundColor = this._backgroundColor;
            this.textField.border = this._border;
            this.textField.borderColor = this._borderColor;
            this.textField.condenseWhite = this._condenseWhite;
            this.textField.displayAsPassword = this._displayAsPassword;
            this.textField.gridFitType = this._gridFitType;
            this.textField.sharpness = this._sharpness;
            this.textField.thickness = this._thickness;
            this.textField.filters = this._nativeFilters;
         }
         if(_loc3_ || _loc2_ || _loc1_)
         {
            this.textField.wordWrap = this._wordWrap;
            this.textField.embedFonts = this._embedFonts;
            if(this._styleSheet)
            {
               this.textField.styleSheet = this._styleSheet;
            }
            else
            {
               this.textField.styleSheet = null;
               this.textField.defaultTextFormat = this.currentTextFormat;
            }
            if(this._isHTML)
            {
               this.textField.htmlText = this._text;
            }
            else
            {
               this.textField.text = this._text;
            }
         }
      }
      
      protected function measure(param1:Point = null) : Point
      {
         var _loc2_:Number = NaN;
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc4_:* = this._explicitWidth !== this._explicitWidth;
         var _loc7_:* = this._explicitHeight !== this._explicitHeight;
         this.textField.autoSize = "left";
         this.textField.wordWrap = false;
         var _loc6_:Number = Starling.contentScaleFactor;
         var _loc8_:Number = 4;
         if(this._useGutter)
         {
            _loc8_ = 0;
         }
         var _loc3_:Number = this._explicitWidth;
         if(_loc4_)
         {
            _loc2_ = this.textField.width;
            _loc3_ = this.textField.width / _loc6_ - _loc8_;
            if(_loc3_ < this._explicitMinWidth)
            {
               _loc3_ = this._explicitMinWidth;
            }
            else if(_loc3_ > this._explicitMaxWidth)
            {
               _loc3_ = this._explicitMaxWidth;
            }
         }
         if(!_loc4_ || this.textField.width / _loc6_ - _loc8_ > _loc3_)
         {
            this.textField.width = _loc3_ + _loc8_;
            this.textField.wordWrap = this._wordWrap;
         }
         var _loc5_:Number = this._explicitHeight;
         if(_loc7_)
         {
            _loc5_ = this.textField.height / _loc6_ - _loc8_;
            if((_loc5_ = roundUpToNearest(_loc5_,0.05)) < this._explicitMinHeight)
            {
               _loc5_ = this._explicitMinHeight;
            }
            else if(_loc5_ > this._explicitMaxHeight)
            {
               _loc5_ = this._explicitMaxHeight;
            }
         }
         this.textField.autoSize = "none";
         this.textField.width = this.actualWidth + _loc8_;
         this.textField.height = this.actualHeight + _loc8_;
         param1.x = _loc3_;
         param1.y = _loc5_;
         this._hasMeasured = true;
         return param1;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc12_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc11_:BitmapData = null;
         var _loc9_:* = false;
         var _loc10_:ConcreteTexture = null;
         var _loc8_:* = false;
         var _loc4_:Boolean = this.isInvalid("styles");
         var _loc5_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("state");
         var _loc3_:Number = Starling.contentScaleFactor;
         var _loc6_:Number = 4;
         if(this._useGutter)
         {
            _loc6_ = 0;
         }
         if(!this._hasMeasured && this._wordWrap)
         {
            this.textField.autoSize = "left";
            this.textField.wordWrap = false;
            if(this.textField.width / _loc3_ - _loc6_ > this.actualWidth)
            {
               this.textField.wordWrap = true;
            }
            this.textField.autoSize = "none";
            this.textField.width = this.actualWidth + _loc6_;
         }
         if(param1)
         {
            this.textField.width = this.actualWidth + _loc6_;
            this.textField.height = this.actualHeight + _loc6_;
            _loc12_ = Math.ceil(this.actualWidth * _loc3_);
            _loc7_ = Math.ceil(this.actualHeight * _loc3_);
            if(this._updateSnapshotOnScaleChange)
            {
               this.getTransformationMatrix(this.stage,HELPER_MATRIX);
               _loc12_ *= matrixToScaleX(HELPER_MATRIX);
               _loc7_ *= matrixToScaleY(HELPER_MATRIX);
            }
            if(_loc12_ >= 1 && _loc7_ >= 1 && this._nativeFilters && this._nativeFilters.length > 0)
            {
               HELPER_MATRIX.identity();
               HELPER_MATRIX.scale(_loc3_,_loc3_);
               (_loc11_ = new BitmapData(_loc12_,_loc7_,true,16711935)).draw(this.textField,HELPER_MATRIX,null,null,HELPER_RECTANGLE);
               this.measureNativeFilters(_loc11_,HELPER_RECTANGLE);
               _loc11_.dispose();
               _loc11_ = null;
               this._textSnapshotOffsetX = HELPER_RECTANGLE.x;
               this._textSnapshotOffsetY = HELPER_RECTANGLE.y;
               _loc12_ = HELPER_RECTANGLE.width;
               _loc7_ = HELPER_RECTANGLE.height;
            }
            if(_loc9_ = Starling.current.profile != "baselineConstrained")
            {
               if(_loc12_ > this._maxTextureDimensions)
               {
                  this._snapshotWidth = int(_loc12_ / this._maxTextureDimensions) * this._maxTextureDimensions + _loc12_ % this._maxTextureDimensions;
               }
               else
               {
                  this._snapshotWidth = _loc12_;
               }
            }
            else if(_loc12_ > this._maxTextureDimensions)
            {
               this._snapshotWidth = int(_loc12_ / this._maxTextureDimensions) * this._maxTextureDimensions + MathUtil.getNextPowerOfTwo(_loc12_ % this._maxTextureDimensions);
            }
            else
            {
               this._snapshotWidth = MathUtil.getNextPowerOfTwo(_loc12_);
            }
            if(_loc9_)
            {
               if(_loc7_ > this._maxTextureDimensions)
               {
                  this._snapshotHeight = int(_loc7_ / this._maxTextureDimensions) * this._maxTextureDimensions + _loc7_ % this._maxTextureDimensions;
               }
               else
               {
                  this._snapshotHeight = _loc7_;
               }
            }
            else if(_loc7_ > this._maxTextureDimensions)
            {
               this._snapshotHeight = int(_loc7_ / this._maxTextureDimensions) * this._maxTextureDimensions + MathUtil.getNextPowerOfTwo(_loc7_ % this._maxTextureDimensions);
            }
            else
            {
               this._snapshotHeight = MathUtil.getNextPowerOfTwo(_loc7_);
            }
            _loc10_ = !!this.textSnapshot ? this.textSnapshot.texture.root : null;
            this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || _loc10_ && (_loc10_.scale != _loc3_ || this._snapshotWidth != _loc10_.nativeWidth || this._snapshotHeight != _loc10_.nativeHeight);
            this._snapshotVisibleWidth = _loc12_;
            this._snapshotVisibleHeight = _loc7_;
         }
         if(_loc4_ || _loc5_ || _loc2_ || this._needsNewTexture || this.actualWidth != this._previousActualWidth || this.actualHeight != this._previousActualHeight)
         {
            this._previousActualWidth = this.actualWidth;
            this._previousActualHeight = this.actualHeight;
            if(_loc8_ = this._text.length > 0)
            {
               if(this._useSnapshotDelayWorkaround)
               {
                  this.addEventListener("enterFrame",enterFrameHandler);
               }
               else
               {
                  this.refreshSnapshot();
               }
            }
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = _loc8_ && this._snapshotWidth > 0 && this._snapshotHeight > 0;
               this.textSnapshot.pixelSnapping = this._pixelSnapping;
            }
            if(this.textSnapshots)
            {
               for each(var _loc13_ in this.textSnapshots)
               {
                  _loc13_.pixelSnapping = this._pixelSnapping;
               }
            }
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc7_:* = this._explicitHeight !== this._explicitHeight;
         var _loc4_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc8_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc3_ && !_loc7_ && !_loc4_ && !_loc8_)
         {
            return false;
         }
         this.measure(HELPER_POINT);
         var _loc2_:Number = this._explicitWidth;
         if(_loc3_)
         {
            _loc2_ = HELPER_POINT.x;
         }
         var _loc5_:Number = this._explicitHeight;
         if(_loc7_)
         {
            _loc5_ = HELPER_POINT.y;
         }
         var _loc1_:* = this._explicitMinWidth;
         if(_loc4_)
         {
            if(_loc3_)
            {
               _loc1_ = 0;
            }
            else
            {
               _loc1_ = _loc2_;
            }
         }
         var _loc6_:* = this._explicitMinHeight;
         if(_loc8_)
         {
            _loc6_ = _loc5_;
         }
         return this.saveMeasurements(_loc2_,_loc5_,_loc1_,_loc6_);
      }
      
      protected function measureNativeFilters(param1:BitmapData, param2:Rectangle = null) : Rectangle
      {
         var _loc3_:int = 0;
         var _loc7_:BitmapFilter = null;
         var _loc10_:Rectangle = null;
         var _loc8_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc12_:Number = NaN;
         if(!param2)
         {
            param2 = new Rectangle();
         }
         var _loc6_:* = 0;
         var _loc13_:* = 0;
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         var _loc14_:int = int(this._nativeFilters.length);
         _loc3_ = 0;
         while(_loc3_ < _loc14_)
         {
            _loc7_ = this._nativeFilters[_loc3_];
            _loc8_ = (_loc10_ = param1.generateFilterRect(param1.rect,_loc7_)).x;
            _loc11_ = _loc10_.y;
            _loc9_ = _loc10_.width;
            _loc12_ = _loc10_.height;
            if(_loc6_ > _loc8_)
            {
               _loc6_ = _loc8_;
            }
            if(_loc13_ > _loc11_)
            {
               _loc13_ = _loc11_;
            }
            if(_loc5_ < _loc9_)
            {
               _loc5_ = _loc9_;
            }
            if(_loc4_ < _loc12_)
            {
               _loc4_ = _loc12_;
            }
            _loc3_++;
         }
         param2.setTo(_loc6_,_loc13_,_loc5_,_loc4_);
         return param2;
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
         if(!_loc2_ && this._selectedTextFormat && this._stateContext is IToggle && IToggle(this._stateContext).isSelected)
         {
            _loc2_ = this._selectedTextFormat;
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
      
      protected function createTextureOnRestoreCallback(param1:Image) : void
      {
         var snapshot:Image = param1;
         var self:TextFieldTextRenderer = this;
         var texture:Texture = snapshot.texture;
         texture.root.onRestore = function():void
         {
            var _loc2_:Number = Starling.contentScaleFactor;
            HELPER_MATRIX.identity();
            HELPER_MATRIX.scale(_loc2_,_loc2_);
            var _loc1_:BitmapData = self.drawTextFieldRegionToBitmapData(snapshot.x,snapshot.y,texture.nativeWidth,texture.nativeHeight);
            texture.root.uploadBitmapData(_loc1_);
            _loc1_.dispose();
         };
      }
      
      protected function drawTextFieldRegionToBitmapData(param1:Number, param2:Number, param3:Number, param4:Number, param5:BitmapData = null) : BitmapData
      {
         var _loc6_:Number = Starling.contentScaleFactor;
         var _loc7_:Number = this._snapshotVisibleWidth - param1;
         var _loc9_:Number = this._snapshotVisibleHeight - param2;
         if(!param5 || param5.width != param3 || param5.height != param4)
         {
            if(param5)
            {
               param5.dispose();
            }
            param5 = new BitmapData(param3,param4,true,16711935);
         }
         else
         {
            param5.fillRect(param5.rect,16711935);
         }
         var _loc8_:Number = 2 * _loc6_;
         if(this._useGutter)
         {
            _loc8_ = 0;
         }
         HELPER_MATRIX.tx = -(param1 + _loc8_) - this._textSnapshotOffsetX;
         HELPER_MATRIX.ty = -(param2 + _loc8_) - this._textSnapshotOffsetY;
         HELPER_RECTANGLE.setTo(0,0,_loc7_,_loc9_);
         param5.draw(this.textField,HELPER_MATRIX,null,null,HELPER_RECTANGLE);
         return param5;
      }
      
      protected function refreshSnapshot() : void
      {
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc10_:BitmapData = null;
         var _loc8_:* = NaN;
         var _loc14_:* = NaN;
         var _loc7_:Texture = null;
         var _loc16_:Image = null;
         var _loc12_:Texture = null;
         var _loc11_:int = 0;
         var _loc6_:* = 0;
         if(this._snapshotWidth <= 0 || this._snapshotHeight <= 0)
         {
            return;
         }
         var _loc3_:Number = Starling.contentScaleFactor;
         if(this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            _loc2_ = matrixToScaleX(HELPER_MATRIX);
            _loc4_ = matrixToScaleY(HELPER_MATRIX);
         }
         HELPER_MATRIX.identity();
         HELPER_MATRIX.scale(_loc3_,_loc3_);
         if(this._updateSnapshotOnScaleChange)
         {
            HELPER_MATRIX.scale(_loc2_,_loc4_);
         }
         var _loc9_:Number = this._snapshotWidth;
         var _loc13_:Number = this._snapshotHeight;
         var _loc1_:Number = 0;
         var _loc5_:Number = 0;
         var _loc15_:int = -1;
         do
         {
            if((_loc8_ = _loc9_) > this._maxTextureDimensions)
            {
               _loc8_ = this._maxTextureDimensions;
            }
            do
            {
               if((_loc14_ = _loc13_) > this._maxTextureDimensions)
               {
                  _loc14_ = this._maxTextureDimensions;
               }
               _loc10_ = this.drawTextFieldRegionToBitmapData(_loc1_,_loc5_,_loc8_,_loc14_,_loc10_);
               if(!this.textSnapshot || this._needsNewTexture)
               {
                  (_loc7_ = Texture.empty(_loc10_.width / _loc3_,_loc10_.height / _loc3_,true,false,false,_loc3_)).root.uploadBitmapData(_loc10_);
               }
               _loc16_ = null;
               if(_loc15_ >= 0)
               {
                  if(!this.textSnapshots)
                  {
                     this.textSnapshots = new Vector.<Image>(0);
                  }
                  else if(this.textSnapshots.length > _loc15_)
                  {
                     _loc16_ = this.textSnapshots[_loc15_];
                  }
               }
               else
               {
                  _loc16_ = this.textSnapshot;
               }
               if(!_loc16_)
               {
                  (_loc16_ = new Image(_loc7_)).pixelSnapping = true;
                  this.addChild(_loc16_);
               }
               else if(this._needsNewTexture)
               {
                  _loc16_.texture.dispose();
                  _loc16_.texture = _loc7_;
                  _loc16_.readjustSize();
               }
               else
               {
                  (_loc12_ = _loc16_.texture).root.uploadBitmapData(_loc10_);
               }
               if(_loc7_)
               {
                  this.createTextureOnRestoreCallback(_loc16_);
               }
               if(_loc15_ >= 0)
               {
                  this.textSnapshots[_loc15_] = _loc16_;
               }
               else
               {
                  this.textSnapshot = _loc16_;
               }
               _loc16_.x = _loc1_ / _loc3_;
               _loc16_.y = _loc5_ / _loc3_;
               if(this._updateSnapshotOnScaleChange)
               {
                  _loc16_.scaleX = 1 / _loc2_;
                  _loc16_.scaleY = 1 / _loc4_;
                  _loc16_.x /= _loc2_;
                  _loc16_.y /= _loc4_;
               }
               _loc15_++;
               _loc5_ += _loc14_;
            }
            while((_loc13_ -= _loc14_) > 0);
            
            _loc1_ += _loc8_;
            _loc9_ -= _loc8_;
            _loc5_ = 0;
            _loc13_ = this._snapshotHeight;
         }
         while(_loc9_ > 0);
         
         _loc10_.dispose();
         if(this.textSnapshots)
         {
            _loc11_ = int(this.textSnapshots.length);
            _loc6_ = _loc15_;
            while(_loc6_ < _loc11_)
            {
               (_loc16_ = this.textSnapshots[_loc6_]).texture.dispose();
               _loc16_.removeFromParent(true);
               _loc6_++;
            }
            if(_loc15_ == 0)
            {
               this.textSnapshots = null;
            }
            else
            {
               this.textSnapshots.length = _loc15_;
            }
         }
         if(this._updateSnapshotOnScaleChange)
         {
            this._lastGlobalScaleX = _loc2_;
            this._lastGlobalScaleY = _loc4_;
            this._lastContentScaleFactor = _loc3_;
         }
         this._needsNewTexture = false;
      }
      
      protected function enterFrameHandler(param1:Event) : void
      {
         this.removeEventListener("enterFrame",enterFrameHandler);
         this.refreshSnapshot();
      }
      
      protected function stateContext_stateChangeHandler(param1:Event) : void
      {
         this.invalidate("state");
      }
   }
}
