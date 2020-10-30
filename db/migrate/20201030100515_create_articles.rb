class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false, limit: 50
      t.text :content, null: false, limit: 1000
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
