## Why

The existing `.travis.yml` CI is effectively dead — Travis CI's free tier for open-source has been gutted and the config targets Haxe 3.2.1 which is no longer relevant after the migration to `utest`. Replacing it with GitHub Actions gives reliable, integrated CI that runs on PRs and protected branches.

## What Changes

- Add `.github/workflows/ci.yml` — multi-target test matrix triggered on push to `master`/`release-*` and on pull requests
- Add `tests-neko.hxml`, `tests-php.hxml`, `tests-java.hxml`, `tests-cpp.hxml` — per-target hxml files for use by the matrix
- Remove `.travis.yml`

## Capabilities

### New Capabilities

- `github-actions-ci`: GitHub Actions workflow that compiles and runs the test suite across JS, Neko, PHP, and Java targets (C++ present but commented out); triggered on push to `master`/`release-*` and all pull requests

### Modified Capabilities

_(none — no existing spec-level behavior changes)_

## Impact

- **CI infrastructure**: Replaces Travis with GitHub Actions; no code changes to the library itself
- **Dependencies**: Adds `krdlab/setup-haxe` GitHub Action (latest stable Haxe); `utest` and `hxcpp` installed via `haxelib install` in the workflow
- **New files**: 5 files added (1 workflow YAML + 4 hxml), 1 removed (`.travis.yml`)
