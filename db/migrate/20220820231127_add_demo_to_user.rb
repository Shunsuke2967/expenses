class AddDemoToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :demo, :boolean, null:false ,default: false
  end
end
