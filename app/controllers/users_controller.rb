class UsersController < ApplicationController

	before_action :authenticate_user!
	
	def styledata
		@userdata = Userdatum.find_by_userid(current_user.id)
		if @userdata
  			@userdata = JSON.parse @userdata.data
		end	
		
    @user = Identity.find_by_email(current_user.email)
    @fb_id = Identity.find_by(email: current_user.email, provider: 'facebook') 

    render 'stylelog-form'
	end
	
	def start
	   	if user_signed_in?
	   		# Get user with current users email id to get nick
	   		redirect_to '/style-log'
	   	else
	  		redirect_to '/users/sign_in'
	   	end
  	end

  	def savedata
  		puts params
  	end

  	def save
  		# Check if the user data exists and modify
  		# Else save the data
  		@userdata = Userdatum.find_by_userid(current_user.id)
  		if @userdata
  			# modify the data
  			@userdata.update_attributes(
  				:data => (params['user']).to_json,
  				:userid => current_user.id
  			)
  		else
  			@userdata = Userdatum.new(userdatum_params)
  			@userdata.save
  		end	

      # Send Email
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
  		
		# Never trust parameters from the scary internet, only allow the white list through.
	    def userdatum_params
	    	# Dig deep into how this works
	    	parameters = {
	    		:userid => current_user.id,
	    		:data => (params['user']).to_json
	    	}
	    end
end
