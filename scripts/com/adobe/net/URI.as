package com.adobe.net
{
   public class URI
   {
      
      public static const URImustEscape:String = " %";
      
      public static const URIbaselineEscape:String = " %:?#/@";
      
      public static const URIpathEscape:String = " %?#";
      
      public static const URIqueryEscape:String = " %#";
      
      public static const URIqueryPartEscape:String = " %#&=";
      
      public static const URInonHierEscape:String = " %?#/";
      
      public static const UNKNOWN_SCHEME:String = "unknown";
      
      protected static const URIbaselineExcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(" %:?#/@");
      
      protected static const URIschemeExcludedBitmap:URIEncodingBitmap = URIbaselineExcludedBitmap;
      
      protected static const URIuserpassExcludedBitmap:URIEncodingBitmap = URIbaselineExcludedBitmap;
      
      protected static const URIauthorityExcludedBitmap:URIEncodingBitmap = URIbaselineExcludedBitmap;
      
      protected static const URIportExludedBitmap:URIEncodingBitmap = URIbaselineExcludedBitmap;
      
      protected static const URIpathExcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(" %?#");
      
      protected static const URIqueryExcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(" %#");
      
      protected static const URIqueryPartExcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(" %#&=");
      
      protected static const URIfragmentExcludedBitmap:URIEncodingBitmap = URIqueryExcludedBitmap;
      
      protected static const URInonHierexcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(" %?#/");
      
      public static const NOT_RELATED:int = 0;
      
      public static const CHILD:int = 1;
      
      public static const EQUAL:int = 2;
      
      public static const PARENT:int = 3;
      
      protected static var _resolver:IURIResolver = null;
       
      
      protected var _valid:Boolean = false;
      
      protected var _relative:Boolean = false;
      
      protected var _scheme:String = "";
      
      protected var _authority:String = "";
      
      protected var _username:String = "";
      
      protected var _password:String = "";
      
      protected var _port:String = "";
      
      protected var _path:String = "";
      
      protected var _query:String = "";
      
      protected var _fragment:String = "";
      
      protected var _nonHierarchical:String = "";
      
      public function URI(param1:String = null)
      {
         super();
         if(param1 == null)
         {
            initialize();
         }
         else
         {
            constructURI(param1);
         }
      }
      
      public static function escapeChars(param1:String) : String
      {
         return fastEscapeChars(param1,URI.URIbaselineExcludedBitmap);
      }
      
      public static function unescapeChars(param1:String) : String
      {
         var _loc2_:* = null;
         return decodeURIComponent(param1);
      }
      
      public static function fastEscapeChars(param1:String, param2:URIEncodingBitmap) : String
      {
         var _loc3_:String = null;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:String = "";
         _loc6_ = 0;
         while(_loc6_ < param1.length)
         {
            _loc3_ = param1.charAt(_loc6_);
            if(_loc5_ = param2.ShouldEscape(_loc3_))
            {
               _loc3_ = _loc5_.toString(16);
               if(_loc3_.length == 1)
               {
                  _loc3_ = "0" + _loc3_;
               }
               _loc3_ = "%" + _loc3_;
               _loc3_ = _loc3_.toUpperCase();
            }
            _loc4_ += _loc3_;
            _loc6_++;
         }
         return _loc4_;
      }
      
      public static function queryPartEscape(param1:String) : String
      {
         var _loc2_:* = param1;
         return String(URI.fastEscapeChars(param1,URI.URIqueryPartExcludedBitmap));
      }
      
      public static function queryPartUnescape(param1:String) : String
      {
         var _loc2_:* = param1;
         return unescapeChars(_loc2_);
      }
      
      protected static function compareStr(param1:String, param2:String, param3:Boolean = true) : Boolean
      {
         if(param3 == false)
         {
            param1 = param1.toLowerCase();
            param2 = param2.toLowerCase();
         }
         return param1 == param2;
      }
      
      protected static function resolve(param1:URI) : URI
      {
         var _loc2_:URI = new URI();
         _loc2_.copyURI(param1);
         if(_resolver != null)
         {
            return _resolver.resolve(_loc2_);
         }
         return _loc2_;
      }
      
      public static function set resolver(param1:IURIResolver) : void
      {
         _resolver = param1;
      }
      
      public static function get resolver() : IURIResolver
      {
         return _resolver;
      }
      
      protected function constructURI(param1:String) : Boolean
      {
         if(!parseURI(param1))
         {
            _valid = false;
         }
         return isValid();
      }
      
      protected function initialize() : void
      {
         _valid = false;
         _relative = false;
         _scheme = "unknown";
         _authority = "";
         _username = "";
         _password = "";
         _port = "";
         _path = "";
         _query = "";
         _fragment = "";
         _nonHierarchical = "";
      }
      
      protected function set hierState(param1:Boolean) : void
      {
         if(param1)
         {
            _nonHierarchical = "";
            if(_scheme == "" || _scheme == "unknown")
            {
               _relative = true;
            }
            else
            {
               _relative = false;
            }
            if(_authority.length == 0 && _path.length == 0)
            {
               _valid = false;
            }
            else
            {
               _valid = true;
            }
         }
         else
         {
            _authority = "";
            _username = "";
            _password = "";
            _port = "";
            _path = "";
            _relative = false;
            if(_scheme == "" || _scheme == "unknown")
            {
               _valid = false;
            }
            else
            {
               _valid = true;
            }
         }
      }
      
      protected function get hierState() : Boolean
      {
         return _nonHierarchical.length == 0;
      }
      
      protected function validateURI() : Boolean
      {
         if(isAbsolute())
         {
            if(_scheme.length <= 1 || _scheme == "unknown")
            {
               return false;
            }
            if(verifyAlpha(_scheme) == false)
            {
               return false;
            }
         }
         if(hierState)
         {
            if(_path.search("\\") != -1)
            {
               return false;
            }
            if(isRelative() == false && _scheme == "unknown")
            {
               return false;
            }
         }
         else if(_nonHierarchical.search("\\") != -1)
         {
            return false;
         }
         return true;
      }
      
      protected function parseURI(param1:String) : Boolean
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc7_:* = param1;
         initialize();
         _loc3_ = _loc7_.indexOf("#");
         if(_loc3_ != -1)
         {
            if(_loc7_.length > _loc3_ + 1)
            {
               _fragment = _loc7_.substr(_loc3_ + 1,_loc7_.length - (_loc3_ + 1));
            }
            _loc7_ = _loc7_.substr(0,_loc3_);
         }
         _loc3_ = _loc7_.indexOf("?");
         if(_loc3_ != -1)
         {
            if(_loc7_.length > _loc3_ + 1)
            {
               _query = _loc7_.substr(_loc3_ + 1,_loc7_.length - (_loc3_ + 1));
            }
            _loc7_ = _loc7_.substr(0,_loc3_);
         }
         _loc3_ = _loc7_.search(":");
         _loc5_ = _loc7_.search("/");
         var _loc6_:* = _loc3_ != -1;
         var _loc4_:*;
         var _loc2_:Boolean = !(_loc4_ = _loc5_ != -1) || _loc3_ < _loc5_;
         if(_loc6_ && _loc2_)
         {
            _scheme = _loc7_.substr(0,_loc3_);
            _scheme = _scheme.toLowerCase();
            if((_loc7_ = _loc7_.substr(_loc3_ + 1)).substr(0,2) != "//")
            {
               _nonHierarchical = _loc7_;
               if((_valid = validateURI()) == false)
               {
                  initialize();
               }
               return isValid();
            }
            _nonHierarchical = "";
            _loc7_ = _loc7_.substr(2,_loc7_.length - 2);
         }
         else
         {
            _scheme = "";
            _relative = true;
            _nonHierarchical = "";
         }
         if(isRelative())
         {
            _authority = "";
            _port = "";
            _path = _loc7_;
         }
         else
         {
            if(_loc7_.substr(0,2) == "//")
            {
               while(_loc7_.charAt(0) == "/")
               {
                  _loc7_ = _loc7_.substr(1,_loc7_.length - 1);
               }
            }
            _loc3_ = _loc7_.search("/");
            if(_loc3_ == -1)
            {
               _authority = _loc7_;
               _path = "";
            }
            else
            {
               _authority = _loc7_.substr(0,_loc3_);
               _path = _loc7_.substr(_loc3_,_loc7_.length - _loc3_);
            }
            _loc3_ = _authority.search("@");
            if(_loc3_ != -1)
            {
               _username = _authority.substr(0,_loc3_);
               _authority = _authority.substr(_loc3_ + 1);
               _loc3_ = _username.search(":");
               if(_loc3_ != -1)
               {
                  _password = _username.substring(_loc3_ + 1,_username.length);
                  _username = _username.substr(0,_loc3_);
               }
               else
               {
                  _password = "";
               }
            }
            else
            {
               _username = "";
               _password = "";
            }
            _loc3_ = _authority.search(":");
            if(_loc3_ != -1)
            {
               _port = _authority.substring(_loc3_ + 1,_authority.length);
               _authority = _authority.substr(0,_loc3_);
            }
            else
            {
               _port = "";
            }
            _authority = _authority.toLowerCase();
         }
         if((_valid = validateURI()) == false)
         {
            initialize();
         }
         return isValid();
      }
      
      public function copyURI(param1:URI) : void
      {
         this._scheme = param1._scheme;
         this._authority = param1._authority;
         this._username = param1._username;
         this._password = param1._password;
         this._port = param1._port;
         this._path = param1._path;
         this._query = param1._query;
         this._fragment = param1._fragment;
         this._nonHierarchical = param1._nonHierarchical;
         this._valid = param1._valid;
         this._relative = param1._relative;
      }
      
      protected function verifyAlpha(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:RegExp = /[^a-z]/;
         param1 = param1.toLowerCase();
         _loc2_ = param1.search(_loc3_);
         if(_loc2_ == -1)
         {
            return true;
         }
         return false;
      }
      
      public function isValid() : Boolean
      {
         return this._valid;
      }
      
      public function isAbsolute() : Boolean
      {
         return !this._relative;
      }
      
      public function isRelative() : Boolean
      {
         return this._relative;
      }
      
      public function isDirectory() : Boolean
      {
         if(_path.length == 0)
         {
            return false;
         }
         return _path.charAt(path.length - 1) == "/";
      }
      
      public function isHierarchical() : Boolean
      {
         return hierState;
      }
      
      public function get scheme() : String
      {
         return URI.unescapeChars(_scheme);
      }
      
      public function set scheme(param1:String) : void
      {
         var _loc2_:String = param1.toLowerCase();
         _scheme = URI.fastEscapeChars(_loc2_,URI.URIschemeExcludedBitmap);
      }
      
      public function get authority() : String
      {
         return URI.unescapeChars(_authority);
      }
      
      public function set authority(param1:String) : void
      {
         param1 = param1.toLowerCase();
         _authority = URI.fastEscapeChars(param1,URI.URIauthorityExcludedBitmap);
         this.hierState = true;
      }
      
      public function get username() : String
      {
         return URI.unescapeChars(_username);
      }
      
      public function set username(param1:String) : void
      {
         _username = URI.fastEscapeChars(param1,URI.URIuserpassExcludedBitmap);
         this.hierState = true;
      }
      
      public function get password() : String
      {
         return URI.unescapeChars(_password);
      }
      
      public function set password(param1:String) : void
      {
         _password = URI.fastEscapeChars(param1,URI.URIuserpassExcludedBitmap);
         this.hierState = true;
      }
      
      public function get port() : String
      {
         return URI.unescapeChars(_port);
      }
      
      public function set port(param1:String) : void
      {
         _port = URI.escapeChars(param1);
         this.hierState = true;
      }
      
      public function get path() : String
      {
         return URI.unescapeChars(_path);
      }
      
      public function set path(param1:String) : void
      {
         this._path = URI.fastEscapeChars(param1,URI.URIpathExcludedBitmap);
         if(this._scheme == "unknown")
         {
            this._scheme = "";
         }
         hierState = true;
      }
      
      public function get query() : String
      {
         return URI.unescapeChars(_query);
      }
      
      public function set query(param1:String) : void
      {
         _query = URI.fastEscapeChars(param1,URI.URIqueryExcludedBitmap);
      }
      
      public function get queryRaw() : String
      {
         return _query;
      }
      
      public function set queryRaw(param1:String) : void
      {
         _query = param1;
      }
      
      public function get fragment() : String
      {
         return URI.unescapeChars(_fragment);
      }
      
      public function set fragment(param1:String) : void
      {
         _fragment = URI.fastEscapeChars(param1,URIfragmentExcludedBitmap);
      }
      
      public function get nonHierarchical() : String
      {
         return URI.unescapeChars(_nonHierarchical);
      }
      
      public function set nonHierarchical(param1:String) : void
      {
         _nonHierarchical = URI.fastEscapeChars(param1,URInonHierexcludedBitmap);
         this.hierState = false;
      }
      
      public function setParts(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String) : void
      {
         this.scheme = param1;
         this.authority = param2;
         this.port = param3;
         this.path = param4;
         this.query = param5;
         this.fragment = param6;
         hierState = true;
      }
      
      public function isOfType(param1:String) : Boolean
      {
         param1 = param1.toLowerCase();
         return this._scheme == param1;
      }
      
      public function getQueryValue(param1:String) : String
      {
         var _loc4_:Object = null;
         var _loc2_:String = null;
         var _loc3_:* = null;
         _loc4_ = getQueryByMap();
         for(_loc2_ in _loc4_)
         {
            if(_loc2_ == param1)
            {
               return String(_loc4_[_loc2_]);
            }
         }
         return new String("");
      }
      
      public function setQueryValue(param1:String, param2:String) : void
      {
         var _loc3_:Object = null;
         _loc3_ = getQueryByMap();
         _loc3_[param1] = param2;
         setQueryByMap(_loc3_);
      }
      
      public function getQueryByMap() : Object
      {
         var _loc8_:String = null;
         var _loc3_:* = null;
         var _loc2_:Array = null;
         var _loc5_:Array = null;
         var _loc7_:String = null;
         var _loc4_:String = null;
         var _loc1_:int = 0;
         var _loc6_:Object = {};
         _loc2_ = (_loc8_ = this._query).split("&");
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.length != 0)
            {
               if((_loc5_ = _loc3_.split("=")).length > 0)
               {
                  _loc4_ = String(_loc5_[0]);
                  if(_loc5_.length > 1)
                  {
                     _loc7_ = String(_loc5_[1]);
                  }
                  else
                  {
                     _loc7_ = "";
                  }
                  _loc4_ = queryPartUnescape(_loc4_);
                  _loc7_ = queryPartUnescape(_loc7_);
                  _loc6_[_loc4_] = _loc7_;
               }
            }
         }
         return _loc6_;
      }
      
      public function setQueryByMap(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc6_:* = null;
         var _loc7_:String = "";
         for(_loc4_ in param1)
         {
            _loc3_ = _loc4_;
            if((_loc5_ = String(param1[_loc4_])) == null)
            {
               _loc5_ = "";
            }
            _loc3_ = queryPartEscape(_loc3_);
            _loc5_ = queryPartEscape(_loc5_);
            _loc2_ = _loc3_;
            if(_loc5_.length > 0)
            {
               _loc2_ += "=";
               _loc2_ += _loc5_;
            }
            if(_loc7_.length != 0)
            {
               _loc7_ += "&";
            }
            _loc7_ += _loc2_;
         }
         _query = _loc7_;
      }
      
      public function toString() : String
      {
         if(this == null)
         {
            return "";
         }
         return toStringInternal(false);
      }
      
      public function toDisplayString() : String
      {
         return toStringInternal(true);
      }
      
      protected function toStringInternal(param1:Boolean) : String
      {
         var _loc3_:String = "";
         var _loc2_:String = "";
         if(isHierarchical() == false)
         {
            _loc3_ += param1 ? this.scheme : _scheme;
            _loc3_ += ":";
            _loc3_ += param1 ? this.nonHierarchical : _nonHierarchical;
         }
         else
         {
            if(isRelative() == false)
            {
               if(_scheme.length != 0)
               {
                  _loc2_ = param1 ? this.scheme : _scheme;
                  _loc3_ += _loc2_ + ":";
               }
               if(_authority.length != 0 || isOfType("file"))
               {
                  _loc3_ += "//";
                  if(_username.length != 0)
                  {
                     _loc2_ = param1 ? this.username : _username;
                     _loc3_ += _loc2_;
                     if(_password.length != 0)
                     {
                        _loc2_ = param1 ? this.password : _password;
                        _loc3_ += ":" + _loc2_;
                     }
                     _loc3_ += "@";
                  }
                  _loc2_ = param1 ? this.authority : _authority;
                  _loc3_ += _loc2_;
                  if(port.length != 0)
                  {
                     _loc3_ += ":" + port;
                  }
               }
            }
            _loc2_ = param1 ? this.path : _path;
            _loc3_ += _loc2_;
         }
         if(_query.length != 0)
         {
            _loc2_ = param1 ? this.query : _query;
            _loc3_ += "?" + _loc2_;
         }
         if(fragment.length != 0)
         {
            _loc2_ = param1 ? this.fragment : _fragment;
            _loc3_ += "#" + _loc2_;
         }
         return _loc3_;
      }
      
      public function forceEscape() : void
      {
         this.scheme = this.scheme;
         this.setQueryByMap(this.getQueryByMap());
         this.fragment = this.fragment;
         if(isHierarchical())
         {
            this.authority = this.authority;
            this.path = this.path;
            this.port = this.port;
            this.username = this.username;
            this.password = this.password;
         }
         else
         {
            this.nonHierarchical = this.nonHierarchical;
         }
      }
      
      public function isOfFileType(param1:String) : Boolean
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         _loc2_ = param1.lastIndexOf(".");
         if(_loc2_ != -1)
         {
            param1 = param1.substr(_loc2_ + 1);
         }
         _loc3_ = getExtension(true);
         if(_loc3_ == "")
         {
            return false;
         }
         if(compareStr(_loc3_,param1,false) == 0)
         {
            return true;
         }
         return false;
      }
      
      public function getExtension(param1:Boolean = false) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String;
         if((_loc4_ = getFilename()) == "")
         {
            return "";
         }
         _loc3_ = _loc4_.lastIndexOf(".");
         if(_loc3_ == -1 || _loc3_ == 0)
         {
            return "";
         }
         _loc2_ = _loc4_.substr(_loc3_);
         if(param1 && _loc2_.charAt(0) == ".")
         {
            _loc2_ = _loc2_.substr(1);
         }
         return _loc2_;
      }
      
      public function getFilename(param1:Boolean = false) : String
      {
         var _loc3_:* = null;
         var _loc2_:int = 0;
         if(isDirectory())
         {
            return "";
         }
         var _loc4_:String;
         _loc2_ = (_loc4_ = this.path).lastIndexOf("/");
         if(_loc2_ != -1)
         {
            _loc3_ = _loc4_.substr(_loc2_ + 1);
         }
         else
         {
            _loc3_ = _loc4_;
         }
         if(param1)
         {
            _loc2_ = _loc3_.lastIndexOf(".");
            if(_loc2_ != -1)
            {
               _loc3_ = _loc3_.substr(0,_loc2_);
            }
         }
         return _loc3_;
      }
      
      public function getDefaultPort() : String
      {
         if(_scheme == "http")
         {
            return "80";
         }
         if(_scheme == "ftp")
         {
            return "21";
         }
         if(_scheme == "file")
         {
            return "";
         }
         if(_scheme == "sftp")
         {
            return "22";
         }
         return "";
      }
      
      public function getRelation(param1:URI, param2:Boolean = true) : int
      {
         var _loc5_:Array = null;
         var _loc9_:Array = null;
         var _loc7_:String = null;
         var _loc13_:String = null;
         var _loc8_:int = 0;
         var _loc12_:URI = URI.resolve(this);
         var _loc4_:URI = URI.resolve(param1);
         if(_loc12_.isRelative() || _loc4_.isRelative())
         {
            return 0;
         }
         if(_loc12_.isHierarchical() == false || _loc4_.isHierarchical() == false)
         {
            if(_loc12_.isHierarchical() == false && _loc4_.isHierarchical() == true || _loc12_.isHierarchical() == true && _loc4_.isHierarchical() == false)
            {
               return 0;
            }
            if(_loc12_.scheme != _loc4_.scheme)
            {
               return 0;
            }
            if(_loc12_.nonHierarchical != _loc4_.nonHierarchical)
            {
               return 0;
            }
            return 2;
         }
         if(_loc12_.scheme != _loc4_.scheme)
         {
            return 0;
         }
         if(_loc12_.authority != _loc4_.authority)
         {
            return 0;
         }
         var _loc11_:String = _loc12_.port;
         var _loc3_:String = _loc4_.port;
         if(_loc11_ == "")
         {
            _loc11_ = _loc12_.getDefaultPort();
         }
         if(_loc3_ == "")
         {
            _loc3_ = _loc4_.getDefaultPort();
         }
         if(_loc11_ != _loc3_)
         {
            return 0;
         }
         if(compareStr(_loc12_.path,_loc4_.path,param2))
         {
            return 2;
         }
         var _loc6_:String = _loc12_.path;
         var _loc10_:String = _loc4_.path;
         if((_loc6_ == "/" || _loc10_ == "/") && (_loc6_ == "" || _loc10_ == ""))
         {
            return 2;
         }
         _loc9_ = _loc6_.split("/");
         _loc5_ = _loc10_.split("/");
         if(_loc9_.length > _loc5_.length)
         {
            if((_loc7_ = String(_loc5_[_loc5_.length - 1])).length > 0)
            {
               return 0;
            }
            _loc5_.pop();
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               _loc13_ = String(_loc9_[_loc8_]);
               _loc7_ = String(_loc5_[_loc8_]);
               if(compareStr(_loc13_,_loc7_,param2) == false)
               {
                  return 0;
               }
               _loc8_++;
            }
            return 1;
         }
         if(_loc9_.length < _loc5_.length)
         {
            if((_loc13_ = String(_loc9_[_loc9_.length - 1])).length > 0)
            {
               return 0;
            }
            _loc9_.pop();
            _loc8_ = 0;
            while(_loc8_ < _loc9_.length)
            {
               _loc13_ = String(_loc9_[_loc8_]);
               _loc7_ = String(_loc5_[_loc8_]);
               if(compareStr(_loc13_,_loc7_,param2) == false)
               {
                  return 0;
               }
               _loc8_++;
            }
            return 3;
         }
         return 0;
      }
      
      public function getCommonParent(param1:URI, param2:Boolean = true) : URI
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:URI = URI.resolve(this);
         var _loc3_:URI = URI.resolve(param1);
         if(!_loc7_.isAbsolute() || !_loc3_.isAbsolute() || _loc7_.isHierarchical() == false || _loc3_.isHierarchical() == false)
         {
            return null;
         }
         var _loc4_:int;
         if((_loc4_ = _loc7_.getRelation(_loc3_)) == 0)
         {
            return null;
         }
         _loc7_.chdir(".");
         _loc3_.chdir(".");
         while(!((_loc4_ = _loc7_.getRelation(_loc3_,param2)) == 2 || _loc4_ == 3))
         {
            _loc6_ = _loc7_.toString();
            _loc7_.chdir("..");
            _loc5_ = _loc7_.toString();
            if(_loc6_ == _loc5_)
            {
               break;
            }
         }
         return _loc7_;
      }
      
      public function chdir(param1:String, param2:Boolean = false) : Boolean
      {
         var _loc14_:URI = null;
         var _loc3_:String = null;
         var _loc16_:String = null;
         var _loc9_:String = null;
         var _loc4_:Array = null;
         var _loc12_:Array = null;
         var _loc15_:String = null;
         var _loc10_:int = 0;
         var _loc11_:* = param1;
         if(param2)
         {
            _loc11_ = URI.escapeChars(param1);
         }
         if(_loc11_ == "")
         {
            return true;
         }
         if(_loc11_.substr(0,2) == "//")
         {
            _loc3_ = this.scheme + ":" + _loc11_;
            return constructURI(_loc3_);
         }
         if(_loc11_.charAt(0) == "?")
         {
            _loc11_ = "./" + _loc11_;
         }
         if((_loc14_ = new URI(_loc11_)).isAbsolute() || _loc14_.isHierarchical() == false)
         {
            copyURI(_loc14_);
            return true;
         }
         var _loc17_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc7_:Boolean = false;
         _loc9_ = this.path;
         _loc16_ = _loc14_.path;
         if(_loc9_.length > 0)
         {
            _loc12_ = _loc9_.split("/");
         }
         else
         {
            _loc12_ = [];
         }
         if(_loc16_.length > 0)
         {
            _loc4_ = _loc16_.split("/");
         }
         else
         {
            _loc4_ = [];
         }
         if(_loc12_.length > 0 && _loc12_[0] == "")
         {
            _loc6_ = true;
            _loc12_.shift();
         }
         if(_loc12_.length > 0 && _loc12_[_loc12_.length - 1] == "")
         {
            _loc17_ = true;
            _loc12_.pop();
         }
         if(_loc4_.length > 0 && _loc4_[0] == "")
         {
            _loc5_ = true;
            _loc4_.shift();
         }
         if(_loc4_.length > 0 && _loc4_[_loc4_.length - 1] == "")
         {
            _loc13_ = true;
            _loc4_.pop();
         }
         if(_loc5_)
         {
            this.path = _loc14_.path;
            this.queryRaw = _loc14_.queryRaw;
            this.fragment = _loc14_.fragment;
            return true;
         }
         if(_loc4_.length == 0 && _loc14_.query == "")
         {
            this.fragment = _loc14_.fragment;
            return true;
         }
         if(_loc17_ == false && _loc12_.length > 0)
         {
            _loc12_.pop();
         }
         this.queryRaw = _loc14_.queryRaw;
         this.fragment = _loc14_.fragment;
         _loc12_ = _loc12_.concat(_loc4_);
         _loc10_ = 0;
         while(_loc10_ < _loc12_.length)
         {
            _loc15_ = String(_loc12_[_loc10_]);
            _loc7_ = false;
            if(_loc15_ == ".")
            {
               _loc12_.splice(_loc10_,1);
               _loc10_ -= 1;
               _loc7_ = true;
            }
            else if(_loc15_ == "..")
            {
               if(_loc10_ >= 1)
               {
                  if(_loc12_[_loc10_ - 1] != "..")
                  {
                     _loc12_.splice(_loc10_ - 1,2);
                     _loc10_ -= 2;
                  }
               }
               else if(!isRelative())
               {
                  _loc12_.splice(_loc10_,1);
                  _loc10_ -= 1;
               }
               _loc7_ = true;
            }
            _loc10_++;
         }
         var _loc8_:String = "";
         _loc13_ ||= _loc7_;
         _loc8_ = joinPath(_loc12_,_loc6_,_loc13_);
         this.path = _loc8_;
         return true;
      }
      
      protected function joinPath(param1:Array, param2:Boolean, param3:Boolean) : String
      {
         var _loc5_:int = 0;
         var _loc4_:String = "";
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            if(_loc4_.length > 0)
            {
               _loc4_ += "/";
            }
            _loc4_ += param1[_loc5_];
            _loc5_++;
         }
         if(param3 && _loc4_.length > 0)
         {
            _loc4_ += "/";
         }
         if(param2)
         {
            _loc4_ = "/" + _loc4_;
         }
         return _loc4_;
      }
      
      public function makeAbsoluteURI(param1:URI) : Boolean
      {
         if(isAbsolute() || param1.isRelative())
         {
            return false;
         }
         var _loc2_:URI = new URI();
         _loc2_.copyURI(param1);
         if(_loc2_.chdir(toString()) == false)
         {
            return false;
         }
         copyURI(_loc2_);
         return true;
      }
      
      public function makeRelativeURI(param1:URI, param2:Boolean = true) : Boolean
      {
         var _loc3_:Array = null;
         var _loc12_:Array = null;
         var _loc7_:String = null;
         var _loc6_:String = null;
         var _loc15_:String = null;
         var _loc11_:int = 0;
         var _loc14_:URI;
         (_loc14_ = new URI()).copyURI(param1);
         var _loc5_:Array = [];
         var _loc8_:String = this.path;
         var _loc10_:String = this.queryRaw;
         var _loc16_:String = this.fragment;
         var _loc4_:Boolean = false;
         var _loc9_:Boolean = false;
         if(isRelative())
         {
            return true;
         }
         if(_loc14_.isRelative())
         {
            return false;
         }
         if(isOfType(param1.scheme) == false || this.authority != param1.authority)
         {
            return false;
         }
         _loc9_ = isDirectory();
         _loc14_.chdir(".");
         _loc12_ = _loc8_.split("/");
         _loc3_ = _loc14_.path.split("/");
         if(_loc12_.length > 0 && _loc12_[0] == "")
         {
            _loc12_.shift();
         }
         if(_loc12_.length > 0 && _loc12_[_loc12_.length - 1] == "")
         {
            _loc9_ = true;
            _loc12_.pop();
         }
         if(_loc3_.length > 0 && _loc3_[0] == "")
         {
            _loc3_.shift();
         }
         if(_loc3_.length > 0 && _loc3_[_loc3_.length - 1] == "")
         {
            _loc3_.pop();
         }
         while(_loc3_.length > 0)
         {
            if(_loc12_.length == 0)
            {
               break;
            }
            _loc15_ = String(_loc12_[0]);
            _loc7_ = String(_loc3_[0]);
            if(!compareStr(_loc15_,_loc7_,param2))
            {
               break;
            }
            _loc12_.shift();
            _loc3_.shift();
         }
         var _loc13_:String = "..";
         _loc11_ = 0;
         while(_loc11_ < _loc3_.length)
         {
            _loc5_.push(_loc13_);
            _loc11_++;
         }
         _loc5_ = _loc5_.concat(_loc12_);
         if((_loc6_ = joinPath(_loc5_,false,_loc9_)).length == 0)
         {
            _loc6_ = "./";
         }
         setParts("","","",_loc6_,_loc10_,_loc16_);
         return true;
      }
      
      public function unknownToURI(param1:String, param2:String = "http") : Boolean
      {
         var _loc4_:String = null;
         var _loc3_:String = null;
         if(param1.length == 0)
         {
            this.initialize();
            return false;
         }
         param1 = param1.replace(/\\/g,"/");
         if(param1.length >= 2)
         {
            if((_loc4_ = param1.substr(0,2)) == "//")
            {
               param1 = param2 + ":" + param1;
            }
         }
         if(param1.length >= 3)
         {
            if((_loc4_ = param1.substr(0,3)) == "://")
            {
               param1 = param2 + param1;
            }
         }
         var _loc5_:URI;
         if((_loc5_ = new URI(param1)).isHierarchical() == false)
         {
            if(_loc5_.scheme == "unknown")
            {
               this.initialize();
               return false;
            }
            copyURI(_loc5_);
            forceEscape();
            return true;
         }
         if(_loc5_.scheme != "unknown" && _loc5_.scheme.length > 0)
         {
            if(_loc5_.authority.length > 0 || _loc5_.scheme == "file")
            {
               copyURI(_loc5_);
               forceEscape();
               return true;
            }
            if(_loc5_.authority.length == 0 && _loc5_.path.length == 0)
            {
               setParts(_loc5_.scheme,"","","","","");
               return false;
            }
         }
         else
         {
            _loc3_ = _loc5_.path;
            if(_loc3_ == ".." || _loc3_ == "." || _loc3_.length >= 3 && _loc3_.substr(0,3) == "../" || _loc3_.length >= 2 && _loc3_.substr(0,2) == "./")
            {
               copyURI(_loc5_);
               forceEscape();
               return true;
            }
         }
         if((_loc5_ = new URI(param2 + "://" + param1)).scheme.length > 0 && _loc5_.authority.length > 0)
         {
            copyURI(_loc5_);
            forceEscape();
            return true;
         }
         this.initialize();
         return false;
      }
   }
}
