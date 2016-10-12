class HomeController < ApplicationController
  #before_action :mobile_device
  
	def index
	  setImages
	  setUtmCookies
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
     flash[:notice] = ""
     redirect_to "/style-log"
	  end
	end
	
	
	private
	
	def setUtmCookies
	 cookies[:utm_source] = params[:utm_source]
   cookies[:utm_campaign] = params[:utm_campaign]
   cookies[:utm_medium] = params[:utm_medium]  
	end
	
	def setImages
	  @mobile = mobile_device?
	  if (@mobile == nil)
	    @slider1 = "/web_1.jpg"
	    @slider2 = "/web_2.jpg"
	    @slider3 = "/web_3.jpg"
      @slider4 = "/web_4.jpg"
      @slider5 = "/web_5.jpg"
      @slider6 = "/web_6.jpg"
	  else
	    @slider1 = "/mobile-slider-1.jpg"
      @slider2 = "/mobile-slider-2.jpg"
      @slider3 = "/mobile-3.png"
      @slider4 = "/mobile-slider-1.jpg"
      @slider5 = "/mobile-slider-2.jpg"
      @slider6 = "/mobile-3.png"
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
