package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.ITextBaselineControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IToolTip;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.skins.IStyleProvider;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   
   public class Label extends FeathersControl implements ITextBaselineControl, IToolTip
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      public static const DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER:String = "feathers-label-text-renderer";
      
      public static const ALTERNATE_STYLE_NAME_HEADING:String = "feathers-heading-label";
      
      public static const ALTERNATE_STYLE_NAME_DETAIL:String = "feathers-detail-label";
      
      public static const ALTERNATE_STYLE_NAME_TOOL_TIP:String = "feathers-tool-tip";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var textRendererStyleName:String = "feathers-label-text-renderer";
      
      protected var textRenderer:ITextRenderer;
      
      protected var _text:String = null;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _textRendererFactory:Function;
      
      protected var _customTextRendererStyleName:String;
      
      protected var _textRendererProperties:PropertyProxy;
      
      protected var _explicitTextRendererWidth:Number;
      
      protected var _explicitTextRendererHeight:Number;
      
      protected var _explicitTextRendererMinWidth:Number;
      
      protected var _explicitTextRendererMinHeight:Number;
      
      protected var _explicitTextRendererMaxWidth:Number;
      
      protected var _explicitTextRendererMaxHeight:Number;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      public function Label()
      {
         super();
         this.isQuickHitAreaEnabled = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Label.globalStyleProvider;
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
      
      public function get baseline() : Number
      {
         if(!this.textRenderer)
         {
            return this.scaledActualHeight;
         }
         return this.scaleY * (this.textRenderer.y + this.textRenderer.baseline);
      }
      
      public function get textRendererFactory() : Function
      {
         return this._textRendererFactory;
      }
      
      public function set textRendererFactory(param1:Function) : void
      {
         if(this._textRendererFactory == param1)
         {
            return;
         }
         this._textRendererFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get customTextRendererStyleName() : String
      {
         return this._customTextRendererStyleName;
      }
      
      public function set customTextRendererStyleName(param1:String) : void
      {
         if(this._customTextRendererStyleName == param1)
         {
            return;
         }
         this._customTextRendererStyleName = param1;
         this.invalidate("textRenderer");
      }
      
      public function get textRendererProperties() : Object
      {
         if(!this._textRendererProperties)
         {
            this._textRendererProperties = new PropertyProxy(textRendererProperties_onChange);
         }
         return this._textRendererProperties;
      }
      
      public function set textRendererProperties(param1:Object) : void
      {
         if(this._textRendererProperties == param1)
         {
            return;
         }
         if(param1 && !(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._textRendererProperties)
         {
            this._textRendererProperties.removeOnChangeCallback(textRendererProperties_onChange);
         }
         this._textRendererProperties = PropertyProxy(param1);
         if(this._textRendererProperties)
         {
            this._textRendererProperties.addOnChangeCallback(textRendererProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this._backgroundSkin == param1)
         {
            return;
         }
         if(this._backgroundSkin && this.currentBackgroundSkin == this._backgroundSkin)
         {
            this.removeChild(this._backgroundSkin);
            this.currentBackgroundSkin = null;
         }
         this._backgroundSkin = param1;
         this.invalidate("styles");
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this._backgroundDisabledSkin;
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this._backgroundDisabledSkin == param1)
         {
            return;
         }
         if(this._backgroundDisabledSkin && this.currentBackgroundSkin == this._backgroundDisabledSkin)
         {
            this.removeChild(this._backgroundDisabledSkin);
            this.currentBackgroundSkin = null;
         }
         this._backgroundDisabledSkin = param1;
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
      
      override protected function draw() : void
      {
         var _loc4_:Boolean = this.isInvalid("data");
         var _loc5_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc2_:Boolean = this.isInvalid("state");
         var _loc3_:Boolean = this.isInvalid("textRenderer");
         if(_loc1_ || _loc5_ || _loc2_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc3_)
         {
            this.createTextRenderer();
         }
         if(_loc3_ || _loc4_ || _loc2_)
         {
            this.refreshTextRendererData();
         }
         if(_loc3_ || _loc2_)
         {
            this.refreshEnabled();
         }
         if(_loc3_ || _loc5_ || _loc2_)
         {
            this.refreshTextRendererStyles();
         }
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layoutChildren();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc8_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc3_:* = this._explicitWidth !== this._explicitWidth;
         var _loc7_:* = this._explicitHeight !== this._explicitHeight;
         var _loc4_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc11_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc3_ && !_loc7_ && !_loc4_ && !_loc11_)
         {
            return false;
         }
         resetFluidChildDimensionsForMeasurement(DisplayObject(this.textRenderer),this._explicitWidth - this._paddingLeft - this._paddingRight,this._explicitHeight - this._paddingTop - this._paddingBottom,this._explicitMinWidth - this._paddingLeft - this._paddingRight,this._explicitMinHeight - this._paddingTop - this._paddingBottom,this._explicitMaxWidth - this._paddingLeft - this._paddingRight,this._explicitMaxHeight - this._paddingTop - this._paddingBottom,this._explicitTextRendererWidth,this._explicitTextRendererHeight,this._explicitTextRendererMinWidth,this._explicitTextRendererMinHeight,this._explicitTextRendererMaxWidth,this._explicitTextRendererMaxHeight);
         this.textRenderer.maxWidth = this._explicitMaxWidth - this._paddingLeft - this._paddingRight;
         this.textRenderer.maxHeight = this._explicitMaxHeight - this._paddingTop - this._paddingBottom;
         this.textRenderer.measureText(HELPER_POINT);
         var _loc9_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc1_:* = this._explicitMinWidth;
         if(_loc4_)
         {
            if(this._text && !_loc3_)
            {
               _loc1_ = HELPER_POINT.x;
            }
            else
            {
               _loc1_ = 0;
            }
            _loc1_ += this._paddingLeft + this._paddingRight;
            _loc8_ = 0;
            if(_loc9_ !== null)
            {
               _loc8_ = _loc9_.minWidth;
            }
            else if(this.currentBackgroundSkin !== null)
            {
               _loc8_ = this._explicitBackgroundMinWidth;
            }
            if(_loc8_ > _loc1_)
            {
               _loc1_ = _loc8_;
            }
         }
         var _loc6_:* = this._explicitMinHeight;
         if(_loc11_)
         {
            if(this._text)
            {
               _loc6_ = HELPER_POINT.y;
            }
            else
            {
               _loc6_ = 0;
            }
            _loc6_ += this._paddingTop + this._paddingBottom;
            _loc10_ = 0;
            if(_loc9_ !== null)
            {
               _loc10_ = _loc9_.minHeight;
            }
            else if(this.currentBackgroundSkin !== null)
            {
               _loc10_ = this._explicitBackgroundMinHeight;
            }
            if(_loc10_ > _loc6_)
            {
               _loc6_ = _loc10_;
            }
         }
         var _loc2_:Number = this._explicitWidth;
         if(_loc3_)
         {
            if(this._text)
            {
               _loc2_ = HELPER_POINT.x;
            }
            else
            {
               _loc2_ = 0;
            }
            _loc2_ += this._paddingLeft + this._paddingRight;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.width > _loc2_)
            {
               _loc2_ = this.currentBackgroundSkin.width;
            }
         }
         var _loc5_:Number = this._explicitHeight;
         if(_loc7_)
         {
            if(this._text)
            {
               _loc5_ = HELPER_POINT.y;
            }
            else
            {
               _loc5_ = 0;
            }
            _loc5_ += this._paddingTop + this._paddingBottom;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.height > _loc5_)
            {
               _loc5_ = this.currentBackgroundSkin.height;
            }
         }
         return this.saveMeasurements(_loc2_,_loc5_,_loc1_,_loc6_);
      }
      
      protected function createTextRenderer() : void
      {
         if(this.textRenderer !== null)
         {
            this.removeChild(DisplayObject(this.textRenderer),true);
            this.textRenderer = null;
         }
         var _loc1_:Function = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
         this.textRenderer = ITextRenderer(_loc1_());
         var _loc2_:String = this._customTextRendererStyleName != null ? this._customTextRendererStyleName : this.textRendererStyleName;
         this.textRenderer.styleNameList.add(_loc2_);
         this.addChild(DisplayObject(this.textRenderer));
         this.textRenderer.initializeNow();
         this._explicitTextRendererWidth = this.textRenderer.explicitWidth;
         this._explicitTextRendererHeight = this.textRenderer.explicitHeight;
         this._explicitTextRendererMinWidth = this.textRenderer.explicitMinWidth;
         this._explicitTextRendererMinHeight = this.textRenderer.explicitMinHeight;
         this._explicitTextRendererMaxWidth = this.textRenderer.explicitMaxWidth;
         this._explicitTextRendererMaxHeight = this.textRenderer.explicitMaxHeight;
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin !== null)
         {
            _loc1_ = this._backgroundDisabledSkin;
         }
         if(this.currentBackgroundSkin != _loc1_)
         {
            if(this.currentBackgroundSkin !== null)
            {
               this.removeChild(this.currentBackgroundSkin);
            }
            this.currentBackgroundSkin = _loc1_;
            if(this.currentBackgroundSkin !== null)
            {
               this.addChildAt(this.currentBackgroundSkin,0);
               if(this.currentBackgroundSkin is IFeathersControl)
               {
                  IFeathersControl(this.currentBackgroundSkin).initializeNow();
               }
               if(this.currentBackgroundSkin is IMeasureDisplayObject)
               {
                  _loc2_ = IMeasureDisplayObject(this.currentBackgroundSkin);
                  this._explicitBackgroundWidth = _loc2_.explicitWidth;
                  this._explicitBackgroundHeight = _loc2_.explicitHeight;
                  this._explicitBackgroundMinWidth = _loc2_.explicitMinWidth;
                  this._explicitBackgroundMinHeight = _loc2_.explicitMinHeight;
                  this._explicitBackgroundMaxWidth = _loc2_.explicitMaxWidth;
                  this._explicitBackgroundMaxHeight = _loc2_.explicitMaxHeight;
               }
               else
               {
                  this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
                  this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
                  this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
                  this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
               }
            }
         }
         if(this.currentBackgroundSkin !== null)
         {
            this.setChildIndex(this.currentBackgroundSkin,0);
         }
      }
      
      protected function layoutChildren() : void
      {
         if(this.currentBackgroundSkin !== null)
         {
            this.currentBackgroundSkin.x = 0;
            this.currentBackgroundSkin.y = 0;
            this.currentBackgroundSkin.width = this.actualWidth;
            this.currentBackgroundSkin.height = this.actualHeight;
         }
         this.textRenderer.x = this._paddingLeft;
         this.textRenderer.y = this._paddingTop;
         this.textRenderer.width = this.actualWidth - this._paddingLeft - this._paddingRight;
         this.textRenderer.height = this.actualHeight - this._paddingTop - this._paddingBottom;
         this.textRenderer.validate();
      }
      
      protected function refreshEnabled() : void
      {
         this.textRenderer.isEnabled = this._isEnabled;
      }
      
      protected function refreshTextRendererData() : void
      {
         this.textRenderer.text = this._text;
         this.textRenderer.visible = this._text && this._text.length > 0;
      }
      
      protected function refreshTextRendererStyles() : void
      {
         var _loc2_:Object = null;
         this.textRenderer.wordWrap = this._wordWrap;
         for(var _loc1_ in this._textRendererProperties)
         {
            _loc2_ = this._textRendererProperties[_loc1_];
            this.textRenderer[_loc1_] = _loc2_;
         }
      }
      
      protected function textRendererProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
   }
}
