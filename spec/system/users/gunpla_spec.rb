require "rails_helper"

RSpec.describe "Users::Gunplas", :js, type: :system do
  let(:user) { create(:user) }
  let!(:category) { create(:child_category) }

  before { sign_in user }

  describe "ガンプラ登録テスト" do
    it "登録ページでガンプラを登録する" do
      visit gunplas_path
      click_on "ガンプラを追加"

      aggregate_failures do
        expect(page).to have_title("ガンプラ登録 - GUNPLA-Type")
        expect(page).to have_selector("li", text: "ホーム")
        expect(page).to have_selector("li", text: "ガンプラリスト")
        expect(page).to have_selector("li", text: "ガンプラ登録")
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
        expect(page).to have_selector(".alert-success", text: "ガンプラの登録に成功しました")
        expect(current_path).to eq gunpla_path(Gunpla.first)
      end
    end
  end

  describe "ガンプラ編集テスト" do
    let(:gunpla) { create(:gunpla) }

    it "編集ページでガンプラを更新する" do
      visit gunpla_path(gunpla)
      click_on "編集する"

      aggregate_failures do
        expect(page).to have_title("ガンプラ編集 - GUNPLA-Type")
        expect(page).to have_selector("li", text: "ホーム")
        expect(page).to have_selector("li", text: "ガンプラリスト")
        expect(page).to have_selector("li", text: gunpla.name)
        expect(page).to have_select("作品", selected: "機動戦士ガンダム")
        expect(find("#gunpla_child_category")).to have_content "HGUC"
        expect(find("#gunpla_grandchild_category")).to have_content "1/144"
      end

      fill_in "商品名", with: "mg　シャア専用ザク"
      select "プレミアムバンダイ限定", from: "販売方法"
      click_on "ガンプラを更新する"

      aggregate_failures do
        expect(Gunpla.first.name).to eq "MG シャア専用ザク"
        expect(Gunpla.first.sales.name).to eq "プレミアムバンダイ限定"
        expect(page).to have_selector(".alert-success", text: "ガンプラを更新しました")
        expect(current_path).to eq gunpla_path(Gunpla.first)
      end
    end
  end

  describe "ガンプラリストページのチェック" do
    let!(:gunpla) { create_list(:gunpla, 10)}

    it "各種要素が正常に表示されていることを検証する" do
      visit gunplas_path

      expect(page).to have_css ".pagination"
      Gunpla.paginates_per(page: 1).each do |gunpla|
        expect(all("ol li").count).to eq 9
      end
    end
  end
end
