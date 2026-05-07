## ADDED Requirements

### Requirement: CI runs on relevant push and PR events
The workflow SHALL trigger on push to `master` and any branch matching `release-*`, and on all pull request events regardless of base branch.

#### Scenario: Push to master triggers CI
- **WHEN** a commit is pushed to the `master` branch
- **THEN** the CI workflow runs all active matrix jobs

#### Scenario: Push to release branch triggers CI
- **WHEN** a commit is pushed to a branch matching `release-*`
- **THEN** the CI workflow runs all active matrix jobs

#### Scenario: Pull request triggers CI
- **WHEN** a pull request is opened, synchronized, or reopened
- **THEN** the CI workflow runs all active matrix jobs

### Requirement: Tests run across multiple Haxe targets in parallel
The workflow SHALL run the test suite independently for each active target (js, neko, php, java) as parallel matrix jobs using the latest stable Haxe release.

#### Scenario: Each target compiles and runs independently
- **WHEN** the CI workflow runs
- **THEN** js, neko, php, and java each compile and execute in a separate job without waiting for each other

#### Scenario: One target failure does not cancel others
- **WHEN** one matrix job fails
- **THEN** the remaining matrix jobs continue to completion (`fail-fast: false`)

#### Scenario: JS target passes
- **WHEN** the js matrix job runs
- **THEN** `haxe tests.hxml` compiles to `tests.js` and `node tests.js` exits with code 0

#### Scenario: Neko target passes
- **WHEN** the neko matrix job runs
- **THEN** `haxe tests-neko.hxml` compiles to `tests.n` and `neko tests.n` exits with code 0

#### Scenario: PHP target passes
- **WHEN** the php matrix job runs
- **THEN** `haxe tests-php.hxml` compiles to `tests.php/` and `php tests.php/index.php` exits with code 0

#### Scenario: Java target passes
- **WHEN** the java matrix job runs
- **THEN** `haxe tests-java.hxml` compiles to `tests.java/` and `java -jar tests.java/HaxeCryptoTests-Debug.jar` exits with code 0

### Requirement: C++ target is present but inactive
The workflow config SHALL include a C++ matrix entry in commented-out form so it can be enabled without writing new config.

#### Scenario: C++ does not run by default
- **WHEN** the CI workflow runs
- **THEN** no C++ compilation or execution job is active

#### Scenario: C++ can be enabled by uncommenting
- **WHEN** the commented C++ matrix entry is uncommented
- **THEN** the workflow compiles with `haxe tests-cpp.hxml` (which installs `hxcpp`) and runs `tests.cpp/HaxeCryptoTests-debug`

### Requirement: Travis CI config is removed
The `.travis.yml` file SHALL be deleted as part of this change.

#### Scenario: No Travis config present after change
- **WHEN** the change is applied
- **THEN** `.travis.yml` no longer exists in the repository root

### Requirement: Per-target hxml files exist for all matrix targets
Each matrix target SHALL have a dedicated hxml file that can also be run locally.

#### Scenario: Developer runs a single target locally
- **WHEN** a developer runs `haxe tests-neko.hxml` (or php/java/cpp variant) locally
- **THEN** the target compiles and the tests run for that target only
