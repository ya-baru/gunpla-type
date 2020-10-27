require 'rails_helper'

RSpec.describe Gunpla, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_length_of(:name).is_at_most(50) }
  it { is_expected.to validate_presence_of :sales_id }
  it { is_expected.to have_many(:browsing_histories).dependent(:destroy) }
  it { is_expected.to have_many(:reviews).dependent(:destroy) }
  it { is_expected.to have_many(:notifications).dependent(:destroy) }

  it "ファクトリーが有効であること" do
    expect(build(:gunpla)).to be_valid
  end
end
