# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://gunpla-type.xyz/"

SitemapGenerator::Sitemap.create do
  add articles_path, priority: 0.7, changefreq: "daily"
  add gunplas_path, priority: 0.7, changefreq: "daily"

  Article.find_each do |article|
    add article_path(article), priority: 1.0, lastmod: article.updated_at, changefreq: "daily"
  end

  Review.find_each do |review|
    add review_path(review), priority: 1.0, lastmod: review.updated_at, changefreq: "daily"
  end

  Gunpla.find_each do |gunpla|
    add gunpla_path(gunpla), priority: 1.0, lastmod: gunpla.updated_at, changefreq: "daily"
  end
end
