#!/usr/bin/env sh
# Part of panpdf
# Written by Eirik Vesterkjær

# abort on error
set -e

INPUT_FILE="INPUT_NOT_SET"
if [[ "$1" =~ ^.+\..+$ ]]
then # non-zero return -> not file
   INPUT_FILE=$(basename -- "$1")
else
    printf "error: unknown input $1\n"
    return -1
fi

HTML_FILETAG=".html"
PDF_FILETAG=".pdf"
INPUT_FILE_NO_EXTENSION=$(echo "$INPUT_FILE" | cut -f 1 -d '.')
INPUT_EXTENSION="${filename##*.}"
OUTPUT_FILE="${INPUT_FILE_NO_EXTENSION}${PDF_FILETAG}"

if [ ! [ "$INPUT_EXTENSION" == "html" || "$INPUT_EXTENSION" == "HTML" ] ]; then
    panhtml $*
    if [[ "$?" != "0" ]]; then
        # failed to create html file
        printf "error: failed to create html file from $INPUT_FILE\n"
        return 1
fi

printf "placeholder for some automization for html -> pdf conversion\n"

