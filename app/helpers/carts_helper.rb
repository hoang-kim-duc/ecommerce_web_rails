module CartsHelper
  def cart
    user_id = session[:user_id]
    session["cart_#{user_id}"] ||= {}
  end

  def remove_form_cart product_id
    user_id = session[:user_id]
    session["cart_#{user_id}"]&.delete product_id
  end

  def load_products_from_cart
    ids = cart.keys
    quantities = cart.values
    @products = []
    @total_price = 0
    ids.each_with_index do |id, i|
      product = Product.find_by id: id
      remove_form_cart(id) && next unless product
      product.quantity = quantities[i]
      @products << product
      @total_price += product.price * product.quantity
    end
  end
end
