require 'rails_helper'

RSpec.describe "Article", :js, type: :system do
  let(:admin) { create(:user, :admin) }

  before { sign_in admin }

  context "admin" do
    describe "記事投稿のテスト" do
      it "管理者ページがから記事を投稿する" do
        visit new_admins_article_path
        expect(page).to have_link("記事一覧へ戻る")

        # 失敗
        aggregate_failures do
          expect { click_on "登録する" }.not_to change(Article, :count)
          expect(page).to have_content "タイトルを入力してください"
          expect(page).to have_content "内容を入力してください"
        end

        # 成功
        fill_in "タイトル", with: "新着記事"
        fill_in_rich_text_area "article_content", with: "コンテンツ"
        attach_file "article[image]", "#{Rails.root}/spec/files/sample.jpg"
        fill_in "建物", with: "ガンダムベース東京"
        fill_in "住所", with: "東京都江東区青海1-1-10 ダイバーシティ東京 プラザ7F"

        expect { click_on "登録する" }.to change(Article, :count).by(1)
      end
    end

    describe "記事の更新テスト" do
      let!(:article) { create(:article) }

      it "各要素が正常に更新されることを検証する" do
        visit edit_admins_article_path(article)

        fill_in "タイトル", with: "イベントのお知らせ"
        fill_in_rich_text_area "article_content", with: "開催日"
        fill_in "建物", with: "ガンダムベース福岡"
        fill_in "住所", with: "福岡県福岡市博多区住吉１丁目２ キャナルシティ博多サウスシティ"
        click_on "更新する"

        aggregate_failures do
          expect(page).to have_content("開催日")
          expect(article.reload).to have_attributes(
            title: "イベントのお知らせ",
            building: "ガンダムベース福岡",
            address: "福岡県福岡市博多区住吉１丁目２ キャナルシティ博多サウスシティ"
          )
        end
      end
    end

    describe "各ページにおける表示チェック" do
      let!(:article) { create(:article, :with_image) }

      context "index" do
        it "各要素が正常に表示されていることを検証する" do
          visit admins_articles_path
          aggregate_failures do
            expect(page).to have_link(article.title)
            expect(page).to have_link("記事を作成する")
            expect(page).to have_link("編集")
            expect(page).to have_link("削除")
          end
        end
      end

      context "show" do
        it "各要素の表示チェックをしてから記事を削除する" do
          visit admins_article_path(article)

          aggregate_failures do
            expect(page).to have_link("編集")
            expect(page).to have_link("削除")
            expect(page).to have_link("戻る")

            within ".article_head" do
              expect(page).to have_selector("h2", text: article.title)
              expect(page).to have_selector("p", text: article.updated_at.to_s(:datetime_jp))
              expect(page).to have_selector("img[src$='sample.jpg']")
            end

            expect(page).to have_content("コンテンツ")
          end

          # GoogleMap 吹き出し表示チェック
          expect(page).to have_css("#map")
          pin = find("map#gmimap0 area", visible: false)
          pin.click
          expect(page).to have_css("#gmimap0 area")

          expect do
            page.accept_confirm { click_on "削除" }
            expect(page).to have_selector(".alert-success", text: "『#{article.title}』を削除しました")
          end.to change(Article, :count).by(-1)
        end
      end
    end
  end

  context "user" do
    let!(:article) { create(:article, :with_image) }

    def expect_page_information(sub_title: nil, breadcrumb: nil)
      expect(page).to have_title("#{sub_title} - GUNPLA-Type")
      expect(page).to have_selector("li.breadcrumb-item", text: "ホーム")
      expect(page).to have_selector("li.breadcrumb-item", text: breadcrumb)
    end

    context "index" do
      it "各要素が正常に表示されていることを検証する" do
        visit articles_path

        aggregate_failures do
          expect_page_information(sub_title: "記事一覧", breadcrumb: "記事一覧")
          within ".media" do
            expect(page).to have_selector("li img[src$='sample.jpg']")
            expect(page).to have_content(article.title)
            expect(page).to have_content(article.updated_at.to_s(:datetime_jp))
          end
        end
      end
    end

    context "show" do
      it "各要素が正常に表示されていることを検証する" do
        visit article_path(article)

        aggregate_failures do
          expect_page_information(sub_title: "記事詳細", breadcrumb: "記事詳細")

          within ".article_head" do
            expect(page).to have_selector("h2", text: article.title)
            expect(page).to have_selector("p", text: article.updated_at.to_s(:datetime_jp))
            expect(page).to have_selector("img[src$='sample.jpg']")
          end

          expect(page).to have_content("コンテンツ")

          # GoogleMap 吹き出し表示チェック
          expect(page).to have_css("#map")
          pin = find("map#gmimap0 area", visible: false)
          pin.click
          expect(page).to have_css("#gmimap0 area")
        end
      end
    end
  end
end
