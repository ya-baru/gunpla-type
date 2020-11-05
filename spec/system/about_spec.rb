require 'rails_helper'

RSpec.describe "About", type: :system do
  subject { page }

  describe "About各ページのタイトルチェック" do
    context "company" do
      before { visit company_path }

      it { is_expected.to have_title("運営情報 - GUNPLA-Type") }
      it { is_expected.to have_selector("li", text: "ホーム") }
      it { is_expected.to have_selector("li", text: "運営情報") }
    end

    context "privacy" do
      before { visit privacy_path }

      it { is_expected.to have_title("プライバシーポリシー - GUNPLA-Type") }
      it { is_expected.to have_selector("li", text: "ホーム") }
      it { is_expected.to have_selector("li", text: "プライバシーポリシー") }
    end

    context "term" do
      before { visit term_path }

      it { is_expected.to have_title("利用規約 - GUNPLA-Type") }
      it { is_expected.to have_selector("li", text: "ホーム") }
      it { is_expected.to have_selector("li", text: "利用規約") }
    end

    context "questions" do
      before { visit questions_path }

      it { is_expected.to have_title("よくある質問 - GUNPLA-Type") }
      it { is_expected.to have_selector("li", text: "ホーム") }
      it { is_expected.to have_selector("li", text: "よくある質問") }

      describe "リンクチェック" do
        it { is_expected.to have_link "こちら", href: "/account_confirmation/" }
        it { is_expected.to have_link "こちら", href: "/account_unlock/" }
        it { is_expected.to have_link "こちら", href: "/password/" }
      end
    end
  end
end
