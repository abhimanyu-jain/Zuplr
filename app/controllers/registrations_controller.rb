class RegistrationsController < Devise::RegistrationsController

  # before_action :find_user_profile, only: [:edit, :update]
  #after_action :profile_create, :only => [:create] # Only for normal registration
  #after_action :identity_create, :only => [:create] # Only for normal registration

  def create
    user = User.find_by_email(params[:user][:email])
    #redirect_path = '/'
    if user == nil
      super
      identity_create
      saveUtmDataInUser
      profile_create
      profile_id  = @user.userprofile_id
      profile = Userprofile.find_by_id(profile_id)
     
     # if profile.try(:data) != nil
     #    redirect_path = '/confirmation'
     # else
     #    redirect_path = '/style-log' 
     # end
    else
      redirect_to "/login", :flash => { :alert => "Email already registered!" }
    end
    #redirect_path
  end

  # Create a identity for normal registered users
  def identity_create
    identity = Identity.create(uid:rand(100000000..9999999999), provider: 'registration')
    identity.user_id = resource.id
    identity.name = params['user']['name'] #Looks very ugly
    identity.email = resource.email
    identity.save
  end

  def profile_create
    @profile = Userprofile.create({ 
                  name: params['user']['name'],
                  phonenumber: params['user']['phone'] || '',
                  latest_status: 'Yet To Contact',
                  phone_number_status: 'Unverified',
                  data: cookies[:userprofile]
                })
                cookies.delete :userprofile
    @user.userprofile_id = @profile.id
    @user.save
  end
  
  def saveUtmDataInUser
    user = User.find_by_id(current_user.id)
    user.utm_source = cookies[:utm_source] || ''
    user.utm_campaign = cookies[:utm_campaign] || ''
    user.utm_medium = cookies[:utm_medium] || ''
    user.save
  end

  def edit
    @userprofile =  find_user_profile
    super
  end

  def update
    @userprofile = find_user_profile
    @userprofile.city = params[:user][:user_profile_city]
    @userprofile.phonenumber = params[:user][:user_profile_phone]
    @userprofile.save
    super
  end
  
  def update_resource(resource, params)
    if resource.encrypted_password.blank? # || params[:password].blank?
      resource.email = params[:email] if params[:email]
      if !params[:password].blank? && params[:password] == params[:password_confirmation]
        logger.info "Updating password"
        resource.password = params[:password]
        resource.save
      end
      if resource.valid?
        resource.update_without_password(params.except(:current_password))
      end
    else
      resource.update_with_password(params)
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

  private

   def find_user_profile
     user = User.find_by_id(current_user.id)
     profile_id  = user.userprofile_id
     Userprofile.find_by_id(profile_id)
   end
end
