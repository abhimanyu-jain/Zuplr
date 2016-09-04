class AdminController < ApplicationController
  
  before_action :authenticate_admin
  
  def index
    @allusers = User.select('*').joins('JOIN userprofiles on users.id = userprofiles.user_id').order('users.created_at DESC')
    @allusers = @allusers.paginate(:page => params[:page], :per_page => 30)
  end
  
  def getuserprofile
    @user = User.select('*').joins('JOIN userprofiles on users.id = userprofiles.user_id where users.userprofile_id = '+params[:id])
    render 'getuserprofile'
  end
  
  def getallorders
    @orders = Order.select('orders.id, orders.order_code, orders.created_at, orders.updated_at, orders.status, orders.scheduleddeliverydate, 
    orders.stylist_comments, users.userprofile_id, userprofiles.phonenumber, userprofiles.address, userprofiles.pincode, users.email').
    joins('JOIN users on users.id = orders.user_id').joins('JOIN userprofiles on userprofiles.user_id = users.id').order('orders.created_at DESC')
    
    @orders = @orders.paginate(:page => params[:page], :per_page => 30)
    
    render 'all_orders'
  end
  
  def getpendingorders
    @orders = Order.select('orders.id, orders.order_code, orders.created_at, orders.updated_at, orders.status, orders.scheduleddeliverydate, 
    orders.stylist_comments, users.userprofile_id, userprofiles.phonenumber, userprofiles.address, userprofiles.pincode, users.email').
    joins('JOIN users on users.id = orders.user_id').joins('JOIN users on users.id = orders.user_id').
    joins('JOIN userprofiles on userprofiles.user_id = users.id').where('status = "REQUESTED"').order('orders.created_at DESC')
    
    @orders = @orders.paginate(:page => params[:page], :per_page => 30)
    
    render 'all_orders'
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
  
  def dispatchorder
    order_id = params["order_id"]
    order = Order.find_by_id(order_id)
    order.status = "DISPATCHED"
    order.save
    render :nothing => true
  end
  
  def completeorder
    order_id = params["order_id"]
    order = Order.find_by_id(order_id)
    order.status = "COMPLETED"
    order.save
    render :nothing => true
  end
  
  def cancelorder
    order_id = params["order_id"]
    order = Order.find_by_id(order_id)
    order.status = "CANCELLED BY ZUPLR"
    order.save
    render :nothing => true
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
    
end
