class CreateBudgets < ActiveRecord::Migration[6.0]
  def change
    create_table :budgets do |t|
      t.references :expense, null: false, foreign_key: true
      t.bigint :rent,null:false
      t.bigint :cost_of_living,null:false
      t.bigint :food_expenses,null:false
      t.bigint :entertainment,null:false
      t.bigint :others,null:false
      t.bigint :car_cost,null:false
      t.bigint :insurance,null:false

      t.timestamps
    end
  end
end
