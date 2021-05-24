class OrderMailer < ApplicationMailer
  def changing_order_status order
    @order = order
    mail to: order.user_email, subject: t("order.mails.status_#{@order.status}")
  end
end
