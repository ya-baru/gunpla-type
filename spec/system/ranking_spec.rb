require 'rails_helper'

RSpec.describe "Rankings", :js, type: :system do
  describe "ランキングページの表示テスト" do
    let!(:like) { create(:like) }
    let!(:favorite) { create(:favorite) }
    let!(:relationship) { create(:relationship) }
    let(:reviewer) { User.first }
    let(:follow) { User.last }
    let(:gunpla) { Gunpla.last }
    let(:review) { Review.first }

    it "各要素が正常に表示されていることを検証する" do
      visit rankings_path

      aggregate_failures do
        expect(page).to have_title("ランキング - GUNPLA-Type")
        expect(page).to have_selector("li.breadcrumb-item", text: "ホーム")
        expect(page).to have_selector("li.breadcrumb-item", text: "ランキング")
        expect(page).to have_css("#chart-1")
        expect(page).to have_css("#chart-2")
        expect(page).to have_css("#chart-3")
        expect(page).to have_css("#chart-4")
        expect(page).to have_css(".sidebar")
        expect(page).to have_selector(".rank_list li", text: reviewer.username)
        expect(page).to have_selector(".rank_list li", text: follow.username)
        expect(page).to have_selector(".rank_list li", text: gunpla.name)
        expect(page).to have_selector(".rank_list li", text: review.title)
      end
    end
  end
end
