class HomeController < ApplicationController
  #before_action :mobile_device
  
	def index
	  setImages
	end

	def campaign
	end
	
	def newuser
	  find_user = User.where("email = ?", params["email"]).first

	  if find_user != nil
	    redirect_to "/login" 
	  else
	   generated_password = Devise.friendly_token.first(8)
     user = User.create!(:email => params["email"], :password => generated_password)
     sign_in(:user, user)
     profile = Userprofile.create(
     {
        user_id: user.id,
        phonenumber: params['phone']
     }
     )
              
      user.userprofile_id = profile.id
      user.save
     UserMailer.welcome(user, generated_password).deliver
     redirect_to "/style-log"
	  end
	end
	
	
	private
	
	def setImages
	  if (mobile_device? == nil)
	    @slider1 = "/home-bg.jpg"
	    @slider2 = "/slider-2.jpg"
	    @slider3 = "/slider-3.jpg"
	      
	  else
	    @slider1 = "/mobile-slider-1.jpg"
      @slider2 = "/mobile-slider-2.jpg"
      @slider3 = "/mobile-slider-3.jpg"
	  end
	  
    
	end
	
	#TODO : Put this separately into a library
	def mobile_device?
   if session[:mobile_param]
     session[:mobile_param] == "1"
   else
     request.user_agent =~ /Mobile|webOS/
   end
end
end
