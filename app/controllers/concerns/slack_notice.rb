module SlackNotice
  extend ActiveSupport::Concern
  included do
    def notice_slack(message)
      notifier = Slack::Notifier.new(Rails.application.credentials.slack[:secret_url])
      notifier.ping(message)
    end
  end
end
