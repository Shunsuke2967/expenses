class Month < ApplicationRecord
  belongs_to :user
  has_many :days,dependent: :destroy
  has_one :budget,dependent: :destroy
  validates :income, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :income2, numericality: {only_integer: true, greater_than_or_equal_to: 0,allow_blank: true}
  validates :income3, numericality: {only_integer: true, greater_than_or_equal_to: 0,allow_blank: true}
  validates :income4, numericality: {only_integer: true, greater_than_or_equal_to: 0,allow_blank: true}
  validate :month_new_record,on: :create

  #すべての支出を項目別に合計したハッシュとすべての項目の合計値を返す(入金は外す)
  def days_total_spending
    spending = self.days.group(:icon).sum(:money).sort {|(k1, v1), (k2, v2)| v2 <=> v1 }.to_h
    spending.delete("入金")

   item_name = ["家賃","生活費","娯楽費","食費","自動車費","保険","その他"]
   item_name.map{ |name| spending[name] = 0 unless spending.include?(name)  }
    return spending
  end


  #引数によってどれを含めた総額にするかを分けている
  #処理自体は別のメソッドに任せている
  def total(salary: false, income: false, spending: false)
    income_int = self.total_income if income
    salary_int = self.total_salary if salary
    spending_int = self.total_spending if spending

    return (income_int.to_i + salary_int.to_i) - spending_int.to_i
  end

  #収入の総額
  def total_income
    self.days.where(income_and_outgo: true).sum(:money).to_i
  end

  #給与設定してある総額
  def total_salary
    self.income.to_i + self.income2.to_i + self.income3.to_i + self.income4.to_i
  end

  def total_spending
    self.days.where(income_and_outgo: false).sum(:money).to_i
  end

  private

  def month_new_record
    User.find(self.user.id).months.each do |self_date|
      if (self_date.month_at.year == self.month_at.year) && (self_date.month_at.month == self.month_at.month)
        errors.add(:month_at, "はすでに存在しています")
      end
    end
  end
end
