require "rails_helper"

RSpec.describe Users::ContactMailer, type: :mailer do
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
    @contact = create(:contact)
  end

  describe "confirmation_instructions" do
    let(:mail) do
      Users::ContactMailer.contact_mail(@contact)
    end

    it "メールの送信チェック" do
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "メールの内容チェック" do
      expect(mail.subject).to eq "GUMPLA_Type お問い合わせありがとうございます"
      expect(mail.from.first).to eq @from
      expect(mail.to.first).to eq @contact.email

      expect(html_body).to match @contact.name
      expect(html_body).to match @contact.email
      expect(html_body).to match @contact.message
      expect(html_body).to match @from

      expect(text_body).to match @contact.name
      expect(text_body).to match @contact.email
      expect(text_body).to match @contact.message
      expect(text_body).to match @from
    end
  end
end
