require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_length_of(:username).is_at_most(20) }
  it { is_expected.to validate_length_of(:profile).is_at_most(255) }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_length_of(:email).is_at_most(255) }
  it { is_expected.to validate_confirmation_of(:email).on(:change_email) }
  it { is_expected.to validate_presence_of(:email_confirmation).on(:change_email) }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }
  it { is_expected.to validate_length_of(:password).is_at_most(20) }

  it "ファクトリーが有効であること" do
    expect(user).to be_valid
  end

  describe "メールアドレスの一意性のチェック" do
    it "重複したアドレスなら無効であること" do
      create(:user, email: "user@example.com")
      other_user = build(:user, email: "user@example.com")
      expect(other_user).not_to be_valid
    end
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
          user.email = valid_address
          expect(user).to be_valid
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
          user.email = invalid_address
          expect(user).not_to be_valid
        end
      end
    end
  end

  describe "パスワードのフォーマットチェック" do
    context "正常な値" do
      it "有効であること" do
        user.password = "P_ass-Word1"
        user.password_confirmation = "P_ass-Word1"
        expect(user).to be_valid
      end
    end

    context "不正な値" do
      invalid_passwords = %w(
        不正なパスワード
        pa@ssword
        pass.word
        pass+word
        pass=word
        pass:word
        pass@word
      )
      it "無効であること" do
        invalid_passwords.each do |invalid_password|
          user.password = invalid_password
          user.password_confirmation = invalid_password
          expect(user).not_to be_valid
        end
      end
    end
  end

  describe "アバターのバリデーションチェック" do
    subject { user.valid? }

    let!(:avatar) do
      user.avatar = fixture_file_upload(Rails.root.join("spec", "files", image_file))
    end

    describe "ファイルサイズのチェック" do
      context "3MB未満のケース" do
        let(:image_file) { "sample_2MB.jpg" }

        it { is_expected.to be_truthy }
      end

      context "3MB以上のケース" do
        let(:image_file) { "sample_3MB.jpg" }

        it { is_expected.to be_falsey }
        it "メッセージチェック" do
          user.valid?
          expect(user.errors.full_messages).to match_array("アバターのファイルサイズは3MBまでです。")
        end
      end
    end

    describe "ファイル拡張子のチェック" do
      context "有効な拡張子" do
        context "jpg" do
          let(:image_file) { "sample.jpg" }

          it { is_expected.to be_truthy }
        end

        context "jpeg" do
          let(:image_file) { "sample.jpeg" }

          it { is_expected.to be_truthy }
        end

        context "png" do
          let(:image_file) { "sample.png" }

          it { is_expected.to be_truthy }
        end
      end

      context "無効な拡張子" do
        context "gif" do
          let(:image_file) { "sample.gif" }

          it { is_expected.to be_falsey }
          it "メッセージチェック" do
            user.valid?
            expect(user.errors.full_messages).to match_array("アバターのファイル形式が有効ではありません。")
          end
        end

        context "bmp" do
          let(:image_file) { "sample.bmp" }

          it { is_expected.to be_falsey }
          it "メッセージチェック" do
            user.valid?
            expect(user.errors.full_messages).to match_array("アバターのファイル形式が有効ではありません。")
          end
        end

        context "svg" do
          let(:image_file) { "sample.svg" }

          it { is_expected.to be_falsey }
          it "メッセージチェック" do
            user.valid?
            expect(user.errors.full_messages).to match_array("アバターのファイル形式が有効ではありません。")
          end
        end

        context "tiff" do
          let(:image_file) { "sample.tiff" }

          it { is_expected.to be_falsey }
          it "メッセージチェック" do
            user.valid?
            expect(user.errors.full_messages).to match_array("アバターのファイル形式が有効ではありません。")
          end
        end
      end
    end
  end
end
