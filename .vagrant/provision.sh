# Setup helix

pacman -Syu --noconfirm --needed helix

mkdir -p /home/vagrant/.config/helix/

cat <<EOF > /home/vagrant/.config/helix/config.toml
theme = "catppuccin_mocha"

[editor]
true-color = true
line-number = "relative"
cursorline = true
color-modes = true

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.indent-guides]
render = true

EOF

chown -R vagrant:vagrant /home/vagrant/.config/helix/

# Setup zellij

pacman -Syu --noconfirm --needed zellij

mkdir -p /home/vagrant/.config/zellij/
chown -R vagrant:vagrant /home/vagrant/.config/zellij/

# Setup fish

pacman -Syu --noconfirm --needed fish

mkdir -p /home/vagrant/.config/fish

cat <<EOF > /home/vagrant/.config/fish/config.fish
set -gx COLORTERM truecolor

cd $APP_DIR

if status is-interactive
    if not set -q ZELLIJ
        exec zellij options --default-shell fish
    end
end

EOF

chown -R vagrant:vagrant /home/vagrant/.config/fish/

# Setup ruby

pacman -Syu --noconfirm --needed base-devel \
  openssl  zlib libyaml libffi

if ! command -v ruby >/dev/null 2>&1; then
  BASE_URL="https://cache.ruby-lang.org/pub/ruby"
  BASE_PATH="$RUBY_VERSION_MAJOR.$RUBY_VERSION_MINOR"
  DOWNLOAD_URL="$BASE_URL/$BASE_PATH/ruby-$RUBY_VERSION.tar.gz"

  mkdir ~/ruby-build && cd ~/ruby-build
  curl -O $DOWNLOAD_URL
  tar -xzf ruby-$RUBY_VERSION.tar.gz
  cd ruby-$RUBY_VERSION
  ./configure
  make -j$(grep -c ^processor /proc/cpuinfo)
  make install
  cd ~/ && rm -rf ~/ruby-build
fi

# Setup docker

pacman -Syu --noconfirm --needed docker docker-buildx

systemctl enable --now docker.service
usermod -aG docker vagrant

# Setup lazygit

pacman -Syu --noconfirm --needed lazygit

mkdir -p /home/vagrant/.config/lazygit
chown -R vagrant:vagrant /home/vagrant/.config/lazygit/

# Setup git

pacman -Syu --noconfirm --needed git less

sudo -u vagrant git config --global user.name "$GIT_NAME"
sudo -u vagrant git config --global user.email "$GIT_EMAIL"
sudo -u vagrant git config --global core.editor "helix"

if [ ! -d "$APP_DIR" ]; then
  sudo -u vagrant git clone $GITHUB_REMOTE $APP_DIR
fi

# Setup gemini

if ! command -v node >/dev/null 2>&1; then
  NODE_VERSION="24.15.0"
  NODE_DISTRO="linux-x64"
  NODE_BASE_URL="https://nodejs.org/dist/v$NODE_VERSION"
  NODE_TARBALL="node-v$NODE_VERSION-$NODE_DISTRO.tar.gz"

  mkdir -p ~/node-build && cd ~/node-build
  curl -O $NODE_BASE_URL/$NODE_TARBALL
  tar -xzf $NODE_TARBALL
  sudo cp -r node-v$NODE_VERSION-$NODE_DISTRO/{bin,include,lib} /usr/local/
  cd ~/ && rm -rf ~/node-build

  npm install -g @google/gemini-cli
fi

# Setup app

cd $APP_DIR
sudo -u vagrant bundle install
