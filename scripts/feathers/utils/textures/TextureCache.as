package feathers.utils.textures
{
   import flash.errors.IllegalOperationError;
   import starling.textures.Texture;
   
   public class TextureCache
   {
       
      
      protected var _unretainedKeys:Vector.<String>;
      
      protected var _unretainedTextures:Object;
      
      protected var _retainedTextures:Object;
      
      protected var _retainCounts:Object;
      
      protected var _maxUnretainedTextures:int;
      
      public function TextureCache(param1:int = 2147483647)
      {
         _unretainedKeys = new Vector.<String>(0);
         _unretainedTextures = {};
         _retainedTextures = {};
         _retainCounts = {};
         super();
         this._maxUnretainedTextures = param1;
      }
      
      public function get maxUnretainedTextures() : int
      {
         return this._maxUnretainedTextures;
      }
      
      public function set maxUnretainedTextures(param1:int) : void
      {
         if(this._maxUnretainedTextures === param1)
         {
            return;
         }
         this._maxUnretainedTextures = param1;
         if(this._unretainedKeys.length > param1)
         {
            this.trimCache();
         }
      }
      
      public function dispose() : void
      {
         for each(var _loc1_ in this._unretainedTextures)
         {
            _loc1_.dispose();
         }
         for each(_loc1_ in this._retainedTextures)
         {
            _loc1_.dispose();
         }
         this._retainedTextures = null;
         this._unretainedTextures = null;
         this._retainCounts = null;
      }
      
      public function addTexture(param1:String, param2:Texture, param3:Boolean = true) : void
      {
         if(!this._retainedTextures)
         {
            throw new IllegalOperationError("Cannot add a texture after the cache has been disposed.");
         }
         if(param1 in this._unretainedTextures || param1 in this._retainedTextures)
         {
            throw new ArgumentError("Key \"" + param1 + "\" already exists in the cache.");
         }
         if(param3)
         {
            this._retainedTextures[param1] = param2;
            this._retainCounts[param1] = 1 as int;
            return;
         }
         this._unretainedTextures[param1] = param2;
         this._unretainedKeys[this._unretainedKeys.length] = param1;
         if(this._unretainedKeys.length > this._maxUnretainedTextures)
         {
            this.trimCache();
         }
      }
      
      public function removeTexture(param1:String, param2:Boolean = false) : void
      {
         if(!this._unretainedTextures)
         {
            return;
         }
         var _loc3_:Texture = this._unretainedTextures[param1] as Texture;
         if(_loc3_)
         {
            this.removeUnretainedKey(param1);
         }
         else
         {
            _loc3_ = this._retainedTextures[param1] as Texture;
            delete this._retainedTextures[param1];
            delete this._retainCounts[param1];
         }
         if(param2 && _loc3_)
         {
            _loc3_.dispose();
         }
      }
      
      public function hasTexture(param1:String) : Boolean
      {
         if(!this._retainedTextures)
         {
            return false;
         }
         return param1 in this._retainedTextures || param1 in this._unretainedTextures;
      }
      
      public function getRetainCount(param1:String) : int
      {
         if(this._retainCounts && param1 in this._retainCounts)
         {
            return this._retainCounts[param1] as int;
         }
         return 0;
      }
      
      public function retainTexture(param1:String) : Texture
      {
         var _loc3_:int = 0;
         if(!this._retainedTextures)
         {
            throw new IllegalOperationError("Cannot retain a texture after the cache has been disposed.");
         }
         if(param1 in this._retainedTextures)
         {
            _loc3_ = this._retainCounts[param1] as int;
            _loc3_++;
            this._retainCounts[param1] = _loc3_;
            return Texture(this._retainedTextures[param1]);
         }
         if(!(param1 in this._unretainedTextures))
         {
            throw new ArgumentError("Texture with key \"" + param1 + "\" cannot be retained because it has not been added to the cache.");
         }
         var _loc2_:Texture = Texture(this._unretainedTextures[param1]);
         this.removeUnretainedKey(param1);
         this._retainedTextures[param1] = _loc2_;
         this._retainCounts[param1] = 1 as int;
         return _loc2_;
      }
      
      public function releaseTexture(param1:String) : void
      {
         var _loc2_:Texture = null;
         if(!this._retainedTextures || !(param1 in this._retainedTextures))
         {
            return;
         }
         var _loc3_:int = this._retainCounts[param1] as int;
         _loc3_--;
         if(_loc3_ === 0)
         {
            _loc2_ = Texture(this._retainedTextures[param1]);
            delete this._retainCounts[param1];
            delete this._retainedTextures[param1];
            this._unretainedTextures[param1] = _loc2_;
            this._unretainedKeys[this._unretainedKeys.length] = param1;
            if(this._unretainedKeys.length > this._maxUnretainedTextures)
            {
               this.trimCache();
            }
         }
         else
         {
            this._retainCounts[param1] = _loc3_;
         }
      }
      
      protected function removeUnretainedKey(param1:String) : void
      {
         var _loc2_:int = this._unretainedKeys.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         this._unretainedKeys.removeAt(_loc2_);
         delete this._unretainedTextures[param1];
      }
      
      protected function trimCache() : void
      {
         var _loc4_:String = null;
         var _loc1_:Texture = null;
         var _loc2_:int = int(this._unretainedKeys.length);
         var _loc3_:int = this._maxUnretainedTextures;
         while(_loc2_ > _loc3_)
         {
            _loc4_ = this._unretainedKeys.shift();
            _loc1_ = Texture(this._unretainedTextures[_loc4_]);
            _loc1_.dispose();
            delete this._unretainedTextures[_loc4_];
            _loc2_--;
         }
      }
   }
}
