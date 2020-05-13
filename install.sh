#!/bin/bash

set -euxo pipefail

INSTALLDIR=$HOME
INSTALLCMD=""
PWD=$(pwd)

# install_github_bundle <user> <repo>
install_github_bundle() {
    echo "Installing bundle github.com/${1}${2}..."

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
    source /etc/os-release

    local cmd=""
    case "${NAME}" in
        "Fedora")
            echo "RedHat distros not currently supported."
            exit 1
            # if [ ! -z "$(which dnf)" ]; then
            #     cmd="dnf -y -q install"
            # else
            #     cmd="yum -y -q install"
            # fi
            ;;
        "Ubuntu")
            cmd="apt-get -y -q install"
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
)

# These are Debian-specific namings
PACKAGES=(
    "build-essential" \
    "ctags" \
    "curl" \
    "git" \
    "golang-1.14" \
    "net-tools" \
    "silversearcher-ag" \
    "tmux" \
    "vim" \
    "zeal" \
)

set_distro_install_cmd
echo "# Installing system packages"
for package in ${PACKAGES[@]]}; do
    install_system_packages "${package}" 2>/dev/null
done

echo "# Copying local override files"
for copy_file in "${!COPIED_FILES[@]}"; do
    target=${COPIED_FILES["${copy_file}"]}
    if [ ! -e "${target}" ]; then
        -y echo -e "\t${copy_file} => ${target}"
        cp "${copy_file}" "${target}" 2>/dev/null
    fi
done
-y 
echo "# Linking global config files"
for file in "${!LINKED_FILES[@]}"; do
    target=${LINKED_FILES["${file}"]}
    echo -e "\t${file} => ${target}"
    if [ -f "${target}" ]; then
        rm "${target}"
    fi
    ln -s "${PWD}/${file}" "${target}" 2>/dev/null
done

# TODO: Use gimme, etc instead of doing this.
echo "export PATH=$PATH:/usr/lib/go-1.14/bin:$HOME/go/bin" >> $HOME/.profile

echo "# Configuring Vim"
install_github_bundle "gmarik" "Vundle.vim"
vim +PluginInstall +qall
vim +GoInstallBinaries +qall
go get -u https://github.com/jstemmer/gotags

echo "# Installing Rust"
./scripts/rustup.sh -q -y --default-toolchain stable --profile complete
