package starling.text
{
   import flash.text.TextFormat;
   import starling.events.EventDispatcher;
   import starling.utils.Align;
   
   public class TextFormat extends EventDispatcher
   {
       
      
      private var _font:String;
      
      private var _size:Number;
      
      private var _color:uint;
      
      private var _bold:Boolean;
      
      private var _italic:Boolean;
      
      private var _underline:Boolean;
      
      private var _horizontalAlign:String;
      
      private var _verticalAlign:String;
      
      private var _kerning:Boolean;
      
      private var _leading:Number;
      
      private var _letterSpacing:Number;
      
      public function TextFormat(param1:String = "Verdana", param2:Number = 12, param3:uint = 0, param4:String = "center", param5:String = "center")
      {
         super();
         _font = param1;
         _size = param2;
         _color = param3;
         _horizontalAlign = param4;
         _verticalAlign = param5;
         _kerning = true;
         _letterSpacing = _leading = 0;
      }
      
      public function copyFrom(param1:starling.text.TextFormat) : void
      {
         _font = param1._font;
         _size = param1._size;
         _color = param1._color;
         _bold = param1._bold;
         _italic = param1._italic;
         _underline = param1._underline;
         _horizontalAlign = param1._horizontalAlign;
         _verticalAlign = param1._verticalAlign;
         _kerning = param1._kerning;
         _leading = param1._leading;
         _letterSpacing = param1._letterSpacing;
         dispatchEventWith("change");
      }
      
      public function clone() : starling.text.TextFormat
      {
         var _loc1_:starling.text.TextFormat = new starling.text.TextFormat();
         _loc1_.copyFrom(this);
         return _loc1_;
      }
      
      public function setTo(param1:String = "Verdana", param2:Number = 12, param3:uint = 0, param4:String = "center", param5:String = "center") : void
      {
         _font = param1;
         _size = param2;
         _color = param3;
         _horizontalAlign = param4;
         _verticalAlign = param5;
         dispatchEventWith("change");
      }
      
      public function toNativeFormat(param1:flash.text.TextFormat = null) : flash.text.TextFormat
      {
         if(param1 == null)
         {
            param1 = new flash.text.TextFormat();
         }
         param1.font = _font;
         param1.size = _size;
         param1.color = _color;
         param1.bold = _bold;
         param1.italic = _italic;
         param1.underline = _underline;
         param1.align = _horizontalAlign;
         param1.kerning = _kerning;
         param1.leading = _leading;
         param1.letterSpacing = _letterSpacing;
         return param1;
      }
      
      public function get font() : String
      {
         return _font;
      }
      
      public function set font(param1:String) : void
      {
         if(param1 != _font)
         {
            _font = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get size() : Number
      {
         return _size;
      }
      
      public function set size(param1:Number) : void
      {
         if(param1 != _size)
         {
            _size = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function set color(param1:uint) : void
      {
         if(param1 != _color)
         {
            _color = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get bold() : Boolean
      {
         return _bold;
      }
      
      public function set bold(param1:Boolean) : void
      {
         if(param1 != _bold)
         {
            _bold = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get italic() : Boolean
      {
         return _italic;
      }
      
      public function set italic(param1:Boolean) : void
      {
         if(param1 != _italic)
         {
            _italic = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get underline() : Boolean
      {
         return _underline;
      }
      
      public function set underline(param1:Boolean) : void
      {
         if(param1 != _underline)
         {
            _underline = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get horizontalAlign() : String
      {
         return _horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(!Align.isValidHorizontal(param1))
         {
            throw new ArgumentError("Invalid horizontal alignment");
         }
         if(param1 != _horizontalAlign)
         {
            _horizontalAlign = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get verticalAlign() : String
      {
         return _verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(!Align.isValidVertical(param1))
         {
            throw new ArgumentError("Invalid vertical alignment");
         }
         if(param1 != _verticalAlign)
         {
            _verticalAlign = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get kerning() : Boolean
      {
         return _kerning;
      }
      
      public function set kerning(param1:Boolean) : void
      {
         if(param1 != _kerning)
         {
            _kerning = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get leading() : Number
      {
         return _leading;
      }
      
      public function set leading(param1:Number) : void
      {
         if(param1 != _leading)
         {
            _leading = param1;
            dispatchEventWith("change");
         }
      }
      
      public function get letterSpacing() : Number
      {
         return _letterSpacing;
      }
      
      public function set letterSpacing(param1:Number) : void
      {
         if(param1 != _letterSpacing)
         {
            _letterSpacing = param1;
            dispatchEventWith("change");
         }
      }
   }
}
