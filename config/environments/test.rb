Sinatra::Application.configure :test do
  # Set up MongoMapper
  MongoMapper.connection = Mongo::Connection.new('127.0.0.1', '27017')
  MongoMapper.database   = 'sinatra_template_test'

  # Do other test related setup...
end

