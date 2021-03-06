class Account < ActiveRecord::Base
  has_many :users
  has_many :playlists
  has_many :products
  has_many :my_courses, through: :users

  def assigned_and_completed_by_user(page)

    final = [
      {name: "Assigned", data: {}, color: "green"},
      {name: "Completed", data: {}}
    ]

    page_of_users = get_page_of_users(page)

    page_of_users.each do |user|
      name = get_name_or_email(user)
      final[0][:data][name] = 0 if final[0][:data][name] == nil
      final[1][:data][name] = 0 if final[1][:data][name] == nil

      if user.my_courses.present?
        user.my_courses.each do |course|
          if course.completed?
            final[1][:data][name] += 1
          else
            final[0][:data][name] += 1
          end
        end
      end
    end
    final
    # byebug
  end

  private

  def get_page_of_users(page)
    page_length = 19
    page == 1 ? page_start = (page-1) * page_length : page_start = (page-1) * page_length + 1
    page_end = page * page_length

    current_users = users
    num_users = current_users.count

    if page_end < num_users
      page_of_users = users[page_start..page_end]
    else
      page_of_users = users[page_start..num_users-1]
    end
    page_of_users
  end

  def get_name_or_email(user)
    user.name.present? ? user.name : user.email
  end

end