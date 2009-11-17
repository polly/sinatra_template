APP_ROOT = File.expand_path(File.dirname(__FILE__))

require 'rubygems'

Dir["vendor/sinatra/*/lib/"].each { |dir| $:.unshift(File.join(APP_ROOT, dir)) }
Dir["vendor/gems/*/lib/"].each do |dir| 
  $:.unshift(File.join(APP_ROOT, dir))
  require Dir[File.join(APP_ROOT, dir, "*.rb")][0]
end

$:.unshift File.join(APP_ROOT, 'lib')
$:.unshift File.join(APP_ROOT, 'public')

require 'sinatra'
require 'main'
