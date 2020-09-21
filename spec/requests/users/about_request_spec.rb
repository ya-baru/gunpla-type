require 'rails_helper'

RSpec.describe "Users::Abouts", type: :request do
  subject { response }

  describe "#term" do
    before { get term_path }

    it { is_expected.to have_http_status(200) }
  end
end
