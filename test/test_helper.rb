ENV['RACK_ENV'] = "test"

require File.join(File.dirname(__FILE__), '..', 'init')

require 'rubygems'
require 'rack/test'
require 'webrat'

Sinatra::Application.set(
  :environment => :test,
  :run => false,
  :raise_errors => true,
  :logging => false
)

Webrat.configure do |config|
  config.mode = :rack
  config.application_port = 4567
end

module TestHelper

  def app
    # change to your app class if using the 'classy' style
    # Sinatra::Application.new
    Main.new
  end

  def body
    last_response.body
  end

  def status
    last_response.status
  end

  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  def login_user(login, password)
    user = User.create(:login => login, :password => password)
    visit '/login'
    fill_in 'user_login',    :with => login
    fill_in 'user_password', :with => password
    click_button 'submit'
  end
end

require 'test/unit'
require 'shoulda'

Test::Unit::TestCase.send(:include, TestHelper)
