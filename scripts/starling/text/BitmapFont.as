package starling.text
{
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import starling.display.Image;
   import starling.display.MeshBatch;
   import starling.display.Sprite;
   import starling.textures.Texture;
   import starling.utils.StringUtil;
   
   public class BitmapFont implements ITextCompositor
   {
      
      public static const NATIVE_SIZE:int = -1;
      
      public static const MINI:String = "mini";
      
      private static const CHAR_SPACE:int = 32;
      
      private static const CHAR_TAB:int = 9;
      
      private static const CHAR_NEWLINE:int = 10;
      
      private static const CHAR_CARRIAGE_RETURN:int = 13;
      
      private static var sLines:Array = [];
      
      private static var sDefaultOptions:TextOptions = new TextOptions();
       
      
      private var _texture:Texture;
      
      private var _chars:Dictionary;
      
      private var _name:String;
      
      private var _size:Number;
      
      private var _lineHeight:Number;
      
      private var _baseline:Number;
      
      private var _offsetX:Number;
      
      private var _offsetY:Number;
      
      private var _padding:Number;
      
      private var _helperImage:Image;
      
      public function BitmapFont(param1:Texture = null, param2:XML = null)
      {
         super();
         if(param1 == null && param2 == null)
         {
            param1 = MiniBitmapFont.texture;
            param2 = MiniBitmapFont.xml;
         }
         else if(param1 == null || param2 == null)
         {
            throw new ArgumentError("Set both of the \'texture\' and \'fontXml\' arguments to valid objects or leave both of them null.");
         }
         _name = "unknown";
         _lineHeight = _size = _baseline = 14;
         _offsetX = _offsetY = _padding = 0;
         _texture = param1;
         _chars = new Dictionary();
         _helperImage = new Image(param1);
         parseFontXml(param2);
      }
      
      public function dispose() : void
      {
         if(_texture)
         {
            _texture.dispose();
         }
      }
      
      private function parseFontXml(param1:XML) : void
      {
         var _loc14_:int = 0;
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc15_:Rectangle = null;
         var _loc5_:Texture = null;
         var _loc8_:BitmapChar = null;
         var _loc16_:int = 0;
         var _loc10_:int = 0;
         var _loc3_:Number = NaN;
         var _loc6_:Number = _texture.scale;
         var _loc17_:Rectangle;
         var _loc7_:Number = !!(_loc17_ = _texture.frame) ? _loc17_.x : 0;
         var _loc9_:Number = !!_loc17_ ? _loc17_.y : 0;
         _name = StringUtil.clean(param1.info.@face);
         _size = parseFloat(param1.info.@size) / _loc6_;
         _lineHeight = parseFloat(param1.common.@lineHeight) / _loc6_;
         _baseline = parseFloat(param1.common.@base) / _loc6_;
         if(param1.info.@smooth.toString() == "0")
         {
            smoothing = "none";
         }
         if(_size <= 0)
         {
            trace("[Starling] Warning: invalid font size in \'" + _name + "\' font.");
            _size = _size == 0 ? 16 : _size * -1;
         }
         for each(var _loc11_ in param1.chars.char)
         {
            _loc14_ = parseInt(_loc11_.@id);
            _loc4_ = parseFloat(_loc11_.@xoffset) / _loc6_;
            _loc2_ = parseFloat(_loc11_.@yoffset) / _loc6_;
            _loc13_ = parseFloat(_loc11_.@xadvance) / _loc6_;
            (_loc15_ = new Rectangle()).x = parseFloat(_loc11_.@x) / _loc6_ + _loc7_;
            _loc15_.y = parseFloat(_loc11_.@y) / _loc6_ + _loc9_;
            _loc15_.width = parseFloat(_loc11_.@width) / _loc6_;
            _loc15_.height = parseFloat(_loc11_.@height) / _loc6_;
            _loc5_ = Texture.fromTexture(_texture,_loc15_);
            _loc8_ = new BitmapChar(_loc14_,_loc5_,_loc4_,_loc2_,_loc13_);
            addChar(_loc14_,_loc8_);
         }
         for each(var _loc12_ in param1.kernings.kerning)
         {
            _loc16_ = parseInt(_loc12_.@first);
            _loc10_ = parseInt(_loc12_.@second);
            _loc3_ = parseFloat(_loc12_.@amount) / _loc6_;
            if(_loc10_ in _chars)
            {
               getChar(_loc10_).addKerning(_loc16_,_loc3_);
            }
         }
      }
      
      public function getChar(param1:int) : BitmapChar
      {
         return _chars[param1];
      }
      
      public function addChar(param1:int, param2:BitmapChar) : void
      {
         _chars[param1] = param2;
      }
      
      public function getCharIDs(param1:Vector.<int> = null) : Vector.<int>
      {
         if(param1 == null)
         {
            param1 = new Vector.<int>(0);
         }
         for(var _loc2_ in _chars)
         {
            param1[param1.length] = _loc2_;
         }
         return param1;
      }
      
      public function hasChars(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return true;
         }
         var _loc4_:int = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.charCodeAt(_loc3_);
            if(_loc2_ != 32 && _loc2_ != 9 && _loc2_ != 10 && _loc2_ != 13 && getChar(_loc2_) == null)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function createSprite(param1:Number, param2:Number, param3:String, param4:TextFormat, param5:TextOptions = null) : Sprite
      {
         var _loc9_:int = 0;
         var _loc10_:CharLocation = null;
         var _loc8_:Image = null;
         var _loc6_:Vector.<CharLocation>;
         var _loc12_:int = int((_loc6_ = arrangeChars(param1,param2,param3,param4,param5)).length);
         var _loc11_:String = this.smoothing;
         var _loc7_:Sprite = new Sprite();
         _loc9_ = 0;
         while(_loc9_ < _loc12_)
         {
            (_loc8_ = (_loc10_ = _loc6_[_loc9_]).char.createImage()).x = _loc10_.x;
            _loc8_.y = _loc10_.y;
            _loc8_.scale = _loc10_.scale;
            _loc8_.color = param4.color;
            _loc8_.textureSmoothing = _loc11_;
            _loc7_.addChild(_loc8_);
            _loc9_++;
         }
         CharLocation.rechargePool();
         return _loc7_;
      }
      
      public function fillMeshBatch(param1:MeshBatch, param2:Number, param3:Number, param4:String, param5:TextFormat, param6:TextOptions = null) : void
      {
         var _loc8_:int = 0;
         var _loc9_:CharLocation = null;
         var _loc7_:Vector.<CharLocation>;
         var _loc10_:int = int((_loc7_ = arrangeChars(param2,param3,param4,param5,param6)).length);
         _helperImage.color = param5.color;
         _loc8_ = 0;
         while(_loc8_ < _loc10_)
         {
            _loc9_ = _loc7_[_loc8_];
            _helperImage.texture = _loc9_.char.texture;
            _helperImage.readjustSize();
            _helperImage.x = _loc9_.x;
            _helperImage.y = _loc9_.y;
            _helperImage.scale = _loc9_.scale;
            param1.addMesh(_helperImage);
            _loc8_++;
         }
         CharLocation.rechargePool();
      }
      
      public function clearMeshBatch(param1:MeshBatch) : void
      {
         param1.clear();
      }
      
      private function arrangeChars(param1:Number, param2:Number, param3:String, param4:TextFormat, param5:TextOptions) : Vector.<CharLocation>
      {
         var _loc38_:CharLocation = null;
         var _loc31_:int = 0;
         var _loc18_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc29_:int = 0;
         var _loc27_:int = 0;
         var _loc23_:* = 0;
         var _loc36_:* = 0;
         var _loc35_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc19_:* = undefined;
         var _loc33_:Boolean = false;
         var _loc24_:int = 0;
         var _loc37_:BitmapChar = null;
         var _loc32_:int = 0;
         var _loc14_:int = 0;
         var _loc12_:* = undefined;
         var _loc21_:int = 0;
         var _loc26_:CharLocation = null;
         var _loc30_:Number = NaN;
         var _loc22_:int = 0;
         if(param3 == null || param3.length == 0)
         {
            return CharLocation.vectorFromPool();
         }
         if(param5 == null)
         {
            param5 = sDefaultOptions;
         }
         var _loc6_:Boolean = param4.kerning;
         var _loc10_:Number = param4.leading;
         var _loc8_:String = param4.horizontalAlign;
         var _loc16_:String = param4.verticalAlign;
         var _loc39_:Number = param4.size;
         var _loc17_:Boolean = param5.autoScale;
         var _loc11_:Boolean = param5.wordWrap;
         var _loc28_:Boolean = false;
         if(_loc39_ < 0)
         {
            _loc39_ *= -_size;
         }
         while(!_loc28_)
         {
            sLines.length = 0;
            _loc13_ = _loc39_ / _size;
            _loc18_ = (param1 - 2 * _padding) / _loc13_;
            _loc34_ = (param2 - 2 * _padding) / _loc13_;
            if(_lineHeight <= _loc34_)
            {
               _loc23_ = -1;
               _loc36_ = -1;
               _loc35_ = 0;
               _loc15_ = 0;
               _loc19_ = CharLocation.vectorFromPool();
               _loc31_ = param3.length;
               _loc27_ = 0;
               while(_loc27_ < _loc31_)
               {
                  _loc33_ = false;
                  _loc24_ = param3.charCodeAt(_loc27_);
                  _loc37_ = getChar(_loc24_);
                  if(_loc24_ == 10 || _loc24_ == 13)
                  {
                     _loc33_ = true;
                  }
                  else if(_loc37_ == null)
                  {
                     trace("[Starling] Font: " + name + " missing character: " + param3.charAt(_loc27_) + " id: " + _loc24_);
                  }
                  else
                  {
                     if(_loc24_ == 32 || _loc24_ == 9)
                     {
                        _loc23_ = _loc27_;
                     }
                     if(_loc6_)
                     {
                        _loc35_ += _loc37_.getKerning(_loc36_);
                     }
                     (_loc38_ = CharLocation.instanceFromPool(_loc37_)).x = _loc35_ + _loc37_.xOffset;
                     _loc38_.y = _loc15_ + _loc37_.yOffset;
                     _loc19_[_loc19_.length] = _loc38_;
                     _loc35_ += _loc37_.xAdvance;
                     _loc36_ = _loc24_;
                     if(_loc38_.x + _loc37_.width > _loc18_)
                     {
                        if(_loc11_)
                        {
                           if(!(_loc17_ && _loc23_ == -1))
                           {
                              _loc32_ = _loc23_ == -1 ? 1 : _loc27_ - _loc23_;
                              _loc29_ = 0;
                              while(_loc29_ < _loc32_)
                              {
                                 _loc19_.pop();
                                 _loc29_++;
                              }
                              if(_loc19_.length != 0)
                              {
                                 _loc27_ -= _loc32_;
                              }
                           }
                           break;
                        }
                        if(!_loc17_)
                        {
                           _loc19_.pop();
                           while(_loc27_ < _loc31_ - 1 && param3.charCodeAt(_loc27_) != 10)
                           {
                              _loc27_++;
                           }
                        }
                        break;
                        _loc33_ = true;
                     }
                  }
                  if(_loc27_ == _loc31_ - 1)
                  {
                     sLines[sLines.length] = _loc19_;
                     _loc28_ = true;
                  }
                  else if(_loc33_)
                  {
                     sLines[sLines.length] = _loc19_;
                     if(_loc23_ == _loc27_)
                     {
                        _loc19_.pop();
                     }
                     if(_loc15_ + _loc10_ + 2 * _lineHeight > _loc34_)
                     {
                        break;
                     }
                     _loc19_ = CharLocation.vectorFromPool();
                     _loc35_ = 0;
                     _loc15_ += _lineHeight + _loc10_;
                     _loc23_ = -1;
                     _loc36_ = -1;
                  }
                  _loc27_++;
               }
            }
            if(_loc17_ && !_loc28_ && _loc39_ > 3)
            {
               _loc39_ -= 1;
            }
            else
            {
               _loc28_ = true;
            }
         }
         var _loc20_:Vector.<CharLocation> = CharLocation.vectorFromPool();
         var _loc9_:int = int(sLines.length);
         var _loc25_:Number = _loc15_ + _lineHeight;
         var _loc7_:int = 0;
         if(_loc16_ == "bottom")
         {
            _loc7_ = _loc34_ - _loc25_;
         }
         else if(_loc16_ == "center")
         {
            _loc7_ = (_loc34_ - _loc25_) / 2;
         }
         _loc14_ = 0;
         while(_loc14_ < _loc9_)
         {
            if((_loc31_ = int((_loc12_ = sLines[_loc14_]).length)) != 0)
            {
               _loc21_ = 0;
               _loc30_ = (_loc26_ = _loc12_[_loc12_.length - 1]).x - _loc26_.char.xOffset + _loc26_.char.xAdvance;
               if(_loc8_ == "right")
               {
                  _loc21_ = _loc18_ - _loc30_;
               }
               else if(_loc8_ == "center")
               {
                  _loc21_ = (_loc18_ - _loc30_) / 2;
               }
               _loc22_ = 0;
               while(_loc22_ < _loc31_)
               {
                  (_loc38_ = _loc12_[_loc22_]).x = _loc13_ * (_loc38_.x + _loc21_ + _offsetX) + _padding;
                  _loc38_.y = _loc13_ * (_loc38_.y + _loc7_ + _offsetY) + _padding;
                  _loc38_.scale = _loc13_;
                  if(_loc38_.char.width > 0 && _loc38_.char.height > 0)
                  {
                     _loc20_[_loc20_.length] = _loc38_;
                  }
                  _loc22_++;
               }
            }
            _loc14_++;
         }
         return _loc20_;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get size() : Number
      {
         return _size;
      }
      
      public function get lineHeight() : Number
      {
         return _lineHeight;
      }
      
      public function set lineHeight(param1:Number) : void
      {
         _lineHeight = param1;
      }
      
      public function get smoothing() : String
      {
         return _helperImage.textureSmoothing;
      }
      
      public function set smoothing(param1:String) : void
      {
         _helperImage.textureSmoothing = param1;
      }
      
      public function get baseline() : Number
      {
         return _baseline;
      }
      
      public function set baseline(param1:Number) : void
      {
         _baseline = param1;
      }
      
      public function get offsetX() : Number
      {
         return _offsetX;
      }
      
      public function set offsetX(param1:Number) : void
      {
         _offsetX = param1;
      }
      
      public function get offsetY() : Number
      {
         return _offsetY;
      }
      
      public function set offsetY(param1:Number) : void
      {
         _offsetY = param1;
      }
      
      public function get padding() : Number
      {
         return _padding;
      }
      
      public function set padding(param1:Number) : void
      {
         _padding = param1;
      }
      
      public function get texture() : Texture
      {
         return _texture;
      }
   }
}

import starling.text.BitmapChar;

class CharLocation
{
   
   private static var sInstancePool:Vector.<CharLocation> = new Vector.<CharLocation>(0);
   
   private static var sVectorPool:Array = [];
   
   private static var sInstanceLoan:Vector.<CharLocation> = new Vector.<CharLocation>(0);
   
   private static var sVectorLoan:Array = [];
    
   
   public var char:BitmapChar;
   
   public var scale:Number;
   
   public var x:Number;
   
   public var y:Number;
   
   public function CharLocation(param1:BitmapChar)
   {
      super();
      reset(param1);
   }
   
   public static function instanceFromPool(param1:BitmapChar) : CharLocation
   {
      var _loc2_:CharLocation = sInstancePool.length > 0 ? sInstancePool.pop() : new CharLocation(param1);
      _loc2_.reset(param1);
      sInstanceLoan[sInstanceLoan.length] = _loc2_;
      return _loc2_;
   }
   
   public static function vectorFromPool() : Vector.<CharLocation>
   {
      var _loc1_:Vector.<CharLocation> = sVectorPool.length > 0 ? sVectorPool.pop() : new Vector.<CharLocation>(0);
      _loc1_.length = 0;
      sVectorLoan[sVectorLoan.length] = _loc1_;
      return _loc1_;
   }
   
   public static function rechargePool() : void
   {
      var _loc1_:CharLocation = null;
      var _loc2_:* = undefined;
      while(sInstanceLoan.length > 0)
      {
         _loc1_ = sInstanceLoan.pop();
         _loc1_.char = null;
         sInstancePool[sInstancePool.length] = _loc1_;
      }
      while(sVectorLoan.length > 0)
      {
         _loc2_ = sVectorLoan.pop();
         _loc2_.length = 0;
         sVectorPool[sVectorPool.length] = _loc2_;
      }
   }
   
   private function reset(param1:BitmapChar) : CharLocation
   {
      this.char = param1;
      return this;
   }
}
