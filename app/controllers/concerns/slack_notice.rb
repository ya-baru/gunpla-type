module SlackNotice
  extend ActiveSupport::Concern
  included do
    def notice_slack(message)
      notifier = Slack::Notifier.new(Rails.application.credentials.slack[:secret_url])
      notifier.ping(message)
    end

    def contacts_slack
      message = "新しい問い合わせがあります。#{Rails.application.credentials.gmail[:link]}"
      notice_slack(message)
    end
  end
end
