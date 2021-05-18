class AdminController < ApplicationController
  include Admin::OrdersHelper

  before_action :require_admin

  private

  def require_admin
    return if current_user.admin?

    redirect_to root_path
  end
end
