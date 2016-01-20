class RegistrationsController < Devise::RegistrationsController
  
  def create
    #Hack to create a identity on normal login
    identity = Identity.create(uid:rand(100000000..9999999999), provider: 'registration')
    identity.name = params['user']['name']
    identity.email = params['user']['email']
    identity.save
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

end