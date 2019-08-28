source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'bootsnap', '1.4.4', require: false
gem 'httparty', '0.17.0'
gem 'money-rails', '1.13.2'
gem 'mongoid', git: 'https://github.com/mongodb/mongoid.git'
gem 'mutations', '0.9.0'
gem 'puma', '3.12.1'
gem 'rails', '6.0.0'
gem 'sass-rails', '5.1.0'
gem 'simple_enum', '2.3.2', require: 'simple_enum/mongoid'
gem 'turbolinks', '5.2.0'
gem 'twitter', '6.2.0'
gem 'tzinfo-data', '1.2.5', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker', '4.0.7'
gem 'whenever', '1.0.0', require: false

group :development, :test do
  gem 'awesome_print', '1.8.0'
  gem 'byebug', '11.0.1', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '5.0.2'
  gem 'faker', '2.2.0'
  gem 'rspec-rails', '3.8.2'
  gem 'rubocop', '0.74.0'
  gem 'rubocop-performance', '1.4.1'
  gem 'rubocop-rails', '2.3.1'
end

group :development do
  gem 'listen', '3.1.5'
  gem 'spring', '2.1.0'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console', '4.0.1'
end

group :test do
  gem 'mongoid-rspec', '4.0.1'
  gem 'simplecov', '0.17.0'
  gem 'webmock', '3.7.0'
end
