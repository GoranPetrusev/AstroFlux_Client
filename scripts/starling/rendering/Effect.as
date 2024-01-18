package starling.rendering
{
   import flash.display3D.Context3D;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.VertexBuffer3D;
   import flash.events.Event;
   import flash.geom.Matrix3D;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import starling.core.Starling;
   import starling.errors.MissingContextError;
   import starling.utils.execute;
   
   public class Effect
   {
      
      public static const VERTEX_FORMAT:VertexDataFormat = VertexDataFormat.fromString("position:float2");
      
      private static var sProgramNameCache:Dictionary = new Dictionary();
       
      
      private var _vertexBuffer:VertexBuffer3D;
      
      private var _vertexBufferSize:int;
      
      private var _indexBuffer:IndexBuffer3D;
      
      private var _indexBufferSize:int;
      
      private var _indexBufferUsesQuadLayout:Boolean;
      
      private var _mvpMatrix3D:Matrix3D;
      
      private var _onRestore:Function;
      
      private var _programBaseName:String;
      
      public function Effect()
      {
         super();
         _mvpMatrix3D = new Matrix3D();
         _programBaseName = getQualifiedClassName(this);
         Starling.current.stage3D.addEventListener("context3DCreate",onContextCreated,false,20,true);
      }
      
      public function dispose() : void
      {
         Starling.current.stage3D.removeEventListener("context3DCreate",onContextCreated);
         purgeBuffers();
      }
      
      private function onContextCreated(param1:Event) : void
      {
         purgeBuffers();
         execute(_onRestore,this);
      }
      
      public function purgeBuffers(param1:Boolean = true, param2:Boolean = true) : void
      {
         if(_vertexBuffer && param1)
         {
            try
            {
               _vertexBuffer.dispose();
            }
            catch(e:Error)
            {
            }
            _vertexBuffer = null;
         }
         if(_indexBuffer && param2)
         {
            try
            {
               _indexBuffer.dispose();
            }
            catch(e:Error)
            {
            }
            _indexBuffer = null;
         }
      }
      
      public function uploadIndexData(param1:IndexData, param2:String = "staticDraw") : void
      {
         var _loc3_:int = param1.numIndices;
         var _loc5_:Boolean = param1.useQuadLayout;
         var _loc4_:Boolean = _indexBufferUsesQuadLayout;
         if(_indexBuffer)
         {
            if(_loc3_ <= _indexBufferSize)
            {
               if(!_loc5_ || !_loc4_)
               {
                  param1.uploadToIndexBuffer(_indexBuffer);
                  _indexBufferUsesQuadLayout = _loc5_ && _loc3_ == _indexBufferSize;
               }
            }
            else
            {
               purgeBuffers(false,true);
            }
         }
         if(_indexBuffer == null)
         {
            _indexBuffer = param1.createIndexBuffer(true,param2);
            _indexBufferSize = _loc3_;
            _indexBufferUsesQuadLayout = _loc5_;
         }
      }
      
      public function uploadVertexData(param1:VertexData, param2:String = "staticDraw") : void
      {
         if(_vertexBuffer)
         {
            if(param1.size <= _vertexBufferSize)
            {
               param1.uploadToVertexBuffer(_vertexBuffer);
            }
            else
            {
               purgeBuffers(true,false);
            }
         }
         if(_vertexBuffer == null)
         {
            _vertexBuffer = param1.createVertexBuffer(true,param2);
            _vertexBufferSize = param1.size;
         }
      }
      
      public function render(param1:int = 0, param2:int = -1) : void
      {
         if(param2 < 0)
         {
            param2 = _indexBufferSize / 3;
         }
         if(param2 == 0)
         {
            return;
         }
         var _loc3_:Context3D = Starling.context;
         if(_loc3_ == null)
         {
            throw new MissingContextError();
         }
         beforeDraw(_loc3_);
         _loc3_.drawTriangles(indexBuffer,param1,param2);
         afterDraw(_loc3_);
      }
      
      protected function beforeDraw(param1:Context3D) : void
      {
         program.activate(param1);
         vertexFormat.setVertexBufferAt(0,vertexBuffer,"position");
         param1.setProgramConstantsFromMatrix("vertex",0,mvpMatrix3D,true);
      }
      
      protected function afterDraw(param1:Context3D) : void
      {
         param1.setVertexBufferAt(0,null);
      }
      
      protected function createProgram() : Program
      {
         var _loc1_:String = ["m44 op, va0, vc0","seq v0, va0, va0"].join("\n");
         var _loc2_:String = "mov oc, v0";
         return Program.fromSource(_loc1_,_loc2_);
      }
      
      protected function get programVariantName() : uint
      {
         return 0;
      }
      
      protected function get programBaseName() : String
      {
         return _programBaseName;
      }
      
      protected function set programBaseName(param1:String) : void
      {
         _programBaseName = param1;
      }
      
      protected function get programName() : String
      {
         var _loc3_:String = this.programBaseName;
         var _loc2_:uint = this.programVariantName;
         var _loc4_:Dictionary;
         if((_loc4_ = sProgramNameCache[_loc3_]) == null)
         {
            _loc4_ = new Dictionary();
            sProgramNameCache[_loc3_] = _loc4_;
         }
         var _loc1_:* = String(_loc4_[_loc2_]);
         if(_loc1_ == null)
         {
            if(_loc2_)
            {
               _loc1_ = _loc3_ + "#" + _loc2_.toString(16);
            }
            else
            {
               _loc1_ = _loc3_;
            }
            _loc4_[_loc2_] = _loc1_;
         }
         return _loc1_;
      }
      
      protected function get program() : Program
      {
         var _loc2_:String = this.programName;
         var _loc1_:Painter = Starling.painter;
         var _loc3_:Program = _loc1_.getProgram(_loc2_);
         if(_loc3_ == null)
         {
            _loc3_ = createProgram();
            _loc1_.registerProgram(_loc2_,_loc3_);
         }
         return _loc3_;
      }
      
      public function get onRestore() : Function
      {
         return _onRestore;
      }
      
      public function set onRestore(param1:Function) : void
      {
         _onRestore = param1;
      }
      
      public function get vertexFormat() : VertexDataFormat
      {
         return VERTEX_FORMAT;
      }
      
      public function get mvpMatrix3D() : Matrix3D
      {
         return _mvpMatrix3D;
      }
      
      public function set mvpMatrix3D(param1:Matrix3D) : void
      {
         _mvpMatrix3D.copyFrom(param1);
      }
      
      protected function get indexBuffer() : IndexBuffer3D
      {
         return _indexBuffer;
      }
      
      protected function get indexBufferSize() : int
      {
         return _indexBufferSize;
      }
      
      protected function get vertexBuffer() : VertexBuffer3D
      {
         return _vertexBuffer;
      }
      
      protected function get vertexBufferSize() : int
      {
         return _vertexBufferSize;
      }
   }
}
