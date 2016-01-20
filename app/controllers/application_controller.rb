class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter  :verify_authenticity_token
  # before_action :configure_permitted_parameters, if: :devise_controller?

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  def after_sign_in_path_for(resource)
    # Send email for signup
    @identity = Identity.find_by_email(current_user.email)
    
    # Yet another crude hack before we understand devise
    if !@identity.mail_sent
      # Send mail to user and admins
      RegisterMailer.welcome(@identity).deliver_later
      RegisterMailer.admin_mailer(@identity).deliver_later

      @identity.mail_sent = 1
      @identity.save
    end

    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      # Temporary hack always redirect to the stylelog after signup 
      # root_path || stored_location_for(resource) || request.referer
      '/style-log'
    end
  end

end

