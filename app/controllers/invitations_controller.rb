class InvitationsController < Devise::InvitationsController
 def create
  params[:user][:email].each do |email|
   User.invite!({:email => email}, current_user)
 end
 redirect_to root_path
end
end