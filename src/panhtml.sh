#!/usr/bin/env sh
# Part of panpdf
# Written by Eirik Vesterkjær

#########
# Don't move or modify this block !
# The css filepath is inserted here by the install shell
# INSTALL_FOLDER
#
# CSS_FILENAME
#
#########

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
CSS=${INSTALL_FOLDER}/${CSS_FILENAME}

#abort on error
set -e

INPUT=$1
set_file_and_folder
if [ $? != 0 ]; then
    printf "error: unknown input ${1}\n"
    exit 1
fi
if [ ! -f $CSS ]; then
    printf "error: failed to find CSS ${CSS}\n"
    exit 1
fi

HTML_FILETAG=".html"


INPUT_FILE_NO_EXTENSION="${INPUT_FILE%.*}"
OUTPUT_FILE="${INPUT_FILE_NO_EXTENSION}${HTML_FILETAG}"
# set the title as the first nonzero line.

TITLE="$(grep -m 1 . ${INPUT_FOLDER}/${INPUT_FILE})"

pandoc -i ${INPUT_FOLDER}/${INPUT_FILE} -o ${OUTPUT_FILE} -s --highlight-style=tango  -M title:"${TITLE}" --mathml
echo "$(sed "s/<p>${TITLE}<\/p>//g" ${OUTPUT_FILE})" > ${OUTPUT_FILE}
printf "\n<style>\n" >> $OUTPUT_FILE
cat ${INSTALL_FOLDER}${CSS_FILENAME} >> $OUTPUT_FILE
printf "\n</style>\n" >> $OUTPUT_FILE


