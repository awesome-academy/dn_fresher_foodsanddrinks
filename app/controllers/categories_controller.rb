class CategoriesController < ApplicationController
  before_action :load_category, only: %i(show)

  def show
    @products = @category.products.page(params[:page])
                         .per(Settings.page.per_8)
  end

  private

  def load_category
    @category = Category.find_by id: params[:id].to_i
    return if @category

    flash[:danger] = t "controllers.categories.not_found"
    redirect_to root_path
  end
end
