require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { create(:contact) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_length_of(:name).is_at_most(20) }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_length_of(:email).is_at_most(255) }
  it { is_expected.to validate_presence_of :message }
  it { is_expected.to validate_length_of(:message).is_at_most(1000) }

  it "ファクトリーが有効であること" do
    expect(build(:contact)).to be_valid
  end

  describe "メールアドレスのフォーマットチェック" do
    context "正常な値" do
      valid_addresses = %w(
        user@example.com
        User@Foo.Com
        a_uS-eR@foo.bor.org
        first.last@foo.jp
        u+ser@example.com
      )

      it "有効であること" do
        valid_addresses.each do |valid_address|
          contact.email = valid_address
          expect(contact).to be_valid
        end
      end
    end

    context "不正な値" do
      invalid_addresses = %w(
        user@example,com
        user_at_foo.org
        user.name@example.
        foo@bar_baz.com
        foo@bar+baz.com
        foo@bar..com
      )
      it "無効であること" do
        invalid_addresses.each do |invalid_address|
          contact.email = invalid_address
          expect(contact).not_to be_valid
        end
      end
    end
  end
end
