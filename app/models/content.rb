class Content < ApplicationRecord
  belongs_to :user
  belongs_to :setting, optional: true

  enum content_type: {
    budget: 1,
    template: 2,
    bank_balance: 3,
    spending_chart_date: 4,
    income_and_expenditure_transition: 5,
    bank_balance_transition: 6,
    template: 7
  }
end
