class AddCategoryIdToGunpla < ActiveRecord::Migration[6.0]
  def change
    add_column :gunplas, :category_id, :integer, null: false

    add_index :gunplas, :category_id
  end
end
