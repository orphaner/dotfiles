#!/bin/bash

declare -a excluded=("LICENSE", "README.md", "${0}", ".git")

basedir=$( dirname $(readlink -f $0 ) )


function installFile() {
    dotFile=$1

    if [ -e $HOME/$dotFile ] && ! [ -h $HOME/$dotFile ]
    then
        echo "* mv $HOME/$dotFile $HOME/$dotFile.sav"
        mv $HOME/$dotFile $HOME/$dotFile.sav
    fi

    if ! [ -h $HOME/$dotFile ]
    then
        echo "* ln -s $basedir/$dotFile $HOME/$dotFile"
        ln -s $basedir/$dotFile $HOME/$dotFile
    fi
}

function installDotFiles() {
    IFS="
"

    for dotFile in $( ls -A1 )
    do
        if ! [[ "${excluded[@]}" =~ "${dotFile}" ]]
        then
            echo "Installing ${dotFile}"
            installFile $dotFile
        fi
    done
}

installDotFiles
