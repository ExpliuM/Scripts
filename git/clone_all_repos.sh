#!/bin/bash

# Get script dir
SOURCE=${BASH_SOURCE[0]}

while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

if [ -z "$1" ]; then
    echo "waiting for the following arguments: username + max-page-number"
    exit 1
else
    username=$1
fi

if [ -z "$2" ]; then 
    max=2
else
    max=$2
fi

context="users"
type="All"
page_number=1
per_page=100

GITHUB_TOKEN=`cat $DIR/TOKENS/git_token`


# To find number of pages
until [ $max -lt $page_number ]
do 
    echo downloading page_number=$page_number

    pageData=`curl \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN"\
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/search/repositories?q=user:$username&page=$page_number&per_page=$per_page" \
    --no-progress-meter`

    if [[ "$pageData" == *"API rate limit exceeded"* ]]; then
        echo "API rate limit exceeded"
        exit 1
    fi

    # could not fetch page data
    if [ -z "$pageData" ]; then
        echo "Could not extarct data for page $page_number"w
        echo "by using URL: \"https://api.github.com/$context/$username/repos?page=$page_number&per_page=$per_page\""
        exit 1
    fi


    # Extract clone URL's
    extractedCloneURLs=`echo -e "$pageData" | jq | grep -e 'clone_url*' | cut -d \" -f 4`
    
    # No URL's extracted
    if [ -z "$extractedCloneURLs" ]; then 
        exit 1
    fi

    # Clone projects
    echo -e "$extractedCloneURLs" | xargs -L1 git clone

    let page_number++
done

exit 0