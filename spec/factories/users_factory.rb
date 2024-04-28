FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name { 'Doe' }
    email { 'john.doe@example.com' }

    trait :different_name do
      first_name { 'Jane' }
      last_name { 'Smith' }
    end

    trait :officer do
      email { 'officer.email@example.com' }
      officer { true }
    end
  end
end
