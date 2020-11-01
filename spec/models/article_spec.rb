require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:article) { create(:article) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_length_of(:title).is_at_most(50) }
  it { is_expected.to validate_presence_of :content }

  describe "ファクトリーテスト" do
    let!(:article) { create(:article) }

    it "ファクトリーが有効であること" do
      expect(article).to be_valid
    end
  end

  describe "contentの字数バリデーション" do
    context "1000字" do
      it "無効" do
        article.content = "a" * 1000
        expect(article).not_to be_valid
      end
    end
  end

  describe "画像のバリデーションチェック" do
    subject { article.valid? }

    let!(:image) do
      article.image = fixture_file_upload(Rails.root.join("spec", "files", image_file))
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
          article.valid?
          expect(article.errors.full_messages).to match_array("画像のファイルは3MB以内にしてください")
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
        def expect_error_message
          expect(article.errors.full_messages).to match_array("画像は『jpeg, jpg, png』形式でアップロードしてください")
        end

        context "gif" do
          let(:image_file) { "sample.gif" }

          it { is_expected.to be_falsey }
          it "メッセージチェック" do
            article.valid?
            expect_error_message
          end
        end

        context "bmp" do
          let(:image_file) { "sample.bmp" }

          it { is_expected.to be_falsey }
          it "メッセージチェック" do
            article.valid?
            expect_error_message
          end
        end

        context "svg" do
          let(:image_file) { "sample.svg" }

          it { is_expected.to be_falsey }
          it "メッセージチェック" do
            article.valid?
            expect_error_message
          end
        end

        context "tiff" do
          let(:image_file) { "sample.tiff" }

          it { is_expected.to be_falsey }
          it "メッセージチェック" do
            article.valid?
            expect_error_message
          end
        end
      end
    end
  end
end
