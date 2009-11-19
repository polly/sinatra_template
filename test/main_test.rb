require File.join(File.dirname(__FILE__), '..', 'test', 'test_helper.rb')

class MainTest < Test::Unit::TestCase
  context "visit /" do
    should "display index properly" do
      visit "/"
      assert_contain "Hello from sinatra"
    end
  end
end
