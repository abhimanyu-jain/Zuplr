class UsersController < ApplicationController

	before_action :authenticate_user!
	
	def styledata
		render 'stylelog-form'
	end
	
	def start
   	if user_signed_in?
   		redirect_to '/style-log'
   	else
  		redirect_to '/users/sign_in'
   	end
  end
end
