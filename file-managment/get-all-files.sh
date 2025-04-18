#!/bin/bash

# Script data
SCRIPT_DIR=$(dirname "$(realpath "$0")")
SCRIPT_NAME=$(basename "$0")

pushd "$SCRIPT_DIR" || exit

# Logs
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$SCRIPT_DIR/logs/$SCRIPT_NAME.log"

mkdir -p "$LOG_DIR"

# Arguments
args=("$@")
folder=${args[0]}
echo "Getting all files located in $folder folder"

# Main
find "${folder}" -type f >"$LOG_FILE"
popd || exit # $SCRIPT_DIR
