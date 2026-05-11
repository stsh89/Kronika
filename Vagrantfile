# frozen_string_literal: true

require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))
cfg = YAML.load_file("#{current_dir}/vagrant_config.yaml")

# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = 'cloud-image/arch-linux'
  config.vm.box_version = '20260501.523211.0'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Disable the default share of the current code directory. Doing this
  # provides improved isolation between the vagrant box and your host
  # by making sure your Vagrantfile isn't accessible to the vagrant box.
  # If you use this you may want to enable additional shared subfolders as
  # shown above.
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:

  config.vm.provider 'virtualbox' do |vb|
    #   # Display the VirtualBox GUI when booting the machine
    #   vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = cfg['virtualbox']['memory'].to_s
    vb.cpus = cfg['memory']['cpus'].to_s
  end

  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  # Provisioning script to install Docker
  config.vm.provision 'shell', inline: <<-SHELL
    # Update package database and install docker
    pacman -Syu --noconfirm docker

    # Start and enable Docker service immediately
    systemctl enable --now docker.service

    # Add the vagrant user to the docker group
    # Note: This takes effect on the next login
    usermod -aG docker vagrant
  SHELL

  # Provisioning script to install Helix
  config.vm.provision 'shell', inline: <<~SHELL
        pacman -Syu --noconfirm --needed helix

        # Create the config.toml file
        sudo -u vagrant mkdir -p /home/vagrant/.config/helix/
        sudo -u vagrant cat <<-'EOF' > /home/vagrant/.config/helix/config.toml
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

  SHELL

  # Provisioning script to install Git
  config.vm.provision 'shell',
                      env: { 'GITHUB_USER' => cfg['github']['user'].to_s,
                             'GITHUB_TOKEN' => cfg['github']['token'].to_s },
                      inline: <<-SHELL
    DEST="/home/vagrant/kronika"
    REPO_URL="https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/Kronika.git"

    # Install git
    pacman -Syu --noconfirm --needed git less

    # Configure git globally for the vagrant user
    # We pass the Ruby variables into the shell script here
    sudo -u vagrant git config --global user.name "#{cfg['git']['name']}"
    sudo -u vagrant git config --global user.email "#{cfg['git']['email']}"
    sudo -u vagrant git config --global core.editor "helix"

    echo "Git configured for: $(sudo -u vagrant git config --global user.name)"

    if [ ! -d "$DEST" ]; then
      echo "Cloning repository..."
      sudo -u vagrant git clone $REPO_URL $DEST
    fi
                      SHELL

  # Provisioning script for Zellij
  config.vm.provision 'shell', inline: <<-SHELL
    pacman -Syu --noconfirm --needed zellij
  SHELL

  # Provisioning script to install Ruby
  config.vm.provision 'shell', inline: <<-SHELL
    # Install dependencies
    pacman -Syu --noconfirm --needed base-devel gcc openssl zlib libyaml libffi readline

    if command -v ruby >/dev/null 2>&1; then
      echo "Ruby is installed: $(ruby -v)"
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
  SHELL

  # Provisioning script for various customizations
  config.vm.provision 'shell',
                      inline: <<-SHELL
      DEST="/home/vagrant/kronika"

      chsh -s /bin/bash vagrant

      if ! grep -q "cd $DEST" /home/vagrant/.bashrc; then
        echo "cd $DEST" >> /home/vagrant/.bashrc
      fi

      cd /home/vagrant/kronika

      sudo -u vagrant bundle install
                      SHELL
end
