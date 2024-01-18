package starling.utils
{
   import flash.display.Stage3D;
   import flash.display3D.Context3D;
   import flash.events.Event;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.errors.AbstractClassError;
   import starling.textures.Texture;
   
   public class RenderUtil
   {
       
      
      public function RenderUtil()
      {
         super();
         throw new AbstractClassError();
      }
      
      public static function clear(param1:uint = 0, param2:Number = 0) : void
      {
         Starling.context.clear(Color.getRed(param1) / 255,Color.getGreen(param1) / 255,Color.getBlue(param1) / 255,param2);
      }
      
      public static function getTextureLookupFlags(param1:String, param2:Boolean, param3:Boolean = false, param4:String = "bilinear") : String
      {
         var _loc5_:Array = ["2d",param3 ? "repeat" : "clamp"];
         if(param1 == "compressed")
         {
            _loc5_.push("dxt1");
         }
         else if(param1 == "compressedAlpha")
         {
            _loc5_.push("dxt5");
         }
         if(param4 == "none")
         {
            _loc5_.push("nearest",param2 ? "mipnearest" : "mipnone");
         }
         else if(param4 == "bilinear")
         {
            _loc5_.push("linear",param2 ? "mipnearest" : "mipnone");
         }
         else
         {
            _loc5_.push("linear",param2 ? "miplinear" : "mipnone");
         }
         return "<" + _loc5_.join() + ">";
      }
      
      public static function getTextureVariantBits(param1:Texture) : uint
      {
         if(param1 == null)
         {
            return 0;
         }
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         switch(param1.format)
         {
            case "compressedAlpha":
               _loc3_ = 3;
               break;
            case "compressed":
               _loc3_ = 2;
               break;
            default:
               _loc3_ = 1;
         }
         _loc2_ |= _loc3_;
         if(!param1.premultipliedAlpha)
         {
            _loc2_ |= 4;
         }
         return _loc2_;
      }
      
      public static function setSamplerStateAt(param1:int, param2:Boolean, param3:String = "bilinear", param4:Boolean = false) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = param4 ? "repeat" : "clamp";
         if(param3 == "none")
         {
            _loc5_ = "nearest";
            _loc6_ = param2 ? "mipnearest" : "mipnone";
         }
         else if(param3 == "bilinear")
         {
            _loc5_ = "linear";
            _loc6_ = param2 ? "mipnearest" : "mipnone";
         }
         else
         {
            _loc5_ = "linear";
            _loc6_ = param2 ? "miplinear" : "mipnone";
         }
         Starling.context.setSamplerStateAt(param1,_loc7_,_loc5_,_loc6_);
      }
      
      public static function createAGALTexOperation(param1:String, param2:String, param3:int, param4:Texture, param5:Boolean = true, param6:String = "ft0") : String
      {
         var _loc8_:String = null;
         var _loc10_:String;
         switch(_loc10_ = param4.format)
         {
            case "compressed":
               _loc8_ = "dxt1";
               break;
            case "compressedAlpha":
               _loc8_ = "dxt5";
               break;
            default:
               _loc8_ = "rgba";
         }
         var _loc9_:Boolean;
         var _loc7_:String = (_loc9_ = param5 && !param4.premultipliedAlpha) && param1 == "oc" ? param6 : param1;
         var _loc11_:String = "tex " + _loc7_ + ", " + param2 + ", fs" + param3 + " <2d, " + _loc8_ + ">\n";
         if(_loc9_)
         {
            if(param1 == "oc")
            {
               _loc11_ = (_loc11_ += "mul " + _loc7_ + ".xyz, " + _loc7_ + ".xyz, " + _loc7_ + ".www\n") + ("mov " + param1 + ", " + _loc7_);
            }
            else
            {
               _loc11_ += "mul " + param1 + ".xyz, " + _loc7_ + ".xyz, " + _loc7_ + ".www\n";
            }
         }
         return _loc11_;
      }
      
      public static function requestContext3D(param1:Stage3D, param2:String, param3:*) : void
      {
         var profiles:Array;
         var currentProfile:String;
         var stage3D:Stage3D = param1;
         var renderMode:String = param2;
         var profile:* = param3;
         var requestNextProfile:* = function():void
         {
            currentProfile = profiles.shift();
            try
            {
               execute(stage3D.requestContext3D,renderMode,currentProfile);
            }
            catch(error:Error)
            {
               if(profiles.length == 0)
               {
                  throw error;
               }
               setTimeout(requestNextProfile,1);
            }
         };
         var onCreated:* = function(param1:Event):void
         {
            var _loc2_:Context3D = stage3D.context3D;
            if(renderMode == "auto" && profiles.length != 0 && _loc2_.driverInfo.indexOf("Software") != -1)
            {
               onError(param1);
            }
            else
            {
               onFinished();
            }
         };
         var onError:* = function(param1:Event):void
         {
            if(profiles.length != 0)
            {
               param1.stopImmediatePropagation();
               setTimeout(requestNextProfile,1);
            }
            else
            {
               onFinished();
            }
         };
         var onFinished:* = function():void
         {
            stage3D.removeEventListener("context3DCreate",onCreated);
            stage3D.removeEventListener("error",onError);
         };
         if(profile == "auto")
         {
            profiles = ["standardExtended","standard","standardConstrained","baselineExtended","baseline","baselineConstrained"];
         }
         else if(profile is String)
         {
            profiles = [profile as String];
         }
         else
         {
            if(!(profile is Array))
            {
               throw new ArgumentError("Profile must be of type \'String\' or \'Array\'");
            }
            profiles = profile as Array;
         }
         stage3D.addEventListener("context3DCreate",onCreated,false,100);
         stage3D.addEventListener("error",onError,false,100);
         requestNextProfile();
      }
   }
}
