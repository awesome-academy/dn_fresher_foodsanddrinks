class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale, :load_categories
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  def configure_permitted_parameters
    added_attrs = [:name, :email, :address, :phone,
                   :password, :password_confirmation,
                   :remember_me, images_attributes: [:id, :image_url]]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
