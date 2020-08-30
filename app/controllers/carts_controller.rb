class CartsController < ApplicationController
  before_action :load_product, only: %i(create update)
  before_action :check_quantity_number, only: %i(create update)
  before_action :check_quantity_create, only: %i(create)
  before_action :load_order_details_from_cart, only: %i(show)

  def show; end

  def create
    cart = current_cart
    if cart[params[:product_id]]
      cart[params[:product_id]] += params[:quantity].to_i
    else
      cart.store(params[:product_id].to_i, params[:quantity].to_i)
    end
    session[:cart] = cart
    flash[:success] = t "controllers.carts.add_success"
    redirect_to carts_path
  end

  def update
    cart = current_cart
    cart[params[:product_id]] = params[:quantity].to_i
    session[:cart] = cart
    flash[:success] = t "controllers.carts.update_success"
    redirect_to carts_path
  end

  def destroy
    cart = current_cart
    cart.reject!{|key| key.to_i == params[:product_id].to_i}
    flash[:success] = t "controllers.carts.delete_success"
    session[:cart] = cart
    redirect_to carts_path
  end

  private

  def item_params
    params.fetch(:order_detail, {}).permit(:product_id, :quantity)
  end

  def load_product
    @product = Product.find_by id: params[:product_id].to_i
    return if @product

    flash[:danger] = t "controllers.carts.product_nil"
    redirect_to carts_path
  end

  def check_quantity_create
    if params[:quantity].to_i.positive?
      cart = current_cart
      return unless cart[params[:product_id]]

      quantity_temp = cart[params[:product_id]] + params[:quantity].to_i
      return if quantity_temp <= @product.quantity

      flash[:danger] = t("controllers.carts.quantity_error_full",
                         name: @product.name,
                         quantity: @product.quantity)
    else
      flash[:danger] = t "controllers.carts.quantity_error"
    end
    redirect_to root_path
  end

  def check_quantity_number
    quantity = params[:quantity].to_i
    return if quantity.positive? && quantity <= @product.quantity

    flash[:danger] = t("controllers.carts.quantity_error_full",
                       name: @product.name,
                       quantity: @product.quantity)
    redirect_to root_path
  end
end
