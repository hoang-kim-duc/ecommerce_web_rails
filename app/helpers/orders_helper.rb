module OrdersHelper
  def short_desc_products order
    desc = ""
    order.order_details.each do |order_detail|
      desc += "#{order_detail.quantity} x #{order_detail.product.name} - "
    end
    desc[0..-4]
  end
end
