REPO_URL="https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/Kronika.git"

pacman -Syu --noconfirm --needed docker helix git less zellij lazygit \
   base-devel gcc openssl zlib libyaml libffi readline

if command -v ruby >/dev/null 2>&1; then
  echo "Ruby is already installed: $(ruby -v)"
else
  echo "Installing ruby"

  mkdir ~/ruby-build && cd ~/ruby-build
  curl -O https://cache.ruby-lang.org/pub/ruby/3.4/ruby-3.4.7.tar.gz
  tar -xzf ruby-3.4.7.tar.gz
  cd ruby-3.4.7
  ./configure --prefix=/usr/local --enable-shared --disable-install-doc
  make -j$(grep -c ^processor /proc/cpuinfo)
  make install
  cd ~/ && rm -rf ~/ruby-build
fi

systemctl enable --now docker.service
usermod -aG docker vagrant

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

chown vagrant:vagrant /home/vagrant/.config/helix/config.toml

sudo -u vagrant git config --global user.name "$GIT_NAME"
sudo -u vagrant git config --global user.email "$GIT_EMAIL"
sudo -u vagrant git config --global core.editor "helix"

if [ ! -d "$DEST" ]; then
  echo "Cloning repository..."
  sudo -u vagrant git clone $REPO_URL $DEST
fi

chsh -s /bin/bash vagrant

if ! grep -q "cd $DEST" /home/vagrant/.bashrc; then
  echo "cd $DEST" >> /home/vagrant/.bashrc
fi

cd /home/vagrant/kronika

sudo -u vagrant bundle install
