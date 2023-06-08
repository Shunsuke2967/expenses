class ExpensesController < ApplicationController
  def index
    if session[:first_user].present?
      @first_user = true
      session[:first_user] = nil
    end
    #search_form_forのため空のRansackオブジェクトを作成
    #検索はajax(searchアクション)で行う
    @q = current_expense.days.ransack
    @budget = current_expense.budget
  end

  # ajax用
  def search
    if params[:q].present?
      result = current_expense.days.ransack(params[:q]).result
      render json:  result.map { |day| day.id  }.to_json
    end
  end


  def new
    @expense = current_user.expenses.new
  end

  def create
    date_at = Time.parse("#{expense_params[:year]}/#{expense_params[:expense]}")
    # 行が長いので下記の方が可読性が良さそうです！
    # @expense = current_user.expenses.new(salary: expense_params[:salary],
    #                                      salary_2: expense_params[:salary_2],
    #                                      salary_3: expense_params[:salary_3],
    #                                      salary_4: expense_params[:salary_4],
    #                                      date_at: date_at)
    @expense = current_user.expenses.new(salary: expense_params[:salary],salary_2: expense_params[:salary_2],salary_3: expense_params[:salary_3],salary_4: expense_params[:salary_4],date_at: date_at)
    expense = current_user.expenses.order(date_at: "DESC").first

    if @expense.save
      session[:expense_id] = @expense.id
      budget = expense.budget
      if budget
        @expense.budget.new(rent: budget.rent,cost_of_living: budget.cost_of_living,food_expenses: budget.food_expenses,entertainment: budget.entertainment,car_cost: budget.car_cost,insurance: budget.insurance,other: budget.other).save
      end

      redirect_to root_url, notice: "新しい家計簿を作成しました"
    end
  end

  def edit_salary
  end

  def update_salary
    # ここってupdateが失敗するパターンは存在しないですか？？
    # もしなさそうでも値の改竄やその他通信環境で落ちる可能性はありそうなのでupdate!でとりあえずエラー出るようにはするか、elseで用意するかあれば良いかもです！
    if current_expense.update(salary_params)
      redirect_to salary_list_expenses_path, notice: '収入金額を再設定しました'
    end
  end

  def destroy
    expense = current_user.expenses.find(params[:id])
    expense.destroy
    current_expense_set

    redirect_to root_url, notice: "#{expense.date_at.year}年#{expense.date_at.month}月の家計簿を削除しました"
  end

  def change
    expense = current_user.expenses.find(params[:id])
    session[:expense_id] = expense.id
    redirect_to root_url, notice: "#{expense.date_at.year}年#{expense.date_at.month}月にログインしました"
  end

  def list
    @page = params[:page]
    @current_user_expense_list = current_user.expenses.order(date_at: "DESC").page(params[:page])
    #ログイン中の年月分までの収支のトータル
    @current_income_and_expenditure = current_expense.total(salary: true,income: true,spending: true)
  end

  private

  def salary_params
    params.require(:expense).permit(:salary,:salary_2,:salary_3,:salary_4)
  end

  def expense_params
    params.require(:expense).permit(:year,:expense,:salary,:salary_2,:salary_3,:salary_4)
  end

  #渡した支出のデータから収入、支出、収支の合計のハッシュを返す
  #月のインスタンスを渡した場合にはその月に設定した収入を入れて計算する
  # これは処理内容的にモデルに持っていった方が良いかもです
  # というか今はこれ呼び出されてるとこなさそうですね・・・
  def sums_hash(days, expense=nil)
    sum = {}
    if expense.present?
      sum[:incomes_sum] = days.where(spending: false).sum(:money).to_i + expense.salary.to_i + expense.salary_2.to_i + expense.salary_3.to_i + expense.salary_4.to_i
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
  def income_expenditure(expenses, date)
    return if expenses.blank?
    income_expenditure = 0
    expenses.where("date_at <= ?" , date).each do |expense|
      income_expenditure  += expense.total(salary: true, income: true, spending: true)
    end

    return income_expenditure 
  end
end
