class MonthsController < ApplicationController
  def index
    if session[:show_active_page].present?
      @show_active_page = session[:show_active_page]
      session[:show_active_page] = nil
    end
    @page = params[:page]
    @months = current_user.months
    @q = current_month.days.ransack(params[:q])
    @current_days = @q.result
    @current_user_month_list = current_user.months.order(month_at: "DESC").page(params[:page])
    @total_spending_list = current_month.days_total_spending
    @current_sum = sums_hash(@current_days,current_month)

    #ログイン中の年月分までの収支のトータル
    @income_and_expenditure = income_expenditure(@current_user_month_list,current_month.month_at)
    #ログイン中の年月の収支
    @current_income_and_expenditure = current_month.total(salary: true,income: true,spending: true)
  end


  def new
    @month = current_user.months.new
  end

  def create
    month_at = "#{month_params[:year_at]}-#{month_params[:month_at]}-1".in_time_zone
    @month = current_user.months.new(income: month_params[:income],income2: month_params[:income2],income3: month_params[:income3],income4: month_params[:income4],month_at: month_at)
    month = current_user.months.order(month_at: "DESC").first

    if @month.save
      session[:month_id] = @month.id
      budget = month.budgets.first
      if budget
        @month.budgets.new(rent: budget.rent,cost_of_living: budget.cost_of_living,food_expenses: budget.food_expenses,entertainment: budget.entertainment,car_cost: budget.car_cost,insurance: budget.insurance,others: budget.others).save
      end

      redirect_to root_url, notice: "新しい家計簿を作成しました"
    end
  end

  def edit
    @month = current_month
  end

  def update
    @month = current_month

    if @month.update(income_params)
      session[:show_active_page] = :template
      redirect_to root_url,notice: '収入金額を再設定しました'
    end
  end

  def destroy
    month = current_user.months.find(params[:id])
    month.destroy
    current_month_set

    redirect_to root_url, notice: "#{month.month_at.year}年#{month.month_at.month}月の家計簿を削除しました"
  end

  def monthcurrent
    month = current_user.months.find(params[:id])
    session[:month_id] = month.id
    redirect_to root_url, notice: "#{month.month_at.year}年#{month.month_at.month}月にログインしました"
  end



  private

  def income_params
    params.require(:month).permit(:income,:income,:income2,:income3,:income4)
  end

  def month_params
    params.require(:month).permit(:month_at,:income,:income2,:income3,:income4,:year_at)
  end

  #渡した支出のデータから収入、支出、収支の合計のハッシュを返す
  #月のインスタンスを渡した場合にはその月に設定した収入を入れて計算する
  def sums_hash(days, month=nil)
    sum = {}
    if month.present?
      sum[:incomes_sum] = days.where(income_and_outgo: true).sum(:money).to_i + month.income.to_i + month.income2.to_i + month.income3.to_i + month.income4.to_i
    else
      sum[:incomes_sum] = days.where(income_and_outgo: true).sum(:money).to_i
    end
    #月の支出合計
    sum[:spending_sum] = days.where(income_and_outgo: false).sum(:money).to_i
    #月の収支合計
    sum[:computation] = sum[:incomes_sum] - sum[:spending_sum]

    return sum
  end

  private

  #渡した年月までの収支を計算してその値を返す
  def income_expenditure(months, date)
    return if months.blank?
    income_expenditure = 0
    months.where("month_at <= ?" , date).each do |month|
      income_expenditure  += month.total(salary: true, income: true, spending: true)
    end

    return income_expenditure 
  end
end
