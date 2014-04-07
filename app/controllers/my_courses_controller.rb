class MyCoursesController < ApplicationController
  before_filter :authenticate_user!

  def index
    u = User.find_by_email(current_user.email)
    @my_courses = u.products
  end
end
