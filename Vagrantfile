# frozen_string_literal: true

require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))
cfg = YAML.load_file("#{current_dir}/vagrant_config.yaml")

Vagrant.configure('2') do |config|
  config.vm.box = 'cloud-image/arch-linux'
  config.vm.box_version = '20260501.523211.0'
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = cfg['virtualbox']['memory'].to_s
    vb.cpus = cfg['virtualbox']['cpus'].to_s
  end

  config.vm.provision 'shell' do |s|
    s.path = 'vagrant_bootstrap.sh'

    s.env = {
      'DEST' => '/home/vagrant/kronika',
      'GITHUB_USER' => cfg['github']['user'],
      'GITHUB_TOKEN' => cfg['github']['token'],
      'GIT_NAME' => cfg['git']['name'],
      'GIT_EMAIL' => cfg['git']['email']
    }
  end
end
