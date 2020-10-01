class Users::ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_mail.subject
  #
  def contact_mail(contact)
    @contact = contact

    mail to: contact.email, subject: "GUMPLA_Type お問い合わせありがとうございます"
  end
end
