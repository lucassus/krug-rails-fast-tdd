!SLIDE

# Spork

* https://github.com/sporkrb/spork
* A DRb server for testing frameworks (RSpec / Cucumber currently)
* It forks a copy of the server each time you run your tests

!SLIDE smaller

# Spork workflow

## running spork

	@@@
	$ spork
	Using RSpec
	Preloading Rails environment
	Loading Spork.prefork block...
	Spork is ready and listening on 8989!

	Running tests with args ["--color", "--order", "random", 
		"spec/models/user_spec.rb"]...
	Done.

## running specs

	@@@
	$ time rspec --drb spec/models/user_spec.rb
	..................

	Finished in 0.5526 seconds
	18 examples, 0 failures

	real	0m1.924s
	user	0m1.080s
	sys		0m0.072s

!SLIDE small

# Spork has many cons

* it's pretty fast but...
* Does crazy Rails monkey-patching
* Requires changing spec_helper.rb
* Sometimes produces strange errors

!SLIDE smaller

# Spork hacks for pre-loading

	@@@ ruby
	# in spec_helper.rb
	Spork.each_run do
	  # This code will be run each time you run your specs.

	  ActiveSupport::Dependencies.clear
	  ActiveRecord::Base.instantiate_observers
	  Locomotive::Application.reload_routes!
	  FactoryGirl.reload

	  # Workarounds for ActiveAdmin
	  # see: https://github.com/gregbell/active_admin/issues/918#issuecomment-3741826
	  ActiveAdmin.unload!
	  ActiveAdmin.load!
	end if Spork.using_spork?
