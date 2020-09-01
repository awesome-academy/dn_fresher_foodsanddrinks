class OrderConfirmsController < ApplicationController
  before_action :load_order, :check_expiration, only: %i(edit)

  def edit
    if @order.waiting?
      @order.confirm
      flash[:success] = t "controllers.order_confirms.success"
    else
      flash[:danger] = t "controllers.order_confirms.fail"
      redirect_to root_path
    end
  end

  private

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "controllers.order_confirms.not_found"
    redirect_to root_path
  end

  def check_expiration
    return unless @order.link_confirm_expired?

    flash[:danger] = t "controllers.order_confirms.expired"
    redirect_to root_path
  end
end
