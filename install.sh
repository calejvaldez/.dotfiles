#!/usr/bin/env bash

# install.sh
# Carlos Valdez
# 
# This is my software installer for the Fedora Workstation OS.

sudo -v

# noting down info...
OS="$(uname -s)"
ARCHITECTURE="$(uname -m)"
DE="$XDG_CURRENT_DESKTOP"
echo "$OS operating system detected."
echo "$ARCHITECTURE architecture detected."
echo "$DE desktop environment detected."

function commonInstall() {
    sudo ln -sf "$PWD/.gitconfig" "$HOME/.gitconfig"

    # installing pip
    curl https://bootstrap.pypa.io/get-pip.py >> "get-pip.py"

    if [[ $OS == "Darwin" ]]; then
        python3 get-pip.py
    else
        python get-pip.py
    fi
    
    rm get-pip.py

    # vs code
    if command -v code &> /dev/null
    then
        code --force --install-extension  "DavidAnson.vscode-markdownlint"
        code --force --install-extension  "dsznajder.es7-react-js-snippets"
        code --force --install-extension  "eamodio.gitlens"
        code --force --install-extension  "figma.figma-vscode-extension"
        code --force --install-extension  "GrapeCity.gc-excelviewer"
        code --force --install-extension  "ms-dotnettools.vscode-dotnet-runtime"
        code --force --install-extension  "ms-python.python"
        code --force --install-extension  "ms-python.vscode-pylance"
        code --force --install-extension  "ms-toolsai.jupyter"
        code --force --install-extension  "ms-toolsai.jupyter-keymap"
        code --force --install-extension  "ms-toolsai.jupyter-renderers"
        code --force --install-extension  "ms-toolsai.vscode-jupyter-cell-tags"
        code --force --install-extension  "ms-toolsai.vscode-jupyter-slideshow"
        code --force --install-extension  "ms-vscode-remote.remote-ssh"
        code --force --install-extension  "ms-vscode-remote.remote-ssh-edit"
        code --force --install-extension  "ms-vscode-remote.remote-wsl"
        code --force --install-extension  "ms-vscode.remote-explorer"
        code --force --install-extension  "ms-vscode.vscode-github-issue-notebooks"
        code --force --install-extension  "ms-vsliveshare.vsliveshare"
        code --force --install-extension  "mtxr.sqltools"
        code --force --install-extension  "mtxr.sqltools-driver-sqlite"
        code --force --install-extension  "NilsSoderman.batch-runner"
        code --force --install-extension  "PKief.material-icon-theme"
        code --force --install-extension  "rechinformatica.rech-editor-batch"
        code --force --install-extension  "redhat.fabric8-analytics"
        code --force --install-extension  "redhat.java"
        code --force --install-extension  "redhat.vscode-yaml"
        code --force --install-extension  "rogalmic.bash-debug"
        code --force --install-extension  "timonwong.shellcheck"
        code --force --install-extension  "VisualStudioExptTeam.vscodeintellicode"
        code --force --install-extension  "vscjava.vscode-java-debug"
        code --force --install-extension  "vscjava.vscode-java-dependency"
        code --force --install-extension  "vscjava.vscode-java-pack"
        code --force --install-extension  "vscjava.vscode-java-test"
        code --force --install-extension  "vscjava.vscode-maven"
        code --force --install-extension  "wmanth.jar-viewer"
    fi
}

function setupFedora () {
    sudo dnf install dnf5

    echo "Running updates..."
    sudo dnf5 --refresh update
    sudo dnf5 --refresh upgrade
    sudo dnf5 install firefox
    sudo dnf5 install snapd

    if [[ $DE == "GNOME" ]]; then
        dconf load -f / < gnome-settings.ini
    else
        echo "DE not set to 'GNOME'. Not importing settings..."
    fi

    sudo ln -sf /var/lib/snapd/snap /snap

    mkdir -p "$HOME/.config/1Password/ssh/"
    sudo ln -sf "$PWD/1Password/agent.toml" "$HOME/.config/1Password/ssh/agent.toml"

    # Check to see if we're on aarch64 or x86_64
    if [[ $ARCHITECTURE == "aarch64" ]]; then
        sudo rpm --force --install "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-arm64"

        # installing 1Password ARM
        curl -sSO https://downloads.1password.com/linux/tar/stable/aarch64/1password-latest.tar.gz
        sudo tar -xf 1password-latest.tar.gz
        sudo rm -rf /opt/1Password/
        sudo mkdir -p /opt/1Password
        sudo mv -f 1password-*/* /opt/1Password
        sudo /opt/1Password/after-install.sh
        sudo rm -r -f 1password*

        # no Sublime for ARM yet
        
    elif [[ $ARCHITECTURE == "x86_64" ]]; then
        sudo rpm --install "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
        sudo rpm --install "https://downloads.1password.com/linux/rpm/stable/x86_64/1password-latest.rpm"
        sudo rpm --install "https://download.sublimetext.com/sublime-text-4152-1.x86_64.rpm"
    else
        echo "This installer has not implemented this architecture yet ($ARCHITECTURE). Goodbye."
        exit 1
    fi



    # installing 1Password CLI
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf5 check-update -y 1password-cli && sudo dnf5 install 1password-cli

    sudo snap install spotify
    sudo snap install zulip
    sudo snap install discord
    sudo snap install todoist

    # NordVPN
    sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)

    # dev packages
    sudo dnf5 install zsh
    sudo dnf5 install vim
    sudo dnf5 install bash
    sudo dnf5 install git
    sudo dnf5 install python
    sudo dnf5 install lynx
    sudo dnf5 install neofetch
    sudo dnf5 install nodejs
    sudo npm install -g yarn
    sudo npm install -g sass

    # flatpaks
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    echo "flathub remote added!"

    flatpak install flathub it.mijorus.gearlever

    chsh -s "$(which zsh)"

    commonInstall
}

function setupMac() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brew install --cask firefox
    brew install --cask 1password
    brew install --cask visual-studio-code
    brew install --cask sublime-text
    brew install --cask 1password-cli
    brew install --cask spotify
    brew install --cask zulip
    brew install --cask discord
    brew install --cask todoist
    brew install --cask nordvpn
    brew install --cask mitmproxy
    brew install python@3.11
    brew install vim
    brew install bash
    brew install git
    brew install lynx
    brew install neofetch
    brew install node
    brew install mas
    sudo npm install -g yarn
    sudo npm install -g sass

    echo "Running updates..."
    sudo softwareupdate -ia --verbose
    mas upgrade

    commonInstall
}

if [[ $OS == "Linux" ]]; then
    setupFedora
elif [[ $OS == "Darwin" ]]; then
    setupMac
else
    echo "This operating system is not supported. Only Linux and macOS are supported."
    exit 1
fi

echo "PLEASE RESTART YOUR SYSTEM."
