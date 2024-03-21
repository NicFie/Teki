RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 3;')
  end

  config.after(:suite) do
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 3;')
  end
end
