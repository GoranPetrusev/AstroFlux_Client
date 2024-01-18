package starling.filters
{
   import starling.rendering.Painter;
   import starling.textures.Texture;
   import starling.utils.Padding;
   
   public class DropShadowFilter extends FragmentFilter
   {
       
      
      private var _blurFilter:BlurFilter;
      
      private var _compositeFilter:CompositeFilter;
      
      private var _distance:Number;
      
      private var _angle:Number;
      
      public function DropShadowFilter(param1:Number = 4, param2:Number = 0.785, param3:uint = 0, param4:Number = 0.5, param5:Number = 1, param6:Number = 0.5)
      {
         super();
         _compositeFilter = new CompositeFilter();
         _blurFilter = new BlurFilter(param5,param5,param6);
         _distance = param1;
         _angle = param2;
         this.color = param3;
         this.alpha = param4;
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
         var _loc1_:Number = Math.cos(_angle) * _distance;
         var _loc2_:Number = Math.sin(_angle) * _distance;
         _compositeFilter.setOffsetAt(0,_loc1_,_loc2_);
         var _loc6_:Padding;
         var _loc4_:Number = (_loc6_ = _blurFilter.padding).left;
         var _loc7_:Number = _loc6_.right;
         var _loc3_:Number = _loc6_.top;
         var _loc5_:Number = _loc6_.bottom;
         if(_loc1_ > 0)
         {
            _loc7_ += _loc1_;
         }
         else
         {
            _loc4_ -= _loc1_;
         }
         if(_loc2_ > 0)
         {
            _loc5_ += _loc2_;
         }
         else
         {
            _loc3_ -= _loc2_;
         }
         padding.setTo(_loc4_,_loc7_,_loc3_,_loc5_);
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
      
      public function get distance() : Number
      {
         return _distance;
      }
      
      public function set distance(param1:Number) : void
      {
         if(_distance != param1)
         {
            _distance = param1;
            setRequiresRedraw();
            updatePadding();
         }
      }
      
      public function get angle() : Number
      {
         return _angle;
      }
      
      public function set angle(param1:Number) : void
      {
         if(_angle != param1)
         {
            _angle = param1;
            setRequiresRedraw();
            updatePadding();
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
