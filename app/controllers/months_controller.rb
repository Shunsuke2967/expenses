class MonthsController < ApplicationController
  def index
    @page = params[:page]
    @months = current_user.months
    @current_budget = current_month.budgets.first
    @current_user_month_list = current_user.months.order(month_at: "DESC").page(params[:page])
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

end
