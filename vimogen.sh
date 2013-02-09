#!/bin/bash
# vimogen.sh by Ryan Kulla <rkulla@gmail.com>
# An opinionated shell script that believes you should install
# your Vim plugins via Pathogen bundles/git repos and automates
# installing and updated your bundles.

usage() {
    printf "Usage:\n"
    printf "vimogen [install|update]\n\n" 
    exit
}

# TODO:
# install command should allow installing newly added repos without redoing existing ones
install() {
    printf "Installing...\n"
    exit 0
}

update() {
    printf "Updating...\n"
    exit 0
}

if (( $# > 0 )); then
    usage
fi

PS3="Select a menu option to perform: "
select option in Install Update Exit
do
    case "$option" in
        Install) 
            install
            ;;
        Update) 
            update
            ;;
        Exit) 
            exit 0
            ;;
        *) 
            echo  "Invalid selection"
            ;;
    esac
done
