class ApplicationController < ActionController::Base
  include ApplicationHelper
  include CartsHelper
  include OrdersHelper
  include ProductsHelper
  include Pagy::Backend

  around_action :switch_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied, with: :access_denied

  private

  def access_denied
    flash[:danger] = t :access_denied
    redirect_to root_path
  end

  def switch_locale &action
    locale = params[:locale] || I18n.default_locale
    I18n.locale = locale
    @pagy_locale = locale
    I18n.with_locale locale, &action
  end

  class << self
    def default_url_options
      {locale: I18n.locale}
    end
  end

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password,
                   :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
