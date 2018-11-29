#!/usr/bin/env sh
# Part of panpdf
# Written by Eirik Vesterkjær

css_source=""
storage_location=""
css_storage_filename=""

check_install_config() {
    if [ -z ${css_source+x} ]; then
        # css_source not set in config
        printf "error: css_source not set in config\n"
        printf "css_source is required\n"
        return 1
    fi
    if [ -z ${storage_location+x} ]; then
        # storage_location not set in config
        printf "error: storage_location not set in config\n"
        printf "storage_location is required\n"
        return 1
    fi
    if [ -z ${css_storage_filename+x} ]; then
        # css_storage_filename not set in config
        css_storage_filename="panpdf_markdown.css"
        printf "error: css_storage_filename not set in config\n"
        printf "css_storage_filename is required"
        return 1
    fi

    if [[ $storage_location == *";"* ]]; then
        printf "error: storage_location contains the char ;\n"
        printf "it is used for deliming with sed, so please change it\n"
        return 1
    fi

    return 0
}

check_satisfies_requirements() {
    if [[ "$OSTYPE" != "darwin"* ]]
    then
        printf "error: panpdf currently only supports macOS\n"
        printf "cannot install panpdf for $OSTYPE since AppleScript is used for HTML -> PDF conversion\n"
        printf "check out wkhtmltopdf or similar libs - "
        printf "pull requests are welcome if you're interested in contributing ( github.com/eirikeve/panpdf )\n"
        return 1
    else
        command -v pandoc > /dev/null
        if [[ "$?" != "0" ]]
        then
            printf "$?\n"
            printf "error: panpdf relies on pandoc for * -> HTML conversion\n"
            printf "cannot install since pandoc isn't available\n"
            printf "check out pandoc.org\n"
            return 1
        fi
        command -v cupsfilter > /dev/null
        if [[ "$?" != "0" ]]
        then
            printf "$?\n"
            printf "error: panpdf relies on cupsfilter for * -> HTML conversion\n"
            printf "cannot install since cupsfilter isn't available\n"
            printf "check out cups.org\n"
            return 1
        fi
    fi
    return 0
}

try_make_tmp_install_folder() {
    mkdir -p $TMP_INSTALL_FOLDER
    if [ ! -d "$TMP_INSTALL_FOLDER" ]; then
        printf "$?\n"
        printf "error: failed to make local temp folder for installation\n"
        return 1
    fi
    return 0
}

try_create_install_folders() {
    if [ ! -d "$storage_location" ]; then
        mkdir -p $storage_location
        if [ ! -d "$storage_location" ]; then
            printf "$?\n"
            printf "error: could not create folder ${storage_location}\n"
            printf "try creating it yourself or running sudo ./install\n"
            return 1
        fi
    fi
    return 0
}

try_download_css() {
    curl -s --fail $css_source > $css_storage_filename

    if [[ "$?" != "0" ]]; then
        # invalid URL
        rm $css_storage_filename
    fi
    return $?
}



make_executables() {
    cp $PANHTML_SRC $TMP_PANHTML
    cp $PANPDF_SRC $TMP_PANPDF
    mv $css_storage_filename $TMP_CSS

    INSTALL_FOLDER_LINE="# INSTALL_FOLDER"
    CSS_FILENAME_LINE="# CSS_FILENAME"

    
    sed -i '' "s;${INSTALL_FOLDER_LINE};INSTALL_FOLDER=${storage_location};" $TMP_PANHTML
    if [[ "$?" != "0" ]]; then
        printf "error: failed to set storage_location to panhtml\n"
        return 1
    fi
    sed -i '' "s;${CSS_FILENAME_LINE};CSS_FILENAME=${css_storage_filename};" $TMP_PANHTML
    if [[ "$?" != "0" ]]; then
        printf "error: failed to set css_storage_filename to panhtml\n"
        return 1
    fi

    chmod a+x $TMP_PANHTML
    chmod a+x $TMP_PANPDF

    chmod a-w $TMP_PANPDF
    chmod a-w $TMP_PANPDF
    chmod a-w $TMP_CSS

    return 0
}

finish_installation() {
    PANHTML_INSTALL=${storage_location}/panhtml.sh
    PANPDF_INSTALL=${storage_location}/panpdf.sh
    CSS_INSTALL=${storage_location}/$css_storage_filename

    mv $TMP_PANHTML $PANHTML_INSTALL
    mv $TMP_PANPDF $PANPDF_INSTALL
    mv $TMP_CSS $CSS_INSTALL

    # symlinks for executables
    ln -sf $PANHTML_INSTALL /usr/local/bin/panhtml
    if [[ "$?" != "0" ]]; then
        printf "error: failed add symlink to panhtml\n"
        return 1
    fi
    ln -sf $PANPDF_INSTALL /usr/local/bin/panpdf
    if [[ "$?" != "0" ]]; then
        ln -s $PANHTML_INSTALL /usr/local/bin/panhtml
        printf "error: failed to add symlink to panpdf\n"
        return 1
    fi

    return 0
}

cleanup() {
    # the folder is empty so no prompt should appear for subfolders etc
    rm -r $TMP_INSTALL_FOLDER
}


#abort on error
set -e

# get config values
. config

# useful vars
TMP_INSTALL_FOLDER=panpdf_install_tmp
PANHTML_SRC=src/panhtml.sh
PANPDF_SRC=src/panpdf.sh
TMP_PANHTML=${TMP_INSTALL_FOLDER}/panhtml.sh
TMP_PANPDF=${TMP_INSTALL_FOLDER}/panpdf.sh
TMP_CSS=${TMP_INSTALL_FOLDER}/${css_storage_filename}

# check config & perform installation
check_install_config
if [[ "$?" != "0" ]]; then
    printf "config ok: no\n"
    return 1
else
    printf "config ok: yes\n"
fi

check_satisfies_requirements
if [[ "$?" != "0" ]]; then
    printf "requirements satisfied: no\n"
    return 1
else
    printf "requirements satisfied: yes\n"
fi

try_make_tmp_install_folder
if [[ "$?" != "0" ]]; then
    printf "could make tmp install folder: no\n"
    return 1
else
    printf "could make tmp install folder: yes\n"
fi

try_create_install_folders
if [[ "$?" != "0" ]]; then
    printf "folder created: no\n"
    return 1
else
    printf "folder ok: yes\n"
fi



try_download_css
if [[ "$?" != "0" ]]; then
    printf "found .css: no\n"
    return 1
else
    printf "found .css: yes\n"
fi


make_executables
if [[ "$?" != "0" ]]; then
    printf "executables created: no\n"
    return 1
else
    printf "executables created: yes\n"
fi

finish_installation
if [[ "$?" != "0" ]]; then
    printf "installed executables: no\n"
    return 1
else
    printf "installed executables: yes\n"
fi

printf "cleaning up and exiting...\n"
cleanup
printf "\nsuccess: panpdf and panhtml installed in ${storage_location} and symlinks added to /usr/local/bin/\n"