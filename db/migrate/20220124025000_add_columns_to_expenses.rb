class AddColumnsToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_column :expenses, :salary_2, :bigint
    add_column :expenses, :salary_3, :bigint
    add_column :expenses, :salary_4, :bigint
  end
end
