class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create, :index, :terms]
  before_action :logined_skip, only: [:new, :create, :index, :terms]
  def new
    @user = User.new
  end

  def create
   @user = User.new(user_params)

    if @user.save
      date = Time.current
      @expense = @user.expenses.create(date_at: Time.parse("#{date.year}/#{date.month}"))
      session[:user_id] = @user.id
      session[:expense_id] = @expense.id
      # 新規の最初のユーザーに見せるモーダルのための変数
      session[:first_user] = true
      redirect_to root_url, notice: '新規登録に成功しました'
    else
      redirect_to new_user_path(user_params), alert: @user.errors.full_messages
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: 'ログアウトしました'
  end

  # 利用規約
  def terms
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logined_skip
    redirect_to root_path if current_user.present?
  end
end
