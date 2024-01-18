package facebook
{
   internal class JSON2
   {
       
      
      public function JSON2()
      {
         super();
      }
      
      public static function deserialize(param1:String) : *
      {
         var source:String = param1;
         source = new String(source);
         var at:Number = 0;
         var ch:String = " ";
         var _isDigit:Function = function(param1:String):*
         {
            return "0" <= param1 && param1 <= "9";
         };
         var _isHexDigit:Function = function(param1:String):*
         {
            return _isDigit(param1) || "A" <= param1 && param1 <= "F" || "a" <= param1 && param1 <= "f";
         };
         var _error:Function = function(param1:String):void
         {
            throw new Error(param1,at - 1);
         };
         var _next:Function = function():*
         {
            ch = source.charAt(at);
            at += 1;
            return ch;
         };
         var _white:Function = function():void
         {
            while(ch)
            {
               if(ch <= " ")
               {
                  _next();
               }
               else
               {
                  if(ch != "/")
                  {
                     break;
                  }
                  switch(_next())
                  {
                     case "/":
                        while(_next() && ch != "\n" && ch != "\r")
                        {
                        }
                        break;
                     case "*":
                        _next();
                        while(true)
                        {
                           if(ch)
                           {
                              if(ch == "*")
                              {
                                 if(_next() == "/")
                                 {
                                    break;
                                 }
                              }
                              else
                              {
                                 _next();
                              }
                           }
                           else
                           {
                              _error("Unterminated Comment");
                           }
                        }
                        _next();
                        break;
                     default:
                        _error("Syntax Error");
                  }
               }
            }
         };
         var _string:Function = function():*
         {
            var _loc2_:* = undefined;
            var _loc1_:* = undefined;
            var _loc5_:* = "";
            var _loc4_:* = "";
            var _loc3_:Boolean = false;
            if(ch == "\"")
            {
               while(Boolean(_next()))
               {
                  if(ch == "\"")
                  {
                     _next();
                     return _loc4_;
                  }
                  if(ch == "\\")
                  {
                     switch(_next())
                     {
                        case "b":
                           _loc4_ += "\b";
                           break;
                        case "f":
                           _loc4_ += "\f";
                           break;
                        case "n":
                           _loc4_ += "\n";
                           break;
                        case "r":
                           _loc4_ += "\r";
                           break;
                        case "t":
                           _loc4_ += "\t";
                           break;
                        case "u":
                           _loc1_ = 0;
                           _loc5_ = 0;
                           while(_loc5_ < 4)
                           {
                              _loc2_ = parseInt(_next(),16);
                              if(!isFinite(_loc2_))
                              {
                                 _loc3_ = true;
                                 break;
                              }
                              _loc1_ = _loc1_ * 16 + _loc2_;
                              _loc5_ += 1;
                           }
                           if(_loc3_)
                           {
                              _loc3_ = false;
                              break;
                           }
                           _loc4_ += String.fromCharCode(_loc1_);
                           break;
                        default:
                           _loc4_ += ch;
                     }
                  }
                  else
                  {
                     _loc4_ += ch;
                  }
               }
            }
            _error("Bad String");
            return null;
         };
         var _array:Function = function():*
         {
            var _loc1_:Array = [];
            if(ch == "[")
            {
               _next();
               _white();
               if(ch == "]")
               {
                  _next();
                  return _loc1_;
               }
               while(ch)
               {
                  _loc1_.push(_value());
                  _white();
                  if(ch == "]")
                  {
                     _next();
                     return _loc1_;
                  }
                  if(ch != ",")
                  {
                     break;
                  }
                  _next();
                  _white();
               }
            }
            _error("Bad Array");
            return null;
         };
         var _object:Function = function():*
         {
            var _loc2_:* = {};
            var _loc1_:* = {};
            if(ch == "{")
            {
               _next();
               _white();
               if(ch == "}")
               {
                  _next();
                  return _loc1_;
               }
               while(ch)
               {
                  _loc2_ = _string();
                  _white();
                  if(ch != ":")
                  {
                     break;
                  }
                  _next();
                  _loc1_[_loc2_] = _value();
                  _white();
                  if(ch == "}")
                  {
                     _next();
                     return _loc1_;
                  }
                  if(ch != ",")
                  {
                     break;
                  }
                  _next();
                  _white();
               }
            }
            _error("Bad Object");
         };
         var _number:Function = function():*
         {
            var _loc2_:* = undefined;
            var _loc4_:* = "";
            var _loc3_:String = "";
            var _loc1_:String = "";
            if(ch == "-")
            {
               _loc1_ = _loc4_ = "-";
               _next();
            }
            if(ch == "0")
            {
               _next();
               if(ch == "x" || ch == "X")
               {
                  _next();
                  while(Boolean(_isHexDigit(ch)))
                  {
                     _loc3_ += ch;
                     _next();
                  }
                  if(_loc3_ != "")
                  {
                     return Number(_loc1_ + "0x" + _loc3_);
                  }
                  _error("mal formed Hexadecimal");
               }
               else
               {
                  _loc4_ += "0";
               }
            }
            while(Boolean(_isDigit(ch)))
            {
               _loc4_ += ch;
               _next();
            }
            if(ch == ".")
            {
               _loc4_ += ".";
               while(_next() && ch >= "0" && ch <= "9")
               {
                  _loc4_ += ch;
               }
            }
            _loc2_ = 1 * _loc4_;
            if(!isFinite(_loc2_))
            {
               _error("Bad Number");
               return NaN;
            }
            return _loc2_;
         };
         var _word:Function = function():*
         {
            switch(ch)
            {
               case "t":
                  if(_next() == "r" && _next() == "u" && _next() == "e")
                  {
                     _next();
                     return true;
                  }
                  break;
               case "f":
                  if(_next() == "a" && _next() == "l" && _next() == "s" && _next() == "e")
                  {
                     _next();
                     return false;
                  }
                  break;
               case "n":
                  if(_next() == "u" && _next() == "l" && _next() == "l")
                  {
                     _next();
                     return null;
                  }
                  break;
            }
            _error("Syntax Error");
            return null;
         };
         var _value:Function = function():*
         {
            _white();
            switch(ch)
            {
               case "{":
                  return _object();
               case "[":
                  return _array();
               case "\"":
                  return _string();
               case "-":
                  return _number();
               default:
                  return ch >= "0" && ch <= "9" ? _number() : _word();
            }
         };
         return _value();
      }
      
      public static function serialize(param1:*) : String
      {
         var _loc4_:String = null;
         var _loc8_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:* = undefined;
         var _loc7_:Number = NaN;
         var _loc3_:String = "";
         switch(typeof param1)
         {
            case "object":
               if(param1)
               {
                  if(param1 is Array)
                  {
                     _loc6_ = Number(param1.length);
                     _loc8_ = 0;
                     while(_loc8_ < _loc6_)
                     {
                        _loc2_ = serialize(param1[_loc8_]);
                        if(_loc3_)
                        {
                           _loc3_ += ",";
                        }
                        _loc3_ += _loc2_;
                        _loc8_++;
                     }
                     return "[" + _loc3_ + "]";
                  }
                  if(typeof param1.toString != "undefined")
                  {
                     for(var _loc5_ in param1)
                     {
                        _loc2_ = param1[_loc5_];
                        if(typeof _loc2_ != "undefined" && typeof _loc2_ != "function")
                        {
                           _loc2_ = serialize(_loc2_);
                           if(_loc3_)
                           {
                              _loc3_ += ",";
                           }
                           _loc3_ += serialize(_loc5_) + ":" + _loc2_;
                        }
                     }
                     return "{" + _loc3_ + "}";
                  }
               }
               return "null";
            case "number":
               return isFinite(param1) ? param1 : "null";
            case "string":
               _loc6_ = Number(param1.length);
               _loc3_ = "\"";
               _loc8_ = 0;
               while(_loc8_ < _loc6_)
               {
                  if((_loc4_ = String(param1.charAt(_loc8_))) >= " ")
                  {
                     if(_loc4_ == "\\" || _loc4_ == "\"")
                     {
                        _loc3_ += "\\";
                     }
                     _loc3_ += _loc4_;
                  }
                  else
                  {
                     switch(_loc4_)
                     {
                        case "\b":
                           _loc3_ += "\\b";
                           break;
                        case "\f":
                           _loc3_ += "\\f";
                           break;
                        case "\n":
                           _loc3_ += "\\n";
                           break;
                        case "\r":
                           _loc3_ += "\\r";
                           break;
                        case "\t":
                           _loc3_ += "\\t";
                           break;
                        default:
                           _loc7_ = _loc4_.charCodeAt();
                           _loc3_ += "\\u00" + Math.floor(_loc7_ / 16).toString(16) + (_loc7_ % 16).toString(16);
                     }
                  }
                  _loc8_ += 1;
               }
               return _loc3_ + "\"";
            case "boolean":
               return param1;
            default:
               return "null";
         }
      }
   }
}
