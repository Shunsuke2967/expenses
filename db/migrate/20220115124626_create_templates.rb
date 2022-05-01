class CreateTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :templates do |t|
      t.string :icon, null:false
      t.string :memo
      t.boolean :income_and_outgo
      t.bigint :money, null:false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
