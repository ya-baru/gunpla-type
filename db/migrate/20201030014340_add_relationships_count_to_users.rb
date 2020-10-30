class AddRelationshipsCountToUsers < ActiveRecord::Migration[6.0]
  def self.up
    add_column :users, :relationships_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :users, :relationships_count
  end
end
