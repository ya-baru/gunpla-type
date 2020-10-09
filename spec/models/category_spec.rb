require 'rails_helper'

RSpec.describe Category, type: :model do
  it { is_expected.to validate_presence_of :name }

  it "ファクトリーが有効であること" do
    expect(build(:category)).to be_valid
    expect(build(:child_category)).to be_valid
    expect(build(:grandchild_category)).to be_valid
  end
end
