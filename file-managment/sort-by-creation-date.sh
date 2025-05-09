#!/bin/bash

# Script data
SCRIPT_DIR=$(dirname "$(realpath "$0")")
fileName=$(basename "$0")

pushd "$SCRIPT_DIR" >/dev/null || exit

# Logs
# Log dirs
LOG_DIR="$SCRIPT_DIR/logs/$fileName/"

# Log files
# LOG_BY_FILE_DIR="${LOG_DIR}by-file/"
LOG_FILE="$LOG_DIR/$fileName.log"

# Make log dir
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

# # Clean up the log file
# . "$SCRIPT_DIR/clean-logs.sh"

# Params
filesToExclude="\(.DS_Store\)"

# Arguments
args=("$@")
dirFullPath=${args[0]}

# Convert all the files to a files array
# TODO: -maxdepth 1 - make it configurable
while IFS= read -r file; do
    fileFullPaths+=("$file")
done < <(find "$dirFullPath" -type f -maxdepth 1 | grep -v "$filesToExclude")

for fileFullPath in "${fileFullPaths[@]}"; do
    fileName=$(basename "$fileFullPath")
    echo "fileFullPath=$fileFullPath" >>"$LOG_FILE"

    ########## Old version
    # creationDate=$(exiftool -DateTimeOriginal "$file" | cut -d":" -f2- | sed 's/^[ \t]*//;s/[ \t]*$//')
    # dateFormat="%Y:%m:%d %H:%M:%S"

    # if [ -z "$creationDate" ]; then
    #     creationDate=$(stat -f "%SB" "$file")
    #     dateFormat="%b %e %T %Y"
    # fi

    # year=$(date -j -f "$dateFormat" "$creationDate" +"%Y")
    # month=$(date -j -f "$dateFormat" "$creationDate" +"%m")
    ##########

    # Get content creation date
    creationDate=$(./get-content-creation-time.sh "$fileFullPath")
    echo "creationDate=$creationDate" >>"$LOG_FILE"
    if [[ -z "${creationDate}" ]]; then
        echo "Skipping move for file $fileFullPath cause creationDate=$creationDate" | tee -a "$LOG_FILE"
        continue
    fi

    # Parsing year and month of creation
    year=$(LC_TIME=en_US.UTF-8 gdate -d "$creationDate" +"%Y")
    month=$(LC_TIME=en_US.UTF-8 gdate -d "$creationDate" +"%m")

    if [[ -z "${creationDate}" || -z "${year}" || -z "${month}" ]]; then
        echo "Skipping move for file $fileFullPath cause year=$year, month=$month, creationDate=$creationDate" | tee -a "$LOG_FILE"
        continue
    fi

    targetDirFullPath="$dirFullPath/$year/$month"
    echo "targetSubDir=$targetDirFullPath" >>"$LOG_FILE"

    # Making the subdir in case it doesn't exists
    mkdir -p "$targetDirFullPath"

    targetFileFullPath=$targetDirFullPath/$fileName
    if [ -f "$targetFileFullPath" ]; then
        echo "Target $targetFileFullPath file already exists, file overwrite is not allowed" >>"$LOG_FILE"

    fi

    # Moving the file
    # if ["$fileFullPath" != "$targetDirFullPath"]:the
    mv -vn "$fileFullPath" "$targetDirFullPath/" >>"$LOG_FILE"
done
popd >/dev/null || exit # SCRIPT_DIR
