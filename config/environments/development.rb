Sinatra::Application.configure :development do
  # Set up MongoMapper
  MongoMapper.connection = Mongo::Connection.new('127.0.0.1', '27017')
  MongoMapper.database   = 'sinatra_template_development'

  # Do other development related setup...
end
