#!/bin/bash

set -euxo pipefail

INSTALLDIR=$HOME
INSTALLCMD="dnf -y install"
PWD=$(pwd)

TERMINAL=""
case "$1" in
    "xfce") TERMINAL="xfce";;
    "gnome") TERMINAL="gnome";;
    *) echo "usage: install.sh [xfce|gnome]"; exit;;
esac

source /etc/os-release

# install_github_bundle <user> <repo>
install_github_bundle() {
    echo "Installing bundle github.com/${1}/${2}..."

    local git_url="https://github.com/${1}/${2}.git"
    local bundle_dir="${INSTALLDIR}/.vim/bundle/${2}"

    if [ -d "${bundle_dir}" ]; then
        echo -e "\tdirectory already exists, skipping ${2}"
        return
    fi

    git clone ${git_url} ${bundle_dir}
}

install_system_package() {
    echo -e "\tInstalling ${1}..."
        sudo bash -c "${INSTALLCMD} ${1}"
}

set_distro_install_cmd() {
    local cmd=""
    case "${NAME}" in
        "Fedora")
            if [ ! -z "$(which dnf)" ]; then
                cmd="dnf -y -q install"
            else
                cmd="yum -y -q install"
            fi
            ;;
        "Ubuntu")
            cmd="aptitude -y -q install"
            ;;
        "Debian GNU/Linux")
            cmd="apt-get install -y -q"
            ;;
    esac

    [[ ! -z "${cmd}" ]] && INSTALLCMD=${cmd}
}

declare -A COPIED_FILES
declare -A LINKED_FILES
declare -a PACKAGES

COPIED_FILES=(
    ["vimrc.local"]="${INSTALLDIR}/.vimrc.local" \
    ["vimrc.bundles.local"]="${INSTALLDIR}/.vimrc.bundles.local" \
    ["tmux.conf.local"]="${INSTALLDIR}/.tmux.conf.local" \
    ["bashrc.local"]="${INSTALLDIR}/.bashrc.local" \
)

LINKED_FILES=(
    ["vim"]="${INSTALLDIR}/.vim" \
    ["tmux.conf"]="${INSTALLDIR}/.tmux.conf" \
    ["vimrc"]="${INSTALLDIR}/.vimrc" \
    ["vimrc.bundles"]="${INSTALLDIR}/.vimrc.bundles" \
    ["gitconfig"]="${INSTALLDIR}/.gitconfig" \
    ["bashrc"]="${INSTALLDIR}/.bashrc" \
)

PACKAGES=(
    "git" \
    "vim" \
    "tmux" \
    "the_silver_searcher" \
    "ctags" \
    "golang" \
    "gotags" \
    "python-pip" \
    "gnupg2" \
    "opensc" \
)

echo "# Beginning dotfiles installation"

echo "# Installing packages"
set_distro_install_cmd
for package in ${PACKAGES[@]}; do
    install_system_package "${package}" 2>/dev/null
done

echo "# Installing solarized colorscheme for your terminal"
if [ ! -e "/usr/bin/dconf" ]; then
    case "${DISTRO}" in
        "Fedora")
            install_system_package "dconf"
            ;;
        "Ubuntu")
            install_system_package "dconf-cli"
            ;;
        "Debian GNU/Linux")
            install_system_package "dconf-cli"
            ;;
    esac
fi

if [ $TERMINAL == "xfce" ]; then
    echo "# Installing solarized-dark for xfce"
    git clone "https://github.com/gtank/xfce4-terminal-colors-solarized.git" || true

    if [[ -d xfce4-terminal-colors-solarized ]]; then
        mkdir -p ~/.config/Terminal
        if [ ! -e "~/.config/Terminal/terminalrc.bak" ]; then
            cp ~/.config/Terminal/terminalrc ~/.config/Terminal/terminalrc.bak
        fi
        cp dark/terminalrc ~/.config/xfce4/terminal/terminalrc
    else
        echo "Failed to install xfce4 solarized!"
    fi
fi

if [ $TERMINAL == "gnome" ]; then
    echo "# Installing solarized for GNOME"
    git clone "https://github.com/gtank/gnome-terminal-colors-solarized.git" || true
    if [[ -d gnome-terminal-colors-solarized ]]; then
        ./gnome-terminal-colors-solarized/install.sh
    else
        echo "Failed to install GNOME solarized!"
    fi
fi

echo "# Copying local override files"
for copy_file in "${!COPIED_FILES[@]}"; do
    target=${COPIED_FILES["${copy_file}"]}
    if [ ! -e "${target}" ]; then
        echo -e "\t${copy_file} => ${target}"
        cp "${copy_file}" "${target}" 2>/dev/null
    fi
done

echo "# Linking global config files"
for file in "${!LINKED_FILES[@]}"; do
    target=${LINKED_FILES["${file}"]}
    echo -e "\t${file} => ${target}"
    if [ -f "${target}" ]; then
        rm "${target}"
    fi
    ln -s "${PWD}/${file}" "${target}" 2>/dev/null
done

echo "# Installing vundle"
install_github_bundle "gmarik" "Vundle.vim"
vim +PluginInstall +qall

echo "# Installing vim-go tools"
vim +GoInstallBinaries +qall
