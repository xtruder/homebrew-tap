#!/usr/bin/env bash
# Downloads every `url` in the formulae and checks it against its `sha256`, so a wrong checksum (e.g. from a Renovate PR) fails before merge.
set -euo pipefail

(($#)) || set -- Formula/*.rb
status=0
for formula in "$@"; do
  while read -r url sha; do
    actual="$(curl -fsSL "$url" | sha256sum | cut -d' ' -f1)"
    if [[ "$actual" == "$sha" ]]; then
      printf 'ok        %s\n' "$url"
    else
      printf 'MISMATCH  %s\n          formula %s\n          actual  %s\n' "$url" "$sha" "$actual"
      status=1
    fi
  # Pairs each url with the next plain `sha256 "..."`; lines such as `version`
  # may sit in between, and bottle checksums (`sha256 cellar: ...`) are skipped.
  done < <(awk '/^ *url "/ { gsub(/"/, "", $2); url = $2; next }
                url && /^ *sha256 "/ { gsub(/"/, "", $2); print url, $2; url = "" }' "$formula")
done
exit "$status"
