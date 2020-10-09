# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  username: "管理者",
  profile: "管理者ページです。",
  email: Rails.application.credentials.admin[:email],
  password: Rails.application.credentials.admin[:password],
  password_confirmation: Rails.application.credentials.admin[:password],
  confirmed_at: Time.current,
  admin_flg: true
)

require "csv"

CSV.foreach('db/category.csv') do |row|
  Category.create(id: row[0], name: row[1], ancestry: row[2])
end

30.times do |n|
  category = %w(65 66 67 68 69 70 71 74 75 76 81).sample
  sales = %w(1 2 3 4 5).sample
  Gunpla.create!(
    name: "RX-78-#{1+n} ガンダム",
    category_id: category,
    sales_id: sales
  )
end
