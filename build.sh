#!/usr/bin/env bash
set -euo pipefail

VERSION="${VERSION:-v1.0.0}"
BIN="tls-ca-fetch"
OUT="releases/${VERSION}"
GO_IMAGE="${GO_IMAGE:-golang:1.22-alpine}"

if ! command -v docker &>/dev/null; then
  echo "error: docker not found" >&2
  exit 1
fi

mkdir -p "${OUT}"

echo "tls-ca-fetch build — ${VERSION} (via ${GO_IMAGE})"
echo

# Build all targets inside a single container run.
# Source is mounted read-only at /src; output dir is mounted read-write at /out.
docker run --rm \
  -v "$(pwd):/src:ro" \
  -v "$(pwd)/${OUT}:/out" \
  -e BIN="${BIN}" \
  -e LDFLAGS="-s -w" \
  "${GO_IMAGE}" \
  sh -c '
    set -e
    cd /src
    for target in \
      "linux   amd64  " \
      "linux   arm64  " \
      "darwin  amd64  " \
      "darwin  arm64  " \
      "windows amd64 .exe"
    do
      set -- $target
      goos="$1" goarch="$2" suffix="${3:-}"
      out="/out/${BIN}-${goos}-${goarch}${suffix}"
      echo "  building ${out##*/} ..."
      CGO_ENABLED=0 GOOS="$goos" GOARCH="$goarch" \
        go build -ldflags="$LDFLAGS" -trimpath -o "$out" .
    done
  '

echo
echo "done — output in ${OUT}/"
ls -lh "${OUT}/"
