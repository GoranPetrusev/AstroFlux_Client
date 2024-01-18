package feathers.media
{
   import feathers.controls.ToggleButton;
   import feathers.controls.popups.DropDownPopUpContentManager;
   import feathers.controls.popups.IPopUpContentManager;
   import feathers.core.PropertyProxy;
   import feathers.skins.IStyleProvider;
   import flash.media.SoundTransform;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class MuteToggleButton extends ToggleButton implements IMediaPlayerControl
   {
      
      protected static const INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY:String = "volumeSliderFactory";
      
      public static const DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER:String = "feathers-volume-toggle-button-volume-slider";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var volumeSliderStyleName:String = "feathers-volume-toggle-button-volume-slider";
      
      protected var slider:VolumeSlider;
      
      protected var _oldVolume:Number;
      
      protected var _ignoreChanges:Boolean = false;
      
      protected var _touchPointID:int = -1;
      
      protected var _popUpTouchPointID:int = -1;
      
      protected var _mediaPlayer:IAudioPlayer;
      
      protected var _popUpContentManager:IPopUpContentManager;
      
      protected var _showVolumeSliderOnHover:Boolean = false;
      
      protected var _volumeSliderFactory:Function;
      
      protected var _customVolumeSliderStyleName:String;
      
      protected var _volumeSliderProperties:PropertyProxy;
      
      protected var _isOpenPopUpPending:Boolean = false;
      
      protected var _isClosePopUpPending:Boolean = false;
      
      public function MuteToggleButton()
      {
         super();
         this.addEventListener("change",muteToggleButton_changeHandler);
         this.addEventListener("touch",muteToggleButton_touchHandler);
      }
      
      protected static function defaultVolumeSliderFactory() : VolumeSlider
      {
         var _loc1_:VolumeSlider = new VolumeSlider();
         _loc1_.direction = "vertical";
         return _loc1_;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return MuteToggleButton.globalStyleProvider;
      }
      
      public function get mediaPlayer() : IMediaPlayer
      {
         return this._mediaPlayer;
      }
      
      public function set mediaPlayer(param1:IMediaPlayer) : void
      {
         if(this._mediaPlayer == param1)
         {
            return;
         }
         this._mediaPlayer = param1 as IAudioPlayer;
         this.refreshVolumeFromMediaPlayer();
         if(this._mediaPlayer)
         {
            this._mediaPlayer.addEventListener("soundTransformChange",mediaPlayer_soundTransformChangeHandler);
         }
         this.invalidate("data");
      }
      
      public function get popUpContentManager() : IPopUpContentManager
      {
         return this._popUpContentManager;
      }
      
      public function set popUpContentManager(param1:IPopUpContentManager) : void
      {
         var _loc2_:EventDispatcher = null;
         if(this._popUpContentManager == param1)
         {
            return;
         }
         if(this._popUpContentManager is EventDispatcher)
         {
            _loc2_ = EventDispatcher(this._popUpContentManager);
            _loc2_.removeEventListener("open",popUpContentManager_openHandler);
            _loc2_.removeEventListener("close",popUpContentManager_closeHandler);
         }
         this._popUpContentManager = param1;
         if(this._popUpContentManager is EventDispatcher)
         {
            _loc2_ = EventDispatcher(this._popUpContentManager);
            _loc2_.addEventListener("open",popUpContentManager_openHandler);
            _loc2_.addEventListener("close",popUpContentManager_closeHandler);
         }
         this.invalidate("styles");
      }
      
      public function get showVolumeSliderOnHover() : Boolean
      {
         return this._showVolumeSliderOnHover;
      }
      
      public function set showVolumeSliderOnHover(param1:Boolean) : void
      {
         if(this._showVolumeSliderOnHover == param1)
         {
            return;
         }
         this._showVolumeSliderOnHover = param1;
         this.invalidate("volumeSliderFactory");
      }
      
      public function get volumeSliderFactory() : Function
      {
         return this._volumeSliderFactory;
      }
      
      public function set volumeSliderFactory(param1:Function) : void
      {
         if(this._volumeSliderFactory == param1)
         {
            return;
         }
         this._volumeSliderFactory = param1;
         this.invalidate("volumeSliderFactory");
      }
      
      public function get customVolumeSliderStyleName() : String
      {
         return this._customVolumeSliderStyleName;
      }
      
      public function set customVolumeSliderStyleName(param1:String) : void
      {
         if(this._customVolumeSliderStyleName == param1)
         {
            return;
         }
         this._customVolumeSliderStyleName = param1;
         this.invalidate("volumeSliderFactory");
      }
      
      public function get volumeSliderProperties() : Object
      {
         if(!this._volumeSliderProperties)
         {
            this._volumeSliderProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._volumeSliderProperties;
      }
      
      public function set volumeSliderProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         if(this._volumeSliderProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            param1 = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc2_ = new PropertyProxy();
            for(var _loc3_ in param1)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
            param1 = _loc2_;
         }
         if(this._volumeSliderProperties)
         {
            this._volumeSliderProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._volumeSliderProperties = PropertyProxy(param1);
         if(this._volumeSliderProperties)
         {
            this._volumeSliderProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function openPopUp() : void
      {
         this._isClosePopUpPending = false;
         if(this._popUpContentManager.isOpen)
         {
            return;
         }
         if(!this._isValidating && this.isInvalid())
         {
            this._isOpenPopUpPending = true;
            return;
         }
         this._isOpenPopUpPending = false;
         this._popUpContentManager.open(this.slider,this);
         this.slider.validate();
         this._popUpTouchPointID = -1;
         this.slider.addEventListener("touch",volumeSlider_touchHandler);
      }
      
      public function closePopUp() : void
      {
         this._isOpenPopUpPending = false;
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(!this._isValidating && this.isInvalid())
         {
            this._isClosePopUpPending = true;
            return;
         }
         this._isClosePopUpPending = false;
         this.slider.validate();
         this._popUpContentManager.close();
      }
      
      override public function dispose() : void
      {
         if(this.slider)
         {
            this.closePopUp();
            this.slider.mediaPlayer = null;
            this.slider.dispose();
            this.slider = null;
         }
         if(this._popUpContentManager)
         {
            this._popUpContentManager.dispose();
            this._popUpContentManager = null;
         }
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         var _loc1_:DropDownPopUpContentManager = null;
         if(!this._popUpContentManager)
         {
            _loc1_ = new DropDownPopUpContentManager();
            _loc1_.fitContentMinWidthToOrigin = false;
            _loc1_.primaryDirection = "up";
            this.popUpContentManager = _loc1_;
         }
         super.initialize();
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("volumeSliderFactory");
         if(_loc1_)
         {
            this.createVolumeSlider();
         }
         if(this.slider && (_loc1_ || _loc2_))
         {
            this.refreshVolumeSliderProperties();
         }
         super.draw();
         this.handlePendingActions();
      }
      
      protected function createVolumeSlider() : void
      {
         if(this.slider)
         {
            this.slider.removeFromParent(false);
            this.slider.dispose();
            this.slider = null;
         }
         if(!this._showVolumeSliderOnHover)
         {
            return;
         }
         var _loc1_:Function = this._volumeSliderFactory != null ? this._volumeSliderFactory : defaultVolumeSliderFactory;
         var _loc2_:String = this._customVolumeSliderStyleName != null ? this._customVolumeSliderStyleName : this.volumeSliderStyleName;
         this.slider = VolumeSlider(_loc1_());
         this.slider.focusOwner = this;
         this.slider.styleNameList.add(_loc2_);
      }
      
      protected function refreshVolumeSliderProperties() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._volumeSliderProperties)
         {
            _loc2_ = this._volumeSliderProperties[_loc1_];
            this.slider[_loc1_] = _loc2_;
         }
         this.slider.mediaPlayer = this._mediaPlayer;
      }
      
      protected function handlePendingActions() : void
      {
         if(this._isOpenPopUpPending)
         {
            this.openPopUp();
         }
         if(this._isClosePopUpPending)
         {
            this.closePopUp();
         }
      }
      
      protected function refreshVolumeFromMediaPlayer() : void
      {
         var _loc1_:Boolean = this._ignoreChanges;
         this._ignoreChanges = true;
         if(this._mediaPlayer)
         {
            this.isSelected = this._mediaPlayer.soundTransform.volume == 0;
         }
         else
         {
            this.isSelected = false;
         }
         this._ignoreChanges = _loc1_;
      }
      
      protected function mediaPlayer_soundTransformChangeHandler(param1:Event) : void
      {
         this.refreshVolumeFromMediaPlayer();
      }
      
      protected function muteToggleButton_changeHandler(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(this._ignoreChanges || !this._mediaPlayer)
         {
            return;
         }
         var _loc3_:SoundTransform = this._mediaPlayer.soundTransform;
         if(this._isSelected)
         {
            this._oldVolume = _loc3_.volume;
            if(this._oldVolume === 0)
            {
               this._oldVolume = 1;
            }
            _loc3_.volume = 0;
            this._mediaPlayer.soundTransform = _loc3_;
         }
         else
         {
            _loc2_ = this._oldVolume;
            if(_loc2_ !== _loc2_)
            {
               _loc2_ = 1;
            }
            _loc3_.volume = _loc2_;
            this._mediaPlayer.soundTransform = _loc3_;
         }
      }
      
      protected function muteToggleButton_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this.slider)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this,null,this._touchPointID);
            if(_loc2_)
            {
               return;
            }
            this._touchPointID = -1;
            _loc2_ = param1.getTouch(this.slider);
            if(this._popUpTouchPointID < 0 && !_loc2_)
            {
               this.closePopUp();
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this,"hover");
            if(!_loc2_)
            {
               return;
            }
            this._touchPointID = _loc2_.id;
            this.openPopUp();
         }
      }
      
      protected function volumeSlider_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(this._popUpTouchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.slider,null,this._popUpTouchPointID);
            if(_loc2_)
            {
               return;
            }
            this._popUpTouchPointID = -1;
            _loc2_ = param1.getTouch(this);
            if(this._touchPointID < 0 && !_loc2_)
            {
               this.closePopUp();
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this.slider,"hover");
            if(!_loc2_)
            {
               return;
            }
            this._popUpTouchPointID = _loc2_.id;
         }
      }
      
      protected function popUpContentManager_openHandler(param1:Event) : void
      {
         this.dispatchEventWith("open");
      }
      
      protected function popUpContentManager_closeHandler(param1:Event) : void
      {
         this.slider.removeEventListener("touch",volumeSlider_touchHandler);
         this.dispatchEventWith("close");
      }
   }
}
