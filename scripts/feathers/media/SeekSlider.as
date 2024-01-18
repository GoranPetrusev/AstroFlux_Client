package feathers.media
{
   import feathers.controls.Slider;
   import feathers.core.IValidating;
   import feathers.skins.IStyleProvider;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class SeekSlider extends Slider implements IMediaPlayerControl
   {
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";
      
      public static const TRACK_LAYOUT_MODE_MIN_MAX:String = "minMax";
      
      public static const TRACK_SCALE_MODE_EXACT_FIT:String = "exactFit";
      
      public static const TRACK_SCALE_MODE_DIRECTIONAL:String = "directional";
      
      public static const TRACK_INTERACTION_MODE_TO_VALUE:String = "toValue";
      
      public static const TRACK_INTERACTION_MODE_BY_PAGE:String = "byPage";
      
      public static const DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-seek-slider-minimum-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-seek-slider-maximum-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-seek-slider-thumb";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var _mediaPlayer:ITimedMediaPlayer;
      
      protected var _progress:Number = 0;
      
      protected var _progressSkin:DisplayObject;
      
      public function SeekSlider()
      {
         super();
         this.thumbStyleName = "feathers-seek-slider-thumb";
         this.minimumTrackStyleName = "feathers-seek-slider-minimum-track";
         this.maximumTrackStyleName = "feathers-seek-slider-maximum-track";
         this.addEventListener("change",seekSlider_changeHandler);
         this.addEventListener("endInteraction",seekSlider_endInteractionHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return SeekSlider.globalStyleProvider;
      }
      
      public function get mediaPlayer() : IMediaPlayer
      {
         return this._mediaPlayer;
      }
      
      public function set mediaPlayer(param1:IMediaPlayer) : void
      {
         var _loc2_:IProgressiveMediaPlayer = null;
         if(this._mediaPlayer == param1)
         {
            return;
         }
         if(this._mediaPlayer)
         {
            this._mediaPlayer.removeEventListener("loadProgress",mediaPlayer_loadProgressHandler);
            this._mediaPlayer.removeEventListener("currentTimeChange",mediaPlayer_currentTimeChangeHandler);
            this._mediaPlayer.removeEventListener("totalTimeChange",mediaPlayer_totalTimeChangeHandler);
         }
         this._mediaPlayer = param1 as ITimedMediaPlayer;
         if(this._mediaPlayer)
         {
            this._mediaPlayer.addEventListener("currentTimeChange",mediaPlayer_currentTimeChangeHandler);
            this._mediaPlayer.addEventListener("totalTimeChange",mediaPlayer_totalTimeChangeHandler);
            if(this._mediaPlayer is IProgressiveMediaPlayer)
            {
               _loc2_ = IProgressiveMediaPlayer(this._mediaPlayer);
               _loc2_.addEventListener("loadProgress",mediaPlayer_loadProgressHandler);
               if(_loc2_.bytesTotal > 0)
               {
                  this._progress = _loc2_.bytesLoaded / _loc2_.bytesTotal;
               }
               else
               {
                  this._progress = 0;
               }
            }
            else
            {
               this._progress = 0;
            }
            this.minimum = 0;
            this.maximum = this._mediaPlayer.totalTime;
            this.value = this._mediaPlayer.currentTime;
         }
         else
         {
            this.minimum = 0;
            this.maximum = 0;
            this.value = 0;
         }
      }
      
      public function get progressSkin() : DisplayObject
      {
         return this._progressSkin;
      }
      
      public function set progressSkin(param1:DisplayObject) : void
      {
         if(this._progressSkin == param1)
         {
            return;
         }
         if(this._progressSkin)
         {
            this.removeChild(this._progressSkin);
         }
         this._progressSkin = param1;
         if(this._progressSkin)
         {
            if(this._progressSkin.parent != this)
            {
               this._progressSkin.visible = false;
               this.addChild(this._progressSkin);
            }
            this._progressSkin.touchable = false;
         }
         this.invalidate("styles");
      }
      
      override protected function layoutChildren() : void
      {
         super.layoutChildren();
         this.layoutProgressSkin();
      }
      
      protected function layoutProgressSkin() : void
      {
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:* = NaN;
         var _loc2_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:* = NaN;
         var _loc5_:Number = NaN;
         if(this._progressSkin === null)
         {
            return;
         }
         if(this._minimum === this._maximum)
         {
            _loc4_ = 1;
         }
         else if((_loc4_ = (this._value - this._minimum) / (this._maximum - this._minimum)) < 0)
         {
            _loc4_ = 0;
         }
         else if(_loc4_ > 1)
         {
            _loc4_ = 1;
         }
         if(this._progress === 0 || this._progress <= _loc4_)
         {
            this._progressSkin.visible = false;
            return;
         }
         this._progressSkin.visible = true;
         if(this._progressSkin is IValidating)
         {
            IValidating(this._progressSkin).validate();
         }
         if(this._direction === "vertical")
         {
            _loc6_ = this.actualHeight - this.thumb.height / 2 - this._minimumPadding - this._maximumPadding;
            this._progressSkin.x = Math.round((this.actualWidth - this._progressSkin.width) / 2);
            _loc3_ = Math.round(_loc6_ * this._progress);
            _loc2_ = Math.round(this.thumb.y + this.thumb.height / 2);
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            else if(_loc3_ > _loc2_)
            {
               _loc3_ = _loc2_;
            }
            this._progressSkin.height = _loc3_;
            this._progressSkin.y = _loc2_ - _loc3_;
         }
         else
         {
            _loc7_ = this.actualWidth - this._minimumPadding - this._maximumPadding;
            this._progressSkin.x = Math.round(this.thumb.x + this.thumb.width / 2);
            this._progressSkin.y = Math.round((this.actualHeight - this._progressSkin.height) / 2);
            _loc1_ = Math.round(_loc7_ * this._progress - this._progressSkin.x);
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            else
            {
               _loc5_ = Math.round(this.actualWidth - this._progressSkin.x);
               if(_loc1_ > _loc5_)
               {
                  _loc1_ = _loc5_;
               }
            }
            this._progressSkin.width = _loc1_;
         }
      }
      
      protected function updateValueFromMediaPlayerCurrentTime() : void
      {
         if(this.isDragging)
         {
            return;
         }
         this._value = this._mediaPlayer.currentTime;
         this.invalidate("data");
      }
      
      protected function seekSlider_changeHandler(param1:Event) : void
      {
         if(!this._mediaPlayer)
         {
            return;
         }
         this._mediaPlayer.seek(this._value);
      }
      
      protected function seekSlider_endInteractionHandler(param1:Event) : void
      {
         this.updateValueFromMediaPlayerCurrentTime();
      }
      
      protected function mediaPlayer_currentTimeChangeHandler(param1:Event) : void
      {
         this.updateValueFromMediaPlayerCurrentTime();
      }
      
      protected function mediaPlayer_totalTimeChangeHandler(param1:Event) : void
      {
         this.maximum = this._mediaPlayer.totalTime;
      }
      
      protected function mediaPlayer_loadProgressHandler(param1:Event, param2:Number) : void
      {
         if(this._progress === param2)
         {
            return;
         }
         this._progress = param2;
         this.invalidate("data");
      }
   }
}
