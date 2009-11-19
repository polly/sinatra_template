require "rake"
require "rake/testtask"

namespace "vendor" do
  desc "Unpack gems into the vendor directory, version is optional"
  task "gem", [:name, :version] do |t, args|
    name, version = args[:name], args[:version]
    
    find_or_create_directory "vendor/gems"
    cleanup                  "#{name}*"
    fetch_and_unpack         name, version
    cleanup                  "#{name}*.gem"
  end
end

namespace "freeze" do
  desc "Freeze sinatra"
  task "sinatra" do
    mkdir 'vendor/sinatra' unless File.exists? "vendor/sinatra"
    mkdir 'vendor/sinatra' unless File.exists? "vendor/sinatra"

    `rm -rf vendor/sinatra/rack*`
    `rm -rf vendor/sinatra/sinatra*`

    `cd vendor/sinatra && gem fetch rack`
    `cd vendor/sinatra && gem unpack rack*.gem`
    `cd vendor/sinatra && gem fetch  sinatra`
    `cd vendor/sinatra && gem unpack sinatra*.gem`

    rm Dir["vendor/sinatra/rack*.gem"]
    rm Dir["vendor/sinatra/sinatra*.gem"]
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

def cleanup(name)
  `rm -rf vendor/gems/#{name}`
end

def fetch_and_unpack(name, version)
  if version
    `cd vendor/gems && gem fetch  #{name} -v #{version}`
  else
    `cd vendor/gems && gem fetch  #{name}`
  end

  `cd vendor/gems && gem unpack #{name}*.gem`
end
