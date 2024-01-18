package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class FrameLabelPlugin extends FramePlugin
   {
      
      public static const API:Number = 2;
       
      
      public function FrameLabelPlugin()
      {
         super();
         _propName = "frameLabel";
      }
      
      override public function _onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!param3.target is MovieClip)
         {
            return false;
         }
         _target = param1 as MovieClip;
         this.frame = _target.currentFrame;
         var _loc5_:Array = _target.currentLabels;
         var _loc6_:String = param2;
         var _loc4_:int = _target.currentFrame;
         var _loc7_:int = int(_loc5_.length);
         while(true)
         {
            _loc7_--;
            if(_loc7_ <= -1)
            {
               break;
            }
            if(_loc5_[_loc7_].name == _loc6_)
            {
               _loc4_ = int(_loc5_[_loc7_].frame);
               break;
            }
         }
         if(this.frame != _loc4_)
         {
            _addTween(this,"frame",this.frame,_loc4_,"frame",true);
         }
         return true;
      }
   }
}
