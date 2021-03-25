#!/usr/bin/env bash

# Finding the directory we're in
declare DIR
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

configure_zsh() {
    local -a progrs=("${@}")
    for prog in "${progrs[@]}"; do
      if ! [[ -x "$(command -v "${prog}")" ]]; then
        sudo dnf install "${prog}" -y
      else
        printf "%s installed.\n" "${prog}"
      fi
    done
    cp "${DIR}/.zshrc" ~/.zshrc
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    wget -O /home/fluit/.zshrc "https://raw.githubusercontent.com/stefanfluit/default_files/master/oh_my_zsh/.zshrc-pnd"
    chsh -s $(which zsh) fluit
}

configure_p10k() {
    local -a fonts=(
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
    )
    for font in "${fonts[@]}"; do
        wget -P /home/$(whoami)/.fonts "${font}"
    done
    /usr/bin/fc-cache
    git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    cp "${DIR}/.p10k.zsh" ~/.p10k.zsh
}

configure_tilix() {
    local -a progrs=("${@}")
    for prog in "${progrs[@]}"; do
      if ! [[ -x "$(command -v "${prog}")" ]]; then
        sudo dnf install "${prog}" -y
      else
        printf "%s installed.\n" "${prog}"
      fi
    done
    dconf load /com/gexperts/Tilix/ < "${DIR}/tilix.dconf"
}

main () {
    configure_tilix "tilix" && \
    configure_zsh "zsh" && \
    configure_p10k
}

main
