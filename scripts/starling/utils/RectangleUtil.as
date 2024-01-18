package starling.utils
{
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import starling.errors.AbstractClassError;
   
   public class RectangleUtil
   {
      
      private static const sPoint:Point = new Point();
      
      private static const sPoint3D:Vector3D = new Vector3D();
      
      private static const sPositions:Vector.<Point> = new <Point>[new Point(),new Point(),new Point(),new Point()];
       
      
      public function RectangleUtil()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function intersect(param1:Rectangle, param2:Rectangle, param3:Rectangle = null) : Rectangle
      {
         if(param3 == null)
         {
            param3 = new Rectangle();
         }
         var _loc5_:Number = param1.x > param2.x ? param1.x : param2.x;
         var _loc7_:Number = param1.right < param2.right ? param1.right : param2.right;
         var _loc4_:Number = param1.y > param2.y ? param1.y : param2.y;
         var _loc6_:Number = param1.bottom < param2.bottom ? param1.bottom : param2.bottom;
         if(_loc5_ > _loc7_ || _loc4_ > _loc6_)
         {
            param3.setEmpty();
         }
         else
         {
            param3.setTo(_loc5_,_loc4_,_loc7_ - _loc5_,_loc6_ - _loc4_);
         }
         return param3;
      }
      
      public static function fit(param1:Rectangle, param2:Rectangle, param3:String = "showAll", param4:Boolean = false, param5:Rectangle = null) : Rectangle
      {
         if(!ScaleMode.isValid(param3))
         {
            throw new ArgumentError("Invalid scaleMode: " + param3);
         }
         if(param5 == null)
         {
            param5 = new Rectangle();
         }
         var _loc8_:Number = param1.width;
         var _loc10_:Number = param1.height;
         var _loc7_:Number = param2.width / _loc8_;
         var _loc6_:Number = param2.height / _loc10_;
         var _loc9_:Number = 1;
         if(param3 == "showAll")
         {
            _loc9_ = _loc7_ < _loc6_ ? _loc7_ : _loc6_;
            if(param4)
            {
               _loc9_ = nextSuitableScaleFactor(_loc9_,false);
            }
         }
         else if(param3 == "noBorder")
         {
            _loc9_ = _loc7_ > _loc6_ ? _loc7_ : _loc6_;
            if(param4)
            {
               _loc9_ = nextSuitableScaleFactor(_loc9_,true);
            }
         }
         _loc8_ *= _loc9_;
         _loc10_ *= _loc9_;
         param5.setTo(param2.x + (param2.width - _loc8_) / 2,param2.y + (param2.height - _loc10_) / 2,_loc8_,_loc10_);
         return param5;
      }
      
      private static function nextSuitableScaleFactor(param1:Number, param2:Boolean) : Number
      {
         var _loc3_:Number = 1;
         if(param2)
         {
            if(param1 >= 0.5)
            {
               return Math.ceil(param1);
            }
            while(1 / (_loc3_ + 1) > param1)
            {
               _loc3_++;
            }
         }
         else
         {
            if(param1 >= 1)
            {
               return Math.floor(param1);
            }
            while(1 / _loc3_ > param1)
            {
               _loc3_++;
            }
         }
         return 1 / _loc3_;
      }
      
      public static function normalize(param1:Rectangle) : void
      {
         if(param1.width < 0)
         {
            param1.width = -param1.width;
            param1.x -= param1.width;
         }
         if(param1.height < 0)
         {
            param1.height = -param1.height;
            param1.y -= param1.height;
         }
      }
      
      public static function extend(param1:Rectangle, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0) : void
      {
         param1.x -= param2;
         param1.y -= param4;
         param1.width += param2 + param3;
         param1.height += param4 + param5;
      }
      
      public static function getBounds(param1:Rectangle, param2:Matrix, param3:Rectangle = null) : Rectangle
      {
         var _loc8_:int = 0;
         if(param3 == null)
         {
            param3 = new Rectangle();
         }
         var _loc5_:Number = 1.7976931348623157e+308;
         var _loc7_:Number = -1.7976931348623157e+308;
         var _loc4_:Number = 1.7976931348623157e+308;
         var _loc6_:Number = -1.7976931348623157e+308;
         var _loc9_:Vector.<Point> = getPositions(param1,sPositions);
         _loc8_ = 0;
         while(_loc8_ < 4)
         {
            MatrixUtil.transformCoords(param2,_loc9_[_loc8_].x,_loc9_[_loc8_].y,sPoint);
            if(_loc5_ > sPoint.x)
            {
               _loc5_ = sPoint.x;
            }
            if(_loc7_ < sPoint.x)
            {
               _loc7_ = sPoint.x;
            }
            if(_loc4_ > sPoint.y)
            {
               _loc4_ = sPoint.y;
            }
            if(_loc6_ < sPoint.y)
            {
               _loc6_ = sPoint.y;
            }
            _loc8_++;
         }
         param3.setTo(_loc5_,_loc4_,_loc7_ - _loc5_,_loc6_ - _loc4_);
         return param3;
      }
      
      public static function getBoundsProjected(param1:Rectangle, param2:Matrix3D, param3:Vector3D, param4:Rectangle = null) : Rectangle
      {
         var _loc9_:int = 0;
         var _loc11_:Point = null;
         if(param4 == null)
         {
            param4 = new Rectangle();
         }
         if(param3 == null)
         {
            throw new ArgumentError("camPos must not be null");
         }
         var _loc6_:Number = 1.7976931348623157e+308;
         var _loc8_:Number = -1.7976931348623157e+308;
         var _loc5_:Number = 1.7976931348623157e+308;
         var _loc7_:Number = -1.7976931348623157e+308;
         var _loc10_:Vector.<Point> = getPositions(param1,sPositions);
         _loc9_ = 0;
         while(_loc9_ < 4)
         {
            _loc11_ = _loc10_[_loc9_];
            if(param2)
            {
               MatrixUtil.transformCoords3D(param2,_loc11_.x,_loc11_.y,0,sPoint3D);
            }
            else
            {
               sPoint3D.setTo(_loc11_.x,_loc11_.y,0);
            }
            MathUtil.intersectLineWithXYPlane(param3,sPoint3D,sPoint);
            if(_loc6_ > sPoint.x)
            {
               _loc6_ = sPoint.x;
            }
            if(_loc8_ < sPoint.x)
            {
               _loc8_ = sPoint.x;
            }
            if(_loc5_ > sPoint.y)
            {
               _loc5_ = sPoint.y;
            }
            if(_loc7_ < sPoint.y)
            {
               _loc7_ = sPoint.y;
            }
            _loc9_++;
         }
         param4.setTo(_loc6_,_loc5_,_loc8_ - _loc6_,_loc7_ - _loc5_);
         return param4;
      }
      
      public static function getPositions(param1:Rectangle, param2:Vector.<Point> = null) : Vector.<Point>
      {
         var _loc3_:int = 0;
         if(param2 == null)
         {
            param2 = new Vector.<Point>(4,true);
         }
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            if(param2[_loc3_] == null)
            {
               param2[_loc3_] = new Point();
            }
            _loc3_++;
         }
         param2[0].x = param1.left;
         param2[0].y = param1.top;
         param2[1].x = param1.right;
         param2[1].y = param1.top;
         param2[2].x = param1.left;
         param2[2].y = param1.bottom;
         param2[3].x = param1.right;
         param2[3].y = param1.bottom;
         return param2;
      }
      
      public static function compare(param1:Rectangle, param2:Rectangle, param3:Number = 0.0001) : Boolean
      {
         if(param1 == null)
         {
            return param2 == null;
         }
         if(param2 == null)
         {
            return false;
         }
         return param1.x > param2.x - param3 && param1.x < param2.x + param3 && param1.y > param2.y - param3 && param1.y < param2.y + param3 && param1.width > param2.width - param3 && param1.width < param2.width + param3 && param1.height > param2.height - param3 && param1.height < param2.height + param3;
      }
   }
}
