## Context

The project currently has a `.travis.yml` targeting Haxe 3.2.1 and `development`, running only `tests.hxml` (JS). Travis CI's free tier for open-source projects has been effectively discontinued. The recent migration from `haxe.unit` to `utest` makes the old config incompatible anyway. GitHub Actions is the natural replacement — it's free, integrated, and widely supported.

The test suite compiles Haxe to multiple targets and runs the output. Each target has slightly different system requirements (Node.js, PHP CLI, JDK, Neko, g++/hxcpp).

## Goals / Non-Goals

**Goals:**
- Replace `.travis.yml` with a working GitHub Actions workflow
- Run tests on JS, Neko, PHP, and Java in a parallel matrix
- Trigger on push to `master` and `release-*` branches, and on all pull requests
- Include C++ in the matrix config but leave it commented out (too slow for default CI)
- Keep per-target build config in hxml files, not inline in the workflow YAML

**Non-Goals:**
- Publishing/deployment automation (handled separately by `deploy.sh`)
- Cross-OS matrix (linux is sufficient for a crypto library with no platform-specific code)
- Caching Haxe compilation output (low value for this size of project)
- Code coverage or artifact upload

## Decisions

### Per-target hxml files over inline YAML flags

**Decision**: Create `tests-neko.hxml`, `tests-php.hxml`, `tests-java.hxml`, `tests-cpp.hxml` alongside the existing `tests.hxml`.

**Rationale**: The project already uses hxml files as the canonical build config (`tests.hxml`, `tests_all.hxml`, `tests_native.hxml`). Keeping target definitions in hxml is consistent with that pattern and allows developers to run any single target locally without reading the CI YAML. Inline YAML flags would split build config across two systems.

### `krdlab/setup-haxe` with `haxe-version: latest`

**Decision**: Use the `krdlab/setup-haxe` community action pinned to a recent version, requesting latest stable Haxe.

**Rationale**: This is the established action for Haxe CI. It installs both Haxe and Neko. `latest` tracks the stable release without requiring manual version bumps.

### C++ commented out, not removed

**Decision**: Include the C++ matrix entry as a YAML comment block rather than omitting it entirely.

**Rationale**: C++ compilation via `hxcpp` takes 3–5 minutes and requires `haxelib install hxcpp`. Leaving it commented preserves the config for anyone who wants to enable it, without slowing down every CI run.

### `strategy.fail-fast: false`

**Decision**: Set `fail-fast: false` on the matrix.

**Rationale**: A failure on one target (e.g. PHP) shouldn't cancel the other in-flight jobs. All failures should be visible in one run.

## Risks / Trade-offs

- **PHP version drift** → ubuntu-latest ships with a specific PHP version; future runner image updates could change behavior. Mitigation: none needed at this scale — pin only if a problem arises.
- **`krdlab/setup-haxe` maintenance** → community action, not officially maintained by Haxe Foundation. Mitigation: pin to a specific action version (e.g. `v1`) rather than `main`.
- **C++ latent breakage** → With C++ commented out, target-specific bugs on that backend won't be caught. Mitigation: documented trade-off; can be re-enabled any time.

## Migration Plan

1. Create per-target hxml files
2. Create `.github/workflows/ci.yml`
3. Delete `.travis.yml`
4. Push to a PR branch — GitHub Actions triggers automatically
5. Verify all matrix jobs pass before merging
