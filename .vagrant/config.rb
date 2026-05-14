require 'yaml'

Config = Data.define(
  :git_name,
  :git_email,
  :github_user,
  :github_token,
  :virtualbox_memory,
  :virtualbox_cpus,
  :ruby_version
)

class Config
  def git_remote
    auth = "#{github_user}:#{github_token}"

    "https://#{auth}@github.com/stsh89/Kronika.git"
  end

  class << self
    def load_from_yaml
      current_dir = File.dirname(File.expand_path(__FILE__))
      yaml = YAML.load_file("#{current_dir}/config.yml")

      Config.new(
        git_name: yaml['git']['name'],
        git_email: yaml['git']['email'],
        github_user: yaml['github']['user'],
        github_token: yaml['github']['token'],
        virtualbox_memory: yaml['virtualbox']['memory'],
        virtualbox_cpus: yaml['virtualbox']['cpus'],
        ruby_version: [4, 0, 4]
      )
    end
  end
end
