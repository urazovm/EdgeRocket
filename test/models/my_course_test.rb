require 'test_helper'

class MyCoursesTest < ActiveSupport::TestCase
  

 	test "courses per user" do
 		crs_user = MyCourse.courses_per_user(101)
     	assert !crs_user.nil?
  	end

  	test "completed course" do
 		mc = MyCourse.find(1050)
     	assert mc.completed?
    end

  	test "wishlist course with compl date" do
 		mc = MyCourse.find(1004)
     	assert !mc.completed?
    end

  	test "subscribe to courses" do
 		result = MyCourse.subscribe(101, 1004, 'reg', 'Self')
     	assert result==true

     	# try duplicate record
 		result = MyCourse.subscribe(101, 1004, 'reg', 'Self')
     	assert result==false
    end


end
