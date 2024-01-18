package starling.geom
{
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   import starling.rendering.IndexData;
   import starling.rendering.VertexData;
   import starling.utils.MathUtil;
   import starling.utils.Pool;
   
   public class Polygon
   {
      
      private static var sRestIndices:Vector.<uint> = new Vector.<uint>(0);
       
      
      private var _coords:Vector.<Number>;
      
      public function Polygon(param1:Array = null)
      {
         super();
         _coords = new Vector.<Number>(0);
         addVertices.apply(this,param1);
      }
      
      public static function createEllipse(param1:Number, param2:Number, param3:Number, param4:Number) : Polygon
      {
         return new Ellipse(param1,param2,param3,param4);
      }
      
      public static function createCircle(param1:Number, param2:Number, param3:Number) : Polygon
      {
         return new Ellipse(param1,param2,param3,param3);
      }
      
      public static function createRectangle(param1:Number, param2:Number, param3:Number, param4:Number) : Polygon
      {
         return new Rectangle(param1,param2,param3,param4);
      }
      
      private static function isConvexTriangle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Boolean
      {
         return (param2 - param4) * (param5 - param3) + (param3 - param1) * (param6 - param4) >= 0;
      }
      
      private static function areVectorsIntersecting(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         if(param1 == param3 && param2 == param4 || param5 == param7 && param6 == param8)
         {
            return false;
         }
         var _loc12_:Number = param3 - param1;
         var _loc14_:Number = param4 - param2;
         var _loc13_:Number = param7 - param5;
         var _loc9_:Number;
         var _loc15_:Number;
         if((_loc9_ = (_loc15_ = param8 - param6) * _loc12_ - _loc13_ * _loc14_) == 0)
         {
            return false;
         }
         var _loc11_:Number;
         if((_loc11_ = (_loc14_ * (param5 - param1) - _loc12_ * (param6 - param2)) / _loc9_) < 0 || _loc11_ > 1)
         {
            return false;
         }
         var _loc10_:Number;
         return (_loc10_ = !!_loc14_ ? (param6 - param2 + _loc11_ * _loc15_) / _loc14_ : (param5 - param1 + _loc11_ * _loc13_) / _loc12_) >= 0 && _loc10_ <= 1;
      }
      
      public function clone() : Polygon
      {
         var _loc3_:int = 0;
         var _loc1_:Polygon = new Polygon();
         var _loc2_:int = int(_coords.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_._coords[_loc3_] = _coords[_loc3_];
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function reverse() : void
      {
         var _loc2_:Number = NaN;
         var _loc4_:int = 0;
         var _loc3_:int = int(_coords.length);
         var _loc1_:int = _loc3_ / 2;
         _loc4_ = 0;
         while(_loc4_ < _loc1_)
         {
            _loc2_ = _coords[_loc4_];
            _coords[_loc4_] = _coords[_loc3_ - _loc4_ - 2];
            _coords[_loc3_ - _loc4_ - 2] = _loc2_;
            _loc2_ = _coords[_loc4_ + 1];
            _coords[_loc4_ + 1] = _coords[_loc3_ - _loc4_ - 1];
            _coords[_loc3_ - _loc4_ - 1] = _loc2_;
            _loc4_ += 2;
         }
      }
      
      public function addVertices(... rest) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(rest.length);
         var _loc4_:int = int(_coords.length);
         if(_loc2_ > 0)
         {
            if(rest[0] is Point)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _coords[_loc4_ + _loc3_ * 2] = (rest[_loc3_] as Point).x;
                  _coords[_loc4_ + _loc3_ * 2 + 1] = (rest[_loc3_] as Point).y;
                  _loc3_++;
               }
            }
            else
            {
               if(!(rest[0] is Number))
               {
                  throw new ArgumentError("Invalid type: " + getQualifiedClassName(rest[0]));
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _coords[_loc4_ + _loc3_] = rest[_loc3_];
                  _loc3_++;
               }
            }
         }
      }
      
      public function setVertex(param1:int, param2:Number, param3:Number) : void
      {
         if(param1 >= 0 && param1 <= numVertices)
         {
            _coords[param1 * 2] = param2;
            _coords[param1 * 2 + 1] = param3;
            return;
         }
         throw new RangeError("Invalid index: " + param1);
      }
      
      public function getVertex(param1:int, param2:Point = null) : Point
      {
         if(param1 >= 0 && param1 < numVertices)
         {
            if(!param2)
            {
               param2 = new Point();
            }
            param2.setTo(_coords[param1 * 2],_coords[param1 * 2 + 1]);
            return param2;
         }
         throw new RangeError("Invalid index: " + param1);
      }
      
      public function contains(param1:Number, param2:Number) : Boolean
      {
         var _loc5_:int = 0;
         var _loc8_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc6_:* = numVertices - 1;
         var _loc4_:uint = 0;
         _loc5_ = 0;
         while(_loc5_ < numVertices)
         {
            _loc8_ = _coords[_loc5_ * 2];
            _loc3_ = _coords[_loc5_ * 2 + 1];
            _loc7_ = _coords[_loc6_ * 2];
            _loc9_ = _coords[_loc6_ * 2 + 1];
            if((_loc3_ < param2 && _loc9_ >= param2 || _loc9_ < param2 && _loc3_ >= param2) && (_loc8_ <= param1 || _loc7_ <= param1))
            {
               _loc4_ ^= uint(_loc8_ + (param2 - _loc3_) / (_loc9_ - _loc3_) * (_loc7_ - _loc8_) < param1);
            }
            _loc6_ = _loc5_;
            _loc5_++;
         }
         return _loc4_ != 0;
      }
      
      public function containsPoint(param1:Point) : Boolean
      {
         return contains(param1.x,param1.y);
      }
      
      public function triangulate(param1:IndexData = null, param2:int = 0) : IndexData
      {
         var _loc16_:int = 0;
         var _loc13_:* = 0;
         var _loc11_:int = 0;
         var _loc9_:* = 0;
         var _loc6_:Boolean = false;
         var _loc7_:* = 0;
         var _loc10_:* = 0;
         var _loc12_:* = 0;
         var _loc14_:int = this.numVertices;
         var _loc8_:int = this.numTriangles;
         if(param1 == null)
         {
            param1 = new IndexData(_loc8_ * 3);
         }
         if(_loc8_ == 0)
         {
            return param1;
         }
         sRestIndices.length = _loc14_;
         _loc11_ = 0;
         while(_loc11_ < _loc14_)
         {
            sRestIndices[_loc11_] = _loc11_;
            _loc11_++;
         }
         _loc16_ = 0;
         _loc13_ = _loc14_;
         var _loc3_:Point = Pool.getPoint();
         var _loc4_:Point = Pool.getPoint();
         var _loc5_:Point = Pool.getPoint();
         var _loc15_:Point = Pool.getPoint();
         while(_loc13_ > 3)
         {
            _loc6_ = false;
            _loc7_ = sRestIndices[_loc16_ % _loc13_];
            _loc10_ = sRestIndices[(_loc16_ + 1) % _loc13_];
            _loc12_ = sRestIndices[(_loc16_ + 2) % _loc13_];
            _loc3_.setTo(_coords[2 * _loc7_],_coords[2 * _loc7_ + 1]);
            _loc4_.setTo(_coords[2 * _loc10_],_coords[2 * _loc10_ + 1]);
            _loc5_.setTo(_coords[2 * _loc12_],_coords[2 * _loc12_ + 1]);
            if(isConvexTriangle(_loc3_.x,_loc3_.y,_loc4_.x,_loc4_.y,_loc5_.x,_loc5_.y))
            {
               _loc6_ = true;
               _loc11_ = 3;
               while(_loc11_ < _loc13_)
               {
                  _loc9_ = sRestIndices[(_loc16_ + _loc11_) % _loc13_];
                  _loc15_.setTo(_coords[2 * _loc9_],_coords[2 * _loc9_ + 1]);
                  if(MathUtil.isPointInTriangle(_loc15_,_loc3_,_loc4_,_loc5_))
                  {
                     _loc6_ = false;
                     break;
                  }
                  _loc11_++;
               }
            }
            if(_loc6_)
            {
               param1.addTriangle(_loc7_ + param2,_loc10_ + param2,_loc12_ + param2);
               sRestIndices.removeAt((_loc16_ + 1) % _loc13_);
               _loc13_--;
               _loc16_ = 0;
            }
            else
            {
               _loc16_++;
               if(_loc16_ == _loc13_)
               {
                  break;
               }
            }
         }
         Pool.putPoint(_loc3_);
         Pool.putPoint(_loc4_);
         Pool.putPoint(_loc5_);
         Pool.putPoint(_loc15_);
         param1.addTriangle(sRestIndices[0] + param2,sRestIndices[1] + param2,sRestIndices[2] + param2);
         return param1;
      }
      
      public function copyToVertexData(param1:VertexData = null, param2:int = 0, param3:String = "position") : void
      {
         var _loc6_:int = 0;
         var _loc4_:int = this.numVertices;
         var _loc5_:int = param2 + _loc4_;
         if(param1.numVertices < _loc5_)
         {
            param1.numVertices = _loc5_;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            param1.setPoint(param2 + _loc6_,param3,_coords[_loc6_ * 2],_coords[_loc6_ * 2 + 1]);
            _loc6_++;
         }
      }
      
      public function toString() : String
      {
         var _loc3_:int = 0;
         var _loc1_:String = "[Polygon";
         var _loc2_:int = this.numVertices;
         if(_loc2_ > 0)
         {
            _loc1_ += "\n";
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ += "  [Vertex " + _loc3_ + ": " + "x=" + _coords[_loc3_ * 2].toFixed(1) + ", " + "y=" + _coords[_loc3_ * 2 + 1].toFixed(1) + "]" + (_loc3_ == _loc2_ - 1 ? "\n" : ",\n");
            _loc3_++;
         }
         return _loc1_ + "]";
      }
      
      public function get isSimple() : Boolean
      {
         var _loc11_:int = 0;
         var _loc7_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc12_:int = 0;
         var _loc3_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc10_:int;
         if((_loc10_ = int(_coords.length)) <= 6)
         {
            return true;
         }
         _loc11_ = 0;
         while(_loc11_ < _loc10_)
         {
            _loc7_ = _coords[_loc11_];
            _loc9_ = _coords[_loc11_ + 1];
            _loc5_ = _coords[(_loc11_ + 2) % _loc10_];
            _loc8_ = _coords[(_loc11_ + 3) % _loc10_];
            _loc1_ = _loc11_ + _loc10_ - 2;
            _loc12_ = _loc11_ + 4;
            while(_loc12_ < _loc1_)
            {
               _loc3_ = _coords[_loc12_ % _loc10_];
               _loc6_ = _coords[(_loc12_ + 1) % _loc10_];
               _loc2_ = _coords[(_loc12_ + 2) % _loc10_];
               _loc4_ = _coords[(_loc12_ + 3) % _loc10_];
               if(areVectorsIntersecting(_loc7_,_loc9_,_loc5_,_loc8_,_loc3_,_loc6_,_loc2_,_loc4_))
               {
                  return false;
               }
               _loc12_ += 2;
            }
            _loc11_ += 2;
         }
         return true;
      }
      
      public function get isConvex() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(_coords.length);
         if(_loc1_ < 6)
         {
            return true;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(!isConvexTriangle(_coords[_loc2_],_coords[_loc2_ + 1],_coords[(_loc2_ + 2) % _loc1_],_coords[(_loc2_ + 3) % _loc1_],_coords[(_loc2_ + 4) % _loc1_],_coords[(_loc2_ + 5) % _loc1_]))
            {
               return false;
            }
            _loc2_ += 2;
         }
         return true;
      }
      
      public function get area() : Number
      {
         var _loc3_:int = 0;
         var _loc1_:Number = 0;
         var _loc2_:int = int(_coords.length);
         if(_loc2_ >= 6)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_ += _coords[_loc3_] * _coords[(_loc3_ + 3) % _loc2_];
               _loc1_ -= _coords[_loc3_ + 1] * _coords[(_loc3_ + 2) % _loc2_];
               _loc3_ += 2;
            }
         }
         return _loc1_ / 2;
      }
      
      public function get numVertices() : int
      {
         return _coords.length / 2;
      }
      
      public function set numVertices(param1:int) : void
      {
         var _loc3_:* = 0;
         var _loc2_:int = numVertices;
         _coords.length = param1 * 2;
         if(_loc2_ < param1)
         {
            _loc3_ = _loc2_;
            while(_loc3_ < param1)
            {
               _coords[_loc3_ * 2] = _coords[_loc3_ * 2 + 1] = 0;
               _loc3_++;
            }
         }
      }
      
      public function get numTriangles() : int
      {
         var _loc1_:int = this.numVertices;
         return _loc1_ >= 3 ? _loc1_ - 2 : 0;
      }
   }
}

