class DaysController < ApplicationController
  def new
    # 同じ記述が多いのと冗長なコードになってるので、privateメソッドにしても良いかもですね！
    # private
    # def current_user_expense
    #   current_user.expenses.find(current_expense.id)
    # end
    # もし他のファイルでも使用しそうならmodelに
    # def self.current_user_expense(current_user_id:, current_expense:)
    # .find(current_user_id).expenses.find(current_expense.id)
    # end
    # もあり？？

    # そうすると下記コードが
    # @day = current_user_expense.days.new
    # とスッキリ書けます！
    @day = current_user.expenses.find(current_expense.id).days.new
  end

  def create
   @day = current_user.expenses.find(current_expense.id).days.new(day_params)
    if @day.save
      redirect_to root_path, notice: '追加しました'
    else
      render :new
    end
  end
  
  def edit
    # before_actionで下記の変数を定義しておくと、updateにもdestroyにも同じコード書かなくてすみそうです！
    @day = current_user.expenses.find(current_expense.id).days.find(params[:id])
  end

  def update
    @day = current_user.expenses.find(current_expense.id).days.find(params[:id])
    
    if @day.update(day_params)
      redirect_to root_url, notice: '修正しました'
    else
      render :edit
    end
  end

  def destroy
    day = current_user.expenses.find(current_expense.id).days.find(params[:id])
    day.destroy
    redirect_to root_url, notice: '削除しました'
  end

  private

  def day_params
    params.require(:day).permit(:day_at,:icon,:memo,:spending,:money)
  end
end
