class AddColumnsToMonths < ActiveRecord::Migration[6.0]
  def change
    add_column :months, :income2, :bigint
    add_column :months, :income3, :bigint
    add_column :months, :income4, :bigint
  end
end
