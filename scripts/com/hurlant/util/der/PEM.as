package com.hurlant.util.der
{
   import com.hurlant.crypto.rsa.RSAKey;
   import com.hurlant.util.Base64;
   import flash.utils.ByteArray;
   
   public class PEM
   {
      
      private static const RSA_PRIVATE_KEY_HEADER:String = "-----BEGIN RSA PRIVATE KEY-----";
      
      private static const RSA_PRIVATE_KEY_FOOTER:String = "-----END RSA PRIVATE KEY-----";
      
      private static const RSA_PUBLIC_KEY_HEADER:String = "-----BEGIN PUBLIC KEY-----";
      
      private static const RSA_PUBLIC_KEY_FOOTER:String = "-----END PUBLIC KEY-----";
      
      private static const CERTIFICATE_HEADER:String = "-----BEGIN CERTIFICATE-----";
      
      private static const CERTIFICATE_FOOTER:String = "-----END CERTIFICATE-----";
       
      
      public function PEM()
      {
         super();
      }
      
      public static function readRSAPrivateKey(param1:String) : RSAKey
      {
         var _loc3_:Array = null;
         var _loc2_:ByteArray = extractBinary("-----BEGIN RSA PRIVATE KEY-----","-----END RSA PRIVATE KEY-----",param1);
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc4_:*;
         if((_loc4_ = DER.parse(_loc2_)) is Array)
         {
            _loc3_ = _loc4_ as Array;
            return new RSAKey(_loc3_[1],_loc3_[2].valueOf(),_loc3_[3],_loc3_[4],_loc3_[5],_loc3_[6],_loc3_[7],_loc3_[8]);
         }
         return null;
      }
      
      public static function readRSAPublicKey(param1:String) : RSAKey
      {
         var _loc3_:Array = null;
         var _loc2_:ByteArray = extractBinary("-----BEGIN PUBLIC KEY-----","-----END PUBLIC KEY-----",param1);
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc4_:*;
         if((_loc4_ = DER.parse(_loc2_)) is Array)
         {
            _loc3_ = _loc4_ as Array;
            if(_loc3_[0][0].toString() != "1.2.840.113549.1.1.1")
            {
               return null;
            }
            if((_loc4_ = DER.parse(_loc3_[1])) is Array)
            {
               _loc3_ = _loc4_ as Array;
               return new RSAKey(_loc3_[0],_loc3_[1]);
            }
            return null;
         }
         return null;
      }
      
      public static function readCertIntoArray(param1:String) : ByteArray
      {
         return extractBinary("-----BEGIN CERTIFICATE-----","-----END CERTIFICATE-----",param1);
      }
      
      private static function extractBinary(param1:String, param2:String, param3:String) : ByteArray
      {
         var _loc6_:int;
         if((_loc6_ = param3.indexOf(param1)) == -1)
         {
            return null;
         }
         _loc6_ += param1.length;
         var _loc5_:int;
         if((_loc5_ = param3.indexOf(param2)) == -1)
         {
            return null;
         }
         var _loc4_:String = (_loc4_ = param3.substring(_loc6_,_loc5_)).replace(/\s/gm,"");
         return Base64.decodeToByteArray(_loc4_);
      }
   }
}
