# 予算
class Budget < ApplicationRecord
  belongs_to :expense
  validates :rent, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :cost_of_living, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :food_expenses, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :entertainment, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :other, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :car_cost, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :insurance, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  # 引数の種別の予算と支払いの差分を返す
  def progress(type)
    return self.send(type) - expense_spending(type)
  end

  def expense_spending(type)
    expense.days.where(spending: true, icon: type).sum(:money)
  end

  # 予算の合計を返す
  def total
    rent + cost_of_living + food_expenses + entertainment + other + car_cost + insurance
  end

  # 種別のキーの配列を返す
  def self.type_keys
    [:rent, :cost_of_living, :food_expenses, :entertainment, :other, :car_cost, :insurance]
  end
end
