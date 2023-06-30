class BudgetDecorator < Draper::Decorator
  delegate_all

  # 渡したBudget Typeによって対応した日本語を返す
  def title(type)
    I18n.t(type, scope: [:activerecord, :attributes, :budget])
  end
end
