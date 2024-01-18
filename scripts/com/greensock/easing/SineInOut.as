package com.greensock.easing
{
   public final class SineInOut extends Ease
   {
      
      public static var ease:SineInOut = new SineInOut();
       
      
      public function SineInOut()
      {
         super();
      }
      
      override public function getRatio(param1:Number) : Number
      {
         return -0.5 * (Math.cos(3.141592653589793 * param1) - 1);
      }
   }
}
