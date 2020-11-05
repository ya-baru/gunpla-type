require 'rails_helper'

RSpec.describe "Users::Homes", type: :request do
  describe "#index" do
    subject { response }

    before { get root_path }

    it { is_expected.to have_http_status 200 }
  end
end
