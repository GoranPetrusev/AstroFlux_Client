package com.google.analytics.core
{
   public function generate32bitRandom() : int
   {
      return Math.round(Math.random() * 2147483647);
   }
}
