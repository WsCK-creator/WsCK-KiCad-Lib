#!/bin/bash
OUT_DIR="WsCK_Footprint_Library.pretty"
SUBMODULES_DIR="submodules"

echo "[*] Initializing & updating submodules..."
for dir in submodules/*; do
    if [ -d "$dir" ]; then
        name=$(basename "$dir")
        git config -f .gitmodules submodule.submodules/$name.branch main
    fi
done
git submodule sync
git submodule update --init --remote --checkout --recursive

echo "[*] Cleaning output directory..."
mkdir -p "$OUT_DIR"
rm -rf "$OUT_DIR"/*

echo "[*] Extracting .kicad_mod files..."
for mod in "$SUBMODULES_DIR"/*/; do
    echo "[*]   Processing submodule: $mod"
    for file in "$mod"*.kicad_mod; do
        if [ -f "$file" ]; then
            echo "[*]     Copying $file"
            cp "$file" "$OUT_DIR"
        fi
    done
done

echo "[*] Cleaning $SUBMODULES_DIR directory..."
for dir in "$SUBMODULES_DIR"/*; do
    if [ -d "$dir" ]; then
        rm -rf "$dir"/.*
		rm -rf "$dir"/*
    fi
done


echo "[✓] Library generated in $OUT_DIR/"
