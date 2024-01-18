package feathers.core
{
   public interface IStateObserver
   {
       
      
      function get stateContext() : IStateContext;
      
      function set stateContext(param1:IStateContext) : void;
   }
}
