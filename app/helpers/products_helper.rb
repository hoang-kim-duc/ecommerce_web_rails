module ProductsHelper
  def apply_filter_and_paging_on_products
    @products = @products.search params[:keyword] if params[:keyword]
    set_price_slider_arg
    if limit_price
      @products = @products.with_price limit_price[0], limit_price[1]
    end
    @products = @products.asc_by_name
    @products = @products.paginate page: params[:page],
                                   per_page: Settings.product.per_page
  end

  def set_price_slider_arg
    @slider ||= {}
    if @products.count.positive?
      @slider[:min] = @products.min_price
      @slider[:max] = @products.max_price
    else
      @slider[:min] = 0
      @slider[:max] = 0
    end
  end

  def limit_price
    @limit_price ||= params[:limit_price]&.split("\;")
  end

  def slider_from
    return limit_price[0] || @slider[:min] if limit_price

    @slider[:min]
  end

  def slider_to
    return limit_price[1] || @slider[:max] if limit_price

    @slider[:max]
  end
end
