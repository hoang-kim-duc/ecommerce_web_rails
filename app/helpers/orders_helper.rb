module OrdersHelper
  def short_desc_products order
    desc = ""
    order.order_details.each do |order_detail|
      desc += "#{order_detail.quantity} x #{order_detail.product.name} - "
    end
    desc[0..-4]
  end

  def save_canceled_rejected_order status, order
    ActiveRecord::Base.transaction do
      order.send "#{status}!"
      order.order_details.each do |details|
        product = details.product
        product.update! quantity: product.quantity + details.quantity
      end
    end
  rescue StandardError
    flash[:danger] = t "errors.general"
  end

  class OutOfStockError < StandardError; end

  def save_new_pending_order order
    ActiveRecord::Base.transaction do
      order.status = :pending
      order.save!
      order.order_details.each do |details|
        product = details.product
        new_quantity = product.quantity - details.quantity
        if new_quantity.negative?
          raise OutOfStockError, t("order.messages.out_of_stock",
                                   product_name: product.name)
        end
        product.update! quantity: new_quantity
      end
    end
  rescue OutOfStockError => e
    flash[:danger] = [e.message]
  rescue StandardError
    flash[:danger] = [t("errors.general")]
  end
end
