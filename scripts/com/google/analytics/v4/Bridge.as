package com.google.analytics.v4
{
   import com.google.analytics.core.EventTracker;
   import com.google.analytics.core.ServerOperationMode;
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.external.JavascriptProxy;
   
   public class Bridge implements GoogleAnalyticsAPI
   {
      
      private static var _checkAndLoadGAJS_js:XML = <script>
            <![CDATA[
                function()
                {
					window._gaq = window._gaq || [];
                }
            ]]>
        </script>;
       
      
      private var _account:String;
      
      private var _debug:DebugConfiguration;
      
      private var _proxy:JavascriptProxy;
      
      private var _jsContainer:String = "_gaq";
      
      public function Bridge(param1:String, param2:DebugConfiguration, param3:JavascriptProxy)
      {
         super();
         this._account = param1;
         this._debug = param2;
         this._proxy = param3;
         this._checkAndLoadGAJS();
      }
      
      private function _call(param1:String, ... rest) : *
      {
         rest.unshift(param1);
         var _loc3_:Array = ["window." + this._jsContainer + ".push",rest];
         return this._proxy.call.apply(this._proxy,_loc3_);
      }
      
      private function _checkAndLoadGAJS() : Boolean
      {
         return this._proxy.call(_checkAndLoadGAJS_js);
      }
      
      public function getAccount() : String
      {
         this._debug.info("getAccount()");
         return this._call("_getAccount");
      }
      
      public function getVersion() : String
      {
         this._debug.info("getVersion()");
         return this._call("_getVersion");
      }
      
      public function resetSession() : void
      {
         this._debug.warning("resetSession() not implemented");
      }
      
      public function setAccount(param1:String) : void
      {
         this._debug.info("setAccount( " + param1 + " )");
         this._call("_setAccount",param1);
      }
      
      public function setSampleRate(param1:Number) : void
      {
         this._debug.info("setSampleRate( " + param1 + " )");
         this._call("_setSampleRate",param1);
      }
      
      public function setSessionTimeout(param1:int) : void
      {
         this._debug.info("setSessionTimeout( " + param1 + " )");
         this._call("_setSessionTimeout",param1);
      }
      
      public function setVar(param1:String) : void
      {
         this._debug.info("setVar( " + param1 + " )");
         this._call("_setVar",param1);
      }
      
      public function trackPageview(param1:String = "") : void
      {
         this._debug.info("trackPageview( " + param1 + " )");
         this._call("_trackPageview",param1);
      }
      
      public function setAllowAnchor(param1:Boolean) : void
      {
         this._debug.info("setAllowAnchor( " + param1 + " )");
         this._call("_setAllowAnchor",param1);
      }
      
      public function setCampContentKey(param1:String) : void
      {
         this._debug.info("setCampContentKey( " + param1 + " )");
         this._call("_setCampContentKey",param1);
      }
      
      public function setCampMediumKey(param1:String) : void
      {
         this._debug.info("setCampMediumKey( " + param1 + " )");
         this._call("_setCampMediumKey",param1);
      }
      
      public function setCampNameKey(param1:String) : void
      {
         this._debug.info("setCampNameKey( " + param1 + " )");
         this._call("_setCampNameKey",param1);
      }
      
      public function setCampNOKey(param1:String) : void
      {
         this._debug.info("setCampNOKey( " + param1 + " )");
         this._call("_setCampNOKey",param1);
      }
      
      public function setCampSourceKey(param1:String) : void
      {
         this._debug.info("setCampSourceKey( " + param1 + " )");
         this._call("_setCampSourceKey",param1);
      }
      
      public function setCampTermKey(param1:String) : void
      {
         this._debug.info("setCampTermKey( " + param1 + " )");
         this._call("_setCampTermKey",param1);
      }
      
      public function setCampaignTrack(param1:Boolean) : void
      {
         this._debug.info("setCampaignTrack( " + param1 + " )");
         this._call("_setCampaignTrack",param1);
      }
      
      public function setCookieTimeout(param1:int) : void
      {
         this._debug.info("setCookieTimeout( " + param1 + " )");
         this._call("_setCookieTimeout",param1);
      }
      
      public function cookiePathCopy(param1:String) : void
      {
         this._debug.info("cookiePathCopy( " + param1 + " )");
         this._call("_cookiePathCopy",param1);
      }
      
      public function getLinkerUrl(param1:String = "", param2:Boolean = false) : String
      {
         this._debug.info("getLinkerUrl(" + param1 + ", " + param2 + ")");
         return this._call("_getLinkerUrl",param1,param2);
      }
      
      public function link(param1:String, param2:Boolean = false) : void
      {
         this._debug.info("link( " + param1 + ", " + param2 + " )");
         this._call("_link",param1,param2);
      }
      
      public function linkByPost(param1:Object, param2:Boolean = false) : void
      {
         this._debug.warning("linkByPost( " + param1 + ", " + param2 + " ) not implemented");
      }
      
      public function setAllowHash(param1:Boolean) : void
      {
         this._debug.info("setAllowHash( " + param1 + " )");
         this._call("_setAllowHash",param1);
      }
      
      public function setAllowLinker(param1:Boolean) : void
      {
         this._debug.info("setAllowLinker( " + param1 + " )");
         this._call("_setAllowLinker",param1);
      }
      
      public function setCookiePath(param1:String) : void
      {
         this._debug.info("setCookiePath( " + param1 + " )");
         this._call("_setCookiePath",param1);
      }
      
      public function setDomainName(param1:String) : void
      {
         this._debug.info("setDomainName( " + param1 + " )");
         this._call("_setDomainName",param1);
      }
      
      public function addItem(param1:String, param2:String, param3:String, param4:String, param5:Number, param6:int) : void
      {
         this._debug.info("addItem( " + [param1,param2,param3,param4,param5,param6].join(", ") + " )");
         this._call("_addItem",param1,param2,param3,param4,param5,param6);
      }
      
      public function addTrans(param1:String, param2:String, param3:Number, param4:Number, param5:Number, param6:String, param7:String, param8:String) : void
      {
         this._debug.info("addTrans( " + [param1,param2,param3,param4,param5,param6,param7,param8].join(", ") + " )");
         this._call("_addTrans",param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function trackTrans() : void
      {
         this._debug.info("trackTrans()");
         this._call("_trackTrans");
      }
      
      public function createEventTracker(param1:String) : EventTracker
      {
         this._debug.info("createEventTracker( " + param1 + " )");
         return new EventTracker(param1,this);
      }
      
      public function trackEvent(param1:String, param2:String, param3:String = null, param4:Number = NaN) : Boolean
      {
         var _loc5_:int = 2;
         if(Boolean(param3) && param3 != "")
         {
            _loc5_ = 3;
         }
         if(_loc5_ == 3 && !isNaN(param4))
         {
            _loc5_ = 4;
         }
         switch(_loc5_)
         {
            case 4:
               this._debug.info("trackEvent( " + [param1,param2,param3,param4].join(", ") + " )");
               return this._call("_trackEvent",param1,param2,param3,param4);
            case 3:
               this._debug.info("trackEvent( " + [param1,param2,param3].join(", ") + " )");
               return this._call("_trackEvent",param1,param2,param3);
            case 2:
         }
         this._debug.info("trackEvent( " + [param1,param2].join(", ") + " )");
         return this._call("_trackEvent",param1,param2);
      }
      
      public function addIgnoredOrganic(param1:String) : void
      {
         this._debug.info("addIgnoredOrganic( " + param1 + " )");
         this._call("_addIgnoredOrganic",param1);
      }
      
      public function addIgnoredRef(param1:String) : void
      {
         this._debug.info("addIgnoredRef( " + param1 + " )");
         this._call("_addIgnoredRef",param1);
      }
      
      public function addOrganic(param1:String, param2:String) : void
      {
         this._debug.info("addOrganic( " + [param1,param2].join(", ") + " )");
         this._call("_addOrganic",param1);
      }
      
      public function clearIgnoredOrganic() : void
      {
         this._debug.info("clearIgnoredOrganic()");
         this._call("_clearIgnoreOrganic");
      }
      
      public function clearIgnoredRef() : void
      {
         this._debug.info("clearIgnoredRef()");
         this._call("_clearIgnoreRef");
      }
      
      public function clearOrganic() : void
      {
         this._debug.info("clearOrganic()");
         this._call("_clearOrganic");
      }
      
      public function getClientInfo() : Boolean
      {
         this._debug.info("getClientInfo()");
         return this._call("_getClientInfo");
      }
      
      public function getDetectFlash() : Boolean
      {
         this._debug.info("getDetectFlash()");
         return this._call("_getDetectFlash");
      }
      
      public function getDetectTitle() : Boolean
      {
         this._debug.info("getDetectTitle()");
         return this._call("_getDetectTitle");
      }
      
      public function setClientInfo(param1:Boolean) : void
      {
         this._debug.info("setClientInfo( " + param1 + " )");
         this._call("_setClientInfo",param1);
      }
      
      public function setDetectFlash(param1:Boolean) : void
      {
         this._debug.info("setDetectFlash( " + param1 + " )");
         this._call("_setDetectFlash",param1);
      }
      
      public function setDetectTitle(param1:Boolean) : void
      {
         this._debug.info("setDetectTitle( " + param1 + " )");
         this._call("_setDetectTitle",param1);
      }
      
      public function getLocalGifPath() : String
      {
         this._debug.info("getLocalGifPath()");
         return this._call("_getLocalGifPath");
      }
      
      public function getServiceMode() : ServerOperationMode
      {
         this._debug.info("getServiceMode()");
         return this._call("_getServiceMode");
      }
      
      public function setLocalGifPath(param1:String) : void
      {
         this._debug.info("setLocalGifPath( " + param1 + " )");
         this._call("_setLocalGifPath",param1);
      }
      
      public function setLocalRemoteServerMode() : void
      {
         this._debug.info("setLocalRemoteServerMode()");
         this._call("_setLocalRemoteServerMode");
      }
      
      public function setLocalServerMode() : void
      {
         this._debug.info("setLocalServerMode()");
         this._call("_setLocalServerMode");
      }
      
      public function setRemoteServerMode() : void
      {
         this._debug.info("setRemoteServerMode()");
         this._call("_setRemoteServerMode");
      }
   }
}
