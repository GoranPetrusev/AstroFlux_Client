package starling.rendering
{
   import starling.utils.StringUtil;
   
   public class BatchToken
   {
       
      
      public var batchID:int;
      
      public var vertexID:int;
      
      public var indexID:int;
      
      public function BatchToken(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         setTo(param1,param2,param3);
      }
      
      public function copyFrom(param1:BatchToken) : void
      {
         batchID = param1.batchID;
         vertexID = param1.vertexID;
         indexID = param1.indexID;
      }
      
      public function setTo(param1:int = 0, param2:int = 0, param3:int = 0) : void
      {
         this.batchID = param1;
         this.vertexID = param2;
         this.indexID = param3;
      }
      
      public function reset() : void
      {
         batchID = vertexID = indexID = 0;
      }
      
      public function equals(param1:BatchToken) : Boolean
      {
         return batchID == param1.batchID && vertexID == param1.vertexID && indexID == param1.indexID;
      }
      
      public function toString() : String
      {
         return StringUtil.format("[BatchToken batchID={0} vertexID={1} indexID={2}]",batchID,vertexID,indexID);
      }
   }
}
