package feathers.controls.text
{
   public class MeasureTextResult
   {
       
      
      public var width:Number;
      
      public var height:Number;
      
      public var isTruncated:Boolean;
      
      public function MeasureTextResult(param1:Number = 0, param2:Number = 0, param3:Boolean = false)
      {
         super();
         this.width = param1;
         this.height = param2;
         this.isTruncated = param3;
      }
   }
}
