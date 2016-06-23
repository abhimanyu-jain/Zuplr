class StylistController < ApplicationController
  def index
  	@orderinfo = Order.select('*').joins('JOIN userprofiles on orders.user_id = userprofiles.user_id')
  end

  def deliveries
  	@orderinfo = Order.select('*').joins('JOIN userprofiles on orders.user_id = userprofiles.user_id')
  end
end
