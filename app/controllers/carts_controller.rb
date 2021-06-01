class CartsController < ApplicationController
  before_action :check_nil_product, only: :add_to_cart
  before_action :authenticate_user!
  before_action :load_products_from_cart, only: :show

  def add_to_cart
    product_id = params[:product_id]
    quantity = params[:quantity] || 1
    cart[product_id] = if cart[product_id]
                         cart[product_id].to_i + quantity.to_i
                       else
                         quantity
                       end
    respond_to do |format|
      format.html{redirect_to root_path}
      format.js
    end
  end

  def show; end

  private

  def check_nil_product
    return if Product.find_by id: params[:product_id]

    flash[:danger] = t "product.errors.add_cart_error", id: params[:product_id]
    redirect_to root_url
  end
end
