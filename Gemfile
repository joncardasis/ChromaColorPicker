source 'https://rubygems.org'
ruby '3.2.2'

gem 'cocoapods', '~> 1.15.0'
gem 'bundler', '~> 2.4.21'

gem 'rubyzip', '~> 2.3.2'
gem 'zip-zip'

gem 'earlgrey'
gem 'algolia'
gem 'faraday'

gem "fastlane"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval(File.read(plugins_path), binding) if File.exist?(plugins_path)
