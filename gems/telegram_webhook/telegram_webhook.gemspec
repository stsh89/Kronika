# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'telegram_webhook'
  spec.version = '0.1.0'
  spec.authors = ['Stanislav Shandyga']
  spec.email = ['stanislavshandyga@gmail.com']
  spec.summary = ''
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '4.0.4'

  spec.add_dependency 'console'
  spec.add_dependency 'geo_names'
  spec.add_dependency 'kronika'
  spec.add_dependency 'rack'
  spec.add_dependency 'telegram'
  spec.add_dependency 'tzinfo'
  spec.add_dependency 'tzinfo-data'
  spec.add_dependency 'upstash'
end
