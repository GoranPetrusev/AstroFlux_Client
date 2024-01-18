package starling.display
{
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.styles.MeshStyle;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   
   public class Button extends DisplayObjectContainer
   {
      
      private static const MAX_DRAG_DIST:Number = 50;
       
      
      private var _upState:Texture;
      
      private var _downState:Texture;
      
      private var _overState:Texture;
      
      private var _disabledState:Texture;
      
      private var _contents:Sprite;
      
      private var _body:Image;
      
      private var _textField:TextField;
      
      private var _textBounds:Rectangle;
      
      private var _overlay:Sprite;
      
      private var _scaleWhenDown:Number;
      
      private var _scaleWhenOver:Number;
      
      private var _alphaWhenDown:Number;
      
      private var _alphaWhenDisabled:Number;
      
      private var _useHandCursor:Boolean;
      
      private var _enabled:Boolean;
      
      private var _state:String;
      
      private var _triggerBounds:Rectangle;
      
      public function Button(param1:Texture, param2:String = "", param3:Texture = null, param4:Texture = null, param5:Texture = null)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("Texture \'upState\' cannot be null");
         }
         _upState = param1;
         _downState = param3;
         _overState = param4;
         _disabledState = param5;
         _state = "up";
         _body = new Image(param1);
         _body.pixelSnapping = true;
         _scaleWhenDown = !!param3 ? 1 : 0.9;
         _scaleWhenOver = _alphaWhenDown = 1;
         _alphaWhenDisabled = !!param5 ? 1 : 0.5;
         _enabled = true;
         _useHandCursor = true;
         _textBounds = new Rectangle(0,0,_body.width,_body.height);
         _triggerBounds = new Rectangle();
         _contents = new Sprite();
         _contents.addChild(_body);
         addChild(_contents);
         addEventListener("touch",onTouch);
         this.touchGroup = true;
         this.text = param2;
      }
      
      override public function dispose() : void
      {
         if(_textField)
         {
            _textField.dispose();
         }
         super.dispose();
      }
      
      public function readjustSize() : void
      {
         var _loc1_:Number = _body.width;
         var _loc4_:Number = _body.height;
         _body.readjustSize();
         var _loc2_:Number = _body.width / _loc1_;
         var _loc3_:Number = _body.height / _loc4_;
         _textBounds.x *= _loc2_;
         _textBounds.y *= _loc3_;
         _textBounds.width *= _loc2_;
         _textBounds.height *= _loc3_;
         if(_textField)
         {
            createTextField();
         }
      }
      
      private function createTextField() : void
      {
         if(_textField == null)
         {
            _textField = new TextField(_textBounds.width,_textBounds.height);
            _textField.pixelSnapping = _body.pixelSnapping;
            _textField.touchable = false;
            _textField.autoScale = true;
            _textField.batchable = true;
         }
         _textField.width = _textBounds.width;
         _textField.height = _textBounds.height;
         _textField.x = _textBounds.x;
         _textField.y = _textBounds.y;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Boolean = false;
         Mouse.cursor = _useHandCursor && _enabled && param1.interactsWith(this) ? "button" : "auto";
         var _loc2_:Touch = param1.getTouch(this);
         if(!_enabled)
         {
            return;
         }
         if(_loc2_ == null)
         {
            state = "up";
         }
         else if(_loc2_.phase == "hover")
         {
            state = "over";
         }
         else if(_loc2_.phase == "began" && _state != "down")
         {
            _triggerBounds = getBounds(stage,_triggerBounds);
            _triggerBounds.inflate(50,50);
            state = "down";
         }
         else if(_loc2_.phase == "moved")
         {
            _loc3_ = _triggerBounds.contains(_loc2_.globalX,_loc2_.globalY);
            if(_state == "down" && !_loc3_)
            {
               state = "up";
            }
            else if(_state == "up" && _loc3_)
            {
               state = "down";
            }
         }
         else if(_loc2_.phase == "ended" && _state == "down")
         {
            state = "up";
            if(!_loc2_.cancelled)
            {
               dispatchEventWith("triggered",true);
            }
         }
      }
      
      public function get state() : String
      {
         return _state;
      }
      
      public function set state(param1:String) : void
      {
         _state = param1;
         _contents.x = _contents.y = 0;
         _contents.scaleX = _contents.scaleY = _contents.alpha = 1;
         switch(_state)
         {
            case "down":
               setStateTexture(_downState);
               _contents.alpha = _alphaWhenDown;
               _contents.scaleX = _contents.scaleY = _scaleWhenDown;
               _contents.x = (1 - _scaleWhenDown) / 2 * _body.width;
               _contents.y = (1 - _scaleWhenDown) / 2 * _body.height;
               break;
            case "up":
               setStateTexture(_upState);
               break;
            case "over":
               setStateTexture(_overState);
               _contents.scaleX = _contents.scaleY = _scaleWhenOver;
               _contents.x = (1 - _scaleWhenOver) / 2 * _body.width;
               _contents.y = (1 - _scaleWhenOver) / 2 * _body.height;
               break;
            case "disabled":
               setStateTexture(_disabledState);
               _contents.alpha = _alphaWhenDisabled;
               break;
            default:
               throw new ArgumentError("Invalid button state: " + _state);
         }
      }
      
      private function setStateTexture(param1:Texture) : void
      {
         _body.texture = !!param1 ? param1 : _upState;
      }
      
      public function get scaleWhenDown() : Number
      {
         return _scaleWhenDown;
      }
      
      public function set scaleWhenDown(param1:Number) : void
      {
         _scaleWhenDown = param1;
      }
      
      public function get scaleWhenOver() : Number
      {
         return _scaleWhenOver;
      }
      
      public function set scaleWhenOver(param1:Number) : void
      {
         _scaleWhenOver = param1;
      }
      
      public function get alphaWhenDown() : Number
      {
         return _alphaWhenDown;
      }
      
      public function set alphaWhenDown(param1:Number) : void
      {
         _alphaWhenDown = param1;
      }
      
      public function get alphaWhenDisabled() : Number
      {
         return _alphaWhenDisabled;
      }
      
      public function set alphaWhenDisabled(param1:Number) : void
      {
         _alphaWhenDisabled = param1;
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(_enabled != param1)
         {
            _enabled = param1;
            state = param1 ? "up" : "disabled";
         }
      }
      
      public function get text() : String
      {
         return !!_textField ? _textField.text : "";
      }
      
      public function set text(param1:String) : void
      {
         if(param1.length == 0)
         {
            if(_textField)
            {
               _textField.text = param1;
               _textField.removeFromParent();
            }
         }
         else
         {
            createTextField();
            _textField.text = param1;
            if(_textField.parent == null)
            {
               _contents.addChild(_textField);
            }
         }
      }
      
      public function get textFormat() : TextFormat
      {
         if(_textField == null)
         {
            createTextField();
         }
         return _textField.format;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         if(_textField == null)
         {
            createTextField();
         }
         _textField.format = param1;
      }
      
      public function get textStyle() : MeshStyle
      {
         if(_textField == null)
         {
            createTextField();
         }
         return _textField.style;
      }
      
      public function set textStyle(param1:MeshStyle) : void
      {
         if(_textField == null)
         {
            createTextField();
         }
         _textField.style = param1;
      }
      
      public function get style() : MeshStyle
      {
         return _body.style;
      }
      
      public function set style(param1:MeshStyle) : void
      {
         _body.style = param1;
      }
      
      public function get upState() : Texture
      {
         return _upState;
      }
      
      public function set upState(param1:Texture) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("Texture \'upState\' cannot be null");
         }
         if(_upState != param1)
         {
            _upState = param1;
            if(_state == "up" || _state == "disabled" && _disabledState == null || _state == "down" && _downState == null || _state == "over" && _overState == null)
            {
               setStateTexture(param1);
            }
         }
      }
      
      public function get downState() : Texture
      {
         return _downState;
      }
      
      public function set downState(param1:Texture) : void
      {
         if(_downState != param1)
         {
            _downState = param1;
            if(_state == "down")
            {
               setStateTexture(param1);
            }
         }
      }
      
      public function get overState() : Texture
      {
         return _overState;
      }
      
      public function set overState(param1:Texture) : void
      {
         if(_overState != param1)
         {
            _overState = param1;
            if(_state == "over")
            {
               setStateTexture(param1);
            }
         }
      }
      
      public function get disabledState() : Texture
      {
         return _disabledState;
      }
      
      public function set disabledState(param1:Texture) : void
      {
         if(_disabledState != param1)
         {
            _disabledState = param1;
            if(_state == "disabled")
            {
               setStateTexture(param1);
            }
         }
      }
      
      public function get textBounds() : Rectangle
      {
         return _textBounds;
      }
      
      public function set textBounds(param1:Rectangle) : void
      {
         _textBounds.copyFrom(param1);
         createTextField();
      }
      
      public function get color() : uint
      {
         return _body.color;
      }
      
      public function set color(param1:uint) : void
      {
         _body.color = param1;
      }
      
      public function get textureSmoothing() : String
      {
         return _body.textureSmoothing;
      }
      
      public function set textureSmoothing(param1:String) : void
      {
         _body.textureSmoothing = param1;
      }
      
      public function get overlay() : Sprite
      {
         if(_overlay == null)
         {
            _overlay = new Sprite();
         }
         _contents.addChild(_overlay);
         return _overlay;
      }
      
      override public function get useHandCursor() : Boolean
      {
         return _useHandCursor;
      }
      
      override public function set useHandCursor(param1:Boolean) : void
      {
         _useHandCursor = param1;
      }
      
      public function get pixelSnapping() : Boolean
      {
         return _body.pixelSnapping;
      }
      
      public function set pixelSnapping(param1:Boolean) : void
      {
         _body.pixelSnapping = param1;
         if(_textField)
         {
            _textField.pixelSnapping = param1;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:Number = param1 / (this.scaleX || 1);
         var _loc3_:Number = _loc2_ / (_body.width || 1);
         _body.width = _loc2_;
         _textBounds.x *= _loc3_;
         _textBounds.width *= _loc3_;
         if(_textField)
         {
            _textField.width = _loc2_;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc2_:Number = param1 / (this.scaleY || 1);
         var _loc3_:Number = _loc2_ / (_body.height || 1);
         _body.height = _loc2_;
         _textBounds.y *= _loc3_;
         _textBounds.height *= _loc3_;
         if(_textField)
         {
            _textField.height = _loc2_;
         }
      }
      
      public function get scale9Grid() : Rectangle
      {
         return _body.scale9Grid;
      }
      
      public function set scale9Grid(param1:Rectangle) : void
      {
         _body.scale9Grid = param1;
      }
   }
}
