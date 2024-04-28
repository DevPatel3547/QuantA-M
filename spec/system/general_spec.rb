require 'rails_helper'

RSpec.describe "Article", type: :system do
  before do
    driven_by(:rack_test)
  end

  include_context 'logged in user'

  scenario 'User can view online help' do
    visit help_path

    expect(page).to have_content('Online Help')
  end
end
