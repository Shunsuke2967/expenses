FactoryBot.define do
  factory :budget do
    rent { 10000 }
    cost_of_living { 10000 }
    food_expenses { 10000 }
    entertainment { 10000 }
    other { 10000 }
    car_cost { 10000 }
    insurance { 10000 }
    association :expense
  end
end
