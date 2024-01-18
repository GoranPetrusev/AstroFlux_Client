package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import com.greensock.core.PropTween;
   
   public class RoundPropsPlugin extends TweenPlugin
   {
      
      public static const API:Number = 2;
       
      
      protected var _tween:TweenLite;
      
      public function RoundPropsPlugin()
      {
         super("roundProps",-1);
         _overwriteProps.length = 0;
      }
      
      override public function _onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         _tween = param3;
         return true;
      }
      
      public function _onInitAllProps() : Boolean
      {
         var _loc5_:String = null;
         var _loc4_:* = null;
         var _loc3_:PropTween = null;
         var _loc2_:Array = null;
         _loc2_ = _tween.vars.roundProps is Array ? _tween.vars.roundProps : _tween.vars.roundProps.split(",");
         var _loc7_:int = int(_loc2_.length);
         var _loc6_:Object = {};
         var _loc1_:PropTween = _tween._propLookup.roundProps;
         while(true)
         {
            _loc7_--;
            if(_loc7_ <= -1)
            {
               break;
            }
            _loc6_[_loc2_[_loc7_]] = 1;
         }
         _loc7_ = int(_loc2_.length);
         while(true)
         {
            _loc7_--;
            if(_loc7_ <= -1)
            {
               break;
            }
            _loc5_ = String(_loc2_[_loc7_]);
            _loc4_ = _tween._firstPT;
            while(_loc4_)
            {
               _loc3_ = _loc4_._next;
               if(_loc4_.pg)
               {
                  _loc4_.t._roundProps(_loc6_,true);
               }
               else if(_loc4_.n == _loc5_)
               {
                  _add(_loc4_.t,_loc5_,_loc4_.s,_loc4_.c);
                  if(_loc3_)
                  {
                     _loc3_._prev = _loc4_._prev;
                  }
                  if(_loc4_._prev)
                  {
                     _loc4_._prev._next = _loc3_;
                  }
                  else if(_tween._firstPT == _loc4_)
                  {
                     _tween._firstPT = _loc3_;
                  }
                  _loc4_._next = _loc4_._prev = null;
                  _tween._propLookup[_loc5_] = _loc1_;
               }
               _loc4_ = _loc3_;
            }
         }
         return false;
      }
      
      public function _add(param1:Object, param2:String, param3:Number, param4:Number) : void
      {
         _addTween(param1,param2,param3,param3 + param4,param2,true);
         _overwriteProps[_overwriteProps.length] = param2;
      }
   }
}
