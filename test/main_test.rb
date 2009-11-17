require File.join(File.dirname(__FILE__), '..', 'test', 'test_helper.rb')

class MainTest < Test::Unit::TestCase

  context "main" do
    context "GET /" do
      setup do
        get '/'
      end
      
      should "be successfull" do
        assert_equal status, 200
      end

      should "have a body" do
        assert body.include? "Hello from sinatra"
      end
    end
  end
end
