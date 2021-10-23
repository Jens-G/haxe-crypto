package com.hurlant.crypto.prng;

import haxe.io.BytesData;
import haxe.io.Bytes;

class SecureRandom {
    // @TODO: IMPORTANT!!
    /**
     * Gather anything we have that isn't entirely predictable:
     *  - memory used
     *  - system capabilities
     *  - timing stuff
     *  - installed fonts
     */
    static public function getSecureRandomBytes(length:Int):Bytes {
        var reason = '';
        try {
            #if flash
                return Bytes.ofData(untyped __global__["flash.crypto.generateRandomBytes"](length));
            #elseif js
                js.Syntax.code('var Crypto = typeof crypto === "undefined" ? require("crypto") : crypto');
                var bytes:Dynamic = js.Syntax.code("(Crypto.randomBytes) ? Crypto.randomBytes({0}) : Crypto.getRandomValues(new Uint8Array({0}))", length);
                var out = Bytes.alloc(length);
                for (n in 0 ... length) out.set(n, bytes[n]);
                return out;
            #elseif python
                var out = Bytes.alloc(length);
                var bytes = RandomOs.urandom(length);
                for (n in 0 ... length) out.set(n, bytes[n]);
                return out;
            #elseif java
                return Bytes.ofData(java.security.SecureRandom.getSeed(length));
            #elseif cs
                var out = Bytes.alloc(length);
                var rng = new cs.system.security.cryptography.RNGCryptoServiceProvider();
                rng.GetBytes(out.getData());
                return out;
            #elseif sys
                // https://en.wikipedia.org/wiki//dev/random
                var out = Bytes.alloc(length);
                #if windows
                    var input = sys.io.File.read("\\Device\\KsecDD");
                #else
                    var input = sys.io.File.read("/dev/urandom");
                #end
                input.readBytes(out, 0, length);
                input.close();
                return out;
            #end
        } catch (e:Dynamic) {
            reason = '$e';
        }
        throw "Can't find a secure source of random bytes. Reason: " + reason;
    }

    //static private function getDefaultSeeds():Array<Int> {
    //}
}

#if python
@:pythonImport("os")
extern class RandomOs {
    static public function urandom(count:Int):Array<Int>;
}
#end
