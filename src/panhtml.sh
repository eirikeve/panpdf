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

# Check if file, or "-i"
INPUT_FILE="INPUT_NOT_SET"

#abort on error
set -e


if [[ "$1" =~ ^.+\..+$ ]]
then # non-zero return -> not file
   INPUT_FILE=$(basename -- "$1")
else
    printf "error: unknown input $1\n"
    return 1
fi
CSS=${INSTALL_FOLDER}/${CSS_FILENAME}

if [ ! -f $CSS ]; 
then
   printf "error: could not find css ${CSS}\n"
   return 1
fi

HTML_FILETAG=".html"
INPUT_FILE_NO_EXTENSION=$(echo "$INPUT_FILE" | cut -f 1 -d '.')
OUTPUT_FILE="${INPUT_FILE_NO_EXTENSION}${HTML_FILETAG}"

TITLE="$(grep -m 1 . ${INPUT_FILE})"
printf "panpdf: converting ${TITLE}\n"

pandoc -i ${INPUT_FILE} -o ${OUTPUT_FILE} -s --highlight-style=tango  -M title:"${TITLE}" --mathjax
CP_FILE="${OUTPUT_FILE}.cp"
cat $OUTPUT_FILE > $CP_FILE
printf "<style>\n" > $OUTPUT_FILE
cat ${INSTALL_FOLDER}/${CSS_FILENAME} >> $OUTPUT_FILE
printf "\n</style>\n" >> $OUTPUT_FILE

echo "$(sed "s/<p>${TITLE}<\/p>//g" ${CP_FILE})" > ${CP_FILE}

cat $CP_FILE >> $OUTPUT_FILE

rm $CP_FILE


