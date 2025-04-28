#!/usr/bin/env bash

# Configuration
PACKAGE_FILE="packages.txt"

# ---- Error handling ----
set -eo pipefail

# ---- Functions ----
# install_lazy_vim() {
#     if [ -d "$HOME/.config/nvim" ]; then
#         echo "Lazyvim is already installed"
#         return 0
#     fi
#     git clone https://github.com/MarceIine/lazy-ah.git $HOME/.config/nvim
# }

install_roll() {
    ENV_DIR=dotfiles/scripts/.env

    if [[ -e "$ENV_DIR/bin/roll" ]]; then
        echo "roll is already installed."
        return 0
    fi

    # Create the Python environment
    python3 -m venv "$ENV_DIR"

    # Get the latest .whl file name and download it
    WHL_URL=$(curl -s https://api.github.com/repos/MarceIine/roll/releases/latest | jq -r '.assets[].browser_download_url' | grep '\.whl$')
    curl -s -L -O "$WHL_URL"

    # Extract the correct filename
    WHL_FILE=$(basename "$WHL_URL")

    # Move it to the correct directory
    mv "$WHL_FILE" "$ENV_DIR/"

    # Install the program with its proper filename
    "$ENV_DIR/bin/pip" install "$ENV_DIR/$WHL_FILE"
}

install_oh_my_zsh() {
    clear
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "oh-my-zsh is already installed."
        return 0
    fi

    # After installing oh-my-zsh it itself will ask the user whether they want to set their default shell to zsh.
    echo "Installing oh-my-zsh !"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
    echo "Finished installing oh-my-zsh"

    clear

    echo "installing zsh-syntax-highlighting.git"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    echo "Finished installing zsh-syntax-highlighting.git"

    echo "installing zsh-autosuggestions.git"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    echo "Finished installing zsh-autosuggestions"

    echo "Stowing zsh dotfiles."
    rm $HOME/.zshrc
    cd ./zsh && stow . -t ~
    echo "Sucessfully finished!!!"

    pkill -u $USER -KILL
}
install_yay() {
    if ! command -v yay >/dev/null 2>&1; then
        echo "Installing yay..."
        temp_dir=$(mktemp -d)
        trap 'rm -rf "$temp_dir"' EXIT

        sudo pacman -S --needed --noconfirm git base-devel || return 1
        git clone https://aur.archlinux.org/yay-bin.git "$temp_dir" || return 1
        (cd "$temp_dir" && makepkg -si --noconfirm) || return 1
    else
        echo "yay is already installed"
    fi
}

# ---- Main script ----
main() {
    # Verify package file exists
    if [[ ! -f "$PACKAGE_FILE" ]]; then
        echo "Error: Package file '$PACKAGE_FILE' not found!"
        exit 1
    fi

    # Read packages with error checking
    echo "Reading packages from $PACKAGE_FILE..."
    mapfile -t packages < <(
        grep -Ev '^\s*#|^\s*$' "$PACKAGE_FILE" |                             # Remove comments and empty lines
            sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | # Trim all whitespace
            awk 'NF'                                                         # Remove any empty lines that might remain
    )

    if [[ ${#packages[@]} -eq 0 ]]; then
        echo "Error: No valid packages found in $PACKAGE_FILE"
        exit 1
    fi

    # Debug output to verify package list
    echo "Packages to be installed (verify no extra spaces):"
    printf '[%s]\n' "${packages[@]}"

    # Confirm before installation
    read -rp "Proceed with installation? [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]] || exit 0

    # Install process
    install_yay || exit 1
    echo "Starting installation..."

    # Install all packages in one command
    yay -Syu --needed --noconfirm --repo "${packages[@]}"
    install_roll
    #install_lazy_vim
    install_oh_my_zsh
}

main "$@"
