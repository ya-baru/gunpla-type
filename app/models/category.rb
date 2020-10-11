class Category < ApplicationRecord
  has_ancestry
  has_many :gunplas

  validates :name, presence: true

  def category_listup
    if self.ancestry.nil?
      indirect_category_ids = self.indirect_ids
      find_gunpla(indirect_category_ids)
    elsif self.ancestry.include?("/")
      @gunplas = Gunpla.where(category_id: params[:id])
    else
      child_category_ids = self.child_ids
      find_gunpla(child_category_ids)
    end
  end
end
