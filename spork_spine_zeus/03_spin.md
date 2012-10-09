!SLIDE small

# [Spin](https://github.com/jstorimer/spin)

* Preloading your Rails environment.

## Spin vs Spork

* Simple and unobtrusive (we don't have to modify spec_helper.rb)
* It doesn't do any crazy monkey patching.

!SLIDE smaller

# Spin workflow

## Run the server

	@@@
	$ spin serve
	Preloaded Rails env in 1.80131643s...

## Push a spec

	@@@
	$ spin push  spec/models/user_spec.rb --time
	Spinning up spec/models/user_spec.rb|tty?

## See the results

	@@@
	$ spin serve
	Preloaded Rails env in 1.80131643s...

	Loading ["spec/models/user_spec.rb"]
	..................

	Finished in 0.22917 seconds
	18 examples, 0 failures
