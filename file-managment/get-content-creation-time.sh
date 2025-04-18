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
    echo "SCRIPT_DIR=${SCRIPT_DIR}" >>"$LOG_FILE"
    echo "SCRIPT_NAME=${SCRIPT_NAME}" >>"$LOG_FILE"

    echo "args=${args[*]}" >>"$LOG_FILE"
    echo "file=${file}" >>"$LOG_FILE"

    # Get file data
    filename=$(basename "$file")
    echo "filename=${filename}" >>"$LOG_FILE"

    # # Logs by file
    # LOG_BY_FILE_FILE="${LOG_BY_FILE_DIR}/${filename}.log"
    # if [ -f "$WORKING_DIR" ]; then
    #     rm -f "$LOG_BY_FILE_FILE"
    # fi
    # touch "$LOG_BY_FILE_FILE"

    # Date from filename
    # echo "LOG_BY_FILE_FILE=$LOG_BY_FILE_FILE" >$LOG_FILE
    decodedDate=$(echo "$filename" | grep -oh -m 1 "[[:digit:]]\{8\}")
    echo "decodedDate=$decodedDate" >>"$LOG_FILE"
    parsedFileNameDate=$(LC_TIME=en_US.UTF-8 gdate -d "$decodedDate")
    echo "parsedFileNameDate=$parsedFileNameDate" >>"$LOG_FILE"
    # from stat
    # statBirthDate=$(stat -f '%w' "$file")
    # statChangeDate=$(stat -f '%z' "$file")
    # statModifyDate=$(stat -f '%y' "$file")

    # echo "date"
    # date -r "$file"

    # echo "mdls"
    # mdls "$file"

    # echo "exiftool"
    # exiftool "$file"

    dates=("$parsedFileNameDate" "$statBirthDate" "$statChangeDate" "$statModifyDate")
    echo "dates=${dates[*]}" >>"$LOG_FILE"

    # Sort the array of dates and get the latest date
    earliestDate=$(printf "%s\n" "${dates[@]}" | sort | tail -n 1)
    echo "earliestDate=$earliestDate" >>"$LOG_FILE"
    echo "$earliestDate" # return value

    popd >/dev/null || exit # "$SCRIPT_DIR"
}

args=("$@")
main "${args[@]}"
