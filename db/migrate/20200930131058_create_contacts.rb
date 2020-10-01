class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :name, null: false, limit: 20
      t.string :email, null: false, limit: 255
      t.text :message, null: false, limit: 1000

      t.timestamps
    end
  end
end
