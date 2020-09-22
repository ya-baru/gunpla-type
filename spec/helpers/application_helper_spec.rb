require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include ApplicationHelper

  describe "full_title" do
    subject { full_title(sub_title: title) }

    context "サブタイトル名あり" do
      let(:title) { "App" }

      it { is_expected.to eq "#{title} - GUNPLA-Type" }
    end

    context "サブタイトル名なし" do
      let(:title) { nil }

      it { is_expected.to eq "GUNPLA-Type" }
    end
  end
end
