package playerio.generated.messages
{
   import com.protobuf.Message;
   
   public final class PlayerInsightSessionStopError extends Message
   {
       
      
      public var errorCode:int;
      
      public var message:String;
      
      public function PlayerInsightSessionStopError()
      {
         super();
         registerField("errorCode","",5,1,1);
         registerField("message","",9,1,2);
      }
   }
}
