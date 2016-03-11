class RegisterMailer < ApplicationMailer
	default from: "care.zuplr@gmail.com"

	def welcome(user)
		@user = user
		mail(to: @user.email, subject: 'Welcome to Zuplr')
		# Send extra mails to admin
	end

	def style_log_thanks(user)
		@user = user
		mail(to: @user.email, subject: 'Thank you from Zuplr')		
	end

	def admin_mailer(user)
		@user = user
		mail(to: 'neelam.nniroula@gmail.com', cc: ['kjvenky@gmail.com','shkartik90@gmail.com'], subject: 'New User Signed up to Zuplr')		
	end

	def admin_form_filled(user)
		@user = user
		mail(to: 'neelam.nniroula@gmail.com', cc: ['kjvenky@gmail.com','shkartik90@gmail.com'], subject: 'Userfilled the form')		
	end
end
