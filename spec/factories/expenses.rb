FactoryBot.define do
  factory :expense do
    salary { 100_000 }
    salary_2 { 5000 }
    salary_3 { 3000 }
    salary_4 { 2000 }
    date_at { Time.current }
    association :user
  end
end
