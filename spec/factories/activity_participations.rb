FactoryBot.define do
  factory :activity_participation do
    user
    activity
    status { "going" }
    attended { false }

    trait :attended do
      attended { true }
    end
  end
end
