FactoryBot.define do
  factory :activity do
    activity_type
    title { "Activity Title" }
    description { "Activity Description" }
    start_time { 60.minutes.ago }
    end_time { 60.minutes.from_now }
    status { 0 }
    passcode { 1234 }
    points { 10 }

    trait :past do
      start_time { 2.days.ago }
      end_time { 1.day.ago }
    end

    trait :future do
      start_time { 1.day.from_now }
      end_time { 2.days.from_now }
    end
  end
end
