#!/bin/bash
set -Eeuo pipefail

install_oh_my_zsh() {
    readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

	while true; do
        read -p "Do you want to install oh-my-zsh? (y/n) " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) return 0;;
            * ) echo "Please answer yes or no.";;
        esac
    done

    if [[ "$(uname -s)" == "Linux" ]]; then
        if ! command -v "zsh" >/dev/null 2>&1; then
            echo "Zsh is not installed."
        
            case "$(lsb_release -si)" in
                Ubuntu*) sudo apt install zsh;;
                Fedora*) sudo dnf install zsh;;
                *) echo "Unsupported distro. Install Zsh manually."; return 1;;
            esac
        fi
    fi

    if [[ -d "${ZSH:-$HOME/.oh-my-zsh}" ]]; then
        echo "oh-my-zsh is already installed."
    else
        echo "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    local plugins=(
        "zsh-completions https://github.com/zsh-users/zsh-completions"
        "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
        "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "evalcache https://github.com/mroth/evalcache"
    )

    for plugin in "${plugins[@]}"; do
        local name="${plugin%% *}"
        local url="${plugin##* }"
        local plugin_dir="${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/$name"
        
        if [[ -d "$plugin_dir" ]]; then
            echo "$name is already installed."
        else
            echo "Installing $name"
            git clone "$url" "$plugin_dir"
        fi
    done
}

install_oh_my_zsh
