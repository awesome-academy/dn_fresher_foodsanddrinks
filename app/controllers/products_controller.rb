class ProductsController < ApplicationController
  before_action :load_product, only: %i(show)

  def show; end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "controllers.carts.product_nil"
    redirect_to root_path
  end
end
