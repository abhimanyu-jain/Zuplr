class OrdersController < ApplicationController
  before_action :set_order, only: [:index, :show]
  before_action :authenticate_user!
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.select("orders.*, SUM(order_items.selling_price) as box_price")
    .joins("JOIN order_items on orders.id = order_items.order_id")
    .where("orders.user_id = ?", String(current_user.try(:id)))
    .includes(:order_items)

    if @orders == nil
      redirect_to "/style-log"
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order_status_history = OrderStatusHistory.where(order_id: @order.id)
    @order_item_categories = OrderItem.select("product_categories.name, count(product_categories.name) as count")
    .joins("JOIN variants on order_items.variant_id = variants.id")
    .joins("JOIN products on variants.product_id = products.id")
    .joins("JOIN product_categories  on products.product_category_id = product_categories.id ")
    .where("order_items.order_id = ?", @order.id).distinct.group("product_categories.name")

    @invoice_amount = OrderItem.sum(:selling_price, :conditions =>  {:order_id => @order.id})

    @items = OrderItem.select("products.* , order_items.*")
    .joins("JOIN variants on order_items.variant_id = variants.id")
    .joins("JOIN products on variants.product_id = products.id")
    .where("order_items.order_id = ?", @order.id)

    @display_items_data = ['RETURN BOOKED', 'PICKUP COMPLETED', 'COMPLETED'].include? @order.status
  end

  # GET /orders/:id/feedback
  def get_feedback
    @order = Order.find_by_order_code(params[:id])

    if (@order.status != 'DELIVERED')
      redirect_to '/orders/'+params[:id]
    else
      @items = OrderItem.select("products.title, products.description, order_items.id, order_items.selling_price")
    .joins("JOIN variants on order_items.variant_id = variants.id")
    .joins("JOIN products on variants.product_id = products.id")
    .where("order_items.order_id = ?", @order.id)

      render 'user_feedback'
    end
  end

  def save_feedback
    items = params[:order_item]

    items.each do |item, nothing|
      size_feedback = item[:size_feedback][item[:id]]
      price_feedback = item[:price_feedback][item[:id]]
      fit_cut_feedback = item[:fit_cut_feedback][item[:id]]
      style_feedback = item[:style_feedback][item[:id]]
      customer_comments = item[:customer_comments]
      accept = -1
      if item[:accept] == nil
      then accept = 0
      else accept = 1
      end
      oi = OrderItem.find(item[:id])
      user_id = oi.order.user_id
      if(current_user.id != user_id)
        redirect_to request.referer
      else
      oi.size_feedback = size_feedback
      oi.price_feedback = price_feedback
      oi.fit_cut_feedback = fit_cut_feedback
      oi.style_feedback = style_feedback
      oi.customer_comments = customer_comments
      oi.kept = accept
      oi.save
      end
    end

    # Find associated order
    oi = OrderItem.find(items[0][:id])
    order = Order.find(oi.order_id)
    order.status = "RETURN BOOKED"
    order.save

    #Adding to status history
    order_status_history = OrderStatusHistory.new
    order_status_history.order_id = order.id
    order_status_history.status = "RETURN BOOKED"
    order_status_history.save
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

    #Send notification email to stylist
    UserMailer.order_notification(@userprofile.name, @userprofile.phonenumber, @userprofile.data.to_json)

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
    @order = Order.find_by_order_code(params[:id])

  #if(current_user == nil || @order == nil || @order.user_id != current_user.id)
  #redirect_to '/'
  #end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.permit(:scheduleddeliverydate, :call_date_time, :promo_code)
  end
end