import flash.errors.IllegalOperationError;
import flash.utils.getQualifiedClassName;
import starling.geom.Polygon;

class ImmutablePolygon extends Polygon
{
    
   
   private var _frozen:Boolean;
   
   public function ImmutablePolygon(param1:Array)
   {
      super(param1);
      _frozen = true;
   }
   
   override public function addVertices(... rest) : void
   {
      if(_frozen)
      {
         throw getImmutableError();
      }
      super.addVertices.apply(this,rest);
   }
   
   override public function setVertex(param1:int, param2:Number, param3:Number) : void
   {
      if(_frozen)
      {
         throw getImmutableError();
      }
      super.setVertex(param1,param2,param3);
   }
   
   override public function reverse() : void
   {
      if(_frozen)
      {
         throw getImmutableError();
      }
      super.reverse();
   }
   
   override public function set numVertices(param1:int) : void
   {
      if(_frozen)
      {
         throw getImmutableError();
      }
      super.reverse();
   }
   
   private function getImmutableError() : Error
   {
      var _loc2_:String = getQualifiedClassName(this).split("::").pop();
      var _loc1_:String = _loc2_ + " cannot be modified. Call \'clone\' to create a mutable copy.";
      return new IllegalOperationError(_loc1_);
   }
}

import starling.rendering.IndexData;

