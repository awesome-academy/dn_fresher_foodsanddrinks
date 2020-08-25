class StaticPagesController < ApplicationController
  def home
    @products = Product.alphabet_name.page(params[:page])
                       .per(Settings.page.per_8)
  end
end
