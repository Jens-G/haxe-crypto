/**
 * PEM
 * 
 * A class to parse some PEM stuff.
 * Copyright (c) 2007 Henri Torgemane
 * 
 * See LICENSE.txt for full license information.
 */
package com.hurlant.util.der;


import haxe.Int32;
import com.hurlant.crypto.rsa.RSAKey;
import com.hurlant.util.Base64;
import com.hurlant.util.der.ByteString;

import com.hurlant.util.ByteArray;

class PEM {
    private static inline var RSA_PRIVATE_KEY_HEADER:String = "-----BEGIN RSA PRIVATE KEY-----";
    private static inline var RSA_PRIVATE_KEY_FOOTER:String = "-----END RSA PRIVATE KEY-----";
    private static inline var PRIVATE_KEY_HEADER:String = "-----BEGIN PRIVATE KEY-----";
    private static inline var PRIVATE_KEY_FOOTER:String = "-----END PRIVATE KEY-----";
    private static inline var RSA_PUBLIC_KEY_HEADER:String = "-----BEGIN RSA PUBLIC KEY-----";
    private static inline var RSA_PUBLIC_KEY_FOOTER:String = "-----END RSA PUBLIC KEY-----";
    private static inline var PUBLIC_KEY_HEADER:String = "-----BEGIN PUBLIC KEY-----";
    private static inline var PUBLIC_KEY_FOOTER:String = "-----END PUBLIC KEY-----";
    private static inline var CERTIFICATE_HEADER:String = "-----BEGIN CERTIFICATE-----";
    private static inline var CERTIFICATE_FOOTER:String = "-----END CERTIFICATE-----";

    /**
     * Read a structure encoded according to
     * ftp://ftp.rsasecurity.com/pub/pkcs/ascii/pkcs-1v2.asc
     * section 11.1.2
     *
     * @param str
     * @return
     */
    public static function readRSAPrivateKey(str:String):RSAKey {
        // Try PKCS#1 format: BEGIN RSA PRIVATE KEY
        var der:ByteArray = extractBinary(RSA_PRIVATE_KEY_HEADER, RSA_PRIVATE_KEY_FOOTER, str);
        if (der != null) {
            var obj = DER.parse(der);
            if (Std.isOfType(obj, Sequence)) {
                var arr = cast(obj, Sequence);
                // arr[0] is Version. should be 0.
                return new RSAKey(
                    arr.get(1), // N
                    arr.get(2).valueOf(), // E
                    arr.get(3), // D
                    arr.get(4), // P
                    arr.get(5), // Q
                    arr.get(6), // DMP1
                    arr.get(7), // DMQ1
                    arr.get(8)
                );
            }
            throw new Error('Don\'t know how to handle $obj');
        }

        // Try PKCS#8 unencrypted format: BEGIN PRIVATE KEY
        // Structure: SEQUENCE { INTEGER 0, SEQUENCE { OID, NULL }, OCTET STRING { RSAPrivateKey } }
        der = extractBinary(PRIVATE_KEY_HEADER, PRIVATE_KEY_FOOTER, str);
        if (der != null) {
            var obj = DER.parse(der);
            if (Std.isOfType(obj, Sequence)) {
                var outer = cast(obj, Sequence);
                var payload = cast(outer.get(2), ByteString);
                payload.data.position = 0;
                var inner = DER.parse(payload.data);
                if (Std.isOfType(inner, Sequence)) {
                    var arr = cast(inner, Sequence);
                    return new RSAKey(
                        arr.get(1), // N
                        arr.get(2).valueOf(), // E
                        arr.get(3), // D
                        arr.get(4), // P
                        arr.get(5), // Q
                        arr.get(6), // DMP1
                        arr.get(7), // DMQ1
                        arr.get(8)
                    );
                }
            }
            throw new Error('Don\'t know how to handle PKCS#8 key');
        }

        return null;
    }


    /**
     * Read a structure encoded according to some spec somewhere
     * Also, follows some chunk from
     * ftp://ftp.rsasecurity.com/pub/pkcs/ascii/pkcs-1v2.asc
     * section 11.1
     *
     * @param str
     * @return
     */
    public static function readRSAPublicKey(str:String):RSAKey {
        var obj = null;

        // PKCS#1 RSAPublicKey (header = BEGIN RSA PUBLIC KEY)
        var der = extractBinary(RSA_PUBLIC_KEY_HEADER, RSA_PUBLIC_KEY_FOOTER, str);
        if (der != null) {
            obj = DER.parse(der);
            if (Std.isOfType(obj, Sequence)) {
                var arr = cast(obj, Sequence);
                return new RSAKey(
                    arr.get(0), // N
                    arr.get(1).valueOf() // E
                );
            }
        }

        // X.509 SubjectPublicKeyInfo (header = BEGIN PUBLIC KEY)
        der = extractBinary(PUBLIC_KEY_HEADER, PUBLIC_KEY_FOOTER, str);
        if (der != null) {
            obj = DER.parse(der);
            if (Std.isOfType(obj, Sequence)) {
                var seq = cast(obj, Sequence);
                // arr[0] = [ <some crap that means "rsaEncryption">, null ]; ( apparently, that's an X-509 Algorithm Identifier.
                if (Std.string(seq.get(0).get(0)) == OID.RSA_ENCRYPTION) {
                    //trace(seq.get(1));
                    //trace(HaxeType.getClass(seq.get(1)));
					seq.get(1).data._position = 0; // FIX: read from beginning, not from end
                    obj = DER.parse(seq.get(1).data);
                    if (Std.isOfType(obj, Sequence)) {
                        seq = cast(obj, Sequence);
                        // arr[0] = modulus
                        // arr[1] = public expt.
                        return new RSAKey(
                            seq.get(0),
                            seq.get(1).valueOf()
                        );
                    }
                }
            }
        }

        throw new Error('Unhandled PEM.readRSAPublicKey $obj');
    }

    public static function readCertIntoArray(str:String):ByteArray {
        var tmp:ByteArray = extractBinary(CERTIFICATE_HEADER, CERTIFICATE_FOOTER, str);
        return tmp;
    }

    private static function extractBinary(header:String, footer:String, str:String):ByteArray {
        var i:Int32 = str.indexOf(header);
        if (i == -1) return null;
        i += header.length;
        var j:Int32 = str.indexOf(footer);
        if (j == -1) return null;
        var b64:String = str.substring(i, j);
        // remove whitesapces.
        b64 = new EReg('\\s', "mg").replace(b64, "");
        // decode
        return Base64.decodeToByteArray(b64);
    }
}
