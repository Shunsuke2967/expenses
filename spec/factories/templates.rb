FactoryBot.define do
  factory :template do
    icon { :rent }
    memo { 'メモ' }
    spending { true }
    money { 10_000 }
    association :user
  end
end
