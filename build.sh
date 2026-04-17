#!/usr/bin/env bash
set -euo pipefail

VERSION="${VERSION:-v1.0.0}"
BIN="tls-ca-fetch"
OUT="releases/${VERSION}"
LDFLAGS="-s -w"

mkdir -p "${OUT}"

build() {
  local goos="$1" goarch="$2" suffix="${3:-}"
  local target="${OUT}/${BIN}-${goos}-${goarch}${suffix}"
  echo "  building ${target} ..."
  CGO_ENABLED=0 GOOS="${goos}" GOARCH="${goarch}" \
    go build -ldflags="${LDFLAGS}" -trimpath -o "${target}" .
}

echo "tls-ca-fetch build — ${VERSION}"
echo

build linux   amd64
build linux   arm64
build darwin  amd64
build darwin  arm64
build windows amd64 .exe

echo
echo "done — output in ${OUT}/"
ls -lh "${OUT}/"
