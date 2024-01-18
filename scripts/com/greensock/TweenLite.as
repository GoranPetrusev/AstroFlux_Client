package com.greensock
{
   import com.greensock.core.Animation;
   import com.greensock.core.PropTween;
   import com.greensock.core.SimpleTimeline;
   import com.greensock.easing.Ease;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class TweenLite extends Animation
   {
      
      public static const version:String = "12.1.4";
      
      public static var defaultEase:Ease = new Ease(null,null,1,1);
      
      public static var defaultOverwrite:String = "auto";
      
      public static var ticker:Shape = Animation.ticker;
      
      public static var _plugins:Object = {};
      
      public static var _onPluginEvent:Function;
      
      protected static var _tweenLookup:Dictionary = new Dictionary(false);
      
      protected static var _reservedProps:Object = {
         "ease":1,
         "delay":1,
         "overwrite":1,
         "onComplete":1,
         "onCompleteParams":1,
         "onCompleteScope":1,
         "useFrames":1,
         "runBackwards":1,
         "startAt":1,
         "onUpdate":1,
         "onUpdateParams":1,
         "onUpdateScope":1,
         "onStart":1,
         "onStartParams":1,
         "onStartScope":1,
         "onReverseComplete":1,
         "onReverseCompleteParams":1,
         "onReverseCompleteScope":1,
         "onRepeat":1,
         "onRepeatParams":1,
         "onRepeatScope":1,
         "easeParams":1,
         "yoyo":1,
         "onCompleteListener":1,
         "onUpdateListener":1,
         "onStartListener":1,
         "onReverseCompleteListener":1,
         "onRepeatListener":1,
         "orientToBezier":1,
         "immediateRender":1,
         "repeat":1,
         "repeatDelay":1,
         "data":1,
         "paused":1,
         "reversed":1
      };
      
      protected static var _overwriteLookup:Object;
       
      
      public var target:Object;
      
      public var ratio:Number;
      
      public var _propLookup:Object;
      
      public var _firstPT:PropTween;
      
      protected var _targets:Array;
      
      public var _ease:Ease;
      
      protected var _easeType:int;
      
      protected var _easePower:int;
      
      protected var _siblings:Array;
      
      protected var _overwrite:int;
      
      protected var _overwrittenProps:Object;
      
      protected var _notifyPluginsOfEnabled:Boolean;
      
      protected var _startAt:TweenLite;
      
      public function TweenLite(param1:Object, param2:Number, param3:Object)
      {
         var _loc4_:int = 0;
         super(param2,param3);
         if(param1 == null)
         {
            throw new Error("Cannot tween a null object. Duration: " + param2 + ", data: " + this.data);
         }
         if(!_overwriteLookup)
         {
            _overwriteLookup = {
               "none":0,
               "all":1,
               "auto":2,
               "concurrent":3,
               "allOnStart":4,
               "preexisting":5,
               "true":1,
               "false":0
            };
            ticker.addEventListener("enterFrame",_dumpGarbage,false,-1,true);
         }
         ratio = 0;
         this.target = param1;
         _ease = defaultEase;
         _overwrite = !("overwrite" in this.vars) ? _overwriteLookup[defaultOverwrite] : (typeof this.vars.overwrite === "number" ? this.vars.overwrite >> 0 : _overwriteLookup[this.vars.overwrite]);
         if(this.target is Array && typeof this.target[0] === "object")
         {
            _targets = this.target.concat();
            _propLookup = [];
            _siblings = [];
            _loc4_ = int(_targets.length);
            while(true)
            {
               _loc4_--;
               if(_loc4_ <= -1)
               {
                  break;
               }
               _siblings[_loc4_] = _register(_targets[_loc4_],this,false);
               if(_overwrite == 1)
               {
                  if(_siblings[_loc4_].length > 1)
                  {
                     _applyOverwrite(_targets[_loc4_],this,null,1,_siblings[_loc4_]);
                  }
               }
            }
         }
         else
         {
            _propLookup = {};
            _siblings = _tweenLookup[param1];
            if(_siblings == null)
            {
               _siblings = _tweenLookup[param1] = [this];
            }
            else
            {
               _siblings[_siblings.length] = this;
               if(_overwrite == 1)
               {
                  _applyOverwrite(param1,this,null,1,_siblings);
               }
            }
         }
         if(this.vars.immediateRender || param2 == 0 && _delay == 0 && this.vars.immediateRender != false)
         {
            render(-_delay,false,true);
         }
      }
      
      public static function to(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         return new TweenLite(param1,param2,param3);
      }
      
      public static function from(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         param3 = _prepVars(param3,true);
         param3.runBackwards = true;
         return new TweenLite(param1,param2,param3);
      }
      
      public static function fromTo(param1:Object, param2:Number, param3:Object, param4:Object) : TweenLite
      {
         param4 = _prepVars(param4,true);
         param3 = _prepVars(param3);
         param4.startAt = param3;
         param4.immediateRender = param4.immediateRender != false && param3.immediateRender != false;
         return new TweenLite(param1,param2,param4);
      }
      
      protected static function _prepVars(param1:Object, param2:Boolean = false) : Object
      {
         if(param1._isGSVars)
         {
            param1 = param1.vars;
         }
         if(param2 && !("immediateRender" in param1))
         {
            param1.immediateRender = true;
         }
         return param1;
      }
      
      public static function delayedCall(param1:Number, param2:Function, param3:Array = null, param4:Boolean = false) : TweenLite
      {
         return new TweenLite(param2,0,{
            "delay":param1,
            "onComplete":param2,
            "onCompleteParams":param3,
            "onReverseComplete":param2,
            "onReverseCompleteParams":param3,
            "immediateRender":false,
            "useFrames":param4,
            "overwrite":0
         });
      }
      
      public static function set(param1:Object, param2:Object) : TweenLite
      {
         return new TweenLite(param1,0,param2);
      }
      
      private static function _dumpGarbage(param1:Event) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         if(_rootFrame / 60 >> 0 === _rootFrame / 60)
         {
            for(_loc3_ in _tweenLookup)
            {
               _loc2_ = _tweenLookup[_loc3_];
               _loc4_ = int(_loc2_.length);
               while(true)
               {
                  _loc4_--;
                  if(_loc4_ <= -1)
                  {
                     break;
                  }
                  if(_loc2_[_loc4_]._gc)
                  {
                     _loc2_.splice(_loc4_,1);
                  }
               }
               if(_loc2_.length === 0)
               {
                  delete _tweenLookup[_loc3_];
               }
            }
         }
      }
      
      public static function killTweensOf(param1:*, param2:* = false, param3:Object = null) : void
      {
         var _loc4_:Array = null;
         if(typeof param2 === "object")
         {
            param3 = param2;
            param2 = false;
         }
         var _loc5_:int = int((_loc4_ = TweenLite.getTweensOf(param1,param2)).length);
         while(true)
         {
            _loc5_--;
            if(_loc5_ <= -1)
            {
               break;
            }
            _loc4_[_loc5_]._kill(param3,param1);
         }
      }
      
      public static function killDelayedCallsTo(param1:Function) : void
      {
         killTweensOf(param1);
      }
      
      public static function getTweensOf(param1:*, param2:Boolean = false) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc3_:TweenLite = null;
         var _loc6_:int = 0;
         if(param1 is Array && typeof param1[0] != "string" && typeof param1[0] != "number")
         {
            _loc6_ = int(param1.length);
            _loc4_ = [];
            while(true)
            {
               _loc6_--;
               if(_loc6_ <= -1)
               {
                  break;
               }
               _loc4_ = _loc4_.concat(getTweensOf(param1[_loc6_],param2));
            }
            _loc6_ = int(_loc4_.length);
            while(true)
            {
               _loc6_--;
               if(_loc6_ <= -1)
               {
                  break;
               }
               _loc3_ = _loc4_[_loc6_];
               _loc5_ = _loc6_;
               while(true)
               {
                  _loc5_--;
                  if(_loc5_ <= -1)
                  {
                     break;
                  }
                  if(_loc3_ === _loc4_[_loc5_])
                  {
                     _loc4_.splice(_loc6_,1);
                  }
               }
            }
         }
         else
         {
            _loc6_ = int((_loc4_ = _register(param1).concat()).length);
            while(true)
            {
               _loc6_--;
               if(_loc6_ <= -1)
               {
                  break;
               }
               if(_loc4_[_loc6_]._gc || param2 && !_loc4_[_loc6_].isActive())
               {
                  _loc4_.splice(_loc6_,1);
               }
            }
         }
         return _loc4_;
      }
      
      protected static function _register(param1:Object, param2:TweenLite = null, param3:Boolean = false) : Array
      {
         var _loc5_:int = 0;
         var _loc4_:Array;
         if((_loc4_ = _tweenLookup[param1]) == null)
         {
            _loc4_ = _tweenLookup[param1] = [];
         }
         if(param2)
         {
            _loc5_ = int(_loc4_.length);
            _loc4_[_loc5_] = param2;
            if(param3)
            {
               while(true)
               {
                  _loc5_--;
                  if(_loc5_ <= -1)
                  {
                     break;
                  }
                  if(_loc4_[_loc5_] === param2)
                  {
                     _loc4_.splice(_loc5_,1);
                  }
               }
            }
         }
         return _loc4_;
      }
      
      protected static function _applyOverwrite(param1:Object, param2:TweenLite, param3:Object, param4:int, param5:Array) : Boolean
      {
         var _loc9_:Boolean = false;
         var _loc13_:TweenLite = null;
         var _loc10_:* = 0;
         var _loc7_:int = 0;
         var _loc6_:Number = NaN;
         if(param4 == 1 || param4 >= 4)
         {
            _loc7_ = int(param5.length);
            _loc10_ = 0;
            while(_loc10_ < _loc7_)
            {
               if((_loc13_ = param5[_loc10_]) != param2)
               {
                  if(!_loc13_._gc)
                  {
                     if(_loc13_._enabled(false,false))
                     {
                        _loc9_ = true;
                     }
                  }
               }
               else if(param4 == 5)
               {
                  break;
               }
               _loc10_++;
            }
            return _loc9_;
         }
         var _loc11_:Number = param2._startTime + 1e-10;
         var _loc12_:Array = [];
         var _loc8_:int = 0;
         var _loc14_:* = param2._duration == 0;
         _loc10_ = int(param5.length);
         while(true)
         {
            _loc10_--;
            if(_loc10_ <= -1)
            {
               break;
            }
            if(!((_loc13_ = param5[_loc10_]) === param2 || _loc13_._gc || _loc13_._paused))
            {
               if(_loc13_._timeline != param2._timeline)
               {
                  _loc6_ ||= _checkOverlap(param2,0,_loc14_);
                  if(_checkOverlap(_loc13_,_loc6_,_loc14_) === 0)
                  {
                     _loc12_[_loc8_++] = _loc13_;
                  }
               }
               else if(_loc13_._startTime <= _loc11_)
               {
                  if(_loc13_._startTime + _loc13_.totalDuration() / _loc13_._timeScale > _loc11_)
                  {
                     if(!((_loc14_ || !_loc13_._initted) && _loc11_ - _loc13_._startTime <= 2e-10))
                     {
                        _loc12_[_loc8_++] = _loc13_;
                     }
                  }
               }
            }
         }
         _loc10_ = _loc8_;
         while(true)
         {
            _loc10_--;
            if(_loc10_ <= -1)
            {
               break;
            }
            _loc13_ = _loc12_[_loc10_];
            if(param4 == 2)
            {
               if(_loc13_._kill(param3,param1))
               {
                  _loc9_ = true;
               }
            }
            if(param4 !== 2 || !_loc13_._firstPT && _loc13_._initted)
            {
               if(_loc13_._enabled(false,false))
               {
                  _loc9_ = true;
               }
            }
         }
         return _loc9_;
      }
      
      private static function _checkOverlap(param1:Animation, param2:Number, param3:Boolean) : Number
      {
         var _loc6_:SimpleTimeline = null;
         var _loc7_:Number = (_loc6_ = param1._timeline)._timeScale;
         var _loc5_:Number = param1._startTime;
         var _loc4_:Number = 1e-10;
         while(_loc6_._timeline)
         {
            _loc5_ += _loc6_._startTime;
            _loc7_ *= _loc6_._timeScale;
            if(_loc6_._paused)
            {
               return -100;
            }
            _loc6_ = _loc6_._timeline;
         }
         return (_loc5_ /= _loc7_) > param2 ? _loc5_ - param2 : (param3 && _loc5_ == param2 || !param1._initted && _loc5_ - param2 < 2 * _loc4_ ? _loc4_ : ((_loc5_ += param1.totalDuration() / param1._timeScale / _loc7_) > param2 + _loc4_ ? 0 : _loc5_ - param2 - _loc4_));
      }
      
      protected function _init() : void
      {
         var _loc6_:int = 0;
         var _loc2_:Boolean = false;
         var _loc4_:PropTween = null;
         var _loc3_:String = null;
         var _loc5_:Object = null;
         var _loc1_:Boolean = Boolean(vars.immediateRender);
         if(vars.startAt)
         {
            if(_startAt != null)
            {
               _startAt.render(-1,true);
            }
            vars.startAt.overwrite = 0;
            vars.startAt.immediateRender = true;
            _startAt = new TweenLite(target,0,vars.startAt);
            if(_loc1_)
            {
               if(_time > 0)
               {
                  _startAt = null;
               }
               else if(_duration !== 0)
               {
                  return;
               }
            }
         }
         else if(vars.runBackwards && _duration !== 0)
         {
            if(_startAt != null)
            {
               _startAt.render(-1,true);
               _startAt = null;
            }
            else
            {
               _loc5_ = {};
               for(_loc3_ in vars)
               {
                  if(!(_loc3_ in _reservedProps))
                  {
                     _loc5_[_loc3_] = vars[_loc3_];
                  }
               }
               _loc5_.overwrite = 0;
               _loc5_.data = "isFromStart";
               _startAt = TweenLite.to(target,0,_loc5_);
               if(!_loc1_)
               {
                  _startAt.render(-1,true);
               }
               else if(_time === 0)
               {
                  return;
               }
            }
         }
         if(vars.ease is Ease)
         {
            _ease = vars.easeParams is Array ? vars.ease.config.apply(vars.ease,vars.easeParams) : vars.ease;
         }
         else if(typeof vars.ease === "function")
         {
            _ease = new Ease(vars.ease,vars.easeParams);
         }
         else
         {
            _ease = defaultEase;
         }
         _easeType = _ease._type;
         _easePower = _ease._power;
         _firstPT = null;
         if(_targets)
         {
            _loc6_ = int(_targets.length);
            while(true)
            {
               _loc6_--;
               if(_loc6_ <= -1)
               {
                  break;
               }
               if(_initProps(_targets[_loc6_],_propLookup[_loc6_] = {},_siblings[_loc6_],!!_overwrittenProps ? _overwrittenProps[_loc6_] : null))
               {
                  _loc2_ = true;
               }
            }
         }
         else
         {
            _loc2_ = _initProps(target,_propLookup,_siblings,_overwrittenProps);
         }
         if(_loc2_)
         {
            _onPluginEvent("_onInitAllProps",this);
         }
         if(_overwrittenProps)
         {
            if(_firstPT == null)
            {
               if(typeof target !== "function")
               {
                  _enabled(false,false);
               }
            }
         }
         if(vars.runBackwards)
         {
            _loc4_ = _firstPT;
            while(_loc4_)
            {
               _loc4_.s += _loc4_.c;
               _loc4_.c = -_loc4_.c;
               _loc4_ = _loc4_._next;
            }
         }
         _onUpdate = vars.onUpdate;
         _initted = true;
      }
      
      protected function _initProps(param1:Object, param2:Object, param3:Array, param4:Object) : Boolean
      {
         var _loc8_:String = null;
         var _loc10_:int = 0;
         var _loc7_:Boolean = false;
         var _loc9_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = this.vars;
         if(param1 == null)
         {
            return false;
         }
         for(_loc8_ in _loc6_)
         {
            _loc5_ = _loc6_[_loc8_];
            if(_loc8_ in _reservedProps)
            {
               if(_loc5_ is Array)
               {
                  if(_loc5_.join("").indexOf("{self}") !== -1)
                  {
                     _loc6_[_loc8_] = _swapSelfInParams(_loc5_ as Array);
                  }
               }
            }
            else if(_loc8_ in _plugins && (_loc9_ = new _plugins[_loc8_]())._onInitTween(param1,_loc5_,this))
            {
               _firstPT = new PropTween(_loc9_,"setRatio",0,1,_loc8_,true,_firstPT,_loc9_._priority);
               _loc10_ = int(_loc9_._overwriteProps.length);
               while(true)
               {
                  _loc10_--;
                  if(_loc10_ <= -1)
                  {
                     break;
                  }
                  param2[_loc9_._overwriteProps[_loc10_]] = _firstPT;
               }
               if(_loc9_._priority || "_onInitAllProps" in _loc9_)
               {
                  _loc7_ = true;
               }
               if("_onDisable" in _loc9_ || "_onEnable" in _loc9_)
               {
                  _notifyPluginsOfEnabled = true;
               }
            }
            else
            {
               _firstPT = param2[_loc8_] = new PropTween(param1,_loc8_,0,1,_loc8_,false,_firstPT);
               _firstPT.s = !_firstPT.f ? Number(param1[_loc8_]) : param1[_loc8_.indexOf("set") || !("get" + _loc8_.substr(3) in param1) ? _loc8_ : "get" + _loc8_.substr(3)]();
               _firstPT.c = typeof _loc5_ === "number" ? Number(_loc5_) - _firstPT.s : (typeof _loc5_ === "string" && _loc5_.charAt(1) === "=" ? (int(_loc5_.charAt(0) + "1")) * Number(_loc5_.substr(2)) : Number(Number(_loc5_) || 0));
            }
         }
         if(param4)
         {
            if(_kill(param4,param1))
            {
               return _initProps(param1,param2,param3,param4);
            }
         }
         if(_overwrite > 1)
         {
            if(_firstPT != null)
            {
               if(param3.length > 1)
               {
                  if(_applyOverwrite(param1,this,param2,_overwrite,param3))
                  {
                     _kill(param2,param1);
                     return _initProps(param1,param2,param3,param4);
                  }
               }
            }
         }
         return _loc7_;
      }
      
      override public function render(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc7_:String = null;
         var _loc6_:PropTween = null;
         var _loc8_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc9_:Number = _time;
         if(param1 >= _duration)
         {
            _totalTime = _time = _duration;
            ratio = _ease._calcEnd ? _ease.getRatio(1) : 1;
            if(!_reversed)
            {
               _loc4_ = true;
               _loc7_ = "onComplete";
            }
            if(_duration == 0)
            {
               _loc8_ = _rawPrevTime;
               if(_startTime === _timeline._duration)
               {
                  param1 = 0;
               }
               if(param1 === 0 || _loc8_ < 0 || _loc8_ === _tinyNum)
               {
                  if(_loc8_ !== param1)
                  {
                     param3 = true;
                     if(_loc8_ > 0 && _loc8_ !== _tinyNum)
                     {
                        _loc7_ = "onReverseComplete";
                     }
                  }
               }
               _rawPrevTime = _loc8_ = !param2 || param1 !== 0 || _rawPrevTime === param1 ? param1 : _tinyNum;
            }
         }
         else if(param1 < 1e-7)
         {
            _totalTime = _time = 0;
            ratio = _ease._calcEnd ? _ease.getRatio(0) : 0;
            if(_loc9_ !== 0 || _duration === 0 && _rawPrevTime > 0 && _rawPrevTime !== _tinyNum)
            {
               _loc7_ = "onReverseComplete";
               _loc4_ = _reversed;
            }
            if(param1 < 0)
            {
               _active = false;
               if(_duration == 0)
               {
                  if(_rawPrevTime >= 0)
                  {
                     param3 = true;
                  }
                  _rawPrevTime = _loc8_ = !param2 || param1 !== 0 || _rawPrevTime === param1 ? param1 : _tinyNum;
               }
            }
            else if(!_initted)
            {
               param3 = true;
            }
         }
         else
         {
            _totalTime = _time = param1;
            if(_easeType)
            {
               _loc5_ = param1 / _duration;
               if(_easeType == 1 || _easeType == 3 && _loc5_ >= 0.5)
               {
                  _loc5_ = 1 - _loc5_;
               }
               if(_easeType == 3)
               {
                  _loc5_ *= 2;
               }
               if(_easePower == 1)
               {
                  _loc5_ *= _loc5_;
               }
               else if(_easePower == 2)
               {
                  _loc5_ *= _loc5_ * _loc5_;
               }
               else if(_easePower == 3)
               {
                  _loc5_ *= _loc5_ * _loc5_ * _loc5_;
               }
               else if(_easePower == 4)
               {
                  _loc5_ *= _loc5_ * _loc5_ * _loc5_ * _loc5_;
               }
               if(_easeType == 1)
               {
                  ratio = 1 - _loc5_;
               }
               else if(_easeType == 2)
               {
                  ratio = _loc5_;
               }
               else if(param1 / _duration < 0.5)
               {
                  ratio = _loc5_ / 2;
               }
               else
               {
                  ratio = 1 - _loc5_ / 2;
               }
            }
            else
            {
               ratio = _ease.getRatio(param1 / _duration);
            }
         }
         if(_time == _loc9_ && !param3)
         {
            return;
         }
         if(!_initted)
         {
            _init();
            if(!_initted || _gc)
            {
               return;
            }
            if(_time && !_loc4_)
            {
               ratio = _ease.getRatio(_time / _duration);
            }
            else if(_loc4_ && _ease._calcEnd)
            {
               ratio = _ease.getRatio(_time === 0 ? 0 : 1);
            }
         }
         if(!_active)
         {
            if(!_paused && _time !== _loc9_ && param1 >= 0)
            {
               _active = true;
            }
         }
         if(_loc9_ == 0)
         {
            if(_startAt != null)
            {
               if(param1 >= 0)
               {
                  _startAt.render(param1,param2,param3);
               }
               else if(!_loc7_)
               {
                  _loc7_ = "_dummyGS";
               }
            }
            if(vars.onStart)
            {
               if(_time != 0 || _duration == 0)
               {
                  if(!param2)
                  {
                     vars.onStart.apply(null,vars.onStartParams);
                  }
               }
            }
         }
         _loc6_ = _firstPT;
         while(_loc6_)
         {
            if(_loc6_.f)
            {
               _loc6_.t[_loc6_.p](_loc6_.c * ratio + _loc6_.s);
            }
            else
            {
               _loc6_.t[_loc6_.p] = _loc6_.c * ratio + _loc6_.s;
            }
            _loc6_ = _loc6_._next;
         }
         if(_onUpdate != null)
         {
            if(param1 < 0 && _startAt != null && _startTime != 0)
            {
               _startAt.render(param1,param2,param3);
            }
            if(!param2)
            {
               if(_time !== _loc9_ || _loc4_)
               {
                  _onUpdate.apply(null,vars.onUpdateParams);
               }
            }
         }
         if(_loc7_)
         {
            if(!_gc)
            {
               if(param1 < 0 && _startAt != null && _onUpdate == null && _startTime != 0)
               {
                  _startAt.render(param1,param2,param3);
               }
               if(_loc4_)
               {
                  if(_timeline.autoRemoveChildren)
                  {
                     _enabled(false,false);
                  }
                  _active = false;
               }
               if(!param2)
               {
                  if(vars[_loc7_])
                  {
                     vars[_loc7_].apply(null,vars[_loc7_ + "Params"]);
                  }
               }
               if(_duration === 0 && _rawPrevTime === _tinyNum && _loc8_ !== _tinyNum)
               {
                  _rawPrevTime = 0;
               }
            }
         }
      }
      
      override public function _kill(param1:Object = null, param2:Object = null) : Boolean
      {
         var _loc10_:Object = null;
         var _loc6_:String = null;
         var _loc7_:PropTween = null;
         var _loc5_:Object = null;
         var _loc9_:Boolean = false;
         var _loc4_:Object = null;
         var _loc3_:Boolean = false;
         var _loc8_:int = 0;
         if(param1 === "all")
         {
            param1 = null;
         }
         if(param1 == null)
         {
            if(param2 == null || param2 == this.target)
            {
               return _enabled(false,false);
            }
         }
         param2 = param2 || _targets || this.target;
         if(param2 is Array && typeof param2[0] === "object")
         {
            _loc8_ = int(param2.length);
            while(true)
            {
               _loc8_--;
               if(_loc8_ <= -1)
               {
                  break;
               }
               if(_kill(param1,param2[_loc8_]))
               {
                  _loc9_ = true;
               }
            }
         }
         else
         {
            if(_targets)
            {
               _loc8_ = int(_targets.length);
               while(true)
               {
                  _loc8_--;
                  if(_loc8_ <= -1)
                  {
                     break;
                  }
                  if(param2 === _targets[_loc8_])
                  {
                     _loc5_ = _propLookup[_loc8_] || {};
                     _overwrittenProps ||= [];
                     _loc10_ = _overwrittenProps[_loc8_] = !!param1 ? _overwrittenProps[_loc8_] || {} : "all";
                     break;
                  }
               }
            }
            else
            {
               if(param2 !== this.target)
               {
                  return false;
               }
               _loc5_ = _propLookup;
               _loc10_ = _overwrittenProps = !!param1 ? _overwrittenProps || {} : "all";
            }
            if(_loc5_)
            {
               _loc4_ = param1 || _loc5_;
               _loc3_ = param1 != _loc10_ && _loc10_ != "all" && param1 != _loc5_ && (typeof param1 != "object" || param1._tempKill != true);
               for(_loc6_ in _loc4_)
               {
                  if((_loc7_ = _loc5_[_loc6_]) != null)
                  {
                     if(_loc7_.pg && _loc7_.t._kill(_loc4_))
                     {
                        _loc9_ = true;
                     }
                     if(!_loc7_.pg || _loc7_.t._overwriteProps.length === 0)
                     {
                        if(_loc7_._prev)
                        {
                           _loc7_._prev._next = _loc7_._next;
                        }
                        else if(_loc7_ == _firstPT)
                        {
                           _firstPT = _loc7_._next;
                        }
                        if(_loc7_._next)
                        {
                           _loc7_._next._prev = _loc7_._prev;
                        }
                        _loc7_._next = _loc7_._prev = null;
                     }
                     delete _loc5_[_loc6_];
                  }
                  if(_loc3_)
                  {
                     _loc10_[_loc6_] = 1;
                  }
               }
               if(_firstPT == null && _initted)
               {
                  _enabled(false,false);
               }
            }
         }
         return _loc9_;
      }
      
      override public function invalidate() : *
      {
         if(_notifyPluginsOfEnabled)
         {
            _onPluginEvent("_onDisable",this);
         }
         _firstPT = null;
         _overwrittenProps = null;
         _onUpdate = null;
         _startAt = null;
         _initted = _active = _notifyPluginsOfEnabled = false;
         _propLookup = !!_targets ? {} : [];
         return this;
      }
      
      override public function _enabled(param1:Boolean, param2:Boolean = false) : Boolean
      {
         var _loc3_:int = 0;
         if(param1 && _gc)
         {
            if(_targets)
            {
               _loc3_ = int(_targets.length);
               while(true)
               {
                  _loc3_--;
                  if(_loc3_ <= -1)
                  {
                     break;
                  }
                  _siblings[_loc3_] = _register(_targets[_loc3_],this,true);
               }
            }
            else
            {
               _siblings = _register(target,this,true);
            }
         }
         super._enabled(param1,param2);
         if(_notifyPluginsOfEnabled)
         {
            if(_firstPT != null)
            {
               return _onPluginEvent(param1 ? "_onEnable" : "_onDisable",this);
            }
         }
         return false;
      }
   }
}
