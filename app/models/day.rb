class Day < ApplicationRecord
  belongs_to :expense
  validates :money, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validate :current_expense_validate
  validates :day_at, presence: true

  enum icon: { rent: 0,
               cost_of_living: 1,
               food_expenses: 2,
               entertainment: 3,
               car_cost: 4,
               insurance: 5,
               payment: 6,
               others: 100
             }

  # 使いやすいようhashのタイトルなどを日本語にしているため、実際のdbから引き出すときなどに使用している
  TO_S_TITLE = {
    "家賃" => "rent",
    "生活費" => "cost_of_living",
    "食費" => "food_expenses",
    "娯楽費" => "entertainment",
    "自動車費" => "car_cost",
    "保険" => "insurance",
    "その他" => "others",
    "入金" => "payment"
  }

  def transfer(template,date_at)
    self.day_at = Time.parse("#{self.month.date_at.year}-#{self.month.date_at.month}-#{date_at}")
    self.icon = template.icon
    self.memo = template.memo
    self.spending = template.spending
    self.money = template.money
    return self
  end

  private

  def current_expense_validate
    return unless self.day_at.present?
    unless self.expense.date_at.month == self.day_at.month && self.expense.date_at.year == self.day_at.year
      errors.add(:day_at, "は現在の家計簿の月と違うので登録できません")
    end
  end
end
