# Smart fxitures

## factory_girl_performance.rb

if ENV['FACTORY_GIRL_PERFORMANCE']
  slow_factories = {}

  # Look for slow factories
  # @see: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#activesupport-instrumentation
  ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
    execution_time_in_seconds = finish - start

    key = :"#{payload[:strategy]} :#{payload[:name]}"
    slow_factories[key] ||= []
    slow_factories[key] << execution_time_in_seconds
  end

  RSpec.configure do |config|
    config.after(:suite) do
      Result = Struct.new(:name, :total_time, :average_time, :calls)
      results = []

      slow_factories.each do |key, times|
        total_time = times.inject(0.0) { |sum, el| sum + el }
        average_time = total_time / times.size
        results << Result.new(key, total_time, average_time, times.size)
      end
      results.sort_by! { |result| -result.average_time }

      def print_list(items, *fields)
        # find max length for each field; start with the field names themselves
        fields = items.first.class.column_names unless fields.any?
        max_len = Hash[*fields.map { |f| [f, f.to_s.length] }.flatten]
        items.each do |item|
          fields.each do |field|
            len = item.send(field).to_s.length
            max_len[field] = len if len > max_len[field]
          end
        end

        border = '+-' + fields.map { |f| '-' * max_len[f] }.join('-+-') + '-+'
        title_row = '| ' + fields.map { |f| sprintf("%-#{max_len[f]}s", f.to_s) }.join(' | ') + ' |'

        puts border
        puts title_row
        puts border

        items.each do |item|
          row = '| ' + fields.map { |f| sprintf("%-#{max_len[f]}s", item.send(f)) }.join(' | ') + ' |'
          puts row
        end

        puts border
        puts "#{items.length} rows in set\n"
      end

      puts "\n\nTop 10 slow factories:"
      print_list(results[0..9], :name, :average_time, :total_time, :calls)
    end
  end
end


# Some shared context for integration specs

# Before

shared_context 'stuff for the API integration specs' do
  let(:user) { create(:user, email: 'user@email.com', password: 'secret password') }
  let(:other_user) { create(:user, email: 'other.user@email.com', password: 'secret password') }

  let(:first_company) { create(:company, name: 'First company', subdomain: 'first-company', users: [user]) }
  let(:second_company) { create(:company, name: 'Second company', subdomain: 'second-company', users: [user]) }
  let(:third_company) { create(:company, name: 'Third company', subdomain: 'third-company', users: [other_user]) }
  let(:company) { first_company }
end

# After

shared_context 'stuff for the API integration specs' do
  before do
    fixtures = SmartFixtures.instance
    fixtures.capture('API integration specs') do
      user = create(:user, email: 'user@email.com', password: 'secret password')
      other_user = create(:user, email: 'other.user@email.com', password: 'secret password')

      create(:company, name: 'First company', subdomain: 'first-company', users: [user])
      create(:company, name: 'Second company', subdomain: 'second-company', users: [user])
      create(:company, name: 'Third company', subdomain: 'third-company', users: [other_user])
    end
  end

  let(:user) { User.where(email: 'user@email.com').first }
  let(:other_user) { User.where(email: 'other.user@email.com').first }

  let(:first_company) { Company.where(subdomain: 'first-company').first }
  let(:second_company) { Company.where(subdomain: 'second-company').first }
  let(:third_company) { Company.where(subdomain: 'third-company').first }
  let(:company) { first_company }
end

##################

## spec_helper.rb

Moped::Protocol::Insert.class_eval do
  def log_inspect_with_instrument
    ActiveSupport::Notifications.instrument('mongodb.insert', collection: collection, documents: documents)
    log_inspect_without_instrument
  end

  alias_method_chain :log_inspect, :instrument
end

# fixtures = SmartFixtures.instance
# fixtures.by_name('sample API data').capture do
# ...
# end
class SmartFixtures
  include Singleton

  attr_reader :fixtures

  def initialize
    @fixtures = {}
  end

  def find_by_name(name)
    fixtures[name.to_sym] ||= SmartFixture.new
    fixtures[name.to_sym]
  end

  def capture(name, &block)
    find_by_name(name).capture(&block)
  end
end

class SmartFixture
  attr_accessor :captured_data

  def initialize
    @captured_data = []
  end

  def capture(&block)
    unless captured?
      ActiveSupport::Notifications.subscribe('mongodb.insert') do |name, start, finish, id, payload|
        captured_data << [payload[:collection], payload[:documents]]
      end

      block.call

      ActiveSupport::Notifications.unsubscribe('mongodb.insert')
    else
      insert_all
    end
  end

  def captured?
    not captured_data.empty?
  end

  # insert data from the query cache
  def insert_all
    captured_data.each do |data|
      collection, documents = *data

      session = User.collection.database.session
      session[collection].insert(documents)
    end
  end
end
