package feathers.controls.text
{
   import feathers.controls.Scroller;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.stageToStarling;
   import feathers.utils.geom.matrixToRotation;
   import feathers.utils.geom.matrixToScaleX;
   import feathers.utils.geom.matrixToScaleY;
   import feathers.utils.math.roundToNearest;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import starling.core.Starling;
   import starling.utils.MatrixUtil;
   
   public class TextFieldTextEditorViewPort extends TextFieldTextEditor implements ITextEditorViewPort
   {
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      private var _ignoreScrolling:Boolean = false;
      
      private var _minVisibleWidth:Number = 0;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var _visibleWidth:Number = NaN;
      
      private var _minVisibleHeight:Number = 0;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var _visibleHeight:Number = NaN;
      
      protected var _scrollStep:int = 0;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      public function TextFieldTextEditorViewPort()
      {
         super();
         this.multiline = true;
         this.wordWrap = true;
         this.resetScrollOnFocusOut = false;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return globalStyleProvider;
      }
      
      public function get minVisibleWidth() : Number
      {
         return this._minVisibleWidth;
      }
      
      public function set minVisibleWidth(param1:Number) : void
      {
         if(this._minVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("minVisibleWidth cannot be NaN");
         }
         this._minVisibleWidth = param1;
         this.invalidate("size");
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
         this._maxVisibleWidth = param1;
         this.invalidate("size");
      }
      
      public function get visibleWidth() : Number
      {
         return this._visibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this._visibleWidth == param1 || param1 !== param1 && this._visibleWidth !== this._visibleWidth)
         {
            return;
         }
         this._visibleWidth = param1;
         this.invalidate("size");
      }
      
      public function get minVisibleHeight() : Number
      {
         return this._minVisibleHeight;
      }
      
      public function set minVisibleHeight(param1:Number) : void
      {
         if(this._minVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("minVisibleHeight cannot be NaN");
         }
         this._minVisibleHeight = param1;
         this.invalidate("size");
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
         this._maxVisibleHeight = param1;
         this.invalidate("size");
      }
      
      public function get visibleHeight() : Number
      {
         return this._visibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this._visibleHeight == param1 || param1 !== param1 && this._visibleHeight !== this._visibleHeight)
         {
            return;
         }
         this._visibleHeight = param1;
         this.invalidate("size");
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
         this._horizontalScrollPosition = param1;
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
         this.invalidate("size");
      }
      
      public function get requiresMeasurementOnScroll() : Boolean
      {
         return false;
      }
      
      override public function get baseline() : Number
      {
         return super.baseline + this._paddingTop + this._verticalScrollPosition;
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
      
      override public function setFocus(param1:Point = null) : void
      {
         if(param1 !== null)
         {
            param1.x -= this._paddingLeft;
            param1.y -= this._paddingTop;
         }
         super.setFocus(param1);
      }
      
      override protected function measure(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc3_:* = this._visibleWidth !== this._visibleWidth;
         this.commitStylesAndData(this.measureTextField);
         var _loc5_:Number = 4;
         if(this._useGutter)
         {
            _loc5_ = 0;
         }
         var _loc2_:Number = this._visibleWidth;
         this.measureTextField.width = _loc2_ - this._paddingLeft - this._paddingRight + _loc5_;
         if(_loc3_)
         {
            _loc2_ = this.measureTextField.width + this._paddingLeft + this._paddingRight - _loc5_;
            if(_loc2_ < this._minVisibleWidth)
            {
               _loc2_ = this._minVisibleWidth;
            }
            else if(_loc2_ > this._maxVisibleWidth)
            {
               _loc2_ = this._maxVisibleWidth;
            }
         }
         var _loc4_:Number = this.measureTextField.height + this._paddingTop + this._paddingBottom - _loc5_;
         if(this._useGutter)
         {
            _loc4_ += 4;
         }
         if(this._visibleHeight === this._visibleHeight)
         {
            if(_loc4_ < this._visibleHeight)
            {
               _loc4_ = this._visibleHeight;
            }
         }
         else if(_loc4_ < this._minVisibleHeight)
         {
            _loc4_ = this._minVisibleHeight;
         }
         param1.x = _loc2_;
         param1.y = _loc4_;
         return param1;
      }
      
      override protected function refreshSnapshotParameters() : void
      {
         var _loc3_:Number = this._visibleWidth - this._paddingLeft - this._paddingRight;
         if(_loc3_ !== _loc3_)
         {
            if(this._maxVisibleWidth < Infinity)
            {
               _loc3_ = this._maxVisibleWidth - this._paddingLeft - this._paddingRight;
            }
            else
            {
               _loc3_ = this._minVisibleWidth - this._paddingLeft - this._paddingRight;
            }
         }
         var _loc4_:Number = this._visibleHeight - this._paddingTop - this._paddingBottom;
         if(_loc4_ !== _loc4_)
         {
            if(this._maxVisibleHeight < Infinity)
            {
               _loc4_ = this._maxVisibleHeight - this._paddingTop - this._paddingBottom;
            }
            else
            {
               _loc4_ = this._minVisibleHeight - this._paddingTop - this._paddingBottom;
            }
         }
         this._textFieldOffsetX = 0;
         this._textFieldOffsetY = 0;
         this._textFieldSnapshotClipRect.x = 0;
         this._textFieldSnapshotClipRect.y = 0;
         var _loc1_:Number = Starling.contentScaleFactor;
         var _loc2_:Number = _loc3_ * _loc1_;
         if(this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            _loc2_ *= matrixToScaleX(HELPER_MATRIX);
         }
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         var _loc5_:Number = _loc4_ * _loc1_;
         if(this._updateSnapshotOnScaleChange)
         {
            _loc5_ *= matrixToScaleY(HELPER_MATRIX);
         }
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         this._textFieldSnapshotClipRect.width = _loc2_;
         this._textFieldSnapshotClipRect.height = _loc5_;
      }
      
      override protected function refreshTextFieldSize() : void
      {
         var _loc1_:Boolean = this._ignoreScrolling;
         var _loc2_:Number = 4;
         if(this._useGutter)
         {
            _loc2_ = 0;
         }
         this._ignoreScrolling = true;
         this.textField.width = this._visibleWidth - this._paddingLeft - this._paddingRight + _loc2_;
         var _loc4_:Number = this._visibleHeight - this._paddingTop - this._paddingBottom + _loc2_;
         if(this.textField.height != _loc4_)
         {
            this.textField.height = _loc4_;
         }
         var _loc3_:Scroller = Scroller(this.parent);
         this.textField.scrollV = Math.round(1 + (this.textField.maxScrollV - 1) * (this._verticalScrollPosition / _loc3_.maxVerticalScrollPosition));
         this._ignoreScrolling = _loc1_;
      }
      
      override protected function commitStylesAndData(param1:TextField) : void
      {
         super.commitStylesAndData(param1);
         if(param1 == this.textField)
         {
            this._scrollStep = param1.getLineMetrics(0).height;
         }
      }
      
      override protected function transformTextField() : void
      {
         var _loc3_:Starling = stageToStarling(this.stage);
         if(_loc3_ === null)
         {
            _loc3_ = Starling.current;
         }
         var _loc9_:Number = 1;
         if(_loc3_.supportHighResolutions)
         {
            _loc9_ = _loc3_.nativeStage.contentsScaleFactor;
         }
         var _loc7_:Number = _loc3_.contentScaleFactor / _loc9_;
         HELPER_POINT.x = HELPER_POINT.y = 0;
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         MatrixUtil.transformCoords(HELPER_MATRIX,0,0,HELPER_POINT);
         var _loc1_:Number = matrixToScaleX(HELPER_MATRIX) * _loc7_;
         var _loc4_:Number = matrixToScaleY(HELPER_MATRIX) * _loc7_;
         var _loc2_:Number = Math.round(this._paddingLeft * _loc1_);
         var _loc5_:Number = Math.round((this._paddingTop + this._verticalScrollPosition) * _loc4_);
         var _loc6_:Rectangle = _loc3_.viewPort;
         var _loc8_:Number = 2;
         if(this._useGutter)
         {
            _loc8_ = 0;
         }
         this.textField.x = _loc2_ + Math.round(_loc6_.x + HELPER_POINT.x * _loc7_ - _loc8_ * _loc1_);
         this.textField.y = _loc5_ + Math.round(_loc6_.y + HELPER_POINT.y * _loc7_ - _loc8_ * _loc4_);
         this.textField.rotation = matrixToRotation(HELPER_MATRIX) * 180 / 3.141592653589793;
         this.textField.scaleX = _loc1_;
         this.textField.scaleY = _loc4_;
      }
      
      override protected function positionSnapshot() : void
      {
         if(!this.textSnapshot)
         {
            return;
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         this.textSnapshot.x = this._paddingLeft + Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
         this.textSnapshot.y = this._paddingTop + this._verticalScrollPosition + Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
      }
      
      override protected function checkIfNewSnapshotIsNeeded() : void
      {
         super.checkIfNewSnapshotIsNeeded();
         this._needsNewTexture ||= this.isInvalid("scroll");
      }
      
      override protected function textField_focusInHandler(param1:FocusEvent) : void
      {
         this.textField.addEventListener("scroll",textField_scrollHandler);
         super.textField_focusInHandler(param1);
         this.invalidate("size");
      }
      
      override protected function textField_focusOutHandler(param1:FocusEvent) : void
      {
         this.textField.removeEventListener("scroll",textField_scrollHandler);
         super.textField_focusOutHandler(param1);
         this.invalidate("size");
      }
      
      protected function textField_scrollHandler(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = this.textField.scrollH;
         var _loc5_:Number = this.textField.scrollV;
         if(this._ignoreScrolling)
         {
            return;
         }
         var _loc4_:Scroller;
         if((_loc4_ = Scroller(this.parent)).maxVerticalScrollPosition > 0 && this.textField.maxScrollV > 1)
         {
            _loc2_ = _loc4_.maxVerticalScrollPosition * (_loc5_ - 1) / (this.textField.maxScrollV - 1);
            _loc4_.verticalScrollPosition = roundToNearest(_loc2_,this._scrollStep);
         }
      }
   }
}
