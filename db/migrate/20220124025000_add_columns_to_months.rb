class AddColumnsToMonths < ActiveRecord::Migration[6.0]
  def change
    add_column :months, :salary_2, :bigint
    add_column :months, :salary_3, :bigint
    add_column :months, :salary_4, :bigint
  end
end
