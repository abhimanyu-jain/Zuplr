class RegistrationsController < Devise::RegistrationsController

  # before_action :find_user_profile, only: [:edit, :update]
  after_action :profile_create, :only => [:create] # Only for normal registration
  after_action :identity_create, :only => [:create] # Only for normal registration

  def create
    super
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
                  user_id: resource.id,
                  name: params['user']['name'],
                  phonenumber: params['user']['phone'] || ''
                })
    @user.userprofile_id = @profile.id
    @user.save
  end

  def edit
    @userprofile = Userprofile.find_by_id resource.id
    super
  end

  def update
    @userprofile = Userprofile.find_by_user_id resource.id
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
        resource.update_without_password(params)
      end
    else
      resource.update_with_password(params)
    end
  end

  private

  # def find_user_profile
  #   @userprofile = Userprofile.find_by(user_id: current_user.id)
  # end
end
