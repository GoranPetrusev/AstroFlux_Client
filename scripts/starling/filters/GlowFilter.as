package starling.filters
{
   import starling.rendering.Painter;
   import starling.textures.Texture;
   
   public class GlowFilter extends FragmentFilter
   {
       
      
      private var _blurFilter:BlurFilter;
      
      private var _compositeFilter:CompositeFilter;
      
      public function GlowFilter(param1:uint = 16776960, param2:Number = 1, param3:Number = 1, param4:Number = 0.5)
      {
         super();
         _blurFilter = new BlurFilter(param3,param3,param4);
         _compositeFilter = new CompositeFilter();
         _compositeFilter.setColorAt(0,param1,true);
         _compositeFilter.setAlphaAt(0,param2);
         updatePadding();
      }
      
      override public function dispose() : void
      {
         _blurFilter.dispose();
         _compositeFilter.dispose();
         super.dispose();
      }
      
      override public function process(param1:Painter, param2:IFilterHelper, param3:Texture = null, param4:Texture = null, param5:Texture = null, param6:Texture = null) : Texture
      {
         var _loc8_:Texture = _blurFilter.process(param1,param2,param3);
         var _loc7_:Texture = _compositeFilter.process(param1,param2,_loc8_,param3);
         param2.putTexture(_loc8_);
         return _loc7_;
      }
      
      override public function get numPasses() : int
      {
         return _blurFilter.numPasses + _compositeFilter.numPasses;
      }
      
      private function updatePadding() : void
      {
         padding.copyFrom(_blurFilter.padding);
      }
      
      public function get color() : uint
      {
         return _compositeFilter.getColorAt(0);
      }
      
      public function set color(param1:uint) : void
      {
         if(color != param1)
         {
            _compositeFilter.setColorAt(0,param1,true);
            setRequiresRedraw();
         }
      }
      
      public function get alpha() : Number
      {
         return _compositeFilter.getAlphaAt(0);
      }
      
      public function set alpha(param1:Number) : void
      {
         if(alpha != param1)
         {
            _compositeFilter.setAlphaAt(0,param1);
            setRequiresRedraw();
         }
      }
      
      public function get blur() : Number
      {
         return _blurFilter.blurX;
      }
      
      public function set blur(param1:Number) : void
      {
         if(blur != param1)
         {
            _blurFilter.blurX = _blurFilter.blurY = param1;
            setRequiresRedraw();
            updatePadding();
         }
      }
      
      override public function get resolution() : Number
      {
         return _blurFilter.resolution;
      }
      
      override public function set resolution(param1:Number) : void
      {
         if(resolution != param1)
         {
            _blurFilter.resolution = param1;
            setRequiresRedraw();
            updatePadding();
         }
      }
   }
}
