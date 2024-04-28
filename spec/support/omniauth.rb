module OmniAuthTestHelper
  def valid_google_login_setup
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: 'john.doe@example.com',
        first_name: 'John',
        last_name: 'Doe'
      },
      credentials: {
        token: 'token',
        refresh_token: 'another_token',
        expires_at: DateTime.now
      }
    })
  end

  def invalid_google_login_setup
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
     provider: 'google_oauth2',
     uid: '123456789',
     info: {
       email: 'invalid',
     },
     credentials: {
       token: 'token',
       refresh_token: 'another_token',
       expires_at: DateTime.now
     }
   })
  end
end
