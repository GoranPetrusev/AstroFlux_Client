package starling.rendering
{
   internal class VertexDataAttribute
   {
      
      private static const FORMAT_SIZES:Object = {
         "bytes4":4,
         "float1":4,
         "float2":8,
         "float3":12,
         "float4":16
      };
       
      
      public var name:String;
      
      public var format:String;
      
      public var isColor:Boolean;
      
      public var offset:int;
      
      public var size:int;
      
      public function VertexDataAttribute(param1:String, param2:String, param3:int)
      {
         super();
         if(!(param2 in FORMAT_SIZES))
         {
            throw new ArgumentError("Invalid attribute format: " + param2 + ". " + "Use one of the following: \'float1\'-\'float4\', \'bytes4\'");
         }
         this.name = param1;
         this.format = param2;
         this.offset = param3;
         this.size = FORMAT_SIZES[param2];
         this.isColor = param1.indexOf("color") != -1 || param1.indexOf("Color") != -1;
      }
   }
}
