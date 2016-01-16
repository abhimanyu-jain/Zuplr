class RegisterMailer < ApplicationMailer
	default from: "kjvenky@gmail.com"

	def welcome(user)
		@user = user
		mail(to: @user.email, subject: 'Welcome to Zuplr')
	end

	def style_log_thanks(user)
		@user = user
		mail(to: @user.email, subject: 'Thank you from Zuplr')		
	end
end
