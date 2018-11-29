#!/usr/bin/env sh
# Part of panpdf
# Written by Eirik Vesterkjær


run_panhtml_if_necessary() {
    if [[ $INPUT_IS_HTML == 0 ]];
    then
        panhtml $INPUT_FILE
        if [[ "$?" != "0" ]]; then
            # failed to create html file
            printf "error: failed to create html file from $INPUT_FILE\n"
            return 1
        fi
    fi
    return 0
}

convert_html_to_pdf() {
    if [[ $INPUT_IS_HTML == 0 ]];
    then
        # output from panhtml
        INPUT_FILE="${INPUT_FILE_NO_EXTENSION}.html"
    fi
    cupsfilter ${INPUT_FILE} > ${OUTPUT_FILE} 2> /dev/null
}

cleanup() {
    if [[ $INPUT_IS_HTML == 0 ]];
    then
        # created by panhtml
        rm $INPUT_FILE
    fi
}

# abort on error
set -e

INPUT_FILE="INPUT_NOT_SET"

if [[ "$1" =~ ^.+\..+$ ]]
then # non-zero return -> not file
   INPUT_FILE=$(basename -- "$1")
else
    printf "error: unknown input $1\n"
    exit 1
fi

HTML_FILETAG=".html"
PDF_FILETAG=".pdf"
INPUT_FILE_NO_EXTENSION="${INPUT_FILE%.*}"
INPUT_EXTENSION="${INPUT_FILE##*.}"
OUTPUT_FILE="${INPUT_FILE_NO_EXTENSION}${PDF_FILETAG}"


if [ "${INPUT_EXTENSION}" != "html" ] && [ "${INPUT_EXTENSION}" != "HTML" ];
then
    INPUT_IS_HTML=0
else
    INPUT_IS_HTML=1
fi


run_panhtml_if_necessary
if [[ "$?" != "0" ]]; then
    exit 1
fi

convert_html_to_pdf
if [[ "$?" != "0" ]]; then
    exit 1
fi

cleanup

