package starling.text
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.MeshBatch;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.rendering.Painter;
   import starling.styles.MeshStyle;
   import starling.utils.RectangleUtil;
   import starling.utils.SystemUtil;
   
   public class TextField extends DisplayObjectContainer
   {
      
      private static const COMPOSITOR_DATA_NAME:String = "starling.display.TextField.compositors";
      
      private static var sMatrix:Matrix = new Matrix();
      
      private static var sDefaultCompositor:ITextCompositor = new TrueTypeCompositor();
      
      private static var sDefaultTextureFormat:String = "bgraPacked4444";
      
      private static var sStringCache:Dictionary = new Dictionary();
       
      
      private var _text:String;
      
      private var _options:TextOptions;
      
      private var _format:TextFormat;
      
      private var _textBounds:Rectangle;
      
      private var _hitArea:Rectangle;
      
      private var _compositor:ITextCompositor;
      
      private var _requiresRecomposition:Boolean;
      
      private var _border:DisplayObjectContainer;
      
      private var _meshBatch:MeshBatch;
      
      private var _style:MeshStyle;
      
      private var _helperFormat:TextFormat;
      
      public function TextField(param1:int, param2:int, param3:String = "", param4:TextFormat = null)
      {
         _helperFormat = new TextFormat();
         super();
         _text = !!param3 ? param3 : "";
         _hitArea = new Rectangle(0,0,param1,param2);
         _requiresRecomposition = true;
         _compositor = sDefaultCompositor;
         _options = new TextOptions();
         _format = !!param4 ? param4.clone() : new TextFormat();
         _format.addEventListener("change",setRequiresRecomposition);
         _meshBatch = new MeshBatch();
         _meshBatch.touchable = false;
         _meshBatch.pixelSnapping = true;
         addChild(_meshBatch);
      }
      
      public static function get defaultTextureFormat() : String
      {
         return sDefaultTextureFormat;
      }
      
      public static function set defaultTextureFormat(param1:String) : void
      {
         sDefaultTextureFormat = param1;
      }
      
      public static function get defaultCompositor() : ITextCompositor
      {
         return sDefaultCompositor;
      }
      
      public static function set defaultCompositor(param1:ITextCompositor) : void
      {
         sDefaultCompositor = param1;
      }
      
      public static function updateEmbeddedFonts() : void
      {
         SystemUtil.updateEmbeddedFonts();
      }
      
      public static function registerCompositor(param1:ITextCompositor, param2:String) : void
      {
         if(param2 == null)
         {
            throw new ArgumentError("name must not be null");
         }
         compositors[convertToLowerCase(param2)] = param1;
      }
      
      public static function unregisterCompositor(param1:String, param2:Boolean = true) : void
      {
         param1 = convertToLowerCase(param1);
         if(param2 && compositors[param1] != undefined)
         {
            compositors[param1].dispose();
         }
         delete compositors[param1];
      }
      
      public static function getCompositor(param1:String) : ITextCompositor
      {
         return compositors[convertToLowerCase(param1)];
      }
      
      public static function registerBitmapFont(param1:BitmapFont, param2:String = null) : String
      {
         if(param2 == null)
         {
            param2 = param1.name;
         }
         registerCompositor(param1,param2);
         return param2;
      }
      
      public static function unregisterBitmapFont(param1:String, param2:Boolean = true) : void
      {
         unregisterCompositor(param1,param2);
      }
      
      public static function getBitmapFont(param1:String) : BitmapFont
      {
         return getCompositor(param1) as BitmapFont;
      }
      
      private static function get compositors() : Dictionary
      {
         var _loc1_:Dictionary = Starling.painter.sharedData["starling.display.TextField.compositors"] as Dictionary;
         if(_loc1_ == null)
         {
            _loc1_ = new Dictionary();
            Starling.painter.sharedData["starling.display.TextField.compositors"] = _loc1_;
         }
         return _loc1_;
      }
      
      private static function convertToLowerCase(param1:String) : String
      {
         var _loc2_:String = String(sStringCache[param1]);
         if(_loc2_ == null)
         {
            _loc2_ = param1.toLowerCase();
            sStringCache[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         _format.removeEventListener("change",setRequiresRecomposition);
         _compositor.clearMeshBatch(_meshBatch);
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         if(_requiresRecomposition)
         {
            recompose();
         }
         super.render(param1);
      }
      
      private function recompose() : void
      {
         var _loc1_:String = null;
         var _loc2_:ITextCompositor = null;
         if(_requiresRecomposition)
         {
            _compositor.clearMeshBatch(_meshBatch);
            _loc1_ = _format.font;
            _loc2_ = getCompositor(_loc1_);
            if(_loc2_ == null && _loc1_ == "mini")
            {
               _loc2_ = new BitmapFont();
               registerCompositor(_loc2_,_loc1_);
            }
            _compositor = !!_loc2_ ? _loc2_ : sDefaultCompositor;
            updateText();
            updateBorder();
            _requiresRecomposition = false;
         }
      }
      
      private function updateText() : void
      {
         var _loc1_:Number = _hitArea.width;
         var _loc3_:Number = _hitArea.height;
         var _loc2_:TextFormat = _helperFormat;
         _loc2_.copyFrom(_format);
         if(isHorizontalAutoSize && !_options.isHtmlText)
         {
            _loc1_ = 100000;
         }
         if(isVerticalAutoSize)
         {
            _loc3_ = 100000;
         }
         _meshBatch.x = _meshBatch.y = 0;
         _options.textureScale = Starling.contentScaleFactor;
         _options.textureFormat = sDefaultTextureFormat;
         _compositor.fillMeshBatch(_meshBatch,_loc1_,_loc3_,_text,_loc2_,_options);
         if(_style)
         {
            _meshBatch.style = _style;
         }
         if(_options.autoSize != "none")
         {
            _textBounds = _meshBatch.getBounds(_meshBatch,_textBounds);
            if(isHorizontalAutoSize)
            {
               _meshBatch.x = _textBounds.x = -_textBounds.x;
               _hitArea.width = _textBounds.width;
               _textBounds.x = 0;
            }
            if(isVerticalAutoSize)
            {
               _meshBatch.y = _textBounds.y = -_textBounds.y;
               _hitArea.height = _textBounds.height;
               _textBounds.y = 0;
            }
         }
         else
         {
            _textBounds = null;
         }
      }
      
      private function updateBorder() : void
      {
         if(_border == null)
         {
            return;
         }
         var _loc4_:Number = _hitArea.width;
         var _loc6_:Number = _hitArea.height;
         var _loc1_:Quad = _border.getChildAt(0) as Quad;
         var _loc3_:Quad = _border.getChildAt(1) as Quad;
         var _loc5_:Quad = _border.getChildAt(2) as Quad;
         var _loc2_:Quad = _border.getChildAt(3) as Quad;
         _loc1_.width = _loc4_;
         _loc1_.height = 1;
         _loc5_.width = _loc4_;
         _loc5_.height = 1;
         _loc2_.width = 1;
         _loc2_.height = _loc6_;
         _loc3_.width = 1;
         _loc3_.height = _loc6_;
         _loc3_.x = _loc4_ - 1;
         _loc5_.y = _loc6_ - 1;
         _loc1_.color = _loc3_.color = _loc5_.color = _loc2_.color = _format.color;
      }
      
      protected function setRequiresRecomposition() : void
      {
         _requiresRecomposition = true;
         setRequiresRedraw();
      }
      
      private function get isHorizontalAutoSize() : Boolean
      {
         return _options.autoSize == "horizontal" || _options.autoSize == "bothDirections";
      }
      
      private function get isVerticalAutoSize() : Boolean
      {
         return _options.autoSize == "vertical" || _options.autoSize == "bothDirections";
      }
      
      public function get textBounds() : Rectangle
      {
         if(_requiresRecomposition)
         {
            recompose();
         }
         if(_textBounds == null)
         {
            _textBounds = _meshBatch.getBounds(this);
         }
         return _textBounds.clone();
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         if(_requiresRecomposition)
         {
            recompose();
         }
         getTransformationMatrix(param1,sMatrix);
         return RectangleUtil.getBounds(_hitArea,sMatrix,param2);
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         if(!visible || !touchable || !hitTestMask(param1))
         {
            return null;
         }
         if(_hitArea.containsPoint(param1))
         {
            return this;
         }
         return null;
      }
      
      override public function set width(param1:Number) : void
      {
         _hitArea.width = param1 / (scaleX || 1);
         setRequiresRecomposition();
      }
      
      override public function set height(param1:Number) : void
      {
         _hitArea.height = param1 / (scaleY || 1);
         setRequiresRecomposition();
      }
      
      public function get text() : String
      {
         return _text;
      }
      
      public function set text(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         if(_text != param1)
         {
            _text = param1;
            setRequiresRecomposition();
         }
      }
      
      public function get format() : TextFormat
      {
         return _format;
      }
      
      public function set format(param1:TextFormat) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("format cannot be null");
         }
         _format.copyFrom(param1);
      }
      
      public function get border() : Boolean
      {
         return _border != null;
      }
      
      public function set border(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(param1 && _border == null)
         {
            _border = new Sprite();
            addChild(_border);
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               _border.addChild(new Quad(1,1));
               _loc2_++;
            }
            updateBorder();
         }
         else if(!param1 && _border != null)
         {
            _border.removeFromParent(true);
            _border = null;
         }
      }
      
      public function get autoScale() : Boolean
      {
         return _options.autoScale;
      }
      
      public function set autoScale(param1:Boolean) : void
      {
         if(_options.autoScale != param1)
         {
            _options.autoScale = param1;
            setRequiresRecomposition();
         }
      }
      
      public function get autoSize() : String
      {
         return _options.autoSize;
      }
      
      public function set autoSize(param1:String) : void
      {
         if(_options.autoSize != param1)
         {
            _options.autoSize = param1;
            setRequiresRecomposition();
         }
      }
      
      public function get wordWrap() : Boolean
      {
         return _options.wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(param1 != _options.wordWrap)
         {
            _options.wordWrap = param1;
            setRequiresRecomposition();
         }
      }
      
      public function get batchable() : Boolean
      {
         return _meshBatch.batchable;
      }
      
      public function set batchable(param1:Boolean) : void
      {
         _meshBatch.batchable = param1;
      }
      
      public function get isHtmlText() : Boolean
      {
         return _options.isHtmlText;
      }
      
      public function set isHtmlText(param1:Boolean) : void
      {
         if(_options.isHtmlText != param1)
         {
            _options.isHtmlText = param1;
            setRequiresRecomposition();
         }
      }
      
      public function get styleSheet() : StyleSheet
      {
         return _options.styleSheet;
      }
      
      public function set styleSheet(param1:StyleSheet) : void
      {
         _options.styleSheet = param1;
         setRequiresRecomposition();
      }
      
      public function get pixelSnapping() : Boolean
      {
         return _meshBatch.pixelSnapping;
      }
      
      public function set pixelSnapping(param1:Boolean) : void
      {
         _meshBatch.pixelSnapping = param1;
      }
      
      public function get style() : MeshStyle
      {
         return _meshBatch.style;
      }
      
      public function set style(param1:MeshStyle) : void
      {
         _meshBatch.style = _style = param1;
         setRequiresRecomposition();
      }
   }
}
