class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.gmail[:address]
  layout 'mailer'
end
