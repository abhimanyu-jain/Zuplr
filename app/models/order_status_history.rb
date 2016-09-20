class OrderStatusHistory < ActiveRecord::Base
  belongs_to :order
end
