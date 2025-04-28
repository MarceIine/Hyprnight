#!/usr/bin/env bash

LINUX_CONFIGS_DIR="$(dirname "$(realpath "$0")")"
LINUX_DOTFILES_DIR="$LINUX_CONFIGS_DIR/dotfiles"

WALLPAPERS_DIR="$LINUX_CONFIGS_DIR/Wallpapers"

display_help() {
    echo "Usage: [-s | -u] [-h]"
    echo "  -s   Stow dotfiles"
    echo "  -u   Unstow dotfiles"
    echo "  -h   Display this help message"
}

log() {
    local timestamp=$(date +"%T")
    local message="======> $1 : $timestamp"

    echo -e "\n$message\n"
}

create_link() {
    local source=$1
    local target=$2

    if [ ! -e "$source" ]; then
        echo "Source does not exist: $source"
        return 1
    fi

    if [ ! -d "$(dirname "$target")" ]; then
        mkdir -p "$(dirname "$target")"
    fi

    if [ -e "$target" ]; then
        rm -rf "$target"
    fi

    ln -sfn "$source" "$target"
    echo "$source ===> $target"
}

create_links() {
    local source_dir=$1
    local target_dir=$2

    if [ ! -d $source_dir ]; then
        echo "Source directory does not exist."
        return 1
    fi

    if [ ! -d $target_dir ]; then
        mkdir -p $target_dir
    fi

    for item in "$source_dir"/* "$source_dir"/.*; do
        if [ -e "$item" ] && [ "$item" != "$source_dir/." ] && [ "$item" != "$source_dir/.." ]; then
            echo "$item ===> $target_dir"

            ln -sfn "$item" "$target_dir/"
        fi
    done
}

delete_links() {
    local source_dir=$1
    local target_dir=$2

    if [ ! -d $source_dir ] || [ ! -d $target_dir ]; then
        echo "Source or target directory does not exist."
        return 1
    fi

    for config in "$source_dir"/* "$source_dir"/.*; do
        config_name=$(basename $config)
        target_config="$target_dir/$config_name"

        if [ -e "$target_config" ]; then
            rm -rf $target_config
            echo "Removed: $target_config"
        else
            echo "Not found: $target_config"
        fi
    done
}

create_target_dir() {
    mkdir -p ~/.config
    mkdir -p ~/Wallpapers
    mkdir -p ~/Screenshots
}

stow() {
    create_target_dir

    # Stow Alacritty configuration
    create_links "$LINUX_DOTFILES_DIR" "$HOME/.config"
    log "Dotfiles stowed successfully!"

    create_links "$WALLPAPERS_DIR" "$HOME/Wallpapers/"
    log "Sucessfully linked Wallpapers!"
    #ln -s ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors-waybar.css
}

unstow() {
    # Unstow Alacritty configuration
    delete_links "$LINUX_DOTFILES_DIR" "$HOME/.config"
    log "Dotfiles configs unstowed successfully!"

    delete_links "$WALLPAPERS_DIR" "$HOME/Wallpapers"
    log "Wallpapers unstowed successfully!"

    log "All configs unstowed successfully !"
}

config() {
    log "Configurating System !"
    sed -i '1s|.*|@import "'"$HOME/.cache/wal/colors-waybar.css"'";|' "$LINUX_DOTFILES_DIR/waybar/style.css"
    mv $WALLPAPERS_DIR/.face $HOME
    mv $HOME/.config{,.bak}
}

while getopts "ush" opt; do
    case $opt in
    s)
        # Calling the  clear command to clear the terminal output.
        clear
        config
        stow
        ;;
    u)
        unstow
        ;;
    h)
        display_help
        exit 0
        ;;
    esac
done

if [[ $# -eq 0 ]]; then
    display_help
fi
