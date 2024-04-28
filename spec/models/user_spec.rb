require 'rails_helper'

RSpec.describe(User, type: :model) do
  let(:user) { build(:user) }

  it 'is valid with valid attributes' do
    expect(user).to(be_valid)
  end

  it 'is not valid without a first name' do
    user.first_name = nil
    expect(user).not_to(be_valid)
  end

  it 'is not valid without a last name' do
    user.last_name = nil
    expect(user).not_to(be_valid)
  end

  it 'is not valid without an email' do
    user.email = nil
    expect(user).not_to(be_valid)
  end

  it 'is not valid with a duplicate email' do
    user.save
    user2 = build(:user, email: user.email)
    expect(user2).not_to(be_valid)
  end

  it 'has a default officer value of false' do
    expect(user.officer).to(eq(false))
  end

  it 'has a default timezone of cst' do
    expect(user.timezone).to(eq('Central Time (US & Canada)'))
  end

  it 'is not valid with an invalid timezone' do
    user.timezone = 'Invalid Timezone'
    expect(user).not_to(be_valid)
  end

  it 'is valid with a valid timezone' do
    user.timezone = 'Eastern Time (US & Canada)'
    expect(user).to(be_valid)
  end

  it 'creates a new user from google' do
    auth = valid_google_login_setup
    user = User.from_google(email: auth.info.email,
                            first_name: auth.info.first_name,
                            last_name: auth.info.last_name,
                            profile_picture: auth.info.image
                           )
    expect(user).to(be_valid)
  end

  it 'updates an existing user from google' do
    user2 = create(:user, first_name: 'Jane', last_name: 'Smith')
    auth = valid_google_login_setup
    user = User.from_google(email: auth.info.email,
                            first_name: auth.info.first_name,
                            last_name: auth.info.last_name,
                            profile_picture: auth.info.image
                           )
    expect(user).to(be_valid)
    expect(user.first_name).not_to(eq(user2.first_name))
    expect(user.last_name).not_to(eq(user2.last_name))
  end
end
