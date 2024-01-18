package feathers.data
{
   import feathers.core.IFeathersEventDispatcher;
   
   public interface IAutoCompleteSource extends IFeathersEventDispatcher
   {
       
      
      function load(param1:String, param2:ListCollection = null) : void;
   }
}
