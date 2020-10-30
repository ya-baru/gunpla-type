require 'rails_helper'

RSpec.describe Like, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:review) }

  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :review_id }

  describe "ファクトリーテスト" do
    let!(:like) { create(:like) }

    it "ファクトリーが有効であること" do
      expect(like).to be_valid
    end
  end
end
