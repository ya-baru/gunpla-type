require 'rails_helper'

RSpec.describe "Contact", type: :system do
  describe "問い合わせフォームの機能テスト" do
    let(:contact) { create(:contact) }

    it "正常な情報を認識してメール送信する" do
      visit root_path
      click_on "お問い合わせ"
      aggregate_failures do
        expect(page).to have_title("お問い合わせ - GUNPLA-Type")
        expect(page).to have_selector("li", text: "ホーム")
        expect(page).to have_selector("li", text: "お問い合わせ")
      end

      # 失敗
      click_on "送信する"
      aggregate_failures do
        expect(page).to have_content("お名前を入力してください")
        expect(page).to have_content("メールアドレスを入力してください")
        expect(page).to have_content("ご用件を入力してください")
      end

      # 成功 確認画面へ移動
      fill_in "お名前", with: contact.name
      fill_in "メールアドレス", with: contact.email
      fill_in "ご用件", with: contact.message
      aggregate_failures do
        expect { click_on "送信する" }.not_to change { ActionMailer::Base.deliveries.count }
        expect(page).to have_title "送信確認 - GUNPLA-Type"
        expect(page).to have_selector("li", text: "ホーム")
        expect(page).to have_selector("li", text: "お問い合わせ")
        expect(page).to have_selector("li", text: "送信確認")
        expect(current_path).to eq contact_confirm_path
        expect(all('tbody tr')[0]).to have_content contact.name
        expect(all('tbody tr')[1]).to have_content contact.email
        expect(all('tbody tr')[2]).to have_content contact.message
      end

      # 一度『戻る』ボタンで入力画面へ戻る
      click_on "戻る"
      aggregate_failures do
        expect(page).to have_field "お名前", with: contact.name
        expect(page).to have_field "メールアドレス", with: contact.email
        expect(page).to have_field "ご用件", with: contact.message
      end

      # 『確定』ボタンをクリックでメールが送信される
      click_on "送信する"
      aggregate_failures do
        expect { click_on "確定" }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(current_path).to eq root_path
        expect(page).to have_selector(".alert-success", text: "お問い合わせを受け付けました")
      end
    end
  end
end
