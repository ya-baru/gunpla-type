require 'rails_helper'

RSpec.describe "Users::Homes", :focus, type: :request do
  describe "#index" do
    subject { response }

    before { get root_url }

    it { is_expected.to have_http_status 200 }
  end
end
