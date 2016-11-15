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
    @user = User.select('*').joins('JOIN userprofiles on users.userprofile_id = userprofiles.id').where('users.userprofile_id ='+ params[:id]).first
    user_id = User.find_by_userprofile_id(params[:id]).id
    @orders = Order.select('*').where("user_id = ?", user_id)
    if(params[:status] != 'All' && params[:status] != nil)
      @orders = @orders.where('orders.status' => params[:status])
    end
   
    if(params[:call_date] != 'All' && params[:call_date] != nil && params[:call_date] != "")
      selected_date = Date.strptime(params[:call_date], "%m/%d/%Y")
      @orders = @orders.where(
      ['orders.call_date_time >= ? AND orders.call_date_time <= ?', 
        selected_date.in_time_zone(Time.zone).beginning_of_day, #HACK : For some reason, active record is converting selected_date to UTC time on localhost but not on production which means the time shifts back by 5 hours 30 minutes. Treat it as UTC for it to work on localhost.
        selected_date.in_time_zone(Time.zone).end_of_day
        ]
      )
    end
    render 'getuserprofile'
  end

  def getallorders
    
    set_list_of_stylists
    
    # 4 joins here because of shitty schema where users and userprofiles are 2 different tables. TODO : Fix that shit
    @orders = Order.select('orders.id, orders.order_code, orders.created_at, orders.updated_at, orders.status, orders.scheduleddeliverydate, orders.call_date_time,
    orders.stylist_comments, orders.promo_code, orders.stylist_id, users.userprofile_id, userprofiles.name, userprofiles.phonenumber, userprofiles.address, userprofiles.pincode, users.email, stylist_profile.name as stylist_name').
    joins('JOIN users on users.id = orders.user_id').joins('JOIN userprofiles on users.userprofile_id = userprofiles.id').joins('JOIN users as stylists on orders.stylist_id = stylists.id').joins('JOIN userprofiles as stylist_profile on stylist_profile.id = stylists.userprofile_id').order('orders.created_at DESC')

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
        selected_date.in_time_zone(Time.zone).beginning_of_day, #HACK : For some reason, active record is converting selected_date to UTC time on localhost but not on production which means the time shifts back by 5 hours 30 minutes. Treat it as UTC for it to work on localhost.
        selected_date.in_time_zone(Time.zone).end_of_day
        ]
      )
    end

    @orders = @orders.paginate(:page => params[:page], :per_page => 30)

    render 'all_orders'
  end

  def getpendingorders
    @orders = Order.select('orders.id, orders.order_code, orders.created_at, orders.updated_at, orders.status, orders.scheduleddeliverydate, orders.call_date_time,
    orders.stylist_comments, orders.promo_code, orders.stylist_id, users.userprofile_id, userprofiles.name, userprofiles.phonenumber, userprofiles.address, userprofiles.pincode, users.email').
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

    call_date_time = Date.strptime(params["call_date"], "%m/%d/%Y")
  
    order = Order.new
    #order.scheduleddeliverydate = params["scheduleddeliverydate"]
    order.stylist_comments = params["stylist_comments"]
    order.status = 'REQUESTED'
    order.order_code = Random.new.rand(1000..1000000000)
    order.call_date_time = call_date_time
    user = User.find_by_userprofile_id(userprofile.id)
    order.user_id = user.id
    order.save

    # Adding to contact log
    contact_log_entry = ContactLog.new(:contact_date => params["call_date"], :notes => "Order generated from backend", :order_id => order.id)
    contact_log_entry.save

  
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

  def next_call
    order_id = params["order_id"]
    date = params["next_call_date"]
    #Get proper date time from the date
    datetime = DateTime.strptime(date, "%m/%d/%Y")
    note = params["stylist_call_note"]
    contact_log_entry = ContactLog.new(:contact_date => datetime, :notes => note, :order_id => order_id)
    contact_log_entry.save

    order = Order.find_by_id(order_id)
    order.call_date_time = datetime
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
  
  def get_contact_history
    order_id = params[:order_id]
    @contact_history = ContactLog.select("contact_date, notes").where("order_id = "+order_id.to_s)
    render :json => @contact_history.to_json
  end
  
  def assign_stylist
    order_id = params[:order_id]
    stylist_id = params[:stylist_id]
    
    order = Order.find_by_id(order_id)
    order.stylist_id = stylist_id
    order.save
    render :nothing => true
  end

  private
  
  def set_list_of_stylists
    @stylists = User.select('users.id, users.email, userprofiles.name').joins('JOIN userprofiles on users.userprofile_id = userprofiles.id').joins('JOIN roles on users.role_id = roles.id').where('roles.name = "Stylist" or roles.name = "Admin"')
  end

  def authenticate_admin
    if current_user == nil
      redirect_to :root
    return
    end
    user = User.find_by_id(current_user.id)
    if user.role.name == 'User'
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
