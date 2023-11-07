# links
mkdir -p "$HOME/.config/1Password/ssh/"
ln -sv "$HOME/.dotfiles_fedora/.config/1Password/ssh/agent.toml" "$HOME/.config/1Password/ssh/"

mkdir -p "$HOME/.ssh/"
ln -sv "$HOME/.dotfiles_fedora/.ssh/config" "$HOME/.ssh/"

ln -sv "$HOME/.dotfiles_fedora/.gitconfig" "$HOME/.gitconfig"

# Brew does not support ARM Linux. </3

sudo -v

sudo dnf install bash
sudo dnf install git # version control
sudo dnf install python
sudo dnf install git-filter-repo
sudo dnf install lynx
sudo dnf install neofetch
sudo dnf install nodejs
sudo npm install -g yarn
sudo npm install -g sass
sudo dnf install firefox
sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install snap-store

sudo snap install spotify
sudo rpm --install "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-arm64"

# installing 1Password ARM
curl -sSO https://downloads.1password.com/linux/tar/stable/aarch64/1password-latest.tar.gz
sudo tar -xf 1password-latest.tar.gz
sudo mkdir -p /opt/1Password
sudo mv 1password-*/* /opt/1Password

sudo /opt/1Password/after-install.sh

sudo rm -r -f 1password-latest.tar.gz

# installing 1Password CLI
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf check-update -y 1password-cli && sudo dnf install 1password-cli

# installing Zulip ARM
git clone https://github.com/zulip/zulip-desktop
cd zulip-desktop
npm install
npx vite build
npx electron-builder --linux tar.gz
cd dist
sudo tar -xf Zulip-*.*.*-arm64.tar.gz
sudo mkdir -p /opt/Zulip
sudo mv Zulip-*/* /opt/Zulip
sudo ln -sf /opt/Zulip/zulip /usr/bin/zulip
sudo rm -r -f ~/.dotfiles_fedora/zulip-desktop

# installing pip
curl https://bootstrap.pypa.io/get-pip.py >> "get-pip.py"
python get-pip.py
rm get-pip.py
