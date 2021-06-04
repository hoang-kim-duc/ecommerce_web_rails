module ProductsHelper
  SORT_LIST = [:name_asc, :created_at_desc, :price_asc, :price_desc].freeze

  def apply_filter_and_paging_on_products
    @q = @products.ransack params[:q]
    @products = @q.result
    set_price_slider_arg
    apply_price_filter if limit_price
    sort_products
    @pagy, @products = pagy @products, items: Settings.product.per_page
  end

  def apply_price_filter
    slider_query = {price_gteq: slider_from, price_lteq: slider_to}
    @products = @products.ransack(slider_query).result
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

  def sort_products
    return unless SORT_LIST.include? params[:sort]&.to_sym

    @selected_sort = params[:sort]
    sort_type = @selected_sort.reverse.sub("_", " ").reverse
    @q = @products.ransack
    @q.sorts = sort_type
    @products = @q.result
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

  def sort_option_tags
    option_tags = ""
    SORT_LIST.each do |sort|
      selected = ""
      selected = "selected='selected'" if sort == @selected_sort&.to_sym
      option_tags += "<option value=#{sort} #{selected}>
                      #{t "product.sort.#{sort}"}
                      </option>"
    end
    option_tags
  end
end
