require 'rails_helper'

RSpec.describe Relationship, type: :model do
  it { is_expected.to belong_to(:follower) }
  it { is_expected.to belong_to(:followed) }

  it { is_expected.to validate_presence_of :follower_id }
  it { is_expected.to validate_presence_of :followed_id }

  describe "ファクトリーテスト" do
    let!(:relationship) { create(:relationship) }

    it "ファクトリーが有効であること" do
      expect(relationship).to be_valid
    end
  end
end
