class AddColumnBuildingToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :building, :string
  end
end
