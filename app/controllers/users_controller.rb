class UsersController < ApplicationController

	before_action :authenticate_user!
	
	def styledata
		@user = Identity.find_by_email(current_user.email)
		@userdata = Userdatum.find_by_userid(current_user.id)
		puts @userdata
		if @userdata
  			@userdata = JSON.parse @userdata.data
		end	
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
  			puts "Modifying the data"
  			@userdata.update_attributes(
  				:data => (params['user']).to_json,
  				:userid => current_user.id
  			)
  		else
  			puts "Saving the data"
  			@userdata = Userdatum.new(userdatum_params)
  			@userdata.save
  		end	
  		render 'thank-you'
  	end

  	private 
  		def user_params
  			params.permit!
  		end
  		
		# Never trust parameters from the scary internet, only allow the white list through.
	    def userdatum_params
	    	# Dig deep into how this works
	    	puts "Printing user params"
	    	parameters = {
	    		:userid => current_user.id,
	    		:data => (params['user']).to_json
	    	}
	    end
end
