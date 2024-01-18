package starling.utils
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.FileReference;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.events.EventDispatcher;
   import starling.text.BitmapFont;
   import starling.text.TextField;
   import starling.textures.AtfData;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import starling.textures.TextureOptions;
   
   public class AssetManager extends EventDispatcher
   {
      
      private static const HTTP_RESPONSE_STATUS:String = "httpResponseStatus";
      
      private static var sNames:Vector.<String> = new Vector.<String>(0);
      
      private static const NAME_REGEX:RegExp = /([^\?\/\\]+?)(?:\.([\w\-]+))?(?:\?.*)?$/;
       
      
      private var _starling:Starling;
      
      private var _numLostTextures:int;
      
      private var _numRestoredTextures:int;
      
      private var _numLoadingQueues:int;
      
      private var _defaultTextureOptions:TextureOptions;
      
      private var _checkPolicyFile:Boolean;
      
      private var _keepAtlasXmls:Boolean;
      
      private var _keepFontXmls:Boolean;
      
      private var _numConnections:int;
      
      private var _verbose:Boolean;
      
      private var _queue:Array;
      
      private var _textures:Dictionary;
      
      private var _atlases:Dictionary;
      
      private var _sounds:Dictionary;
      
      private var _xmls:Dictionary;
      
      private var _objects:Dictionary;
      
      private var _byteArrays:Dictionary;
      
      public function AssetManager(param1:Number = 1, param2:Boolean = false)
      {
         super();
         _defaultTextureOptions = new TextureOptions(param1,param2);
         _textures = new Dictionary();
         _atlases = new Dictionary();
         _sounds = new Dictionary();
         _xmls = new Dictionary();
         _objects = new Dictionary();
         _byteArrays = new Dictionary();
         _numConnections = 3;
         _verbose = true;
         _queue = [];
      }
      
      public function dispose() : void
      {
         for each(var _loc1_ in _textures)
         {
            _loc1_.dispose();
         }
         for each(var _loc2_ in _atlases)
         {
            _loc2_.dispose();
         }
         for each(var _loc3_ in _xmls)
         {
            System.disposeXML(_loc3_);
         }
         for each(var _loc4_ in _byteArrays)
         {
            _loc4_.clear();
         }
      }
      
      public function getTexture(param1:String) : Texture
      {
         var _loc3_:Texture = null;
         if(param1 in _textures)
         {
            return _textures[param1];
         }
         for each(var _loc2_ in _atlases)
         {
            _loc3_ = _loc2_.getTexture(param1);
            if(_loc3_)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getTextures(param1:String = "", param2:Vector.<Texture> = null) : Vector.<Texture>
      {
         if(param2 == null)
         {
            param2 = new Vector.<Texture>(0);
         }
         for each(var _loc3_ in getTextureNames(param1,sNames))
         {
            param2[param2.length] = getTexture(_loc3_);
         }
         sNames.length = 0;
         return param2;
      }
      
      public function getTextureNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         param2 = getDictionaryKeys(_textures,param1,param2);
         for each(var _loc3_ in _atlases)
         {
            _loc3_.getNames(param1,param2);
         }
         param2.sort(1);
         return param2;
      }
      
      public function getTextureAtlas(param1:String) : TextureAtlas
      {
         return _atlases[param1] as TextureAtlas;
      }
      
      public function getTextureAtlasNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(_atlases,param1,param2);
      }
      
      public function getSound(param1:String) : Sound
      {
         return _sounds[param1];
      }
      
      public function getSoundNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(_sounds,param1,param2);
      }
      
      public function playSound(param1:String, param2:Number = 0, param3:int = 0, param4:SoundTransform = null) : SoundChannel
      {
         if(param1 in _sounds)
         {
            return getSound(param1).play(param2,param3,param4);
         }
         return null;
      }
      
      public function getXml(param1:String) : XML
      {
         return _xmls[param1];
      }
      
      public function getXmlNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(_xmls,param1,param2);
      }
      
      public function getObject(param1:String) : Object
      {
         return _objects[param1];
      }
      
      public function getObjectNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(_objects,param1,param2);
      }
      
      public function getByteArray(param1:String) : ByteArray
      {
         return _byteArrays[param1];
      }
      
      public function getByteArrayNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(_byteArrays,param1,param2);
      }
      
      public function addTexture(param1:String, param2:Texture) : void
      {
         log("Adding texture \'" + param1 + "\'");
         if(param1 in _textures)
         {
            log("Warning: name was already in use; the previous texture will be replaced.");
            _textures[param1].dispose();
         }
         _textures[param1] = param2;
      }
      
      public function addTextureAtlas(param1:String, param2:TextureAtlas) : void
      {
         log("Adding texture atlas \'" + param1 + "\'");
         if(param1 in _atlases)
         {
            log("Warning: name was already in use; the previous atlas will be replaced.");
            _atlases[param1].dispose();
         }
         _atlases[param1] = param2;
      }
      
      public function addSound(param1:String, param2:Sound) : void
      {
         log("Adding sound \'" + param1 + "\'");
         if(param1 in _sounds)
         {
            log("Warning: name was already in use; the previous sound will be replaced.");
         }
         _sounds[param1] = param2;
      }
      
      public function addXml(param1:String, param2:XML) : void
      {
         log("Adding XML \'" + param1 + "\'");
         if(param1 in _xmls)
         {
            log("Warning: name was already in use; the previous XML will be replaced.");
            System.disposeXML(_xmls[param1]);
         }
         _xmls[param1] = param2;
      }
      
      public function addObject(param1:String, param2:Object) : void
      {
         log("Adding object \'" + param1 + "\'");
         if(param1 in _objects)
         {
            log("Warning: name was already in use; the previous object will be replaced.");
         }
         _objects[param1] = param2;
      }
      
      public function addByteArray(param1:String, param2:ByteArray) : void
      {
         log("Adding byte array \'" + param1 + "\'");
         if(param1 in _byteArrays)
         {
            log("Warning: name was already in use; the previous byte array will be replaced.");
            _byteArrays[param1].clear();
         }
         _byteArrays[param1] = param2;
      }
      
      public function removeTexture(param1:String, param2:Boolean = true) : void
      {
         log("Removing texture \'" + param1 + "\'");
         if(param2 && param1 in _textures)
         {
            _textures[param1].dispose();
         }
         delete _textures[param1];
      }
      
      public function removeTextureAtlas(param1:String, param2:Boolean = true) : void
      {
         log("Removing texture atlas \'" + param1 + "\'");
         if(param2 && param1 in _atlases)
         {
            _atlases[param1].dispose();
         }
         delete _atlases[param1];
      }
      
      public function removeSound(param1:String) : void
      {
         log("Removing sound \'" + param1 + "\'");
         delete _sounds[param1];
      }
      
      public function removeXml(param1:String, param2:Boolean = true) : void
      {
         log("Removing xml \'" + param1 + "\'");
         if(param2 && param1 in _xmls)
         {
            System.disposeXML(_xmls[param1]);
         }
         delete _xmls[param1];
      }
      
      public function removeObject(param1:String) : void
      {
         log("Removing object \'" + param1 + "\'");
         delete _objects[param1];
      }
      
      public function removeByteArray(param1:String, param2:Boolean = true) : void
      {
         log("Removing byte array \'" + param1 + "\'");
         if(param2 && param1 in _byteArrays)
         {
            _byteArrays[param1].clear();
         }
         delete _byteArrays[param1];
      }
      
      public function purgeQueue() : void
      {
         _queue.length = 0;
         dispatchEventWith("cancel");
      }
      
      public function purge() : void
      {
         log("Purging all assets, emptying queue");
         purgeQueue();
         dispose();
         _textures = new Dictionary();
         _atlases = new Dictionary();
         _sounds = new Dictionary();
         _xmls = new Dictionary();
         _objects = new Dictionary();
         _byteArrays = new Dictionary();
      }
      
      public function enqueue(... rest) : void
      {
         var _loc3_:XML = null;
         var _loc4_:* = null;
         for each(var _loc2_ in rest)
         {
            if(_loc2_ is Array)
            {
               enqueue.apply(this,_loc2_);
            }
            else if(_loc2_ is Class)
            {
               _loc3_ = describeType(_loc2_);
               if(_verbose)
               {
                  log("Looking for static embedded assets in \'" + _loc3_.@name.split("::").pop() + "\'");
               }
               for each(_loc4_ in _loc3_.constant.(@type == "Class"))
               {
                  enqueueWithName(_loc2_[_loc4_.@name],_loc4_.@name);
               }
               for each(_loc4_ in _loc3_.variable.(@type == "Class"))
               {
                  enqueueWithName(_loc2_[_loc4_.@name],_loc4_.@name);
               }
            }
            else if(getQualifiedClassName(_loc2_) == "flash.filesystem::File")
            {
               if(!_loc2_["exists"])
               {
                  log("File or directory not found: \'" + _loc2_["url"] + "\'");
               }
               else if(!_loc2_["isHidden"])
               {
                  if(_loc2_["isDirectory"])
                  {
                     enqueue.apply(this,_loc2_["getDirectoryListing"]());
                  }
                  else
                  {
                     enqueueWithName(_loc2_);
                  }
               }
            }
            else if(_loc2_ is String || _loc2_ is URLRequest)
            {
               enqueueWithName(_loc2_);
            }
            else
            {
               log("Ignoring unsupported asset type: " + getQualifiedClassName(_loc2_));
            }
         }
      }
      
      public function enqueueWithName(param1:Object, param2:String = null, param3:TextureOptions = null) : String
      {
         var _loc4_:String = null;
         if(getQualifiedClassName(param1) == "flash.filesystem::File")
         {
            _loc4_ = String(param1["name"]);
            param1 = decodeURI(param1["url"]);
         }
         if(param2 == null)
         {
            param2 = getName(param1);
         }
         if(param3 == null)
         {
            param3 = _defaultTextureOptions.clone();
         }
         else
         {
            param3 = param3.clone();
         }
         log("Enqueuing \'" + (_loc4_ || param2) + "\'");
         _queue.push({
            "name":param2,
            "asset":param1,
            "options":param3
         });
         return param2;
      }
      
      public function loadQueue(param1:Function) : void
      {
         var PROGRESS_PART_ASSETS:Number;
         var PROGRESS_PART_XMLS:Number;
         var i:int;
         var canceled:Boolean;
         var xmls:Vector.<XML>;
         var assetInfos:Array;
         var assetCount:int;
         var assetProgress:Array;
         var assetIndex:int;
         var onProgress:Function = param1;
         var loadNextQueueElement:* = function():void
         {
            var _loc1_:int = 0;
            if(assetIndex < assetInfos.length)
            {
               _loc1_ = assetIndex++;
               loadQueueElement(_loc1_,assetInfos[_loc1_]);
            }
         };
         var loadQueueElement:* = function(param1:int, param2:Object):void
         {
            var onElementProgress:Function;
            var onElementLoaded:Function;
            var index:int = param1;
            var assetInfo:Object = param2;
            if(canceled)
            {
               return;
            }
            onElementProgress = function(param1:Number):void
            {
               updateAssetProgress(index,param1 * 0.8);
            };
            onElementLoaded = function():void
            {
               updateAssetProgress(index,1);
               assetCount--;
               if(assetCount > 0)
               {
                  loadNextQueueElement();
               }
               else
               {
                  processXmls();
               }
            };
            processRawAsset(assetInfo.name,assetInfo.asset,assetInfo.options,xmls,onElementProgress,onElementLoaded);
         };
         var updateAssetProgress:* = function(param1:int, param2:Number):void
         {
            assetProgress[param1] = param2;
            var _loc4_:Number = 0;
            var _loc3_:int = int(assetProgress.length);
            i = 0;
            while(i < _loc3_)
            {
               _loc4_ += assetProgress[i];
               ++i;
            }
            onProgress(_loc4_ / _loc3_ * 0.9);
         };
         var processXmls:* = function():void
         {
            xmls.sort(function(param1:XML, param2:XML):int
            {
               return param1.localName() == "TextureAtlas" ? -1 : 1;
            });
            setTimeout(processXml,1,0);
         };
         var processXml:* = function(param1:int):void
         {
            var _loc5_:String = null;
            var _loc3_:Texture = null;
            if(canceled)
            {
               return;
            }
            if(param1 == xmls.length)
            {
               finish();
               return;
            }
            var _loc4_:XML;
            var _loc6_:String = String((_loc4_ = xmls[param1]).localName());
            var _loc2_:Number = (param1 + 1) / (xmls.length + 1);
            if(_loc6_ == "TextureAtlas")
            {
               _loc5_ = getName(_loc4_.@imagePath.toString());
               _loc3_ = getTexture(_loc5_);
               if(_loc3_)
               {
                  addTextureAtlas(_loc5_,new TextureAtlas(_loc3_,_loc4_));
                  removeTexture(_loc5_,false);
                  if(_keepAtlasXmls)
                  {
                     addXml(_loc5_,_loc4_);
                  }
                  else
                  {
                     System.disposeXML(_loc4_);
                  }
               }
               else
               {
                  log("Cannot create atlas: texture \'" + _loc5_ + "\' is missing.");
               }
            }
            else
            {
               if(_loc6_ != "font")
               {
                  throw new Error("XML contents not recognized: " + _loc6_);
               }
               _loc5_ = getName(_loc4_.pages.page.@file.toString());
               _loc3_ = getTexture(_loc5_);
               if(_loc3_)
               {
                  log("Adding bitmap font \'" + _loc5_ + "\'");
                  TextField.registerCompositor(new BitmapFont(_loc3_,_loc4_),_loc5_);
                  removeTexture(_loc5_,false);
                  if(_keepFontXmls)
                  {
                     addXml(_loc5_,_loc4_);
                  }
                  else
                  {
                     System.disposeXML(_loc4_);
                  }
               }
               else
               {
                  log("Cannot create bitmap font: texture \'" + _loc5_ + "\' is missing.");
               }
            }
            onProgress(0.9 + 0.09999999999999998 * _loc2_);
            setTimeout(processXml,1,param1 + 1);
         };
         var cancel:* = function():void
         {
            removeEventListener("cancel",cancel);
            _numLoadingQueues--;
            canceled = true;
         };
         var finish:* = function():void
         {
            setTimeout(function():void
            {
               if(!canceled)
               {
                  cancel();
                  onProgress(1);
               }
            },1);
         };
         if(onProgress == null)
         {
            throw new ArgumentError("Argument \'onProgress\' must not be null");
         }
         if(_queue.length == 0)
         {
            onProgress(1);
            return;
         }
         _starling = Starling.current;
         if(_starling == null || _starling.context == null)
         {
            throw new Error("The Starling instance needs to be ready before assets can be loaded.");
         }
         canceled = false;
         xmls = new Vector.<XML>(0);
         assetInfos = _queue.concat();
         assetCount = int(_queue.length);
         assetProgress = [];
         assetIndex = 0;
         i = 0;
         while(i < assetCount)
         {
            assetProgress[i] = 0;
            ++i;
         }
         i = 0;
         while(i < _numConnections)
         {
            loadNextQueueElement();
            ++i;
         }
         _queue.length = 0;
         _numLoadingQueues++;
         addEventListener("cancel",cancel);
      }
      
      private function processRawAsset(param1:String, param2:Object, param3:TextureOptions, param4:Vector.<XML>, param5:Function, param6:Function) : void
      {
         var name:String = param1;
         var rawAsset:Object = param2;
         var options:TextureOptions = param3;
         var xmls:Vector.<XML> = param4;
         var onProgress:Function = param5;
         var onComplete:Function = param6;
         var process:* = function(param1:Object):void
         {
            var texture:Texture;
            var bytes:ByteArray;
            var asset:Object = param1;
            var object:Object = null;
            var xml:XML = null;
            _starling.makeCurrent();
            if(!canceled)
            {
               if(asset == null)
               {
                  onComplete();
               }
               else if(asset is Sound)
               {
                  addSound(name,asset as Sound);
                  onComplete();
               }
               else if(asset is XML)
               {
                  xml = asset as XML;
                  if(xml.localName() == "TextureAtlas" || xml.localName() == "font")
                  {
                     xmls.push(xml);
                  }
                  else
                  {
                     addXml(name,xml);
                  }
                  onComplete();
               }
               else
               {
                  if(_starling.context.driverInfo == "Disposed")
                  {
                     log("Context lost while processing assets, retrying ...");
                     setTimeout(process,1,asset);
                     return;
                  }
                  if(asset is Bitmap)
                  {
                     texture = Texture.fromData(asset,options);
                     texture.root.onRestore = function():void
                     {
                        _numLostTextures++;
                        loadRawAsset(rawAsset,null,function(param1:Object):void
                        {
                           try
                           {
                              if(param1 == null)
                              {
                                 throw new Error("Reload failed");
                              }
                              texture.root.uploadBitmap(param1 as Bitmap);
                              param1.bitmapData.dispose();
                           }
                           catch(e:Error)
                           {
                              log("Texture restoration failed for \'" + name + "\': " + e.message);
                           }
                           _numRestoredTextures++;
                           Starling.current.stage.setRequiresRedraw();
                           if(_numLostTextures == _numRestoredTextures)
                           {
                              dispatchEventWith("texturesRestored");
                           }
                        });
                     };
                     asset.bitmapData.dispose();
                     addTexture(name,texture);
                     onComplete();
                  }
                  else if(asset is ByteArray)
                  {
                     bytes = asset as ByteArray;
                     if(AtfData.isAtfData(bytes))
                     {
                        options.onReady = prependCallback(options.onReady,function():void
                        {
                           addTexture(name,texture);
                           onComplete();
                        });
                        texture = Texture.fromData(bytes,options);
                        texture.root.onRestore = function():void
                        {
                           _numLostTextures++;
                           loadRawAsset(rawAsset,null,function(param1:Object):void
                           {
                              try
                              {
                                 if(param1 == null)
                                 {
                                    throw new Error("Reload failed");
                                 }
                                 texture.root.uploadAtfData(param1 as ByteArray,0,false);
                                 param1.clear();
                              }
                              catch(e:Error)
                              {
                                 log("Texture restoration failed for \'" + name + "\': " + e.message);
                              }
                              _numRestoredTextures++;
                              Starling.current.stage.setRequiresRedraw();
                              if(_numLostTextures == _numRestoredTextures)
                              {
                                 dispatchEventWith("texturesRestored");
                              }
                           });
                        };
                        bytes.clear();
                     }
                     else if(byteArrayStartsWith(bytes,"{") || byteArrayStartsWith(bytes,"["))
                     {
                        try
                        {
                           object = JSON.parse(bytes.readUTFBytes(bytes.length));
                        }
                        catch(e:Error)
                        {
                           log("Could not parse JSON: " + e.message);
                           dispatchEventWith("parseError",false,name);
                        }
                        if(object)
                        {
                           addObject(name,object);
                        }
                        bytes.clear();
                        onComplete();
                     }
                     else if(byteArrayStartsWith(bytes,"<"))
                     {
                        try
                        {
                           xml = new XML(bytes);
                        }
                        catch(e:Error)
                        {
                           log("Could not parse XML: " + e.message);
                           dispatchEventWith("parseError",false,name);
                        }
                        process(xml);
                        bytes.clear();
                     }
                     else
                     {
                        addByteArray(name,bytes);
                        onComplete();
                     }
                  }
                  else
                  {
                     addObject(name,asset);
                     onComplete();
                  }
               }
            }
            asset = null;
            bytes = null;
            removeEventListener("cancel",cancel);
         };
         var progress:* = function(param1:Number):void
         {
            if(!canceled)
            {
               onProgress(param1);
            }
         };
         var cancel:* = function():void
         {
            canceled = true;
         };
         var canceled:Boolean = false;
         addEventListener("cancel",cancel);
         loadRawAsset(rawAsset,progress,process);
      }
      
      protected function loadRawAsset(param1:Object, param2:Function, param3:Function) : void
      {
         var rawAsset:Object = param1;
         var onProgress:Function = param2;
         var onComplete:Function = param3;
         var onIoError:* = function(param1:IOErrorEvent):void
         {
            log("IO error: " + param1.text);
            dispatchEventWith("ioError",false,url);
            complete(null);
         };
         var onSecurityError:* = function(param1:SecurityErrorEvent):void
         {
            log("security error: " + param1.text);
            dispatchEventWith("securityError",false,url);
            complete(null);
         };
         var onHttpResponseStatus:* = function(param1:HTTPStatusEvent):void
         {
            var _loc2_:Array = null;
            var _loc3_:String = null;
            if(extension == null)
            {
               _loc2_ = param1["responseHeaders"];
               _loc3_ = getHttpHeader(_loc2_,"Content-Type");
               if(_loc3_ && /(audio|image)\//.exec(_loc3_))
               {
                  extension = _loc3_.split("/").pop();
               }
            }
         };
         var onLoadProgress:* = function(param1:ProgressEvent):void
         {
            if(onProgress != null && param1.bytesTotal > 0)
            {
               onProgress(param1.bytesLoaded / param1.bytesTotal);
            }
         };
         var onUrlLoaderComplete:* = function(param1:Object):void
         {
            var _loc5_:Sound = null;
            var _loc3_:LoaderContext = null;
            var _loc4_:Loader = null;
            var _loc2_:ByteArray = transformData(urlLoader.data as ByteArray,url);
            if(_loc2_ == null)
            {
               complete(null);
               return;
            }
            if(extension)
            {
               extension = extension.toLowerCase();
            }
            switch(extension)
            {
               case "mpeg":
               case "mp3":
                  (_loc5_ = new Sound()).loadCompressedDataFromByteArray(_loc2_,_loc2_.length);
                  _loc2_.clear();
                  complete(_loc5_);
                  break;
               case "jpg":
               case "jpeg":
               case "png":
               case "gif":
                  _loc3_ = new LoaderContext(_checkPolicyFile);
                  _loc4_ = new Loader();
                  _loc3_.imageDecodingPolicy = "onLoad";
                  loaderInfo = _loc4_.contentLoaderInfo;
                  loaderInfo.addEventListener("ioError",onIoError);
                  loaderInfo.addEventListener("complete",onLoaderComplete);
                  _loc4_.loadBytes(_loc2_,_loc3_);
                  break;
               default:
                  complete(_loc2_);
            }
         };
         var onLoaderComplete:* = function(param1:Object):void
         {
            urlLoader.data.clear();
            complete(param1.target.content);
         };
         var complete:* = function(param1:Object):void
         {
            if(urlLoader)
            {
               urlLoader.removeEventListener("ioError",onIoError);
               urlLoader.removeEventListener("securityError",onSecurityError);
               urlLoader.removeEventListener("httpResponseStatus",onHttpResponseStatus);
               urlLoader.removeEventListener("progress",onLoadProgress);
               urlLoader.removeEventListener("complete",onUrlLoaderComplete);
            }
            if(loaderInfo)
            {
               loaderInfo.removeEventListener("ioError",onIoError);
               loaderInfo.removeEventListener("complete",onLoaderComplete);
            }
            if(SystemUtil.isDesktop)
            {
               onComplete(param1);
            }
            else
            {
               SystemUtil.executeWhenApplicationIsActive(onComplete,param1);
            }
         };
         var extension:String = null;
         var loaderInfo:LoaderInfo = null;
         var urlLoader:URLLoader = null;
         var urlRequest:URLRequest = null;
         var url:String = null;
         if(rawAsset is Class)
         {
            setTimeout(complete,1,new rawAsset());
         }
         else if(rawAsset is String || rawAsset is URLRequest)
         {
            urlRequest = rawAsset as URLRequest || new URLRequest(rawAsset as String);
            url = urlRequest.url;
            extension = getExtensionFromUrl(url);
            urlLoader = new URLLoader();
            urlLoader.dataFormat = "binary";
            urlLoader.addEventListener("ioError",onIoError);
            urlLoader.addEventListener("securityError",onSecurityError);
            urlLoader.addEventListener("httpResponseStatus",onHttpResponseStatus);
            urlLoader.addEventListener("progress",onLoadProgress);
            urlLoader.addEventListener("complete",onUrlLoaderComplete);
            urlLoader.load(urlRequest);
         }
      }
      
      protected function getName(param1:Object) : String
      {
         var _loc2_:String = null;
         if(param1 is String)
         {
            _loc2_ = param1 as String;
         }
         else if(param1 is URLRequest)
         {
            _loc2_ = (param1 as URLRequest).url;
         }
         else if(param1 is FileReference)
         {
            _loc2_ = (param1 as FileReference).name;
         }
         if(_loc2_)
         {
            _loc2_ = _loc2_.replace(/%20/g," ");
            _loc2_ = getBasenameFromUrl(_loc2_);
            if(_loc2_)
            {
               return _loc2_;
            }
            throw new ArgumentError("Could not extract name from String \'" + param1 + "\'");
         }
         _loc2_ = getQualifiedClassName(param1);
         throw new ArgumentError("Cannot extract names for objects of type \'" + _loc2_ + "\'");
      }
      
      protected function transformData(param1:ByteArray, param2:String) : ByteArray
      {
         return param1;
      }
      
      protected function log(param1:String) : void
      {
         if(_verbose)
         {
            trace("[AssetManager]",param1);
         }
      }
      
      private function byteArrayStartsWith(param1:ByteArray, param2:String) : Boolean
      {
         var _loc7_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = int(param1.length);
         var _loc3_:int = param2.charCodeAt(0);
         if(_loc6_ >= 4 && (param1[0] == 0 && param1[1] == 0 && param1[2] == 254 && param1[3] == 255) || param1[0] == 255 && param1[1] == 254 && param1[2] == 0 && param1[3] == 0)
         {
            _loc5_ = 4;
         }
         else if(_loc6_ >= 3 && param1[0] == 239 && param1[1] == 187 && param1[2] == 191)
         {
            _loc5_ = 3;
         }
         else if(_loc6_ >= 2 && (param1[0] == 254 && param1[1] == 255) || param1[0] == 255 && param1[1] == 254)
         {
            _loc5_ = 2;
         }
         _loc7_ = _loc5_;
         while(_loc7_ < _loc6_)
         {
            if(!((_loc4_ = int(param1[_loc7_])) == 0 || _loc4_ == 10 || _loc4_ == 13 || _loc4_ == 32))
            {
               return _loc4_ == _loc3_;
            }
            _loc7_++;
         }
         return false;
      }
      
      private function getDictionaryKeys(param1:Dictionary, param2:String = "", param3:Vector.<String> = null) : Vector.<String>
      {
         if(param3 == null)
         {
            param3 = new Vector.<String>(0);
         }
         for(var _loc4_ in param1)
         {
            if(_loc4_.indexOf(param2) == 0)
            {
               param3[param3.length] = _loc4_;
            }
         }
         param3.sort(1);
         return param3;
      }
      
      private function getHttpHeader(param1:Array, param2:String) : String
      {
         if(param1)
         {
            for each(var _loc3_ in param1)
            {
               if(_loc3_.name == param2)
               {
                  return _loc3_.value;
               }
            }
         }
         return null;
      }
      
      protected function getBasenameFromUrl(param1:String) : String
      {
         var _loc2_:Array = NAME_REGEX.exec(param1);
         if(_loc2_ && _loc2_.length > 0)
         {
            return _loc2_[1];
         }
         return null;
      }
      
      protected function getExtensionFromUrl(param1:String) : String
      {
         var _loc2_:Array = NAME_REGEX.exec(param1);
         if(_loc2_ && _loc2_.length > 1)
         {
            return _loc2_[2];
         }
         return null;
      }
      
      private function prependCallback(param1:Function, param2:Function) : Function
      {
         var oldCallback:Function = param1;
         var newCallback:Function = param2;
         if(oldCallback == null)
         {
            return newCallback;
         }
         if(newCallback == null)
         {
            return oldCallback;
         }
         return function():void
         {
            newCallback();
            oldCallback();
         };
      }
      
      protected function get queue() : Array
      {
         return _queue;
      }
      
      public function get numQueuedAssets() : int
      {
         return _queue.length;
      }
      
      public function get verbose() : Boolean
      {
         return _verbose;
      }
      
      public function set verbose(param1:Boolean) : void
      {
         _verbose = param1;
      }
      
      public function get isLoading() : Boolean
      {
         return _numLoadingQueues > 0;
      }
      
      public function get useMipMaps() : Boolean
      {
         return _defaultTextureOptions.mipMapping;
      }
      
      public function set useMipMaps(param1:Boolean) : void
      {
         _defaultTextureOptions.mipMapping = param1;
      }
      
      public function get scaleFactor() : Number
      {
         return _defaultTextureOptions.scale;
      }
      
      public function set scaleFactor(param1:Number) : void
      {
         _defaultTextureOptions.scale = param1;
      }
      
      public function get textureFormat() : String
      {
         return _defaultTextureOptions.format;
      }
      
      public function set textureFormat(param1:String) : void
      {
         _defaultTextureOptions.format = param1;
      }
      
      public function get forcePotTextures() : Boolean
      {
         return _defaultTextureOptions.forcePotTexture;
      }
      
      public function set forcePotTextures(param1:Boolean) : void
      {
         _defaultTextureOptions.forcePotTexture = param1;
      }
      
      public function get checkPolicyFile() : Boolean
      {
         return _checkPolicyFile;
      }
      
      public function set checkPolicyFile(param1:Boolean) : void
      {
         _checkPolicyFile = param1;
      }
      
      public function get keepAtlasXmls() : Boolean
      {
         return _keepAtlasXmls;
      }
      
      public function set keepAtlasXmls(param1:Boolean) : void
      {
         _keepAtlasXmls = param1;
      }
      
      public function get keepFontXmls() : Boolean
      {
         return _keepFontXmls;
      }
      
      public function set keepFontXmls(param1:Boolean) : void
      {
         _keepFontXmls = param1;
      }
      
      public function get numConnections() : int
      {
         return _numConnections;
      }
      
      public function set numConnections(param1:int) : void
      {
         _numConnections = param1;
      }
   }
}
