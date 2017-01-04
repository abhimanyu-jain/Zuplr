class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter  :verify_authenticity_token
  # before_action :configure_permitted_parameters, if: :devise_controller?

  #before_action :check_if_user_provided_details, only: [:styledata, :index]

  def check_if_user_provided_details
    # This was to check if user had provided phonenumber when logging in. 
    # At that time, we were forcefully requiring users to give their number before continuing.
    # Note being used right now.
    if user_signed_in? 
      user_profile = Userprofile.find_by(id: current_user.userprofile_id)
      if (current_user.role.name == 'User' && user_profile.try(:phonenumber) == nil)
        redirect_to users_new_signup_path
      end
    end
  end

  # helper ApplicationHelper

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
    puts "after_sign_in_path_for"
    # Send email for signup
    @identity = Identity.find_by_email(current_user.email)
    user = User.find_by_id(current_user.id)
    profile_id  = user.userprofile_id
    profile = Userprofile.find_by_id(profile_id)
    # Yet another crude hack before we understand devise
    # if @identity
    #   if !@identity.mail_sent
    #     RegisterMailer.welcome(@identity).deliver_now
    #     RegisterMailer.admin_mailer(@identity).deliver_now

    #     @identity.mail_sent = 1
    #     @identity.save
    #   end
    # end

    #sign_in_url = new_user_session_url
    #if request.referer == sign_in_url
    #  super
    #else
      # Temporary hack always redirect to the stylelog after signup 
      #root_path || stored_location_for(resource) || request.referer
    #  stored_location_for(resource) || root_path
      # @userprofile = Userprofile.find_by_user_id(current_user.id)
       if profile.try(:data) == nil && cookies[:userprofiles] == nil
         '/style-log'
       else
         '/confirmation'
       end
   # end
  end

  def after_invite_path_for(resource)
    root_path
  end
  
  def authenticate_admin
    if current_user == nil
      redirect_to :root
    return
    end
    user = User.find_by_id(current_user.id)
    if user.role.name == 'User'
      redirect_to :root
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
