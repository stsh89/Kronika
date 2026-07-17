require 'yaml'

Config = Data.define(
  :git_name,
  :git_email,
  :github_user,
  :github_token,
  :machine_memory,
  :machine_cpus,
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
        machine_memory: yaml['machine']['memory'],
        machine_cpus: yaml['machine']['cpus'],
        ruby_version: [4, 0, 6]
      )
    end
  end
end
