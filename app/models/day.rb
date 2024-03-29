class Day < ApplicationRecord
  belongs_to :expense
  validates :money, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :current_expense_validate
  validates :day_at, presence: true

  enum icon: { rent: 1,
               cost_of_living: 2,
               food_expenses: 3,
               entertainment: 4,
               car_cost: 5,
               insurance: 6,
               payment: 7,
               other: 100 }

  def transfer(template, date_at)
    self.day_at = Time.parse("#{expense.date_at.year}-#{expense.date_at.month}-#{date_at}")
    self.icon = template.icon
    self.memo = template.memo
    self.spending = template.spending
    self.money = template.money
    self
  end

  # 渡された文字列からenumのi18n変換
  def self.parse_icon_to_s(key)
    I18n.t(key, scope: [:activerecord, :attributes, :day, :icons])
  end

  private

  def current_expense_validate
    return unless day_at.present?

    return if expense.date_at.month == day_at.month && expense.date_at.year == day_at.year

    errors.add(:day_at, 'は現在の家計簿の月と違うので登録できません')
  end
end
