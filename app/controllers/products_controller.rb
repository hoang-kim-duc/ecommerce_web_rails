class ProductsController < ApplicationController
  before_action :load_product

  def show; end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.errors.not_exist"
    redirect_to root_path
  end
end
