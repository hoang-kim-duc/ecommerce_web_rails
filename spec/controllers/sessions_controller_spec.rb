require "rails_helper"
include SessionsHelper

RSpec.describe SessionsController, type: :controller do
  let!(:user){create :customer}

  describe "#new" do
    before {get :new}

    it {should render_template(:new)}
  end

  describe "#create" do
    context "correct username and password" do
      before do
        post :create, params: {
          session: {
            email: user.email,
            password: user.password
          }
        }
      end

      it {should set_session[:user_id].to(user.id)}
      it {should redirect_to(root_path)}
    end
    
    context "correct username and password" do
      before do
        post :create, params: {
          session: {
            email: user.email,
            password: "a wrong password"
          }
        }
      end

      it {should set_flash[:danger].to(I18n.t :incorrect_email_password)}
      it {should redirect_to(login_path)}
    end
  end

  describe "#destroy" do
    before do
      log_in user
      get :destroy
    end

    it {should_not set_session[:user_id].to(user.id)}
    it {should redirect_to(root_path)}
  end
end
