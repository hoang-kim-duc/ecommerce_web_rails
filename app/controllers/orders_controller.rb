class OrdersController < ApplicationController
  before_action :check_logged_in
  before_action :load_products_from_cart, :check_user_chose_delivery_address
  before_action :build_order, only: :create

  def new
    @shipping_cost = Settings.order.shipping_cost_default
  end

  def create
    if @order.save
      cart.clear
      flash[:success] = t "order.messages.create_success"
    else
      flash[:danger] = order.errors.full_messages
    end
    redirect_to root_path
  end

  private

  def build_order
    shipping_cost = Settings.order.shipping_cost_default
    @order = current_user.orders.new note: params[:order][:note],
                      delivery_address_id: @delivery_address.id,
                      shipping: shipping_cost,
                      total: (shipping_cost + @total_price)
    @products.each do |product|
      @order.order_details.build product_id: product.id,
                                quantity: product.quantity,
                                price: product.price
    end
  end

  def check_user_chose_delivery_address
    id = session[:delivery_address_id]
    return redirect_to shipping_path unless id

    @delivery_address = DeliveryAddress.find_by id: id,
                                                user_id: session[:user_id]
    return if @delivery_address

    session.delete :delivery_address_id
    redirect_to shipping_path
  end
end
