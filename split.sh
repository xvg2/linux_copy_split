#!/bin/bash

SRC_DIR="/updateme"
DEST_DIR="/updateme"
MAX_SIZE=$((15 * 1024 * 1024 * 1024)) # 15 GB in bytes

folder_index=1
current_size=0

mkdir -p "$DEST_DIR/folder_$folder_index"

# Find all files (handles spaces safely)
find "$SRC_DIR" -type f -print0 | while IFS= read -r -d '' file; do
    file_size=$(stat -c%s "$file")

    # If adding this file exceeds limit, move to next folder
    if (( current_size + file_size > MAX_SIZE )); then
        ((folder_index++))
        current_size=0
        mkdir -p "$DEST_DIR/folder_$folder_index"
    fi

    cp "$file" "$DEST_DIR/folder_$folder_index/"
    ((current_size += file_size))
done
