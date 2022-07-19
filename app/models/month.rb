class Month < ApplicationRecord
  belongs_to :user
  has_many :days,dependent: :destroy
  has_one :budget,dependent: :destroy
  validates :salary, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :salary_2, numericality: {only_integer: true, greater_than_or_equal_to: 0,allow_blank: true}
  validates :salary_3, numericality: {only_integer: true, greater_than_or_equal_to: 0,allow_blank: true}
  validates :salary_4, numericality: {only_integer: true, greater_than_or_equal_to: 0,allow_blank: true}
  validate :month_new_record,on: :create

  #すべての支出を項目別に合計したハッシュとすべての項目の合計値を返す(入金は外す)
  def days_total_spending
    spending = self.days.group(:icon).sum(:money).sort {|(k1, v1), (k2, v2)| v2 <=> v1 }.to_h
    spending.delete("payment")

    item_name = Day.icons.keys
    item_name.delete("payment")
    item_name.map{ |name| spending[name] = 0 unless spending.include?(name)  }
    # keyを日本語に変換
    spending_i18n = {}
    # 変換用ハッシュを用意
    i18n_item = { "rent" => "家賃", "cost_of_living" => "生活費", "food_expenses" => "食費", "entertainment" => "娯楽費", "car_cost" => "自動車費", "insurance" => "保険", "others" => "その他" }
    spending.each do |key,value|
      spending_i18n[i18n_item[key]] = value
    end

    return spending_i18n
  end


  #引数によってどれを含めた総額にするかを分けている
  #処理自体は別のメソッドに任せている
  def total(salary: false, income: false, spending: false)
    income_int = self.total_income if income
    salary_int = self.total_salary if salary
    spending_int = self.total_spending if spending

    return (income_int.to_i + salary_int.to_i) - spending_int.to_i
  end

  # 収入の総額
  def total_income
    self.days.where(spending: false).sum(:money).to_i
  end

  # 給与設定してある総額
  def total_salary
    self.salary.to_i + self.salary_2.to_i + self.salary_3.to_i + self.salary_4.to_i
  end

  # 支払いの総額
  def total_spending
    self.days.where(spending: true).sum(:money).to_i
  end

  # 設定してある給与のハッシュを返す
  def salary_list
    salary_list = {}
    salary_list[:salary] = self.salary if self.salary.present?
    salary_list[:salary_2] = self.salary_2 if self.salary_2.present?
    salary_list[:salary_3] = self.salary_3 if self.salary_3.present?
    salary_list[:salary_4] = self.salary_4 if self.salary_4.present?
    return salary_list
  end

  # dbに値があればそれを返す
  # ログイン中の月のその日の日付を返す
  # その日が31日でログイン中の月にない場合はその月の月末日を設定して返す
  def date_to_s(day)
    return day.day_at.strftime("%Y-%m-%d") if day.day_at.present?
    return Time.parse("#{self.date_at.year}-#{self.date_at.month}-#{Time.zone.now.day}").strftime("%Y-%m-%d") \
      rescue return Time.parse("#{self.date_at.year}-#{self.date_at.month}-1").end_of_month.strftime("%Y-%m-%d")
  end

  private

  def month_new_record
    User.find(self.user.id).months.each do |self_date|
      if (self_date.date_at.year == self.date_at.year) && (self_date.date_at.month == self.date_at.month)
        errors.add(:date_at, "はすでに存在しています")
      end
    end
  end
end
