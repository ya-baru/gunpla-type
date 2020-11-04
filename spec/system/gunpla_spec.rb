require "rails_helper"

RSpec.describe "Gunpla", :js, type: :system do
  let!(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  before { sign_in user }

  def expect_page_information(sub_title: nil, breadcrumb: nil)
    aggregate_failures do
      expect(page).to have_title("#{sub_title} - GUNPLA-Type")
      expect(page).to have_selector("li.breadcrumb-item", text: "ホーム")
      expect(page).to have_selector("li.breadcrumb-item", text: "ガンプラリスト")
      expect(page).to have_selector("li.breadcrumb-item", text: breadcrumb)
    end
  end

  describe "ガンプラ登録テスト" do
    let!(:category) { create(:child_category) }

    it "登録ページでガンプラを登録する" do
      visit gunplas_path
      click_on "ガンプラを追加"
      expect_page_information(sub_title: "ガンプラ登録", breadcrumb: "ガンプラ登録")

      aggregate_failures do
        expect(find("#gunpla_parent_category")).to have_content "選択して下さい"
        expect(find("#gunpla_child_category")).not_to have_content "HGUC"
        expect(find("#gunpla_grandchild_category")).not_to have_content "1/144"
      end

      # 失敗
      aggregate_failures do
        expect { click_on "ガンプラを登録する" }.not_to change(Gunpla, :count)
        expect(page).to have_content "商品名を入力してください"
        expect(page).to have_content "カテゴリーを入力してください"
        expect(page).to have_content "販売方法を入力してください"
      end

      # 成功
      fill_in "商品名", with: "Hguc　ガンダム"
      select "機動戦士ガンダム", from: "作品"
      select "HGUC", from: "グレード"
      select "1/144", from: "スケール"
      select "一般販売", from: "販売方法"

      aggregate_failures do
        expect { click_on "ガンプラを登録する" }.to change(Gunpla, :count).by(1)
        expect(page).to have_selector(".alert-success", text: "ガンプラを登録しました")
        expect(current_path).to eq gunpla_path(Gunpla.first)
      end
    end
  end

  describe "ガンプラ編集テスト" do
    let(:gunpla) { create(:gunpla) }

    it "編集ページでガンプラを更新する" do
      visit gunpla_path(gunpla)
      click_on "編集"
      expect_page_information(sub_title: "ガンプラ編集", breadcrumb: "ガンプラ編集")

      aggregate_failures do
        expect(page).to have_select("作品", selected: "機動戦士ガンダム")
        expect(find("#gunpla_child_category")).to have_content "HGUC"
        expect(find("#gunpla_grandchild_category")).to have_content "1/144"
      end

      fill_in "商品名", with: "mg　シャア専用ザク"
      select "プレミアムバンダイ限定", from: "販売方法"
      click_on "ガンプラを更新する"

      aggregate_failures do
        expect(Gunpla.first.name).to eq "MG シャア専用ザク"
        expect(Gunpla.first.sales).to eq "プレミアムバンダイ限定"
        expect(page).to have_selector(".alert-success", text: "ガンプラを更新しました")
        expect(current_path).to eq gunpla_path(Gunpla.first)
      end
    end
  end

  describe "検索機能" do
    let!(:gunpla) { create_list(:gunpla, 3) }

    describe "検索結果で表示切り替えが正常に行われていることを検証する" do
      before { visit gunplas_path }

      context "未入力" do
        it "検索結果が正常に表示されること" do
          click_on "検索"
          expect_page_information(sub_title: "検索結果", breadcrumb: "検索結果")

          aggregate_failures do
            expect(current_path).to eq search_gunplas_path
            expect(all(".card-header")[1]).to have_selector("h2", text: "検索結果（#{Gunpla.count}）")
            expect(all("ol.gunpla_index li.card").count).to eq 3
          end
        end
      end

      context "該当あり" do
        it "入力時にオートコンプリートが正常に機能されることを検証する" do
          fill_in "レビューしたいガンプラを探そう！", with: Gunpla.first.name
          expect(page).to have_selector(".ui-menu-item", text: Gunpla.first.name)
          find(".ui-menu-item").click

          click_on "検索"
          aggregate_failures do
            expect(all(".card-header")[1]).to have_selector("h2", text: "検索結果（1）")
            expect(page).to have_selector(".search_result", text: Gunpla.first.name)
            expect(all("ol.gunpla_index li.card").count).to eq 1
          end
        end
      end

      context "該当なし" do
        it "入力時にオートコンプリートが正常に機能されることを検証する" do
          fill_in "レビューしたいガンプラを探そう！", with: "ガンダム"
          expect(page).not_to have_selector(".ui-menu-item", text: "ガンダム")

          click_on "検索"
          aggregate_failures do
            expect(all(".card-header")[1]).to have_selector("h2", text: "検索結果（0）")
            expect(page).to have_selector(".search_result", text: "ガンダム")
            expect(page).to have_selector("strong", text: "ガンダム")
            expect(all("ol.gunpla_index li.card").count).to eq 0
          end
        end
      end
    end
  end

  describe "カテゴリー検索" do
    def select_parent_category
      find("a.category_box").click
      expect(page).to have_selector("a.parent_category", text: category.root.name)

      find("a.parent_category").click
    end

    def select_child_categoy
      find("a.category_box").click
      find('a.parent_category').hover
      expect(page).to have_selector("a.child_category", text: category.parent.name)

      find("a.child_category").click
    end

    def select_grandchild_category
      find("a.category_box").click
      find('a.parent_category').hover
      find('a.child_category').hover
      expect(page).to have_selector("a.grandchild_category", text: category.name)

      find("a.grandchild_category").click
    end

    context "該当あり" do
      let(:category) { Category.last }
      let!(:gunpla) { create(:gunpla) }

      before { visit gunplas_path }

      def expect_result(text)
        sleep 0.5
        aggregate_failures do
          expect(all(".card-header")[1]).to have_selector("h2", text: "カテゴリー検索（#{Gunpla.count}）")
          expect(page).to have_selector(".search_result", text: text)
          expect(all("ol.gunpla_index li.card").count).to eq 1
        end
      end

      it "定義したロジック通りに結果が表示されていることを検証する" do
        # 親カテゴリー
        select_parent_category
        expect_page_information(sub_title: "カテゴリー検索", breadcrumb: "カテゴリー検索")

        aggregate_failures do
          expect(current_path).to eq select_category_index_gunpla_path(category.root_id)
          expect_result(category.root.name)
        end

        # 子カテゴリー
        select_child_categoy
        expect_result("#{category.root.name} / #{category.parent.name}")

        # 孫カテゴリー
        select_grandchild_category
        expect_result("#{category.root.name} / #{category.parent.name} / #{category.name}")
      end
    end

    context "該当なし" do
      let!(:category) { create(:child_category) }

      before { visit gunplas_path }

      def expect_none_result(text)
        sleep 0.5
        aggregate_failures do
          expect(all(".card-header")[1]).to have_selector("h2", text: "カテゴリー検索（#{Gunpla.count}）")
          expect(page).to have_selector(".search_result", text: text)
          expect(all("ol.gunpla_index li.card").count).to eq 0
        end
      end

      it "定義したロジック通りに結果が表示されていることを検証する" do
        # 親カテゴリー
        select_parent_category
        expect_none_result("『#{category.root.name}』に分類されるガンプラはありませんでした。")

        # 子カテゴリー
        select_child_categoy
        expect_none_result("『#{category.root.name} / #{category.parent.name}』に分類されるガンプラはありませんでした。")

        # 孫カテゴリー
        select_grandchild_category
        expect_none_result("『#{category.root.name} / #{category.parent.name} / #{category.name}』に分類されるガンプラはありませんでした。")
      end
    end
  end

  describe "閲覧履歴" do
    let(:gunplas) { create_list(:gunpla, 5) }

    def expect_browsing_histories(count: nil, num: nil)
      aggregate_failures do
        expect(BrowsingHistory.count).to eq count
        expect(BrowsingHistory.last.gunpla_id).to eq gunplas[num].id
      end
    end

    it "定義したロジック通りに保存されていることを検証する" do
      visit gunplas_path
      aggregate_failures do
        expect(page).to have_selector(".history_box .text-center", text: "閲覧履歴はありません")
        expect { visit gunpla_path(Gunpla.find(gunplas[0].id)) }.to change(BrowsingHistory, :count).by(1)
        expect(find(".history_box ul")).to have_selector(".history-#{BrowsingHistory.first.id}", text: gunplas[0].name)
      end

      # 新規
      visit gunpla_path(Gunpla.find(gunplas[1].id))
      expect_browsing_histories(count: 2, num: 1)

      # 同一ページ
      visit gunpla_path(Gunpla.find(gunplas[1].id))
      expect_browsing_histories(count: 2, num: 1)

      # 新規
      visit gunpla_path(Gunpla.find(gunplas[2].id))
      expect_browsing_histories(count: 3, num: 2)

      # 二つ前のページ
      visit gunpla_path(Gunpla.find(gunplas[1].id))
      expect_browsing_histories(count: 3, num: 1)

      # 新規
      visit gunpla_path(Gunpla.find(gunplas[3].id))
      expect_browsing_histories(count: 4, num: 3)

      # 4件まで降順で保存
      visit gunpla_path(Gunpla.find(gunplas[4].id))
      expect_browsing_histories(count: 4, num: 4)
      expect(BrowsingHistory.last.gunpla_id).not_to eq gunplas[0].id
      expect(all(".history_box li")[0]).to have_content(gunplas[4].name)

      # サインアウト中は非表示
      sign_out user
      visit gunplas_path
      expect(page).not_to have_selector(".history_box h5", text: "閲覧履歴")
    end
  end

  describe "ガンプラリストのページネーション" do
    let!(:gunpla) { create_list(:gunpla, 10) }

    it "各種要素が正常に表示されていることを検証する" do
      visit gunplas_path

      expect(page).to have_css ".pagination"
      Gunpla.paginates_per(page: 1).each do |gunpla|
        expect(all("ol.gunpla_index li.card").count).to eq 9
      end
    end
  end
end
