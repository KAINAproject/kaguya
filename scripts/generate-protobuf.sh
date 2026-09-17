#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
generated_dir=$(mktemp -d "${TMPDIR:-/tmp}/kaguya-protobuf.XXXXXX")
trap 'rm -rf "$generated_dir"' EXIT INT TERM

(
  cd "$repo_root/packages/shared"
  protoc \
    --plugin=protoc-gen-mbt="$repo_root/scripts/protoc-gen-mbt.sh" \
    --mbt_out="$generated_dir" \
    --mbt_opt=project_name=generated,source_dir=.,json=false,async=false,derive=Eq,Debug \
    kaguya.proto
)

mkdir -p "$repo_root/packages/shared/kaguya/v1"
cp "$generated_dir/generated/kaguya/v1/top.mbt" \
  "$repo_root/packages/shared/kaguya/v1/top.mbt"
moon fmt "$repo_root/packages/shared/kaguya/v1/top.mbt"
