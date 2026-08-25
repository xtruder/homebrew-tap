# xtruder/homebrew-tap

Personal Homebrew tap.

## Formulae

- `notify-relay` — forward `notify-send` notifications to a host desktop session
- `oo7` — D-Bus Secret Service provider (`org.freedesktop.secrets`), a headless
  replacement for gnome-keyring

## Install

```sh
brew tap xtruder/tap
brew install oo7
```

`oo7` ships a pre-built bottle for `x86_64_linux`, so `brew install` downloads and
pours it. Source is the fallback for any platform without a bottle.

## Releasing a new version (bottle)

Each release publishes a bottle on GitHub Releases so installs don't compile from
source. Use a **formula-prefixed release tag** (`oo7-<VERSION>`) so multiple
formulae in this tap never collide on a tag.

1. Bump the formula: update `url` + `version` + source `sha256`, and **remove the
   old `bottle do … end` block**.

   ```sh
   curl -L "https://github.com/linux-credentials/oo7/archive/refs/tags/<TAG>.tar.gz" | sha256sum
   ```

2. Rebuild with the bottling flag (`--build-bottle` is on `brew install`, **not**
   `brew reinstall` — uninstall first):

   ```sh
   brew uninstall oo7
   brew install --build-bottle oo7
   ```

3. Generate the bottle:

   ```sh
   brew bottle --root-url="https://github.com/xtruder/homebrew-tap/releases/download/oo7-<VERSION>" oo7
   ```

4. Publish it to a GitHub release. **Prerelease versions** get a `--` (double
   dash) name from `brew bottle` but `brew install` requests `-` (single dash) —
   rename before uploading:

   ```sh
   mv oo7--<VERSION>.x86_64_linux.bottle.*.tar.gz oo7-<VERSION>.x86_64_linux.bottle.*.tar.gz
   gh release create oo7-<VERSION> oo7-<VERSION>.x86_64_linux.bottle.*.tar.gz \
     --repo xtruder/homebrew-tap --title "oo7 <VERSION>" --generate-notes
   ```

5. Add the `bottle do … end` block that `brew bottle` printed (sha256 + `rebuild`
   + `cellar`) into the formula. Make sure `root_url` includes the release **tag**
   segment:

   ```ruby
   bottle do
     root_url "https://github.com/xtruder/homebrew-tap/releases/download/oo7-<VERSION>"
     rebuild 1
     sha256 cellar: :any, x86_64_linux: "<sha256>"
   end
   ```

6. Commit, push, verify:

   ```sh
   git add Formula/oo7.rb && git commit -m "oo7: release <VERSION> bottle" && git push
   brew uninstall oo7 && brew install oo7   # should print "Pouring …", not compile
   ```

## Gotchas

- `--build-bottle` is on `brew install`, not `brew reinstall`, and `--force`
  doesn't override "already installed" — uninstall first.
- Prerelease bottles: `brew bottle` emits `oo7--<ver>…` (double dash) but
  `brew install` wants `oo7-<ver>…` (single dash); rename the asset to single dash.
- `root_url` must include the release tag (`…/releases/download/oo7-<ver>`),
  because Homebrew builds the URL as `root_url + "/" + filename`.
- Linux bottles inherit the builder's glibc — build on the oldest glibc you want
  to support (e.g. Ubuntu LTS, not the newest Fedora).
