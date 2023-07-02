class ExpensesController < ApplicationController
  def index
    if session[:first_user].present?
      @first_user = true
      session[:first_user] = nil
    end
    # search_form_forのため空のRansackオブジェクトを作成
    # 検索はajax(searchアクション)で行う
    @q = current_expense.days.ransack
    @budget = current_expense.budget
  end

  # ajax用
  def search
    return unless params[:q].present?

    result = current_expense.days.ransack(params[:q]).result
    render json: result.map { |day| day.id }.to_json
  end

  def new
    @expense = current_user.expenses.new
  end

  def create
    date = Time.zone.parse("#{expense_params[:year]}/#{expense_params[:month]}")
    @expense = current_user.expenses.new(
      salary: expense_params[:salary],
      salary_2: expense_params[:salary_2],
      salary_3: expense_params[:salary_3],
      salary_4: expense_params[:salary_4],
      date_at: date
    )
    budget = current_user.related_expense.budget
    return unless @expense.save

    session[:expense_id] = @expense.id
    @expense.set_budget(budget)
    redirect_to root_url, notice: '新しい家計簿を作成しました'
  end

  def edit_salary
  end

  def update_salary
    return unless current_expense.update(salary_params)

    redirect_to salary_list_expenses_path, notice: '収入金額を再設定しました'
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
    @current_user_expense_list = current_user.expenses.order(date_at: 'DESC').page(params[:page])
    # ログイン中の年月分までの収支のトータル
    @current_income_and_expenditure = current_expense.total(salary: true, income: true, spending: true)
  end

  private

  def salary_params
    params.require(:expense).permit(:salary, :salary_2, :salary_3, :salary_4)
  end

  def expense_params
    params.require(:expense).permit(:year, :month, :salary, :salary_2, :salary_3, :salary_4)
  end
end
