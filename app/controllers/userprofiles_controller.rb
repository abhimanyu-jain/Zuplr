class UserprofilesController < ApplicationController
  before_action :set_userprofile, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /userprofiles
  # GET /userprofiles.json
  def index
    @userprofiles = Userprofile.all
  end

  # GET /userprofiles/1
  # GET /userprofiles/1.json
  def show
  end

  # GET /userprofiles/new
  def new
    @userprofile = Userprofile.new
  end

  # GET /userprofiles/1/edit
  def edit
  end

  def welcomeuser
    render 'welcome'
  end

  def request_details
    if current_user
      render 'request_details'
    # if current_user.userprofile.phonenumber.nil? then render 'request_details' else redirect_to(root_path) end
    else
      redirect_to(root)
    end
  end

  def confirmation
    @userprofile = Userprofile.find_by_user_id(current_user.id)
    render 'info_confirmation'
  end

  def savenumber
    @user = User.find_by_email(current_user.email)
    @userprofile = Userprofile.find_by_user_id(current_user.id)

    if @userprofile
      @userprofile.update_attributes(
      :city=> params['user']['city'],
      :phonenumber => params['user']['phonenumber'])

      # Update user info also
      @user.update_attributes({
        :userprofile_id => @userprofile.id
      })
    else
      parameters = {
        :user_id => current_user.id,
        :city=> params['user']['city'],
        :phonenumber => params['user']['phonenumber']
      }
      @userprofile = Userprofile.new(parameters)
      @userprofile.save

      # Update user info also
      @user.update_attributes({
        :userprofile_id => @userprofile.id
      })
    end
  end

  def styledata
    @userprofile = Userprofile.find_by_user_id(current_user.id)
    if !@userprofile.nil? and !@userprofile.data.nil? and @userprofile.data != 'null'
      @userdata = JSON.parse @userprofile.data
    end

    # @user = User.find_by_email(current_user.email)
    # @identity = Identity.find_by_email(current_user.email)
    @fb_id = Identity.find_by(user_id: current_user.id, provider: 'facebook')

    #this is to set the name as Guest if the person isn't logged in. TODO : Take it out into global helper function and use it everywhere
    @name = if (@userprofile) then (@userprofile.name) else "Guest" end
    render 'stylelog-form'
  end

  # POST /userprofiles
  # POST /userprofiles.json
  def create
    #check to see if we are only saving or saving and proceeding to order as well
    proceed = params["save-and-order"]
    
    @userprofile = Userprofile.find_by_user_id(current_user.id)
    if @userprofile
      @userprofile.update_attributes(
      :data => (params['user']).to_json,
      :user_id => current_user.id
    )
    else
      @userprofile = Userprofile.new(userprofile_params)
    @userprofile.save
    end

    @identity = Identity.find_by_email(current_user.email)
    @user = User.find_by_email(current_user.email)

    # Update user also
    @user.update_attributes({
      :userprofile_id => @userprofile.id
    })

  # RegisterMailer.style_log_thanks(@identity).deliver_later

  # @userprofile = Userprofile.new(userprofile_params)

  # respond_to do |format|
  #   if @userprofile.save
  #     format.html { redirect_to @userprofile, notice: 'Userprofile was successfully created.' }
  #     format.json { render :show, status: :created, location: @userprofile }
  #   else
  #     format.html { render :new }
  #     format.json { render json: @userprofile.errors, status: :unprocessable_entity }
  #   end
  # end
    if proceed == nil
      redirect_to '/style-log', notice: 'Userprofile was successfully updated.'
    else
      redirect_to '/confirmation'
    end 
  end

  # PATCH/PUT /userprofiles/1
  # PATCH/PUT /userprofiles/1.json
  def update
    respond_to do |format|
      if @userprofile.update(userprofile_params)
        format.html { redirect_to @userprofile, notice: 'Userprofile was successfully updated.' }
        format.json { render :show, status: :ok, location: @userprofile }
      else
        format.html { render :edit }
        format.json { render json: @userprofile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /userprofiles/1
  # DELETE /userprofiles/1.json
  def destroy
    @userprofile.destroy
    respond_to do |format|
      format.html { redirect_to userprofiles_url, notice: 'Userprofile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_userprofile
    @userprofile = Userprofile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def userprofile_params
  #   params.require(:userprofile).permit(:data, :city, :phonenumber)
  # end

  def userprofile_params
    parameters = {
      :user_id => current_user.id,
      :data => (params['user']).to_json
    }
  end
end
