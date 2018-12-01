#!/usr/bin/env sh
# Part of panpdf
# Written by Eirik Vesterkjær


run_panhtml_if_necessary() {
    if [[ $INPUT_IS_HTML == 0 ]];
    then
        panhtml ${INPUT_FOLDER}/${INPUT_FILE}
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
        # output from panhtml will be saved in the current dir
        INPUT_FILE="${INPUT_FILE_NO_EXTENSION}.html"
        else
        # file not from panhtml
        INPUT_FILE=$INPUT
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

set_file_and_folder() {
    if [ ! -f ${INPUT} ]; then
        return 1
    fi
    INPUT_FILE=$(basename $INPUT)
    INPUT_FOLDER=$(dirname $INPUT)
    return 0
}

INPUT_FILE="INPUT_NOT_SET"
INPUT_FOLDER="FOLDER_NOT_SET"

#abort on error
set -e

INPUT=$1
set_file_and_folder
if [ $? != 0 ]; then
    printf "error: unknown input ${1}\n"
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

