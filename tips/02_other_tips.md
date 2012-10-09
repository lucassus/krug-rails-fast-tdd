!SLIDE title smaller small

# Other tips

* Selenium --> phantomjs, webkit
* Run specs in parallel with [parallel_tests](https://github.com/grosser/parallel_tests)
* Run specs with --profile parameter
* Find [slow factories](https://gist.github.com/3857273)

!SLIDE small

# Several specs in one example

	@@@ ruby
	subject { do_something_really_slow }

## Context is evaluated for each example

	@@@ ruby
	it { should < 10 }
	it { should < 12 }

## About x2 faster

	@@@ ruby
	it 'should be somewhere in the middle' do
	  should > 10
	  should < 12
	end
