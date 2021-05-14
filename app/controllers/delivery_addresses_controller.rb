class DeliveryAddressesController < ApplicationController
  before_action :check_logged_in

  def show; end

  def create
    @delivery_address = current_user.delivery_addresses.build address_params
    if @delivery_address.save
      title = :success
      msg = t "delivery_address.messages.create_address_success"
    else
      title = :danger
      msg = @delivery_address.errors.full_messages.join "\n"
    end
    flash[title] = msg
    redirect_to shipping_path
  end

  private

  def address_params
    params.require(:delivery_address).permit(:name, :phone, :address)
  end
end
