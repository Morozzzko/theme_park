# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :tools do
  gem 'parser', github: 'iliabylich/parser', ref: 'pattern-matching'
  gem 'pry-byebug'
  gem 'rubocop'
  gem 'rubocop-daemon'
  gem 'rubocop-rspec'
  gem 'solargraph'
  gem 'travis'
end

group :test do
  gem 'rspec'
  gem 'simplecov', require: false
end

gem 'dry-initializer'
gem 'dry-struct'
gem 'dry-types'
gem 'tty-prompt'

gem 'ascii_cards', '~> 1.0'
