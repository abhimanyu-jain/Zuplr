class AdminController < ApplicationController

  before_action :authenticate_admin
  def index
    @allusers = User.select('*').joins('JOIN userprofiles on users.userprofile_id = userprofiles.id')

    if(params[:email] != 'All' && params[:email] != nil && params[:email] != "")
      @allusers = @allusers.where(email: params[:email])
    end
    if(params[:phone] != 'All' && params[:phone] != nil && params[:phone] != "")
      @allusers = @allusers.where('userprofiles.phonenumber' => params[:phone])
    end
    if(params[:phone_number_status] != 'All' && params[:phone_number_status] != nil)
      @allusers = @allusers.where('userprofiles.phone_number_status' => params[:phone_number_status])
    end
    if(params[:gender] != 'All' && params[:gender] != nil)
      @allusers = @allusers.where('userprofiles.gender' => params[:gender])
    end
    if(params[:latest_status] != 'All' && params[:latest_status] != nil)
      @allusers = @allusers.where('userprofiles.latest_status' => params[:latest_status])
    end

    @allusers = @allusers.order('users.created_at DESC')

    @allusers = @allusers.paginate(:page => params[:page], :per_page => 30)
  end

  def getuserprofile
    @user = User.select('*').joins('JOIN userprofiles on users.userprofile_id = userprofiles.id where users.userprofile_id = '+params[:id])
    render 'getuserprofile'
  end

  def getallorders
    @orders = Order.select('orders.id, orders.order_code, orders.created_at, orders.updated_at, orders.status, orders.scheduleddeliverydate, orders.call_date_time,
    orders.stylist_comments, users.userprofile_id, userprofiles.name, userprofiles.phonenumber, userprofiles.address, userprofiles.pincode, users.email').
    joins('JOIN users on users.id = orders.user_id').joins('JOIN userprofiles on users.userprofile_id = userprofiles.id').order('orders.created_at DESC')

    if(params[:email] != 'All' && params[:email] != nil && params[:email] != "")
      @orders = @orders.where('users.email' => params[:email])
    end
    if(params[:phone] != 'All' && params[:phone] != nil && params[:phone] != "")
      @orders = @orders.where('userprofiles.phonenumber' => params[:phone])
    end
    if(params[:status] != 'All' && params[:status] != nil)
      @orders = @orders.where('orders.status' => params[:status])
    end
    if(params[:created_on] != 'All' && params[:created_on] != nil && params[:created_on] != "")
      @orders = @orders.where('orders.created_at' => params[:created_on])
    end
    if(params[:updated_at] != 'All' && params[:updated_at] != nil && params[:updated_at] != "")
      @orders = @orders.where('orders.updated_at' => params[:updated_at])
    end
    if(params[:call_date] != 'All' && params[:call_date] != nil && params[:call_date] != "")
      selected_date = Date.strptime(params[:call_date], "%m/%d/%Y")
      @orders = @orders.where(
      ['orders.call_date_time >= ? AND orders.call_date_time <= ?', 
        selected_date.in_time_zone(Time.zone).beginning_of_day, #HACK : For some reason, active record is converting selected_date to UTC time, which means the time shifts back by 5 hours 30 minutes. Had to treat it as UTC for it to work.
        selected_date.in_time_zone(Time.zone).end_of_day
        ]
      )
    end

    @orders = @orders.paginate(:page => params[:page], :per_page => 30)

    render 'all_orders'
  end

  def getpendingorders
    @orders = Order.select('orders.id, orders.order_code, orders.created_at, orders.updated_at, orders.status, orders.scheduleddeliverydate, orders.call_date_time,
    orders.stylist_comments, users.userprofile_id, userprofiles.name, userprofiles.phonenumber, userprofiles.address, userprofiles.pincode, users.email').
    joins('JOIN users on users.id = orders.user_id').joins('JOIN users on users.id = orders.user_id').
    joins('JOIN userprofiles on users.userprofile_id = userprofiles.id').where('status = "REQUESTED"').order('orders.created_at DESC')

    @orders = @orders.paginate(:page => params[:page], :per_page => 30)

    render 'all_orders'
  end

  def backendorder
    #To create order from backend after phone call or whatsapp chat
    userprofile = Userprofile.find_by_id(params["userprofile_id"])
    userprofile.address = params["address"]
    userprofile.phonenumber = params["phone"]
    userprofile.pincode = params["pincode"]
    userprofile.save

    order = Order.new
    #order.scheduleddeliverydate = params["scheduleddeliverydate"]
    order.stylist_comments = params["stylist_comments"]
    order.status = 'REQUESTED'
    user = User.find_by_userprofile_id(params["userprofile_id"])
    order.user_id = user.id
    order.save

    #Adding to status history
    order_status_history = OrderStatusHistory.new
    order_status_history.order_id = order.id
    order_status_history.status = order.status
    order_status_history.save

    render :nothing => true
  end

  def updatecomment
    order_id = params["order_id"]
    stylistcomment = params["stylistcomment"]
    order = Order.find_by_id(order_id)
    order.stylist_comments = stylistcomment
    order.save
    render :nothing => true
  end

  def updateuserstylistcomment
    user_id = params["user_id"]
    stylistcomment = params["stylistcomment"]
    userprofile = Userprofile.find_by_id(user_id)
    userprofile.stylist_comment = stylistcomment
    userprofile.save
    render :nothing => true
  end

  def update_order_status
    order_id = params["order_id"]
    order_status = params["order_status"]
    order = Order.find_by_id(order_id)
    order.status = order_status
    order.save

    #Adding to status history
    order_status_history = OrderStatusHistory.new
    order_status_history.order_id = order_id
    order_status_history.status = order_status
    order_status_history.save
    render :nothing => true
  end

  def get_order_history
    order_id = params[:order_id]
    @history = OrderStatusHistory.select("created_at, status").where("order_id = "+order_id.to_s)
    render :json => @history.to_json
  end

  private

  def authenticate_admin
    if current_user == nil
      redirect_to :root
    return
    end
    user = User.find_by_id(current_user.id)
    if user.role_id != 3
      redirect_to :root
    end
  end

  def backend_order_params
    params.permit(:scheduleddeliverydate, :stylist_comments, :user_id)
  end

  def backend_user_params
    params.permit()
  end

end
