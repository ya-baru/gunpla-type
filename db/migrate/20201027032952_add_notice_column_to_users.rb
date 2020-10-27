class AddNoticeColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :notice, :boolean, default: true
  end
end
