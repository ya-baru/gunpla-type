require 'rails_helper'

RSpec.describe Like, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:review) }

  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :review_id }

  it "ファクトリーが有効であること" do
    expect(create(:like)).to be_valid
  end
end
