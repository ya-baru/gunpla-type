module StringNormalizable
  extend ActiveSupport::Concern

  included do
    before_validation :normalize_changed_attributes
  end

  private

  def normalize_changed_attributes
    changed_attributes.each do |key, _|
      if self[key].is_a?(String) && self[key].present?
        self[key] = normalize(self[key])
      end
    end
  end

  def normalize(str)
    str.strip.
      tr("０-９ａ-ｚＡ-Ｚ 　（）－−", "0-9a-zA-Z  ()-").
      gsub("\t", ' ').gsub(/ +/, " ").
      upcase
  end
end
