package playerio.generated.messages
{
   import com.protobuf.Message;
   
   public final class PlayerInsightSetSegmentsArgs extends Message
   {
       
      
      public var segments:Array;
      
      public function PlayerInsightSetSegmentsArgs(param1:Array)
      {
         segments = [];
         super();
         registerField("segments","",9,3,1);
         this.segments = param1;
      }
   }
}
