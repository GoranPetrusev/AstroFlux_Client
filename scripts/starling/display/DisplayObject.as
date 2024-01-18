package starling.display
{
   import flash.errors.IllegalOperationError;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.system.Capabilities;
   import flash.ui.Mouse;
   import flash.utils.getQualifiedClassName;
   import starling.core.Starling;
   import starling.core.starling_internal;
   import starling.errors.AbstractClassError;
   import starling.errors.AbstractMethodError;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.TouchEvent;
   import starling.filters.FragmentFilter;
   import starling.rendering.BatchToken;
   import starling.rendering.Painter;
   import starling.utils.MathUtil;
   import starling.utils.MatrixUtil;
   import starling.utils.SystemUtil;
   
   use namespace starling_internal;
   
   public class DisplayObject extends EventDispatcher
   {
      
      private static var sAncestors:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sHelperPoint3D:Vector3D = new Vector3D();
      
      private static var sHelperPointAlt3D:Vector3D = new Vector3D();
      
      private static var sHelperRect:Rectangle = new Rectangle();
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sHelperMatrixAlt:Matrix = new Matrix();
      
      private static var sHelperMatrix3D:Matrix3D = new Matrix3D();
      
      private static var sHelperMatrixAlt3D:Matrix3D = new Matrix3D();
      
      private static var sMaskWarningShown:Boolean = false;
       
      
      private var _x:Number;
      
      private var _y:Number;
      
      private var _pivotX:Number;
      
      private var _pivotY:Number;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _skewX:Number;
      
      private var _skewY:Number;
      
      private var _rotation:Number;
      
      private var _alpha:Number;
      
      private var _visible:Boolean;
      
      private var _touchable:Boolean;
      
      private var _blendMode:String;
      
      private var _name:String;
      
      private var _useHandCursor:Boolean;
      
      private var _transformationMatrix:Matrix;
      
      private var _transformationMatrix3D:Matrix3D;
      
      private var _orientationChanged:Boolean;
      
      private var _is3D:Boolean;
      
      private var _maskee:DisplayObject;
      
      internal var _parent:DisplayObjectContainer;
      
      internal var _lastParentOrSelfChangeFrameID:uint;
      
      internal var _lastChildChangeFrameID:uint;
      
      internal var _tokenFrameID:uint;
      
      internal var _pushToken:BatchToken;
      
      internal var _popToken:BatchToken;
      
      internal var _hasVisibleArea:Boolean;
      
      internal var _filter:FragmentFilter;
      
      internal var _mask:DisplayObject;
      
      public function DisplayObject()
      {
         _pushToken = new BatchToken();
         _popToken = new BatchToken();
         super();
         if(Capabilities.isDebugger && getQualifiedClassName(this) == "starling.display::DisplayObject")
         {
            throw new AbstractClassError();
         }
         _x = _y = _pivotX = _pivotY = _rotation = _skewX = _skewY = 0;
         _scaleX = _scaleY = _alpha = 1;
         _visible = _touchable = _hasVisibleArea = true;
         _blendMode = "auto";
         _transformationMatrix = new Matrix();
      }
      
      private static function findCommonParent(param1:DisplayObject, param2:DisplayObject) : DisplayObject
      {
         var _loc3_:* = param1;
         while(_loc3_)
         {
            sAncestors[sAncestors.length] = _loc3_;
            _loc3_ = _loc3_._parent;
         }
         _loc3_ = param2;
         while(_loc3_ && sAncestors.indexOf(_loc3_) == -1)
         {
            _loc3_ = _loc3_._parent;
         }
         sAncestors.length = 0;
         if(_loc3_)
         {
            return _loc3_;
         }
         throw new ArgumentError("Object not connected to target");
      }
      
      public function dispose() : void
      {
         if(_filter)
         {
            _filter.dispose();
         }
         if(_mask)
         {
            _mask.dispose();
         }
         removeEventListeners();
         mask = null;
      }
      
      public function removeFromParent(param1:Boolean = false) : void
      {
         if(_parent)
         {
            _parent.removeChild(this,param1);
         }
         else if(param1)
         {
            this.dispose();
         }
      }
      
      public function getTransformationMatrix(param1:DisplayObject, param2:Matrix = null) : Matrix
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:* = null;
         if(param2)
         {
            param2.identity();
         }
         else
         {
            param2 = new Matrix();
         }
         if(param1 == this)
         {
            return param2;
         }
         if(param1 == _parent || param1 == null && _parent == null)
         {
            param2.copyFrom(transformationMatrix);
            return param2;
         }
         if(param1 == null || param1 == base)
         {
            _loc4_ = this;
            while(_loc4_ != param1)
            {
               param2.concat(_loc4_.transformationMatrix);
               _loc4_ = _loc4_._parent;
            }
            return param2;
         }
         if(param1._parent == this)
         {
            param1.getTransformationMatrix(this,param2);
            param2.invert();
            return param2;
         }
         _loc3_ = findCommonParent(this,param1);
         _loc4_ = this;
         while(_loc4_ != _loc3_)
         {
            param2.concat(_loc4_.transformationMatrix);
            _loc4_ = _loc4_._parent;
         }
         if(_loc3_ == param1)
         {
            return param2;
         }
         sHelperMatrix.identity();
         _loc4_ = param1;
         while(_loc4_ != _loc3_)
         {
            sHelperMatrix.concat(_loc4_.transformationMatrix);
            _loc4_ = _loc4_._parent;
         }
         sHelperMatrix.invert();
         param2.concat(sHelperMatrix);
         return param2;
      }
      
      public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         throw new AbstractMethodError();
      }
      
      public function hitTest(param1:Point) : DisplayObject
      {
         if(!_visible || !_touchable)
         {
            return null;
         }
         if(_mask && !hitTestMask(param1))
         {
            return null;
         }
         if(getBounds(this,sHelperRect).containsPoint(param1))
         {
            return this;
         }
         return null;
      }
      
      public function hitTestMask(param1:Point) : Boolean
      {
         var _loc2_:Point = null;
         if(_mask)
         {
            if(_mask.stage)
            {
               getTransformationMatrix(_mask,sHelperMatrixAlt);
            }
            else
            {
               sHelperMatrixAlt.copyFrom(_mask.transformationMatrix);
               sHelperMatrixAlt.invert();
            }
            _loc2_ = param1 == sHelperPoint ? new Point() : sHelperPoint;
            MatrixUtil.transformPoint(sHelperMatrixAlt,param1,_loc2_);
            return _mask.hitTest(_loc2_) != null;
         }
         return true;
      }
      
      public function localToGlobal(param1:Point, param2:Point = null) : Point
      {
         if(is3D)
         {
            sHelperPoint3D.setTo(param1.x,param1.y,0);
            return local3DToGlobal(sHelperPoint3D,param2);
         }
         getTransformationMatrix(base,sHelperMatrixAlt);
         return MatrixUtil.transformPoint(sHelperMatrixAlt,param1,param2);
      }
      
      public function globalToLocal(param1:Point, param2:Point = null) : Point
      {
         if(is3D)
         {
            globalToLocal3D(param1,sHelperPoint3D);
            stage.getCameraPosition(this,sHelperPointAlt3D);
            return MathUtil.intersectLineWithXYPlane(sHelperPointAlt3D,sHelperPoint3D,param2);
         }
         getTransformationMatrix(base,sHelperMatrixAlt);
         sHelperMatrixAlt.invert();
         return MatrixUtil.transformPoint(sHelperMatrixAlt,param1,param2);
      }
      
      public function render(param1:Painter) : void
      {
         throw new AbstractMethodError();
      }
      
      public function alignPivot(param1:String = "center", param2:String = "center") : void
      {
         var _loc3_:Rectangle = getBounds(this,sHelperRect);
         setOrientationChanged();
         if(param1 == "left")
         {
            _pivotX = _loc3_.x;
         }
         else if(param1 == "center")
         {
            _pivotX = _loc3_.x + _loc3_.width / 2;
         }
         else
         {
            if(param1 != "right")
            {
               throw new ArgumentError("Invalid horizontal alignment: " + param1);
            }
            _pivotX = _loc3_.x + _loc3_.width;
         }
         if(param2 == "top")
         {
            _pivotY = _loc3_.y;
         }
         else if(param2 == "center")
         {
            _pivotY = _loc3_.y + _loc3_.height / 2;
         }
         else
         {
            if(param2 != "bottom")
            {
               throw new ArgumentError("Invalid vertical alignment: " + param2);
            }
            _pivotY = _loc3_.y + _loc3_.height;
         }
      }
      
      public function getTransformationMatrix3D(param1:DisplayObject, param2:Matrix3D = null) : Matrix3D
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:* = null;
         if(param2)
         {
            param2.identity();
         }
         else
         {
            param2 = new Matrix3D();
         }
         if(param1 == this)
         {
            return param2;
         }
         if(param1 == _parent || param1 == null && _parent == null)
         {
            param2.copyFrom(transformationMatrix3D);
            return param2;
         }
         if(param1 == null || param1 == base)
         {
            _loc4_ = this;
            while(_loc4_ != param1)
            {
               param2.append(_loc4_.transformationMatrix3D);
               _loc4_ = _loc4_._parent;
            }
            return param2;
         }
         if(param1._parent == this)
         {
            param1.getTransformationMatrix3D(this,param2);
            param2.invert();
            return param2;
         }
         _loc3_ = findCommonParent(this,param1);
         _loc4_ = this;
         while(_loc4_ != _loc3_)
         {
            param2.append(_loc4_.transformationMatrix3D);
            _loc4_ = _loc4_._parent;
         }
         if(_loc3_ == param1)
         {
            return param2;
         }
         sHelperMatrix3D.identity();
         _loc4_ = param1;
         while(_loc4_ != _loc3_)
         {
            sHelperMatrix3D.append(_loc4_.transformationMatrix3D);
            _loc4_ = _loc4_._parent;
         }
         sHelperMatrix3D.invert();
         param2.append(sHelperMatrix3D);
         return param2;
      }
      
      public function local3DToGlobal(param1:Vector3D, param2:Point = null) : Point
      {
         var _loc3_:Stage = this.stage;
         if(_loc3_ == null)
         {
            throw new IllegalOperationError("Object not connected to stage");
         }
         getTransformationMatrix3D(_loc3_,sHelperMatrixAlt3D);
         MatrixUtil.transformPoint3D(sHelperMatrixAlt3D,param1,sHelperPoint3D);
         return MathUtil.intersectLineWithXYPlane(_loc3_.cameraPosition,sHelperPoint3D,param2);
      }
      
      public function globalToLocal3D(param1:Point, param2:Vector3D = null) : Vector3D
      {
         var _loc3_:Stage = this.stage;
         if(_loc3_ == null)
         {
            throw new IllegalOperationError("Object not connected to stage");
         }
         getTransformationMatrix3D(_loc3_,sHelperMatrixAlt3D);
         sHelperMatrixAlt3D.invert();
         return MatrixUtil.transformCoords3D(sHelperMatrixAlt3D,param1.x,param1.y,0,param2);
      }
      
      starling_internal function setParent(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObject = param1;
         while(_loc2_ != this && _loc2_ != null)
         {
            _loc2_ = _loc2_._parent;
         }
         if(_loc2_ == this)
         {
            throw new ArgumentError("An object cannot be added as a child to itself or one of its children (or children\'s children, etc.)");
         }
         _parent = param1;
      }
      
      internal function setIs3D(param1:Boolean) : void
      {
         _is3D = param1;
      }
      
      internal function get isMask() : Boolean
      {
         return _maskee != null;
      }
      
      public function setRequiresRedraw() : void
      {
         var _loc1_:DisplayObject = _parent || _maskee;
         var _loc2_:int = int(Starling.frameID);
         _lastParentOrSelfChangeFrameID = _loc2_;
         _hasVisibleArea = _alpha != 0 && _visible && _maskee == null && _scaleX != 0 && _scaleY != 0;
         while(_loc1_ && _loc1_._lastChildChangeFrameID != _loc2_)
         {
            _loc1_._lastChildChangeFrameID = _loc2_;
            _loc1_ = _loc1_._parent || _loc1_._maskee;
         }
      }
      
      public function get requiresRedraw() : Boolean
      {
         var _loc1_:uint = Starling.frameID;
         return _lastParentOrSelfChangeFrameID == _loc1_ || _lastChildChangeFrameID == _loc1_;
      }
      
      starling_internal function excludeFromCache() : void
      {
         var _loc2_:* = this;
         var _loc1_:Number = 4294967295;
         while(_loc2_ && _loc2_._tokenFrameID != _loc1_)
         {
            _loc2_._tokenFrameID = _loc1_;
            _loc2_ = _loc2_._parent;
         }
      }
      
      private function setOrientationChanged() : void
      {
         _orientationChanged = true;
         setRequiresRedraw();
      }
      
      override public function dispatchEvent(param1:Event) : void
      {
         if(param1.type == "removedFromStage" && stage == null)
         {
            return;
         }
         super.dispatchEvent(param1);
      }
      
      override public function addEventListener(param1:String, param2:Function) : void
      {
         if(param1 == "enterFrame" && !hasEventListener(param1))
         {
            addEventListener("addedToStage",addEnterFrameListenerToStage);
            addEventListener("removedFromStage",removeEnterFrameListenerFromStage);
            if(this.stage)
            {
               addEnterFrameListenerToStage();
            }
         }
         super.addEventListener(param1,param2);
      }
      
      override public function removeEventListener(param1:String, param2:Function) : void
      {
         super.removeEventListener(param1,param2);
         if(param1 == "enterFrame" && !hasEventListener(param1))
         {
            removeEventListener("addedToStage",addEnterFrameListenerToStage);
            removeEventListener("removedFromStage",removeEnterFrameListenerFromStage);
            removeEnterFrameListenerFromStage();
         }
      }
      
      override public function removeEventListeners(param1:String = null) : void
      {
         if((param1 == null || param1 == "enterFrame") && hasEventListener("enterFrame"))
         {
            removeEventListener("addedToStage",addEnterFrameListenerToStage);
            removeEventListener("removedFromStage",removeEnterFrameListenerFromStage);
            removeEnterFrameListenerFromStage();
         }
         super.removeEventListeners(param1);
      }
      
      private function addEnterFrameListenerToStage() : void
      {
         Starling.current.stage.addEnterFrameListener(this);
      }
      
      private function removeEnterFrameListenerFromStage() : void
      {
         Starling.current.stage.removeEnterFrameListener(this);
      }
      
      public function get transformationMatrix() : Matrix
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(_orientationChanged)
         {
            _orientationChanged = false;
            if(_skewX == 0 && _skewY == 0)
            {
               if(_rotation == 0)
               {
                  _transformationMatrix.setTo(_scaleX,0,0,_scaleY,_x - _pivotX * _scaleX,_y - _pivotY * _scaleY);
               }
               else
               {
                  _loc7_ = Math.cos(_rotation);
                  _loc8_ = Math.sin(_rotation);
                  _loc1_ = _scaleX * _loc7_;
                  _loc2_ = _scaleX * _loc8_;
                  _loc3_ = _scaleY * -_loc8_;
                  _loc4_ = _scaleY * _loc7_;
                  _loc5_ = _x - _pivotX * _loc1_ - _pivotY * _loc3_;
                  _loc6_ = _y - _pivotX * _loc2_ - _pivotY * _loc4_;
                  _transformationMatrix.setTo(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
               }
            }
            else
            {
               _transformationMatrix.identity();
               _transformationMatrix.scale(_scaleX,_scaleY);
               MatrixUtil.skew(_transformationMatrix,_skewX,_skewY);
               _transformationMatrix.rotate(_rotation);
               _transformationMatrix.translate(_x,_y);
               if(_pivotX != 0 || _pivotY != 0)
               {
                  _transformationMatrix.tx = _x - _transformationMatrix.a * _pivotX - _transformationMatrix.c * _pivotY;
                  _transformationMatrix.ty = _y - _transformationMatrix.b * _pivotX - _transformationMatrix.d * _pivotY;
               }
            }
         }
         return _transformationMatrix;
      }
      
      public function set transformationMatrix(param1:Matrix) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = 0.7853981633974483;
         setRequiresRedraw();
         _orientationChanged = false;
         _transformationMatrix.copyFrom(param1);
         _pivotX = _pivotY = 0;
         _x = param1.tx;
         _y = param1.ty;
         _skewX = Math.atan(-param1.c / param1.d);
         _skewY = Math.atan(param1.b / param1.a);
         if(_skewX != _skewX)
         {
            _skewX = 0;
         }
         if(_skewY != _skewY)
         {
            _skewY = 0;
         }
         _scaleY = _skewX > -0.7853981633974483 && _skewX < 0.7853981633974483 ? param1.d / Math.cos(_skewX) : -param1.c / Math.sin(_skewX);
         _scaleX = _skewY > -0.7853981633974483 && _skewY < 0.7853981633974483 ? param1.a / Math.cos(_skewY) : param1.b / Math.sin(_skewY);
         if(MathUtil.isEquivalent(_skewX,_skewY))
         {
            _rotation = _skewX;
            _skewX = _skewY = 0;
         }
         else
         {
            _rotation = 0;
         }
      }
      
      public function get transformationMatrix3D() : Matrix3D
      {
         if(_transformationMatrix3D == null)
         {
            _transformationMatrix3D = new Matrix3D();
         }
         return MatrixUtil.convertTo3D(transformationMatrix,_transformationMatrix3D);
      }
      
      public function get is3D() : Boolean
      {
         return _is3D;
      }
      
      public function get useHandCursor() : Boolean
      {
         return _useHandCursor;
      }
      
      public function set useHandCursor(param1:Boolean) : void
      {
         if(param1 == _useHandCursor)
         {
            return;
         }
         _useHandCursor = param1;
         if(_useHandCursor)
         {
            addEventListener("touch",onTouch);
         }
         else
         {
            removeEventListener("touch",onTouch);
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         Mouse.cursor = param1.interactsWith(this) ? "button" : "auto";
      }
      
      public function get bounds() : Rectangle
      {
         return getBounds(_parent);
      }
      
      public function get width() : Number
      {
         return getBounds(_parent,sHelperRect).width;
      }
      
      public function set width(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = _scaleX != _scaleX;
         if(_scaleX == 0 || _loc3_)
         {
            scaleX = 1;
            _loc2_ = width;
         }
         else
         {
            _loc2_ = Math.abs(width / _scaleX);
         }
         if(_loc2_)
         {
            scaleX = param1 / _loc2_;
         }
      }
      
      public function get height() : Number
      {
         return getBounds(_parent,sHelperRect).height;
      }
      
      public function set height(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = _scaleY != _scaleY;
         if(_scaleY == 0 || _loc3_)
         {
            scaleY = 1;
            _loc2_ = height;
         }
         else
         {
            _loc2_ = Math.abs(height / _scaleY);
         }
         if(_loc2_)
         {
            scaleY = param1 / _loc2_;
         }
      }
      
      public function get x() : Number
      {
         return _x;
      }
      
      public function set x(param1:Number) : void
      {
         if(_x != param1)
         {
            _x = param1;
            setOrientationChanged();
         }
      }
      
      public function get y() : Number
      {
         return _y;
      }
      
      public function set y(param1:Number) : void
      {
         if(_y != param1)
         {
            _y = param1;
            setOrientationChanged();
         }
      }
      
      public function get pivotX() : Number
      {
         return _pivotX;
      }
      
      public function set pivotX(param1:Number) : void
      {
         if(_pivotX != param1)
         {
            _pivotX = param1;
            setOrientationChanged();
         }
      }
      
      public function get pivotY() : Number
      {
         return _pivotY;
      }
      
      public function set pivotY(param1:Number) : void
      {
         if(_pivotY != param1)
         {
            _pivotY = param1;
            setOrientationChanged();
         }
      }
      
      public function get scaleX() : Number
      {
         return _scaleX;
      }
      
      public function set scaleX(param1:Number) : void
      {
         if(_scaleX != param1)
         {
            _scaleX = param1;
            setOrientationChanged();
         }
      }
      
      public function get scaleY() : Number
      {
         return _scaleY;
      }
      
      public function set scaleY(param1:Number) : void
      {
         if(_scaleY != param1)
         {
            _scaleY = param1;
            setOrientationChanged();
         }
      }
      
      public function get scale() : Number
      {
         return scaleX;
      }
      
      public function set scale(param1:Number) : void
      {
         scaleX = scaleY = param1;
      }
      
      public function get skewX() : Number
      {
         return _skewX;
      }
      
      public function set skewX(param1:Number) : void
      {
         param1 = MathUtil.normalizeAngle(param1);
         if(_skewX != param1)
         {
            _skewX = param1;
            setOrientationChanged();
         }
      }
      
      public function get skewY() : Number
      {
         return _skewY;
      }
      
      public function set skewY(param1:Number) : void
      {
         param1 = MathUtil.normalizeAngle(param1);
         if(_skewY != param1)
         {
            _skewY = param1;
            setOrientationChanged();
         }
      }
      
      public function get rotation() : Number
      {
         return _rotation;
      }
      
      public function set rotation(param1:Number) : void
      {
         param1 = MathUtil.normalizeAngle(param1);
         if(_rotation != param1)
         {
            _rotation = param1;
            setOrientationChanged();
         }
      }
      
      internal function get isRotated() : Boolean
      {
         return _rotation != 0 || _skewX != 0 || _skewY != 0;
      }
      
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(param1 != _alpha)
         {
            _alpha = param1 < 0 ? 0 : (param1 > 1 ? 1 : param1);
            setRequiresRedraw();
         }
      }
      
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(param1 != _visible)
         {
            _visible = param1;
            setRequiresRedraw();
         }
      }
      
      public function get touchable() : Boolean
      {
         return _touchable;
      }
      
      public function set touchable(param1:Boolean) : void
      {
         _touchable = param1;
      }
      
      public function get blendMode() : String
      {
         return _blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         if(param1 != _blendMode)
         {
            _blendMode = param1;
            setRequiresRedraw();
         }
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function get filter() : FragmentFilter
      {
         return _filter;
      }
      
      public function set filter(param1:FragmentFilter) : void
      {
         if(param1 != _filter)
         {
            if(_filter)
            {
               _filter.starling_internal::setTarget(null);
            }
            if(param1)
            {
               param1.starling_internal::setTarget(this);
            }
            _filter = param1;
            setRequiresRedraw();
         }
      }
      
      public function get mask() : DisplayObject
      {
         return _mask;
      }
      
      public function set mask(param1:DisplayObject) : void
      {
         if(_mask != param1)
         {
            if(!sMaskWarningShown)
            {
               if(!SystemUtil.supportsDepthAndStencil)
               {
                  trace("[Starling] Full mask support requires \'depthAndStencil\' to be enabled in the application descriptor.");
               }
               sMaskWarningShown = true;
            }
            if(_mask)
            {
               _mask._maskee = null;
            }
            if(param1)
            {
               param1._maskee = this;
               param1._hasVisibleArea = false;
            }
            _mask = param1;
            setRequiresRedraw();
         }
      }
      
      public function get parent() : DisplayObjectContainer
      {
         return _parent;
      }
      
      public function get base() : DisplayObject
      {
         var _loc1_:* = this;
         while(_loc1_._parent)
         {
            _loc1_ = _loc1_._parent;
         }
         return _loc1_;
      }
      
      public function get root() : DisplayObject
      {
         var _loc1_:* = this;
         while(_loc1_._parent)
         {
            if(_loc1_._parent is Stage)
            {
               return _loc1_;
            }
            _loc1_ = _loc1_.parent;
         }
         return null;
      }
      
      public function get stage() : Stage
      {
         return this.base as Stage;
      }
   }
}
