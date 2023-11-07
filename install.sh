# links
mkdir -p "$HOME/.config/1Password/ssh/"
ln -sv "$HOME/.dotfiles_fedora/.config/1Password/ssh/agent.toml" "$HOME/.config/1Password/ssh/"

mkdir -p "$HOME/.ssh/"
ln -sv "$HOME/.dotfiles_fedora/.ssh/config" "$HOME/.ssh/"

ln -sv "$HOME/.dotfiles_fedora/.gitconfig" "$HOME/.gitconfig"

sudo -v

sudo dnf install firefox
sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install snap-store

sudo rpm --install "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-arm64" # vscode
sudo rpm --install "https://downloads.1password.com/linux/rpm/stable/x86_64/1password-latest.rpm" # 1password
sudo rpm --install "https://download.sublimetext.com/sublime-text-4152-1.x86_64.rpm" # sublime text

# installing 1Password CLI
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf check-update -y 1password-cli && sudo dnf install 1password-cli

sudo snap install spotify
sudo snap install zulip
sudo snap install discord
sudo snap install todoist


# installing pip
curl https://bootstrap.pypa.io/get-pip.py >> "get-pip.py"
python get-pip.py
rm get-pip.py
