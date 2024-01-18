package starling.display
{
   import flash.errors.IllegalOperationError;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import starling.animation.IAnimatable;
   import starling.textures.Texture;
   
   public class MovieClip extends Image implements IAnimatable
   {
       
      
      private var _frames:Vector.<MovieClipFrame>;
      
      private var _defaultFrameDuration:Number;
      
      private var _currentTime:Number;
      
      private var _currentFrameID:int;
      
      private var _loop:Boolean;
      
      private var _playing:Boolean;
      
      private var _muted:Boolean;
      
      private var _wasStopped:Boolean;
      
      private var _soundTransform:SoundTransform;
      
      public function MovieClip(param1:Vector.<Texture>, param2:Number = 12)
      {
         if(param1.length > 0)
         {
            super(param1[0]);
            init(param1,param2);
            return;
         }
         throw new ArgumentError("Empty texture array");
      }
      
      private function init(param1:Vector.<Texture>, param2:Number) : void
      {
         var _loc4_:int = 0;
         if(param2 <= 0)
         {
            throw new ArgumentError("Invalid fps: " + param2);
         }
         var _loc3_:int = int(param1.length);
         _defaultFrameDuration = 1 / param2;
         _loop = true;
         _playing = true;
         _currentTime = 0;
         _currentFrameID = 0;
         _wasStopped = true;
         _frames = new Vector.<MovieClipFrame>(0);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _frames[_loc4_] = new MovieClipFrame(param1[_loc4_],_defaultFrameDuration,_defaultFrameDuration * _loc4_);
            _loc4_++;
         }
      }
      
      public function addFrame(param1:Texture, param2:Sound = null, param3:Number = -1) : void
      {
         addFrameAt(numFrames,param1,param2,param3);
      }
      
      public function addFrameAt(param1:int, param2:Texture, param3:Sound = null, param4:Number = -1) : void
      {
         var _loc6_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param1 < 0 || param1 > numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         if(param4 < 0)
         {
            param4 = _defaultFrameDuration;
         }
         var _loc7_:MovieClipFrame;
         (_loc7_ = new MovieClipFrame(param2,param4)).sound = param3;
         _frames.insertAt(param1,_loc7_);
         if(param1 == numFrames)
         {
            _loc6_ = Number(param1 > 0 ? _frames[param1 - 1].startTime : 0);
            _loc5_ = Number(param1 > 0 ? _frames[param1 - 1].duration : 0);
            _loc7_.startTime = _loc6_ + _loc5_;
         }
         else
         {
            updateStartTimes();
         }
      }
      
      public function removeFrameAt(param1:int) : void
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         if(numFrames == 1)
         {
            throw new IllegalOperationError("Movie clip must not be empty");
         }
         _frames.removeAt(param1);
         if(param1 != numFrames)
         {
            updateStartTimes();
         }
      }
      
      public function getFrameTexture(param1:int) : Texture
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return _frames[param1].texture;
      }
      
      public function setFrameTexture(param1:int, param2:Texture) : void
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         _frames[param1].texture = param2;
      }
      
      public function getFrameSound(param1:int) : Sound
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return _frames[param1].sound;
      }
      
      public function setFrameSound(param1:int, param2:Sound) : void
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         _frames[param1].sound = param2;
      }
      
      public function getFrameAction(param1:int) : Function
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return _frames[param1].action;
      }
      
      public function setFrameAction(param1:int, param2:Function) : void
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         _frames[param1].action = param2;
      }
      
      public function getFrameDuration(param1:int) : Number
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return _frames[param1].duration;
      }
      
      public function setFrameDuration(param1:int, param2:Number) : void
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         _frames[param1].duration = param2;
         updateStartTimes();
      }
      
      public function reverseFrames() : void
      {
         _frames.reverse();
         _currentTime = totalTime - _currentTime;
         _currentFrameID = numFrames - _currentFrameID - 1;
         updateStartTimes();
      }
      
      public function play() : void
      {
         _playing = true;
      }
      
      public function pause() : void
      {
         _playing = false;
      }
      
      public function stop() : void
      {
         _playing = false;
         _wasStopped = true;
         currentFrame = 0;
      }
      
      private function updateStartTimes() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = this.numFrames;
         var _loc3_:MovieClipFrame = _frames[0];
         _loc3_.startTime = 0;
         _loc2_ = 1;
         while(_loc2_ < _loc1_)
         {
            _frames[_loc2_].startTime = _loc3_.startTime + _loc3_.duration;
            _loc3_ = _frames[_loc2_];
            _loc2_++;
         }
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         if(!_playing)
         {
            return;
         }
         var _loc8_:MovieClipFrame = _frames[_currentFrameID];
         if(_wasStopped)
         {
            _wasStopped = false;
            _loc8_.playSound(_soundTransform);
            if(_loc8_.action != null)
            {
               _loc8_.executeAction(this,_currentFrameID);
               advanceTime(param1);
               return;
            }
         }
         if(_currentTime == totalTime)
         {
            if(!_loop)
            {
               return;
            }
            _currentTime = 0;
            _currentFrameID = 0;
            (_loc8_ = _frames[0]).playSound(_soundTransform);
            texture = _loc8_.texture;
            if(_loc8_.action != null)
            {
               _loc8_.executeAction(this,_currentFrameID);
               advanceTime(param1);
               return;
            }
         }
         var _loc3_:int = _frames.length - 1;
         var _loc4_:Number = _loc8_.duration - _currentTime + _loc8_.startTime;
         var _loc5_:Boolean = false;
         var _loc6_:Function = null;
         var _loc7_:int = _currentFrameID;
         while(param1 >= _loc4_)
         {
            _loc2_ = false;
            param1 -= _loc4_;
            _currentTime = _loc8_.startTime + _loc8_.duration;
            if(_currentFrameID == _loc3_)
            {
               if(hasEventListener("complete"))
               {
                  _loc5_ = true;
               }
               else
               {
                  if(!_loop)
                  {
                     return;
                  }
                  _currentTime = 0;
                  _currentFrameID = 0;
                  _loc2_ = true;
               }
            }
            else
            {
               _currentFrameID += 1;
               _loc2_ = true;
            }
            _loc6_ = (_loc8_ = _frames[_currentFrameID]).action;
            if(_loc2_)
            {
               _loc8_.playSound(_soundTransform);
            }
            if(_loc5_)
            {
               texture = _loc8_.texture;
               dispatchEventWith("complete");
               advanceTime(param1);
               return;
            }
            if(_loc6_ != null)
            {
               texture = _loc8_.texture;
               _loc8_.executeAction(this,_currentFrameID);
               advanceTime(param1);
               return;
            }
            _loc4_ = _loc8_.duration;
            if(param1 + 0.0001 > _loc4_ && param1 - 0.0001 < _loc4_)
            {
               param1 = _loc4_;
            }
         }
         if(_loc7_ != _currentFrameID)
         {
            texture = _frames[_currentFrameID].texture;
         }
         _currentTime += param1;
      }
      
      public function get numFrames() : int
      {
         return _frames.length;
      }
      
      public function get totalTime() : Number
      {
         var _loc1_:MovieClipFrame = _frames[_frames.length - 1];
         return _loc1_.startTime + _loc1_.duration;
      }
      
      public function get currentTime() : Number
      {
         return _currentTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         if(param1 < 0 || param1 > totalTime)
         {
            throw new ArgumentError("Invalid time: " + param1);
         }
         var _loc2_:int = _frames.length - 1;
         _currentTime = param1;
         _currentFrameID = 0;
         while(_currentFrameID < _loc2_ && _frames[_currentFrameID + 1].startTime <= param1)
         {
            ++_currentFrameID;
         }
         var _loc3_:MovieClipFrame = _frames[_currentFrameID];
         texture = _loc3_.texture;
      }
      
      public function get loop() : Boolean
      {
         return _loop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         _loop = param1;
      }
      
      public function get muted() : Boolean
      {
         return _muted;
      }
      
      public function set muted(param1:Boolean) : void
      {
         _muted = param1;
      }
      
      public function get soundTransform() : SoundTransform
      {
         return _soundTransform;
      }
      
      public function set soundTransform(param1:SoundTransform) : void
      {
         _soundTransform = param1;
      }
      
      public function get currentFrame() : int
      {
         return _currentFrameID;
      }
      
      public function set currentFrame(param1:int) : void
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         currentTime = _frames[param1].startTime;
      }
      
      public function get fps() : Number
      {
         return 1 / _defaultFrameDuration;
      }
      
      public function set fps(param1:Number) : void
      {
         var _loc4_:int = 0;
         if(param1 <= 0)
         {
            throw new ArgumentError("Invalid fps: " + param1);
         }
         var _loc2_:Number = 1 / param1;
         var _loc3_:Number = _loc2_ / _defaultFrameDuration;
         _currentTime *= _loc3_;
         _defaultFrameDuration = _loc2_;
         _loc4_ = 0;
         while(_loc4_ < numFrames)
         {
            _frames[_loc4_].duration *= _loc3_;
            _loc4_++;
         }
         updateStartTimes();
      }
      
      public function get isPlaying() : Boolean
      {
         if(_playing)
         {
            return _loop || _currentTime < totalTime;
         }
         return false;
      }
      
      public function get isComplete() : Boolean
      {
         return !_loop && _currentTime >= totalTime;
      }
   }
}

import flash.media.Sound;
import flash.media.SoundTransform;
import starling.display.MovieClip;
import starling.textures.Texture;

class MovieClipFrame
{
    
   
   public var texture:Texture;
   
   public var sound:Sound;
   
   public var duration:Number;
   
   public var startTime:Number;
   
   public var action:Function;
   
   public function MovieClipFrame(param1:Texture, param2:Number = 0.1, param3:Number = 0)
   {
      super();
      this.texture = param1;
      this.duration = param2;
      this.startTime = param3;
   }
   
   public function playSound(param1:SoundTransform) : void
   {
      if(sound)
      {
         sound.play(0,0,param1);
      }
   }
   
   public function executeAction(param1:MovieClip, param2:int) : void
   {
      var _loc3_:int = 0;
      if(action != null)
      {
         _loc3_ = int(action.length);
         if(_loc3_ == 0)
         {
            action();
         }
         else if(_loc3_ == 1)
         {
            action(param1);
         }
         else
         {
            if(_loc3_ != 2)
            {
               throw new Error("Frame actions support zero, one or two parameters: movie:MovieClip, frameID:int");
            }
            action(param1,param2);
         }
      }
   }
}
