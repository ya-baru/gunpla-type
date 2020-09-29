require 'rails_helper'

RSpec.describe "Users::About", type: :request do
  subject { response }

  describe "#company" do
    before { get company_path }

    it { is_expected.to have_http_status 200 }
  end

  describe "#privacy" do
    before { get privacy_path }

    it { is_expected.to have_http_status 200 }
  end

  describe "#term" do
    before { get term_path }

    it { is_expected.to have_http_status 200 }
  end

  describe "#questions" do
    before { get questions_path }

    it { is_expected.to have_http_status 200 }
  end
end
