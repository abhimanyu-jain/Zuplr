class UserMailer < ApplicationMailer
	default from: "care@zuplr.com"

	def registration(user)
		@user = user
		mail(to: @user.email, subject: 'Welcome to Zuplr')
	end

	def style_log_thanks(user)
		@user = user
		mail(to: @user.email, subject: 'Thank you from Zuplr')		
	end

	def admin_mailer(user)
		@user = user
		mail(to: 'kjvenky@gmail.com', subject: 'New User Signed up to Zuplr')		
	end

	def admin_form_filled(user)
		@user = user
		mail(to: 'kjvenky@gmail.com', subject: 'Userfilled the form')		
	end
end
