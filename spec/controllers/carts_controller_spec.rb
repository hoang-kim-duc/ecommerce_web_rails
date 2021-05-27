require 'rails_helper'
include ApplicationHelper
include SessionsHelper
include CartsHelper

RSpec.describe CartsController, type: :controller do
  describe "#show" do
    context "when user is not logged in" do
      before do
        log_out
        get :show
      end

      it {should set_flash[:warning].to(I18n.t :have_to_login)}
      it {should redirect_to(root_path)}
    end

    context "when user logged in" do
      it "render cart" do
        log_in create(:customer)
        get :show
        expect(response).to render_template :show
      end
    end
  end

  describe "#add_to_cart" do
    before do
      log_in create(:customer)
      @product = create :product
    end

    context "when product is exist" do
      it "render add_to_cart" do
        post :add_to_cart, params: {product_id: @product.id}
        expect(response).to redirect_to root_path
      end

      it "increse cart size when add new product" do
        old_size = cart.size
        post :add_to_cart, params: {product_id: @product.id}
        expect(cart.size).to eql(old_size+1)
      end

      it "increase quantity of product in cart when add duplicated product" do
        post :add_to_cart, params: {product_id: @product.id}
        old_quantity = cart[@product.id.to_s]
        post :add_to_cart, params: {product_id: @product.id}
        expect(old_quantity).to eql(cart[@product.id.to_s]-1)
      end
    end

    context "product is not exist" do
      before do
        @product = build :product
        post :add_to_cart, params: {product_id: @product.id}
      end

      it {should set_flash[:danger].to(I18n.t "product.errors.add_cart_error", id: @product.id)}
      it {should redirect_to(root_path)}
    end
  end
end
