class CreateDays < ActiveRecord::Migration[6.0]
  def change
    create_table :days do |t|
      t.datetime :day_at
      t.string :icon
      t.string :memo
      t.boolean :income_and_outgo
      t.bigint :money
      t.references :month, null: false, foreign_key: true

      t.timestamps
    end
  end
end
