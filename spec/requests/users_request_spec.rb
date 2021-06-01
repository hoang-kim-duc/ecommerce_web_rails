require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#new" do
    before {get "/signup"}

    it {should render_template :new}
  end

  describe "#create" do
    context "invalid user info" do
      before do
        post "/users", params: {
          user: {
            name: "name",
            email: "test@@gmail.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }
      end

      it {should render_template :new}
    end

    context "valid user info" do
      before do
        post "/users", params: {
          user: {
            name: "name",
            email: "test@gmail.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }
      end

      it "show flash success" do
        expect(flash[:success]).to eql(I18n.t "messages.signup_success")
      end
      it "show flash info" do
        expect(flash[:info]).to eql(I18n.t "messages.email_check_for_activation")
      end
      it "redirect root" do
        expect(response).to redirect_to root_path(locale: 
                                  Rails.application.config.i18n.default_locale)
      end
    end
  end

  describe "#activate_user" do
    context "invalid activation link" do
      before do
        get "/users/activate", params: {email: "", token: ""}
      end

      it "show flash danger" do
        expect(flash[:danger]).to eql(I18n.t "messages.invalid_activation_link")
      end

      it "redirect root" do
        expect(response).to redirect_to root_path(locale: 
                                  Rails.application.config.i18n.default_locale)
      end
    end

    context "valid activation link" do
      let!(:user){create :customer, activated: false }
      before do
        get "/users/activate", params: {email: user.email, token: user.activation_token}
      end

      it "show flash success" do
        expect(flash[:success]).to eql(I18n.t "messages.account_activated")
      end

      it "redirect root" do
        expect(response).to redirect_to root_path(locale: 
                                  Rails.application.config.i18n.default_locale)
      end
    end
  end
end
