require "rails_helper"

RSpec.describe Users::Mailer, type: :mailer do
  let(:user) { build(:user, email: "user@example.com") }
  let(:text_body) do
    part = mail.body.parts.detect { |p| p.content_type == "text/plain; charset=UTF-8" }
    part.body.raw_source
  end
  let(:html_body) do
    part = mail.body.parts.detect { |p| p.content_type == "text/html; charset=UTF-8" }
    part.body.raw_source
  end

  before do
    @from = Rails.application.credentials.gmail[:address]
    @token = "confirm_token"
  end

  describe "confirmation_instructions" do
    let(:mail) { Users::Mailer.confirmation_instructions(user, @token) }

    it "メールの送信チェック" do
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "メールの内容チェック", :focus do
      expect(mail.subject).to eq I18n.t('devise.mailer.confirmation_instructions.subject')
      expect(mail.from.first).to eq @from
      expect(mail.to.first).to eq user.email

      expect(html_body).to match user.username
      expect(html_body).to match @token

      expect(text_body).to match user.username
      expect(text_body).to match @token
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

      expect(html_body).to match user.username
      expect(html_body).to match @token

      expect(text_body).to match user.username
      expect(text_body).to match @token
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

      expect(html_body).to match user.username
      expect(html_body).to match @token

      expect(text_body).to match user.username
      expect(text_body).to match @token
    end
  end
end
