class SearchsController < ApplicationController
  before_action :check_keyword, only: %i(index)

  def index
    @products = @q.result(distinct: true)
                  .page(params[:page])
                  .per(Settings.page.per_8)
  end

  private

  def check_keyword
    @keyword = params[:q].values.first if params[:q]
    return unless @keyword.blank?

    flash[:danger] = t "controllers.searchs.empty"
    redirect_to root_path
  end
end
