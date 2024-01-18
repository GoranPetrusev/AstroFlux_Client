package feathers.utils.skins
{
   import feathers.core.IMeasureDisplayObject;
   import starling.display.DisplayObject;
   
   public function resetFluidChildDimensionsForMeasurement(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number) : void
   {
      var _loc15_:* = NaN;
      var _loc20_:* = NaN;
      var _loc17_:* = NaN;
      var _loc18_:* = NaN;
      if(param1 === null)
      {
         return;
      }
      var _loc16_:* = param2 !== param2;
      var _loc19_:* = param3 !== param3;
      if(_loc16_)
      {
         param1.width = param8;
      }
      else
      {
         param1.width = param2;
      }
      if(_loc19_)
      {
         param1.height = param9;
      }
      else
      {
         param1.height = param3;
      }
      var _loc14_:IMeasureDisplayObject;
      if((_loc14_ = param1 as IMeasureDisplayObject) !== null)
      {
         compilerWorkaround = _loc15_ = param4;
         if(_loc15_ !== _loc15_ || param10 > _loc15_)
         {
            _loc15_ = param10;
         }
         _loc14_.minWidth = _loc15_;
         compilerWorkaround = _loc20_ = param5;
         if(_loc20_ !== _loc20_ || param11 > _loc20_)
         {
            _loc20_ = param11;
         }
         _loc14_.minHeight = _loc20_;
         compilerWorkaround = _loc17_ = param6;
         if(_loc17_ !== _loc17_ || param12 < _loc17_)
         {
            _loc17_ = param12;
         }
         _loc14_.maxWidth = _loc17_;
         compilerWorkaround = _loc18_ = param7;
         if(_loc18_ !== _loc18_ || param13 < _loc18_)
         {
            _loc18_ = param13;
         }
         _loc14_.maxHeight = _loc18_;
      }
   }
}

var compilerWorkaround:Object;
