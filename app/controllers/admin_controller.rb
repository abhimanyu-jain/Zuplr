class AdminController < ApplicationController
  def index
    @allusers = User.select('*').joins('JOIN userprofiles on users.id = userprofiles.user_id')
  end
  
  def getuserprofile
    @user = User.select('*').joins('JOIN userprofiles on users.id = userprofiles.user_id where users.id = '+params[:id])
  end
end
