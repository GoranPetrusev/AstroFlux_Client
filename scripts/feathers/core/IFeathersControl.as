package feathers.core
{
   import feathers.skins.IStyleProvider;
   
   public interface IFeathersControl extends IValidating, IMeasureDisplayObject
   {
       
      
      function get isEnabled() : Boolean;
      
      function set isEnabled(param1:Boolean) : void;
      
      function get isInitialized() : Boolean;
      
      function get isCreated() : Boolean;
      
      function get styleNameList() : TokenList;
      
      function get styleName() : String;
      
      function set styleName(param1:String) : void;
      
      function get styleProvider() : IStyleProvider;
      
      function set styleProvider(param1:IStyleProvider) : void;
      
      function get toolTip() : String;
      
      function set toolTip(param1:String) : void;
      
      function setSize(param1:Number, param2:Number) : void;
      
      function move(param1:Number, param2:Number) : void;
      
      function resetStyleProvider() : void;
      
      function initializeNow() : void;
   }
}
