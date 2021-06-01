require "rails_helper"
include SessionsHelper

RSpec.describe DeliveryAddressesController, type: :controller do
  let!(:user){create :customer}
  before {log_in user}

  describe "#show" do
    before {get :show}

    it {should render_template(:show)}
  end

  describe "#create" do
    context "invalid param" do
      let!(:invalid_delivery_address){build :delivery_address, phone: "INVALID_PHONE"}

      before do
        invalid_delivery_address.valid?
        post :create, params: {
          delivery_address: invalid_delivery_address.attributes
        }
      end

      it {should set_flash[:danger].to(invalid_delivery_address.errors
                                                               .full_messages)}
      it {should redirect_to(shipping_path)}
    end

    context "valid param" do
      let!(:delivery_address){build :delivery_address}

      before do
        post :create, params: {
          delivery_address: delivery_address.attributes
        }
      end

      it {should set_flash[:success].to(I18n.t "delivery_address.messages.create_address_success")}
      it {should redirect_to(shipping_path)}
    end
  end

  describe "#save_choice" do
    context "delivery address is not exist" do
      before {post :save_choice, params: {delivery_address_id: -1}}

      it {should set_flash[:danger].to(I18n.t "delivery_address.messages.not_exist")}
      it {should redirect_to(shipping_path)}
    end

    context "delivery address is exist" do
      let!(:delivery_address){create :delivery_address}
      before {post :save_choice, params: {delivery_address_id: delivery_address.id}}

      it {should set_session[:delivery_address_id].to(delivery_address.id)}
      it {should redirect_to(confirmation_url)}
    end
  end
end
