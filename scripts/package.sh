#!/usr/bin/env sh

# Package the plugin into dist/helm-git-<version>.tgz and sign it into
# dist/helm-git-<version>.tgz.prov, so that Helm v4 can verify it on install.
# Requires Helm v4.
#
# Environment:
#   HELM_GIT_SIGNING_KEY         name (or email) of the signing key
#   HELM_GIT_SIGNING_KEYRING     path to a keyring containing the secret key
#   HELM_GIT_SIGNING_PASSPHRASE  passphrase of the secret key (optional)

set -eu

: "${HELM_GIT_SIGNING_KEY:?must be set}"
: "${HELM_GIT_SIGNING_KEYRING:?must be set}"
HELM_BIN="${HELM_BIN:-helm}"

cd "$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd -P)"

stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

# Only ship the files the plugin needs at runtime.
mkdir "$stage/helm-git"
cp plugin.yaml helm-git helm-git-plugin.sh LICENSE README.md "$stage/helm-git/"

mkdir -p dist
if [ -n "${HELM_GIT_SIGNING_PASSPHRASE:-}" ]; then
  printf '%s' "$HELM_GIT_SIGNING_PASSPHRASE" | "$HELM_BIN" plugin package "$stage/helm-git" \
    --destination dist \
    --key "$HELM_GIT_SIGNING_KEY" \
    --keyring "$HELM_GIT_SIGNING_KEYRING" \
    --passphrase-file -
else
  "$HELM_BIN" plugin package "$stage/helm-git" \
    --destination dist \
    --key "$HELM_GIT_SIGNING_KEY" \
    --keyring "$HELM_GIT_SIGNING_KEYRING"
fi
