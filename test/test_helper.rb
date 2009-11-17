require 'rubygems'
require 'sinatra'
require 'rack/test'

require File.join(File.dirname(__FILE__), '..', 'lib', 'main.rb')

Sinatra::Application.set(
  :environment => :test,
  :run => false,
  :raise_errors => true,
  :logging => false
)

module TestHelper
  
  def app
    # change to your app class if using the 'classy' style
    # Sinatra::Application.new
    Sinatra::Application.new
  end
  
  def body
    last_response.body
  end
  
  def status
    last_response.status
  end
  
  include Rack::Test::Methods

end

require 'test/unit'
require 'shoulda'

Test::Unit::TestCase.send(:include, TestHelper)
