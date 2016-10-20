class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.where("user_id = ?", String(current_user.try(:id)))

    if @orders == nil
      redirect_to "/style-log"
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    address = params["address"]
    phone = params["phone"]
    pincode = params["pincode"]
    stylist_comments = params["comments"]
    call_date_time = Date.strptime(params["calldate"], "%m/%d/%Y")
    promo_code = params["promo_code"]

    @userprofile = Userprofile.find_by_id(current_user.userprofile_id)
    @userprofile.update_attributes(
    :address => address,
    :phonenumber => phone,
    :pincode => pincode
    )

    @order = Order.new(order_params)
    @order.update_attributes(
    :user_id => current_user.try(:id),
    :status => 'REQUESTED',
    :order_code => Random.new.rand(1000..1000000000),
    #:scheduleddeliverydate => Date.strptime(params["scheduleddeliverydate"], "%m/%d/%Y").strftime("%Y-%m-%d"),
    :stylist_comments => stylist_comments,
    :call_date_time => call_date_time,
    :promo_code => promo_code
    )

    contact_log_entry = ContactLog.new(:contact_date => call_date_time, :notes => "Initial Call Date Specified by Customer", :order_id => @order.id)
    contact_log_entry.save

    #Adding to status history
    order_status_history = OrderStatusHistory.new
    order_status_history.order_id = @order.id
    order_status_history.status = @order.status
    order_status_history.save

    respond_to do |format|
      if @order.save
        format.html { render json: @order, notice: 'Thank You for Ordering with Zuplr.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.permit(:scheduleddeliverydate, :call_date_time, :promo_code)
  end
end
