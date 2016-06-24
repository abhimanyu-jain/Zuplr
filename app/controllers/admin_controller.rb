class AdminController < ApplicationController
  def index
    @allusers = User.select('*').joins('JOIN userprofiles on users.id = userprofiles.user_id')
  end
  
  def getuserprofile
    @user = User.select('*').joins('JOIN userprofiles on users.id = userprofiles.user_id where users.id = '+params[:id])
  end
  
  def getallorders
    @orders = Order.select('*')
    render 'all_orders'
  end
  
  def getpendingorders
    @orders = Order.select('*').where('status = "REQUESTED"')
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
end
