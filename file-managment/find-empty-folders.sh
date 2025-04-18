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

# Dir argument
dir=${args[0]}
[ -d "$dir" ] || die "Directory $dir does not exist"
# echo "dir=$dir"

# Delete argument
delete="${args[1]:-false}"
echo "$delete" | grep -E -q "true|false" || die "Delete should be false/true"
# echo "delete=$delete"

commandArgs=""
if [ "$delete" = "true" ]; then
    commandArgs=-delete
fi
# echo "$commandArgs"

find "$dir" -depth -type d -empty $commandArgs

popd || exit # SCRIPT_DIR
