#!/bin/bash
# vimogen.sh by Ryan Kulla <rkulla@gmail.com>
# version 1.4.2
# License: Vim License. See :help license

# If any command fails, abort the script
set -e

install_dir="$HOME/.vim/bundle"
manifest_file="$HOME/.vimogen_repos"
bold=$(tput bold)
normal=$(tput sgr0)
arg1="$1"
MSG=''

usage() {
    printf "Usage:\n"
    printf "vimogen [-v]\n\n" 
    exit
}

pause() {
   read -n 1 -p "Press any key to continue"
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
        printf "%s doesn't exist. Please create it first.\n" "$install_dir"
        exit 0
    fi

    if [[ ! -f "$manifest_file" ]]; then
        printf "%s doesn't exist. Trying to generate from any existing bundles...\n" "$manifest_file"
        generate_manifest
        pause
    fi
    
    if [[ ! -f "$manifest_file" ]]; then
        printf "[failed].\nPlease create $manifest_file.\n"
        exit 0
    fi
}

install() {
    printf "${bold}Installing plugins into $install_dir/${normal}\n"
    pushd . > /dev/null
    local install_count=0

    cd "$install_dir"

    while read -r line; do
        local basename=${line##*/}
        local clone_dir="${basename%.*}" # take out the .git
        if [[ "$clone_dir" = *.vim ]]; then
            clone_dir="${clone_dir%.vim}" # take out the .vim
        fi
        if [[ ! -d "$install_dir/$clone_dir" ]]; then
            local gitclone=$(git clone "$line" "$clone_dir" 2>&1 | awk 'NR==2;END{print}')
            install_count=$(( install_count+1 ))
            printf "%s\n" "$gitclone"
        fi
    done < "$manifest_file"

    popd > /dev/null

    if [[ $install_count -eq 0 ]]; then
        MSG="Nothing new to install\n"
    else
        MSG="Installed $install_count plugins\n"
    fi

    pause
}

uninstall() {
    pushd . > /dev/null
    cd "$install_dir"

    PS3="Enter the number of the plugin you wish to uninstall: "
    while :
    do
        local plugins=()
        for clone_dir in $(ls); do 
            if [[ -d "$install_dir/$clone_dir" ]]; then
                plugins+=( "$clone_dir" )
            fi
        done

        local sorted_plugins=($(printf '%s\n' "${plugins[@]}"|sort -f))
        clear
        printf "\n${bold}%b${normal}\n" "$MSG"

        local plugin_count="${#sorted_plugins[*]}"
        if (( $plugin_count == 0 )); then
            MSG="No plugins are currently installed\n"
            break
        fi

        select option in "CANCEL" "ALL" "${sorted_plugins[@]}"
        do
            MSG=''
            case "$option" in
                CANCEL) 
                    if [[ "$option" -eq "CANCEL" ]]; then
                        return 0
                    fi
                    break
                    ;;
                ALL)
                    read -n 1 -p "Delete all files from $install_dir/*: y/n? " prompt_rm
                    if [[ "$prompt_rm" = 'y' ]]; then
                        printf "\nUninstalling all plugins...\n"
                        rm -rf "$install_dir/"*
                        printf "Done\n"
                        pause
                    fi
                    echo
                    break
                    ;;
                *)
                    if [[ ! -z "$option" ]]; then
                        local path_to_rm="$install_dir/$option"
                        printf "Uninstalling $option"
                        MSG="Uninstalled $option"
                        rm -rf "$path_to_rm"
                        echo
                    else
                        MSG="Invalid selection"
                    fi
                    break
                    ;;
            esac
        done
    done

    popd > /dev/null
}

update() {
    printf "Updating...\n"
    pushd . > /dev/null
    cd "$install_dir"
    local updated=0

    for i in $(ls); do 
        pushd . > /dev/null
        cd "$i" 
        if [[ $arg1 = "-v" ]]; then
            local pull=$(git pull --verbose)
        else
            local pull=$(git pull --verbose 2>&1 | awk 'NR==1;END{print}')
        fi

        if [[ $pull != *"Already up-to-date"* ]]; then
            updated=1
            printf "%s\n\n" "$pull"
        fi

        if [[ $pull = *vimogen* && $pull != *"Already up-to-date"* ]]; then
            MSG+="\nVimogen was updated! You should copy the new script to your PATH"
        fi

        if [[ $pull = *pathogen* && $pull != *"Already up-to-date"* ]]; then
            MSG+="\nPathogen was updated. You should copy the new ~/.vim/bundle/vim-pathogen/bundle/pathogen.vim to ~/.vim/autoload/"
        fi

        popd > /dev/null
    done

    if (( $updated == 0 )); then
        MSG+="No plugins had updates at this time.\n"
    fi

    popd > /dev/null

    if test "$i"; then
        pause
    else
        MSG="No plugins are currently installed\n"
    fi
}

get_menu_opt() {
    while :
    clear
    PS3="Enter the number of the menu option to perform: "
    printf "\n${bold}%b${normal}\n" "$MSG"
    do
        select option in INSTALL UNINSTALL UPDATE EXIT
        do
            MSG=''
            case "$option" in
                INSTALL) 
                    install
                    break
                    ;;
                UNINSTALL) 
                    uninstall
                    break
                    ;;
                UPDATE) 
                    update
                    break
                    ;;
                EXIT) 
                    exit 0
                    break
                    ;;
                *) 
                    MSG="Invalid selection"
                    break
                    ;;
            esac
        done
    done
}

if (( $# > 1 )); then
    usage
else
    validate_environment
    get_menu_opt
fi
