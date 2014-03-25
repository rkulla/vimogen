#!/bin/bash
# vimogen.sh by Ryan Kulla <rkulla@gmail.com>
# version 1.4
# License: Vim License. See :help license

install_dir="$HOME/.vim/bundle"
manifest_file="$HOME/.vimogen_repos"
bold=$(tput bold)
normal=$(tput sgr0)
arg1="$1"

usage() {
    printf "Usage:\n"
    printf "vimogen [-v]\n\n" 
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
        printf "%s doesn't exist. Please create it first.\n" "$install_dir"
        exit 0
    fi

    if [[ ! -f "$manifest_file" ]]; then
        printf "%s doesn't exist. Trying to generate from any existing bundles...\n" "$manifest_file"
        generate_manifest
    fi
    
    if [[ ! -f "$manifest_file" ]]; then
        printf "[failed].\nPlease create $manifest_file.\n"
        exit 0
    fi
}

install() {
    printf "${bold}Installing plugins into $install_dir/...${normal}\n"
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
        printf "Nothing new to install\n"
    else
        printf "Installed $install_count plugins\n"
    fi
}

uninstall() {
    pushd . > /dev/null
    local plugins=()
    cd "$install_dir"

    for clone_dir in $(ls); do 
        if [[ -d "$install_dir/$clone_dir" ]]; then
            plugins+=( "$clone_dir" )
        fi
    done

    local sorted_plugins=($(printf '%s\n' "${plugins[@]}"|sort -f))

    PS3="${bold}Enter the number of the plugin you wish to uninstall:${normal} "
    select option in "CANCEL" "ALL" "${sorted_plugins[@]}"
    do
        case "$option" in
            CANCEL) 
                if [[ "$option" -eq "CANCEL" ]]; then
                    printf "cancelling\n"
                    return 0
                fi
                ;;
            ALL)
                read -n 1 -p "${bold}Delete all files from $install_dir/*: y/n?${normal} " prompt_rm
                if [[ "$prompt_rm" = 'y' ]]; then
                    printf "\nUninstalling all plugins...\n"
                    rm -rf "$install_dir/"*
                    printf "Done\n"
                fi
                echo
                return 0
                ;;
            *)
                if [[ ! -z "$option" ]]; then
                    local path_to_rm="$install_dir/$option"
                    printf "\nUninstalling [$option]\n"
                    rm -rf "$path_to_rm"
                    echo
                    uninstall
                    break
                else
                    printf "Invalid selection\n"
                fi
                ;;
        esac
    done

    popd > /dev/null
}

update() {
    printf "${bold}Updating...${normal}\n"
    pushd . > /dev/null
    cd "$install_dir"

    for i in $(ls); do 
        pushd . > /dev/null
        cd "$i" 
        if [[ $arg1 = "-v" ]]; then
            local pull=$(git pull --verbose)
        else
            local pull=$(git pull --verbose 2>&1 | awk 'NR==1;END{print}')
        fi
        printf "%s\n" "$pull"

        if [[ $pull = *vimogen* && $pull != *"Already up-to-date"* ]]; then
            printf "${bold}Vimogen was updated! You should cp the updated script to your PATH${normal}\n"
        fi

        if [[ $pull = *pathogen* && $pull != *"Already up-to-date"* ]]; then
            printf "${bold}Pathogen was updated! You should cp ~/.vim/bundle/vim-pathogen/bundle/pathogen.vim to ~/.vim/autoload/${normal}\n"
        fi

        echo -e
        popd > /dev/null
    done

    popd > /dev/null
}

get_menu_opt() {
    clear
    PS3="${bold}Enter the number of the menu option to perform:${normal} "

    select option in INSTALL UNINSTALL UPDATE EXIT
    do
        case "$option" in
            INSTALL) 
                install
                ;;
            UNINSTALL) 
                uninstall
                PS3="${bold}Enter the number of the menu option to perform:${normal} "
                ;;
            UPDATE) 
                update
                ;;
            EXIT) 
                exit 0
                ;;
            *) 
                PS3="${bold}Enter the number of the menu option to perform:${normal} "
                echo  "Invalid selection"
                ;;
        esac
    done
}

if (( $# > 1 )); then
    usage
else
    validate_environment
    get_menu_opt
fi
