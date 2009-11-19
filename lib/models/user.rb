class User
  include MongoMapper::Document
  include Sinatra::SessionAuth::EncryptionHelpers
  
  key :login,           String
  key :hashed_password, String
  key :email,           String
  key :salt,            String
end
