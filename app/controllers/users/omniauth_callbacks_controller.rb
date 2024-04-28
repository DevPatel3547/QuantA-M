class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_google(**from_google_params)

    if user.present?
      sign_out_all_scopes
      flash[:notice] = t('devise.omniauth_callbacks.success', kind: 'Google')
      sign_in_and_redirect(user, event: :authentication)
    else
      flash[:alert] = t('devise.omniauth_callbacks.failure', kind: 'Google', reason: 'there was an error creating your account. Please try again.')
      redirect_to(new_user_session_path)
    end
  end

  def from_google_params
    @from_google_params ||= {
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      profile_picture: auth.info.image
    }
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
