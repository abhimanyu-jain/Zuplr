module OrdersHelper
  def cancellation_allowed(order)
    return ['REQUESTED', 'BOX READY'].include? order.status
  end
  def feedback_allowed(order)
    return @order.status == 'DELIVERED'
  end
end
