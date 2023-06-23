module LoginModule
  def login(user)
    session[:user_id] = user.id
    expense = user.expenses.order(date_at: "DESC").first
    if expense
      session[:expense_id] = expense.id
    else
      expense = user.expenses.new(date_at: Time.zone.now)
      if expense.save
        session[:expense_id] = expense.id
      end
    end
  end
end
