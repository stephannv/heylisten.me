RSpec.configure do |config|
  config.before(:each) do
    Mongoid.purge!
  end
end
