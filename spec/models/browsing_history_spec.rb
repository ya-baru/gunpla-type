require 'rails_helper'

RSpec.describe BrowsingHistory, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:gunpla) }

  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :gunpla_id }
end
