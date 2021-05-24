class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email]
    if user&.authenticate params[:session][:password]
      return unless check_activated? user

      log_in user
      redirect_to root_path
    else
      flash[:danger] = t :incorrect_email_password
      redirect_to login_path
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def check_activated? user
    return true if user.activated

    flash[:danger] = t("messages.not_activated")
    redirect_to root_path
    false
  end
end
