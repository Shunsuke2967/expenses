class BudgetsController < ApplicationController
  def edit
    @budget = current_expense.budget
  end

  def update
    @budget = current_expense.budget

    if @budget.update(budget_params)
      redirect_to charts_path, notice: "予算費を再設定しました"
    else
      redirect_to edit_budget_path(budget_params), alert: @budget.errors.full_messages
    end
  end

  def new
    @budget = current_expense.build_budget
  end

  def create
    @budget = current_expense.build_budget(budget_params)

    if @budget.save
      redirect_to charts_path, notice: "予算費を設定しました"
    else
      redirect_to new_budget_path(budget_params), alert: @budget.errors.full_messages
    end
  end

  private

  def budget_params
    params.require(:budget).permit(:rent, :cost_of_living, :food_expenses, :entertainment, :car_cost, :insurance, :other)
  end


end
