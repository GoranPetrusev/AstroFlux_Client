package feathers.data
{
   import starling.events.EventDispatcher;
   
   public class HierarchicalCollection extends EventDispatcher
   {
       
      
      protected var _data:Object;
      
      protected var _dataDescriptor:IHierarchicalCollectionDataDescriptor;
      
      public function HierarchicalCollection(param1:Object = null)
      {
         _dataDescriptor = new ArrayChildrenHierarchicalCollectionDataDescriptor();
         super();
         if(!param1)
         {
            param1 = [];
         }
         this.data = param1;
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         this.dispatchEventWith("reset");
         this.dispatchEventWith("change");
      }
      
      public function get dataDescriptor() : IHierarchicalCollectionDataDescriptor
      {
         return this._dataDescriptor;
      }
      
      public function set dataDescriptor(param1:IHierarchicalCollectionDataDescriptor) : void
      {
         if(this._dataDescriptor == param1)
         {
            return;
         }
         this._dataDescriptor = param1;
         this.dispatchEventWith("reset");
         this.dispatchEventWith("change");
      }
      
      public function isBranch(param1:Object) : Boolean
      {
         return this._dataDescriptor.isBranch(param1);
      }
      
      public function getLength(... rest) : int
      {
         rest.insertAt(0,this._data);
         return this._dataDescriptor.getLength.apply(null,rest);
      }
      
      public function updateItemAt(param1:int, ... rest) : void
      {
         rest.insertAt(0,param1);
         this.dispatchEventWith("updateItem",false,rest);
      }
      
      public function updateAll() : void
      {
         this.dispatchEventWith("updateAll");
      }
      
      public function getItemAt(param1:int, ... rest) : Object
      {
         rest.insertAt(0,param1);
         rest.insertAt(0,this._data);
         return this._dataDescriptor.getItemAt.apply(null,rest);
      }
      
      public function getItemLocation(param1:Object, param2:Vector.<int> = null) : Vector.<int>
      {
         return this._dataDescriptor.getItemLocation(this._data,param1,param2);
      }
      
      public function addItemAt(param1:Object, param2:int, ... rest) : void
      {
         rest.insertAt(0,param2);
         rest.insertAt(0,param1);
         rest.insertAt(0,this._data);
         this._dataDescriptor.addItemAt.apply(null,rest);
         this.dispatchEventWith("change");
         rest.shift();
         rest.shift();
         this.dispatchEventWith("addItem",false,rest);
      }
      
      public function removeItemAt(param1:int, ... rest) : Object
      {
         rest.insertAt(0,param1);
         rest.insertAt(0,this._data);
         var _loc3_:Object = this._dataDescriptor.removeItemAt.apply(null,rest);
         this.dispatchEventWith("change");
         rest.shift();
         this.dispatchEventWith("removeItem",false,rest);
         return _loc3_;
      }
      
      public function removeItem(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int>;
         if(_loc5_ = this.getItemLocation(param1))
         {
            _loc2_ = [];
            _loc3_ = int(_loc5_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_.push(_loc5_[_loc4_]);
               _loc4_++;
            }
            this.removeItemAt.apply(this,_loc2_);
         }
      }
      
      public function removeAll() : void
      {
         if(this.getLength() == 0)
         {
            return;
         }
         this._dataDescriptor.removeAll(this._data);
         this.dispatchEventWith("change");
         this.dispatchEventWith("reset",false);
      }
      
      public function setItemAt(param1:Object, param2:int, ... rest) : void
      {
         rest.insertAt(0,param2);
         rest.insertAt(0,param1);
         rest.insertAt(0,this._data);
         this._dataDescriptor.setItemAt.apply(null,rest);
         rest.shift();
         rest.shift();
         this.dispatchEventWith("replaceItem",false,rest);
         this.dispatchEventWith("change");
      }
      
      public function dispose(param1:Function, param2:Function) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc4_:int = this.getLength();
         var _loc3_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this.getItemAt(_loc5_);
            _loc3_[0] = _loc5_;
            this.disposeGroupInternal(_loc6_,_loc3_,param1,param2);
            _loc3_.length = 0;
            _loc5_++;
         }
      }
      
      protected function disposeGroupInternal(param1:Object, param2:Array, param3:Function, param4:Function) : void
      {
         var _loc6_:int = 0;
         var _loc5_:Object = null;
         if(param3 != null)
         {
            param3(param1);
         }
         var _loc7_:int = this.getLength.apply(this,param2);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            param2[param2.length] = _loc6_;
            _loc5_ = this.getItemAt.apply(this,param2);
            if(this.isBranch(_loc5_))
            {
               this.disposeGroupInternal(_loc5_,param2,param3,param4);
            }
            else if(param4 != null)
            {
               param4(_loc5_);
            }
            param2.length--;
            _loc6_++;
         }
      }
   }
}
