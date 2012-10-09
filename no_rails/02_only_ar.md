!SLIDE title subsection smaller

# Target #5
## Run only ActiveRecord

## [spec\_models\_helper.rb](https://gist.github.com/7b6924fe149d09db6e39)

* load bundler
* initialize ActiveSupport::Dependencies
* add 'app/models' and 'lib' to the load path
* connect with database
* load other dependencies if necessary
* configure rspec

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
