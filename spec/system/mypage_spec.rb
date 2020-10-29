require 'rails_helper'

RSpec.describe "Mypage", :js, type: :system do
  let(:user) { create(:user, :with_profile, :with_avatar) }

  def expect_page_information(sub_title: nil, breadcrumb: nil)
    expect(page).to have_title("#{sub_title} - GUNPLA-Type")
    expect(page).to have_selector("li.breadcrumb-item", text: "ホーム")
    expect(page).to have_selector("li.breadcrumb-item", text: breadcrumb)
  end

  describe "マイページへのアクセスチェック" do
    let(:reviews) { user.reviews }

    context "ログインユーザー" do
      context "レビューなし" do
        it "要素の表示チェックをする" do
          sign_in user
          visit mypage_path(user)

          aggregate_failures do
            expect_page_information(sub_title: "マイページ", breadcrumb: "マイページ")

            within ".user_status" do
              expect(page).to have_selector("img[src$='sample.jpg']")
              expect(page).to have_selector("h4", text: user.username)
              expect(page).to have_selector("p", text: user.reviews_count)
              expect(page).to have_selector("a", text: user.favorites_count)
            end

            within ".user_btn" do
              expect(page).to have_selector("a", text: "アクティビティー")
              expect(page).to have_selector("a", text: "プロフィール編集")
              expect(page).not_to have_css("#follow-#{user.id}")
            end

            expect(page).to have_selector(".user_profile p", text: user.profile)
            expect(page).to have_selector(".text-center.text-md-left.mb-3", text: "ガンプラをレビューする")

            within ".user_stats" do
              expect(page).to have_selector("a", text: user.likes_count)
              expect(page).to have_selector("a", text: user.following.count)
              expect(page).to have_selector("a", text: user.followers.count)
            end

            within ".menu_list" do
              expect(page).to have_link "マイページ"
              expect(page).to have_link "プロフィール編集"
              expect(page).to have_link "退会の手続き"
              expect(page).to have_link "ガンプラをレビューする"
              expect(page).to have_link "アクティビティー"
              expect(page).to have_link "お知らせ"
            end

            within ".menu_status" do
              expect(page).to have_selector("h2.headingLv", text: "レビューリスト（#{reviews.count}）")
              expect(page).to have_content("ガンプラのレビューはありません")
            end
          end
        end
      end

      context "レビューあり" do
        let!(:review) { create(:review) }
        let(:user) { User.first }

        it "要素の表示チェックをする" do
          sign_in user
          visit mypage_path(user)

          aggregate_failures do
            within ".menu_status" do
              expect(page).to have_selector("li", text: review.content)
              expect(page).to have_css("li#rate-#{review.id}")
              expect(page).to have_selector("li", text: review.created_at.to_s(:datetime_jp))
            end
          end
        end
      end
    end

    context "他ユーザー" do
      let(:other_user) { create(:user) }

      it "要素の表示チェックをする" do
        sign_in other_user
        visit mypage_path(user)

        within ".user_btn" do
          expect(page).not_to have_selector("a", text: "アクティビティー")
          expect(page).not_to have_selector("a", text: "プロフィール編集")
          expect(page).to have_css("#follow-#{user.id}")
        end

        expect(page).not_to have_selector(".text-center.text-md-left.mb-3", text: "ガンプラをレビューする")

        expect(page).not_to have_css(".menu_list")
      end
    end

    context "未ログインユーザー" do
      it "要素の表示チェックをする" do
        visit mypage_path(user)

        expect(page).not_to have_selector(".user_btn a", text: "アクティビティー")
        expect(page).not_to have_selector(".user_btn a", text: "プロフィール編集")
        expect(page).not_to have_css(".user_btn #follow-#{user.id}")
        expect(page).not_to have_selector(".text-center.text-md-left.mb-3", text: "ガンプラをレビューする")
        expect(page).not_to have_css(".menu_list")
      end
    end
  end

  describe "いいね！レビューリストのアクセスチェック" do
    let(:reviews) { user.reviews }

    context "いいねなし" do
      it "要素の表示チェックをする" do
        sign_in user
        visit like_reviews_mypage_path(user)

        aggregate_failures do
          expect_page_information(sub_title: "いいね！レビューリスト", breadcrumb: "いいね！レビューリスト")

          within ".menu_status" do
            expect(page).to have_selector("h2.headingLv", text: "レビューリスト（#{reviews.count}）")
            expect(page).to have_content("いいね！したレビューはありません")
          end
        end
      end
    end

    context "いいねあり" do
      let!(:like) { create(:like) }
      let(:user) { User.first }
      let(:review) { Review.first }

      it "要素の表示チェックをする" do
        sign_in user
        visit like_reviews_mypage_path(user)

        aggregate_failures do
          within ".menu_status" do
            expect(page).to have_selector("li", text: review.content)
            expect(page).to have_css("li#rate-#{review.id}")
            expect(page).to have_selector("li", text: review.created_at.to_s(:datetime_jp))
          end
        end
      end
    end
  end

  # # 個別テストのみ成功
  # describe "お気に入りガンプラリストのアクセスチェック", :focus do
  #   let(:gunplas) { user.favorite_gunplas }

  #   context "お気に入り登録なし" do
  #     it "要素の表示チェックをする" do
  #       sign_in user
  #       visit favorite_gunplas_mypage_path(user)

  #       aggregate_failures do
  #         expect_page_information(sub_title: "お気に入りガンプラリスト", breadcrumb: "お気に入りガンプラリスト")

  #         within ".menu_status" do
  #           expect(page).to have_selector("h2.headingLv", text: "お気に入りガンプラリスト（#{gunplas.count}）")
  #           expect(page).to have_content("お気に入り登録したガンプラはありません")
  #         end
  #       end
  #     end
  #   end

  #   context "お気に入り登録あり" do
  #     let!(:favorite) { create(:favorite) }
  #     let(:user) { User.first }
  #     let(:gunpla) { Gunpla.first }
  #     let(:category) { gunpla.category }

  #     it "要素の表示チェックをする" do
  #       sign_in user
  #       visit favorite_gunplas_mypage_path(user)

  #       aggregate_failures do
  #         within ".menu_status" do
  #           expect(page).to have_selector("p", text: gunpla.name)
  #           expect(page).to have_selector("li", text: "#{category.parent.name} #{category.name}")
  #           expect(page).to have_css("li#rate-#{gunpla.id}")
  #         end
  #       end
  #     end
  #   end
  # end

  describe "フォローリストのアクセスチェック" do
    let(:following) { user.following }

    context "フォローなし" do
      it "要素の表示チェックをする" do
        sign_in user
        visit following_mypage_path(user)

        aggregate_failures do
          expect_page_information(sub_title: "フォローリスト", breadcrumb: "フォローリスト")

          within ".menu_status" do
            expect(page).to have_selector("h2.headingLv", text: "フォローリスト（#{following.count}）")
            expect(page).to have_content("フォローはありません")
          end
        end
      end
    end

    context "フォローあり" do
      let(:relationship) { create(:relationship) }
      let(:follower) { relationship.follower }
      let(:followed) { relationship.followed }

      it "要素の表示チェックをする" do
        sign_in follower
        visit following_mypage_path(follower)

        aggregate_failures do
          within ".menu_status" do
            expect(page).to have_selector("li", text: followed.username)
          end
        end
      end
    end
  end

  describe "フォロワーリストのアクセスチェック" do
    let(:followers) { user.followers }

    context "フォロワーなし" do
      it "要素の表示チェックをする" do
        sign_in user
        visit followers_mypage_path(user)

        aggregate_failures do
          expect_page_information(sub_title: "フォロワーリスト", breadcrumb: "フォロワーリスト")

          within ".menu_status" do
            expect(page).to have_selector("h2.headingLv", text: "フォロワーリスト（#{followers.count}）")
            expect(page).to have_content("フォロワーはありません")
          end
        end
      end
    end

    context "フォロワーあり" do
      let(:relationship) { create(:relationship) }
      let(:follower) { relationship.follower }
      let(:followed) { relationship.followed }

      it "要素の表示チェックをする" do
        sign_in followed
        visit followers_mypage_path(followed)

        aggregate_failures do
          within ".menu_status" do
            expect(page).to have_selector("li", text: follower.username)
          end
        end
      end
    end
  end
end
