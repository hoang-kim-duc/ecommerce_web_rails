class Admin::OrdersController < AdminController
  before_action :load_order, except: :index
  authorize_resource

  def index
    @status = params[:status]
    @orders = Order.newest_first
    authorize! :index, @orders
    if Order.statuses.keys.include? params[:status]
      @orders = @orders.status(@status)
    else
      @status = "all"
    end
    @pagy, @orders = pagy @orders, items: Settings.order.per_page
  end

  def forward
    if is_order_valid_for_forwarding? @order
      change_to_next_status @order
    else
      flash[:warning] = t "order.messages.not_for_forwarding"
    end
    redirect_to admin_orders_path(status: params[:status])
  end

  def backward
    if is_order_valid_for_backwarding? @order
      change_to_previous_status @order
    else
      flash[:warning] = t "order.messages.not_for_backwarding"
    end
    redirect_to admin_orders_path(status: params[:status])
  end

  def reject
    if is_order_valid_for_rejecting? @order
      save_canceled_rejected_order :rejected, @order
    else
      flash[:warning] = t "order.messages.not_for_rejecting"
    end
    redirect_to admin_orders_path(status: params[:status])
  end

  def restore_rejected_order
    if is_order_valid_for_restoring? @order
      save_new_pending_order @order
    else
      flash[:warning] = t "order.messages.not_for_restoring"
    end
    redirect_to admin_orders_path(status: params[:status])
  end

  private

  def load_order
    @order = Order.find_by id: params[:order_id]
    return if @order

    flash[:danger] = t "order.messages.not_exist"
    redirect_to admin_orders_path
  end

  def change_to_next_status order
    case order.status
    when "pending"
      order.approved!
    when "approved"
      order.shipping!
    when "shipping"
      order.finish!
    end
    OrderMailer.changing_order_status(order).deliver_later
  rescue StandardError
    flash[:danger] = t("errors.general")
  end

  def change_to_previous_status order
    case order.status
    when "finish"
      order.shipping!
    when "shipping"
      order.approved!
    when "approved"
      order.pending!
    end
  rescue StandardError
    flash[:danger] = t("errors.general")
  end
end
