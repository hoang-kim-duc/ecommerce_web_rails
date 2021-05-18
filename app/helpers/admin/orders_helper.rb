module Admin::OrdersHelper
  def is_order_valid_for_forwarding? order
    !(order.finish? || order.canceled? || order.rejected?)
  end

  def is_order_valid_for_backwarding? order
    !(order.pending? || order.canceled? || order.rejected?)
  end

  def is_order_valid_for_rejecting? order
    !(order.rejected? || order.canceled? || order.finish?)
  end

  def is_order_valid_for_restoring? order
    order.rejected?
  end
end
