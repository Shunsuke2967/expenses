class Budget < ApplicationRecord
  belongs_to :month
  validates :rent, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :cost_of_living, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :food_expenses, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :entertainment, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :others, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :car_cost, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :insurance, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
