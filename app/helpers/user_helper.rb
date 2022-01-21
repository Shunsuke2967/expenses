module UserHelper

  def line_chart_date_hash(user)
    month_money = []
    month_money_average = []
    month_count = 1
    month_sum = 0
    month_hash = {}
    month_hash["name"] = "収支"
    month_hash_average = {}
    month_hash_average["name"] = "収支平均"
    user.months.order(:month_at).each do |month|
      int_sum = month.days.where(income_and_outgo: true).sum(:money).to_i + month.income
      float_sum = month.days.where(income_and_outgo: false).sum(:money).to_i
      subtraction = int_sum - float_sum
      month_sum += subtraction 
      month_money << ["#{month.month_at.year}年#{month.month_at.month}月",subtraction]
      month_money_average << ["#{month.month_at.year}年#{month.month_at.month}月",(month_sum.to_f / month_count).to_i]
      month_count += 1
    end


    month_hash_average["data"] = month_money_average
    month_hash["data"] = month_money
    return line_chart_date = [month_hash,month_hash_average]
  end
end
