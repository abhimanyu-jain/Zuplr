class UsersController < ApplicationController

	before_action :authenticate_user!, :except => [:leads]
	load_and_authorize_resource

    def leads
    end
  
    def index
        @users = User.includes(:role, :userprofile)
    end

    def show
    end 

    def new
    end

    def start_chat
      @conv = Conversation.create(sender_id: current_user.id, receiver_id: 1)
      @conv.save
      redirect_to conversation_messages_path(@conv)
    end

    def destroy
        @user.destroy
        respond_to do |format|
            format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def start
        if user_signed_in?
            redirect_to '/style-log'
        else
            redirect_to '/users/sign_in'
        end
    end

    def styledata
        @userdata = Userdatum.find_by_user_id(current_user.id)
        if !@userdata.nil? and !@userdata.data.nil?
            @userdata = JSON.parse @userdata.data
        end	
        @user = Identity.find_by_email(current_user.email)
        @fb_id = Identity.find_by(email: current_user.email, provider: 'facebook') 
        render 'stylelog-form'
    end

    def justin
      render 'justin'
    end

    def savenumber
        @userdata = Userdatum.find_by_user_id(current_user.id)
        @user = User.find_by_email(current_user.email)

        if @userdata
            @userdata.update_attributes(
                :city=> params['user']['city'],
                :phonenumber => params['user']['phonenumber'])

             # Update user info also
            @user.update_attributes({
                :userdatum_id => @userdata.id
                })
        else
            parameters = {
                :user_id => current_user.id,
                :city=> params['user']['city'],
                :phonenumber => params['user']['phonenumber']
            }
            @userdata = Userdatum.new(parameters)
            @userdata.save

            # Update user info also
            @user.update_attributes({
                :userdatum_id => @userdata.id
                })
         end
    end


    def save
        @userdata = Userdatum.find_by_user_id(current_user.id)
        if @userdata
            @userdata.update_attributes(
                :data => (params['user']).to_json,
                :user_id => current_user.id
                )
        else
            @userdata = Userdatum.new(userdatum_params)
            @userdata.save
        end	
        @user = Identity.find_by_email(current_user.email)
        # RegisterMailer.style_log_thanks(@user).deliver_later
        # RegisterMailer.admin_form_filled(@user).deliver_later
       render 'thank-you'
    end

    def deliver
      @delivery = Delivery.new(delivery_params)
      @delivery.save
    end

    def invite
      User.invite!(:email => "Ounly1984@einrot.com", :name => "John Doe")
    end

private

    def delivery_params
        params.require(:delivery).permit!
    end

    def user_params
        params.permit!
    end

    def userdatum_params
        parameters = {
            :user_id => current_user.id,
            :data => (params['user']).to_json
        }
    end
end