class Ellipse extends ImmutablePolygon
{
    
   
   private var _x:Number;
   
   private var _y:Number;
   
   private var _radiusX:Number;
   
   private var _radiusY:Number;
   
   public function Ellipse(param1:Number, param2:Number, param3:Number, param4:Number, param5:int = -1)
   {
      _x = param1;
      _y = param2;
      _radiusX = param3;
      _radiusY = param4;
      super(getVertices(param5));
   }
   
   private function getVertices(param1:int) : Array
   {
      var _loc5_:int = 0;
      if(param1 < 0)
      {
         param1 = 3.141592653589793 * (_radiusX + _radiusY) / 4;
      }
      if(param1 < 6)
      {
         param1 = 6;
      }
      var _loc2_:Array = [];
      var _loc3_:Number = 2 * 3.141592653589793 / param1;
      var _loc4_:Number = 0;
      _loc5_ = 0;
      while(_loc5_ < param1)
      {
         _loc2_[_loc5_ * 2] = Math.cos(_loc4_) * _radiusX + _x;
         _loc2_[_loc5_ * 2 + 1] = Math.sin(_loc4_) * _radiusY + _y;
         _loc4_ += _loc3_;
         _loc5_++;
      }
      return _loc2_;
   }
   
   override public function triangulate(param1:IndexData = null, param2:int = 0) : IndexData
   {
      var _loc3_:int = 0;
      if(param1 == null)
      {
         param1 = new IndexData((numVertices - 2) * 3);
      }
      var _loc4_:uint = 1;
      var _loc5_:uint = numVertices - 1;
      _loc3_ = int(_loc4_);
      while(_loc3_ < _loc5_)
      {
         param1.addTriangle(param2,param2 + _loc3_,param2 + _loc3_ + 1);
         _loc3_++;
      }
      return param1;
   }
   
