package starling.rendering
{
   import com.adobe.utils.AGALMiniAssembler;
   import flash.display3D.Context3D;
   import flash.display3D.Program3D;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import starling.core.Starling;
   import starling.errors.MissingContextError;
   
   public class Program
   {
      
      private static var sAssembler:AGALMiniAssembler = new AGALMiniAssembler();
       
      
      private var _vertexShader:ByteArray;
      
      private var _fragmentShader:ByteArray;
      
      private var _program3D:Program3D;
      
      public function Program(param1:ByteArray, param2:ByteArray)
      {
         super();
         _vertexShader = param1;
         _fragmentShader = param2;
         Starling.current.stage3D.addEventListener("context3DCreate",onContextCreated,false,30,true);
      }
      
      public static function fromSource(param1:String, param2:String, param3:uint = 1) : Program
      {
         return new Program(sAssembler.assemble("vertex",param1,param3),sAssembler.assemble("fragment",param2,param3));
      }
      
      public function dispose() : void
      {
         Starling.current.stage3D.removeEventListener("context3DCreate",onContextCreated);
         disposeProgram();
      }
      
      public function activate(param1:Context3D = null) : void
      {
         if(param1 == null)
         {
            param1 = Starling.context;
            if(param1 == null)
            {
               throw new MissingContextError();
            }
         }
         if(_program3D == null)
         {
            _program3D = param1.createProgram();
            _program3D.upload(_vertexShader,_fragmentShader);
         }
         param1.setProgram(_program3D);
      }
      
      private function onContextCreated(param1:Event) : void
      {
         disposeProgram();
      }
      
      private function disposeProgram() : void
      {
         if(_program3D)
         {
            _program3D.dispose();
            _program3D = null;
         }
      }
   }
}
