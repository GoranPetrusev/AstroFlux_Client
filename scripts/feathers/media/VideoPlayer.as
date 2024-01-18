package feathers.media
{
   import feathers.controls.LayoutGroup;
   import feathers.core.PopUpManager;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.stageToStarling;
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.media.SoundTransform;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.textures.Texture;
   
   public class VideoPlayer extends BaseTimedMediaPlayer implements IVideoPlayer, IProgressiveMediaPlayer
   {
      
      protected static const NET_STATUS_CODE_NETCONNECTION_CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
      
      protected static const NET_STATUS_CODE_NETSTREAM_PLAY_START:String = "NetStream.Play.Start";
      
      protected static const NET_STATUS_CODE_NETSTREAM_PLAY_STOP:String = "NetStream.Play.Stop";
      
      protected static const NET_STATUS_CODE_NETSTREAM_PLAY_STREAMNOTFOUND:String = "NetStream.Play.StreamNotFound";
      
      protected static const NET_STATUS_CODE_NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:String = "NetStream.Play.NoSupportedTrackFound";
      
      protected static const NO_VIDEO_SOURCE_PLAY_ERROR:String = "Cannot play media when videoSource property has not been set.";
      
      protected static const NO_VIDEO_SOURCE_PAUSE_ERROR:String = "Cannot pause media when videoSource property has not been set.";
      
      protected static const NO_VIDEO_SOURCE_SEEK_ERROR:String = "Cannot seek media when videoSource property has not been set.";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var _fullScreenContainer:LayoutGroup;
      
      protected var _ignoreDisplayListEvents:Boolean = false;
      
      protected var _soundTransform:SoundTransform;
      
      protected var _isWaitingForTextureReady:Boolean = false;
      
      protected var _texture:Texture;
      
      protected var _netConnection:NetConnection;
      
      protected var _netStream:NetStream;
      
      protected var _hasPlayedToEnd:Boolean = false;
      
      protected var _videoSource:String;
      
      protected var _autoPlay:Boolean = true;
      
      protected var _isFullScreen:Boolean = false;
      
      protected var _normalDisplayState:String = "normal";
      
      protected var _fullScreenDisplayState:String = "fullScreenInteractive";
      
      protected var _hideRootWhenFullScreen:Boolean = true;
      
      protected var _netConnectionFactory:Function;
      
      protected var _bytesLoaded:uint = 0;
      
      protected var _bytesTotal:uint = 0;
      
      public function VideoPlayer()
      {
         _netConnectionFactory = defaultNetConnectionFactory;
         super();
      }
      
      protected static function defaultNetConnectionFactory() : NetConnection
      {
         var _loc1_:NetConnection = new NetConnection();
         _loc1_.connect(null);
         return _loc1_;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return VideoPlayer.globalStyleProvider;
      }
      
      public function get soundTransform() : SoundTransform
      {
         if(!this._soundTransform)
         {
            this._soundTransform = new SoundTransform();
         }
         return this._soundTransform;
      }
      
      public function set soundTransform(param1:SoundTransform) : void
      {
         this._soundTransform = param1;
         if(this._netStream)
         {
            this._netStream.soundTransform = this._soundTransform;
         }
         this.dispatchEventWith("soundTransformChange");
      }
      
      public function get texture() : Texture
      {
         if(this._isWaitingForTextureReady)
         {
            return null;
         }
         return this._texture;
      }
      
      public function get nativeWidth() : Number
      {
         if(this._texture)
         {
            return this._texture.nativeWidth;
         }
         return 0;
      }
      
      public function get nativeHeight() : Number
      {
         if(this._texture)
         {
            return this._texture.nativeHeight;
         }
         return 0;
      }
      
      public function get netStream() : NetStream
      {
         return this._netStream;
      }
      
      public function get videoSource() : String
      {
         return this._videoSource;
      }
      
      public function set videoSource(param1:String) : void
      {
         if(this._videoSource === param1)
         {
            return;
         }
         if(this._isPlaying)
         {
            this.stop();
         }
         this.disposeNetStream();
         if(!param1)
         {
            this.disposeNetConnection();
         }
         if(this._texture !== null)
         {
            this._texture.dispose();
            this._texture = null;
            this.dispatchEventWith("clear");
         }
         this._videoSource = param1;
         if(this._currentTime !== 0)
         {
            this._currentTime = 0;
            this.dispatchEventWith("currentTimeChange");
         }
         if(this._totalTime !== 0)
         {
            this._totalTime = 0;
            this.dispatchEventWith("totalTimeChange");
         }
         this._bytesLoaded = 0;
         this._bytesTotal = 0;
         if(this._autoPlay && this._videoSource)
         {
            this.play();
         }
      }
      
      public function get autoPlay() : Boolean
      {
         return this._autoPlay;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         this._autoPlay = param1;
      }
      
      public function get isFullScreen() : Boolean
      {
         return this._isFullScreen;
      }
      
      public function get normalDisplayState() : String
      {
         return this._normalDisplayState;
      }
      
      public function set normalDisplayState(param1:String) : void
      {
         var _loc2_:Starling = null;
         var _loc3_:Stage = null;
         if(this._normalDisplayState == param1)
         {
            return;
         }
         this._normalDisplayState = param1;
         if(!this._isFullScreen && this.stage)
         {
            _loc2_ = stageToStarling(this.stage);
            _loc3_ = _loc2_.nativeStage;
            _loc3_.displayState = this._normalDisplayState;
         }
      }
      
      public function get fullScreenDisplayState() : String
      {
         return this._fullScreenDisplayState;
      }
      
      public function set fullScreenDisplayState(param1:String) : void
      {
         var _loc2_:Starling = null;
         var _loc3_:Stage = null;
         if(this._fullScreenDisplayState == param1)
         {
            return;
         }
         this._fullScreenDisplayState = param1;
         if(this._isFullScreen && this.stage)
         {
            _loc2_ = stageToStarling(this.stage);
            _loc3_ = _loc2_.nativeStage;
            _loc3_.displayState = this._fullScreenDisplayState;
         }
      }
      
      public function get hideRootWhenFullScreen() : Boolean
      {
         return this._hideRootWhenFullScreen;
      }
      
      public function set hideRootWhenFullScreen(param1:Boolean) : void
      {
         this._hideRootWhenFullScreen = param1;
      }
      
      public function get netConnectionFactory() : Function
      {
         return this._netConnectionFactory;
      }
      
      public function set netConnectionFactory(param1:Function) : void
      {
         if(this._netConnectionFactory === param1)
         {
            return;
         }
         this._netConnectionFactory = param1;
         this.stop();
         this.disposeNetStream();
         this.disposeNetConnection();
      }
      
      public function get bytesLoaded() : uint
      {
         return this._bytesLoaded;
      }
      
      public function get bytesTotal() : uint
      {
         return this._bytesTotal;
      }
      
      override public function dispose() : void
      {
         this.videoSource = null;
         super.dispose();
      }
      
      override public function play() : void
      {
         if(this._videoSource === null)
         {
            return;
         }
         super.play();
      }
      
      override public function stop() : void
      {
         if(this._videoSource === null)
         {
            return;
         }
         super.stop();
      }
      
      override public function render(param1:Painter) : void
      {
         if(this._isFullScreen)
         {
            return;
         }
         super.render(param1);
      }
      
      public function toggleFullScreen() : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:DisplayObject = null;
         if(!this.stage)
         {
            throw new IllegalOperationError("Cannot enter full screen mode if the video player does not have access to the Starling stage.");
         }
         var _loc1_:Starling = stageToStarling(this.stage);
         var _loc2_:Stage = _loc1_.nativeStage;
         var _loc5_:Boolean = this._ignoreDisplayListEvents;
         this._ignoreDisplayListEvents = true;
         if(this._isFullScreen)
         {
            this.root.visible = true;
            PopUpManager.removePopUp(this._fullScreenContainer,false);
            _loc4_ = this._fullScreenContainer.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_ = this._fullScreenContainer.getChildAt(0);
               this.addChild(_loc6_);
               _loc3_++;
            }
            _loc2_.displayState = this._normalDisplayState;
         }
         else
         {
            if(this._hideRootWhenFullScreen)
            {
               this.root.visible = false;
            }
            _loc2_.displayState = this._fullScreenDisplayState;
            if(!this._fullScreenContainer)
            {
               this._fullScreenContainer = new LayoutGroup();
               this._fullScreenContainer.autoSizeMode = "stage";
            }
            this._fullScreenContainer.layout = this._layout;
            _loc4_ = this.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_ = this.getChildAt(0);
               this._fullScreenContainer.addChild(_loc6_);
               _loc3_++;
            }
            PopUpManager.addPopUp(this._fullScreenContainer,true,false);
         }
         this._ignoreDisplayListEvents = _loc5_;
         this._isFullScreen = !this._isFullScreen;
         this.dispatchEventWith("displayStageChange");
      }
      
      override protected function playMedia() : void
      {
         var _loc1_:Function = null;
         if(!this._videoSource)
         {
            throw new IllegalOperationError("Cannot play media when videoSource property has not been set.");
         }
         if(this._netConnection === null)
         {
            _loc1_ = this._netConnectionFactory !== null ? this._netConnectionFactory : defaultNetConnectionFactory;
            this._netConnection = NetConnection(_loc1_());
         }
         if(this._netStream === null)
         {
            if(!this._netConnection.connected)
            {
               this._netConnection.addEventListener("netStatus",netConnection_netStatusHandler);
               return;
            }
            this._netStream = new NetStream(this._netConnection);
            this._netStream.client = new VideoPlayerNetStreamClient(this.netStream_onMetaData);
            this._netStream.addEventListener("netStatus",netStream_netStatusHandler);
            this._netStream.addEventListener("ioError",netStream_ioErrorHandler);
         }
         if(this._soundTransform === null)
         {
            this._soundTransform = new SoundTransform();
         }
         this._netStream.soundTransform = this._soundTransform;
         var _loc2_:Function = videoTexture_onComplete;
         if(this._texture !== null)
         {
            if(this._hasPlayedToEnd)
            {
               this._netStream.play(this._videoSource);
            }
            else
            {
               this.addEventListener("enterFrame",videoPlayer_enterFrameHandler);
               this._netStream.resume();
            }
         }
         else
         {
            this._isWaitingForTextureReady = true;
            this._texture = Texture.fromNetStream(this._netStream,Starling.current.contentScaleFactor,_loc2_);
            this._texture.root.onRestore = videoTexture_onRestore;
            this._netStream.play(this._videoSource);
         }
         this._hasPlayedToEnd = false;
      }
      
      override protected function pauseMedia() : void
      {
         if(!this._videoSource)
         {
            throw new IllegalOperationError("Cannot pause media when videoSource property has not been set.");
         }
         this.removeEventListener("enterFrame",videoPlayer_enterFrameHandler);
         this._netStream.pause();
      }
      
      override protected function seekMedia(param1:Number) : void
      {
         if(!this._videoSource)
         {
            throw new IllegalOperationError("Cannot seek media when videoSource property has not been set.");
         }
         this._currentTime = param1;
         if(this._hasPlayedToEnd)
         {
            this.playMedia();
            return;
         }
         this._netStream.seek(param1);
      }
      
      protected function disposeNetConnection() : void
      {
         if(this._netConnection === null)
         {
            return;
         }
         this._netConnection.removeEventListener("netStatus",netConnection_netStatusHandler);
         this._netConnection.close();
         this._netConnection = null;
      }
      
      protected function disposeNetStream() : void
      {
         if(this._netStream === null)
         {
            return;
         }
         this._netStream.removeEventListener("netStatus",netStream_netStatusHandler);
         this._netStream.removeEventListener("ioError",netStream_ioErrorHandler);
         this._netStream.close();
         this._netStream = null;
      }
      
      protected function videoPlayer_enterFrameHandler(param1:Event) : void
      {
         this._currentTime = this._netStream.time;
         this.dispatchEventWith("currentTimeChange");
      }
      
      protected function videoPlayer_progress_enterFrameHandler(param1:Event) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc2_:Number = this._netStream.bytesTotal;
         if(_loc2_ > 0)
         {
            _loc3_ = false;
            _loc4_ = this._netStream.bytesLoaded;
            if(this._bytesTotal !== _loc2_)
            {
               this._bytesTotal = _loc2_;
               _loc3_ = true;
            }
            if(this._bytesLoaded !== _loc4_)
            {
               this._bytesLoaded = _loc4_;
               _loc3_ = true;
            }
            if(_loc3_)
            {
               this.dispatchEventWith("loadProgress",false,_loc4_ / _loc2_);
            }
            if(_loc4_ === _loc2_)
            {
               this.removeEventListener("enterFrame",videoPlayer_progress_enterFrameHandler);
            }
         }
      }
      
      protected function videoTexture_onRestore() : void
      {
         this.pauseMedia();
         this._isWaitingForTextureReady = true;
         this._texture.root.attachNetStream(this._netStream,videoTexture_onComplete);
         this._netStream.play(this._videoSource);
      }
      
      protected function videoTexture_onComplete() : void
      {
         this._isWaitingForTextureReady = false;
         this.dispatchEventWith("ready");
         var _loc1_:Number = this._netStream.bytesTotal;
         if(this._bytesTotal === 0 && _loc1_ > 0)
         {
            this._bytesLoaded = this._netStream.bytesLoaded;
            this._bytesTotal = _loc1_;
            this.dispatchEventWith("loadProgress",false,this._bytesLoaded / _loc1_);
            if(this._bytesLoaded !== this._bytesTotal)
            {
               this.addEventListener("enterFrame",videoPlayer_progress_enterFrameHandler);
            }
         }
      }
      
      protected function netConnection_netStatusHandler(param1:NetStatusEvent) : void
      {
         var _loc2_:String = String(param1.info.code);
         var _loc3_:* = _loc2_;
         if("NetConnection.Connect.Success" === _loc3_)
         {
            this.playMedia();
         }
      }
      
      protected function netStream_onMetaData(param1:Object) : void
      {
         this.dispatchEventWith("dimensionsChange");
         this._totalTime = param1.duration;
         this.dispatchEventWith("totalTimeChange");
         this.dispatchEventWith("metadataReceived",false,param1);
      }
      
      protected function netStream_ioErrorHandler(param1:IOErrorEvent) : void
      {
         this.dispatchEventWith(param1.type,false,param1);
      }
      
      protected function netStream_netStatusHandler(param1:NetStatusEvent) : void
      {
         var _loc2_:String = String(param1.info.code);
         switch(_loc2_)
         {
            case "NetStream.Play.StreamNotFound":
               this.dispatchEventWith("error",false,_loc2_);
               break;
            case "NetStream.Play.NoSupportedTrackFound":
               this.dispatchEventWith("error",false,_loc2_);
               break;
            case "NetStream.Play.Start":
               if(this._netStream.time !== this._currentTime)
               {
                  this._netStream.seek(this._currentTime);
               }
               if(this._isPlaying)
               {
                  this.addEventListener("enterFrame",videoPlayer_enterFrameHandler);
               }
               else
               {
                  this.pauseMedia();
               }
               break;
            case "NetStream.Play.Stop":
               if(this._hasPlayedToEnd)
               {
                  return;
               }
               this.removeEventListener("enterFrame",videoPlayer_enterFrameHandler);
               if(Starling.context.driverInfo !== "Disposed")
               {
                  this.stop();
                  this._hasPlayedToEnd = true;
                  this.dispatchEventWith("complete");
               }
               break;
         }
      }
      
      override protected function mediaPlayer_addedHandler(param1:Event) : void
      {
         if(this._ignoreDisplayListEvents)
         {
            return;
         }
         super.mediaPlayer_addedHandler(param1);
      }
      
      override protected function mediaPlayer_removedHandler(param1:Event) : void
      {
         if(this._ignoreDisplayListEvents)
         {
            return;
         }
         super.mediaPlayer_removedHandler(param1);
      }
   }
}

dynamic class VideoPlayerNetStreamClient
{
    
   
   public var onMetaDataCallback:Function;
   
   public function VideoPlayerNetStreamClient(param1:Function)
   {
      super();
      this.onMetaDataCallback = param1;
   }
   
   public function onMetaData(param1:Object) : void
   {
      this.onMetaDataCallback(param1);
   }
}
