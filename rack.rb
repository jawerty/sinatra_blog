require 'rubygems'
require 'rack'

class HelloWorld
  def call(env)
    [200, {"Content-Type" => "text/html"}, "Hello Rack!"}]
  end
end

puts "Rack server running on port 9292"
Rack::Handler::Mongrel.run HelloWorld.new, :Port => 9292