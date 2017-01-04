module OrdersHelper
  def cancellation_allowed(order)
    return ['REQUESTED', 'BOX READY'].include? order.status
  end
  def feedback_allowed(order)
    return @order.status == 'DELIVERED'
  end
  def dispatched(order)
    return ['DISPATCHED', 'DELIVERED', 'RETURN BOOKED','PICKUP COMPLETED', 'COMPLETED'].include? order.status
  end
  def feedback_available(order)
    return ['RETURN BOOKED', 'PICKUP COMPLETED', 'COMPLETED'].include? order.status
  end
end
