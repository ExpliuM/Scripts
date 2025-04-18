#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

mkdir -p "$SCRIPT_DIR/lists"

brew list >"$SCRIPT_DIR/lists/list.out"
brew list --cask >"$SCRIPT_DIR/lists/cask_list.out"

cat "$SCRIPT_DIR/lists/list.out" "$SCRIPT_DIR/lists/cask_list.out" | sort | uniq >"$SCRIPT_DIR"/lists/merged_list.out
