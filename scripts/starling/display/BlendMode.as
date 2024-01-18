package starling.display
{
   import starling.core.Starling;
   
   public class BlendMode
   {
      
      private static var sBlendModes:Object;
      
      public static const AUTO:String = "auto";
      
      public static const NONE:String = "none";
      
      public static const NORMAL:String = "normal";
      
      public static const ADD:String = "add";
      
      public static const MULTIPLY:String = "multiply";
      
      public static const SCREEN:String = "screen";
      
      public static const ERASE:String = "erase";
      
      public static const MASK:String = "mask";
      
      public static const BELOW:String = "below";
       
      
      private var _name:String;
      
      private var _sourceFactor:String;
      
      private var _destinationFactor:String;
      
      public function BlendMode(param1:String, param2:String, param3:String)
      {
         super();
         _name = param1;
         _sourceFactor = param2;
         _destinationFactor = param3;
      }
      
      public static function get(param1:String) : BlendMode
      {
         if(sBlendModes == null)
         {
            registerDefaults();
         }
         if(param1 in sBlendModes)
         {
            return sBlendModes[param1];
         }
         throw new ArgumentError("Blend mode not found: " + param1);
      }
      
      public static function register(param1:String, param2:String, param3:String) : BlendMode
      {
         if(sBlendModes == null)
         {
            registerDefaults();
         }
         var _loc4_:BlendMode = new BlendMode(param1,param2,param3);
         sBlendModes[param1] = _loc4_;
         return _loc4_;
      }
      
      private static function registerDefaults() : void
      {
         if(sBlendModes)
         {
            return;
         }
         sBlendModes = {};
         register("none","one","zero");
         register("normal","one","oneMinusSourceAlpha");
         register("add","one","one");
         register("multiply","destinationColor","oneMinusSourceAlpha");
         register("screen","one","oneMinusSourceColor");
         register("erase","zero","oneMinusSourceAlpha");
         register("mask","zero","sourceAlpha");
         register("below","oneMinusDestinationAlpha","destinationAlpha");
      }
      
      public function activate() : void
      {
         Starling.context.setBlendFactors(_sourceFactor,_destinationFactor);
      }
      
      public function toString() : String
      {
         return _name;
      }
      
      public function get sourceFactor() : String
      {
         return _sourceFactor;
      }
      
      public function get destinationFactor() : String
      {
         return _destinationFactor;
      }
      
      public function get name() : String
      {
         return _name;
      }
   }
}
