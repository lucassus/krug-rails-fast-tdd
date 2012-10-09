!SLIDE smaller

# Run only ActiveRecord

	@@@ ruby
	# rspec_models_helper.rb
	require 'rubygems'
	require 'bundler/setup'

	# Configure load paths
	require 'active_support/dependencies'

	root_path = File.expand_path("../..", __FILE__)
	$LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)

	ActiveSupport::Dependencies.autoload_paths << 'app/models'
	ActiveSupport::Dependencies.autoload_paths << 'lib'

!SLIDE smaller

# Load database config

	@@@ ruby
	# continue...
	env = ENV['RAILS_ENV'] || 'test'
	yml = ERB.new(IO.read(File.join(root_path, 'config', 'database.yml'))).result
	database_config = YAML::load(yml)[env]

	# Establish connection with database
	require 'active_record'
	ActiveRecord::Base.establish_connection(database_config)

!SLIDE smaller

# Load all necessary gems

	@@@ ruby
	# continue...

	# Load foreigner gem
	require 'foreigner'
	Foreigner.load

	require 'rspec'
	require 'shoulda-matchers'
	require 'database_cleaner'
	require 'factory_girl'

!SLIDE smaller

# Initialize rspec

	@@@ ruby
	# continue...
	Dir[File.join(root_path, "spec/support/**/*.rb")].each do |f| 
 	  require f
	end

	RSpec.configure do |config|; end

!SLIDE smaller

# Use it

	@@@ Ruby
	require 'spec_models_helper'
	describe User do; end

# Run it

	@@@
	$ time rspec spec/models/user_spec.rb 
	..................

	Finished in 0.79919 seconds
	18 examples, 0 failures

	real	0m2.611s
	user	0m2.232s
	sys		0m0.260s
