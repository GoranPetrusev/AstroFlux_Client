package starling.animation
{
   import starling.core.starling_internal;
   import starling.events.EventDispatcher;
   import starling.utils.Color;
   
   use namespace starling_internal;
   
   public class Tween extends EventDispatcher implements IAnimatable
   {
      
      private static const HINT_MARKER:String = "#";
      
      private static var sTweenPool:Vector.<Tween> = new Vector.<Tween>(0);
       
      
      private var _target:Object;
      
      private var _transitionFunc:Function;
      
      private var _transitionName:String;
      
      private var _properties:Vector.<String>;
      
      private var _startValues:Vector.<Number>;
      
      private var _endValues:Vector.<Number>;
      
      private var _updateFuncs:Vector.<Function>;
      
      private var _onStart:Function;
      
      private var _onUpdate:Function;
      
      private var _onRepeat:Function;
      
      private var _onComplete:Function;
      
      private var _onStartArgs:Array;
      
      private var _onUpdateArgs:Array;
      
      private var _onRepeatArgs:Array;
      
      private var _onCompleteArgs:Array;
      
      private var _totalTime:Number;
      
      private var _currentTime:Number;
      
      private var _progress:Number;
      
      private var _delay:Number;
      
      private var _roundToInt:Boolean;
      
      private var _nextTween:Tween;
      
      private var _repeatCount:int;
      
      private var _repeatDelay:Number;
      
      private var _reverse:Boolean;
      
      private var _currentCycle:int;
      
      public function Tween(param1:Object, param2:Number, param3:Object = "linear")
      {
         super();
         reset(param1,param2,param3);
      }
      
      internal static function getPropertyHint(param1:String) : String
      {
         if(param1.indexOf("color") != -1 || param1.indexOf("Color") != -1)
         {
            return "rgb";
         }
         var _loc2_:int = param1.indexOf("#");
         if(_loc2_ != -1)
         {
            return param1.substr(_loc2_ + 1);
         }
         return null;
      }
      
      internal static function getPropertyName(param1:String) : String
      {
         var _loc2_:int = param1.indexOf("#");
         if(_loc2_ != -1)
         {
            return param1.substring(0,_loc2_);
         }
         return param1;
      }
      
      starling_internal static function fromPool(param1:Object, param2:Number, param3:Object = "linear") : Tween
      {
         if(sTweenPool.length)
         {
            return sTweenPool.pop().reset(param1,param2,param3);
         }
         return new Tween(param1,param2,param3);
      }
      
      starling_internal static function toPool(param1:Tween) : void
      {
         param1._onStart = param1._onUpdate = param1._onRepeat = param1._onComplete = null;
         param1._onStartArgs = param1._onUpdateArgs = param1._onRepeatArgs = param1._onCompleteArgs = null;
         param1._target = null;
         param1._transitionFunc = null;
         param1.removeEventListeners();
         sTweenPool.push(param1);
      }
      
      public function reset(param1:Object, param2:Number, param3:Object = "linear") : Tween
      {
         _target = param1;
         _currentTime = 0;
         _totalTime = Math.max(0.0001,param2);
         _progress = 0;
         _delay = _repeatDelay = 0;
         _onStart = _onUpdate = _onRepeat = _onComplete = null;
         _onStartArgs = _onUpdateArgs = _onRepeatArgs = _onCompleteArgs = null;
         _roundToInt = _reverse = false;
         _repeatCount = 1;
         _currentCycle = -1;
         _nextTween = null;
         if(param3 is String)
         {
            this.transition = param3 as String;
         }
         else
         {
            if(!(param3 is Function))
            {
               throw new ArgumentError("Transition must be either a string or a function");
            }
            this.transitionFunc = param3 as Function;
         }
         if(_properties)
         {
            _properties.length = 0;
         }
         else
         {
            _properties = new Vector.<String>(0);
         }
         if(_startValues)
         {
            _startValues.length = 0;
         }
         else
         {
            _startValues = new Vector.<Number>(0);
         }
         if(_endValues)
         {
            _endValues.length = 0;
         }
         else
         {
            _endValues = new Vector.<Number>(0);
         }
         if(_updateFuncs)
         {
            _updateFuncs.length = 0;
         }
         else
         {
            _updateFuncs = new Vector.<Function>(0);
         }
         return this;
      }
      
      public function animate(param1:String, param2:Number) : void
      {
         if(_target == null)
         {
            return;
         }
         var _loc3_:int = int(_properties.length);
         var _loc4_:Function = getUpdateFuncFromProperty(param1);
         _properties[_loc3_] = getPropertyName(param1);
         _startValues[_loc3_] = NaN;
         _endValues[_loc3_] = param2;
         _updateFuncs[_loc3_] = _loc4_;
      }
      
      public function scaleTo(param1:Number) : void
      {
         animate("scaleX",param1);
         animate("scaleY",param1);
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         animate("x",param1);
         animate("y",param2);
      }
      
      public function fadeTo(param1:Number) : void
      {
         animate("alpha",param1);
      }
      
      public function rotateTo(param1:Number, param2:String = "rad") : void
      {
         animate("rotation#" + param2,param1);
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Function = null;
         var _loc5_:Function = null;
         var _loc8_:Array = null;
         if(param1 == 0 || _repeatCount == 1 && _currentTime == _totalTime)
         {
            return;
         }
         var _loc3_:Number = _currentTime;
         var _loc2_:Number = _totalTime - _currentTime;
         var _loc10_:Number = param1 > _loc2_ ? param1 - _loc2_ : 0;
         _currentTime += param1;
         if(_currentTime <= 0)
         {
            return;
         }
         if(_currentTime > _totalTime)
         {
            _currentTime = _totalTime;
         }
         if(_currentCycle < 0 && _loc3_ <= 0 && _currentTime > 0)
         {
            _currentCycle++;
            if(_onStart != null)
            {
               _onStart.apply(this,_onStartArgs);
            }
         }
         var _loc11_:Number = _currentTime / _totalTime;
         var _loc9_:Boolean = _reverse && _currentCycle % 2 == 1;
         var _loc4_:int = int(_startValues.length);
         _progress = _loc9_ ? _transitionFunc(1 - _loc11_) : _transitionFunc(_loc11_);
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            if(_startValues[_loc6_] != _startValues[_loc6_])
            {
               _startValues[_loc6_] = _target[_properties[_loc6_]] as Number;
            }
            (_loc7_ = _updateFuncs[_loc6_] as Function)(_properties[_loc6_],_startValues[_loc6_],_endValues[_loc6_]);
            _loc6_++;
         }
         if(_onUpdate != null)
         {
            _onUpdate.apply(this,_onUpdateArgs);
         }
         if(_loc3_ < _totalTime && _currentTime >= _totalTime)
         {
            if(_repeatCount == 0 || _repeatCount > 1)
            {
               _currentTime = -_repeatDelay;
               _currentCycle++;
               if(_repeatCount > 1)
               {
                  _repeatCount--;
               }
               if(_onRepeat != null)
               {
                  _onRepeat.apply(this,_onRepeatArgs);
               }
            }
            else
            {
               _loc5_ = _onComplete;
               _loc8_ = _onCompleteArgs;
               dispatchEventWith("removeFromJuggler");
               if(_loc5_ != null)
               {
                  _loc5_.apply(this,_loc8_);
               }
               if(_currentTime == 0)
               {
                  _loc10_ = 0;
               }
            }
         }
         if(_loc10_)
         {
            advanceTime(_loc10_);
         }
      }
      
      private function getUpdateFuncFromProperty(param1:String) : Function
      {
         var _loc3_:Function = null;
         var _loc2_:String = getPropertyHint(param1);
         switch(_loc2_)
         {
            case null:
               _loc3_ = updateStandard;
               break;
            case "rgb":
               _loc3_ = updateRgb;
               break;
            case "rad":
               _loc3_ = updateRad;
               break;
            case "deg":
               _loc3_ = updateDeg;
               break;
            default:
               trace("[Starling] Ignoring unknown property hint:",_loc2_);
               _loc3_ = updateStandard;
         }
         return _loc3_;
      }
      
      private function updateStandard(param1:String, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = param2 + _progress * (param3 - param2);
         if(_roundToInt)
         {
            _loc4_ = Math.round(_loc4_);
         }
         _target[param1] = _loc4_;
      }
      
      private function updateRgb(param1:String, param2:Number, param3:Number) : void
      {
         _target[param1] = Color.interpolate(uint(param2),uint(param3),_progress);
      }
      
      private function updateRad(param1:String, param2:Number, param3:Number) : void
      {
         updateAngle(3.141592653589793,param1,param2,param3);
      }
      
      private function updateDeg(param1:String, param2:Number, param3:Number) : void
      {
         updateAngle(180,param1,param2,param3);
      }
      
      private function updateAngle(param1:Number, param2:String, param3:Number, param4:Number) : void
      {
         while(Math.abs(param4 - param3) > param1)
         {
            if(param3 < param4)
            {
               param4 -= 2 * param1;
            }
            else
            {
               param4 += 2 * param1;
            }
         }
         updateStandard(param2,param3,param4);
      }
      
      public function getEndValue(param1:String) : Number
      {
         var _loc2_:int = _properties.indexOf(param1);
         if(_loc2_ == -1)
         {
            throw new ArgumentError("The property \'" + param1 + "\' is not animated");
         }
         return _endValues[_loc2_] as Number;
      }
      
      public function get isComplete() : Boolean
      {
         return _currentTime >= _totalTime && _repeatCount == 1;
      }
      
      public function get target() : Object
      {
         return _target;
      }
      
      public function get transition() : String
      {
         return _transitionName;
      }
      
      public function set transition(param1:String) : void
      {
         _transitionName = param1;
         _transitionFunc = Transitions.getTransition(param1);
         if(_transitionFunc == null)
         {
            throw new ArgumentError("Invalid transiton: " + param1);
         }
      }
      
      public function get transitionFunc() : Function
      {
         return _transitionFunc;
      }
      
      public function set transitionFunc(param1:Function) : void
      {
         _transitionName = "custom";
         _transitionFunc = param1;
      }
      
      public function get totalTime() : Number
      {
         return _totalTime;
      }
      
      public function get currentTime() : Number
      {
         return _currentTime;
      }
      
      public function get progress() : Number
      {
         return _progress;
      }
      
      public function get delay() : Number
      {
         return _delay;
      }
      
      public function set delay(param1:Number) : void
      {
         _currentTime = _currentTime + _delay - param1;
         _delay = param1;
      }
      
      public function get repeatCount() : int
      {
         return _repeatCount;
      }
      
      public function set repeatCount(param1:int) : void
      {
         _repeatCount = param1;
      }
      
      public function get repeatDelay() : Number
      {
         return _repeatDelay;
      }
      
      public function set repeatDelay(param1:Number) : void
      {
         _repeatDelay = param1;
      }
      
      public function get reverse() : Boolean
      {
         return _reverse;
      }
      
      public function set reverse(param1:Boolean) : void
      {
         _reverse = param1;
      }
      
      public function get roundToInt() : Boolean
      {
         return _roundToInt;
      }
      
      public function set roundToInt(param1:Boolean) : void
      {
         _roundToInt = param1;
      }
      
      public function get onStart() : Function
      {
         return _onStart;
      }
      
      public function set onStart(param1:Function) : void
      {
         _onStart = param1;
      }
      
      public function get onUpdate() : Function
      {
         return _onUpdate;
      }
      
      public function set onUpdate(param1:Function) : void
      {
         _onUpdate = param1;
      }
      
      public function get onRepeat() : Function
      {
         return _onRepeat;
      }
      
      public function set onRepeat(param1:Function) : void
      {
         _onRepeat = param1;
      }
      
      public function get onComplete() : Function
      {
         return _onComplete;
      }
      
      public function set onComplete(param1:Function) : void
      {
         _onComplete = param1;
      }
      
      public function get onStartArgs() : Array
      {
         return _onStartArgs;
      }
      
      public function set onStartArgs(param1:Array) : void
      {
         _onStartArgs = param1;
      }
      
      public function get onUpdateArgs() : Array
      {
         return _onUpdateArgs;
      }
      
      public function set onUpdateArgs(param1:Array) : void
      {
         _onUpdateArgs = param1;
      }
      
      public function get onRepeatArgs() : Array
      {
         return _onRepeatArgs;
      }
      
      public function set onRepeatArgs(param1:Array) : void
      {
         _onRepeatArgs = param1;
      }
      
      public function get onCompleteArgs() : Array
      {
         return _onCompleteArgs;
      }
      
      public function set onCompleteArgs(param1:Array) : void
      {
         _onCompleteArgs = param1;
      }
      
      public function get nextTween() : Tween
      {
         return _nextTween;
      }
      
      public function set nextTween(param1:Tween) : void
      {
         _nextTween = param1;
      }
   }
}
