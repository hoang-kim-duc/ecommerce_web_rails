class Admin::OrdersController < AdminController
  def index
    @status = params[:status]
    @orders = Order.newest_first
    @orders = @orders.status(@status) if Order.statuses.keys
                                              .include? params[:status]
    @orders = @orders.paginate page: params[:page],
                               per_page: Settings.order.per_page
  end
end
