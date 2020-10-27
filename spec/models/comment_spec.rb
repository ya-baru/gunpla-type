require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:review) }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :review_id }
  it { is_expected.to validate_presence_of :content }
  it { is_expected.to validate_length_of(:content).is_at_most(255) }
  it { is_expected.to have_many(:notifications).dependent(:destroy) }

  describe "ファクトリーテスト" do
    let!(:comment) { create(:comment) }

    it "ファクトリーが有効であること" do
      expect(comment).to be_valid
    end
  end
end
