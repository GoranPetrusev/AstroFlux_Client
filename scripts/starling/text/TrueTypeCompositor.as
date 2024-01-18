package starling.text
{
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import starling.display.MeshBatch;
   import starling.display.Quad;
   import starling.textures.Texture;
   import starling.utils.SystemUtil;
   
   public class TrueTypeCompositor implements ITextCompositor
   {
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sHelperQuad:Quad = new Quad(100,100);
      
      private static var sNativeTextField:flash.text.TextField = new flash.text.TextField();
      
      private static var sNativeFormat:flash.text.TextFormat = new flash.text.TextFormat();
       
      
      public function TrueTypeCompositor()
      {
         super();
      }
      
      public function dispose() : void
      {
      }
      
      public function fillMeshBatch(param1:MeshBatch, param2:Number, param3:Number, param4:String, param5:starling.text.TextFormat, param6:TextOptions = null) : void
      {
         var texture:Texture;
         var textureFormat:String;
         var bitmapData:BitmapDataEx;
         var meshBatch:MeshBatch = param1;
         var width:Number = param2;
         var height:Number = param3;
         var text:String = param4;
         var format:starling.text.TextFormat = param5;
         var options:TextOptions = param6;
         if(text == null || text == "")
         {
            return;
         }
         textureFormat = options.textureFormat;
         bitmapData = renderText(width,height,text,format,options);
         texture = Texture.fromBitmapData(bitmapData,false,false,bitmapData.scale,textureFormat);
         texture.root.onRestore = function():void
         {
            bitmapData = renderText(width,height,text,format,options);
            texture.root.uploadBitmapData(bitmapData);
            bitmapData.dispose();
            bitmapData = null;
         };
         bitmapData.dispose();
         bitmapData = null;
         sHelperQuad.texture = texture;
         sHelperQuad.readjustSize();
         if(format.horizontalAlign == "left")
         {
            sHelperQuad.x = 0;
         }
         else if(format.horizontalAlign == "center")
         {
            sHelperQuad.x = int((width - texture.width) / 2);
         }
         else
         {
            sHelperQuad.x = width - texture.width;
         }
         if(format.verticalAlign == "top")
         {
            sHelperQuad.y = 0;
         }
         else if(format.verticalAlign == "center")
         {
            sHelperQuad.y = int((height - texture.height) / 2);
         }
         else
         {
            sHelperQuad.y = height - texture.height;
         }
         meshBatch.addMesh(sHelperQuad);
         sHelperQuad.texture = null;
      }
      
      public function clearMeshBatch(param1:MeshBatch) : void
      {
         param1.clear();
         if(param1.texture)
         {
            param1.texture.dispose();
         }
      }
      
      private function renderText(param1:Number, param2:Number, param3:String, param4:starling.text.TextFormat, param5:TextOptions) : BitmapDataEx
      {
         var _loc16_:BitmapDataEx = null;
         var _loc7_:Number = param1 * param5.textureScale;
         var _loc15_:Number = param2 * param5.textureScale;
         var _loc6_:String = param4.horizontalAlign;
         param4.toNativeFormat(sNativeFormat);
         sNativeFormat.size = Number(sNativeFormat.size) * param5.textureScale;
         sNativeTextField.embedFonts = SystemUtil.isEmbeddedFont(param4.font,param4.bold,param4.italic);
         sNativeTextField.styleSheet = null;
         sNativeTextField.defaultTextFormat = sNativeFormat;
         sNativeTextField.styleSheet = param5.styleSheet;
         sNativeTextField.width = _loc7_;
         sNativeTextField.height = _loc15_;
         sNativeTextField.antiAliasType = "advanced";
         sNativeTextField.selectable = false;
         sNativeTextField.multiline = true;
         sNativeTextField.wordWrap = param5.wordWrap;
         if(param5.isHtmlText)
         {
            sNativeTextField.htmlText = param3;
         }
         else
         {
            sNativeTextField.text = param3;
         }
         if(param5.autoScale)
         {
            autoScaleNativeTextField(sNativeTextField,param3,param5.isHtmlText);
         }
         var _loc9_:Number = sNativeTextField.textWidth;
         var _loc10_:Number = sNativeTextField.textHeight;
         var _loc13_:int = Math.ceil(_loc9_) + 4;
         var _loc14_:int = Math.ceil(_loc10_) + 4;
         var _loc8_:int = Texture.maxSize;
         var _loc11_:int = 1;
         var _loc12_:Number = 0;
         if(param5.isHtmlText)
         {
            _loc9_ = _loc13_ = _loc7_;
         }
         if(_loc13_ < _loc11_)
         {
            _loc13_ = 1;
         }
         if(_loc14_ < _loc11_)
         {
            _loc14_ = 1;
         }
         if(_loc14_ > _loc8_ || _loc13_ > _loc8_)
         {
            param5.textureScale *= _loc8_ / Math.max(_loc13_,_loc14_);
            return renderText(param1,param2,param3,param4,param5);
         }
         if(!param5.isHtmlText)
         {
            if(_loc6_ == "right")
            {
               _loc12_ = _loc7_ - _loc9_ - 4;
            }
            else if(_loc6_ == "center")
            {
               _loc12_ = (_loc7_ - _loc9_ - 4) / 2;
            }
         }
         _loc16_ = new BitmapDataEx(_loc13_,_loc14_);
         sHelperMatrix.setTo(1,0,0,1,-_loc12_,0);
         _loc16_.draw(sNativeTextField,sHelperMatrix);
         _loc16_.scale = param5.textureScale;
         sNativeTextField.text = "";
         return _loc16_;
      }
      
      private function autoScaleNativeTextField(param1:flash.text.TextField, param2:String, param3:Boolean) : void
      {
         var _loc7_:flash.text.TextFormat = param1.defaultTextFormat;
         var _loc5_:int = param1.width - 4;
         var _loc6_:int = param1.height - 4;
         var _loc4_:Number = Number(_loc7_.size);
         while(param1.textWidth > _loc5_ || param1.textHeight > _loc6_)
         {
            if(_loc4_ <= 4)
            {
               break;
            }
            _loc7_.size = _loc4_--;
            param1.defaultTextFormat = _loc7_;
            if(param3)
            {
               param1.htmlText = param2;
            }
            else
            {
               param1.text = param2;
            }
         }
      }
   }
}

import flash.display.BitmapData;

class BitmapDataEx extends BitmapData
{
    
   
   private var _scale:Number = 1;
   
   public function BitmapDataEx(param1:int, param2:int, param3:Boolean = true, param4:uint = 0)
   {
      super(param1,param2,param3,param4);
   }
   
   public function get scale() : Number
   {
      return _scale;
   }
   
   public function set scale(param1:Number) : void
   {
      _scale = param1;
   }
}
