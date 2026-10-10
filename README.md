# xtruder/homebrew-tap

Personal Homebrew tap.

## Formulae

- `openbao-authorizer` — human approval of OpenBao access requests, with the
  `bao-cred` client (prebuilt binaries for Linux and macOS)
- `oo7` — D-Bus Secret Service provider (`org.freedesktop.secrets`), a headless
  replacement for gnome-keyring

## Install

```sh
brew tap xtruder/tap
brew install openbao-authorizer
brew install oo7
```

`oo7` ships a pre-built bottle for `x86_64_linux`, so `brew install` downloads and
pours it. Source is the fallback for any platform without a bottle.

## Updates

Renovate opens PRs for new upstream releases (`renovate.json`; check it with
`make validate`). On every PR that touches `Formula/`:

- **Checksums** downloads each `url` and compares it with its `sha256`.
- **Bottle** builds bottles for formulae that have a `bottle do` block (`oo7`)
  on Ubuntu 22.04, runs `brew test`, uploads them to the `<formula>-<version>`
  release and pushes the new bottle block to the PR branch. Merge after that
  commit appears.

`openbao-authorizer` installs prebuilt release binaries and has no bottle.

To rebuild a bottle by hand, run the Bottle workflow with the formula name:

```sh
gh workflow run bottle.yml -R xtruder/homebrew-tap -f formula=oo7
```

Bottle releases are tagged `<formula>-<version>` so formulae never collide.
Version comes from the `url`; don't add a `version` line, because Renovate only
rewrites `url` and `sha256`.

## Gotchas

- `--build-bottle` is on `brew install`, not `brew reinstall`, and `--force`
  doesn't override "already installed" — uninstall first.
- Prerelease bottles: `brew bottle` emits `oo7--<ver>…` (double dash) but
  `brew install` wants `oo7-<ver>…` (single dash); rename the asset to single dash.
- `root_url` must include the release tag (`…/releases/download/oo7-<ver>`),
  because Homebrew builds the URL as `root_url + "/" + filename`.
- Linux bottles inherit the builder's glibc — build on the oldest glibc you want
  to support (e.g. Ubuntu LTS, not the newest Fedora).
