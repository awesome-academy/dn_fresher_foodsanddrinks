class OrderMailer < ApplicationMailer
  def order_confirm order, user
    @order = order
    @user = user
    mail to: @user.email, subject: t("mailer.order_infor")
  end

  def order_notify order
    @order = order
    mail to: order.user.email, subject: t("mailer.order_notify")
  end
end
