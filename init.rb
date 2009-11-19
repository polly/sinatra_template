APP_ROOT = File.expand_path(File.dirname(__FILE__))

Dir["vendor/sinatra/*/lib/"].each { |dir| $:.unshift(File.join(APP_ROOT, dir)) }
Dir["vendor/gems/*/lib/"].each do |dir| 
  $:.unshift(File.join(APP_ROOT, dir))

  path = Dir[File.join(APP_ROOT, dir, "*.rb")][0]
  require path unless path.nil?
end

require 'sinatra/base'
require 'sinatra/session_auth'


$:.unshift models = File.join(APP_ROOT, "lib", "models")

Dir[File.join(models, "*.rb")].each { |file| require file unless file.nil? }

$:.unshift File.join(APP_ROOT, 'lib')
$:.unshift File.join(APP_ROOT, 'public')

require File.join(APP_ROOT, 'config', 'environment')
require File.join(APP_ROOT, 'config', 'environments', 'development')
require File.join(APP_ROOT, 'config', 'environments', 'test')
require File.join(APP_ROOT, 'config', 'environments', 'production')

Sinatra::Application.set(
  :run    => false 
)

require 'main'
