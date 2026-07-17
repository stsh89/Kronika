# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'http_mock'
  spec.version = '0.1.0'
  spec.authors = ['Stanislav Shandyga']
  spec.email = ['stanislavshandyga@gmail.com']
  spec.summary = ''
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '4.0.6'

  spec.add_dependency 'async'
  spec.add_dependency 'async-http'
  spec.add_dependency 'faraday'
end
