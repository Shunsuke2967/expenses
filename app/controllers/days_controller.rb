class DaysController < ApplicationController
  def new
    @day = current_user.months.find(current_month.id).days.new
  end

  def create
   @day = current_user.months.find(current_month.id).days.new(day_params)
    if @day.save
      session[:show_active_page] = params[:setting_type]
      redirect_to root_path, notice: '追加しました'
    else
      render :new
    end
  end
  
  def edit
    @day = current_user.months.find(current_month.id).days.find(params[:id])
  end

  def update
    @day = current_user.months.find(current_month.id).days.find(params[:id])
    
    if @day.update(day_params)
      session[:show_active_page] = params[:setting_type]
      redirect_to root_url, notice: '修正しました'
    else
      render :edit
    end
  end

  def destroy
    day = current_user.months.find(current_month.id).days.find(params[:id])
    day.destroy
    session[:show_active_page] = params[:setting_type]
    redirect_to root_url, notice: '削除しました'
  end

  private

  def day_params
    params.require(:day).permit(:day_at,:icon,:memo,:spending,:money)
  end
end
