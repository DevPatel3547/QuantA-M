require 'rails_helper'

RSpec.describe "Welcome", type: :request do
  describe "GET #index" do
    context "when user is not authenticated" do
      it "redirects to the sign-in page" do
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before do
        user = create(:user)
        sign_in user
      end

      it "allows access" do
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
