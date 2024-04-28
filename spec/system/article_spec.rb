require 'rails_helper'

RSpec.describe "Article", type: :system do
  before do
    driven_by(:rack_test)
  end

  include_context 'logged in user'

  scenario 'Officer can create an article' do
    login_officer

    article_module = create(:article_module)
    article_category = create(:article_category)
    visit new_article_path

    fill_in 'Title', with: 'New Article'
    find('.hidden-content-field', visible: false).set('Body')

    select article_module.name, from: 'Module'
    select article_category.name, from: 'Category'

    click_button 'Create Article'

    expect(page).to have_content('Article was successfully created.')
  end

  scenario 'Officer can edit an article' do
    login_officer

    article = create(:article)
    visit edit_article_path(article)

    fill_in 'Title', with: 'Updated Article'
    click_button 'Update Article'

    expect(page).to have_content('Article was successfully updated.')
  end

  scenario 'Officer improperly creates an article' do
    login_officer

    visit new_article_path

    click_button 'Create Article'

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'Officer improperly edits an article' do
    login_officer

    article = create(:article)
    visit edit_article_path(article)

    fill_in 'Title', with: ''
    click_button 'Update Article'

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'Officer can delete an article' do
    login_officer

    article = create(:article)
    visit delete_article_path(article)
    click_button 'Delete Article'

    expect(page).to have_content('Article was successfully deleted.')
  end

  scenario 'User tries to make a new article' do
    visit new_article_path

    expect(page).to have_content(I18n.t 'not_authorized')
  end

  scenario 'User tries to edit an article' do
    article = create(:article)
    visit edit_article_path(article)

    expect(page).to have_content(I18n.t 'not_authorized')
  end

  scenario 'User tries to delete an article' do
    article = create(:article)
    visit delete_article_path(article)

    expect(page).to have_content(I18n.t 'not_authorized')
  end

  scenario 'User tries to view an article' do
    article = create(:article)
    visit article_path(article)

    expect(page).to have_content(article.title)
  end

  scenario 'User tries to view all articles' do
    create(:article)
    visit articles_path

    expect(page).to have_content(Article.first.title)
  end

  scenario 'User searches for an article' do
    create(:article, title: 'Article 1')
    visit articles_path(search: 'Article 1')

    expect(page).to have_content('Article 1')
  end

  scenario 'User filters an article category' do
    article = create(:article)
    category = article.article_category

    visit articles_path(category: category.id)

    expect(page).to have_content(article.title)
  end
end
