class DeliveryAddressesController < ApplicationController
  before_action :check_logged_in
  before_action :load_delivery_address, only: :save_choice

  def show; end

  def create
    @delivery_address = current_user.delivery_addresses.build address_params
    if @delivery_address.save
      title = :success
      msg = t "delivery_address.messages.create_address_success"
    else
      title = :danger
      msg = @delivery_address.errors.full_messages
    end
    flash[title] = msg
    redirect_to shipping_path
  end

  def save_choice
    session[:delivery_address_id] = params[:delivery_address_id]
    redirect_to confirmation_url
  end

  private

  def address_params
    params.require(:delivery_address).permit(:name, :phone, :address)
  end

  def load_delivery_address
    @delivery_address = DeliveryAddress.find_by id: params[:delivery_address_id]
    return if @delivery_address

    flash[:danger] = t "delivery_address.messages.not_exist"
    redirect_to shipping_path
  end
end
