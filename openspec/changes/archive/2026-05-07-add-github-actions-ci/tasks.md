## 1. Per-target hxml files

- [x] 1.1 Create `tests-neko.hxml` with common flags and `-neko tests.n` / `-cmd neko tests.n`
- [x] 1.2 Create `tests-php.hxml` with common flags and `-php tests.php` / `-cmd php tests.php/index.php`
- [x] 1.3 Create `tests-java.hxml` with common flags and `-java tests.java` / `-cmd java -jar tests.java/HaxeCryptoTests-Debug.jar`
- [x] 1.4 Create `tests-cpp.hxml` with common flags and `-cpp tests.cpp` / `-cmd tests.cpp/HaxeCryptoTests-debug`

## 2. GitHub Actions workflow

- [x] 2.1 Create `.github/workflows/ci.yml` with triggers: push to `master` and `release-*`, plus `pull_request`
- [x] 2.2 Add matrix with `fail-fast: false` covering js (`tests.hxml`), neko (`tests-neko.hxml`), php (`tests-php.hxml`, apt: `php-cli`), java (`tests-java.hxml`)
- [x] 2.3 Add C++ matrix entry as a YAML comment block (target: cpp, hxml: tests-cpp.hxml, extra haxelib: hxcpp)
- [x] 2.4 Add workflow steps: checkout → setup-haxe (latest) → `haxelib install utest` → conditional apt install → `haxe <matrix.hxml>`

## 3. Cleanup

- [x] 3.1 Delete `.travis.yml`
