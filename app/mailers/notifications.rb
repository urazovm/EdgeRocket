class Notifications < ActionMailer::Base
  default from: "support@edgerocket.co"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.playlist_course_added.subject
  #
  def playlist_course_added(user, playlist, product, hostname)
    #byebug
    @user = user
    @playlist = playlist
    @product = product
    @hostname = hostname
    @greeting = "New course has been added to your EdgeRocket playlist"

    mail to: @user.email, subject: @greeting
  end

  def survey_completed(user)
    @email = user.email
    @survey_json = user.survey.preferences
    @greeting = "A new survey has been completed by #{@email}!"

    mail to: 'support@edgerocket.co', subject: @greeting
  end

  def account_requested(pending_user)
    @email = pending_user.email
    @first_name = pending_user.first_name
    @subject = "Account request has been received"

    mail to: @email, subject: @subject
  end

  def account_request_received(pending_user, hostname)
    @pending_user_email = pending_user.email
    @pending_user_name = "#{pending_user.first_name} #{pending_user.last_name}"
    @hostname = hostname
    @subject = "A new self sign-up account has been requested"

    mail to: 'support@edgerocket.co', subject: @subject
  end

  def account_confirmation_email(user, hostname, generated_password, account_type)
    @user = user
    @hostname = hostname
    @generated_password = generated_password
    
    #byebug
    
    @sign_in_path = '/users/sign_in'
    if !account_type.blank?
      @sign_in_path += '?type=' + account_type
    end

    mail to: @user.email, subject: 'Welcome to EdgeRocket!'

  end

  def admin_adds_user_email(user, hostname)
    @user = user
    @hostname = hostname
    mail to: @user.email, subject: 'Welcome to EdgeRocket!'
  end

  def send_recommendations(user, hostname, skills)
    @user = user
    @hostname = hostname
    @skills = skills
    mail to: @user.email, subject: "EdgeRocket Recommendations"
  end

  def course_assigned(user, product, hostname)
    @user = user
    @product = product
    @hostname = hostname
    @greeting = "A manager has assigned you a new course"

    mail to: @user.email, subject: @greeting
    
  end
end
