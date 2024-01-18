package feathers.controls.supportClasses
{
   import feathers.core.FeathersControl;
   import feathers.utils.geom.matrixToRotation;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.utils.MatrixUtil;
   
   public class TextFieldViewPort extends FeathersControl implements IViewPort
   {
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
       
      
      private var _textFieldContainer:Sprite;
      
      private var _textField:TextField;
      
      private var _text:String = "";
      
      private var _isHTML:Boolean = false;
      
      private var _textFormat:TextFormat;
      
      private var _disabledTextFormat:TextFormat;
      
      protected var _styleSheet:StyleSheet;
      
      private var _embedFonts:Boolean = false;
      
      private var _antiAliasType:String = "advanced";
      
      private var _background:Boolean = false;
      
      private var _backgroundColor:uint = 16777215;
      
      private var _border:Boolean = false;
      
      private var _borderColor:uint = 0;
      
      private var _cacheAsBitmap:Boolean = true;
      
      private var _condenseWhite:Boolean = false;
      
      private var _displayAsPassword:Boolean = false;
      
      private var _gridFitType:String = "pixel";
      
      private var _sharpness:Number = 0;
      
      private var _thickness:Number = 0;
      
      private var _actualMinVisibleWidth:Number = 0;
      
      private var _explicitMinVisibleWidth:Number;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var _actualVisibleWidth:Number = 0;
      
      private var _explicitVisibleWidth:Number = NaN;
      
      private var _actualMinVisibleHeight:Number = 0;
      
      private var _explicitMinVisibleHeight:Number;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var _actualVisibleHeight:Number = 0;
      
      private var _explicitVisibleHeight:Number = NaN;
      
      private var _scrollStep:Number;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      private var _paddingTop:Number = 0;
      
      private var _paddingRight:Number = 0;
      
      private var _paddingBottom:Number = 0;
      
      private var _paddingLeft:Number = 0;
      
      public function TextFieldViewPort()
      {
         super();
         this.addEventListener("addedToStage",addedToStageHandler);
         this.addEventListener("removedFromStage",removedFromStageHandler);
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
      
      public function get cacheAsBitmap() : Boolean
      {
         return this._cacheAsBitmap;
      }
      
      public function set cacheAsBitmap(param1:Boolean) : void
      {
         if(this._cacheAsBitmap == param1)
         {
            return;
         }
         this._cacheAsBitmap = param1;
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
      
      public function get minVisibleWidth() : Number
      {
         if(this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return this._actualMinVisibleWidth;
         }
         return this._explicitMinVisibleWidth;
      }
      
      public function set minVisibleWidth(param1:Number) : void
      {
         if(this._explicitMinVisibleWidth == param1)
         {
            return;
         }
         var _loc2_:* = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleWidth;
         this._explicitMinVisibleWidth = param1;
         if(_loc2_)
         {
            this._actualMinVisibleWidth = 0;
            this.invalidate("size");
         }
         else
         {
            this._actualMinVisibleWidth = param1;
            if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth < param1 || this._actualVisibleWidth === _loc3_))
            {
               this.invalidate("size");
            }
         }
      }
      
      public function get maxVisibleWidth() : Number
      {
         return this._maxVisibleWidth;
      }
      
      public function set maxVisibleWidth(param1:Number) : void
      {
         if(this._maxVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleWidth cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleWidth;
         this._maxVisibleWidth = param1;
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth && (this._actualVisibleWidth > param1 || this._actualVisibleWidth === _loc2_))
         {
            this.invalidate("size");
         }
      }
      
      public function get visibleWidth() : Number
      {
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return this._actualVisibleWidth;
         }
         return this._explicitVisibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this._explicitVisibleWidth == param1 || param1 !== param1 && this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return;
         }
         this._explicitVisibleWidth = param1;
         if(this._actualVisibleWidth !== param1)
         {
            this.invalidate("size");
         }
      }
      
      public function get minVisibleHeight() : Number
      {
         if(this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return this._actualMinVisibleHeight;
         }
         return this._explicitMinVisibleHeight;
      }
      
      public function set minVisibleHeight(param1:Number) : void
      {
         if(this._explicitMinVisibleHeight == param1)
         {
            return;
         }
         var _loc2_:* = param1 !== param1;
         if(_loc2_ && this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinVisibleHeight;
         this._explicitMinVisibleHeight = param1;
         if(_loc2_)
         {
            this._actualMinVisibleHeight = 0;
            this.invalidate("size");
         }
         else
         {
            this._actualMinVisibleHeight = param1;
            if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight < param1 || this._actualVisibleHeight === _loc3_))
            {
               this.invalidate("size");
            }
         }
      }
      
      public function get maxVisibleHeight() : Number
      {
         return this._maxVisibleHeight;
      }
      
      public function set maxVisibleHeight(param1:Number) : void
      {
         if(this._maxVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleHeight cannot be NaN");
         }
         var _loc2_:Number = this._maxVisibleHeight;
         this._maxVisibleHeight = param1;
         if(this._explicitVisibleHeight !== this._explicitVisibleHeight && (this._actualVisibleHeight > param1 || this._actualVisibleHeight === _loc2_))
         {
            this.invalidate("size");
         }
      }
      
      public function get visibleHeight() : Number
      {
         if(this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return this._actualVisibleHeight;
         }
         return this._explicitVisibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this._explicitVisibleHeight == param1 || param1 !== param1 && this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return;
         }
         this._explicitVisibleHeight = param1;
         if(this._actualVisibleHeight !== param1)
         {
            this.invalidate("size");
         }
      }
      
      public function get contentX() : Number
      {
         return 0;
      }
      
      public function get contentY() : Number
      {
         return 0;
      }
      
      public function get horizontalScrollStep() : Number
      {
         return this._scrollStep;
      }
      
      public function get verticalScrollStep() : Number
      {
         return this._scrollStep;
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         this._horizontalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         this._verticalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get requiresMeasurementOnScroll() : Boolean
      {
         return false;
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
      
      override public function render(param1:Painter) : void
      {
         param1.excludeFromCache(this);
         var _loc2_:Rectangle = Starling.current.viewPort;
         HELPER_POINT.x = HELPER_POINT.y = 0;
         this.parent.getTransformationMatrix(this.stage,HELPER_MATRIX);
         MatrixUtil.transformCoords(HELPER_MATRIX,0,0,HELPER_POINT);
         var _loc4_:Number = 1;
         if(Starling.current.supportHighResolutions)
         {
            _loc4_ = Starling.current.nativeStage.contentsScaleFactor;
         }
         var _loc3_:Number = Starling.contentScaleFactor / _loc4_;
         this._textFieldContainer.x = _loc2_.x + HELPER_POINT.x * _loc3_;
         this._textFieldContainer.y = _loc2_.y + HELPER_POINT.y * _loc3_;
         this._textFieldContainer.scaleX = matrixToScaleX(HELPER_MATRIX) * _loc3_;
         this._textFieldContainer.scaleY = matrixToScaleY(HELPER_MATRIX) * _loc3_;
         this._textFieldContainer.rotation = matrixToRotation(HELPER_MATRIX) * 180 / 3.141592653589793;
         this._textFieldContainer.alpha = param1.state.alpha;
         super.render(param1);
      }
      
      override protected function initialize() : void
      {
         this._textFieldContainer = new Sprite();
         this._textFieldContainer.visible = false;
         this._textField = new TextField();
         this._textField.autoSize = "left";
         this._textField.selectable = false;
         this._textField.mouseWheelEnabled = false;
         this._textField.wordWrap = true;
         this._textField.multiline = true;
         this._textField.addEventListener("link",textField_linkHandler);
         this._textFieldContainer.addChild(this._textField);
      }
      
      override protected function draw() : void
      {
         var _loc4_:Rectangle = null;
         var _loc6_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc9_:Boolean = this.isInvalid("scroll");
         var _loc7_:Boolean = this.isInvalid("styles");
         var _loc5_:Boolean = this.isInvalid("state");
         if(_loc7_)
         {
            this._textField.antiAliasType = this._antiAliasType;
            this._textField.background = this._background;
            this._textField.backgroundColor = this._backgroundColor;
            this._textField.border = this._border;
            this._textField.borderColor = this._borderColor;
            this._textField.condenseWhite = this._condenseWhite;
            this._textField.displayAsPassword = this._displayAsPassword;
            this._textField.embedFonts = this._embedFonts;
            this._textField.gridFitType = this._gridFitType;
            this._textField.sharpness = this._sharpness;
            this._textField.thickness = this._thickness;
            this._textField.cacheAsBitmap = this._cacheAsBitmap;
            this._textField.x = this._paddingLeft;
            this._textField.y = this._paddingTop;
         }
         if(_loc6_ || _loc7_ || _loc5_)
         {
            if(this._styleSheet)
            {
               this._textField.styleSheet = this._styleSheet;
            }
            else
            {
               this._textField.styleSheet = null;
               if(!this._isEnabled && this._disabledTextFormat)
               {
                  this._textField.defaultTextFormat = this._disabledTextFormat;
               }
               else if(this._textFormat)
               {
                  this._textField.defaultTextFormat = this._textFormat;
               }
            }
            if(this._isHTML)
            {
               this._textField.htmlText = this._text;
            }
            else
            {
               this._textField.text = this._text;
            }
            this._scrollStep = this._textField.getLineMetrics(0).height * Starling.contentScaleFactor;
         }
         var _loc8_:Number = this._explicitVisibleWidth;
         if(_loc8_ != _loc8_)
         {
            if(this.stage)
            {
               _loc8_ = this.stage.stageWidth;
            }
            else
            {
               _loc8_ = Starling.current.stage.stageWidth;
            }
            if(_loc8_ < this._explicitMinVisibleWidth)
            {
               _loc8_ = this._explicitMinVisibleWidth;
            }
            else if(_loc8_ > this._maxVisibleWidth)
            {
               _loc8_ = this._maxVisibleWidth;
            }
         }
         this._textField.width = _loc8_ - this._paddingLeft - this._paddingRight;
         var _loc3_:Number = this._textField.height + this._paddingTop + this._paddingBottom;
         var _loc1_:* = this._explicitVisibleHeight;
         if(_loc1_ != _loc1_)
         {
            _loc1_ = _loc3_;
            if(_loc1_ < this._explicitMinVisibleHeight)
            {
               _loc1_ = this._explicitMinVisibleHeight;
            }
            else if(_loc1_ > this._maxVisibleHeight)
            {
               _loc1_ = this._maxVisibleHeight;
            }
         }
         _loc2_ = this.saveMeasurements(_loc8_,_loc3_,_loc8_,_loc3_) || _loc2_;
         this._actualVisibleWidth = _loc8_;
         this._actualVisibleHeight = _loc1_;
         this._actualMinVisibleWidth = _loc8_;
         this._actualMinVisibleHeight = _loc1_;
         if(_loc2_ || _loc9_)
         {
            if(!(_loc4_ = this._textFieldContainer.scrollRect))
            {
               _loc4_ = new Rectangle();
            }
            _loc4_.width = _loc8_;
            _loc4_.height = _loc1_;
            _loc4_.x = this._horizontalScrollPosition;
            _loc4_.y = this._verticalScrollPosition;
            this._textFieldContainer.scrollRect = _loc4_;
         }
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         Starling.current.nativeStage.addChild(this._textFieldContainer);
         this.addEventListener("enterFrame",enterFrameHandler);
      }
      
      private function removedFromStageHandler(param1:Event) : void
      {
         Starling.current.nativeStage.removeChild(this._textFieldContainer);
         this.removeEventListener("enterFrame",enterFrameHandler);
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         var _loc2_:DisplayObject = this;
         while(_loc2_.visible)
         {
            _loc2_ = _loc2_.parent;
            if(!_loc2_)
            {
               this._textFieldContainer.visible = true;
               return;
            }
         }
         this._textFieldContainer.visible = false;
      }
      
      protected function textField_linkHandler(param1:TextEvent) : void
      {
         this.dispatchEventWith("triggered",false,param1.text);
      }
   }
}
