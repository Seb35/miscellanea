#!/bin/bash

# Ce script calcule des statistiques d’utilisation des listes de
# discussion Sympa et en crée un texte en syntaxe wiki.
# This script computes statistics of use of Sympa mailing lists and
# creates a text written in wikisyntax.
# 
# Auteur/Author   : Seb35
# Licence/License : WTFPL 2.0
# 
# Ce programme est libre. Vous pouvez le redistribuer et/ou le modifier
# selon les termes de la Do What The Fuck You Want To Public License,
# Version 2, publiée par Sam Hocevar. Voir le fichier LICENSE pour plus
# de détails.
# 
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the LICENSE file for more details.
# 
# Utilisation/Use:
#   
#   $ create_sympa_stats.sh 2013 11
#   
#   (2013 11 = Année Mois = Year Month)
#   (Les variables dans le script doivent être adaptées.)
#   (The variables in the script must be adapted.)
# 
# À faire/Todo:
# - retirer les variables internes et rendre le script autonome
# - pouvoir personnaliser la syntaxe de sortie
# - avoir un fichier de config optionnel pour la syntaxe + variables
# - traitement des listes absentes avant une certaine date
# - traitement des listes fermées
# - traiter les plages temporelles au lieu d’un seul mois
#  

LISTES="liste1 liste2 liste3"

REPERTOIRE="/home/sympa/arc/"
DOMAINE="listserver.example.org"
ANNEE="$1"
MOISNR="$(printf %02d $2)"

case "$MOISNR" in
"01")
    MOIS=Janvier
    ;;
"02")
    MOIS=Février
    ;;
"03")
    MOIS=Mars
    ;;
"04")
    MOIS=Avril
    ;;
"05")
    MOIS=Mai
    ;;
"06")
    MOIS=Juin
    ;;
"07")
    MOIS=Juillet
    ;;
"08")
    MOIS=Août
    ;;
"09")
    MOIS=Septembre
    ;;
"10")
    MOIS=Octobre
    ;;
"11")
    MOIS=Novembre
    ;;
"12")
    MOIS=Décembre
    ;;
esac

CHAINE="{{Listes de discussion|mois=$MOIS|nblistes="

TRAITES=""
for LISTE in $LISTES ; do
    if [ -d "$REPERTOIRE$LISTE@$DOMAINE/$ANNEE-$MOISNR" ] ; then
        NB=$(ls -1 $REPERTOIRE$LISTE\@$DOMAINE/$ANNEE-$MOISNR/msg*.html | wc -l)
    else
        NB=0
    fi
    CHAINE="$CHAINE|$LISTE=$NB"
    TRAITES="$TRAITES $LISTE"
done
TRAITES="$TRAITES "

NOUVEAUX=""
for LISTEDOMAINE in $(ls -1 $REPERTOIRE) ; do
    LISTE=${LISTEDOMAINE:0:$(expr $(expr index "$LISTEDOMAINE" @) - 1)}
    if [[ "$TRAITES" != *" $LISTE "* ]] ; then
        if [ -d "$REPERTOIRE$LISTE@$DOMAINE/$ANNEE-$MOISNR" ] ; then
            NB=$(ls -1 $REPERTOIRE$LISTE\@$DOMAINE/$ANNEE-$MOISNR/msg*.html | wc -l)
        else
            NB=0
        fi
        CHAINE="$CHAINE|$LISTE=$NB"
        NOUVEAUX="$NOUVEAUX $LISTE"
    fi
done
CHAINE="$CHAINE}}"

echo $CHAINE

if [ "$NOUVEAUX" != "" ] ; then
    echo "Listes manquantes dans la liste : ${NOUVEAUX:1}" >&2
fi
