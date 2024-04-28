require 'rails_helper'

RSpec.describe "ArticleCategory", type: :system do
  before do
    driven_by(:rack_test)
  end

  include_context 'logged in user'

  scenario 'Officer can create an article category' do
    login_officer

    visit new_article_category_path

    fill_in 'Name', with: 'New Category'
    click_button 'Create Article category'

    expect(page).to have_content('Article category was successfully created.')
  end

  scenario 'Officer can edit an article category' do
    login_officer

    article_category = create(:article_category)
    visit edit_article_category_path(article_category)

    fill_in 'Name', with: 'Updated Category'
    click_button 'Update Article category'

    expect(page).to have_content('Article category was successfully updated.')
  end

  scenario 'Officer improperly creates an article category' do
    login_officer

    visit new_article_category_path

    click_button 'Create Article category'

    expect(page).to have_content("Name can't be blank")
  end

  scenario 'Officer improperly edits an article category' do
    login_officer

    article_category = create(:article_category)
    visit edit_article_category_path(article_category)

    fill_in 'Name', with: ''
    click_button 'Update Article category'

    expect(page).to have_content("Name can't be blank")
  end

  scenario 'Officer can delete an article category' do
    login_officer

    article_category = create(:article_category)
    visit delete_article_category_path(article_category)
    click_button 'Delete Category'

    expect(page).to have_content('Article category was successfully deleted.')
  end
end
