class UsersController < ApplicationController
  skip_before_action :login_required

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
      redirect_to root_url, notice: '新規登録に成功しました'
    end
  end


  def destroy
    reset_session
    redirect_to root_url, notice: "ログアウトしました"
  end


  private

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
end
