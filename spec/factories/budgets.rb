FactoryBot.define do
  factory :budget do
    rent { 10_000 }
    cost_of_living { 10_000 }
    food_expenses { 10_000 }
    entertainment { 10_000 }
    other { 10_000 }
    car_cost { 10_000 }
    insurance { 10_000 }
    association :expense
  end
end
