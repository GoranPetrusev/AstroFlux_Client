package feathers.media
{
   import flash.media.SoundTransform;
   
   public interface IAudioPlayer extends ITimedMediaPlayer
   {
       
      
      function get soundTransform() : SoundTransform;
      
      function set soundTransform(param1:SoundTransform) : void;
   }
}
