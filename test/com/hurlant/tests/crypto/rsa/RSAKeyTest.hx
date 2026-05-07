/**
 * RSAKeyTest
 *
 * A test class for RSAKey
 * Copyright (c) 2007 Henri Torgemane
 *
 * See LICENSE.txt for full license information.
 */
package com.hurlant.tests.crypto.rsa;


import com.hurlant.tests.*;

import com.hurlant.crypto.rsa.RSAKey;
import com.hurlant.util.Hex;
import com.hurlant.util.der.PEM;

import com.hurlant.util.ByteArray;

class RSAKeyTest extends BaseTestCase {
    public function test_smoke() {
        var N = (
            "C4E3F7212602E1E396C0B6623CF11D26204ACE3E7D26685E037AD2507DCE82FC" +
            "28F2D5F8A67FC3AFAB89A6D818D1F4C28CFA548418BD9F8E7426789A67E73E41"
        );
        var E = "10001";
        var D = (
            "7cd1745aec69096129b1f42da52ac9eae0afebbe0bc2ec89253598dcf454960e" +
            "3e5e4ec9f8c87202b986601dd167253ee3fb3fa047e14f1dfd5ccd37e931b29d"
        );
        var P = "f0e4dd1eac5622bd3932860fc749bbc48662edabdf3d2826059acc0251ac0d3b";
        var Q = "d13cb38fbcd06ee9bca330b4000b3dae5dae12b27e5173e4d888c325cda61ab3";
        var DMP1 = "b3d5571197fc31b0eb6b4153b425e24c033b054d22b9c8282254fe69d8c8c593";
        var DMQ1 = "968ffe89e50d7b72585a79b65cfdb9c1da0963cceb56c3759e57334de5a0ac3f";
        var IQMP = "d9bc4f420e93adad9f007d0e5744c2fe051c9ed9d3c9b65f439a18e13d6e3908";
        // create a key.
        var rsa = RSAKey.parsePrivateKey(N, E, D, P, Q, DMP1, DMQ1, IQMP);
        var txt = "hello";
        var src = Hex.toArray(Hex.fromString(txt));
        var dst = new ByteArray();
        var dst2 = new ByteArray();
        rsa.encrypt(src, dst, src.length);
        rsa.decrypt(dst, dst2, dst.length);
        var txt2 = Hex.toString(Hex.fromArray(dst2));
        assert(txt, txt2);
    }

    public function test_generate() {
        var rsa = RSAKey.generate(256, "10001");
        // same lame smoke test here.
        var txt = "hello";
        var src = Hex.toArray(Hex.fromString(txt));
        var dst = new ByteArray();
        var dst2 = new ByteArray();
        rsa.encrypt(src, dst, src.length);
        rsa.decrypt(dst, dst2, dst.length);
        var txt2 = Hex.toString(Hex.fromArray(dst2));
        assert(txt, txt2);
    }

    public function test_pem() {
        var pem = (
            "-----BEGIN RSA PRIVATE KEY-----\n" +
            "MGQCAQACEQDJG3bkuB9Ie7jOldQTVdzPAgMBAAECEQCOGqcPhP8t8mX8cb4cQEaR\n" +
            "AgkA5WTYuAGmH0cCCQDgbrto0i7qOQIINYr5btGrtccCCQCYy4qX4JDEMQIJAJll\n" +
            "OnLVtCWk\n" +
            "-----END RSA PRIVATE KEY-----"
        );
        var rsa = PEM.readRSAPrivateKey(pem);
        //trace(rsa.dump());

        // obligatory use
        var txt = "hello";
        var src = Hex.toArray(Hex.fromString(txt));
        var dst = new ByteArray();
        var dst2 = new ByteArray();
        rsa.encrypt(src, dst, src.length);
        rsa.decrypt(dst, dst2, dst.length);
        var txt2 = Hex.toString(Hex.fromArray(dst2));
        assert(txt, txt2);
    }

    public function test_pem2() {
        var pem = (
            "-----BEGIN PUBLIC KEY-----\n" +
            "MCwwDQYJKoZIhvcNAQEBBQADGwAwGAIRAMkbduS4H0h7uM6V1BNV3M8CAwEAAQ==\n" +
            "-----END PUBLIC KEY-----"
        );
        var rsa = PEM.readRSAPublicKey(pem);
        assert(rsa != null);
    }

