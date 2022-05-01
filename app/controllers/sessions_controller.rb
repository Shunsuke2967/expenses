class SessionsController < ApplicationController
  skip_before_action :login_required
  def index
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      current_month_set
      redirect_to root_url, notice: 'ログインしました'
    else
      redirect_to sessions_path, notice: 'ログインできませんでした'
    end  
  end


  private

  def session_params
    params.require(:session).permit(:email,:password)
  end
end
