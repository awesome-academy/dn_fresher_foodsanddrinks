class SearchsController < ApplicationController
  before_action :check_keyword, only: %i(index)

  def index
    @products = Product.search_by_name(@keyword)
                       .page(params[:page])
                       .per(Settings.page.per_8)
  end

  private

  def check_keyword
    @keyword = params[:keyword]
    return unless @keyword.empty?

    flash[:danger] = t "controllers.searchs.empty"
    redirect_to root_path
  end
end