    public function test_longText() {
        var pem = (
            "-----BEGIN RSA PRIVATE KEY-----\n" +
            "MGQCAQACEQDJG3bkuB9Ie7jOldQTVdzPAgMBAAECEQCOGqcPhP8t8mX8cb4cQEaR\n" +
            "AgkA5WTYuAGmH0cCCQDgbrto0i7qOQIINYr5btGrtccCCQCYy4qX4JDEMQIJAJll\n" +
            "OnLVtCWk\n" +
            "-----END RSA PRIVATE KEY-----"
        );
        var rsa = PEM.readRSAPrivateKey(pem);

        var txt = (
            "With each new release" +
            "of Flash Player, Adobe strives to introduce a stronger platform with" +
            "more robust security controls and tools for creating secure" +
            "applications. By leveraging those tools, compiling for recent" +
            "versions, performing data validation, and leveraging available SDKs," +
            "developers can produce more secure applications that run in Flash" +
            "Player."
        );
        var src = Hex.toArray(Hex.fromString(txt));
        var dst = new ByteArray();
        var dst2 = new ByteArray();
        rsa.encrypt(src, dst, src.length);
        rsa.decrypt(dst, dst2, dst.length);
        var txt2 = Hex.toString(Hex.fromArray(dst2));
        assert(txt, txt2);
    }

    /**
     * Issue #22: PEM.readRSAPrivateKey must also accept PKCS#8 unencrypted keys
     * (BEGIN PRIVATE KEY), which is the default output of OpenSSL 3.x.
     * Key generated with: openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:512
     */
    public function test_pem_pkcs8():Void {
        var pem = (
            "-----BEGIN PRIVATE KEY-----\n" +
            "MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEA2FFySdkG8j+UBpoP\n" +
            "ud6Sq3oh0cfYh9Hmrb6jNGDpdSnGYOCML01856z3U1C63aDSYUe7OVey64VejhTc\n" +
            "5LqTjQIDAQABAkBjetk/YuJR57EwdAtFZDk5SNpiujA3De2y+1fcz7CtYyciVhWP\n" +
            "Puf4Gg5qfkO+IaSfVpqnsbyeM5agZ01YkpgVAiEA9g0HaDVVy6e9hku3STo8m6Ws\n" +
            "XfeZYgtJ87ypGjJ5eNsCIQDhEKRZ8cInK+xcv/juYszLMwE7jNgGSEXopd1LDRs9\n" +
            "twIhAJO8IvRpAci0QNG/6J8pPnbeNO5+2jPKP27/mjFGmTT9AiB9z4rACMfqk8AV\n" +
            "/O5PfAVVFZb7zfi4UlBaA9YXbSUsMwIhAKythjFDLOJDqoYKdD0YoTMn9u3sJkrV\n" +
            "2TTjEm6/7hJr\n" +
            "-----END PRIVATE KEY-----"
        );
        var rsa = PEM.readRSAPrivateKey(pem);
        assert(rsa != null);

        var txt = "hello";
        var src = Hex.toArray(Hex.fromString(txt));
        var dst = new ByteArray();
        var dst2 = new ByteArray();
        rsa.encrypt(src, dst, src.length);
        rsa.decrypt(dst, dst2, dst.length);
        var txt2 = Hex.toString(Hex.fromArray(dst2));
        assert(txt, txt2);
    }

    /*
    public function test_adobeSample() {
        var myPEMPublicKeyString = (
            "-----BEGIN PUBLIC KEY-----" +
            "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALHpyYTN96rMbkQB" +
            "gIoB9vH2AN47NN1YXoKxAaqpEkafQdPUw41p4gTrA0r04acE" +
            "m3GaWUA4YROCSKgJnvii0UsCAwEAAQ==" +
            "-----END PUBLIC KEY-----"
        );

        // Put data to be encrypted into a byte array
        var data = Hex.toArray(Hex.fromString("MyInputString"));

        // Destination ByteArray that will contain the encrypted data
        var encryptedResult = new ByteArray();

        // Set up the RSAKey and encrypt the data
        var rsa = PEM.readRSAPublicKey(myPEMPublicKeyString);
        rsa.encrypt(data, encryptedResult, data.length);

        // Convert the encrypted data into a hex encoded string for transport
        // The other side of the connection can convert the hex back into
        // binary before decrypting
        var hexEncryptedResult = Hex.fromArray(encryptedResult);
        assertTrue(hexEncryptedResult.length > 5);
    }
    */
}
