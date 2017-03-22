source 'https://rubygems.org'

# git_source(:github) do |repo_name|
#   repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
#   "https://github.com/#{repo_name}.git"
# end

gem 'mongoid'

gem 'bootstrap-sass'

gem 'devise'
# gem 'kaminari'

# gem 'carrierwave'
# gem 'fog'
gem 'aws-sdk', '~> 2'

gem 'mini_magick'

gem 'data_uri'

# gem 'tesseract-ocr', '~> 0.1.8'

# gem 'fog'
gem 'faker'

# gem 'sucker_punch'
# gem 'resque'
# gem 'resque-scheduler'
# gem 'queue_classic'
# gem 'resque'
# gem 'sidekiq'
# gem 'redis'
# gem 'redis-namespace'

# gem "jquery-fileupload-rails"

gem 'farm_ruby', git: 'https://github.com/jessethebuilder/farm_ruby'

gem 'farm_shed', git: 'https://github.com/jessethebuilder/farm_shed', branch: 'lite'
# gem 'farm_shed', path: '/var/www/my_gems/farm_shed', branch: 'lite'

gem 'farm_devise_views', git: 'https://github.com/jessethebuilder/farm_devise_views'

# gem 'farm_scrape', git: 'https://github.com/jessethebuilder/farm_scrape.git'

gem 'rtesseract'
# gem 'tesseract-ocr'

group :test, :development do
  gem 'faker'
  gem 'rspec-rails'
  gem 'database_cleaner', '~> 1.0.0rc'
  gem 'timecop'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'selenium-webdriver'
  gem 'shoulda'
  gem 'launchy', '~> 2.3.0'
  #gem 'webrat'
  gem 'poltergeist'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# , '~> 5.0.1'
# gem 'rails', '~> 4.0.2'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'


# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'listen', '~> 3.0.5'
  # # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
