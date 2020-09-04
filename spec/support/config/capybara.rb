RSpec.configure do |config|
  # 通常時に使用するドライバー
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  # JS時に使用するドライバー
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end
Capybara.default_max_wait_time = 10
