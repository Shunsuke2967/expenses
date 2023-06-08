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
    other: 100
  }

  # 値によってclassを返すだけであれば、Decoratorに書いた方が良さそうです！
  def set_class
    case self.icon
    when "rent"
      return ["icon-color-red","fas fa-home"]
    when "food_expenses"
      return ["icon-color-yellow","fas fa-utensils"]
    when "cost_of_living"
      return ["icon-color-lightblue","fas fa-faucet"]
    when "entertainment"
      return ["icon-color-green","fas fa-shopping-cart"]
    when "car_cost"
      return ["icon-color-violetgreen","fas fa-car-side"]
    when "insurance"
      return ["icon-color-violet","fas fa-hospital-user"]
    when "payment"
      return ["icon-color-gray","fas fa-yen-sign"]
    when "other"
      return ["icon-color-gray","far fa-question-circle"]
    else
      return ""
    end
  end
end
