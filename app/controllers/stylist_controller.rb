class StylistController < ApplicationController
  def index
  	@orderinfo = Order.select('*').joins('JOIN userprofiles on orders.user_id = users.id')
  	                              .joins('JOIN users.userprofile_id = userprofiles.id')
  end

  #def deliveries
  #	@orderinfo = Order.select('*').joins('JOIN userprofiles on orders.user_id = userprofiles.user_id')
  #end
end
