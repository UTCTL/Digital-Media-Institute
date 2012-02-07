source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem "acts_as_list", "~> 0.1.4"
gem "awesome_nested_set", "~> 2.0.2"
gem "vimeo"
gem "nokogiri"
gem 'fog'
# gem "aws-s3"
gem 's3_swf_upload', :git => 'git://github.com/nathancolgate/s3-swf-upload-plugin'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
#  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'


group :development, :test do
  gem 'rspec-rails', '~> 2.7'
  gem 'factory_girl_rails', "~>1.2"
  gem 'webrat'
  gem 'spork', '~> 0.9.0.rc'
  gem 'ruby-debug19'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'rb-fsevent' #, :require => false if RUBY_PLATFORM =~ /darwin/i
  #gem 'guard-rspec'
  gem 'guard-spork'
end

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end
