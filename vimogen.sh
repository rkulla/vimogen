#!/bin/bash
# vimogen.sh by Ryan Kulla <rkulla@gmail.com>

install_dir="$HOME/.vim/bundle"
manifest_file="$HOME/.vimogen_repos"

usage() {
    printf "Usage:\n"
    printf "vimogen [install|update]\n\n" 
    exit
}

validate_environment() {
    if [[ ! -d "$install_dir" ]]; then
        printf "$install_dir doesn't exist. Please create it first.\n"
        exit 0
    fi

    if [[ ! -f "$manifest_file" ]]; then
        printf "$manifest_file doesn't exist. Please create it first.\n"
        exit 0
    fi
}

install() {
    printf "Installing...\n"
    pushd . > /dev/null
    local install_count=0

    cd "$install_dir"

    while read -r line; do
        local basename=${line##*/}
        local clone_dir="${basename%.*}"
        if [[ ! -d "$install_dir/$clone_dir" ]]; then
            git clone "$line"
            install_count=$(( install_count+1 ))
        fi
    done < "$manifest_file"

    popd > /dev/null

    if [[ $install_count -eq 0 ]]; then
        printf "Nothing new to install\n"
    else
        printf "Installed $install_count plugins\n"
    fi
    
    exit 0
}

update() {
    printf "Updating...\n"
    exit 0
}

get_menu_opt() {
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
}

if (( $# > 0 )); then
    usage
else
    validate_environment
    get_menu_opt
fi
