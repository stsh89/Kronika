# Setup helix

if ! command -v helix >/dev/null 2>&1; then
    pacman -Syu --noconfirm --needed helix
    mkdir -p /home/vagrant/.config/helix/
    chown -R vagrant:vagrant /home/vagrant/.config/helix/
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

fi

# Setup git

if ! command -v git >/dev/null 2>&1; then
    pacman -Syu --noconfirm --needed git less
    sudo -u vagrant git config --global user.name "$GIT_NAME"
    sudo -u vagrant git config --global user.email "$GIT_EMAIL"
    sudo -u vagrant git config --global core.editor "helix"
fi

# Setup zellij

if ! command -v zellij >/dev/null 2>&1; then
    pacman -Syu --noconfirm --needed zellij
    mkdir -p /home/vagrant/.config/zellij/
    chown -R vagrant:vagrant /home/vagrant/.config/zellij/
fi

# Setup fish

if ! command -v fish >/dev/null 2>&1; then
    pacman -Syu --noconfirm --needed fish
    mkdir -p /home/vagrant/.config/fish
    chown -R vagrant:vagrant /home/vagrant/.config/fish/
    cat <<EOF > /home/vagrant/.config/fish/config.fish
export EDITOR=helix

cd $APP_DIR

if status is-interactive
    if not set -q ZELLIJ
        exec zellij options --default-shell fish
    end
end

EOF

fi

# Setup yazi

if ! command -v yazi >/dev/null 2>&1; then
    sudo pacman -Syu --noconfirm --needed yazi
    mkdir -p /home/vagrant/.config/yazi
    chown -R vagrant:vagrant /home/vagrant/.config/yazi/
    sudo -u vagrant ya pkg add yazi-rs/flavors:catppuccin-mocha
    cat <<EOF > /home/vagrant/.config/yazi/theme.toml
[flavor]
dark = "catppuccin-mocha"

EOF

fi

# Setup ruby

if ! command -v ruby >/dev/null 2>&1; then
    pacman -Syu --noconfirm --needed base-devel \
        openssl  zlib libyaml libffi

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

if ! command -v docker >/dev/null 2>&1; then
    pacman -Syu --noconfirm --needed docker docker-buildx
    systemctl enable --now docker.service
    usermod -aG docker vagrant
fi

# Setup lazygit

if ! command -v docker >/dev/null 2>&1; then
    pacman -Syu --noconfirm --needed lazygit
    mkdir -p /home/vagrant/.config/lazygit
    chown -R vagrant:vagrant /home/vagrant/.config/lazygit/
fi

# Clone repository

if [ ! -d "$APP_DIR" ]; then
    sudo -u vagrant git clone $GITHUB_REMOTE $APP_DIR
fi

# Setup app

cd $APP_DIR
sudo -u vagrant bundle install
