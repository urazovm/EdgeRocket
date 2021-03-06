require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class ManageCoursesTest < Capybara::Rails::TestCase
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

  test "List courses and add new" do

    @account = FactoryGirl.create(:account, :company_name => 'ABC Co.')
    @user = FactoryGirl.create(:user, :email => 'admin-test@edgerocket.co', :password => '12345678', :account_id => @account.id)
    @role = FactoryGirl.create(:role, :name => 'Admin', :user_id => @user.id)

    visit app_path
    fill_in "user_email", with: 'admin-test@edgerocket.co'
    fill_in "user_password", with: '12345678'
    click_button 'Sign in'

    # Add a playlits to use it later
    visit '/playlists'
    assert_content page, "Mandatory"
    click_button 'Add Playlist'
    fill_in "newTitle", with: 'New Playlist Title Test'
    click_button 'Create'
    click_button 'Add Playlist'
    fill_in "newTitle", with: 'New Playlist 2'
    click_button 'Create'

    visit '/products/curated'
    assert_content page, "Course Title"
    assert_content page, "Provider"
    click_button 'Add Item'
    fill_in "newTitle", with: 'New Product Title Test'
    select "New Playlist Title Test", :from => 'selectPlaylists'
    click_button 'Create'
    assert_content page, 'New Product Title Test'
    #sleep 1000

  end


  test "Courses in sysop mode" do

    account = create_account
    @user = create_user(account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)

    visit app_path
    fill_in "user_email", with: 'sysop-test@edgerocket.co'
    fill_in "user_password", with: '12345678'
    click_button 'Sign in'

    visit '/products/curated'
    assert_content page, "Course Title"
    assert_content page, "Provider"
    click_button 'Add Item'
    fill_in "newTitle", with: 'New Product Sysop'
    select "ABC Co.", :from => 'selectAccounts'
    click_button 'Create'
    #assert_content page, 'New Product Sysop'
    #sleep 1000

  end
end
