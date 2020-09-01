class OrderMailer < ApplicationMailer
  def order_confirm order, user
    @order = order
    @user = user
    mail to: @user.email, subject: t("mailer.order_infor")
  end
end
