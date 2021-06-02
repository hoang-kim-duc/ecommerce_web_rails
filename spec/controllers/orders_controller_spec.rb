require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let!(:user){create :customer}
  let!(:delivery_address){create :delivery_address, user: user}

  describe "#index" do
    context "user is not logged in" do
      before do
        get :index
      end

      it {should set_flash[:alert].to(I18n.t "devise.failure.unauthenticated")}
      it {should redirect_to(new_user_session_path)}
    end

    it "render orders when user logged in" do
      sign_in create(:customer)
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    let!(:order){create :order, user_id: user.id}

    context "order is not exist" do
      before do
        sign_in user
        post :cancel, params: {id: -1}
      end

      it {should redirect_to(orders_path)}
      it {should set_flash[:danger].to(I18n.t "order.messages.not_exist")}
    end

    context "user is not permitted" do
      before do |test|
        other_user = create(:customer)
        sign_in other_user
        get :show, params: {id: order.id}
      end

      it {should redirect_to(root_path)}
      it {should set_flash[:danger].to(I18n.t "order.messages.only_owner")}
    end

    context "user is permitted" do
      before do |test|
        sign_in user
        get :show, params: {id: order.id}
      end

      it {should render_template(:show)}
    end
  end

  describe "#create" do
    before do
      sign_in user
      fake_cart user
    end

    context "have not chosen a delivery address" do
      before do
        session.delete :delivery_address_id
        get :create
      end

      it {should redirect_to(shipping_path)}
    end

    context "chosen a not valid dilivery address" do
      before do
        session[:delivery_address_id] = -1
        get :create
      end

      it {should redirect_to(shipping_path)}
    end

    context "chosen a valid dilivery address" do
      before do
        session[:delivery_address_id] = delivery_address.id
        post :create, params: {order: {note: "note"}}
      end

      it {should redirect_to(root_path)}
      it {should set_flash[:success].to(I18n.t "order.messages.create_success")}
    end
  end

  describe "#cancel" do
    let!(:order){create :order, user_id: user.id}

    context "when user is not owner" do
      before do
        other_user = create(:customer)
        sign_in other_user
        post :cancel, params: {id: order.id}
      end

      it {should redirect_to(orders_path)}
      it {should set_flash[:danger].to(I18n.t "order.messages.only_owner")}
    end

    context "order is not pending" do
      before do
        sign_in user
        order.approved!
        post :cancel, params: {id: order.id}
      end

      it {should redirect_to(order)}
      it {should set_flash[:danger].to(I18n.t "order.messages.not_for_cancel")}
    end

    context "when user is owner and order is pending" do
      before do
        sign_in user
        post :cancel, params: {id: order.id}
      end

      it {should redirect_to(order)}
    end
  end

  describe "new" do
    before do
      session[:delivery_address_id] = delivery_address.id
      sign_in user
      get :new
    end

    it {should render_template :new}
  end
end
