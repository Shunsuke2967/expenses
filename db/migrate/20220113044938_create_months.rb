class CreateMonths < ActiveRecord::Migration[6.0]
  def change
    create_table :months do |t|
      t.datetime :month_at, null: false
      t.bigint :income,null: false, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
