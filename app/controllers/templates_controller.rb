class TemplatesController < ApplicationController
  def new
    @template = current_user.templates.new
  end

  def create
   @template = current_user.templates.new(template_params)
    if @template.save
      redirect_to root_path, notice: 'テンプレートに追加しました'
    end
  end

  def edit
    @template = current_user.templates.find(params[:id])
  end

  def update
    @template = current_user.templates.find(params[:id])

    if @template.update(template_params)
      redirect_to root_url, notice: 'テンプレートを変更しました'
    end
  end

  def add
    @template = current_user.templates.find(params[:id])
  end

  def createadd
   @day = current_user.months.find(current_month.id).days.new(template_day_params)
    if @day.save
      redirect_to root_path, notice: '追加しました'
    end
  end

  def destroy
    @template = current_user.templates.find(params[:id])
    @template.destroy

    redirect_to root_url, notice: "テンプレートを削除しました"

  end


  private

  def template_params
    params.require(:template).permit(:icon,:memo,:income_and_outgo,:money)
  end

  def template_day_params
    params.require(:template).permit(:day_at,:icon,:memo,:income_and_outgo,:money)
  end

end
