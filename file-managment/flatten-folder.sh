#!/bin/bash

# Script data
SCRIPT_DIR=$(dirname "$(realpath "$0")")
SCRIPT_NAME=$(basename "$0")

# echo "SCRIPT_DIR=$SCRIPT_DIR"
# echo "SCRIPT_DIR=$SCRIPT_NAME"
pushd "$SCRIPT_DIR" || exit

# Logs
# Log dirs
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$SCRIPT_DIR/logs/$SCRIPT_NAME.log"

# Log files
ERROR_LOG_FILE="$SCRIPT_DIR/logs/$SCRIPT_NAME-errors.log"
NOT_OVERWRITTEN_FILES="$SCRIPT_DIR/logs/$SCRIPT_NAME-not-overwritten.log"

# Make log dir
mkdir -p "$LOG_DIR"

# Clean up the log files
rm -f "$NOT_OVERWRITTEN_FILES"
rm -f "$LOG_FILE"

# Arguments
args=("$@")
flattenFolder=${args[0]}
echo "flattenFolder=$flattenFolder"

# Main
find "${flattenFolder}" -type f -mindepth 2 -exec mv -vn '{}' "${flattenFolder}" ';' 2>"$ERROR_LOG_FILE" >"$LOG_FILE"

# Handle logs
cat "$LOG_FILE" | grep "not overwritten" >"$NOT_OVERWRITTEN_FILES"
popd || exit # SCRIPT_DIR
