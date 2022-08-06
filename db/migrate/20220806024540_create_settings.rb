class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :setting_type
      t.integer :sort_order

      t.timestamps
    end
  end
end
