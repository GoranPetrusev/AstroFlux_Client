package starling.rendering
{
   import flash.geom.Matrix;
   import starling.display.Mesh;
   import starling.display.MeshBatch;
   import starling.utils.MeshSubset;
   
   internal class BatchProcessor
   {
      
      private static var sMeshSubset:MeshSubset = new MeshSubset();
       
      
      private var _batches:Vector.<MeshBatch>;
      
      private var _batchPool:BatchPool;
      
      private var _currentBatch:MeshBatch;
      
      private var _currentStyleType:Class;
      
      private var _onBatchComplete:Function;
      
      private var _cacheToken:BatchToken;
      
      public function BatchProcessor()
      {
         super();
         _batches = new Vector.<MeshBatch>(0);
         _batchPool = new BatchPool();
         _cacheToken = new BatchToken();
      }
      
      public function dispose() : void
      {
         for each(var _loc1_ in _batches)
         {
            _loc1_.dispose();
         }
         _batches.length = 0;
         _batchPool.purge();
         _currentBatch = null;
         _onBatchComplete = null;
      }
      
      public function addMesh(param1:Mesh, param2:RenderState, param3:MeshSubset = null, param4:Boolean = false) : void
      {
         var _loc6_:Matrix = null;
         var _loc5_:Number = NaN;
         if(param3 == null)
         {
            param3 = sMeshSubset;
            param3.vertexID = param3.indexID = 0;
            param3.numVertices = param1.numVertices;
            param3.numIndices = param1.numIndices;
         }
         else
         {
            if(param3.numVertices < 0)
            {
               param3.numVertices = param1.numVertices - param3.vertexID;
            }
            if(param3.numIndices < 0)
            {
               param3.numIndices = param1.numIndices - param3.indexID;
            }
         }
         if(param3.numVertices > 0)
         {
            if(_currentBatch == null || !_currentBatch.canAddMesh(param1,param3.numVertices))
            {
               finishBatch();
               _currentStyleType = param1.style.type;
               _currentBatch = _batchPool.get(_currentStyleType);
               _currentBatch.blendMode = !!param2 ? param2.blendMode : param1.blendMode;
               _cacheToken.setTo(_batches.length);
               _batches[_batches.length] = _currentBatch;
            }
            _loc6_ = !!param2 ? param2._modelviewMatrix : null;
            _loc5_ = !!param2 ? param2._alpha : 1;
            _currentBatch.addMesh(param1,_loc6_,_loc5_,param3,param4);
            _cacheToken.vertexID += param3.numVertices;
            _cacheToken.indexID += param3.numIndices;
         }
      }
      
      public function finishBatch() : void
      {
         var _loc1_:MeshBatch = _currentBatch;
         if(_loc1_)
         {
            _currentBatch = null;
            _currentStyleType = null;
            if(_onBatchComplete != null)
            {
               _onBatchComplete(_loc1_);
            }
         }
      }
      
      public function clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(_batches.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _batchPool.put(_batches[_loc1_]);
            _loc1_++;
         }
         _batches.length = 0;
         _currentBatch = null;
         _currentStyleType = null;
         _cacheToken.reset();
      }
      
      public function getBatchAt(param1:int) : MeshBatch
      {
         return _batches[param1];
      }
      
      public function trim() : void
      {
         _batchPool.purge();
      }
      
      public function fillToken(param1:BatchToken) : BatchToken
      {
         param1.batchID = _cacheToken.batchID;
         param1.vertexID = _cacheToken.vertexID;
         param1.indexID = _cacheToken.indexID;
         return param1;
      }
      
      public function get numBatches() : int
      {
         return _batches.length;
      }
      
      public function get onBatchComplete() : Function
      {
         return _onBatchComplete;
      }
      
      public function set onBatchComplete(param1:Function) : void
      {
         _onBatchComplete = param1;
      }
   }
}

import flash.utils.Dictionary;
import starling.display.MeshBatch;

class BatchPool
{
    
   
   private var _batchLists:Dictionary;
   
   public function BatchPool()
   {
      super();
      _batchLists = new Dictionary();
   }
   
   public function purge() : void
   {
      var _loc1_:int = 0;
      for each(var _loc2_ in _batchLists)
      {
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc2_[_loc1_].dispose();
            _loc1_++;
         }
         _loc2_.length = 0;
      }
   }
   
   public function get(param1:Class) : MeshBatch
   {
      var _loc2_:Vector.<MeshBatch> = _batchLists[param1];
      if(_loc2_ == null)
      {
         _loc2_ = new Vector.<MeshBatch>(0);
         _batchLists[param1] = _loc2_;
      }
      if(_loc2_.length > 0)
      {
         return _loc2_.pop();
      }
      return new MeshBatch();
   }
   
   public function put(param1:MeshBatch) : void
   {
      var _loc2_:Class = param1.style.type;
      var _loc3_:Vector.<MeshBatch> = _batchLists[_loc2_];
      if(_loc3_ == null)
      {
         _loc3_ = new Vector.<MeshBatch>(0);
         _batchLists[_loc2_] = _loc3_;
      }
      param1.clear();
      _loc3_[_loc3_.length] = param1;
   }
}
