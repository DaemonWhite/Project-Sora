#!/usr/bin/env bash

set -e

OS_LIST=("windows" "linux" "macos")
ARCH_LIST=("x86_x64" "arm64")

BASE_DIR="./export"

echo "📁 Création des dossiers dans $BASE_DIR..."

for os in "${OS_LIST[@]}"; do
  for arch in "${ARCH_LIST[@]}"; do
    target_dir="$BASE_DIR/$os/$arch"
    mkdir -p "$target_dir"
    echo "  ✓ $target_dir"
  done
done

echo "✨ Arborescence créée avec succès !"