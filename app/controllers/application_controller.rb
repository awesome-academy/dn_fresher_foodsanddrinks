class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale, :load_categories

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_categories
    @categories = Category.alphabet_name
  end
end
