require "rails_helper"

RSpec.shared_examples "invalid action on order" do |action, status|
  let!(:order){create :order, status: Order.statuses[status]}

  before do
    post action, params: {order_id: order.id}
  end

  it {should set_flash[:warning].to(I18n.t "order.messages.not_for_#{action}ing")}
  it {should redirect_to(admin_orders_path)}
end

RSpec.shared_examples "valid action on order" do |action, status|
  context "valid order for forward" do
    let!(:order){create :order, status: Order.statuses[status]}
  
    before{post action, params: {order_id: order.id}}
  
    it {should redirect_to(admin_orders_path)}
  end
end

RSpec.shared_examples "invalid to restore order" do |status|
  let!(:order){create :order, status: Order.statuses[status]}

  before{post :restore_rejected_order, params: {order_id: order.id}}

  it {should set_flash[:warning].to(I18n.t "order.messages.not_for_restoring")}
  it {should redirect_to(admin_orders_path)}
end

RSpec.describe Admin::OrdersController, type: :controller do
  let!(:admin){create :admin}
  before {sign_in admin}

  describe "#index" do
    context "not logged in as admin" do
      let!(:user){create :customer}

      before do
        sign_in user
        get :index
      end

      it {should redirect_to(root_path)}
    end

    context "logged in as admin" do

      before do
        get :index
      end

      it {should render_template(:index)}
    end
  end

  describe "#forward" do
    context "order is not exist" do
      before{post :forward, params: {order_id: -1}}
      
      it {should set_flash[:danger].to(I18n.t "order.messages.not_exist")}
      it {should redirect_to(admin_orders_path)}
    end

    it_behaves_like "invalid action on order", :forward , :canceled
    it_behaves_like "invalid action on order", :forward , :rejected
    it_behaves_like "invalid action on order", :forward , :finish

    it_behaves_like "valid action on order", :forward , :pending
    it_behaves_like "valid action on order", :forward , :approved
    it_behaves_like "valid action on order", :forward , :shipping
  end

  describe "#backward" do
    it_behaves_like "invalid action on order", :backward , :pending
    it_behaves_like "invalid action on order", :backward , :canceled
    it_behaves_like "invalid action on order", :backward , :rejected

    it_behaves_like "valid action on order", :backward , :finish
    it_behaves_like "valid action on order", :backward , :approved
    it_behaves_like "valid action on order", :backward , :shipping
  end

  describe "#reject" do
    it_behaves_like "invalid action on order", :reject , :canceled
    it_behaves_like "invalid action on order", :reject , :rejected
    it_behaves_like "invalid action on order", :reject , :finish

    it_behaves_like "valid action on order", :reject , :pending
    it_behaves_like "valid action on order", :reject , :approved
    it_behaves_like "valid action on order", :reject , :shipping
  end

  describe "#restore_rejected_order" do
    it_behaves_like "invalid to restore order", :pending
    it_behaves_like "invalid to restore order", :approved
    it_behaves_like "invalid to restore order", :shipping
    it_behaves_like "invalid to restore order", :finish
    it_behaves_like "invalid to restore order", :canceled

    it_behaves_like "valid action on order", :restore_rejected_order , :rejected
  end
end
