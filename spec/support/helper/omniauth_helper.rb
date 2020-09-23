module OmniAuthHelper
  def set_omniauth(service: nil)
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new({
      provider: service.to_s,
      uid: "12345678",
      info: {
        name: "user",
      },
    })
  end
end
