require 'rails_helper'

RSpec.describe Review, type: :model do
  let!(:user) { create(:user) }
  let!(:gunpla) { create(:gunpla) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:gunpla) }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_length_of(:title).is_at_most(30) }
  it { is_expected.to validate_presence_of :content }
  it { is_expected.to validate_length_of(:content).is_at_most(1000) }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :gunpla_id }
  it { is_expected.to have_many(:likes).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:notifications).dependent(:destroy) }

  describe "ファクトリーテスト" do
    let!(:review) { create(:review) }

    it "ファクトリーが有効であること" do
      expect(review).to be_valid
    end
  end

  describe "画像テスト" do
    before do
      @review = user.reviews.build(
        title: "おすすめ！",
        content: "組み立てやすい！",
        gunpla_id: gunpla.id,
        rate: 5
      )
      image_attach
    end

    def image_attach
      @review.images.attach(
        io: File.open(Rails.root.join('spec', 'files', image_file)),
        filename: image_file
      )
    end

    describe "画像のバリデーションチェック" do
      subject { @review.valid? }

      describe "ファイルサイズのチェック" do
        context "3MB未満のケース" do
          let(:image_file) { "sample_2MB.jpg" }

          it { is_expected.to be_truthy }
        end

        context "3MB以上のケース" do
          let(:image_file) { "sample_3MB.jpg" }

          it { is_expected.to be_falsey }
          it "メッセージチェック" do
            @review.valid?
            expect(@review.errors.full_messages).to match_array("画像は1つのファイル3MB以内にしてください")
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
            expect(@review.errors.full_messages).to match_array("画像は『jpeg, jpg, png』形式でアップロードしてください")
          end

          context "gif" do
            let(:image_file) { "sample.gif" }

            it { is_expected.to be_falsey }
            it "メッセージチェック" do
              @review.valid?
              expect_error_message
            end
          end

          context "bmp" do
            let(:image_file) { "sample.bmp" }

            it { is_expected.to be_falsey }
            it "メッセージチェック" do
              @review.valid?
              expect_error_message
            end
          end

          context "svg" do
            let(:image_file) { "sample.svg" }

            it { is_expected.to be_falsey }
            it "メッセージチェック" do
              @review.valid?
              expect_error_message
            end
          end

          context "tiff" do
            let(:image_file) { "sample.tiff" }

            it { is_expected.to be_falsey }
            it "メッセージチェック" do
              @review.valid?
              expect_error_message
            end
          end
        end
      end

      describe "画像枚数のチェック" do
        let(:image_file) { "sample.jpg" }

        before do
          image_attach
          image_attach
          image_attach
        end

        it { is_expected.to be_falsey }
        it "メッセージチェック" do
          @review.valid?
          expect(@review.errors.full_messages).to match_array("画像は3枚以内にしてください")
        end
      end
    end
  end
end
