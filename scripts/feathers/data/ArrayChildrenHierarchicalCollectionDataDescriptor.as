package feathers.data
{
   public class ArrayChildrenHierarchicalCollectionDataDescriptor implements IHierarchicalCollectionDataDescriptor
   {
       
      
      public var childrenField:String = "children";
      
      public function ArrayChildrenHierarchicalCollectionDataDescriptor()
      {
         super();
      }
      
      public function getLength(param1:Object, ... rest) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = param1 as Array;
         var _loc3_:int = int(rest.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = rest[_loc4_] as int;
            _loc6_ = _loc6_[_loc5_][childrenField] as Array;
            _loc4_++;
         }
         return _loc6_.length;
      }
      
      public function getItemAt(param1:Object, param2:int, ... rest) : Object
      {
         var _loc5_:int = 0;
         rest.insertAt(0,param2);
         var _loc7_:Array = param1 as Array;
         var _loc4_:int = rest.length - 1;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            param2 = rest[_loc5_] as int;
            _loc7_ = _loc7_[param2][childrenField] as Array;
            _loc5_++;
         }
         var _loc6_:int = rest[_loc4_] as int;
         return _loc7_[_loc6_];
      }
      
      public function setItemAt(param1:Object, param2:Object, param3:int, ... rest) : void
      {
         var _loc6_:int = 0;
         rest.insertAt(0,param3);
         var _loc8_:Array = param1 as Array;
         var _loc5_:int = rest.length - 1;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            param3 = rest[_loc6_] as int;
            _loc8_ = _loc8_[param3][childrenField] as Array;
            _loc6_++;
         }
         var _loc7_:int = int(rest[_loc5_]);
         _loc8_[_loc7_] = param2;
      }
      
      public function addItemAt(param1:Object, param2:Object, param3:int, ... rest) : void
      {
         var _loc6_:int = 0;
         rest.insertAt(0,param3);
         var _loc8_:Array = param1 as Array;
         var _loc5_:int = rest.length - 1;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            param3 = rest[_loc6_] as int;
            _loc8_ = _loc8_[param3][childrenField] as Array;
            _loc6_++;
         }
         var _loc7_:int = int(rest[_loc5_]);
         _loc8_.insertAt(_loc7_,param2);
      }
      
      public function removeItemAt(param1:Object, param2:int, ... rest) : Object
      {
         var _loc5_:int = 0;
         rest.insertAt(0,param2);
         var _loc7_:Array = param1 as Array;
         var _loc4_:int = rest.length - 1;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            param2 = rest[_loc5_] as int;
            _loc7_ = _loc7_[param2][childrenField] as Array;
            _loc5_++;
         }
         var _loc6_:int = int(rest[_loc4_]);
         return _loc7_.removeAt(_loc6_);
      }
      
      public function removeAll(param1:Object) : void
      {
         var _loc2_:Array = param1 as Array;
         _loc2_.length = 0;
      }
      
      public function getItemLocation(param1:Object, param2:Object, param3:Vector.<int> = null, ... rest) : Vector.<int>
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!param3)
         {
            param3 = new Vector.<int>(0);
         }
         else
         {
            param3.length = 0;
         }
         var _loc9_:Array = param1 as Array;
         var _loc6_:int = int(rest.length);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = rest[_loc7_] as int;
            param3[_loc7_] = _loc8_;
            _loc9_ = _loc9_[_loc8_][childrenField] as Array;
            _loc7_++;
         }
         var _loc5_:Boolean;
         if(!(_loc5_ = this.findItemInBranch(_loc9_,param2,param3)))
         {
            param3.length = 0;
         }
         return param3;
      }
      
      public function isBranch(param1:Object) : Boolean
      {
         return param1.hasOwnProperty(this.childrenField) && param1[this.childrenField] is Array;
      }
      
      protected function findItemInBranch(param1:Array, param2:Object, param3:Vector.<int>) : Boolean
      {
         var _loc7_:int = 0;
         var _loc5_:Object = null;
         var _loc4_:Boolean = false;
         var _loc6_:int;
         if((_loc6_ = param1.indexOf(param2)) >= 0)
         {
            param3.push(_loc6_);
            return true;
         }
         var _loc8_:int = int(param1.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc5_ = param1[_loc7_];
            if(this.isBranch(_loc5_))
            {
               param3.push(_loc7_);
               if(_loc4_ = this.findItemInBranch(_loc5_[childrenField] as Array,param2,param3))
               {
                  return true;
               }
               param3.pop();
            }
            _loc7_++;
         }
         return false;
      }
   }
}
