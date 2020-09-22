require 'rails_helper'

RSpec.describe "Users::Abouts", type: :request do
  subject { response }

  before { url }

  describe "#term" do
    let(:url) { get term_path }

    it { is_expected.to have_http_status(200) }
  end
end
