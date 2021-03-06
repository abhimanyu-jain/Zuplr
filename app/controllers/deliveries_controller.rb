class DeliveriesController < ApplicationController
  def index
  end

  def show
  end

  def create
  	@delivery = Delivery.new(delivery_params)
    @userprofile = Userprofile.find(current_user.id)
    @delivery.update_attributes(
      :user_id => current_user.try(:id),
      :status => 'REQUESTED',
      :session_number => Random.new.rand(1000..1000000000),
      :city => 'Bangalore',
      :address1 => '',
      :address2 => '',
      :phonenumber => @userprofile.phonenumber,
      :delivery_date => ''
      )
    
    respond_to do |format|
      if @delivery.save
        format.html { redirect_to @delivery, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @delivery }
      else
        format.html { render :new }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  def thanks
  end

  private
  def delivery_params
  	params.require(:delivery).permit!
    puts Delivery.created
  	del_params = {
  		'user_id' => current_user.id,
  		'delivery_date' => params['delivery']['delivery_date'],
  		'address1' => params['delivery']['address1'],
  		'address2' => params['delivery']['address2'],
  		'pincode' => params['delivery']['pincode'],
  		'city' => params['delivery']['city'],
      'session_number' => 'SESS'+'',
      'status' => Delivery.statuses[:created]
  	} 
  end
end
