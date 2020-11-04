# require 'rails_helper'

# # circleciでは安定しない
# RSpec.describe "Home", type: :system do
#   describe "HOMEページの表示テスト" do
#     let!(:article) { create(:article) }
#     let!(:review) { create(:review) }
#     let(:gunpla) { review.gunpla }

#     it "各要素が正常に表示されていることを検証する" do
#       visit root_path

#       expect(page).to have_content(article.title)
#       expect(page).to have_content(gunpla.name)
#       expect(page).to have_content(review.title)
#       expect(page).to have_css(".sidebar")
#     end
#   end
# end
