package starling.events
{
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Stage;
   
   public class TouchProcessor
   {
      
      private static var sUpdatedTouches:Vector.<Touch> = new Vector.<Touch>(0);
      
      private static var sHoveringTouchData:Vector.<Object> = new Vector.<Object>(0);
      
      private static var sHelperPoint:Point = new Point();
       
      
      private var _stage:Stage;
      
      private var _root:DisplayObject;
      
      private var _elapsedTime:Number;
      
      private var _lastTaps:Vector.<Touch>;
      
      private var _shiftDown:Boolean = false;
      
      private var _ctrlDown:Boolean = false;
      
      private var _multitapTime:Number = 0.3;
      
      private var _multitapDistance:Number = 25;
      
      private var _touchEvent:TouchEvent;
      
      private var _touchMarker:TouchMarker;
      
      private var _simulateMultitouch:Boolean;
      
      protected var _queue:Vector.<Array>;
      
      protected var _currentTouches:Vector.<Touch>;
      
      public function TouchProcessor(param1:Stage)
      {
         super();
         _root = _stage = param1;
         _elapsedTime = 0;
         _currentTouches = new Vector.<Touch>(0);
         _queue = new Vector.<Array>(0);
         _lastTaps = new Vector.<Touch>(0);
         _touchEvent = new TouchEvent("touch");
         _stage.addEventListener("keyDown",onKey);
         _stage.addEventListener("keyUp",onKey);
         monitorInterruptions(true);
      }
      
      public function dispose() : void
      {
         monitorInterruptions(false);
         _stage.removeEventListener("keyDown",onKey);
         _stage.removeEventListener("keyUp",onKey);
         if(_touchMarker)
         {
            _touchMarker.dispose();
         }
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Touch = null;
         var _loc4_:Array = null;
         _elapsedTime += param1;
         sUpdatedTouches.length = 0;
         if(_lastTaps.length > 0)
         {
            _loc2_ = _lastTaps.length - 1;
            while(_loc2_ >= 0)
            {
               if(_elapsedTime - _lastTaps[_loc2_].timestamp > _multitapTime)
               {
                  _lastTaps.removeAt(_loc2_);
               }
               _loc2_--;
            }
         }
         while(_queue.length > 0)
         {
            for each(_loc3_ in _currentTouches)
            {
               if(_loc3_.phase == "began" || _loc3_.phase == "moved")
               {
                  _loc3_.phase = "stationary";
               }
            }
            while(_queue.length > 0 && !containsTouchWithID(sUpdatedTouches,_queue[_queue.length - 1][0]))
            {
               _loc4_ = _queue.pop();
               _loc3_ = createOrUpdateTouch(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5],_loc4_[6]);
               sUpdatedTouches[sUpdatedTouches.length] = _loc3_;
            }
            processTouches(sUpdatedTouches,_shiftDown,_ctrlDown);
            _loc2_ = _currentTouches.length - 1;
            while(_loc2_ >= 0)
            {
               if(_currentTouches[_loc2_].phase == "ended")
               {
                  _currentTouches.removeAt(_loc2_);
               }
               _loc2_--;
            }
            sUpdatedTouches.length = 0;
         }
      }
      
      protected function processTouches(param1:Vector.<Touch>, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:* = null;
         sHoveringTouchData.length = 0;
         _touchEvent.resetTo("touch",_currentTouches,param2,param3);
         for each(_loc4_ in param1)
         {
            if(_loc4_.phase == "hover" && _loc4_.target)
            {
               sHoveringTouchData[sHoveringTouchData.length] = {
                  "touch":_loc4_,
                  "target":_loc4_.target,
                  "bubbleChain":_loc4_.bubbleChain
               };
            }
            if(_loc4_.phase == "hover" || _loc4_.phase == "began")
            {
               sHelperPoint.setTo(_loc4_.globalX,_loc4_.globalY);
               _loc4_.target = _root.hitTest(sHelperPoint);
            }
         }
         for each(var _loc5_ in sHoveringTouchData)
         {
            if(_loc5_.touch.target != _loc5_.target)
            {
               _touchEvent.dispatch(_loc5_.bubbleChain);
            }
         }
         for each(_loc4_ in param1)
         {
            _loc4_.dispatchEvent(_touchEvent);
         }
         _touchEvent.resetTo("touch");
      }
      
      public function enqueue(param1:int, param2:String, param3:Number, param4:Number, param5:Number = 1, param6:Number = 1, param7:Number = 1) : void
      {
         _queue.unshift(arguments);
         if(_ctrlDown && _touchMarker && param1 == 0)
         {
            _touchMarker.moveMarker(param3,param4,_shiftDown);
            _queue.unshift([1,param2,_touchMarker.mockX,_touchMarker.mockY]);
         }
      }
      
      public function enqueueMouseLeftStage() : void
      {
         var _loc1_:Touch = getCurrentTouch(0);
         if(_loc1_ == null || _loc1_.phase != "hover")
         {
            return;
         }
         var _loc2_:int = 1;
         var _loc8_:Number = _loc1_.globalX;
         var _loc6_:Number = _loc1_.globalY;
         var _loc4_:Number = _loc1_.globalX;
         var _loc7_:Number = _stage.stageWidth - _loc4_;
         var _loc3_:Number = _loc1_.globalY;
         var _loc9_:Number = _stage.stageHeight - _loc3_;
         var _loc5_:Number;
         if((_loc5_ = Math.min(_loc4_,_loc7_,_loc3_,_loc9_)) == _loc4_)
         {
            _loc8_ = -_loc2_;
         }
         else if(_loc5_ == _loc7_)
         {
            _loc8_ = _stage.stageWidth + _loc2_;
         }
         else if(_loc5_ == _loc3_)
         {
            _loc6_ = -_loc2_;
         }
         else
         {
            _loc6_ = _stage.stageHeight + _loc2_;
         }
         enqueue(0,"hover",_loc8_,_loc6_);
      }
      
      public function cancelTouches() : void
      {
         if(_currentTouches.length > 0)
         {
            for each(var _loc1_ in _currentTouches)
            {
               if(_loc1_.phase == "began" || _loc1_.phase == "moved" || _loc1_.phase == "stationary")
               {
                  _loc1_.phase = "ended";
                  _loc1_.cancelled = true;
               }
            }
            processTouches(_currentTouches,_shiftDown,_ctrlDown);
         }
         _currentTouches.length = 0;
         _queue.length = 0;
      }
      
      private function createOrUpdateTouch(param1:int, param2:String, param3:Number, param4:Number, param5:Number = 1, param6:Number = 1, param7:Number = 1) : Touch
      {
         var _loc8_:Touch;
         if((_loc8_ = getCurrentTouch(param1)) == null)
         {
            _loc8_ = new Touch(param1);
            addCurrentTouch(_loc8_);
         }
         _loc8_.globalX = param3;
         _loc8_.globalY = param4;
         _loc8_.phase = param2;
         _loc8_.timestamp = _elapsedTime;
         _loc8_.pressure = param5;
         _loc8_.width = param6;
         _loc8_.height = param7;
         if(param2 == "began")
         {
            updateTapCount(_loc8_);
         }
         return _loc8_;
      }
      
      private function updateTapCount(param1:Touch) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:* = null;
         var _loc2_:Number = _multitapDistance * _multitapDistance;
         for each(var _loc3_ in _lastTaps)
         {
            if((_loc4_ = Math.pow(_loc3_.globalX - param1.globalX,2) + Math.pow(_loc3_.globalY - param1.globalY,2)) <= _loc2_)
            {
               _loc5_ = _loc3_;
               break;
            }
         }
         if(_loc5_)
         {
            param1.tapCount = _loc5_.tapCount + 1;
            _lastTaps.removeAt(_lastTaps.indexOf(_loc5_));
         }
         else
         {
            param1.tapCount = 1;
         }
         _lastTaps[_lastTaps.length] = param1.clone();
      }
      
      private function addCurrentTouch(param1:Touch) : void
      {
         var _loc2_:int = 0;
         _loc2_ = _currentTouches.length - 1;
         while(_loc2_ >= 0)
         {
            if(_currentTouches[_loc2_].id == param1.id)
            {
               _currentTouches.removeAt(_loc2_);
            }
            _loc2_--;
         }
         _currentTouches[_currentTouches.length] = param1;
      }
      
      private function getCurrentTouch(param1:int) : Touch
      {
         for each(var _loc2_ in _currentTouches)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function containsTouchWithID(param1:Vector.<Touch>, param2:int) : Boolean
      {
         for each(var _loc3_ in param1)
         {
            if(_loc3_.id == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get simulateMultitouch() : Boolean
      {
         return _simulateMultitouch;
      }
      
      public function set simulateMultitouch(param1:Boolean) : void
      {
         var target:Starling;
         var value:Boolean = param1;
         var createTouchMarker:* = function():void
         {
            target.removeEventListener("context3DCreate",createTouchMarker);
            if(_touchMarker == null)
            {
               _touchMarker = new TouchMarker();
               _touchMarker.visible = false;
               _stage.addChild(_touchMarker);
            }
         };
         if(simulateMultitouch == value)
         {
            return;
         }
         _simulateMultitouch = value;
         target = Starling.current;
         if(value && _touchMarker == null)
         {
            if(Starling.current.contextValid)
            {
               createTouchMarker();
            }
            else
            {
               target.addEventListener("context3DCreate",createTouchMarker);
            }
         }
         else if(!value && _touchMarker)
         {
            _touchMarker.removeFromParent(true);
            _touchMarker = null;
         }
      }
      
      public function get multitapTime() : Number
      {
         return _multitapTime;
      }
      
      public function set multitapTime(param1:Number) : void
      {
         _multitapTime = param1;
      }
      
      public function get multitapDistance() : Number
      {
         return _multitapDistance;
      }
      
      public function set multitapDistance(param1:Number) : void
      {
         _multitapDistance = param1;
      }
      
      public function get root() : DisplayObject
      {
         return _root;
      }
      
      public function set root(param1:DisplayObject) : void
      {
         _root = param1;
      }
      
      public function get stage() : Stage
      {
         return _stage;
      }
      
      public function get numCurrentTouches() : int
      {
         return _currentTouches.length;
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc4_:Touch = null;
         var _loc3_:Touch = null;
         if(param1.keyCode == 17 || param1.keyCode == 15)
         {
            _loc2_ = _ctrlDown;
            _ctrlDown = param1.type == "keyDown";
            if(_touchMarker && _loc2_ != _ctrlDown)
            {
               _touchMarker.visible = _ctrlDown;
               _touchMarker.moveCenter(_stage.stageWidth / 2,_stage.stageHeight / 2);
               _loc4_ = getCurrentTouch(0);
               _loc3_ = getCurrentTouch(1);
               if(_loc4_)
               {
                  _touchMarker.moveMarker(_loc4_.globalX,_loc4_.globalY);
               }
               if(_loc2_ && _loc3_ && _loc3_.phase != "ended")
               {
                  _queue.unshift([1,"ended",_loc3_.globalX,_loc3_.globalY]);
               }
               else if(_ctrlDown && _loc4_)
               {
                  if(_loc4_.phase == "hover" || _loc4_.phase == "ended")
                  {
                     _queue.unshift([1,"hover",_touchMarker.mockX,_touchMarker.mockY]);
                  }
                  else
                  {
                     _queue.unshift([1,"began",_touchMarker.mockX,_touchMarker.mockY]);
                  }
               }
            }
         }
         else if(param1.keyCode == 16)
         {
            _shiftDown = param1.type == "keyDown";
         }
      }
      
      private function monitorInterruptions(param1:Boolean) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Object = null;
         try
         {
            _loc3_ = getDefinitionByName("flash.desktop::NativeApplication");
            _loc2_ = _loc3_["nativeApplication"];
            if(param1)
            {
               _loc2_.addEventListener("deactivate",onInterruption,false,0,true);
            }
            else
            {
               _loc2_.removeEventListener("deactivate",onInterruption);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onInterruption(param1:Object) : void
      {
         cancelTouches();
      }
   }
}
