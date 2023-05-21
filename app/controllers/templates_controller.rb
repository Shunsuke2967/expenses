class TemplatesController < ApplicationController
  def new
    @template = current_user.templates.new
  end

  def create
   @template = current_user.templates.new(template_params)
    if @template.save
      redirect_to root_path, notice: 'テンプレートに追加しました'
    else
      render :new
    end
  end

  def edit
    @template = current_user.templates.find(params[:id])
  end

  def update
    @template = current_user.templates.find(params[:id])

    if @template.update(template_params)
      redirect_to root_url, notice: 'テンプレートを変更しました'
    else
      render :edit
    end
  end

  def add
    @template = current_user.templates.find(params[:id])
  end

  def create_add
    @day = current_user.expenses.find(current_expense.id).days.new(template_day_params)
    if @day.save
      redirect_to root_path, notice: '追加しました'
    end
  end

  def destroy
    @template = current_user.templates.find(params[:id])
    @template.destroy

    redirect_to root_url, notice: "テンプレートを削除しました"
  end

  def day_select
    if params[:ids].present?
      @templates = current_user.templates.where(id: params[:ids])
    else
      logger.debug(params)
      flash[:danger] = '一つ以上選択してください'
      redirect_to root_path
    end
  end

  def days_create
    if params[:date_at].present?
      if current_expense.days_create(params[:date_at])
        redirect_to root_url, notice: "収支一覧表に追加しました"
      else
        flash[:danger] = "追加時にエラーが発生しました"
        redirect_to root_url
      end
    else
      flash[:danger] = "対象が見つかりません"
      redirect_to root_url
    end
  end

  private

  def template_params
    params.require(:template).permit(:icon,:memo,:spending,:money)
  end

  def template_day_params
    params.require(:template).permit(:day_at,:icon,:memo,:spending,:money)
  end

end
