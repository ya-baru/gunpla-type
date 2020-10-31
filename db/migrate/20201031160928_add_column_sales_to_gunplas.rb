class AddColumnSalesToGunplas < ActiveRecord::Migration[6.0]
  def change
    add_column :gunplas, :sales, :integer, null: false
    remove_column :gunplas, :sales_id, :integer, null: false
  end
end
