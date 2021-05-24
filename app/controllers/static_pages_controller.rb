class StaticPagesController < ApplicationController
  def home
    @categories = Category.roots
    @ctg_ancestors = []
    @products = Product
    apply_filter_and_paging_on_products
    @title = t :home
    render "products/index"
  end
end
