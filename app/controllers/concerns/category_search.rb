module CategorySearch
  extend ActiveSupport::Concern
  included do
    def category_listup(category)
      if category.ancestry?
        indirect_category_ids = category.indirect_ids
        find_gunpla(indirect_category_ids)
      elsif category.ancestry.include?("/")
        @gunplas = Gunpla.where(category_id: params[:id])
      else
        child_category_ids = category.child_ids
        find_gunpla(child_category_ids)
      end
    end

    protected

    def find_gunpla(category_ids)
      @gunplas = []
      category_ids.each do |id|
        gunpla_arry = Gunpla.where(category_id: id).reject(&:blank?)
        gunpla_arry.each do |gunpla|
          @gunplas.push(gunpla) if gunpla.present?
        end
      end
    end
  end
end
