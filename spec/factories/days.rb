FactoryBot.define do
  factory :day do
    icon { :rent }
    memo { 'メモ' }
    spending { true }
    money { 10000 }
    association :expense
    day_at { Time.current }
  end
end
