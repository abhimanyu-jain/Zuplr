class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def profile_create(user)
    @profile = Userprofile.create({ name: user.name })
    @user.userprofile_id = @profile.id
    @user.save
    
    if(cookies[:userprofile])
       @profile.update_attributes(
        :data => cookies[:userprofile] || ''
        )
      @profile.save
      cookies.delete :userprofile
    end
    
  end

  def facebook
    generic_callback( 'facebook' )
  end

  def google_oauth2
    generic_callback( 'google_oauth2' )
  end

  def generic_callback( provider )
    @identity = Identity.find_for_oauth env["omniauth.auth"]
    @user = @identity.user || current_user || User.find_by_email(@identity.email)

    if @user.nil?
      @user = User.create( email: @identity.email || "" )
      @identity.update_attribute( :user_id, @user.id )
    end

    if @user.email.blank? && @identity.email
      @user.update_attribute( :email, @identity.email)
    end

    if @user.persisted?
      @identity.update_attribute( :user_id, @user.id )
      userprofile_id = @user.userprofile_id
      if userprofile_id != nil
        @profile = Userprofile.try(:find, userprofile_id)
      end
      profile_create(@identity) if @profile.nil?
      # This is because we've created the user manually, and Device expects a
      # FormUser class (with the validations)
      @user = FormUser.find @user.id
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  protected

  def after_sign_up_path_for(resource)
      # This is the point where user has been signed up but his/her profile has not been created yet. So we have to check cookies.
      if cookies[:userprofile] != nil
         '/confirmation'
      else
         '/style-log' 
      end
  end

end

    