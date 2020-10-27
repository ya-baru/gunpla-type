require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { is_expected.to belong_to(:visitor).class_name("User") }
  it { is_expected.to belong_to(:visited).class_name("User") }
  it { is_expected.to belong_to(:gunpla).optional(true) }
  it { is_expected.to belong_to(:review).optional(true) }
  it { is_expected.to belong_to(:comment).optional(true) }
  it { is_expected.to validate_presence_of :visitor_id }
  it { is_expected.to validate_presence_of :visited_id }
  it { is_expected.to validate_presence_of :action }

  describe "ファクトリーテスト" do
    let!(:notification) { create(:notification) }

    it "ファクトリーが有効であること" do
      expect(notification).to be_valid
    end
  end
end
