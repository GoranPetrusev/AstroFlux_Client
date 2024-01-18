package playerio.generated.messages
{
   import com.protobuf.Message;
   
   public final class AchievementsLoadArgs extends Message
   {
       
      
      public var userIds:Array;
      
      public function AchievementsLoadArgs(param1:Array)
      {
         userIds = [];
         super();
         registerField("userIds","",9,3,1);
         this.userIds = param1;
      }
   }
}
