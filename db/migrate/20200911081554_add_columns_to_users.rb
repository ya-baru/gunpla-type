class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :username, :string, null: false, limit: 30

    add_index :users, [:uid, :provider], unique: true
  end
end
