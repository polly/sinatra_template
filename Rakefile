require "rake"
require "rake/testtask"

namespace "vendor" do
  desc "Unpack gems into the vendor directory, version is optional"
  task "gem", [:name, :version] do |t, args|
    name, version = args[:name], args[:version]
    
    find_or_create_directory "vendor/gems"
    cleanup_vendor           "gems/#{name}*"
    fetch_and_unpack         "vendor/gems", name, version
    cleanup_vendor           "gems/#{name}*.gem"
  end
end

namespace "freeze" do
  desc "Freeze sinatra"
  task "sinatra" do
    find_or_create_directory 'vendor/sinatra'

    cleanup_vendor "sinatra/rack*"
    cleanup_vendor "sinatra/sinatra*"

    fetch_and_unpack "vendor/sinatra", "rack"
    fetch_and_unpack "vendor/sinatra", "sinatra"

    cleanup_vendor "sinatra/rack*.gem"
    cleanup_vendor "sinatra/sinatra*.gem"
  end
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end


private

def find_or_create_directory(dir)
  mkdir dir unless File.exists? dir
end

def cleanup_vendor(name)
  `rm -rf vendor/#{name}`
end

def fetch_and_unpack(dir, name, version=nil)
  if version
    `cd #{dir} && gem fetch  #{name} -v #{version}`
  else
    `cd #{dir} && gem fetch  #{name}`
  end

  `cd #{dir} && gem unpack #{name}*.gem`
end
