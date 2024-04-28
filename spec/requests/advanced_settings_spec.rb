require 'rails_helper'

RSpec.describe "AdvancedSettings", type: :request do
  include_context 'logged in user'

  describe "GET /index" do
    it "returns http success" do
      get "/advanced_settings/index"
      expect(response).to have_http_status(:success)
    end
  end
end
