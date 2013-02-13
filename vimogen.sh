#!/bin/bash
# vimogen.sh by Ryan Kulla <rkulla@gmail.com>
# version 1.3
# License: Vim License. See :help license

install_dir="$HOME/.vim/bundle"
manifest_file="$HOME/.vimogen_repos"

usage() {
    printf "Usage:\n"
    printf "vimogen\n\n" 
    exit
}

generate_manifest() {
    pushd . > /dev/null

    cd "$install_dir"
    for i in $(ls); do 
        pushd . > /dev/null
        cd "$i" 
        local url=$(git remote -v | perl -ne 'print $1 if /^origin\s(.*)\s\(fetch\)/')
        echo "$url" >> "$manifest_file"
        popd > /dev/null
    done

    popd > /dev/null
}

validate_environment() {
    if [[ ! -d "$install_dir" ]]; then
        printf "$install_dir doesn't exist. Please create it first.\n"
        exit 0
    fi

    if [[ ! -f "$manifest_file" ]]; then
        printf "$manifest_file doesn't exist. Generating...\n"
        generate_manifest
    fi
}

install() {
    printf "Installing...\n"
    pushd . > /dev/null
    local install_count=0

    cd "$install_dir"

    while read -r line; do
        local basename=${line##*/}
        local clone_dir="${basename%.*}" # take out the .git
        if [[ "$clone_dir" = *.vim ]]; then
            clone_dir="${clone_dir%.vim}"
        fi
        if [[ ! -d "$install_dir/$clone_dir" ]]; then
            git clone "$line" "$clone_dir"
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

uninstall() {
    pushd . > /dev/null
    local plugins=()

    while read -r line; do
        local basename=${line##*/}
        local clone_dir="${basename%.*}"
        if [[ "$clone_dir" = *.vim ]]; then
            clone_dir="${clone_dir%.vim}"
        fi
        if [[ -d "$install_dir/$clone_dir" ]]; then
            plugins+=( "$clone_dir" )
        fi
    done < "$manifest_file"

    local sorted_plugins=($(printf '%s\n' "${plugins[@]}"|sort -f))

    PS3="Enter the number of the plugin you wish to uninstall: "
    select option in "EXIT" "${sorted_plugins[@]}"
    do
        case "$option" in
            EXIT) 
                if [[ "$option" -eq "EXIT" ]]; then
                    printf "exiting\n"
                    exit 0
                fi
                ;;
            *)
                if [[ ! -z "$option" ]]; then
                    local path_to_rm="$install_dir/$option"
                    read -n 1 -p "rm $path_to_rm: y/n? " prompt_rm
                    if [[ "$prompt_rm" = 'y' ]]; then
                        printf "\nUninstalling [$option]\n"
                        rm -rf "$path_to_rm"
                    fi
                    echo
                    uninstall
                else
                    printf "Invalid selection\n"
                fi
                ;;
        esac
    done

    exit 0
}

update() {
    printf "Updating...\n"
    pushd . > /dev/null

    cd "$install_dir"
    for i in $(ls); do 
        pushd . > /dev/null
        cd "$i" 
        git pull --verbose
        popd > /dev/null
    done

    popd > /dev/null

    exit 0
}

get_menu_opt() {
    PS3="Enter the number of the menu option to perform: "
    select option in Install Uninstall Update Exit
    do
        case "$option" in
            Install) 
                install
                ;;
            Uninstall) 
                uninstall
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
