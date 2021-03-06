class AddFavoritesCountToUsers < ActiveRecord::Migration[6.0]
  def self.up
    add_column :users, :favorites_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :users, :favorites_count
  end
end
