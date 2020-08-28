class CartsController < ApplicationController
  before_action :load_product, :check_quantity, only: %i(create)

  def show
    cart = current_cart
    @total = 0
    @order_details = []
    cart.each do |key, value|
      @product = Product.find_by id: key
      @order_details << OrderDetail.new(product: @product, quantity: value,
        current_price: @product.price)
      @total += @product.price * value
    end
  end

  def create
    cart = current_cart
    if cart.key?(params[:product_id])
      cart[params[:product_id]] += params[:quantity].to_i
    else
      cart.store(params[:product_id].to_i, params[:quantity].to_i)
    end
    session[:cart] = cart
    flash[:success] = t "controllers.carts.add_success"
    redirect_to carts_path
  end

  def destroy
    cart = current_cart
    cart.reject!{|key| key.to_i == params[:id].to_i}
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

  def check_quantity
    return if params[:quantity].to_i <= @product.quantity &&
              params[:quantity].to_i.positive?

    flash[:danger] = t "controllers.carts.quantity_error"
    redirect_to root_path
  end
end
