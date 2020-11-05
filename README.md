# GUNPLA-Type

[![CircleCI](https://img.shields.io/badge/circleci-passing-brightgreen)](https://app.circleci.com/pipelines/github/ya-baru)

## サイト概要

![GUNPLA-Type イメージ](https://user-images.githubusercontent.com/59059160/98214794-4942e200-1f8a-11eb-916c-f0d91a427434.png)

時代に左右されやすいホビーコンテンツの中で、力強く歩み続けるガンダムのプラモデル（通称：ガンプラ）は非常に珍しいコンテンツです。その背景には、ガンダムの世界に魅了された世代を超えた多くのファンの支えと、その熱い声に応え続けてきた企業努力の賜物だと私は考えています。

『GUNPLA-Type』は、レビュー、ブックマーク、ランキングなどの機能を活用して、ユーザーが主体となってガンプラをレビューする WEB サービスです。

自分のお気に入りのガンプラを通じて熱く語り合い、情報共有をし合いながら昨今の自粛ムードを乗り切るのが狙いです。

※注意
当サイトはポートフォリオの一環で作成したものです。
サイト内で使用されている画像は全て著作権元の著作物です。引用/転載の基準については著作権元に準じます。
サイト紹介のために画像を引用せております。

## 作成のポイント

機能自体は特段難しいものは導入していません。ただ、ひたすらに MVC 構造のコンセプトを忠実に守り、ユーザーが直感で操作できるシンプルなサイトデザインを目指して作成しました。

そうした中でも素人目線ながら特に意識した点は

- **実際の開発現場では一般的だとされている機能やスタイルは可能な限り取り入れる。**
- **後々のメンテナンス性を考慮して、可読性の向上を最優先にしたコーディング**
- **単になる作品完成がゴールではなく、その後のサービス運用を視野に入れた上でのバックヤードの開発に力を入れる。**

**また、チーム開発を想定して Github の機能を活用し、「isuue -> branch -> develop -> push -> pull request -> master marge」を実行するなど、擬似的な開発スタイルを再現して進めていくように努めました。**

- チーム共通の開発が行えるように Dokcer を導入
- 開発性向上に CI/CD ツールを使った自動テスト＆自動デプロイ
- devise を活用しつつ、より利便性を求めた機能
- サイトマップやメタタグなどを用いた SEO 対策
- DoS 攻撃などに備えたセキュリティ対策
- Ajax を積極的に活用したユーザビリティなページ開発
- 万が一例外が発生した場合の通知機能
- 各種 API を利用した機能（SNS ログインや GoogleMAP など）
- admin 状態のユーザーだけがアクセスできる管理画面

※より細かな導入技術については後述のリストや実際のコードをご覧いただけると幸いです。

# URL

[https://gunpla-type.herokuapp.com/](https://gunpla-type.herokuapp.com/)

```HTML
テストユーザーアカウント

メールアドレス：test@example.com
パスワード：password
```

※ページ内には『テストユーザーとしてワンクリックでログインができるボタン』も実装してありますので、そちらをご利用いただけると幸いです。

# 開発環境

- Ruby 2.7.1
- Rails 6.0.3.4

# ER 図

<img width="1440" alt="GUNPLA-Type ER図" src="https://user-images.githubusercontent.com/59059160/98214304-a8ecbd80-1f89-11eb-840f-b094b8f68da6.png">

# 各種機能＆導入技術

- プラットフォーム（Heroku）
- データベース（PostgreSQL）
- コンテナ型仮想化（Docker）
- 自動テスト＆自動デプロイ（Circleci）
- テスト（Rspec、Capybara、factory_bot）
- HTML テンプレートエンジン（Slim）
- CSS フレームワーク（Bootstrap4）
- コードチェック（rubocop、rails_best_practices、bullet）
- セキュリティチェック（brakeman、rack-attack）
- ユーザー登録＆ログイン（devise、omniauth)
- 画像アップロード（activestorage、mini_magick、 image_processing、 AWS S3）
- レビュー（jquery、raty）
- いいね、ブックマーク、オートコンプリート等（Ajax）
- チャート(chartkick)
- エディタ（actiontext）
- マークダウン（redcarpet）
- パーシャル（cells-rails）
- ページネーション（kaminari）
- アカウント有効化、凍結解除、パスワードリセット、お問い合わせ（ActionMailer）
- 検索（ransack）
- デコレーター(draper)
- カウント(counter_culture)
- カテゴリー(ancestry)
- マップ（geocoder）
- パンくずリスト（gretel）
- SEO 対策（google-analytics-rails、meta-tags、sitemap_generator）
- 管理者ページ（rails_admin, cancancan）
- 通知機能（exception_notification、slack-notifier）
- 各種 API（Twitter、Facebook、LINE、Google）

## トップページ

![GT トップページ](https://user-images.githubusercontent.com/59059160/98214347-bace6080-1f89-11eb-93f5-00dd6bfa65e8.png)

## 新規登録

![GT 新規登録](https://user-images.githubusercontent.com/59059160/98214368-c15cd800-1f89-11eb-9797-a665665fbd8d.png)

## マイページ

![GT マイページ](https://user-images.githubusercontent.com/59059160/98214387-c752b900-1f89-11eb-8dc3-c27e0466bb62.png)

## ガンプラページ

![GT ガンプラページ](https://user-images.githubusercontent.com/59059160/98218466-2404a280-1f8f-11eb-8295-f991265434a7.png)

## 記事詳細ページ

![GT 記事](https://user-images.githubusercontent.com/59059160/98214440-d9345c00-1f89-11eb-9e0e-36882e1b4828.png)
