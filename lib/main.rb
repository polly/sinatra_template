class Main < Sinatra::Application
  use Rack::Session::Cookie
  use Rack::Flash

  register Sinatra::SessionAuth

  set :views, APP_ROOT + "/views/main"

  get "/" do
    erb :index
  end

  get "/protected" do
    authorize!
    "Protected Action"
  end
end
