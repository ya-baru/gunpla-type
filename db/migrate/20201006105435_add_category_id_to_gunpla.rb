class AddCategoryIdToGunpla < ActiveRecord::Migration[6.0]
  def change
    add_column :gunplas, :category_id, :integer, null: false
  end
end
