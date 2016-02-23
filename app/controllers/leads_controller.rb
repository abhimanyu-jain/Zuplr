class LeadsController < ApplicationController
	
	def index
		@leads = Lead.all
	end

	def create
		puts lead_params[:email]
#		@user = User.find_by_email_id(lead_params[:email])
		
		# Create User if User/Identity and  does not exist
#		if @user.nil?
			# @user = User.create(lead_params)
			# @identity = 
#		end

		# Send email

		# Register a lead
		@lead = Lead.new(lead_params)
   		@lead.save
   		render 'thanks'
	end

	private
	def lead_params
		params.require(:lead).permit!
	end
end
