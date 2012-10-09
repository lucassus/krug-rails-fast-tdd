!SLIDE title subsection smaller

# Target #6
## Smart fixtures

### Fixtures are evil!
### But factory_girl could be very slow

	@@@ ruby
	shared_context 'stuff for the API integration specs' do
	  let(:user) { create(:user, email: 'user@email.com') }
	  let(:other_user) { create(:user, email: 'other.user@email.com') }

	  let(:first_company) { create(:company, name: 'First company', 
	  	users: [user]) }
	  let(:second_company) { create(:company, name: 'Second company', 
	  	users: [user]) }
	  # etc...
	end

!SLIDE smaller

# Be smart

	@@@ ruby
	shared_context 'stuff for the API integration specs' do
	  before do
	    fixtures = SmartFixtures.instance
	    fixtures.capture('API integration specs') do
	      user = create(:user, email: 'user@email.com')
	      create(:company, subdomain: 'first-company', users: [user])
	    end
	  end

	  let(:user) { User.where(email: 'user@email.com').first }
	  let(:first_company) { Company.where(subdomain: 'first-company').first }
	end

!SLIDE smaller

# Implementation

## Get mongodb inserts

	@@@ ruby
	# spec_helper.rb
	Moped::Protocol::Insert.class_eval do
	  def log_inspect_with_instrument
	    ActiveSupport::Notifications.instrument('mongodb.insert', 
    		collection: collection, documents: documents)
	    log_inspect_without_instrument
	  end

	  alias_method_chain :log_inspect, :instrument
	end

## Capture it

	@@@ ruby
    ActiveSupport::Notifications.subscribe('mongodb.insert') 
    do |name, start, finish, id, payload|
      captured_data << [payload[:collection], payload[:documents]]
    end

## [sources https://gist.github.com/3857230](https://gist.github.com/3857230)

!SLIDE smaller

# Results

## Before

	@@@
	$ rspec spec/ --tag api
	Run options: include {:api=>true}
	..........................................

	Finished in 3 minutes 59.73 seconds

## After

	@@@
	$ rspec spec/ --tag api
	Run options: include {:api=>true}
	..........................................

	Finished in 1 minute 12.46 seconds
