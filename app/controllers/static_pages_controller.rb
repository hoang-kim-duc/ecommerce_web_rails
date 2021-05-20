class StaticPagesController < ApplicationController
  def home
    @categories = Category.roots
    @ctg_ancestors = []
    @products = Product.asc_by_name.paginate page: params[:page],
                                    per_page: Settings.product.per_page
    @title = t :home
    render "products/index"
  end
end
