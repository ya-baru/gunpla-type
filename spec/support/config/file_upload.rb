RSpec.configure do |config|
  # テストアップロード後ファイルを削除
  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/test_uploads/"])
  end
end
