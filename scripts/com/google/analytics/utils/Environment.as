package com.google.analytics.utils
{
   import com.google.analytics.core.ga_internal;
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.external.HTMLDOM;
   import core.strings.userAgent;
   import core.uri;
   import core.version;
   import flash.display.DisplayObject;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.system.System;
   
   use namespace ga_internal;
   
   public class Environment
   {
       
      
      private var _debug:DebugConfiguration;
      
      private var _dom:HTMLDOM;
      
      private var _protocol:String;
      
      private var _appName:String;
      
      private var _appVersion:version;
      
      private var _userAgent:String;
      
      private var _url:String;
      
      private var _display:DisplayObject;
      
      public function Environment(param1:String = "", param2:String = "", param3:String = "", param4:DebugConfiguration = null, param5:HTMLDOM = null, param6:DisplayObject = null)
      {
         var _loc7_:version = null;
         super();
         if(param2 == "")
         {
            if(this.isAIR())
            {
               param2 = "AIR";
            }
            else
            {
               param2 = "Flash";
            }
         }
         if(param3 == "")
         {
            _loc7_ = this.flashVersion;
         }
         else
         {
            _loc7_ = getVersionFromString(param3);
         }
         this._url = param1;
         this._appName = param2;
         this._appVersion = _loc7_;
         this._debug = param4;
         this._dom = param5;
         this._display = param6;
      }
      
      private function _findProtocol() : void
      {
         var _loc1_:uri = null;
         this._protocol = "";
         if(this._url != "")
         {
            _loc1_ = new uri(this._url);
            this._protocol = _loc1_.scheme;
         }
      }
      
      public function get appName() : String
      {
         return this._appName;
      }
      
      public function set appName(param1:String) : void
      {
         this._appName = param1;
         this._defineUserAgent();
      }
      
      public function get appVersion() : version
      {
         return this._appVersion;
      }
      
      public function set appVersion(param1:version) : void
      {
         this._appVersion = param1;
         this._defineUserAgent();
      }
      
      ga_internal function set url(param1:String) : void
      {
         this._url = param1;
      }
      
      public function get locationSWFPath() : String
      {
         return this._url;
      }
      
      public function get referrer() : String
      {
         var _loc1_:String = this._dom.referrer;
         if(_loc1_)
         {
            return _loc1_;
         }
         if(this.protocol == "file")
         {
            return "localhost";
         }
         return "";
      }
      
      public function get documentTitle() : String
      {
         var _loc1_:String = this._dom.title;
         if(_loc1_)
         {
            return _loc1_;
         }
         return "";
      }
      
      public function get documentDomainName() : String
      {
         var _host:String = null;
         if(this.protocol == "http" || this.protocol == "https")
         {
            if(this._dom.inIframe)
            {
               _host = !!this._dom.parentHost ? this._dom.parentHost.toLowerCase() : "unknown_host";
            }
            else
            {
               _host = !!this._dom.host ? this._dom.host.toLowerCase() : "unknown_host";
            }
            if(_host == "unknown_host" && this._display != null && this._display.loaderInfo != null)
            {
               try
               {
                  _host = new uri(this._display.loaderInfo.parameters["qs_windowLocation"]).host;
               }
               catch(err:Error)
               {
                  _host = "";
               }
            }
            if(_host)
            {
               return _host;
            }
         }
         return "";
      }
      
      public function get domainName() : String
      {
         var _loc1_:uri = null;
         if(this.protocol == "http" || this.protocol == "https")
         {
            _loc1_ = new uri(this._url.toLowerCase());
            return _loc1_.host;
         }
         if(this.protocol == "file")
         {
            return "localhost";
         }
         return "";
      }
      
      public function isAIR() : Boolean
      {
         return Security.sandboxType == "application";
      }
      
      public function isInHTML() : Boolean
      {
         return Capabilities.playerType == "PlugIn";
      }
      
      public function get locationPath() : String
      {
         var _loc1_:String = this._dom.inIframe ? this._dom.parentPathname : this._dom.pathname;
         if(_loc1_)
         {
            return _loc1_;
         }
         return "";
      }
      
      public function get locationSearch() : String
      {
         var _loc1_:String = this._dom.inIframe ? this._dom.parentSearch : this._dom.search;
         if(_loc1_)
         {
            return _loc1_;
         }
         return "";
      }
      
      public function get flashVersion() : version
      {
         return getVersionFromString(Capabilities.version.split(" ")[1],",");
      }
      
      public function get language() : String
      {
         var _loc1_:String = this._dom.language;
         var _loc2_:String = Capabilities.language;
         if(_loc1_)
         {
            if(_loc1_.length > _loc2_.length && _loc1_.substr(0,_loc2_.length) == _loc2_)
            {
               _loc2_ = _loc1_;
            }
         }
         return _loc2_;
      }
      
      public function get languageEncoding() : String
      {
         var _loc1_:String = null;
         if(System.useCodePage)
         {
            _loc1_ = this._dom.characterSet;
            if(_loc1_)
            {
               return _loc1_;
            }
            return "-";
         }
         return "UTF-8";
      }
      
      public function get operatingSystem() : String
      {
         return Capabilities.os;
      }
      
      public function get playerType() : String
      {
         return Capabilities.playerType;
      }
      
      public function get platform() : String
      {
         var _loc1_:String = Capabilities.manufacturer;
         return _loc1_.split("Adobe ")[1];
      }
      
      public function get protocol() : String
      {
         if(!this._protocol)
         {
            this._findProtocol();
         }
         return this._protocol;
      }
      
      public function get screenHeight() : Number
      {
         return Capabilities.screenResolutionY;
      }
      
      public function get screenWidth() : Number
      {
         return Capabilities.screenResolutionX;
      }
      
      public function get screenColorDepth() : String
      {
         var _loc1_:String = null;
         switch(Capabilities.screenColor)
         {
            case "bw":
               _loc1_ = "1";
               break;
            case "gray":
               _loc1_ = "2";
               break;
            case "color":
            default:
               _loc1_ = "24";
         }
         var _loc2_:String = this._dom.colorDepth;
         if(_loc2_)
         {
            _loc1_ = _loc2_;
         }
         return _loc1_;
      }
      
      private function _defineUserAgent() : void
      {
         this._userAgent = userAgent(this.appName + "/" + this.appVersion.toString(4));
      }
      
      public function get userAgent() : String
      {
         if(!this._userAgent)
         {
            this._defineUserAgent();
         }
         return this._userAgent;
      }
      
      public function set userAgent(param1:String) : void
      {
         this._userAgent = param1;
      }
   }
}
