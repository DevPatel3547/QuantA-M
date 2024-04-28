# spec/features/activity_type_spec.rb

require 'rails_helper'

RSpec.describe "Activity Type", type: :system do
  let(:activity_type) { create(:activity_type) }

  before do
    driven_by(:rack_test)
  end

  include_context 'logged in user'

  scenario 'User creates a new activity type' do
    visit new_activity_type_path

    fill_in 'Title', with: 'New Activity Type'

    click_button 'Create Activity type'

    expect(page).to have_content('Activity type was successfully created.')
  end

  scenario 'User edits an existing activity type' do
    visit edit_activity_type_path(activity_type)

    fill_in 'Title', with: 'Updated Activity Type'

    click_button 'Update Activity type'

    expect(page).to have_content('Activity type was successfully updated.')
  end

  scenario 'User improperly creates a new activity type' do
    visit new_activity_type_path

    click_button 'Create Activity type'

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'User improperly edits an existing activity type' do
    visit edit_activity_type_path(activity_type)

    fill_in 'Title', with: ''
    click_button 'Update Activity type'

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'User deletes an existing activity type' do
    visit delete_activity_type_path(activity_type)

    click_button 'Delete Activity Type'

    expect(page).to have_content('Activity type was successfully destroyed.')
  end
end
