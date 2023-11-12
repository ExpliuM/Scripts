#!/bin/bash

args=("$@")
dir=${args[0]}

find "$dir" -type f -exec bash -c '
    file="$1"
    year=$(date -r "$file" +"%Y")
    month=$(date -r "$file" +"%m")
    targetSubDir="$2/$year/$month"

    mkdir -p "$targetSubDir"
    mv "$file" "$targetSubDir/"
' bash {} "$dir" \;./
