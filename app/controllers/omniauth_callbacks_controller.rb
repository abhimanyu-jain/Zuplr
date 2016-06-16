class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def profile_create(user)
    @profile = Userprofile.create({ user_id: resource.id, name: user.name })
    @user.userprofile_id = @profile.id
    @user.save
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
      @profile = Userprofile.find_by_user_id(@identity.user_id) 
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
end

    