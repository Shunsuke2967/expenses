class CreateDays < ActiveRecord::Migration[6.0]
  def change
    create_table :days do |t|
      t.datetime :day_at
      t.integer :icon, null: false
      t.string :memo
      t.boolean :spending
      t.bigint :money, null: false
      t.references :expense, null: false, foreign_key: true

      t.timestamps
    end
  end
end
