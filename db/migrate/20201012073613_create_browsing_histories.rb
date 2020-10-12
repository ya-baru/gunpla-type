class CreateBrowsingHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :browsing_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :gunpla, null: false, foreign_key: true

      t.timestamps
    end
    add_index :browsing_histories, [:user_id, :gunpla_id]
  end
end
