class UsersController < ApplicationController
  skip_before_action :login_required,only: [:new,:create,:index]
  before_action :logined_skip, only: [:new,:create,:index]
  def index
  end

  def new
    @user = User.new
  end

  def create
   @user = User.new(user_params)

    if @user.save
      date = Time.zone.now
      @month = @user.months.create(date_at: Time.parse("#{date.year}/#{date.month}"))
      session[:user_id] = @user.id
      session[:month_id] = @month.id
      session[:demo] = nil
      @user.setting_prepare
      redirect_to root_url, notice: '新規登録に成功しました'
    end
  end


  def destroy
    reset_session
    redirect_to root_url, notice: "ログアウトしました"
  end

  # 利用規約
  def terms
  end

  def expansions
    @settings = current_user.setting_prepare
  end

  # ajaxで機能の拡張の状態を更新する
  def update_expansion
    logger.debug(params[:lis_data])
    ActiveRecord::Base.transaction do
      if current_user.contents.where(setting_id: params[:setting_id]).destroy_all
        params[:lis_data].each do |sort, type|
          current_user.contents.create(content_type: type[0], fix: type[1], sort_order: sort, setting_id: params[:setting_id])
        end
      else
        raise ActiveRecord::Rollback
      end
    end
    @settings = current_user.settings
  end

  # ajaxで機能の拡張の削除＆テンプレートを更新する
  def delete_expansion
    if current_user.contents.find(params[:id]).destroy
      @settings = current_user.settings
    end

    render :update_expansion
  end

  private

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end

  def logined_skip
    redirect_to root_path if current_user.present?
  end
end
