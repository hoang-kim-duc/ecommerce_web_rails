module CartsHelper
  def cart
    user_id = session[:user_id]
    session["cart_#{user_id}"] ||= {}
  end

  def remove_form_cart product_id
    user_id = session[:user_id]
    session["cart_#{user_id}"]&.delete product_id
  end
end
