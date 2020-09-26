require "rails_helper"

RSpec.describe Users::Mailer, type: :mailer do
  let(:user) { build(:user, email: "user@example.com") }

  before do
    @from = Rails.application.credentials.gmail[:address]
    @token = "confirm_token"
  end

  describe "confirmation_instructions" do
    let(:mail) { Users::Mailer.confirmation_instructions(user, @token) }

    it "メールの送信チェック" do
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "メールの内容チェック" do
      expect(mail.subject).to eq I18n.t('devise.mailer.confirmation_instructions.subject')
      expect(mail.from.first).to eq @from
      expect(mail.to.first).to eq user.email

      expect(mail.body).to match user.username
      expect(mail.body).to match @token
    end
  end

  describe "reset_password_instructions" do
    let(:mail) { Users::Mailer.reset_password_instructions(user, @token) }

    it "メールの送信チェック" do
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "メールの内容チェック" do
      expect(mail.subject).to eq I18n.t('devise.mailer.reset_password_instructions.subject')
      expect(mail.from.first).to eq @from
      expect(mail.to.first).to eq user.email

      expect(mail.body).to match user.username
      expect(mail.body).to match @token
    end
  end

  describe "unlock_instructions" do
    let(:mail) { Users::Mailer.unlock_instructions(user, @token) }

    it "メールの送信チェック" do
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "メールの内容チェック" do
      expect(mail.subject).to eq I18n.t('devise.mailer.unlock_instructions.subject')
      expect(mail.from.first).to eq @from
      expect(mail.to.first).to eq user.email

      expect(mail.body).to match user.username
      expect(mail.body).to match @token
    end
  end
end
