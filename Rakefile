require "rake"

namespace "vendor" do
  desc "Unpack gems into the vendor directory, usage: vendor:gem[some_gem]"
  task "gem", [:gem_name] do |t, args|
    mkdir 'vendor/gems' unless File.exists? "vendor/gems"
    
    `rm -rf vendor/gems/#{args[:gem_name]}*`

    `cd vendor/gems && gem fetch  #{args[:gem_name]}`
    `cd vendor/gems && gem unpack #{args[:gem_name]}*.gem`

    rm Dir["vendor/gems/#{args[:gem_name]}*.gem"]
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
