APP_ROOT = File.expand_path(File.dirname(__FILE__))

Dir["vendor/sinatra/*/lib/"].each { |dir| $:.unshift(File.join(APP_ROOT, dir)) }
Dir["vendor/gems/*/lib/"].each do |dir| 
  $:.unshift(File.join(APP_ROOT, dir))
  require Dir[File.join(APP_ROOT, dir, "*.rb")][0]
end

require 'sinatra'

$:.unshift File.join(APP_ROOT, 'lib')
$:.unshift File.join(APP_ROOT, 'public')

set :views,  APP_ROOT + '/views'
set :public, APP_ROOT + '/public'

require 'main'
