# frozen_string_literal: true

require_relative 'support/in_memory_repo'
require_relative 'support/dummy_chrono'

require 'kronika'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
