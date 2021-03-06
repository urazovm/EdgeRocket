require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class SystemAccessTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end

    Capybara.current_driver = :selenium
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "systems page can only be viewed while logged in as a sysop user" do
    visit "/system/surveys"
    assert_content page, "Forgot your password?"
  end

  test "systems page cannot be viewed by a user below sysop role" do
    account = FactoryGirl.create(:account, :company_name => 'ABC Co.')
    user = FactoryGirl.create(:user, :email => 'admin-test@edgerocket.co', :password => '12345678', :account_id => account.id)
    role = FactoryGirl.create(:role, :name => 'Admin', :user_id => user.id)

    visit app_path
    fill_in "user_email", with: 'admin-test@edgerocket.co'
    fill_in "user_password", with: '12345678'
    click_button 'Sign in'

    visit "/system/surveys"
    assert_no_content page, "Sysop"
  end

  test "systems page can be viewed by a user at sysop role level" do
    account = FactoryGirl.create(:account, :company_name => 'Sysop Co.')
    user = FactoryGirl.create(:user, :email => 'sysop-test@edgerocket.co', :password => '12345678', :account_id => account.id)
    role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => user.id)

    visit app_path
    fill_in "user_email", with: 'sysop-test@edgerocket.co'
    fill_in "user_password", with: '12345678'
    click_button 'Sign in'

    visit "/system/surveys"
    assert_content page, "Sysop Survey Page"
  end

end