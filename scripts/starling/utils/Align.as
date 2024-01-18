package starling.utils
{
   import starling.errors.AbstractClassError;
   
   public final class Align
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const TOP:String = "top";
      
      public static const BOTTOM:String = "bottom";
      
      public static const CENTER:String = "center";
       
      
      public function Align()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function isValid(param1:String) : Boolean
      {
         return param1 == "left" || param1 == "right" || param1 == "center" || param1 == "top" || param1 == "bottom";
      }
      
      public static function isValidHorizontal(param1:String) : Boolean
      {
         return param1 == "left" || param1 == "center" || param1 == "right";
      }
      
      public static function isValidVertical(param1:String) : Boolean
      {
         return param1 == "top" || param1 == "center" || param1 == "bottom";
      }
   }
}
