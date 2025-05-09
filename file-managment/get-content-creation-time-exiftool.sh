#!/bin/bash

# Script data
SCRIPT_DIR=$(dirname "$(realpath "$0")")
SCRIPT_NAME=$(basename "$0")

# Logs
# Log dirs
LOG_DIR="$SCRIPT_DIR/logs/$SCRIPT_NAME"
LOG_BY_FILE_DIR="${LOG_DIR}/by-file"

# mkdir -p $LOG_BY_FILE_DIR
mkdir -p "$LOG_DIR"
mkdir -p "$LOG_BY_FILE_DIR"

# Log files
LOG_FILE="$LOG_DIR/$SCRIPT_NAME.log"
touch "$LOG_FILE"

function main {
    # Arguments
    args=("$@")
    file=${args[0]}

    pushd "$SCRIPT_DIR" >>"$LOG_FILE" || exit

    # echo "exiftool"
    echo "exiftool \"\$file\"" >>"$LOG_FILE"
    createDateFromExifTool=$(exiftool ~/OneDrive/My\ Pictures/To\ sort/From\ Katias\ Phone/IMG_2653.HEIC -json | jq ".[0].CreateDate" | tr -d '"' | sed 's/:/-/1; s/:/-/1')

    LC_TIME=en_US.UTF-8 gdate -d "$createDateFromExifTool"

    popd >/dev/null || exit # "$SCRIPT_DIR"
}

args=("$@")
main "${args[@]}"
