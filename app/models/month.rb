class Month < ApplicationRecord
  belongs_to :user
  has_many :days,dependent: :destroy
  has_many :budgets,dependent: :destroy
  validates :income, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validate :month_new_record,on: :create

  private

  def month_new_record
    User.find(self.user.id).months.each do |self_date|
      if (self_date.month_at.year == self.month_at.year) && (self_date.month_at.month == self.month_at.month)
        errors.add(:month_at, "はすでに存在しています")
      end
    end
  end
end
