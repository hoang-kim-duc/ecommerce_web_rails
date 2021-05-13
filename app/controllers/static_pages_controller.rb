class StaticPagesController < ApplicationController
  def home
    @products = Product.asc_by_name.paginate page: params[:page],
                                per_page: Settings.product.per_page
  end
end
