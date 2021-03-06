require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class SystemPendingUser < Capybara::Rails::TestCase
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

  test "system can view the page and it has records" do

    account = create_account
    @user = create_user(account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    @pending_user = FactoryGirl.create(:pending_user, first_name: "Jimi", last_name: "Hendrix", company_name: "EdgeRocket", email: "jimihendrix@edgerocket.co", encrypted_password: "password", user_type: "Free")
    visit app_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'

    visit "/system/pending_users"
    assert_content page, "Hendrix, Jimi"
  end

  test "pending user will be removed from pending users and a user will be created" do

    account = create_account
    @user = create_user(account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    @pending_user = FactoryGirl.create(:pending_user, first_name: "Jimi", last_name: "Hendrix", company_name: "EdgeRocket", email: "jimihendrix@edgerocket.co", encrypted_password: "password", user_type: "Free")
    visit app_path

    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Sign in'

    visit "/system/pending_users"
    find(".glyphicon-ok").click
    assert_no_content page, "Hendrix, Jimi"
    assert_content page, "The pending user has been approved."

  end
end
