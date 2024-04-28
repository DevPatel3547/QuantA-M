# spec/features/activity_spec.rb

require 'rails_helper'

RSpec.describe "Application", type: :system do
  let(:activity) { create(:activity) }

  before do
    driven_by(:rack_test)
  end

  scenario 'User visits the home page without signing in' do
    visit root_path
    expect(page).to have_content('Sign in')
  end

  scenario 'User visits the home page after signing in' do
    user = create(:user)
    sign_in user
    visit root_path
    expect(page).to have_content(user.first_name)
  end

  scenario 'User signs out' do
    user = create(:user)
    sign_in user
    visit root_path
    visit destroy_user_session_path
    expect(page).to have_content('Sign in')
  end
end
