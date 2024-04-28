require 'rails_helper'

RSpec.describe "ArticleModule", type: :system do
  before do
    driven_by(:rack_test)
  end

  include_context 'logged in user'

  scenario 'Officer can create an article module' do
    login_officer

    visit new_article_module_path

    fill_in 'Name', with: 'New Module'
    click_button 'Create Article module'

    expect(page).to have_content('Article module was successfully created.')
  end

  scenario 'Officer can edit an article module' do
    login_officer

    article_module = create(:article_module)
    visit edit_article_module_path(article_module)

    fill_in 'Name', with: 'Updated Module'
    click_button 'Update Article module'

    expect(page).to have_content('Article module was successfully updated.')
  end

  scenario 'Officer improperly creates an article module' do
    login_officer

    visit new_article_module_path

    click_button 'Create Article module'

    expect(page).to have_content("Name can't be blank")
  end

  scenario 'Officer improperly edits an article module' do
    login_officer

    article_module = create(:article_module)
    visit edit_article_module_path(article_module)

    fill_in 'Name', with: ''
    click_button 'Update Article module'

    expect(page).to have_content("Name can't be blank")
  end

  scenario 'Officer can delete an article module' do
    login_officer

    article_module = create(:article_module)
    visit delete_article_module_path(article_module)
    click_button 'Delete Module'

    expect(page).to have_content('Article module was successfully deleted.')
  end

  scenario 'Officer can increase a module position' do
    login_officer

    first = create(:article_module)
    second = create(:article_module, name: 'Second Module', priority: 1)

    visit article_modules_path
    find("[data-cta-id='" + second.id.to_s + "_inc']").click
  end

  scenario 'Officer can decrease a module position' do
    login_officer

    first = create(:article_module)
    second = create(:article_module, name: 'Second Module', priority: 1)

    visit article_modules_path
    find("[data-cta-id='" + first.id.to_s + "_dec']").click
  end

  scenario 'User tries to make a new article module' do
    visit new_article_module_path

    expect(page).to have_content(I18n.t 'not_authorized')
  end

  scenario 'User tries to edit an article module' do
    article_module = create(:article_module)
    visit edit_article_module_path(article_module)

    expect(page).to have_content(I18n.t 'not_authorized')
  end

  scenario 'User tries to delete an article module' do
    article_module = create(:article_module)
    visit delete_article_module_path(article_module)

    expect(page).to have_content(I18n.t 'not_authorized')
  end

  scenario 'User tries to view all article modules' do
    visit article_modules_path

    expect(page).to have_content(I18n.t 'not_authorized')
  end
end