   override public function contains(param1:Number, param2:Number) : Boolean
   {
      var _loc4_:Number = param1 - _x;
      var _loc6_:Number = param2 - _y;
      var _loc3_:Number = _loc4_ / _radiusX;
      var _loc5_:Number = _loc6_ / _radiusY;
      return _loc3_ * _loc3_ + _loc5_ * _loc5_ <= 1;
   }
   
   override public function get area() : Number
   {
      return 3.141592653589793 * _radiusX * _radiusY;
   }
   
   override public function get isSimple() : Boolean
   {
      return true;
   }
   
   override public function get isConvex() : Boolean
   {
      return true;
   }
}

import starling.rendering.IndexData;

class Rectangle extends ImmutablePolygon
{
    
   
   private var _x:Number;
   
   private var _y:Number;
   
   private var _width:Number;
   
   private var _height:Number;
   
   public function Rectangle(param1:Number, param2:Number, param3:Number, param4:Number)
   {
      _x = param1;
      _y = param2;
      _width = param3;
      _height = param4;
      super([param1,param2,param1 + param3,param2,param1 + param3,param2 + param4,param1,param2 + param4]);
   }
   
   override public function triangulate(param1:IndexData = null, param2:int = 0) : IndexData
   {
      if(param1 == null)
      {
         param1 = new IndexData(6);
      }
      param1.addTriangle(param2,param2 + 1,param2 + 3);
      param1.addTriangle(param2 + 1,param2 + 2,param2 + 3);
      return param1;
   }
   
   override public function contains(param1:Number, param2:Number) : Boolean
   {
      return param1 >= _x && param1 <= _x + _width && param2 >= _y && param2 <= _y + _height;
   }
   
   override public function get area() : Number
   {
      return _width * _height;
   }
   
   override public function get isSimple() : Boolean
   {
      return true;
   }
   
   override public function get isConvex() : Boolean
   {
      return true;
   }
}
