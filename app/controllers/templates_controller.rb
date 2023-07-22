class TemplatesController < ApplicationController
  before_action :set_template, only: [:edit, :update, :destroy]
  def new
    @template = current_user.templates.new
  end

  def create
    @template = current_user.templates.new(template_params)
    if @template.save
      redirect_to imports_path, notice: 'テンプレートに追加しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @template.update(template_params)
      redirect_to imports_path, notice: 'テンプレートを変更しました'
    else
      render :edit
    end
  end

  def destroy
    @template.destroy!
    redirect_to root_url, notice: "テンプレートを削除しました"
  end

  def day_select
    if params[:ids].present?
      @templates = current_user.templates.where(id: params[:ids])
    else
      flash[:danger] = '一つ以上選択してください'
      redirect_to root_path
    end
  end

  def days_create
    if params[:date_at].present?
      if current_expense.days_create(params[:date_at])
        redirect_to root_url, notice: '収支一覧表に追加しました'
      else
        flash[:danger] = '追加時にエラーが発生しました'
        redirect_to root_url
      end
    else
      flash[:danger] = '対象が見つかりません'
      redirect_to root_url
    end
  end

  private

  def template_params
    params.require(:template).permit(:icon, :memo, :spending, :money)
  end

  def template_day_params
    params.require(:template).permit(:day_at, :icon, :memo, :spending, :money)
  end

  def set_template
    @template = current_user.templates.find(params[:id])
  end
end
