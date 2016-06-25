#!/bin/bash


# TODO dd.mkv ->  ./dd.mkv -> ./house.7./dd.mkv.mkv => error

# -----------------------------------------------------------------
# Variables priv�es
# -----------------------------------------------------------------
simu=1
cpt=0


# -----------------------------------------------------------------
# Variables de travail
# -----------------------------------------------------------------
# nom de la s�rie
serie=""
# num�ro de saison de la s�rie
season=""


# -----------------------------------------------------------------
# Fonctions
# -----------------------------------------------------------------

#
# recherche le nom de la s�rie et le num�ro
# de la saison depuis le chemin courant d'execution
function findInfosInPath
{
    echo "recherche auto des infos depuis : `pwd`"
    oldIFS=$IFS
    IFS=/
    set `pwd`
    shift `expr $# - 2`
    serie=$1
    season=`echo $2 | sed 's/^.*\([0-9]\).*$/\1/'`
    IFS=$oldIFS
}

#
# v�rifie les informations trouv�es
function checkInfos
{
    error=0
    if [ -z "$serie" ]
    then
        echo "* Erreur : nom de la serie non trouve"
        error=1
    fi

    if [ -z $season ]
    then
        echo "* Erreur : numero de la saison non trouve"
        error=1
    fi

    if [ $error -eq 1 ]
    then
        exit
    fi
}

#
# renomme une liste de fichiers pass�s en param�tre
function rename
{
    cptLocal=0
    for i in $@
    do
        ext=${i##*.}
        num=`echo $i | sed 's/720p//' | sed 's/1080p//' | sed 's/264//' | sed 's/^.*\([0-9][0-9]\).*$/\1/'`
        new="./$serie.$season$num.$ext"
        if [ "$new" != "$i" ]
        then
            if [ $simu -eq 1 ]
            then
                echo "- $i -> $new"
            else
                mv "$i" $new
            fi
            cpt=$[ $cpt + 1 ]
            cptLocal=$[ $cptLocal + 1]
        fi
    done
    if [ $cptLocal -eq 0 ] && [ $simu -eq 1 ]
    then
        echo "rien trouve ..."
    fi
}


#
# lance xbmc
function startXbmc
{
    echo ""
    echo -n "Demarrer xbmc (Y/n) : "
    read confirm

    if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ] || [ "$confirm" == "" ]
    then
	if [ -f ~/xbmc.sh ]
	then
	    ~/xbmc.sh
	else
	    xbmc
	fi
    else
	exit
    fi
}



# -----------------------------------------------------------------
# ex�cution
# -----------------------------------------------------------------

findInfosInPath
checkInfos

echo "* serie  : $serie"
echo "* saison : $season"
echo ""


IFS="
"

videoList=`find . -name "*avi" -o -name "*mkv" -o -name "*mp4" -type f -o -type l | sort`
subList=`find . -name "*srt" -o -name "*ass" | sort`

# Affichage des infos sans effectuer le renomage ($simu est � 1)
echo "* videos :"
rename $videoList

echo ""
echo "* sous titres :"
rename $subList


if [ $cpt -eq 0 ]
then
    echo ""
    echo "rien a faire, tout est deja a jour :=)"
    startXbmc
    exit
fi

echo ""
echo -n "Infos correctes (Y/n) : "
read confirm

if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ] || [ "$confirm" == "" ]
then
    echo "work in progress ..."
    simu=0
    rename $videoList
    rename $subList
    echo "done :)"
    startXbmc
else
    echo "cancel, too bad :("
fi
