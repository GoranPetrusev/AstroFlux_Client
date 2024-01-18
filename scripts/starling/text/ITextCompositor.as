package starling.text
{
   import starling.display.MeshBatch;
   
   public interface ITextCompositor
   {
       
      
      function fillMeshBatch(param1:MeshBatch, param2:Number, param3:Number, param4:String, param5:TextFormat, param6:TextOptions = null) : void;
      
      function clearMeshBatch(param1:MeshBatch) : void;
      
      function dispose() : void;
   }
}
