/**
 * NullPad
 * 
 * A padding class that doesn't pad.
 * Copyright (c) 2007 Henri Torgemane
 * 
 * See LICENSE.txt for full license information.
 */
package com.hurlant.crypto.symmetric;


import com.hurlant.util.ByteArray;

/**
	 * A pad that does nothing.
	 * Useful when you don't want padding in your Mode.
	 */
class NullPad implements IPad
{
    public function unpad(a : ByteArray) : Void
    {
        return;
    }
    
    public function pad(a : ByteArray) : Void
    {
        return;
    }
    
    public function setBlockSize(bs : Int) : Void{
        return;
    }

    public function new()
    {
    }
}