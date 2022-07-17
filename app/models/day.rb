class Day < ApplicationRecord
  belongs_to :month
  validates :money, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validate :current_month_validate

  private

  def current_month_validate
    unless self.month.month_at.month == self.day_at.month && self.month.month_at.year == self.day_at.year
      errors.add(:day_at, "は現在の家計簿の月と違うので登録できません")
    end
  end
end
