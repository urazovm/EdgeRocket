require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  before :each do
    @user = User.new
    @user.email = 'test@EdgeRocket.co'
    @user.password = 'password'
    @user.id = 1
    @user.save!

    Survey.create!(
      preferences: '{"skills"=>[{"id"=>"seo"}, {"id"=>"cs"}, {"id"=>"computer_networking"}], "user_home"=>{"skills"=>[{"id"=>"seo"}, {"id"=>"cs"}, {"id"=>"computer_networking"}]}}'.to_json,
      user_id: @user.id
    )
    @product = Product.new
    @product.name = 'new course'
    @pl = Playlist.new
    @pl.title = 'test pl 1'
  end

  test "playlist_course_added" do
    mail = Notifications.playlist_course_added @user, @pl, @product, 'http://localhost'
    assert_equal "New course has been added to your EdgeRocket playlist", mail.subject
  end

  test "survey completed" do
    mail = Notifications.survey_completed(@user).deliver
    assert_equal "A new survey has been completed by test@edgerocket.co!", mail.subject
  end

end
