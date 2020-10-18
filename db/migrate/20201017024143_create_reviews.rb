class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.string :title, null: false, limit: 50
      t.text :content, null: false, limit: 1000
      t.references :user, null: false, foreign_key: true
      t.references :gunpla, null: false, foreign_key: true

      t.timestamps
    end
    add_index :reviews, [:user_id, :gunpla_id], unique: true
  end
end
