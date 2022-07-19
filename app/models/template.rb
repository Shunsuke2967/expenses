class Template < ApplicationRecord
  belongs_to :user
  validates :money, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  enum icon: { rent: 0,
    cost_of_living: 1,
    food_expenses: 2,
    entertainment: 3,
    car_cost: 4,
    insurance: 5,
    payment: 6,
    others: 100
  }
end
