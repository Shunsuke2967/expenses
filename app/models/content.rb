class Content < ApplicationRecord
  belongs_to :user
  belongs_to :setting, optional: true

  enum content_type: {
    budget: 1, # 各支出のプログレスバー
    template: 2, # テンプレート機能
    bank_balance: 3, # 口座残高
    spending_chart_date: 4, # 支出の円グラフ
    income_and_expenditure_transition: 5, # 収支の推移
    bank_balance_transition: 6, # 口座残高の推移
    current_income_and_expenditure: 7, # 今月の収支
    list_of_details: 8, # 今月の収支の記録一覧
    current_salary: 9 # 収入設定画面
  }
end
