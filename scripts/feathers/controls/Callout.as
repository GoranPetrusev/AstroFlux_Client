package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.events.KeyboardEvent;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class Callout extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_POSITIONS:Vector.<String> = new <String>["bottom","top","right","left"];
      
      public static const DIRECTION_ANY:String = "any";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DIRECTION_UP:String = "up";
      
      public static const DIRECTION_DOWN:String = "down";
      
      public static const DIRECTION_LEFT:String = "left";
      
      public static const DIRECTION_RIGHT:String = "right";
      
      public static const ARROW_POSITION_TOP:String = "top";
      
      public static const ARROW_POSITION_RIGHT:String = "right";
      
      public static const ARROW_POSITION_BOTTOM:String = "bottom";
      
      public static const ARROW_POSITION_LEFT:String = "left";
      
      protected static const INVALIDATION_FLAG_ORIGIN:String = "origin";
      
      private static const HELPER_RECT:Rectangle = new Rectangle();
      
      protected static const FUZZY_CONTENT_DIMENSIONS_PADDING:Number = 0.000001;
      
      public static var stagePaddingTop:Number = 0;
      
      public static var stagePaddingRight:Number = 0;
      
      public static var stagePaddingBottom:Number = 0;
      
      public static var stagePaddingLeft:Number = 0;
      
      public static var calloutOverlayFactory:Function = PopUpManager.defaultOverlayFactory;
      
      public static var calloutFactory:Function = defaultCalloutFactory;
       
      
      public var closeOnTouchBeganOutside:Boolean = false;
      
      public var closeOnTouchEndedOutside:Boolean = false;
      
      public var closeOnKeys:Vector.<uint>;
      
      public var disposeOnSelfClose:Boolean = true;
      
      public var disposeContent:Boolean = true;
      
      protected var _isReadyToClose:Boolean = false;
      
      protected var _explicitContentWidth:Number;
      
      protected var _explicitContentHeight:Number;
      
      protected var _explicitContentMinWidth:Number;
      
      protected var _explicitContentMinHeight:Number;
      
      protected var _explicitContentMaxWidth:Number;
      
      protected var _explicitContentMaxHeight:Number;
      
      protected var _explicitBackgroundSkinWidth:Number;
      
      protected var _explicitBackgroundSkinHeight:Number;
      
      protected var _explicitBackgroundSkinMinWidth:Number;
      
      protected var _explicitBackgroundSkinMinHeight:Number;
      
      protected var _explicitBackgroundSkinMaxWidth:Number;
      
      protected var _explicitBackgroundSkinMaxHeight:Number;
      
      protected var _content:DisplayObject;
      
      protected var _origin:DisplayObject;
      
      protected var _supportedDirections:String = null;
      
      protected var _supportedPositions:Vector.<String> = null;
      
      protected var _horizontalAlign:String = "center";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _arrowPosition:String = "top";
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var currentArrowSkin:DisplayObject;
      
      protected var _bottomArrowSkin:DisplayObject;
      
      protected var _topArrowSkin:DisplayObject;
      
      protected var _leftArrowSkin:DisplayObject;
      
      protected var _rightArrowSkin:DisplayObject;
      
      protected var _topArrowGap:Number = 0;
      
      protected var _bottomArrowGap:Number = 0;
      
      protected var _rightArrowGap:Number = 0;
      
      protected var _leftArrowGap:Number = 0;
      
      protected var _arrowOffset:Number = 0;
      
      protected var _lastGlobalBoundsOfOrigin:Rectangle;
      
      protected var _ignoreContentResize:Boolean = false;
      
      public function Callout()
      {
         super();
         this.addEventListener("addedToStage",callout_addedToStageHandler);
      }
      
      public static function get stagePadding() : Number
      {
         return Callout.stagePaddingTop;
      }
      
      public static function set stagePadding(param1:Number) : void
      {
         Callout.stagePaddingTop = param1;
         Callout.stagePaddingRight = param1;
         Callout.stagePaddingBottom = param1;
         Callout.stagePaddingLeft = param1;
      }
      
      public static function show(param1:DisplayObject, param2:DisplayObject, param3:Object = null, param4:Boolean = true, param5:Function = null, param6:Function = null) : Callout
      {
         if(param2.stage === null)
         {
            throw new ArgumentError("Callout origin must be added to the stage.");
         }
         var _loc7_:*;
         if((_loc7_ = param5) === null)
         {
            if((_loc7_ = calloutFactory) === null)
            {
               _loc7_ = defaultCalloutFactory;
            }
         }
         var _loc8_:Callout;
         (_loc8_ = Callout(_loc7_())).content = param1;
         if(param3 is String)
         {
            _loc8_.supportedDirections = param3 as String;
         }
         else
         {
            _loc8_.supportedPositions = param3 as Vector.<String>;
         }
         _loc8_.origin = param2;
         if((_loc7_ = param6) === null)
         {
            if((_loc7_ = calloutOverlayFactory) === null)
            {
               _loc7_ = PopUpManager.defaultOverlayFactory;
            }
         }
         PopUpManager.addPopUp(_loc8_,param4,false,_loc7_);
         return _loc8_;
      }
      
      public static function defaultCalloutFactory() : Callout
      {
         var _loc1_:Callout = new Callout();
         _loc1_.closeOnTouchBeganOutside = true;
         _loc1_.closeOnTouchEndedOutside = true;
         _loc1_.closeOnKeys = new <uint>[16777238,27];
         return _loc1_;
      }
      
      protected static function positionBelowOrigin(param1:Callout, param2:Rectangle) : void
      {
         var _loc4_:Number = NaN;
         param1.measureWithArrowPosition("top");
         var _loc5_:Number = param2.x;
         if(param1._horizontalAlign === "center")
         {
            _loc5_ += Math.round((param2.width - param1.width) / 2);
         }
         else if(param1._horizontalAlign === "right")
         {
            _loc5_ += param2.width - param1.width;
         }
         var _loc3_:* = _loc5_;
         if(stagePaddingLeft > _loc3_)
         {
            _loc3_ = stagePaddingLeft;
         }
         else if((_loc4_ = Starling.current.stage.stageWidth - param1.width - stagePaddingRight) < _loc3_)
         {
            _loc3_ = _loc4_;
         }
         param1.x = _loc3_;
         param1.y = param2.y + param2.height;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc5_ - _loc3_;
            param1._arrowPosition = "top";
         }
         else
         {
            param1.arrowOffset = _loc5_ - _loc3_;
            param1.arrowPosition = "top";
         }
      }
      
      protected static function positionAboveOrigin(param1:Callout, param2:Rectangle) : void
      {
         var _loc4_:Number = NaN;
         param1.measureWithArrowPosition("bottom");
         var _loc5_:Number = param2.x;
         if(param1._horizontalAlign === "center")
         {
            _loc5_ += Math.round((param2.width - param1.width) / 2);
         }
         else if(param1._horizontalAlign === "right")
         {
            _loc5_ += param2.width - param1.width;
         }
         var _loc3_:* = _loc5_;
         if(stagePaddingLeft > _loc3_)
         {
            _loc3_ = stagePaddingLeft;
         }
         else if((_loc4_ = Starling.current.stage.stageWidth - param1.width - stagePaddingRight) < _loc3_)
         {
            _loc3_ = _loc4_;
         }
         param1.x = _loc3_;
         param1.y = param2.y - param1.height;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc5_ - _loc3_;
            param1._arrowPosition = "bottom";
         }
         else
         {
            param1.arrowOffset = _loc5_ - _loc3_;
            param1.arrowPosition = "bottom";
         }
      }
      
      protected static function positionToRightOfOrigin(param1:Callout, param2:Rectangle) : void
      {
         var _loc3_:Number = NaN;
         param1.measureWithArrowPosition("left");
         param1.x = param2.x + param2.width;
         var _loc5_:Number = param2.y;
         if(param1._verticalAlign === "middle")
         {
            _loc5_ += Math.round((param2.height - param1.height) / 2);
         }
         else if(param1._verticalAlign === "bottom")
         {
            _loc5_ += param2.height - param1.height;
         }
         var _loc4_:* = _loc5_;
         if(stagePaddingTop > _loc4_)
         {
            _loc4_ = stagePaddingTop;
         }
         else
         {
            _loc3_ = Starling.current.stage.stageHeight - param1.height - stagePaddingBottom;
            if(_loc3_ < _loc4_)
            {
               _loc4_ = _loc3_;
            }
         }
         param1.y = _loc4_;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc5_ - _loc4_;
            param1._arrowPosition = "left";
         }
         else
         {
            param1.arrowOffset = _loc5_ - _loc4_;
            param1.arrowPosition = "left";
         }
      }
      
      protected static function positionToLeftOfOrigin(param1:Callout, param2:Rectangle) : void
      {
         var _loc3_:Number = NaN;
         param1.measureWithArrowPosition("right");
         param1.x = param2.x - param1.width;
         var _loc5_:Number = param2.y;
         if(param1._verticalAlign === "middle")
         {
            _loc5_ += Math.round((param2.height - param1.height) / 2);
         }
         else if(param1._verticalAlign === "bottom")
         {
            _loc5_ += param2.height - param1.height;
         }
         var _loc4_:* = _loc5_;
         if(stagePaddingTop > _loc4_)
         {
            _loc4_ = stagePaddingTop;
         }
         else
         {
            _loc3_ = Starling.current.stage.stageHeight - param1.height - stagePaddingBottom;
            if(_loc3_ < _loc4_)
            {
               _loc4_ = _loc3_;
            }
         }
         param1.y = _loc4_;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc5_ - _loc4_;
            param1._arrowPosition = "right";
         }
         else
         {
            param1.arrowOffset = _loc5_ - _loc4_;
            param1.arrowPosition = "right";
         }
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Callout.globalStyleProvider;
      }
      
      public function get content() : DisplayObject
      {
         return this._content;
      }
      
      public function set content(param1:DisplayObject) : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         if(this._content == param1)
         {
            return;
         }
         if(this._content !== null)
         {
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).removeEventListener("resize",content_resizeHandler);
            }
            if(this._content.parent === this)
            {
               this._content.removeFromParent(false);
            }
         }
         this._content = param1;
         if(this._content !== null)
         {
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).addEventListener("resize",content_resizeHandler);
            }
            this.addChild(this._content);
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).initializeNow();
            }
            if(this._content is IMeasureDisplayObject)
            {
               _loc2_ = IMeasureDisplayObject(this._content);
               this._explicitContentWidth = _loc2_.explicitWidth;
               this._explicitContentHeight = _loc2_.explicitHeight;
               this._explicitContentMinWidth = _loc2_.explicitMinWidth;
               this._explicitContentMinHeight = _loc2_.explicitMinHeight;
               this._explicitContentMaxWidth = _loc2_.explicitMaxWidth;
               this._explicitContentMaxHeight = _loc2_.explicitMaxHeight;
            }
            else
            {
               this._explicitContentWidth = this._content.width;
               this._explicitContentHeight = this._content.height;
               this._explicitContentMinWidth = this._explicitContentWidth;
               this._explicitContentMinHeight = this._explicitContentHeight;
               this._explicitContentMaxWidth = this._explicitContentWidth;
               this._explicitContentMaxHeight = this._explicitContentHeight;
            }
         }
         this.invalidate("size");
         this.invalidate("data");
      }
      
      public function get origin() : DisplayObject
      {
         return this._origin;
      }
      
      public function set origin(param1:DisplayObject) : void
      {
         if(this._origin == param1)
         {
            return;
         }
         if(param1 && !param1.stage)
         {
            throw new ArgumentError("Callout origin must have access to the stage.");
         }
         if(this._origin)
         {
            this.removeEventListener("enterFrame",callout_enterFrameHandler);
            this._origin.removeEventListener("removedFromStage",origin_removedFromStageHandler);
         }
         this._origin = param1;
         this._lastGlobalBoundsOfOrigin = null;
         if(this._origin)
         {
            this._origin.addEventListener("removedFromStage",origin_removedFromStageHandler);
            this.addEventListener("enterFrame",callout_enterFrameHandler);
         }
         this.invalidate("origin");
      }
      
      public function get supportedDirections() : String
      {
         return this._supportedDirections;
      }
      
      public function set supportedDirections(param1:String) : void
      {
         var _loc2_:Vector.<String> = null;
         if(param1 === "any")
         {
            _loc2_ = new <String>["bottom","top","right","left"];
         }
         else if(param1 === "horizontal")
         {
            _loc2_ = new <String>["right","left"];
         }
         else if(param1 === "vertical")
         {
            _loc2_ = new <String>["bottom","top"];
         }
         else if(param1 === "up")
         {
            _loc2_ = new <String>["top"];
         }
         else if(param1 === "down")
         {
            _loc2_ = new <String>["bottom"];
         }
         else if(param1 === "right")
         {
            _loc2_ = new <String>["right"];
         }
         else if(param1 === "left")
         {
            _loc2_ = new <String>["left"];
         }
         this._supportedDirections = param1;
         this.supportedPositions = _loc2_;
      }
      
      public function get supportedPositions() : Vector.<String>
      {
         return this._supportedPositions;
      }
      
      public function set supportedPositions(param1:Vector.<String>) : void
      {
         this._supportedPositions = param1;
      }
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this._horizontalAlign === param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this._lastGlobalBoundsOfOrigin = null;
         this.invalidate("origin");
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign === param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this._lastGlobalBoundsOfOrigin = null;
         this.invalidate("origin");
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
      
      public function get arrowPosition() : String
      {
         return this._arrowPosition;
      }
      
      public function set arrowPosition(param1:String) : void
      {
         if(this._arrowPosition == param1)
         {
            return;
         }
         this._arrowPosition = param1;
         this.invalidate("styles");
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         if(this._backgroundSkin == param1)
         {
            return;
         }
         if(this._backgroundSkin !== null && this._backgroundSkin.parent === this)
         {
            this._backgroundSkin.removeFromParent(false);
         }
         this._backgroundSkin = param1;
         if(this._backgroundSkin !== null)
         {
            this.addChildAt(this._backgroundSkin,0);
            if(this._backgroundSkin is IFeathersControl)
            {
               IFeathersControl(this._backgroundSkin).initializeNow();
            }
            if(this._backgroundSkin is IMeasureDisplayObject)
            {
               _loc2_ = IMeasureDisplayObject(this._backgroundSkin);
               this._explicitBackgroundSkinWidth = _loc2_.explicitWidth;
               this._explicitBackgroundSkinHeight = _loc2_.explicitHeight;
               this._explicitBackgroundSkinMinWidth = _loc2_.explicitMinWidth;
               this._explicitBackgroundSkinMinHeight = _loc2_.explicitMinHeight;
               this._explicitBackgroundSkinMaxWidth = _loc2_.explicitMaxWidth;
               this._explicitBackgroundSkinMaxHeight = _loc2_.explicitMaxHeight;
            }
            else
            {
               this._explicitBackgroundSkinWidth = this._backgroundSkin.width;
               this._explicitBackgroundSkinHeight = this._backgroundSkin.height;
               this._explicitBackgroundSkinMinWidth = this._explicitBackgroundSkinWidth;
               this._explicitBackgroundSkinMinHeight = this._explicitBackgroundSkinHeight;
               this._explicitBackgroundSkinMaxWidth = this._explicitBackgroundSkinWidth;
               this._explicitBackgroundSkinMaxHeight = this._explicitBackgroundSkinHeight;
            }
         }
         this.invalidate("styles");
      }
      
      public function get bottomArrowSkin() : DisplayObject
      {
         return this._bottomArrowSkin;
      }
      
      public function set bottomArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._bottomArrowSkin == param1)
         {
            return;
         }
         if(this._bottomArrowSkin !== null && this._bottomArrowSkin.parent === this)
         {
            this._bottomArrowSkin.removeFromParent(false);
         }
         this._bottomArrowSkin = param1;
         if(this._bottomArrowSkin !== null)
         {
            this._bottomArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._bottomArrowSkin);
            }
            else
            {
               this.addChildAt(this._bottomArrowSkin,_loc2_);
            }
         }
         this.invalidate("styles");
      }
      
      public function get topArrowSkin() : DisplayObject
      {
         return this._topArrowSkin;
      }
      
      public function set topArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._topArrowSkin == param1)
         {
            return;
         }
         if(this._topArrowSkin !== null && this._topArrowSkin.parent === this)
         {
            this._topArrowSkin.removeFromParent(false);
         }
         this._topArrowSkin = param1;
         if(this._topArrowSkin !== null)
         {
            this._topArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._topArrowSkin);
            }
            else
            {
               this.addChildAt(this._topArrowSkin,_loc2_);
            }
         }
         this.invalidate("styles");
      }
      
      public function get leftArrowSkin() : DisplayObject
      {
         return this._leftArrowSkin;
      }
      
      public function set leftArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._leftArrowSkin == param1)
         {
            return;
         }
         if(this._leftArrowSkin !== null && this._leftArrowSkin.parent === this)
         {
            this._leftArrowSkin.removeFromParent(false);
         }
         this._leftArrowSkin = param1;
         if(this._leftArrowSkin !== null)
         {
            this._leftArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._leftArrowSkin);
            }
            else
            {
               this.addChildAt(this._leftArrowSkin,_loc2_);
            }
         }
         this.invalidate("styles");
      }
      
      public function get rightArrowSkin() : DisplayObject
      {
         return this._rightArrowSkin;
      }
      
      public function set rightArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._rightArrowSkin == param1)
         {
            return;
         }
         if(this._rightArrowSkin !== null && this._rightArrowSkin.parent === this)
         {
            this._rightArrowSkin.removeFromParent(false);
         }
         this._rightArrowSkin = param1;
         if(this._rightArrowSkin !== null)
         {
            this._rightArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._rightArrowSkin);
            }
            else
            {
               this.addChildAt(this._rightArrowSkin,_loc2_);
            }
         }
         this.invalidate("styles");
      }
      
      public function get topArrowGap() : Number
      {
         return this._topArrowGap;
      }
      
      public function set topArrowGap(param1:Number) : void
      {
         if(this._topArrowGap == param1)
         {
            return;
         }
         this._topArrowGap = param1;
         this.invalidate("styles");
      }
      
      public function get bottomArrowGap() : Number
      {
         return this._bottomArrowGap;
      }
      
      public function set bottomArrowGap(param1:Number) : void
      {
         if(this._bottomArrowGap == param1)
         {
            return;
         }
         this._bottomArrowGap = param1;
         this.invalidate("styles");
      }
      
      public function get rightArrowGap() : Number
      {
         return this._rightArrowGap;
      }
      
      public function set rightArrowGap(param1:Number) : void
      {
         if(this._rightArrowGap == param1)
         {
            return;
         }
         this._rightArrowGap = param1;
         this.invalidate("styles");
      }
      
      public function get leftArrowGap() : Number
      {
         return this._leftArrowGap;
      }
      
      public function set leftArrowGap(param1:Number) : void
      {
         if(this._leftArrowGap == param1)
         {
            return;
         }
         this._leftArrowGap = param1;
         this.invalidate("styles");
      }
      
      public function get arrowOffset() : Number
      {
         return this._arrowOffset;
      }
      
      public function set arrowOffset(param1:Number) : void
      {
         if(this._arrowOffset == param1)
         {
            return;
         }
         this._arrowOffset = param1;
         this.invalidate("styles");
      }
      
      override public function dispose() : void
      {
         this.origin = null;
         var _loc1_:DisplayObject = this._content;
         this.content = null;
         if(_loc1_ !== null && this.disposeContent)
         {
            _loc1_.dispose();
         }
         super.dispose();
      }
      
      public function close(param1:Boolean = false) : void
      {
         if(this.parent)
         {
            this.removeFromParent(false);
            this.dispatchEventWith("close");
         }
         if(param1)
         {
            this.dispose();
         }
      }
      
      override protected function initialize() : void
      {
         this.addEventListener("removedFromStage",callout_removedFromStageHandler);
      }
      
      override protected function draw() : void
      {
         var _loc4_:Boolean = this.isInvalid("data");
         var _loc1_:Boolean = this.isInvalid("size");
         var _loc3_:Boolean = this.isInvalid("state");
         var _loc5_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("origin");
         if(_loc1_)
         {
            this._lastGlobalBoundsOfOrigin = null;
            _loc2_ = true;
         }
         if(_loc2_)
         {
            this.positionRelativeToOrigin();
         }
         if(_loc5_ || _loc3_)
         {
            this.refreshArrowSkin();
         }
         if(_loc3_ || _loc4_)
         {
            this.refreshEnabled();
         }
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layoutChildren();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         return this.measureWithArrowPosition(this._arrowPosition);
      }
      
      protected function measureWithArrowPosition(param1:String) : Boolean
      {
         var _loc8_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc6_:* = NaN;
         var _loc27_:Number = NaN;
         var _loc20_:* = NaN;
         var _loc25_:Number = NaN;
         var _loc10_:* = NaN;
         var _loc32_:Number = NaN;
         var _loc26_:* = NaN;
         var _loc19_:Number = NaN;
         var _loc15_:* = this._explicitWidth !== this._explicitWidth;
         var _loc9_:* = this._explicitHeight !== this._explicitHeight;
         var _loc24_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc12_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc15_ && !_loc9_ && !_loc24_ && !_loc12_)
         {
            return false;
         }
         if(this._backgroundSkin !== null)
         {
            _loc8_ = this._backgroundSkin.width;
            _loc28_ = this._backgroundSkin.height;
         }
         var _loc17_:IMeasureDisplayObject = this._backgroundSkin as IMeasureDisplayObject;
         resetFluidChildDimensionsForMeasurement(this._backgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundSkinWidth,this._explicitBackgroundSkinHeight,this._explicitBackgroundSkinMinWidth,this._explicitBackgroundSkinMinHeight,this._explicitBackgroundSkinMaxWidth,this._explicitBackgroundSkinMaxHeight);
         if(this._backgroundSkin is IValidating)
         {
            IValidating(this._backgroundSkin).validate();
         }
         var _loc4_:Number = 0;
         var _loc21_:Number = 0;
         if(param1 === "left" && this._leftArrowSkin !== null)
         {
            _loc4_ = this._leftArrowSkin.width + this._leftArrowGap;
            _loc21_ = this._leftArrowSkin.height;
         }
         else if(param1 === "right" && this._rightArrowSkin !== null)
         {
            _loc4_ = this._rightArrowSkin.width + this._rightArrowGap;
            _loc21_ = this._rightArrowSkin.height;
         }
         var _loc29_:Number = 0;
         var _loc11_:Number = 0;
         if(param1 === "top" && this._topArrowSkin !== null)
         {
            _loc29_ = this._topArrowSkin.width;
            _loc11_ = this._topArrowSkin.height + this._topArrowGap;
         }
         else if(param1 === "bottom" && this._bottomArrowSkin !== null)
         {
            _loc29_ = this._bottomArrowSkin.width;
            _loc11_ = this._bottomArrowSkin.height + this._bottomArrowGap;
         }
         var _loc18_:Boolean = this._ignoreContentResize;
         this._ignoreContentResize = true;
         var _loc2_:IMeasureDisplayObject = this._content as IMeasureDisplayObject;
         resetFluidChildDimensionsForMeasurement(this._content,this._explicitWidth - _loc4_ - this._paddingLeft - this._paddingRight,this._explicitHeight - _loc11_ - this._paddingTop - this._paddingBottom,this._explicitMinWidth - _loc4_ - this._paddingLeft - this._paddingRight,this._explicitMinHeight - _loc11_ - this._paddingTop - this._paddingBottom,this._explicitMaxWidth - _loc21_ - this._paddingLeft - this._paddingRight,this._explicitMaxHeight - _loc11_ - this._paddingTop - this._paddingBottom,this._explicitContentWidth,this._explicitContentHeight,this._explicitContentMinWidth,this._explicitContentMinHeight,this._explicitContentMaxWidth,this._explicitContentMaxHeight);
         if(_loc2_ !== null)
         {
            if((_loc5_ = this._explicitMaxWidth - this._paddingLeft - this._paddingRight) < _loc2_.maxWidth)
            {
               _loc2_.maxWidth = _loc5_;
            }
            if((_loc31_ = this._explicitMaxHeight - this._paddingTop - this._paddingBottom) < _loc2_.maxHeight)
            {
               _loc2_.maxHeight = _loc31_;
            }
         }
         if(this._content is IValidating)
         {
            IValidating(this._content).validate();
         }
         this._ignoreContentResize = _loc18_;
         var _loc13_:* = this._explicitMaxWidth;
         var _loc7_:* = this._explicitMaxHeight;
         if(this.stage !== null)
         {
            _loc16_ = this.stage.stageWidth - stagePaddingLeft - stagePaddingRight;
            if(_loc13_ > _loc16_)
            {
               _loc13_ = _loc16_;
            }
            _loc22_ = this.stage.stageHeight - stagePaddingTop - stagePaddingBottom;
            if(_loc7_ > _loc22_)
            {
               _loc7_ = _loc22_;
            }
         }
         var _loc14_:* = this._explicitWidth;
         if(_loc15_)
         {
            _loc6_ = 0;
            if(this._content !== null)
            {
               _loc6_ = this._content.width;
            }
            if(_loc29_ > _loc6_)
            {
               _loc6_ = _loc29_;
            }
            _loc14_ = _loc6_ + this._paddingLeft + this._paddingRight;
            _loc27_ = 0;
            if(this._backgroundSkin !== null)
            {
               _loc27_ = this._backgroundSkin.width;
            }
            if(_loc27_ > _loc14_)
            {
               _loc14_ = _loc27_;
            }
            if((_loc14_ += _loc4_) > _loc13_)
            {
               _loc14_ = _loc13_;
            }
         }
         var _loc3_:* = this._explicitHeight;
         if(_loc9_)
         {
            _loc20_ = 0;
            if(this._content !== null)
            {
               _loc20_ = this._content.height;
            }
            if(_loc21_ > _loc6_)
            {
               _loc20_ = _loc21_;
            }
            _loc3_ = _loc20_ + this._paddingTop + this._paddingBottom;
            _loc25_ = 0;
            if(this._backgroundSkin !== null)
            {
               _loc25_ = this._backgroundSkin.height;
            }
            if(_loc25_ > _loc3_)
            {
               _loc3_ = _loc25_;
            }
            _loc3_ += _loc11_;
            if(_loc3_ > _loc7_)
            {
               _loc3_ = _loc7_;
            }
         }
         var _loc23_:* = this._explicitMinWidth;
         if(_loc24_)
         {
            _loc10_ = 0;
            if(_loc2_ !== null)
            {
               _loc10_ = _loc2_.minWidth;
            }
            else if(this._content !== null)
            {
               _loc10_ = this._content.width;
            }
            if(_loc29_ > _loc10_)
            {
               _loc10_ = _loc29_;
            }
            _loc23_ = _loc10_ + this._paddingLeft + this._paddingRight;
            _loc32_ = 0;
            if(_loc17_ !== null)
            {
               _loc32_ = _loc17_.minWidth;
            }
            else if(this._backgroundSkin !== null)
            {
               _loc32_ = this._explicitBackgroundSkinMinWidth;
            }
            if(_loc32_ > _loc23_)
            {
               _loc23_ = _loc32_;
            }
            if((_loc23_ += _loc4_) > _loc13_)
            {
               _loc23_ = _loc13_;
            }
         }
         var _loc30_:* = this._explicitHeight;
         if(_loc12_)
         {
            _loc26_ = 0;
            if(_loc2_ !== null)
            {
               _loc26_ = _loc2_.minHeight;
            }
            else if(this._content !== null)
            {
               _loc26_ = this._content.height;
            }
            if(_loc21_ > _loc26_)
            {
               _loc26_ = _loc21_;
            }
            _loc30_ = _loc26_ + this._paddingTop + this._paddingBottom;
            _loc19_ = 0;
            if(_loc17_ !== null)
            {
               _loc19_ = _loc17_.minHeight;
            }
            else if(this._backgroundSkin !== null)
            {
               _loc19_ = this._explicitBackgroundSkinMinHeight;
            }
            if(_loc19_ > _loc30_)
            {
               _loc30_ = _loc19_;
            }
            if((_loc30_ += _loc11_) > _loc7_)
            {
               _loc30_ = _loc7_;
            }
         }
         if(this._backgroundSkin !== null)
         {
            this._backgroundSkin.width = _loc8_;
            this._backgroundSkin.height = _loc28_;
         }
         return this.saveMeasurements(_loc14_,_loc3_,_loc23_,_loc30_);
      }
      
      protected function refreshArrowSkin() : void
      {
         this.currentArrowSkin = null;
         if(this._arrowPosition == "bottom")
         {
            this.currentArrowSkin = this._bottomArrowSkin;
         }
         else if(this._bottomArrowSkin)
         {
            this._bottomArrowSkin.visible = false;
         }
         if(this._arrowPosition == "top")
         {
            this.currentArrowSkin = this._topArrowSkin;
         }
         else if(this._topArrowSkin)
         {
            this._topArrowSkin.visible = false;
         }
         if(this._arrowPosition == "left")
         {
            this.currentArrowSkin = this._leftArrowSkin;
         }
         else if(this._leftArrowSkin)
         {
            this._leftArrowSkin.visible = false;
         }
         if(this._arrowPosition == "right")
         {
            this.currentArrowSkin = this._rightArrowSkin;
         }
         else if(this._rightArrowSkin)
         {
            this._rightArrowSkin.visible = false;
         }
         if(this.currentArrowSkin)
         {
            this.currentArrowSkin.visible = true;
         }
      }
      
      protected function refreshEnabled() : void
      {
         if(this._content is IFeathersControl)
         {
            IFeathersControl(this._content).isEnabled = this._isEnabled;
         }
      }
      
      protected function layoutChildren() : void
      {
         var _loc17_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc4_:* = NaN;
         var _loc5_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc14_:* = NaN;
         var _loc21_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc15_:* = NaN;
         var _loc3_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:* = NaN;
         var _loc16_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc11_:Boolean = false;
         var _loc1_:Number = 0;
         if(this._leftArrowSkin !== null && this._arrowPosition === "left")
         {
            _loc1_ = this._leftArrowSkin.width + this._leftArrowGap;
         }
         var _loc8_:Number = 0;
         if(this._topArrowSkin !== null && this._arrowPosition === "top")
         {
            _loc8_ = this._topArrowSkin.height + this._topArrowGap;
         }
         var _loc12_:Number = 0;
         if(this._rightArrowSkin !== null && this._arrowPosition === "right")
         {
            _loc12_ = this._rightArrowSkin.width + this._rightArrowGap;
         }
         var _loc10_:Number = 0;
         if(this._bottomArrowSkin !== null && this._arrowPosition === "bottom")
         {
            _loc10_ = this._bottomArrowSkin.height + this._bottomArrowGap;
         }
         var _loc19_:Number = this.actualWidth - _loc1_ - _loc12_;
         var _loc18_:Number = this.actualHeight - _loc8_ - _loc10_;
         if(this._backgroundSkin !== null)
         {
            this._backgroundSkin.x = _loc1_;
            this._backgroundSkin.y = _loc8_;
            this._backgroundSkin.width = _loc19_;
            this._backgroundSkin.height = _loc18_;
         }
         if(this.currentArrowSkin !== null)
         {
            _loc17_ = _loc19_ - this._paddingLeft - this._paddingRight;
            _loc13_ = _loc18_ - this._paddingTop - this._paddingBottom;
            if(this._arrowPosition === "left")
            {
               this._leftArrowSkin.x = _loc1_ - this._leftArrowSkin.width - this._leftArrowGap;
               _loc4_ = this._arrowOffset + _loc8_ + this._paddingTop;
               if(this._verticalAlign === "middle")
               {
                  _loc4_ += Math.round((_loc13_ - this._leftArrowSkin.height) / 2);
               }
               else if(this._verticalAlign === "bottom")
               {
                  _loc4_ += _loc13_ - this._leftArrowSkin.height;
               }
               if((_loc5_ = _loc8_ + this._paddingTop) > _loc4_)
               {
                  _loc4_ = _loc5_;
               }
               else if((_loc9_ = _loc8_ + this._paddingTop + _loc13_ - this._leftArrowSkin.height) < _loc4_)
               {
                  _loc4_ = _loc9_;
               }
               this._leftArrowSkin.y = _loc4_;
            }
            else if(this._arrowPosition === "right")
            {
               this._rightArrowSkin.x = _loc1_ + _loc19_ + this._rightArrowGap;
               _loc14_ = this._arrowOffset + _loc8_ + this._paddingTop;
               if(this._verticalAlign === "middle")
               {
                  _loc14_ += Math.round((_loc13_ - this._rightArrowSkin.height) / 2);
               }
               else if(this._verticalAlign === "bottom")
               {
                  _loc14_ += _loc13_ - this._rightArrowSkin.height;
               }
               if((_loc21_ = _loc8_ + this._paddingTop) > _loc14_)
               {
                  _loc14_ = _loc21_;
               }
               else
               {
                  _loc2_ = _loc8_ + this._paddingTop + _loc13_ - this._rightArrowSkin.height;
                  if(_loc2_ < _loc14_)
                  {
                     _loc14_ = _loc2_;
                  }
               }
               this._rightArrowSkin.y = _loc14_;
            }
            else if(this._arrowPosition === "bottom")
            {
               _loc15_ = this._arrowOffset + _loc1_ + this._paddingLeft;
               if(this._horizontalAlign === "center")
               {
                  _loc15_ += Math.round((_loc17_ - this._bottomArrowSkin.width) / 2);
               }
               else if(this._horizontalAlign === "right")
               {
                  _loc15_ += _loc17_ - this._bottomArrowSkin.width;
               }
               _loc3_ = _loc1_ + this._paddingLeft;
               if(_loc3_ > _loc15_)
               {
                  _loc15_ = _loc3_;
               }
               else if((_loc6_ = _loc1_ + this._paddingLeft + _loc17_ - this._bottomArrowSkin.width) < _loc15_)
               {
                  _loc15_ = _loc6_;
               }
               this._bottomArrowSkin.x = _loc15_;
               this._bottomArrowSkin.y = _loc8_ + _loc18_ + this._bottomArrowGap;
            }
            else
            {
               _loc7_ = this._arrowOffset + _loc1_ + this._paddingLeft;
               if(this._horizontalAlign === "center")
               {
                  _loc7_ += Math.round((_loc17_ - this._topArrowSkin.width) / 2);
               }
               else if(this._horizontalAlign === "right")
               {
                  _loc7_ += _loc17_ - this._topArrowSkin.width;
               }
               if((_loc16_ = _loc1_ + this._paddingLeft) > _loc7_)
               {
                  _loc7_ = _loc16_;
               }
               else if((_loc20_ = _loc1_ + this._paddingLeft + _loc17_ - this._topArrowSkin.width) < _loc7_)
               {
                  _loc7_ = _loc20_;
               }
               this._topArrowSkin.x = _loc7_;
               this._topArrowSkin.y = _loc8_ - this._topArrowSkin.height - this._topArrowGap;
            }
         }
         if(this._content !== null)
         {
            this._content.x = _loc1_ + this._paddingLeft;
            this._content.y = _loc8_ + this._paddingTop;
            _loc11_ = this._ignoreContentResize;
            this._ignoreContentResize = true;
            this._content.width = _loc19_ - this._paddingLeft - this._paddingRight;
            this._content.height = _loc18_ - this._paddingTop - this._paddingBottom;
            if(this._content is IValidating)
            {
               IValidating(this._content).validate();
            }
            this._ignoreContentResize = _loc11_;
         }
      }
      
      protected function positionRelativeToOrigin() : void
      {
         var _loc6_:int = 0;
         var _loc9_:String = null;
         if(this._origin === null)
         {
            return;
         }
         this._origin.getBounds(Starling.current.stage,HELPER_RECT);
         var _loc8_:*;
         if((_loc8_ = this._lastGlobalBoundsOfOrigin != null) && this._lastGlobalBoundsOfOrigin.equals(HELPER_RECT))
         {
            return;
         }
         if(!_loc8_)
         {
            this._lastGlobalBoundsOfOrigin = new Rectangle();
         }
         this._lastGlobalBoundsOfOrigin.x = HELPER_RECT.x;
         this._lastGlobalBoundsOfOrigin.y = HELPER_RECT.y;
         this._lastGlobalBoundsOfOrigin.width = HELPER_RECT.width;
         this._lastGlobalBoundsOfOrigin.height = HELPER_RECT.height;
         var _loc2_:Vector.<String> = this._supportedPositions;
         if(_loc2_ === null)
         {
            _loc2_ = DEFAULT_POSITIONS;
         }
         var _loc3_:Number = -1;
         var _loc1_:Number = -1;
         var _loc7_:Number = -1;
         var _loc4_:Number = -1;
         var _loc5_:int = int(_loc2_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            switch(_loc9_ = _loc2_[_loc6_])
            {
               case "top":
                  this.measureWithArrowPosition("bottom");
                  _loc3_ = this._lastGlobalBoundsOfOrigin.y - this.actualHeight;
                  if(_loc3_ >= stagePaddingTop)
                  {
                     positionAboveOrigin(this,this._lastGlobalBoundsOfOrigin);
                     return;
                  }
                  if(_loc3_ < 0)
                  {
                     _loc3_ = 0;
                  }
                  break;
               case "right":
                  this.measureWithArrowPosition("left");
                  _loc1_ = Starling.current.stage.stageWidth - actualWidth - (this._lastGlobalBoundsOfOrigin.x + this._lastGlobalBoundsOfOrigin.width);
                  if(_loc1_ >= stagePaddingRight)
                  {
                     positionToRightOfOrigin(this,this._lastGlobalBoundsOfOrigin);
                     return;
                  }
                  if(_loc1_ < 0)
                  {
                     _loc1_ = 0;
                  }
                  break;
               case "left":
                  this.measureWithArrowPosition("right");
                  if((_loc4_ = this._lastGlobalBoundsOfOrigin.x - this.actualWidth) >= stagePaddingLeft)
                  {
                     positionToLeftOfOrigin(this,this._lastGlobalBoundsOfOrigin);
                     return;
                  }
                  if(_loc4_ < 0)
                  {
                     _loc4_ = 0;
                  }
                  break;
               default:
                  this.measureWithArrowPosition("top");
                  if((_loc7_ = Starling.current.stage.stageHeight - this.actualHeight - (this._lastGlobalBoundsOfOrigin.y + this._lastGlobalBoundsOfOrigin.height)) >= stagePaddingBottom)
                  {
                     positionBelowOrigin(this,this._lastGlobalBoundsOfOrigin);
                     return;
                  }
                  if(_loc7_ < 0)
                  {
                     _loc7_ = 0;
                  }
                  break;
            }
            _loc6_++;
         }
         if(_loc7_ !== -1 && _loc7_ >= _loc3_ && _loc7_ >= _loc1_ && _loc7_ >= _loc4_)
         {
            positionBelowOrigin(this,this._lastGlobalBoundsOfOrigin);
         }
         else if(_loc3_ !== -1 && _loc3_ >= _loc1_ && _loc3_ >= _loc4_)
         {
            positionAboveOrigin(this,this._lastGlobalBoundsOfOrigin);
         }
         else if(_loc1_ !== -1 && _loc1_ >= _loc4_)
         {
            positionToRightOfOrigin(this,this._lastGlobalBoundsOfOrigin);
         }
         else
         {
            positionToLeftOfOrigin(this,this._lastGlobalBoundsOfOrigin);
         }
      }
      
      protected function callout_addedToStageHandler(param1:Event) : void
      {
         var _loc2_:int = -getDisplayObjectDepthFromStage(this);
         Starling.current.nativeStage.addEventListener("keyDown",callout_nativeStage_keyDownHandler,false,_loc2_,true);
         this.stage.addEventListener("touch",stage_touchHandler);
         this._isReadyToClose = false;
         this.addEventListener("enterFrame",callout_oneEnterFrameHandler);
      }
      
      protected function callout_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener("touch",stage_touchHandler);
         Starling.current.nativeStage.removeEventListener("keyDown",callout_nativeStage_keyDownHandler);
      }
      
      protected function callout_oneEnterFrameHandler(param1:Event) : void
      {
         this.removeEventListener("enterFrame",callout_oneEnterFrameHandler);
         this._isReadyToClose = true;
      }
      
      protected function callout_enterFrameHandler(param1:EnterFrameEvent) : void
      {
         this.positionRelativeToOrigin();
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:DisplayObject = DisplayObject(param1.target);
         if(!this._isReadyToClose || !this.closeOnTouchEndedOutside && !this.closeOnTouchBeganOutside || this.contains(_loc3_) || PopUpManager.isPopUp(this) && !PopUpManager.isTopLevelPopUp(this))
         {
            return;
         }
         if(this._origin == _loc3_ || this._origin is DisplayObjectContainer && Boolean(DisplayObjectContainer(this._origin).contains(_loc3_)))
         {
            return;
         }
         if(this.closeOnTouchBeganOutside)
         {
            _loc2_ = param1.getTouch(this.stage,"began");
            if(_loc2_)
            {
               this.close(this.disposeOnSelfClose);
               return;
            }
         }
         if(this.closeOnTouchEndedOutside)
         {
            _loc2_ = param1.getTouch(this.stage,"ended");
            if(_loc2_)
            {
               this.close(this.disposeOnSelfClose);
               return;
            }
         }
      }
      
      protected function callout_nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(!this.closeOnKeys || this.closeOnKeys.indexOf(param1.keyCode) < 0)
         {
            return;
         }
         param1.preventDefault();
         this.close(this.disposeOnSelfClose);
      }
      
      protected function origin_removedFromStageHandler(param1:Event) : void
      {
         this.close(this.disposeOnSelfClose);
      }
      
      protected function content_resizeHandler(param1:Event) : void
      {
         if(this._ignoreContentResize)
         {
            return;
         }
         this.invalidate("size");
      }
   }
}
