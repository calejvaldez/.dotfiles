#!/usr/bin/env bash
sudo -v

ARCHITECTURE="$(uname -m)"
echo "$ARCHITECTURE architecture detected."

sudo dnf install firefox
sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap

# Check to see if we're on aarch64 or x86_64
if [[ $ARCHITECTURE == "aarch64" ]]; then
    sudo rpm --install "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-arm64"

    # installing 1Password ARM
    curl -sSO https://downloads.1password.com/linux/tar/stable/aarch64/1password-latest.tar.gz
    sudo tar -xf 1password-latest.tar.gz
    sudo mkdir -p /opt/1Password
    sudo mv 1password-*/* /opt/1Password
    sudo /opt/1Password/after-install.sh
    sudo rm -r -f 1password-latest.tar.gz

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
sudo dnf check-update -y 1password-cli && sudo dnf install 1password-cli

sudo snap install spotify
sudo snap install zulip
sudo snap install discord
sudo snap install todoist

# dev packages
sudo dnf install bash
sudo dnf install git
sudo dnf install python
sudo dnf install git-filter-repo
sudo dnf install lynx
sudo dnf install neofetch
sudo dnf install nodejs
sudo npm install -g yarn
sudo npm install -g sass


# installing pip
curl https://bootstrap.pypa.io/get-pip.py >> "get-pip.py"
python get-pip.py
rm get-pip.py

# vs code
if command -v code &> /dev/null
then
    code --install-extension "DavidAnson.vscode-markdownlint"
    code --install-extension "dsznajder.es7-react-js-snippets"
    code --install-extension "eamodio.gitlens"
    code --install-extension "figma.figma-vscode-extension"
    code --install-extension "GrapeCity.gc-excelviewer"
    code --install-extension "ms-dotnettools.vscode-dotnet-runtime"
    code --install-extension "ms-python.python"
    code --install-extension "ms-python.vscode-pylance"
    code --install-extension "ms-toolsai.jupyter"
    code --install-extension "ms-toolsai.jupyter-keymap"
    code --install-extension "ms-toolsai.jupyter-renderers"
    code --install-extension "ms-toolsai.vscode-jupyter-cell-tags"
    code --install-extension "ms-toolsai.vscode-jupyter-slideshow"
    code --install-extension "ms-vscode-remote.remote-ssh"
    code --install-extension "ms-vscode-remote.remote-ssh-edit"
    code --install-extension "ms-vscode-remote.remote-wsl"
    code --install-extension "ms-vscode.remote-explorer"
    code --install-extension "ms-vscode.vscode-github-issue-notebooks"
    code --install-extension "ms-vsliveshare.vsliveshare"
    code --install-extension "mtxr.sqltools"
    code --install-extension "mtxr.sqltools-driver-sqlite"
    code --install-extension "NilsSoderman.batch-runner"
    code --install-extension "PKief.material-icon-theme"
    code --install-extension "rechinformatica.rech-editor-batch"
    code --install-extension "redhat.fabric8-analytics"
    code --install-extension "redhat.java"
    code --install-extension "redhat.vscode-yaml"
    code --install-extension "rogalmic.bash-debug"
    code --install-extension "timonwong.shellcheck"
    code --install-extension "VisualStudioExptTeam.intellicode-api-usage-examples"
    code --install-extension "VisualStudioExptTeam.vscodeintellicode"
    code --install-extension "vscjava.vscode-java-debug"
    code --install-extension "vscjava.vscode-java-dependency"
    code --install-extension "vscjava.vscode-java-pack"
    code --install-extension "vscjava.vscode-java-test"
    code --install-extension "vscjava.vscode-maven"
    code --install-extension "wmanth.jar-viewer"
fi
