# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ユーザー
User.create!(
  username: "管理者",
  profile: "管理者です。",
  email: Rails.application.credentials.admin[:email],
  password: Rails.application.credentials.admin[:password],
  password_confirmation: Rails.application.credentials.admin[:password],
  confirmed_at: Time.current,
  admin_flg: true,
)

User.create!(
  username: "テストユーザー",
  profile: "テストユーザーです。",
  email:  "test@example.com",
  password: "password",
  password_confirmation: "password",
  confirmed_at: Time.current,
  admin_flg: false,
)

user = User.new(
  username: "アムロ",
  profile: "僕が一番ガンプラをうまく作れるんだ！",
  email:  "user1@example.com",
  password: "password",
  password_confirmation: "password",
  confirmed_at: Time.current,
  admin_flg: false,
  )
  user.avatar.attach(
    io: File.open("#{Rails.root}/db/fixtures/images/users/amuro.jpg"), filename: "amuro.jpg")
  user.save!

User.create!(
  username: "シャア",
  profile: "見せてもらおうか。バンダイのガンプラの性能とやらを。",
  email:  "user2@example.com",
  password: "password",
  password_confirmation: "password",
  confirmed_at: Time.current,
  admin_flg: false,
)

User.create!(
  username: "刹那",
  profile: "俺がガンダムだ!",
  email:  "user3@example.com",
  password: "password",
  password_confirmation: "password",
  confirmed_at: Time.current,
  admin_flg: false,
)

# カテゴリー
require "csv"

CSV.foreach('db/category.csv') do |row|
  Category.create(id: row[0], name: row[1], ancestry: row[2])
end

# ガンプラ
20.times do |n|
  category = %w(65 66 67 68 69 70 71 74 75 76 81).sample
  sales = %w(0 1 2 3 4).sample.to_i
  Gunpla.create!(
    name: "RX-78-#{1+n} ガンダム",
    category_id: category,
    sales: sales,
  )
end

# レビュー & お気に入り
# アムロ
amuro = User.find(3)
gunplas = Gunpla.where(id: 18..20)
gunplas.each_with_index do |gunpla, i|
  review = Review.new(
    title: "すごい... 親父が熱中するわけだ。（その#{1+i}）",
    content: "テスト投稿#{1+i}",
    user_id: amuro.id,
    gunpla_id: gunpla.id,
    rate: 5,
  )
  review.images.attach(
    io: File.open("#{Rails.root}/db/fixtures/images/reviews/rx-78-2 gundam.jpg"), filename: "rx-78-2 gundam.jpg")
  review.save!

  Notification.create!(
    visitor_id: amuro.id,
    visited_id: amuro.id,
    gunpla_id: gunpla.id,
    review_id: review.id,
    action: "review",
    checked: true,
  )
end

gunplas = Gunpla.where(id: 18..20)
gunplas.each do |gunpla|
  amuro.favorite(gunpla)
end

# シャア
char = User.find(4)
gunplas = Gunpla.where(id: 19..20)
gunplas.each_with_index do |gunpla, i|
  review = Review.new(
    title: "ええい！バンダイのガンプラは化物か！（その#{1+i}）",
    content: "テスト投稿#{4+i}",
    user_id: char.id,
    gunpla_id: gunpla.id,
    rate: 4,
  )
  review.images.attach(
    io: File.open("#{Rails.root}/db/fixtures/images/reviews/ae.jpg"), filename: "ae.jpg")
  review.save!

  Notification.create!(
    visitor_id: char.id,
    visited_id: char.id,
    gunpla_id: gunpla.id,
    review_id: review.id,
    action: "review",
    checked: true,
  )
end

gunplas = Gunpla.where(id: 19..20)
gunplas.each do |gunpla|
  char.favorite(gunpla)
end

# 刹那
setsuna = User.find(5)
gunpla = Gunpla.find(20)
review = Review.new(
  title: "お前もガンダムだ！",
  content: "テスト投稿6",
  user_id: setsuna.id,
  gunpla_id: gunpla.id,
  rate: 3,
)
review.images.attach(
  io: File.open("#{Rails.root}/db/fixtures/images/reviews/vist.jpg"), filename: "vist.jpg")
review.save!

Notification.create!(
  visitor_id: setsuna.id,
  visited_id: setsuna.id,
  gunpla_id: gunpla.id,
  review_id: review.id,
  action: "review",
  checked: true,
)
Notification.create!(
  visitor_id: setsuna.id,
  visited_id: amuro.id,
  gunpla_id: gunpla.id,
  review_id: review.id,
  action: "review",
  checked: false,
)

setsuna.favorite(gunpla)

# コメント
comment = Comment.create!(
  content: "テストコメント",
  user_id: amuro.id,
  review_id: Review.first.id,
)
Notification.create!(
  visitor_id: amuro.id,
  visited_id: amuro.id,
  review_id: Review.first.id,
  comment_id: comment.id,
  action: "comment",
  checked: true,
)

comment = Comment.create!(
  content: "テストコメント",
  user_id: amuro.id,
  review_id: Review.last.id,
)
Notification.create!(
  visitor_id: amuro.id,
  visited_id: setsuna.id,
  review_id: Review.last.id,
  comment_id: comment.id,
  action: "comment",
  checked: false,
)

# お気に入り
amuro.uplike(Review.last)
Notification.create!(
  visitor_id: char.id,
  visited_id: amuro.id,
  review_id: review.id,
  action: "like",
  checked: false,
)

reviews = Review.where(id: 1..2)
reviews.each do |review|
  char.uplike(review)
  Notification.create!(
    visitor_id: char.id,
    visited_id: amuro.id,
    review_id: review.id,
    action: "like",
    checked: false,
  )
end

reviews = Review.where(id: 1..3)
reviews.each do |review|
  setsuna.uplike(review)
  Notification.create!(
    visitor_id: setsuna.id,
    visited_id: amuro.id,
    review_id: review.id,
    action: "like",
    checked: false,
  )
end

# フォロー
following = User.where(id: 4..5)
following.each do |followed|
  amuro.follow(followed)
  Notification.create!(
    visitor_id: amuro.id,
    visited_id: followed.id,
    action: "follow",
    checked: false,
  )
end

following = User.where(id: 3..4)
following.each do |followed|
  char.follow(followed)
  Notification.create!(
    visitor_id: char.id,
    visited_id: followed.id,
    action: "follow",
    checked: false,
  )
end

setsuna.follow(amuro)
Notification.create!(
  visitor_id: setsuna.id,
  visited_id: amuro.id,
  action: "follow",
  checked: false,
)

# 記事
article = Article.new(
  title: "テスト記事",
  content: "コンテンツ",
  building: "ガンダムベース東京",
  address: " 東京都江東区青海1-1-10 ダイバーシティ東京 プラザ7F",
  latitude: "35.6251856",
  longitude: "139.7756314",
)
article.image.attach(
  io: File.open("#{Rails.root}/db/fixtures/images/articles/rx-78-2 gundam.jpg"), filename: "x-78-2 gundam.jpg")
article.save!
