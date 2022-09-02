class SessionsController < ApplicationController
  skip_before_action :login_required
  before_action :logined_skip, only: [:create,:index]
  def index
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      current_month_set
      user.setting_prepare
      session[:demo] = nil
      redirect_to root_url, notice: 'ログインしました'
    else
      flash[:danger] = 'ログインできませんでした'
      redirect_to sessions_path
    end  
  end

  def demo
    user = User.demo_data_create
    if user.valid?
      session[:user_id] = user.id
      current_month_set
      user.setting_prepare
      session[:demo] = true
      # 新規の最初のユーザーに見せるモーダルのための変数
      session[:first_user] = true
      redirect_to root_url, notice: 'デモ画面にログインしました'
    else
      flash[:danger] = 'エラーが発生しデモ画面に入れませんでした'
      redirect_to sessions_path
    end
  end


  private

  def session_params
    params.require(:session).permit(:email,:password)
  end

  def logined_skip
    redirect_to root_path if current_user.present?
  end
end
