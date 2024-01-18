package starling.textures
{
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import starling.utils.StringUtil;
   
   public class TextureAtlas
   {
      
      private static var sNames:Vector.<String> = new Vector.<String>(0);
       
      
      private var _atlasTexture:Texture;
      
      private var _subTextures:Dictionary;
      
      private var _subTextureNames:Vector.<String>;
      
      public function TextureAtlas(param1:Texture, param2:XML = null)
      {
         super();
         _subTextures = new Dictionary();
         _atlasTexture = param1;
         if(param2)
         {
            parseAtlasXml(param2);
         }
      }
      
      private static function parseBool(param1:String) : Boolean
      {
         return param1.toLowerCase() == "true";
      }
      
      public function dispose() : void
      {
         _atlasTexture.dispose();
      }
      
      protected function parseAtlasXml(param1:XML) : void
      {
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc3_:Number = _atlasTexture.scale;
         var _loc13_:Rectangle = new Rectangle();
         var _loc14_:Rectangle = new Rectangle();
         for each(var _loc8_ in param1.SubTexture)
         {
            _loc9_ = StringUtil.clean(_loc8_.@name);
            _loc10_ = parseFloat(_loc8_.@x) / _loc3_;
            _loc12_ = parseFloat(_loc8_.@y) / _loc3_;
            _loc11_ = parseFloat(_loc8_.@width) / _loc3_;
            _loc15_ = parseFloat(_loc8_.@height) / _loc3_;
            _loc4_ = parseFloat(_loc8_.@frameX) / _loc3_;
            _loc6_ = parseFloat(_loc8_.@frameY) / _loc3_;
            _loc7_ = parseFloat(_loc8_.@frameWidth) / _loc3_;
            _loc2_ = parseFloat(_loc8_.@frameHeight) / _loc3_;
            _loc5_ = parseBool(_loc8_.@rotated);
            _loc13_.setTo(_loc10_,_loc12_,_loc11_,_loc15_);
            _loc14_.setTo(_loc4_,_loc6_,_loc7_,_loc2_);
            if(_loc7_ > 0 && _loc2_ > 0)
            {
               addRegion(_loc9_,_loc13_,_loc14_,_loc5_);
            }
            else
            {
               addRegion(_loc9_,_loc13_,null,_loc5_);
            }
         }
      }
      
      public function getTexture(param1:String) : Texture
      {
         return _subTextures[param1];
      }
      
      public function getTextures(param1:String = "", param2:Vector.<Texture> = null) : Vector.<Texture>
      {
         if(param2 == null)
         {
            param2 = new Vector.<Texture>(0);
         }
         for each(var _loc3_ in getNames(param1,sNames))
         {
            param2[param2.length] = getTexture(_loc3_);
         }
         sNames.length = 0;
         return param2;
      }
      
      public function getNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         var _loc3_:String = null;
         if(param2 == null)
         {
            param2 = new Vector.<String>(0);
         }
         if(_subTextureNames == null)
         {
            _subTextureNames = new Vector.<String>(0);
            for(_loc3_ in _subTextures)
            {
               _subTextureNames[_subTextureNames.length] = _loc3_;
            }
            _subTextureNames.sort(1);
         }
         for each(_loc3_ in _subTextureNames)
         {
            if(_loc3_.indexOf(param1) == 0)
            {
               param2[param2.length] = _loc3_;
            }
         }
         return param2;
      }
      
      public function getRegion(param1:String) : Rectangle
      {
         var _loc2_:SubTexture = _subTextures[param1];
         return !!_loc2_ ? _loc2_.region : null;
      }
      
      public function getFrame(param1:String) : Rectangle
      {
         var _loc2_:SubTexture = _subTextures[param1];
         return !!_loc2_ ? _loc2_.frame : null;
      }
      
      public function getRotation(param1:String) : Boolean
      {
         var _loc2_:SubTexture = _subTextures[param1];
         return !!_loc2_ ? _loc2_.rotated : false;
      }
      
      public function addRegion(param1:String, param2:Rectangle, param3:Rectangle = null, param4:Boolean = false) : void
      {
         _subTextures[param1] = new SubTexture(_atlasTexture,param2,false,param3,param4);
         _subTextureNames = null;
      }
      
      public function removeRegion(param1:String) : void
      {
         var _loc2_:SubTexture = _subTextures[param1];
         if(_loc2_)
         {
            _loc2_.dispose();
         }
         delete _subTextures[param1];
         _subTextureNames = null;
      }
      
      public function get texture() : Texture
      {
         return _atlasTexture;
      }
   }
}
