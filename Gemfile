source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.5'

gem 'rails', '~> 5.2.3'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'grape'
gem 'grape-swagger'
gem 'grape_fast_jsonapi', git: 'git@github.com:EmCousin/grape_fast_jsonapi.git'
gem 'seedbank'
gem 'api-pagination'
gem 'kaminari'

group :development do
  gem 'bullet'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers', '4.0.0.rc.1'
  gem 'shoulda-callback-matchers'
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'faker'
end

group :development, :test do
  gem 'pry-rails'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 3.7.0'
end


gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
