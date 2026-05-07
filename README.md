# Haxe Cryptography Library

[![Build Status](https://github.com/Jens-G/haxe-crypto/actions/workflows/ci.yml/badge.svg)](https://github.com/Jens-G/haxe-crypto/actions/workflows/ci.yml)

Forked from:
* [https://github.com/timkurvers/as3-crypto](https://github.com/timkurvers/as3-crypto)

That was forked from:

* [https://code.google.com/archive/p/as3crypto/](https://code.google.com/archive/p/as3crypto/)
* [http://crypto.hurlant.com/](http://crypto.hurlant.com/)

The original project can be found at [http://code.google.com/p/as3crypto/](http://code.google.com/p/as3crypto/)

Although unofficial, this GitHub-fork includes community fixes and patches.

Consult the CHANGELOG for implemented fixes and contributors.


-----

Copyright (c) 2007 Henri Torgemane  
Modifications (c) 2011-2013 Tim Kurvers and various other contributors
Ported to Haxe (c) 2016 Carlos Ballesteros and various other contributors

A cryptography library written in Haxe that provides several common algorithms. This version also introduces a TLS engine, more commonly known as SSL.

Licensed under the **BSD** license. Includes several derivative works from Java, C and JavaScript sources. See LICENSE for more information and a list of contributors.

## Usage

`haxelib install haxe-crypto`


## Features

* Protocols: TLS 1.0 support (partial)
* Certificates: X.509 Certificate parsing and validation, built-in Root CAs.
* Public Key Encryption: RSA (encrypt/decrypt, sign/verify)
* Secret Key Encryption: AES, DES, 3DES, BlowFish, XTEA, RC4
* Confidentiality Modes: ECB, CBC, CFB, CFB8, OFB, CTR
* Hashing Algorithms: MD2, MD5, SHA-1, SHA-224, SHA-256, RMD-160
* Paddings available: PKCS#5, PKCS#1 type 1 and 2
* Other Useful Stuff: HMAC, Random, TLS-PRF, some ASN-1/DER parsing, ROT13, UUID, UTF-8, UTF-16
