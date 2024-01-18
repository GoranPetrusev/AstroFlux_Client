package starling.core
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.Stage3D;
   import flash.display3D.Context3D;
   import flash.errors.IllegalOperationError;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TouchEvent;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Mouse;
   import flash.ui.Multitouch;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import starling.animation.Juggler;
   import starling.display.DisplayObject;
   import starling.display.Stage;
   import starling.events.EventDispatcher;
   import starling.events.KeyboardEvent;
   import starling.events.ResizeEvent;
   import starling.events.TouchProcessor;
   import starling.rendering.Painter;
   import starling.utils.RectangleUtil;
   import starling.utils.SystemUtil;
   
   public class Starling extends EventDispatcher
   {
      
      public static const VERSION:String = "2.1.1";
      
      private static var sCurrent:Starling;
      
      private static var sAll:Vector.<Starling> = new Vector.<Starling>(0);
       
      
      private var _stage:starling.display.Stage;
      
      private var _rootClass:Class;
      
      private var _root:DisplayObject;
      
      private var _juggler:Juggler;
      
      private var _painter:Painter;
      
      private var _touchProcessor:TouchProcessor;
      
      private var _antiAliasing:int;
      
      private var _frameTimestamp:Number;
      
      private var _frameID:uint;
      
      private var _leftMouseDown:Boolean;
      
      private var _statsDisplay:StatsDisplay;
      
      private var _started:Boolean;
      
      private var _rendering:Boolean;
      
      private var _supportHighResolutions:Boolean;
      
      private var _skipUnchangedFrames:Boolean;
      
      private var _showStats:Boolean;
      
      private var _viewPort:Rectangle;
      
      private var _previousViewPort:Rectangle;
      
      private var _clippedViewPort:Rectangle;
      
      private var _nativeStage:flash.display.Stage;
      
      private var _nativeStageEmpty:Boolean;
      
      private var _nativeOverlay:Sprite;
      
      public function Starling(param1:Class, param2:flash.display.Stage, param3:Rectangle = null, param4:Stage3D = null, param5:String = "auto", param6:Object = "auto")
      {
         super();
         if(param2 == null)
         {
            throw new ArgumentError("Stage must not be null");
         }
         if(param3 == null)
         {
            param3 = new Rectangle(0,0,param2.stageWidth,param2.stageHeight);
         }
         if(param4 == null)
         {
            param4 = param2.stage3Ds[0];
         }
         SystemUtil.initialize();
         sAll.push(this);
         makeCurrent();
         _rootClass = param1;
         _viewPort = param3;
         _previousViewPort = new Rectangle();
         _stage = new starling.display.Stage(param3.width,param3.height,param2.color);
         _nativeOverlay = new Sprite();
         _nativeStage = param2;
         _nativeStage.addChild(_nativeOverlay);
         _touchProcessor = new TouchProcessor(_stage);
         _juggler = new Juggler();
         _antiAliasing = 0;
         _supportHighResolutions = false;
         _painter = new Painter(param4);
         _frameTimestamp = getTimer() / 1000;
         _frameID = 1;
         param2.scaleMode = "noScale";
         param2.align = "TL";
         for each(var _loc7_ in touchEventTypes)
         {
            param2.addEventListener(_loc7_,onTouch,false,0,true);
         }
         param2.addEventListener("enterFrame",onEnterFrame,false,0,true);
         param2.addEventListener("keyDown",onKey,false,0,true);
         param2.addEventListener("keyUp",onKey,false,0,true);
         param2.addEventListener("resize",onResize,false,0,true);
         param2.addEventListener("mouseLeave",onMouseLeave,false,0,true);
         param4.addEventListener("context3DCreate",onContextCreated,false,10,true);
         param4.addEventListener("error",onStage3DError,false,10,true);
         if(_painter.shareContext)
         {
            setTimeout(initialize,1);
         }
         else
         {
            _painter.requestContext3D(param5,param6);
         }
      }
      
      public static function get current() : Starling
      {
         return sCurrent;
      }
      
      public static function get all() : Vector.<Starling>
      {
         return sAll;
      }
      
      public static function get context() : Context3D
      {
         return !!sCurrent ? sCurrent.context : null;
      }
      
      public static function get juggler() : Juggler
      {
         return !!sCurrent ? sCurrent._juggler : null;
      }
      
      public static function get painter() : Painter
      {
         return !!sCurrent ? sCurrent._painter : null;
      }
      
      public static function get contentScaleFactor() : Number
      {
         return !!sCurrent ? sCurrent.contentScaleFactor : 1;
      }
      
      public static function get multitouchEnabled() : Boolean
      {
         return Multitouch.inputMode == "touchPoint";
      }
      
      public static function set multitouchEnabled(param1:Boolean) : void
      {
         if(sCurrent)
         {
            throw new IllegalOperationError("\'multitouchEnabled\' must be set before Starling instance is created");
         }
         Multitouch.inputMode = param1 ? "touchPoint" : "none";
      }
      
      public static function get frameID() : uint
      {
         return !!sCurrent ? sCurrent._frameID : 0;
      }
      
      public function dispose() : void
      {
         stop(true);
         _nativeStage.removeEventListener("enterFrame",onEnterFrame,false);
         _nativeStage.removeEventListener("keyDown",onKey,false);
         _nativeStage.removeEventListener("keyUp",onKey,false);
         _nativeStage.removeEventListener("resize",onResize,false);
         _nativeStage.removeEventListener("mouseLeave",onMouseLeave,false);
         _nativeStage.removeChild(_nativeOverlay);
         stage3D.removeEventListener("context3DCreate",onContextCreated,false);
         stage3D.removeEventListener("context3DCreate",onContextRestored,false);
         stage3D.removeEventListener("error",onStage3DError,false);
         for each(var _loc2_ in touchEventTypes)
         {
            _nativeStage.removeEventListener(_loc2_,onTouch,false);
         }
         _touchProcessor.dispose();
         _painter.dispose();
         _stage.dispose();
         var _loc1_:int = sAll.indexOf(this);
         if(_loc1_ != -1)
         {
            sAll.removeAt(_loc1_);
         }
         if(sCurrent == this)
         {
            sCurrent = null;
         }
      }
      
      private function initialize() : void
      {
         makeCurrent();
         updateViewPort(true);
         dispatchEventWith("context3DCreate",false,context);
         initializeRoot();
         _frameTimestamp = getTimer() / 1000;
      }
      
      private function initializeRoot() : void
      {
         if(_root == null && _rootClass != null)
         {
            _root = new _rootClass() as DisplayObject;
            if(_root == null)
            {
               throw new Error("Invalid root class: " + _rootClass);
            }
            _stage.addChildAt(_root,0);
            dispatchEventWith("rootCreated",false,_root);
         }
      }
      
      public function nextFrame() : void
      {
         var _loc1_:Number = getTimer() / 1000;
         var _loc2_:Number = _loc1_ - _frameTimestamp;
         _frameTimestamp = _loc1_;
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ < 0)
         {
            _loc2_ = 1 / _nativeStage.frameRate;
         }
         advanceTime(_loc2_);
         render();
      }
      
      public function advanceTime(param1:Number) : void
      {
         if(!contextValid)
         {
            return;
         }
         makeCurrent();
         _touchProcessor.advanceTime(param1);
         _stage.advanceTime(param1);
         _juggler.advanceTime(param1);
      }
      
      public function render() : void
      {
         var _loc4_:Boolean = false;
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(!contextValid)
         {
            return;
         }
         makeCurrent();
         updateViewPort();
         var _loc3_:Boolean = _stage.requiresRedraw || mustAlwaysRender;
         if(_loc3_)
         {
            dispatchEventWith("render");
            _loc4_ = _painter.shareContext;
            _loc1_ = _viewPort.width / _stage.stageWidth;
            _loc2_ = _viewPort.height / _stage.stageHeight;
            _painter.nextFrame();
            _painter.pixelSize = 1 / contentScaleFactor;
            _painter.state.setProjectionMatrix(_viewPort.x < 0 ? -_viewPort.x / _loc1_ : 0,_viewPort.y < 0 ? -_viewPort.y / _loc2_ : 0,_clippedViewPort.width / _loc1_,_clippedViewPort.height / _loc2_,_stage.stageWidth,_stage.stageHeight,_stage.cameraPosition);
            if(!_loc4_)
            {
               _painter.clear(_stage.color,0);
            }
            _stage.render(_painter);
            _painter.finishFrame();
            _painter.frameID = ++_frameID;
            if(!_loc4_)
            {
               _painter.present();
            }
         }
         if(_statsDisplay)
         {
            _statsDisplay.drawCount = _painter.drawCount;
            if(!_loc3_)
            {
               _statsDisplay.markFrameAsSkipped();
            }
         }
      }
      
      private function updateViewPort(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         if(param1 || !RectangleUtil.compare(_viewPort,_previousViewPort))
         {
            _previousViewPort.setTo(_viewPort.x,_viewPort.y,_viewPort.width,_viewPort.height);
            _clippedViewPort = _viewPort.intersection(new Rectangle(0,0,_nativeStage.stageWidth,_nativeStage.stageHeight));
            if(_clippedViewPort.width < 32)
            {
               _clippedViewPort.width = 32;
            }
            if(_clippedViewPort.height < 32)
            {
               _clippedViewPort.height = 32;
            }
            _loc2_ = _supportHighResolutions ? _nativeStage.contentsScaleFactor : 1;
            _painter.configureBackBuffer(_clippedViewPort,_loc2_,_antiAliasing,true);
         }
      }
      
      private function updateNativeOverlay() : void
      {
         _nativeOverlay.x = _viewPort.x;
         _nativeOverlay.y = _viewPort.y;
         _nativeOverlay.scaleX = _viewPort.width / _stage.stageWidth;
         _nativeOverlay.scaleY = _viewPort.height / _stage.stageHeight;
      }
      
      public function stopWithFatalError(param1:String) : void
      {
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(0,0.8);
         _loc2_.graphics.drawRect(0,0,_stage.stageWidth,_stage.stageHeight);
         _loc2_.graphics.endFill();
         var _loc3_:TextField = new TextField();
         var _loc4_:TextFormat;
         (_loc4_ = new TextFormat("Verdana",14,16777215)).align = "center";
         _loc3_.defaultTextFormat = _loc4_;
         _loc3_.wordWrap = true;
         _loc3_.width = _stage.stageWidth * 0.75;
         _loc3_.autoSize = "center";
         _loc3_.text = param1;
         _loc3_.x = (_stage.stageWidth - _loc3_.width) / 2;
         _loc3_.y = (_stage.stageHeight - _loc3_.height) / 2;
         _loc3_.background = true;
         _loc3_.backgroundColor = 5570560;
         updateNativeOverlay();
         nativeOverlay.addChild(_loc2_);
         nativeOverlay.addChild(_loc3_);
         stop(true);
         trace("[Starling]",param1);
         dispatchEventWith("fatalError",false,param1);
      }
      
      public function makeCurrent() : void
      {
         sCurrent = this;
      }
      
      public function start() : void
      {
         _started = _rendering = true;
         _frameTimestamp = getTimer() / 1000;
         setTimeout(setRequiresRedraw,100);
      }
      
      public function stop(param1:Boolean = false) : void
      {
         _started = false;
         _rendering = !param1;
      }
      
      public function setRequiresRedraw() : void
      {
         _stage.setRequiresRedraw();
      }
      
      private function onStage3DError(param1:ErrorEvent) : void
      {
         var _loc2_:String = null;
         if(param1.errorID == 3702)
         {
            _loc2_ = Capabilities.playerType == "Desktop" ? "renderMode" : "wmode";
            stopWithFatalError("Context3D not available! Possible reasons: wrong " + _loc2_ + " or missing device support.");
         }
         else
         {
            stopWithFatalError("Stage3D error: " + param1.text);
         }
      }
      
      private function onContextCreated(param1:Event) : void
      {
         stage3D.removeEventListener("context3DCreate",onContextCreated);
         stage3D.addEventListener("context3DCreate",onContextRestored,false,10,true);
         trace("[Starling] Context ready. Display Driver:",context.driverInfo);
         initialize();
      }
      
      private function onContextRestored(param1:Event) : void
      {
         trace("[Starling] Context restored.");
         updateViewPort(true);
         dispatchEventWith("context3DCreate",false,context);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(!shareContext)
         {
            if(_started)
            {
               nextFrame();
            }
            else if(_rendering)
            {
               render();
            }
         }
         updateNativeOverlay();
      }
      
      private function onKey(param1:flash.events.KeyboardEvent) : void
      {
         if(!_started)
         {
            return;
         }
         var _loc2_:starling.events.KeyboardEvent = new starling.events.KeyboardEvent(param1.type,param1.charCode,param1.keyCode,param1.keyLocation,param1.ctrlKey,param1.altKey,param1.shiftKey);
         makeCurrent();
         _stage.dispatchEvent(_loc2_);
         if(_loc2_.isDefaultPrevented())
         {
            param1.preventDefault();
         }
      }
      
      private function onResize(param1:Event) : void
      {
         var event:Event = param1;
         var dispatchResizeEvent:* = function():void
         {
            makeCurrent();
            removeEventListener("context3DCreate",dispatchResizeEvent);
            _stage.dispatchEvent(new ResizeEvent("resize",stageWidth,stageHeight));
         };
         var stageWidth:int = int(event.target.stageWidth);
         var stageHeight:int = int(event.target.stageHeight);
         if(contextValid)
         {
            dispatchResizeEvent();
         }
         else
         {
            addEventListener("context3DCreate",dispatchResizeEvent);
         }
      }
      
      private function onMouseLeave(param1:Event) : void
      {
         _touchProcessor.enqueueMouseLeftStage();
      }
      
      private function onTouch(param1:Event) : void
      {
         var _loc5_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc6_:int = 0;
         var _loc2_:String = null;
         var _loc4_:MouseEvent = null;
         var _loc8_:TouchEvent = null;
         if(!_started)
         {
            return;
         }
         var _loc9_:Number = 1;
         var _loc7_:Number = 1;
         var _loc10_:Number = 1;
         if(param1 is MouseEvent)
         {
            _loc5_ = (_loc4_ = param1 as MouseEvent).stageX;
            _loc3_ = _loc4_.stageY;
            _loc6_ = 0;
            if(param1.type == "mouseDown")
            {
               _leftMouseDown = true;
            }
            else if(param1.type == "mouseUp")
            {
               _leftMouseDown = false;
            }
         }
         else
         {
            _loc8_ = param1 as TouchEvent;
            if(Mouse.supportsCursor && _loc8_.isPrimaryTouchPoint)
            {
               return;
            }
            _loc5_ = _loc8_.stageX;
            _loc3_ = _loc8_.stageY;
            _loc6_ = _loc8_.touchPointID;
            _loc9_ = _loc8_.pressure;
            _loc7_ = _loc8_.sizeX;
            _loc10_ = _loc8_.sizeY;
         }
         switch(param1.type)
         {
            case "touchBegin":
               _loc2_ = "began";
               break;
            case "touchMove":
               _loc2_ = "moved";
               break;
            case "touchEnd":
               _loc2_ = "ended";
               break;
            case "mouseDown":
               _loc2_ = "began";
               break;
            case "mouseUp":
               _loc2_ = "ended";
               break;
            case "mouseMove":
               _loc2_ = _leftMouseDown ? "moved" : "hover";
         }
         _loc5_ = _stage.stageWidth * (_loc5_ - _viewPort.x) / _viewPort.width;
         _loc3_ = _stage.stageHeight * (_loc3_ - _viewPort.y) / _viewPort.height;
         _touchProcessor.enqueue(_loc6_,_loc2_,_loc5_,_loc3_,_loc9_,_loc7_,_loc10_);
         if(param1.type == "mouseUp" && Mouse.supportsCursor)
         {
            _touchProcessor.enqueue(_loc6_,"hover",_loc5_,_loc3_);
         }
      }
      
      private function get touchEventTypes() : Array
      {
         var _loc1_:Array = [];
         if(multitouchEnabled)
         {
            _loc1_.push("touchBegin","touchMove","touchEnd");
         }
         if(!multitouchEnabled || Mouse.supportsCursor)
         {
            _loc1_.push("mouseDown","mouseMove","mouseUp");
         }
         return _loc1_;
      }
      
      private function get mustAlwaysRender() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc1_:Boolean = false;
         if(!_skipUnchangedFrames || _painter.shareContext)
         {
            return true;
         }
         if(SystemUtil.isDesktop && profile != "baselineConstrained")
         {
            return false;
         }
         _loc2_ = Boolean(isNativeDisplayObjectEmpty(_nativeStage));
         _loc1_ = !_loc2_ || !_nativeStageEmpty;
         _nativeStageEmpty = _loc2_;
         return _loc1_;
      }
      
      public function get isStarted() : Boolean
      {
         return _started;
      }
      
      public function get juggler() : Juggler
      {
         return _juggler;
      }
      
      public function get painter() : Painter
      {
         return _painter;
      }
      
      public function get context() : Context3D
      {
         return _painter.context;
      }
      
      public function get simulateMultitouch() : Boolean
      {
         return _touchProcessor.simulateMultitouch;
      }
      
      public function set simulateMultitouch(param1:Boolean) : void
      {
         _touchProcessor.simulateMultitouch = param1;
      }
      
      public function get enableErrorChecking() : Boolean
      {
         return _painter.enableErrorChecking;
      }
      
      public function set enableErrorChecking(param1:Boolean) : void
      {
         _painter.enableErrorChecking = param1;
      }
      
      public function get antiAliasing() : int
      {
         return _antiAliasing;
      }
      
      public function set antiAliasing(param1:int) : void
      {
         if(_antiAliasing != param1)
         {
            _antiAliasing = param1;
            if(contextValid)
            {
               updateViewPort(true);
            }
         }
      }
      
      public function get viewPort() : Rectangle
      {
         return _viewPort;
      }
      
      public function set viewPort(param1:Rectangle) : void
      {
         _viewPort = param1.clone();
      }
      
      public function get contentScaleFactor() : Number
      {
         return _viewPort.width * _painter.backBufferScaleFactor / _stage.stageWidth;
      }
      
      public function get nativeOverlay() : Sprite
      {
         return _nativeOverlay;
      }
      
      public function get showStats() : Boolean
      {
         return _showStats;
      }
      
      public function set showStats(param1:Boolean) : void
      {
         _showStats = param1;
         if(param1)
         {
            if(_statsDisplay)
            {
               _stage.addChild(_statsDisplay);
            }
            else
            {
               showStatsAt();
            }
         }
         else if(_statsDisplay)
         {
            _statsDisplay.removeFromParent();
         }
      }
      
      public function showStatsAt(param1:String = "left", param2:String = "top", param3:Number = 1) : void
      {
         var stageWidth:int;
         var stageHeight:int;
         var horizontalAlign:String = param1;
         var verticalAlign:String = param2;
         var scale:Number = param3;
         var onRootCreated:* = function():void
         {
            if(_showStats)
            {
               showStatsAt(horizontalAlign,verticalAlign,scale);
            }
            removeEventListener("rootCreated",onRootCreated);
         };
         _showStats = true;
         if(context == null)
         {
            addEventListener("rootCreated",onRootCreated);
         }
         else
         {
            stageWidth = _stage.stageWidth;
            stageHeight = _stage.stageHeight;
            if(_statsDisplay == null)
            {
               _statsDisplay = new StatsDisplay();
               _statsDisplay.touchable = false;
            }
            _stage.addChild(_statsDisplay);
            _statsDisplay.scaleX = _statsDisplay.scaleY = scale;
            if(horizontalAlign == "left")
            {
               _statsDisplay.x = 0;
            }
            else if(horizontalAlign == "right")
            {
               _statsDisplay.x = stageWidth - _statsDisplay.width;
            }
            else
            {
               if(horizontalAlign != "center")
               {
                  throw new ArgumentError("Invalid horizontal alignment: " + horizontalAlign);
               }
               _statsDisplay.x = (stageWidth - _statsDisplay.width) / 2;
            }
            if(verticalAlign == "top")
            {
               _statsDisplay.y = 0;
            }
            else if(verticalAlign == "bottom")
            {
               _statsDisplay.y = stageHeight - _statsDisplay.height;
            }
            else
            {
               if(verticalAlign != "center")
               {
                  throw new ArgumentError("Invalid vertical alignment: " + verticalAlign);
               }
               _statsDisplay.y = (stageHeight - _statsDisplay.height) / 2;
            }
         }
      }
      
      public function get stage() : starling.display.Stage
      {
         return _stage;
      }
      
      public function get stage3D() : Stage3D
      {
         return _painter.stage3D;
      }
      
      public function get nativeStage() : flash.display.Stage
      {
         return _nativeStage;
      }
      
      public function get root() : DisplayObject
      {
         return _root;
      }
      
      public function get rootClass() : Class
      {
         return _rootClass;
      }
      
      public function set rootClass(param1:Class) : void
      {
         if(_rootClass != null && _root != null)
         {
            throw new Error("Root class may not change after root has been instantiated");
         }
         if(_rootClass == null)
         {
            _rootClass = param1;
            if(context)
            {
               initializeRoot();
            }
         }
      }
      
      public function get shareContext() : Boolean
      {
         return _painter.shareContext;
      }
      
      public function set shareContext(param1:Boolean) : void
      {
         _painter.shareContext = param1;
      }
      
      public function get profile() : String
      {
         return _painter.profile;
      }
      
      public function get supportHighResolutions() : Boolean
      {
         return _supportHighResolutions;
      }
      
      public function set supportHighResolutions(param1:Boolean) : void
      {
         if(_supportHighResolutions != param1)
         {
            _supportHighResolutions = param1;
            if(contextValid)
            {
               updateViewPort(true);
            }
         }
      }
      
      public function get skipUnchangedFrames() : Boolean
      {
         return _skipUnchangedFrames;
      }
      
      public function set skipUnchangedFrames(param1:Boolean) : void
      {
         _skipUnchangedFrames = param1;
         _nativeStageEmpty = false;
      }
      
      public function get touchProcessor() : TouchProcessor
      {
         return _touchProcessor;
      }
      
      public function set touchProcessor(param1:TouchProcessor) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("TouchProcessor must not be null");
         }
         if(param1 != _touchProcessor)
         {
            _touchProcessor.dispose();
            _touchProcessor = param1;
         }
      }
      
      public function get frameID() : uint
      {
         return _frameID;
      }
      
      public function get contextValid() : Boolean
      {
         return _painter.contextValid;
      }
   }
}

function isNativeDisplayObjectEmpty(param1:DisplayObject):Boolean
{
   var _loc2_:DisplayObjectContainer = null;
   var _loc3_:int = 0;
   var _loc4_:int = 0;
   if(param1 == null)
   {
      return true;
   }
   if(param1 is DisplayObjectContainer)
   {
      _loc2_ = param1 as DisplayObjectContainer;
      _loc3_ = _loc2_.numChildren;
      _loc4_ = 0;
      while(_loc4_ < _loc3_)
      {
         if(!isNativeDisplayObjectEmpty(_loc2_.getChildAt(_loc4_)))
         {
            return false;
         }
         _loc4_++;
      }
      return true;
   }
   return !param1.visible;
}