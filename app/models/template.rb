class Template < ApplicationRecord
  belongs_to :user
  validates :money, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enum icon: { rent: 0,
               cost_of_living: 1,
               food_expenses: 2,
               entertainment: 3,
               car_cost: 4,
               insurance: 5,
               payment: 6,
               other: 100 }

  def set_class
    case icon
    when 'rent'
      ['icon-color-red', 'fas fa-home']
    when 'food_expenses'
      ['icon-color-yellow', 'fas fa-utensils']
    when 'cost_of_living'
      ['icon-color-lightblue', 'fas fa-faucet']
    when 'entertainment'
      ['icon-color-green', 'fas fa-shopping-cart']
    when 'car_cost'
      ['icon-color-violetgreen', 'fas fa-car-side']
    when 'insurance'
      ['icon-color-violet', 'fas fa-hospital-user']
    when 'payment'
      ['icon-color-gray', 'fas fa-yen-sign']
    when 'other'
      ['icon-color-gray', 'far fa-question-circle']
    else
      ''
    end
  end
end
