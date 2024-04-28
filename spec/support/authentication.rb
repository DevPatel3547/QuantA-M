RSpec.shared_context 'logged in user' do
  before :each do
    user = create(:user)
    login_as(user, scope: :user)
  end
end

def login_officer
  officer = create(:user, :officer)
  login_as(officer, scope: :user)
end
