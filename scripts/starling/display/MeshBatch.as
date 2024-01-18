package starling.display
{
   import flash.geom.Matrix;
   import starling.rendering.IndexData;
   import starling.rendering.MeshEffect;
   import starling.rendering.Painter;
   import starling.rendering.VertexData;
   import starling.styles.MeshStyle;
   import starling.utils.MatrixUtil;
   import starling.utils.MeshSubset;
   
   public class MeshBatch extends Mesh
   {
      
      public static const MAX_NUM_VERTICES:int = 65535;
      
      private static var sFullMeshSubset:MeshSubset = new MeshSubset();
       
      
      private var _effect:MeshEffect;
      
      private var _batchable:Boolean;
      
      private var _vertexSyncRequired:Boolean;
      
      private var _indexSyncRequired:Boolean;
      
      public function MeshBatch()
      {
         var _loc1_:VertexData = new VertexData();
         var _loc2_:IndexData = new IndexData();
         super(_loc1_,_loc2_);
      }
      
      override public function dispose() : void
      {
         if(_effect)
         {
            _effect.dispose();
         }
         super.dispose();
      }
      
      override public function setVertexDataChanged() : void
      {
         _vertexSyncRequired = true;
         super.setVertexDataChanged();
      }
      
      override public function setIndexDataChanged() : void
      {
         _indexSyncRequired = true;
         super.setIndexDataChanged();
      }
      
      private function setVertexAndIndexDataChanged() : void
      {
         _vertexSyncRequired = _indexSyncRequired = true;
      }
      
      private function syncVertexBuffer() : void
      {
         _effect.uploadVertexData(_vertexData);
         _vertexSyncRequired = false;
      }
      
      private function syncIndexBuffer() : void
      {
         _effect.uploadIndexData(_indexData);
         _indexSyncRequired = false;
      }
      
      public function clear() : void
      {
         if(_parent)
         {
            setRequiresRedraw();
         }
         _vertexData.numVertices = 0;
         _indexData.numIndices = 0;
         _vertexSyncRequired = true;
         _indexSyncRequired = true;
      }
      
      public function addMesh(param1:Mesh, param2:Matrix = null, param3:Number = 1, param4:MeshSubset = null, param5:Boolean = false) : void
      {
         if(param5)
         {
            param2 = null;
         }
         else if(param2 == null)
         {
            param2 = param1.transformationMatrix;
         }
         if(param4 == null)
         {
            param4 = sFullMeshSubset;
         }
         var _loc7_:int = int(_vertexData.numVertices);
         var _loc8_:int = int(_indexData.numIndices);
         var _loc6_:MeshStyle = param1._style;
         if(_loc7_ == 0)
         {
            setupFor(param1);
         }
         _loc6_.batchVertexData(_style,_loc7_,param2,param4.vertexID,param4.numVertices);
         _loc6_.batchIndexData(_style,_loc8_,_loc7_ - param4.vertexID,param4.indexID,param4.numIndices);
         if(param3 != 1)
         {
            _vertexData.scaleAlphas("color",param3,_loc7_,param4.numVertices);
         }
         if(_parent)
         {
            setRequiresRedraw();
         }
         _indexSyncRequired = _vertexSyncRequired = true;
      }
      
      public function addMeshAt(param1:Mesh, param2:int, param3:int) : void
      {
         var _loc5_:int = param1.numIndices;
         var _loc4_:int = param1.numVertices;
         var _loc7_:Matrix = param1.transformationMatrix;
         var _loc6_:MeshStyle = param1._style;
         if(_vertexData.numVertices == 0)
         {
            setupFor(param1);
         }
         _loc6_.batchVertexData(_style,param3,_loc7_,0,_loc4_);
         _loc6_.batchIndexData(_style,param2,param3,0,_loc5_);
         if(alpha != 1)
         {
            _vertexData.scaleAlphas("color",alpha,param3,_loc4_);
         }
         if(_parent)
         {
            setRequiresRedraw();
         }
         _indexSyncRequired = _vertexSyncRequired = true;
      }
      
      private function setupFor(param1:Mesh) : void
      {
         var _loc3_:MeshStyle = param1._style;
         var _loc2_:Class = _loc3_.type;
         if(_style.type != _loc2_)
         {
            setStyle(new _loc2_() as MeshStyle,false);
         }
         _style.copyFrom(_loc3_);
      }
      
      public function canAddMesh(param1:Mesh, param2:int = -1) : Boolean
      {
         var _loc3_:int = int(_vertexData.numVertices);
         if(_loc3_ == 0)
         {
            return true;
         }
         if(param2 < 0)
         {
            param2 = param1.numVertices;
         }
         if(param2 == 0)
         {
            return true;
         }
         if(param2 + _loc3_ > 65535)
         {
            return false;
         }
         return _style.canBatchWith(param1._style);
      }
      
      override public function render(param1:Painter) : void
      {
         if(_vertexData.numVertices == 0)
         {
            return;
         }
         if(_pixelSnapping)
         {
            MatrixUtil.snapToPixels(param1.state.modelviewMatrix,param1.pixelSize);
         }
         if(_batchable)
         {
            param1.batchMesh(this);
         }
         else
         {
            param1.finishMeshBatch();
            param1.drawCount += 1;
            param1.prepareToDraw();
            param1.excludeFromCache(this);
            if(_vertexSyncRequired)
            {
               syncVertexBuffer();
            }
            if(_indexSyncRequired)
            {
               syncIndexBuffer();
            }
            _style.updateEffect(_effect,param1.state);
            _effect.render(0,_indexData.numTriangles);
         }
      }
      
      override public function setStyle(param1:MeshStyle = null, param2:Boolean = true) : void
      {
         super.setStyle(param1,param2);
         if(_effect)
         {
            _effect.dispose();
         }
         _effect = style.createEffect();
         _effect.onRestore = setVertexAndIndexDataChanged;
         setVertexAndIndexDataChanged();
      }
      
      public function set numVertices(param1:int) : void
      {
         if(_vertexData.numVertices != param1)
         {
            _vertexData.numVertices = param1;
            _vertexSyncRequired = true;
            setRequiresRedraw();
         }
      }
      
      public function set numIndices(param1:int) : void
      {
         if(_indexData.numIndices != param1)
         {
            _indexData.numIndices = param1;
            _indexSyncRequired = true;
            setRequiresRedraw();
         }
      }
      
      public function get batchable() : Boolean
      {
         return _batchable;
      }
      
      public function set batchable(param1:Boolean) : void
      {
         if(_batchable != param1)
         {
            _batchable = param1;
            setRequiresRedraw();
         }
      }
   }
}
