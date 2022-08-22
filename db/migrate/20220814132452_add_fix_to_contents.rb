class AddFixToContents < ActiveRecord::Migration[7.0]
  def change
    add_column :contents, :fix, :boolean , null: false, default: true
  end
end
