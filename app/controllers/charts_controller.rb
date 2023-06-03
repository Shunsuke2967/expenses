class ChartsController < ApplicationController
  def index
    @budget = current_expense.budget
  end
end
