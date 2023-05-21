class Budget < ApplicationRecord
  belongs_to :expense
  validates :rent, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :cost_of_living, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :food_expenses, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :entertainment, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :others, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :car_cost, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :insurance, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}


  def all_budget
    self.rent + self.cost_of_living + self.food_expenses + self.entertainment + self.others + self.car_cost + self.insurance
  end

  def item_budget(item_s)
    case item_s
    when "家賃"
      self.rent
    when "生活費"
      self.cost_of_living
    when "娯楽費"
      self.entertainment
    when "食費"
      self.food_expenses
    when "自動車費"
      self.car_cost
    when "保険"
      self.insurance
    when "その他"
      self.others
    else
      return 0
    end
  end
end
