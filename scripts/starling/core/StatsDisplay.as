package starling.core
{
   import flash.system.System;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.rendering.Painter;
   import starling.styles.MeshStyle;
   import starling.text.TextField;
   
   internal class StatsDisplay extends Sprite
   {
      
      private static const UPDATE_INTERVAL:Number = 0.5;
      
      private static const B_TO_MB:Number = 9.5367431640625e-7;
       
      
      private var _background:Quad;
      
      private var _labels:TextField;
      
      private var _values:TextField;
      
      private var _frameCount:int = 0;
      
      private var _totalTime:Number = 0;
      
      private var _fps:Number = 0;
      
      private var _memory:Number = 0;
      
      private var _gpuMemory:Number = 0;
      
      private var _drawCount:int = 0;
      
      private var _skipCount:int = 0;
      
      public function StatsDisplay()
      {
         var _loc1_:String = null;
         _loc1_ = "mini";
         var _loc3_:Number = NaN;
         _loc3_ = -1;
         var _loc4_:* = 0;
         _loc4_ = 16777215;
         var _loc2_:Number = NaN;
         _loc2_ = 90;
         super();
         var _loc6_:Number = supportsGpuMem ? 35 : 27;
         var _loc5_:String = supportsGpuMem ? "\ngpu memory:" : "";
         var _loc7_:String = "frames/sec:\nstd memory:" + _loc5_ + "\ndraw calls:";
         _labels = new TextField(90,_loc6_,_loc7_);
         _labels.format.setTo("mini",-1,16777215,"left");
         _labels.batchable = true;
         _labels.x = 2;
         _values = new TextField(90 - 1,_loc6_,"");
         _values.format.setTo("mini",-1,16777215,"right");
         _values.batchable = true;
         _background = new Quad(90,_loc6_,0);
         if(_background.style.type != MeshStyle)
         {
            _background.style = new MeshStyle();
         }
         if(_labels.style.type != MeshStyle)
         {
            _labels.style = new MeshStyle();
         }
         if(_values.style.type != MeshStyle)
         {
            _values.style = new MeshStyle();
         }
         addChild(_background);
         addChild(_labels);
         addChild(_values);
         addEventListener("addedToStage",onAddedToStage);
         addEventListener("removedFromStage",onRemovedFromStage);
      }
      
      private function onAddedToStage() : void
      {
         addEventListener("enterFrame",onEnterFrame);
         _totalTime = _frameCount = _skipCount = 0;
         update();
      }
      
      private function onRemovedFromStage() : void
      {
         removeEventListener("enterFrame",onEnterFrame);
      }
      
      private function onEnterFrame(param1:EnterFrameEvent) : void
      {
         _totalTime += param1.passedTime;
         _frameCount++;
         if(_totalTime > 0.5)
         {
            update();
            _frameCount = _skipCount = _totalTime = 0;
         }
      }
      
      public function update() : void
      {
         _background.color = _skipCount > _frameCount / 2 ? 16128 : 0;
         _fps = _totalTime > 0 ? _frameCount / _totalTime : 0;
         _memory = System.totalMemory * 9.5367431640625e-7;
         _gpuMemory = supportsGpuMem ? Starling.context["totalGPUMemory"] * 9.5367431640625e-7 : -1;
         var _loc1_:String = _fps.toFixed(_fps < 100 ? 1 : 0);
         var _loc3_:String = _memory.toFixed(_memory < 100 ? 1 : 0);
         var _loc2_:String = _gpuMemory.toFixed(_gpuMemory < 100 ? 1 : 0);
         var _loc4_:String = String((_totalTime > 0 ? _drawCount - 2 : _drawCount).toString());
         _values.text = _loc1_ + "\n" + _loc3_ + "\n" + (_gpuMemory >= 0 ? _loc2_ + "\n" : "") + _loc4_;
      }
      
      public function markFrameAsSkipped() : void
      {
         _skipCount += 1;
      }
      
      override public function render(param1:Painter) : void
      {
         param1.excludeFromCache(this);
         param1.finishMeshBatch();
         super.render(param1);
      }
      
      private function get supportsGpuMem() : Boolean
      {
         return "totalGPUMemory" in Starling.context;
      }
      
      public function get drawCount() : int
      {
         return _drawCount;
      }
      
      public function set drawCount(param1:int) : void
      {
         _drawCount = param1;
      }
      
      public function get fps() : Number
      {
         return _fps;
      }
      
      public function set fps(param1:Number) : void
      {
         _fps = param1;
      }
      
      public function get memory() : Number
      {
         return _memory;
      }
      
      public function set memory(param1:Number) : void
      {
         _memory = param1;
      }
      
      public function get gpuMemory() : Number
      {
         return _gpuMemory;
      }
      
      public function set gpuMemory(param1:Number) : void
      {
         _gpuMemory = param1;
      }
   }
}
