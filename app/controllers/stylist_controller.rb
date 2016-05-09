class StylistController < ApplicationController
  def index
  	@deliveries = Delivery.all
  end

  def deliveries
  	@deliveries = Delivery.all
  end
end
