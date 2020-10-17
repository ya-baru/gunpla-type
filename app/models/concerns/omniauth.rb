module Omniauth
  extend ActiveSupport::Concern
  included do
    class << self
      def find_for_oauth(auth)
        user = User.where(uid: auth.uid, provider: auth.provider).first
        user ||= User.new( # rubocop:disable Lint/UselessAssignment
          uid: auth.uid,
          provider: auth.provider,
          username: auth.info.name,
          email: User.dummy_email(auth),
          password: Devise.friendly_token[0, 20]
        )
      end

      protected

      def dummy_email(auth)
        "#{auth.uid}-#{auth.provider}@example.com"
      end
    end
  end
end
