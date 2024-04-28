# spec/requests/users_omniauth_callbacks_spec.rb
require 'rails_helper'

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  before do
    OmniAuth.config.test_mode = true
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  after do
    OmniAuth.config.test_mode = false
  end

  it "handles the Google OAuth2 callback" do
    valid_google_login_setup
    get user_google_oauth2_omniauth_callback_path
    expect(response).to redirect_to(root_path)
  end

  it "handles the Google OAuth2 failure" do
    invalid_google_login_setup
    get user_google_oauth2_omniauth_callback_path
    expect(response).to redirect_to(new_user_session_path)
  end
end
