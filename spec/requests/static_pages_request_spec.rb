require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  describe "#home" do
    before {get root_path}

    it {should render_template :index}
  end
end
