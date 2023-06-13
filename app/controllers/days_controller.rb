class DaysController < ApplicationController
  before_action :set_days, only: [:edit, :update, :destroy]
  def new
    @day = current_expense.days.new
  end

  def create
   @day = current_expense.days.new(day_params)
    if @day.save
      redirect_to root_path, notice: '追加しました'
    else
      render :new
    end
  end
  
  def edit
  end

  def update
    if @day.update(day_params)
      redirect_to root_url, notice: '修正しました'
    else
      render :edit
    end
  end

  def destroy
    @day.destroy
    redirect_to root_url, notice: '削除しました'
  end

  private

  def day_params
    params.require(:day).permit(:day_at, :icon, :memo, :spending, :money)
  end

  def set_days
    @day = current_expense.days.find(params[:id])
  end
end
