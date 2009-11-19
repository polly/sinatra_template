require File.join(File.dirname(__FILE__), '..', 'test', 'test_helper.rb')

class MainTest < Test::Unit::TestCase
  def before
    User.delete_all
  end

  context "visit /" do
    should "display index properly" do
      visit "/"
      assert_contain "Hello from sinatra"
    end
  end

  context "visit /protected as an unregistered user" do
    should "require login" do
      visit "/protected"
      assert_contain "You must be logged in to view this page."
    end
  end


  context "visit /protected as a registered user" do
    should "render page properly" do
      login_user('polly', '1234')

      visit "/protected"
      assert_contain 'Protected Action'
    end
  end

  context "visit /signup" do
    should "allow a user to create an account" do
      visit "/signup"
      fill_in "user[login]",    :with => "test"
      fill_in "user[email]",    :with => "test@test.com"
      fill_in "user[password]", :with => "test"
      click_button "submit"
      assert_contain "Your account was succesfully created"
    end
  end
end
