class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email

      flash[:success] = t "messages.signup_success"
      flash[:info] = t "messages.email_check_for_activation"
      redirect_to root_path
    else
      render :new
    end
  end

  def activate_user
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation,
                                                       params[:token])
      user.activate
      log_in user
      flash[:success] = t "messages.account_activated"
    else
      flash[:danger] = t "messages.invalid_activation_link"
    end
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end
