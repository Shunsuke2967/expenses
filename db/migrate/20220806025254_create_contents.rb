class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :setting, foreign_key: true
      t.integer :content_type
      t.integer :sort_order

      t.timestamps
    end
  end
end
