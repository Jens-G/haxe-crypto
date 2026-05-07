package com.hurlant.tests;

import haxe.PosInfos;

class BaseTestCase extends utest.Test {
    public function new() {
        super();
    }

    public function assertEquals<T>(expected:T, actual:T, ?pos:PosInfos) {
        utest.Assert.equals(expected, actual, null, pos);
    }

    public inline function assert(a:Dynamic, ?b:Dynamic, ?pos:PosInfos) {
        if (b == null) {
            utest.Assert.isTrue(a, null, pos);
        } else {
            assertEquals(b, a, pos);
        }
    }

    public function fail(msg:String):Void {
        utest.Assert.fail(msg);
    }
}