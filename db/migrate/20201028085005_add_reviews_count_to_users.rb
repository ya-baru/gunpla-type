class AddReviewsCountToUsers < ActiveRecord::Migration[6.0]
  def self.up
    add_column :users, :reviews_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :users, :reviews_count
  end
end
