class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.datetime :date_at, null: false
      t.bigint :salary,null: false, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
