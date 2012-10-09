!SLIDE smaller

# No rails

## spec_helper.rb

	@@@ ruby
	ENV["RAILS_ENV"] ||= 'test'
	require File.expand_path("../../config/environment", __FILE__)

## spec/user_spec.rb

	@@@ ruby
	require 'spec_helper'
	describe User do; end

!SLIDE

## Possible approaches

* [Speeding up rails tests](http://www.nateklaiber.com/blog/2012/08/29/refactoring-in-practice-speeding-up-your-rails-tests)
* [DAS, Fast tests with and withour rails](https://www.destroyallsoftware.com/screencasts/catalog/fast-tests-with-and-without-rails)
* [Corey Haines: Fast Rails Tests](http://blog.moretea.nl/corey-haines-fast-rails-tests)
* ..and many other
