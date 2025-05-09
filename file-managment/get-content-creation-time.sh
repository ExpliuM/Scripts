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

    # # from stat
    # statBirthDate=$(stat -f '%w' "$file")
    # echo "statBirthDate=$statBirthDate" >>"$LOG_FILE"

    # statChangeDate=$(stat -f '%z' "$file")
    # echo "statChangeDate=$statBirthDate" >>"$LOG_FILE"

    # statModifyDate=$(stat -f '%y' "$file")
    # echo "statModifyDate=$statBirthDate" >>"$LOG_FILE"

    # # echo "date"
    # echo "date -r \"$file\"" >>"$LOG_FILE"
    # date -r "$file" >>"$LOG_FILE"

    # # echo "mdls"
    # echo "mdls \"\$file\"" >>"$LOG_FILE"
    # mdls "$file" >>"$LOG_FILE"

    # echo "exiftool"
    echo "exiftool \"$file\"" >>"$LOG_FILE"
    createDateFromExifToolPreFormat=$(exiftool "$file" -json | jq ".[0].CreateDate" | tr -d '"' | sed 's/:/-/1; s/:/-/1') >>"$LOG_FILE"
    createDateFromExifTool=$(LC_TIME=en_US.UTF-8 gdate -d "$createDateFromExifToolPreFormat")

    createdDateFromExifToolPreFormat=$(exiftool "$file" -json | jq ".[0].DateCreated" | tr -d '"' | sed 's/:/-/1; s/:/-/1') >>"$LOG_FILE"
    createdDateFromExifTool=$(LC_TIME=en_US.UTF-8 gdate -d "$createdDateFromExifToolPreFormat")

    fileModifyDateExifToolPreFormat=$(exiftool "$file" -json | jq ".[0].FileModifyDate" | tr -d '"' | sed 's/:/-/1; s/:/-/1') >>"$LOG_FILE"
    fileModifyDateExifTool=$(LC_TIME=en_US.UTF-8 gdate -d "$fileModifyDateExifToolPreFormat")

    dates=("$parsedFileNameDate" "$statBirthDate" "$statChangeDate" "$statModifyDate" "$createDateFromExifTool" "$createdDateFromExifTool" "$fileModifyDateExifTool")
    echo "dates=${dates[*]}" >>"$LOG_FILE"

    # Find earliest date
    for date in "${dates[@]}"; do
        echo "date=$date" >>"$LOG_FILE"
        epoch=$(LC_TIME=en_US.UTF-8 gdate -d "$date" +%s)
        echo "epoch=$epoch" >>"$LOG_FILE"
        if [[ -z "$earliestDate" || "$epoch" -lt "$earliest_epoch" ]]; then
            earliestDate="$date"
            earliest_epoch="$epoch"
        fi

        echo "earliestDate=$earliestDate" >>"$LOG_FILE"
        echo "earliest_epoch=$earliest_epoch" >>"$LOG_FILE"
    done

    echo "earliestDate=$earliestDate" >>"$LOG_FILE"
    echo "$earliestDate" # return value

    popd >/dev/null || exit # "$SCRIPT_DIR"
}

args=("$@")
main "${args[@]}"
