class ProductsController < ApplicationController
  before_action :load_product, only: :show
  before_action :load_category, except: :show

  def index
    @categories = @category.children
    @ctg_ancestors = @category.ancestors
    @products = @category.all_product_from_descendants
                         .asc_by_name
                         .paginate page: params[:page],
                                   per_page: Settings.product.per_page
  end

  def show; end

  def other_in_category
    @ctg_ancestors = @category.ancestors << Category.new(title: t(:other),
                                                         id: @category.id)
    @products = @category.products.paginate page: params[:page],
                                            per_page: Settings.product.per_page
  end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.errors.not_exist"
    redirect_to root_path
  end

  def load_category
    @category = Category.find_by id: params[:category_id]
    return if @category

    flash[:danger] = t "errors.unavailable_url"
    redirect_to root_path
  end
end
