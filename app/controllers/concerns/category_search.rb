module CategorySearch
  extend ActiveSupport::Concern
  included do
    def category_listup(category)
      return find_gunpla(category.indirect_ids) unless category.ancestry?

      return @gunplas = Gunpla.where(category_id: params[:id]) if category.ancestry.include?("/")

      find_gunpla(category.child_ids)
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
