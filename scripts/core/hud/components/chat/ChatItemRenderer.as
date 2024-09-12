package core.hud.components.chat
{
    import feathers.controls.Label;
    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.core.FeathersControl;
    import starling.display.Quad;
    import starling.display.DisplayObject;
    import starling.events.Event;
 
    public class ChatItemRenderer extends FeathersControl implements IListItemRenderer
    {

        protected var _label:Label;
 
        protected var _index:int = -1;
 
        protected var _owner:List;
 
        protected var _data:Object;

        protected var _factoryID:String;
 
        protected var _padding:Number = 0;
  
        protected var _isSelected:Boolean;

        protected var _backgroundSkin:DisplayObject;
        
        public function ChatItemRenderer()
        {
            var bg:Quad = new Quad(1, 1, 0);
            bg.alpha = 0.0;
            this.backgroundSkin = bg;
        }

        public function get label():Label
        {
            return this._label;
        }
 
        public function get backgroundSkin():DisplayObject
        {
            return this._backgroundSkin;
        }
        
        public function set backgroundSkin(value:DisplayObject):void
        {
            if(this._backgroundSkin == value)
            {
                return;
            }
            if(this._backgroundSkin)
            {
                this.removeChild(this._backgroundSkin, true);
            }
            this._backgroundSkin = value;
            if(this._backgroundSkin)
            {
                this.addChildAt(this._backgroundSkin, 0);
            }
            this.invalidate(INVALIDATION_FLAG_SKIN);
        }

        public function get index():int
        {
            return this._index;
        }
 
        public function set index(value:int):void
        {
            if(this._index == value)
            {
                return;
            }
            this._index = value;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }
 
        public function get owner():List
        {
            return this._owner;
        }
 
        public function set owner(value:List):void
        {
            if(this._owner == value)
            {
                return;
            }
            this._owner = value;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }
 
        public function get data():Object
        {
            return this._data;
        }
 
        public function set data(value:Object):void
        {
            if(this._data == value)
            {
                return;
            }
            this._data = value;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get factoryID():String
        {
            return this._factoryID;
        }

        public function set factoryID(value:String):void
        {
            this._factoryID = value;
        }
 
        public function get isSelected():Boolean
        {
            return this._isSelected;
        }
 
        public function set isSelected(value:Boolean):void
        {
            if(this._isSelected == value)
            {
                return;
            }
            this._isSelected = value;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
            this.dispatchEventWith(Event.CHANGE);
        }
 
        public function get padding():Number
        {
            return this._padding;
        }
 
        public function set padding(value:Number):void
        {
            if(this._padding == value)
            {
                return;
            }
            this._padding = value;
            this.invalidate(INVALIDATION_FLAG_LAYOUT);
        }
 
        override protected function initialize():void
        {
            if(!this._label)
            {
                this._label = new Label();
                this._label.styleName = "chat";
                this.addChild(this._label);
            }
        }
 
        override protected function draw():void
        {
            var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
 
            if(dataInvalid)
            {
                this.commitData();
            }
 
            this.autoSizeIfNeeded();
            this.layoutChildren();
        }
 
        protected function autoSizeIfNeeded():Boolean
        {
            var needsWidth:Boolean = isNaN(this.explicitWidth);
            var needsHeight:Boolean = isNaN(this.explicitHeight);
            if(!needsWidth && !needsHeight)
            {
                return false;
            }
 
            this._label.width = this.explicitWidth - 2 * this._padding;
            this._label.height = this.explicitHeight - 2 * this._padding;
            this._label.validate();
 
            var newWidth:Number = this.explicitWidth;
            if(needsWidth)
            {
                newWidth = this._label.width + 2 * this._padding;
                var backgroundWidth:Number = this._backgroundSkin.width;
                if(backgroundWidth > newWidth)
                {
                    newWidth = backgroundWidth;
                }
            }
            var newHeight:Number = this.explicitHeight;
            if(needsHeight)
            {
                newHeight = this._label.height + 2 * this._padding;
                var backgroundHeight:Number = this._backgroundSkin.height;
                if(backgroundHeight > newHeight)
                {
                    newHeight = backgroundHeight;
                }
            }
 
            return this.saveMeasurements(newWidth, newHeight, newWidth, newHeight);
        }
 
        protected function commitData():void
        {
            if(this._data)
            {
                this._label.text = this._data.contents;
            }
            else
            {
                this._label.text = null;
            }
        }
 
        protected function layoutChildren():void
        {
            if(this._backgroundSkin)
            {
                this._backgroundSkin.width = this.actualWidth;
                this._backgroundSkin.height = this.actualHeight;
            }

            this._label.x = this._padding;
            this._label.y = this._padding;
            this._label.width = this.actualWidth - 2 * this._padding;
            this._label.height = this.actualHeight - 2 * this._padding;
        }
    }
}