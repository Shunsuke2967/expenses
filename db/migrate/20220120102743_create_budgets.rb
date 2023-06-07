class CreateBudgets < ActiveRecord::Migration[6.0]
  def change
    create_table :budgets do |t|
      t.references :expense, null: false, foreign_key: true
      t.bigint :rent, null: false, default: 0
      t.bigint :cost_of_living, null: false, default: 0
      t.bigint :food_expenses, null: false, default: 0
      t.bigint :entertainment, null: false, default: 0
      t.bigint :other, null: false, default: 0
      t.bigint :car_cost, null: false, default: 0
      t.bigint :insurance, null: false, default: 0

      t.timestamps
    end
  end
end
