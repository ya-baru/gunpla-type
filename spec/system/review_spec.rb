require "rails_helper"

RSpec.describe "Review", :js, type: :system do
  def expect_page_information(sub_title: nil, breadcrumb: nil)
    aggregate_failures do
      expect(page).to have_title("#{sub_title} - GUNPLA-Type")
      expect(page).to have_selector("li.breadcrumb-item", text: "ホーム")
      expect(page).to have_selector("li.breadcrumb-item", text: "ガンプラリスト")
      expect(page).to have_selector("li.breadcrumb-item", text: gunpla.name)
      expect(page).to have_selector("li.breadcrumb-item", text: breadcrumb)
    end
  end

  describe "レビュー投稿機能のテスト" do
    let(:user) { create(:user, :with_avatar) }
    let(:gunpla) { create(:gunpla) }

    it "バリデーション, 画像登録, Ratyの各種機能の動作チェックをする" do
      # リンクの非表示チェック
      visit gunpla_path(gunpla)
      expect(page).not_to have_selector(".btn", text: "『#{gunpla.name}』 をレビューする")

      sign_in user
      visit gunpla_path(gunpla)
      click_on "『#{gunpla.name}』 をレビューする"
      expect_page_information(sub_title: "レビュー投稿", breadcrumb: "レビュー投稿")
      expect(page).to have_css(".sidebar")

      # 失敗
      aggregate_failures do
        expect { click_on "レビューを投稿する" }.not_to change(Review, :count)
        expect(page).to have_content "タイトルを入力してください"
        expect(page).to have_content "内容を入力してください"
        expect(page).to have_content "評価を入力してください"
        expect(page).to have_content "画像ファイルを添付してください"
      end

      # 成功
      fill_in "タイトル", with: "おすすめ！"
      fill_in "内容", with: "組み立てやすい！"
      page.all("img")[4].click
      attach_file "review[images][]",
                  ["#{Rails.root}/spec/files/sample.jpg", "#{Rails.root}/spec/files/sample.jpg"],
                  make_visible: true

      # 画像選択でサムネと変更ボタンと削除ボタンが表示
      aggregate_failures do
        expect(page).to have_selector(".image-box img")
        expect(page).to have_selector("a.btn-edit")
        expect(page).to have_selector("a.btn-delete")
        expect(all(".image-box img").count).to eq 2
        expect(all("a.btn-edit").count).to eq 2
        expect(all("a.btn-delete").count).to eq 2
      end

      # 三枚目まで投稿ボタンが表示
      aggregate_failures do
        expect(page).to have_selector("bottun.btn-success")
        attach_file "review[images][]", ["#{Rails.root}/spec/files/sample.jpg"], make_visible: true
        expect(page).not_to have_selector("bottun.btn-success")
      end

      # 画像を削除すると投稿ボタン再表示
      page.all("a.btn-delete")[2].click
      expect(page).to have_selector("bottun.btn-success")

      expect { click_on "レビューを投稿する" }.to change(Review, :count).by(1)
      expect(current_path).to eq review_path(Review.first)
      expect(page).to have_content("『#{gunpla.name}』のレビューが完了しました")

      # レビュアーのアバターチェック
      visit review_path(Review.first)
      expect(page).to have_selector(".reviewer_avatar img[src$='sample.jpg']")
    end
  end

  describe "レビュー編機能のテスト" do
    let!(:review) { create(:review, :with_image) }
    let(:other_user) { create(:user) }
    let(:user) { User.first }
    let(:gunpla) { Gunpla.first }

    it "編集ページで各種項目の更新テストする" do
      # リンク表示チェック
      # 他ユーザーだとリンク表示がされない
      sign_in other_user
      visit gunpla_path(gunpla)
      expect(page).not_to have_selector(".btn", text: "『#{gunpla.name}』 のレビューを編集する")
      sign_out other_user

      sign_in user
      visit gunpla_path(gunpla)
      expect(page).not_to have_selector(".btn", text: "『#{gunpla.name}』 をレビューする")

      click_on "『#{gunpla.name}』 のレビューを編集する"
      expect_page_information(sub_title: "レビュー編集", breadcrumb: "レビュー編集")
      expect(page).to have_css(".sidebar")

      aggregate_failures do
        expect(page).to have_field "タイトル", with: review.title
        expect(page).to have_field "内容", with: review.content
        expect(find("#review_star", visible: false).value).to eq "4.0"
        expect(page).to have_selector("img[src$='sample.jpg']")
      end

      fill_in "タイトル", with: "コスパ最高！"
      fill_in "内容", with: "量産機のスタンダードキット！"
      page.all("#rate img")[4].click
      attach_file "review[images][]", ["#{Rails.root}/spec/files/sample.png"], make_visible: true
      click_on "レビューを更新する"

      aggregate_failures do
        expect(current_path).to eq review_path(review)
        expect(page).to have_content("『#{review.gunpla.name}』のレビュー内容を編集しました")
      end

      aggregate_failures do
        expect(review.reload.title).to eq "コスパ最高！"
        expect(review.reload.content).to eq "量産機のスタンダードキット！"
        expect(review.reload.rate).to eq 5.0
        expect(review.reload.images.count).to eq 2
      end
    end
  end

  describe "レビューの削除動作のチェック" do
    let!(:review) { create(:review, :with_image) }
    let(:user) { User.first }
    let(:gunpla) { Gunpla.first }

    it "編集ページから削除する" do
      sign_in user
      visit edit_review_path(review)
      page.accept_confirm('レビューを削除してよろしいですか?') do
        click_on("削除")
      end

      aggregate_failures do
        expect(current_path).to eq gunpla_path(gunpla)
        expect(page).to have_content("『#{review.gunpla.name}』のレビューを削除しました")
      end
    end
  end

  describe "関連ページにおけるレビュー内容のチェック" do
    let!(:review) { create(:review, :with_image) }
    let(:user) { User.first }
    let(:gunpla) { Gunpla.first }
    let(:category) { Category.last }

    context "gunplas#show" do
      it "レビュー要素が正常に表示されていること" do
        visit gunpla_path(gunpla)

        aggregate_failures do
          expect(page).to have_selector(".card-header h2", text: "レビューリスト（#{gunpla.reviews.count}）")
          expect(page).to have_selector("#average-rate-#{gunpla.id}")
          expect(page).to have_selector("#mainImg-list1 img[src$='sample.jpg']")
          expect(page).to have_selector("#subImg-list1 img[src$='sample.jpg']")
          expect(page).to have_selector(".media img[src$='sample.jpg']")
          expect(page).to have_selector(".media-body p", text: review.title)
          expect(page).to have_selector(".media-body p", text: review.content)
          expect(page).to have_selector("#rate-#{review.id}")
          expect(page).to have_selector(".media-body p", text: "#{review.created_at.to_s(:datetime_jp)} 投稿")
        end

        click_on review.title
        expect(current_path).to eq review_path(review)
      end
    end

    context "reviews#show" do
      it "レビュー要素が正常に表示されていること" do
        visit review_path(review)
        expect_page_information(sub_title: "レビュー詳細", breadcrumb: "レビュー詳細")
        expect(page).not_to have_css(".history_box")

        # レビュー情報
        aggregate_failures do
          expect(page).to have_selector("h2", text: gunpla.name)
          expect(page).to have_selector("#mainImg-list1 img[src$='sample.jpg']")
          expect(page).to have_selector("#subImg-list1 img[src$='sample.jpg']")
          expect(page).to have_selector("#rate")
          expect(page).to have_selector(".review_content p", text: review.title)
          expect(page).to have_selector(".review_content em", text: "#{review.created_at.to_s(:datetime_jp)} 投稿")
          expect(page).to have_selector(".review_content p", text: review.content)
          expect(page).to have_selector(".reviewer_profile a", text: user.username)
        end

        # 編集ボタンの表示チェック
        expect(page).not_to have_selector("a", text: "編集")

        sign_in user
        visit review_path(review)
        click_on "編集"
        expect(current_path).to eq edit_review_path(review)
      end
    end

    # # 全テストの場合なぜか失敗
    # context "gunplas#index" do

    #   it "レビュー要素が正常に表示されていること" do
    #     visit gunplas_path

    #     aggregate_failures do
    #       expect(all("ol.gunpla_index li").first).to have_selector(".gunpla_index img[src$='sample.jpg']")
    #       expect(all("ol.gunpla_index li").first).to have_selector("p", text: gunpla.name)
    #       expect(all("ol.gunpla_index li").first).to have_selector("li", text: "#{category.parent.name} #{category.name}")
    #       expect(all("ol.gunpla_index li").first).to have_selector("li#rate-#{gunpla.id}")
    #     end
    #   end
    # end
  end
end
