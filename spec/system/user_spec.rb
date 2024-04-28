require 'rails_helper'

RSpec.describe "User", type: :system do
  before do
    driven_by(:rack_test)
  end

  include_context 'logged in user'

  scenario 'User can access their profile through the navbar' do
    visit root_path
    find("[data-cta_id='userDropdown']").click
    click_link 'Profile'
  end

  scenario 'Use can sign out through the navbar' do
    visit root_path
    find("[data-cta_id='userDropdown']").click
    expect(page).to have_link('Sign Out')
  end

  scenario 'User does not see officer nav link if not logged in as officer' do
    visit root_path
    expect(page).not_to have_link('Members')
  end

  scenario 'User sees officer nav link if logged in as officer' do
    user = create(:user, :officer)
    sign_in user
    visit root_path
    expect(page).to have_link('Members')
  end

  scenario 'User can view their profile' do
    user = User.first
    visit user_path(user)
    expect(page).to have_content(user.first_name)
  end

  scenario 'User can update their profile' do
    user = User.first
    visit user_path(user)
    select 'Eastern Time (US & Canada)', from: 'Time Zone'
    click_button 'Update Profile'
    expect(page).to have_content('User was successfully updated.')
  end

  scenario 'User improperly updates their profile' do
    user = User.first
    visit user_path(user)
    fill_in 'First Name', with: ''
    click_button 'Update Profile'
    expect(page).to have_content("First name can't be blank")
  end

  scenario 'User redeems password for points' do
    activity = create(:activity)
    user = User.first

    visit activity_path(activity)
    click_button 'Verify Attendance'

    fill_in 'Passcode', with: activity.passcode
    click_button 'Submit Passcode'
    expect(page).to have_content("Passcode is correct")

    visit user_path(user)
    expect(page).to have_content(activity.points)
  end

  scenario 'User submits wrong password' do
    create(:activity_type)
    activity = create(:activity)

    visit activity_path(activity)
    click_button 'Verify Attendance'

    fill_in 'Passcode', with: 12345
    click_button 'Submit Passcode'
    expect(page).to have_content("Passcode is incorrect")
  end

  scenario 'User tries to redeem password for points after activity has ended' do
    activity = create(:activity, :past)

    visit activity_path(activity)
    expect(page).not_to have_button('Verify Attendance')
  end

  scenario 'User tries to redeem password for points before activity has started' do
    activity = create(:activity, :future)

    visit activity_path(activity)
    expect(page).not_to have_button('Verify Attendance')
  end

  scenario 'Officer can search for a user' do
    user = User.first
    officer = create(:user, :officer)
    sign_in officer
    visit users_path
    fill_in 'query', with: user.first_name
    click_button 'search-addon'
    expect(page).to have_content(user.first_name)
  end

  scenario 'Officer can make another user an officer' do
    user = User.first
    officer = create(:user, :officer)
    sign_in officer
    visit user_path(user)

    find('#officerSwitch').click

    click_button 'Update Profile'
  end
end
