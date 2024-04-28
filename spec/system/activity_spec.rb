# spec/features/activity_spec.rb

require 'rails_helper'

RSpec.describe "Activity", type: :system do
  let(:activity) { create(:activity) }

  before do
    driven_by(:rack_test)
  end

  include_context 'logged in user'

  scenario 'Officer creates a new activity' do
    login_officer

    create(:activity_type)
    visit new_activity_path

    fill_in 'Title', with: 'New Activity'

    # Fills in the description field by setting the hidden content field
    find('.hidden-content-field', visible: false).set('New Description')

    select activity.activity_type.title, from: 'Activity Type'

    fill_in 'Start Time', with: Time.current.strftime('%Y-%m-%d %H:%M:%S')
    fill_in 'End Time', with: Time.current.strftime('%Y-%m-%d %H:%M:%S')

    select activity.status.humanize, from: 'Status'

    click_button 'Create Activity'

    expect(page).to have_content('Activity was successfully created.')
    expect(page).to have_content('New Activity')
  end

  scenario 'Officer edits an existing activity' do
    login_officer

    visit edit_activity_path(activity)

    fill_in 'Title', with: 'Updated Activity'

    click_button 'Update Activity'

    expect(page).to have_content('Activity was successfully updated.')
  end

  scenario 'Officer improperly creates a new activity' do
    login_officer

    visit new_activity_path

    click_button 'Create Activity'

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'Officer improperly edits an existing activity' do
    login_officer

    visit edit_activity_path(activity)

    fill_in 'Title', with: ''
    click_button 'Update Activity'

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'Officer deletes an existing activity' do
    login_officer

    visit delete_activity_path(activity)

    click_button 'Delete Activity'

    expect(page).to have_content('Activity was successfully deleted.')
  end

  scenario 'Officer edits an existing activity' do
    login_officer

    visit activity_path(activity)
    expect(page).to have_content(activity.title)
    expect(page).to have_content(activity.description)
    expect(page).to have_content(activity.status.humanize)

    visit edit_activity_path(activity)
    select 'Postponed', from: 'Status'
    click_button 'Update Activity'

    visit activity_path(activity)
    expect(page).to have_content('Postponed')

    visit edit_activity_path(activity)
    select 'Canceled', from: 'Status'
    click_button 'Update Activity'

    visit activity_path(activity)
    expect(page).to have_content('Canceled')
  end

  scenario 'User should see their timezone' do
    visit activities_path
    expect(page).to have_content('Central Time (US & Canada)')
  end

  scenario 'User should see applicable buttons if activity is live' do
    visit activity_path(activity)
    expect(page).to have_button('Verify Attendance')
  end

  scenario 'User should not see applicable buttons if activity is not live' do
    activity.update(start_time: 2.days.ago, end_time: 1.day.ago)
    visit activity_path(activity)
    expect(page).to_not have_button('Verify Attendance')
  end

  scenario 'User should not see applicable buttons if activity is not scheduled' do
    activity.update(status: 'canceled')
    visit activity_path(activity)
    expect(page).to_not have_button('Verify Attendance')
  end

  scenario 'User types in the passcode to verify attendance' do
    visit activity_path(activity)
    click_button 'Verify Attendance'
    fill_in 'Passcode', with: activity.passcode
    click_button 'Submit Passcode'
    expect(page).to have_content('Passcode is correct')
  end

  scenario 'User types in the wrong passcode to verify attendance' do
    visit activity_path(activity)
    click_button 'Verify Attendance'
    fill_in 'Passcode', with: activity.passcode + 1
    click_button 'Submit Passcode'
    expect(page).to have_content('Passcode is incorrect')
  end

  scenario 'User can sign up for an activity' do
    visit activity_path(activity)
    click_button 'Sign Up'
    select 'Going', from: 'Status'
    click_button 'Submit'

    expect(page).to have_content('You have successfully signed up for this activity.')
  end

  scenario 'User can edit their sign up for an activity' do
    create(:activity_participation, user: User.first, activity: activity)
    visit activity_path(activity)
    click_button 'Change Status'
    select 'Not going', from: 'Status'
    click_button 'Submit'

    expect(page).to have_content('Sign up status was successfully updated.')
  end

  scenario 'User can view the sign up list for an activity' do
    create(:activity_participation, user: User.first, activity: activity)
    visit activity_path(activity)
    click_link 'See All Signups'

    expect(page).to have_content(User.first.first_name)
  end

  scenario 'User can view the list view of all activities' do
    visit activities_path(view: 'list')
  end
end
