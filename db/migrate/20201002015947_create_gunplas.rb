class CreateGunplas < ActiveRecord::Migration[6.0]
  def change
    create_table :gunplas do |t|
      t.string :name, null: false, limit: 50
      t.integer :sales_id, null: false

      t.timestamps
    end
  end
end