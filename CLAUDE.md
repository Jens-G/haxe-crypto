# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Run tests (JavaScript via Node.js)
```bash
haxe tests.hxml
```

### Run tests on all targets
```bash
haxe tests_all.hxml
```

### Run tests on native targets only (Neko, C++)
```bash
haxe tests_native.hxml
```

### Publish to haxelib
```bash
./deploy.sh
```

## Architecture

This is a Haxe cryptography library (haxelib: `haxe-crypto`, version 0.0.8) ported from the ActionScript 3 `as3-crypto` library. The class path root is `src/`; tests live in `test/`.

All package names are under `com.hurlant.*`.

### Key abstraction: `ByteArray`

`src/com/hurlant/util/ByteArray.hx` defines a custom `ByteArray` abstract wrapping `ByteArrayData`. This is the universal byte buffer used throughout the entire library — it mimics the ActionScript 3 `ByteArray` API (positional read/write, endian control, `length`, `position`, `bytesAvailable`). The default endian is `BIG_ENDIAN`. Almost every algorithm takes and returns `ByteArray`.

### Entry point: `Crypto`

`src/com/hurlant/crypto/Crypto.hx` is the high-level factory. Use `Crypto.getCipher(name, key)`, `Crypto.getHash(name)`, `Crypto.getHMAC(name)`, and `Crypto.getPad(name)` to instantiate algorithms by string name (e.g. `"aes-128-cbc"`, `"sha256"`, `"hmac-sha1-128"`). Using `Crypto` links the entire library; instantiate algorithm classes directly to avoid that.

### Source layout

| Package | Contents |
|---|---|
| `com.hurlant.crypto` | `Crypto` factory |
| `com.hurlant.crypto.symmetric` | Block ciphers: AES, DES, 3DES, BlowFish, XTEA |
| `com.hurlant.crypto.symmetric.mode` | Cipher modes: ECB, CBC, CFB, CFB8, OFB, CTR |
| `com.hurlant.crypto.hash` | Hash algorithms: MD2, MD5, SHA1, SHA224, SHA256, RMD160 |
| `com.hurlant.crypto.pad` | Padding: PKCS5, NullPad, SSLPad, TLSPad |
| `com.hurlant.crypto.prng` | PRNG: ARC4 (RC4), Random, SecureRandom, TLSPRF |
| `com.hurlant.crypto.rsa` | RSA key operations |
| `com.hurlant.crypto.cert` | X.509 certificate parsing, Mozilla root CAs |
| `com.hurlant.crypto.tls` | TLS 1.0 engine (partial implementation) |
| `com.hurlant.math` | BigInteger with Barrett, Montgomery, Classic reductions |
| `com.hurlant.util` | ByteArray, Hex, Base64, ASN.1/DER parser, utility types |
| `com.hurlant.util.der` | DER encoding/decoding (used for certificate and RSA parsing) |
| `com.hurlant.util.asn1` | Newer ASN.1 type system and parser |

### Tests

`test/com/hurlant/tests/HaxeCryptoTests.hx` is the test runner main class. Each test class extends `BaseTestCase` (which extends `haxe.unit.TestCase`) and uses `assert(actual, expected)` or `assertEquals`. The TLS test is currently commented out.

### Interface conventions

- Symmetric ciphers implement `ISymmetricKey` (block ciphers) or `IStreamCipher`
- Cipher modes implement `IMode` (or `IVMode` for IV-based modes)
- All modes wrap an `ISymmetricKey`; padding is optional (defaults to CBC)
- Hash algorithms implement `IHash`
- `SimpleIVMode` prepends the IV to the ciphertext (useful for self-contained encrypted payloads)

### Multi-target support

The library targets JS, PHP, Java, C++, and Neko. The `.hxml` files configure each compilation target. CI (Travis) runs only the JS target. `Std2.hx` and `HaxeType.hx` provide cross-target compatibility shims.
