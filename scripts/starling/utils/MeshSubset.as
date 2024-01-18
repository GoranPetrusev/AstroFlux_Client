package starling.utils
{
   public class MeshSubset
   {
       
      
      public var vertexID:int;
      
      public var numVertices:int;
      
      public var indexID:int;
      
      public var numIndices:int;
      
      public function MeshSubset(param1:int = 0, param2:int = -1, param3:int = 0, param4:int = -1)
      {
         super();
         setTo(param1,param2,param3,param4);
      }
      
      public function setTo(param1:int = 0, param2:int = -1, param3:int = 0, param4:int = -1) : void
      {
         this.vertexID = param1;
         this.numVertices = param2;
         this.indexID = param3;
         this.numIndices = param4;
      }
   }
}
