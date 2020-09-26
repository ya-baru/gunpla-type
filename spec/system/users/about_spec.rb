require 'rails_helper'

RSpec.describe "Users::Abouts", type: :system do
  subject { page }

  describe "About各ページのタイトルチェック" do
    context "company" do
      before { visit company_path }

      it { is_expected.to have_title("運営情報 - GUNPLA-Type") }
    end

    context "privacy" do
      before { visit privacy_path }

      it { is_expected.to have_title("プライバシーポリシー - GUNPLA-Type") }
    end

    context "term" do
      before { visit term_path }

      it { is_expected.to have_title("利用規約 - GUNPLA-Type") }
    end

    context "questions" do
      before { visit questions_path }

      it { is_expected.to have_title("よくある質問 - GUNPLA-Type") }
    end
  end

  describe "よくある質問ページ内におけるハイパーリンクチェック" do
    before { visit questions_path }

    context "アカウント有効化の案内" do
      it { is_expected.to have_link "こちら", href: "/account_confirmation/" }
    end

    context "アカウント凍結解除方法" do
      it { is_expected.to have_link "こちら", href: "/account_unlock/" }
    end

    context "パスワード再設定の方法" do
      it { is_expected.to have_link "こちら", href: "/password/" }
    end
  end
end
