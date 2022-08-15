class MonthsController < ApplicationController
  def index
    if session[:show_active_page].present? || params[:setting_type]
      @show_active_page = session[:show_active_page] ||= params[:setting_type]
      session[:show_active_page] = nil
    end
    @page = params[:page]
    @months = current_user.months
    #search_form_forのため空のRansackオブジェクトを作成
    #検索はajaxで行う
    @q = current_month.days.ransack
    @current_days = @q.result
    @current_user_month_list = current_user.months.order(date_at: "DESC").page(params[:page])
    @total_spending_list = current_month.days_total_spending
    @current_sum = sums_hash(@current_days,current_month)
    #ログイン中の年月分までの収支のトータル
    @income_and_expenditure = income_expenditure(@current_user_month_list,current_month.date_at)
    #ログイン中の年月の収支
    @current_income_and_expenditure = current_month.total(salary: true,income: true,spending: true)
    @settings = current_user.settings.order(sort_order: :asc)

    # 部分テンプレート生成用のためインスタンス変数をhashにまとめる
    @locals_date = { 
      current_days: @current_days,
      current_user_month_list: @current_user_month_list,
      total_spending_list: @total_spending_list,
      current_sum: @current_sum,
      income_and_expenditure: @income_and_expenditure,
      current_income_and_expenditure: @current_income_and_expenditure,
    }
  end

  # ajax用
  def search
    if params[:q].present?
      result = current_month.days.ransack(params[:q]).result
      render json:  result.map { |day| day.id  }.to_json
    end
  end


  def new
    @month = current_user.months.new
  end

  def create
    date_at = Time.parse("#{month_params[:year]}/#{month_params[:month]}")
    @month = current_user.months.new(salary: month_params[:salary],salary_2: month_params[:salary_2],salary_3: month_params[:salary_3],salary_4: month_params[:salary_4],date_at: date_at)
    month = current_user.months.order(date_at: "DESC").first

    if @month.save
      session[:month_id] = @month.id
      budget = month.budget
      if budget
        @month.budget.new(rent: budget.rent,cost_of_living: budget.cost_of_living,food_expenses: budget.food_expenses,entertainment: budget.entertainment,car_cost: budget.car_cost,insurance: budget.insurance,others: budget.others).save
      end

      redirect_to root_url, notice: "新しい家計簿を作成しました"
    end
  end

  def edit
    @month = current_month
  end

  def update
    @month = current_month

    if @month.update(salary_params)
      session[:show_active_page] = :template
      redirect_to root_url,notice: '収入金額を再設定しました'
    end
  end

  def destroy
    month = current_user.months.find(params[:id])
    month.destroy
    current_month_set

    redirect_to root_url, notice: "#{month.date_at.year}年#{month.date_at.month}月の家計簿を削除しました"
  end

  def month_current
    month = current_user.months.find(params[:id])
    session[:month_id] = month.id
    redirect_to root_url, notice: "#{month.date_at.year}年#{month.date_at.month}月にログインしました"
  end

  def expenses_list
    @page = params[:page]
    @current_user_month_list = current_user.months.order(date_at: "DESC").page(params[:page])
    #ログイン中の年月分までの収支のトータル
    @current_income_and_expenditure = current_month.total(salary: true,income: true,spending: true)
  end

  def current_salary
  end



  private

  def salary_params
    params.require(:month).permit(:salary,:salary_2,:salary_3,:salary_4)
  end

  def month_params
    params.require(:month).permit(:year,:month,:salary,:salary_2,:salary_3,:salary_4)
  end

  #渡した支出のデータから収入、支出、収支の合計のハッシュを返す
  #月のインスタンスを渡した場合にはその月に設定した収入を入れて計算する
  def sums_hash(days, month=nil)
    sum = {}
    if month.present?
      sum[:incomes_sum] = days.where(spending: false).sum(:money).to_i + month.salary.to_i + month.salary_2.to_i + month.salary_3.to_i + month.salary_4.to_i
    else
      sum[:incomes_sum] = days.where(spending: false).sum(:money).to_i
    end
    #月の支出合計
    sum[:spending_sum] = days.where(spending: true).sum(:money).to_i
    #月の収支合計
    sum[:computation] = sum[:incomes_sum] - sum[:spending_sum]

    return sum
  end

  private

  #渡した年月までの収支を計算してその値を返す
  def income_expenditure(months, date)
    return if months.blank?
    income_expenditure = 0
    months.where("date_at <= ?" , date).each do |month|
      income_expenditure  += month.total(salary: true, income: true, spending: true)
    end

    return income_expenditure 
  end
end
