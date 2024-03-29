module UserHelper
  def line_chart_date_hash(user)
    month_money = []
    month_money_average = []
    month_count = 1
    month_sum = 0
    month_hash = {}
    month_hash['name'] = '収支'
    month_hash_average = {}
    month_hash_average['name'] = '収支平均'
    user.expenses.order(:date_at).last(12).each do |month|
      subtraction = month.total(salary: true, income: true, spending: true)
      month_sum += subtraction
      month_money << ["#{month.date_at.year}年#{month.date_at.month}月", subtraction]
      month_money_average << ["#{month.date_at.year}年#{month.date_at.month}月", (month_sum.to_f / month_count).to_i]
      month_count += 1
    end

    month_hash_average['data'] = month_money_average
    month_hash['data'] = month_money
    [month_hash, month_hash_average]
  end

  def area_chart_date_hash(user)
    month_money = []
    month_hash = {}
    sum_month = 0
    month_hash['name'] = '口座残高'
    user.expenses.order(:date_at).each do |month|
      sum_month += month.total(salary: true, spending: true, income: true)
      month_money << ["#{month.date_at.year}年#{month.date_at.month}月", sum_month]
    end

    month_hash['data'] = month_money
    [month_hash]
  end
end
