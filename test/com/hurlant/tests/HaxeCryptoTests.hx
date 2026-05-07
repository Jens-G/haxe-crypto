/**
 * AS3CryptoTests
 *
 * @author	Tim Kurvers <tim@moonsphere.net>
 */
package com.hurlant.tests;


import com.hurlant.tests.crypto.extra.UUIDTest;
import com.hurlant.tests.crypto.extra.ROT13Test;
import com.hurlant.tests.crypto.rsa.RSAKeyTest;
import com.hurlant.tests.math.BigIntegerTest;
import com.hurlant.tests.crypto.CryptoTest;
import utest.Runner;
import utest.ui.Report;
import com.hurlant.tests.crypto.hash.*;
import com.hurlant.tests.crypto.prng.*;
import com.hurlant.tests.crypto.symmetric.*;
import com.hurlant.tests.util.*;

/**
 * haxe-crypto unit tests runner
 */
class HaxeCryptoTests {
    static function main() {
        //var a = new BigInteger("112374128763487126349871263984761238", 10);
        //trace(a.toString(10));
        //return;
        //assert(a.toString(10), "112374128763487126349871263984761238");

        var runner = new Runner();
        runner.addCase(new RandomTest());
        runner.addCase(new Std2Test());
        runner.addCase(new MD2Test());
        runner.addCase(new MD5Test());
        runner.addCase(new RMD160Test());
        runner.addCase(new ARC4Test());
        runner.addCase(new HexTest());
        runner.addCase(new Base64Test());
        runner.addCase(new ArrayUtilTest());
        runner.addCase(new XTeaKeyTest());
        runner.addCase(new SHA1Test());
        runner.addCase(new SHA256Test());
        runner.addCase(new SHA224Test());
        runner.addCase(new HMACTest());
        runner.addCase(new TLSPRFTest());
        runner.addCase(new BlowFishKeyTest());
        runner.addCase(new DESKeyTest());
        runner.addCase(new TripleDESKeyTest());
        runner.addCase(new AESKeyTest());
        runner.addCase(new CFB8ModeTest());
        runner.addCase(new CBCModeTest());
        runner.addCase(new CFBModeTest());
        runner.addCase(new CTRModeTest());
        runner.addCase(new OFBModeTest());
        runner.addCase(new ECBModeTest());
        runner.addCase(new CryptoTest());
        runner.addCase(new BigIntegerTest());
        runner.addCase(new RSAKeyTest());
        runner.addCase(new ROT13Test());
        runner.addCase(new UUIDTest());
        //runner.addCase(new TLSTest());

        Report.create(runner);
        runner.run();
    }
}
