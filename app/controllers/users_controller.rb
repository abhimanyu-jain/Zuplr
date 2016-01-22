class UsersController < ApplicationController

	before_action :authenticate_user!
	
	def styledata
		@userdata = Userdatum.find_by_userid(current_user.id)
    if @userdata.data
      @userdata = JSON.parse @userdata.data
    end	

    @user = Identity.find_by_email(current_user.email)
    @fb_id = Identity.find_by(email: current_user.email, provider: 'facebook') 
    render 'stylelog-form'
  end

  def justin
    render 'justin'
  end
  
  def savenumber
    @userdata = Userdatum.find_by_userid(current_user.id)
    if @userdata
      @userdata.update_attributes(
        :city=> params['user']['city'],
        :phonenumber => params['user']['phonenumber'])
    else
      parameters = {
        :userid => current_user.id,
        :city=> params['user']['city'],
        :phonenumber => params['user']['phonenumber']
      }
      @userdata = Userdatum.new(parameters)
      @userdata.save
    end
  end

  def start
    if user_signed_in?
      redirect_to '/style-log'
    else
      redirect_to '/users/sign_in'
    end
  end

  def savedata
    puts params
  end

  def save
    @userdata = Userdatum.find_by_userid(current_user.id)
    if @userdata
     @userdata.update_attributes(
      :data => (params['user']).to_json,
      :userid => current_user.id
      )
   else
     @userdata = Userdatum.new(userdatum_params)
     @userdata.save
   end	

   @user = Identity.find_by_email(current_user.email)

   RegisterMailer.style_log_thanks(@user).deliver_later
   RegisterMailer.admin_form_filled(@user).deliver_later

   render 'thank-you'
  end

  def deliver
    @delivery = Delivery.new(delivery_params)
    @delivery.save
  end

  private

  def delivery_params
    params.require(:delivery).permit!
  end

  def user_params
   params.permit!
  end

  def userdatum_params
    parameters = {
     :userid => current_user.id,
     :data => (params['user']).to_json
   }
  end
end
