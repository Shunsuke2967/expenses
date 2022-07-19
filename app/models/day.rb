class Day < ApplicationRecord
  belongs_to :month
  validates :money, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validate :current_month_validate

  enum icon: { rent: 0,
               cost_of_living: 1,
               food_expenses: 2,
               entertainment: 3,
               car_cost: 4,
               insurance: 5,
               payment: 6,
               others: 100
             }

  private

  def current_month_validate
    unless self.month.date_at.month == self.day_at.month && self.month.date_at.year == self.day_at.year
      errors.add(:day_at, "は現在の家計簿の月と違うので登録できません")
    end
  end
end
