class User < ApplicationRecord
  has_many :expenses, dependent: :destroy
  has_many :templates, dependent: :destroy
  has_secure_password

  validates :name, presence: true
  validates :email,presence: true,uniqueness: true
  validates :password, confirmation: true
  validates :demo, inclusion: {in: [true, false]}

  # 渡した年月までの収支を計算する
  def expense_balance(to_date)
    income_expenditure = 0
    expenses.where("date_at <= ?" , to_date).each do |expense|
      income_expenditure  += expense.total(salary: true, income: true, spending: true)
    end
    return income_expenditure 
  end

  # 一番最新の家計簿を返す 
  def related_expense
    expenses.order(date_at: "DESC").first
  end

  # デモ機能
  # ユーザーを作成して、それに伴いデータも生成する
  # demo_sessions_pathにログインするたびに新しくデータを作成する
  # 残ったデータは一定時間で削除する仕様にする
  def self.demo_data_create
    demo_user = self.new(
      name: "demo",
      email: "#{SecureRandom.hex(10)}@#{Date.current.to_s}.jp",
      password: "password",
      password_confirmation: "password",
      demo: true
    )
    # emailはユニークなので値がかぶった場合は新しい値を入れて実行
    # error_countで10回saveが失敗したら終了する
    if !demo_user.save
      error_count = 0
      while error_count <= 10
        demo_user.email = "#{SecureRandom.hex(10)}@#{Date.current.to_s}.jp"
        error_count += 1
        break if demo_user.save
      end
    end
    return nil unless demo_user.persisted?

    demo_user.create_demo_data
    return demo_user
  end

  # 紐づく家計簿を作成する
  def create_demo_data
    date = Time.current
    0.upto(11) do |n|
      create_demo_expenses(date.ago(n.month))
    end
  end

  # 家計簿作成
  def create_demo_expenses(month_at)
    # 6桁で最初の値が1... になるよう修正
    salary_1 = "".rjust(6,"1" + SecureRandom.random_number(1000).to_s).to_i
    salary_2 = "".rjust(6,"1" + SecureRandom.random_number(1000).to_s).to_i
      expense = self.expenses.create(
        date_at: month_at,
        salary: salary_1,
        salary_2: salary_2
      )

    create_demo_day(month_at,expense)
  end

  # 家計簿に紐づくDayを作成
  def create_demo_day(month_at,expense)
    # 家賃と自動車費と保険と入金だけは1つだけ作成する
    expense.days.create(
    icon: Day.icons[:rent],
    day_at: month_at,
    memo: "毎月1日 家賃",
      money: 75000,
      spending: true
    )

    expense.days.create(
      icon: Day.icons[:car_cost],
      day_at: month_at.since(4.day),
      memo: "毎月5日 自動車ローン",
      money: 52000,
      spending: true
    )

    expense.days.create(
      icon: Day.icons[:insurance],
      day_at: month_at.since(14.day),
      memo: "毎月15日 自動車保険",
      money: 15000,
      spending: true
    )

    expense.days.create(
      icon: Day.icons[:insurance],
      day_at: month_at.since(24.day),
      memo: "毎月25日 生命保険",
      money: 15980,
      spending: true
    )

    expense.days.create(
      icon: Day.icons[:cost_of_living],
      day_at: month_at.since(24.day),
      memo: "水道代",
      money: 5251,
      spending: true
    )

    expense.days.create(
      icon: Day.icons[:cost_of_living],
      day_at: month_at.since(24.day),
      memo: "電気代",
      money: 8127,
      spending: true
    )

    expense.days.create(
      icon: Day.icons[:cost_of_living],
      day_at: month_at.since(24.day),
      memo: "ガス代",
      money: 11439,
      spending: true
    )

    # 入金はランダムに作成したり、しなかったりする
    if SecureRandom.random_number(2) == 0
      expense.days.create(
        icon: Day.icons[:payment],
        day_at: month_at.since(12.day),
        memo: "株式の配当金",
        money: 2000,
        spending: false
      )
    end

    # 入金(ボーナス)に7月に設定
    if month_at.month == 7
      expense.days.create(
        icon: Day.icons[:payment],
        day_at: month_at.since(24.day),
        memo: "ボーナス",
        money: 200000,
        spending: false
      )
    end

    # 娯楽費: 4万、その他: 1万をランダムで作成
    create_other(Day.icons.keys, month_at, expense)
  end

  # 娯楽や食費やその他の出費をランダムに作成
  def create_other(icons, month_at, expense)
    icons.delete("insurance")
    icons.delete("car_cost")
    icons.delete("payment")
    icons.each do |icon|
      amount = {
        "food_expenses" => 0,
        "entertainment" => 0,
        "other" => 0
      }
      memo = {}
      memo["food_expenses"] = ["外食","おやつ","会食","社食","ガスト","マック","バイキング"]
      memo["entertainment"] = ["クレーンゲーム","釣り具購入","筋トレ道具購入","飲み会","友達と焼き肉","遊園地","県外に遊び","本購入"]
      memo["other"] = ["修理費","出張費","社内講習会"]
      case icon
      when "food_expenses"
        while amount[icon] < 60000
          money = SecureRandom.random_number(4001)
          index = SecureRandom.random_number(memo[icon].length + 2)
          day = SecureRandom.random_number(month_at.end_of_month.day)
          next if money == 0
          day = expense.days.create(
            icon: Day.icons[:food_expenses],
            day_at: month_at.since(day.day),
            memo: memo[icon][index],
            money: money,
            spending: true
          )
          amount[icon] = amount[icon] + day.money
        end
      when "entertainment"
        while amount[icon] < 70000
          money = SecureRandom.random_number(8001)
          index = SecureRandom.random_number(memo[icon].length + 2)
          day = SecureRandom.random_number(month_at.end_of_month.day)
          next if money == 0
          day = expense.days.create(
            icon: Day.icons[:entertainment],
            day_at: month_at.since(day.day),
            memo: memo[icon][index],
            money: money,
            spending: true
          )
          amount[icon] = amount[icon] + day.money
        end
      when "other"
        money = [7000,3000,6000][SecureRandom.random_number(3)]
        index = SecureRandom.random_number(memo[icon].length + 1)
        day = SecureRandom.random_number(month_at.end_of_month.day)
        day = expense.days.create(
          icon: Day.icons[:other],
          day_at: month_at.since(day.day),
          memo: memo[icon][index],
          money: money,
          spending: true
        )
      end
    end
  end
end